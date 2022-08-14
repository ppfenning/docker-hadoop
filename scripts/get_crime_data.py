import os

import pandas as pd
from kaggle.api.kaggle_api_extended import KaggleApi


if __name__ == '__main__':
    print("Auth Kaggle API...")
    api = KaggleApi()
    api.authenticate()
    print("Success!...")
    fold = 'examples/data'
    # download and unzip
    print("Downloading csvs...")
    api.dataset_download_files('currie32/crimes-in-chicago', path=fold, unzip=True, force=True)
    fold_lst = os.listdir(fold)
    print("Downloaded files:",  fold_lst)
    df_lst = []
    for fname in fold_lst:
        file = os.path.join(fold, fname)
        print(f'Loading {file}')
        # file to df
        df = pd.read_csv(
            file,
            delimiter=',',
            on_bad_lines='skip',
            low_memory=False
        )
        # remove tows with NA year
        df = df[df['Year'].notna()]
        print(df.head())
        # add to collection
        df_lst.append(df)
        # remove cleaned file
        os.remove(file)
    # concat to single file
    print("Combine csv...")
    df_combo = pd.concat(df_lst, ignore_index=True)
    # update col names
    print("Add 'num' colname...")
    cols = df_combo.columns.tolist()
    cols[0] = 'num'
    df_combo.columns = cols
    print("Dropping 'Location' column as it can be made from 'Latitude' and 'Longitude'...")
    df_combo.drop(['Location'], axis=1, inplace=True)
    # describe data
    print(df_combo.describe(include='all'))
    df_combo.to_csv(os.path.join(fold, 'Chicago_Crimes.csv'), index=False)
