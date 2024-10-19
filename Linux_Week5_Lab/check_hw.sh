#!/bin/bash

# student id,compressed hw file path
student_id_file="student_id"
compressed_files_dir="compressed_files"

# path of missing and wrong list
missing_list="missing_list"
wrong_list="wrong_list"

# Step1: calssification student hw by there submit
echo "Step1: calssification student hw by there submit"

# clear and create file of missing and wrong list
> "$missing_list"
> "$wrong_list"

# loop checking id in student_id
while read -r id; do
	# check is the student's file found or wrong?
	is_found=false
	is_wrong=false

	# check 3 type of file
	for ext in zip tar.gz rar;do
		if [ -f "$compressed_files_dir/${id}.${ext}" ]; then
			is_found=true
			break
		fi
	done

	# check is file name wrong or missing
	if [ "$is_found" = false ]; then
		file_path=$(find "$compressed_files_dir" -name "${id}.*" -print -quit)

		if [ -n "$file_path" ]; then
			is_wrong=true
			echo "$id" >> wrong_list
			echo "$id - Wrong Format: $(basename "$file_path")"
		else
			echo "$id" >> missing_list
			echo "$id - Missing File"
		fi	
	fi
done < "$student_id_file"

echo ""

# Step2: classification file type and un compress them
echo "Step2: classification file type and un compress them"
echo "classification and uncompressing..."

# result path
rar_path="$compressed_files_dir/rar"
tar_gz_path="$compressed_files_dir/tar.gz"
zip_path="$compressed_files_dir/zip"
unknown_path="$compressed_files_dir/unknown"

# create diretory
mkdir -p "$rar_path" "$tar_gz_path" "$zip_path" "$unknown_path"

# check each file in compressed_files
for file in "$compressed_files_dir"/*; do
	if [ -f "$file" ]; then
		# according to file's ext do sth.
		case "$file" in
			*.rar)
				mv "$file" "$rar_path/"
				unrar x "$rar_path/$(basename $file)" "$rar_path/" > /dev/null 2>&1
				;;
			*.tar.gz)
				mv "$file" "$tar_gz_path/"
				tar -xzf "$tar_gz_path/$(basename $file)" -C "$tar_gz_path/"
				;;
			*.zip)
				mv "$file" "$zip_path"
				unzip -q "$zip_path/$(basename $file)" -d "$zip_path/" 
				;;
			*)
				mv "$file" "$unknown_path/"
				;;
		esac
	fi
done

echo "finish hw checking"
