#!/bin/bash

current_patch=`pwd`
rails="$current_patch/bin/rails"
rake="$current_patch/bin/rake"

`$rake db:migrate 2>&1`

cat > ./file_upload <<EOF
#!/bin/bash
cd '$current_patch'
rails s
EOF

chmod +x ./file_upload
