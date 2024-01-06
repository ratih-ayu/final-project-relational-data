CREATE TABLE user_info(
			 			user_id int PRIMARY KEY,
			 			nama_user varchar (50) NOT NULL,
			 			kontak varchar (13) NOT NULL,
			 			email varchar (50)NOT NULL),
						kota_id int NOT NUL,
						CONSTRAINT fK_kota_id
							   FOREIGN KEY (kota_id)
							   REFERENCES kota (kota_id));
CREATE TABLE product (
						product_id int PRIMARY KEY,
						brand varchar (50) NOT NULL,
						model varchar (100) NOT NULL,
						body_type varchar (50) NOT NULL,
						tahun int NOT NULL,
						harga int NOT NULL);
CREATE TABLE iklan (
					iklan_id int PRIMARY KEY,
					judul varchar (50) NOT NULL,
					product_id int NOT NULL,
					CONSTRAINT fK_product_id
							   FOREIGN KEY (product_id)
							   REFERENCES product(product_id),
					user_id int NOT NULL,
					CONSTRAINT fK_user_id
							   FOREIGN KEY (user_id)
							   REFERENCES user_info (user_id),
					tipe_bid varchar (50) NOT NULL,
					tanggal_posting timestamp);
CREATE TABLE bid( 
					bid_id int PRIMARY KEY,
					product_id int NOT NULL,
					CONSTRAINT fK_product_id
							   FOREIGN KEY (product_id)
							   REFERENCES product(product_id),
					user_id int NOT NULL,
					CONSTRAINT fK_user_id
							   FOREIGN KEY (user_id)
							   REFERENCES user_info (user_id),
					iklan_id int NOT NULL,
					CONSTRAINT fK_iklan_id
							   FOREIGN KEY (iklan_id)
							   REFERENCES iklan (iklan_id),
					harga_bid int NOT NULL,
					tanggal_bid timestamp,
					bid_status varchar (50));
CREATE TABLE kota(
				  kota_id int PRIMARY KEY,
				  nama_kota varchar (50) NOT NULL,
				  lokasi point);
