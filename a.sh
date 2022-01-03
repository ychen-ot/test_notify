
DEPLOY_SYS="main"
BUILD_ID="12345"


          if [ "${DEPLOY_SYS}" == "main" ]; then
            version=$(cat ./qadmin/app/version.txt | sed 's/ //g')
            if [ "${version}" != "" ]; then
              # Check if tag already exists.
              match_tag=$(git tag | grep "^${version}$")
              if [ "${match_tag}" != "" ]; then
                echo "Tag '${version}' exists.  Please manually create a new tag in main, and update version.txt to next version"

              # tag does not exist, so tag, and update version
              else

                echo "Tagging main branch with '${version}'"

                # Tag git
                # git config --global user.email "githubaction@openteams.com"
                # git config --global user.name "Github Action"
                git tag -a "${version}" -m "Deployed with build ${BUILD_ID}"
                git push --tags

                # switch branch
                # git checkout develop

                # Increment version, update version, and commit
                echo "Incrementing version..."
                last_digit=${version##*.}
                if [ "${last_digit}" != "" ]; then
                  new_ver=$(expr $last_digit + 1 )
                  ver_prefix=$(echo $version | sed 's/\.[^.]*$//')
                  new_full_ver="${ver_prefix}.${new_ver}"
                  echo "New version: $new_full_ver"
                  echo "$new_full_ver" > ./qadmin/app/version.txt

                  # git commit this change
                  git add .
                  git commit -m "Version updated - generated"
                  git push
                fi
              fi
            fi
          else
            echo "No tagging needed for develop and uat"
          fi
