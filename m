Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 374D04F391D
	for <kvmarm@lists.linux.dev>; Thu, 17 Sep 2026 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660213; cv=none; b=ULU7VLPihH9VfocJGJ8isszfaUfbYytwdntCLyQGEmA1Lqoe8fK9P+3o1P3ywHCbU7kPla9+NS7uZUFuuKvulOJoElXQcWxLPCSp8da4iXgyP8W2pc5iVOOuScetsywiaKMTGD9TujSRNnNvxcpxt2HWhN3VvOwid8KGQQ45uAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660213; c=relaxed/simple;
	bh=as4niUxszyJmJ0RZKoTrF4Gxoj4IjADF7PZ+s2K6oj4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4DR+YybQI+kdNC1SxR5Eorbpzznwbg3e4Mt9+FunwgtIs5lrU07CriLtOrlxtzU+kIhvJ2xGM+Rhi86TGoAyZe1h/fDGz3blWmIyEVIzzoiI6Bw0xnJ1DvcQWyVZLxmMbbcEk6uggwjrqSbVYgseDcTPOS0Xo6KNue+rI56ubI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ocm3yDXQ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ocm3yDXQ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3C891FC4;
	Thu, 17 Sep 2026 08:49:59 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 844F63F7B4;
	Thu, 17 Sep 2026 08:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789660203; bh=as4niUxszyJmJ0RZKoTrF4Gxoj4IjADF7PZ+s2K6oj4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ocm3yDXQVrM4HRkpVAoiPIDsqYtziWAtQ4dR7Wh6KGpi5cJApq+d0t3TYv0t74vL0
	 FmDWtXSzh2bqqPK73eSGXsHZsDJ2T1g8yRU8y8mrBS7cDd7lU4aqIsIRY7gC/kwHBg
	 JNI8vRq8ktiPwDQFm7XqkMJgjwVSjjsnMqvVSMtU=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	kvm@vger.kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [RFC PATCH kvmtool 6/7] Introduce kvm_create_thread()
Date: Thu, 17 Sep 2026 16:49:31 +0100
Message-ID: <20260917154932.193943-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917154932.193943-1-alexandru.elisei@arm.com>
References: <20260917154932.193943-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch over all pthread_create() invocations to kvm_create_thread(). Also
add error checking where it was missing.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 disk/aio.c               |  3 +--
 disk/blk.c               | 12 +++++++++--
 disk/core.c              | 29 +++++++++++++-------------
 disk/qcow.c              | 44 ++++++++++++++++++++++++++++------------
 disk/raw.c               | 21 +++++++++++++++----
 epoll.c                  |  2 +-
 include/kvm/disk-image.h | 28 +++++++++++++++++--------
 include/kvm/qcow.h       |  3 ++-
 include/kvm/uip.h        |  2 ++
 include/kvm/util.h       |  2 ++
 net/uip/tcp.c            |  7 +++----
 net/uip/udp.c            |  5 +++--
 term.c                   |  4 ++--
 ui/gtk3.c                |  2 +-
 ui/sdl.c                 |  2 +-
 ui/vnc.c                 |  2 +-
 util/threadpool.c        |  9 ++++----
 util/util.c              | 12 +++++++++++
 virtio/blk.c             |  2 +-
 virtio/net.c             | 26 ++++++++++++++++--------
 20 files changed, 146 insertions(+), 71 deletions(-)

diff --git a/disk/aio.c b/disk/aio.c
index a7418c8c261d..365f075272dd 100644
--- a/disk/aio.c
+++ b/disk/aio.c
@@ -127,9 +127,8 @@ int disk_aio_setup(struct disk_image *disk)
 		return -errno;
 
 	io_setup(AIO_MAX, &disk->ctx);
-	r = pthread_create(&disk->thread, NULL, disk_aio_thread, disk);
+	r = kvm_create_thread(disk->kvm, &disk->thread, disk_aio_thread, disk);
 	if (r) {
-		r = -errno;
 		close(disk->evt);
 		return r;
 	}
diff --git a/disk/blk.c b/disk/blk.c
index b4c9fba3bcec..82e1937a1906 100644
--- a/disk/blk.c
+++ b/disk/blk.c
@@ -35,8 +35,14 @@ static bool is_mounted(struct stat *st)
 	return false;
 }
 
-struct disk_image *blkdev__probe(const char *filename, int flags, struct stat *st)
+struct disk_image *blkdev__probe(const char *filename, int flags, struct stat *st,
+				 struct kvm *kvm)
 {
+	struct new_disk_image ndi = {
+		.ops	= &blk_dev_ops,
+		.kvm	= kvm,
+		.flags	= DISK_IMAGE_REGULAR,
+	};
 	int fd, r;
 	u64 size;
 
@@ -56,17 +62,19 @@ struct disk_image *blkdev__probe(const char *filename, int flags, struct stat *s
 	fd = open(filename, flags);
 	if (fd < 0)
 		return ERR_PTR(fd);
+	ndi.fd = fd;
 
 	if (ioctl(fd, BLKGETSIZE64, &size) < 0) {
 		r = -errno;
 		close(fd);
 		return ERR_PTR(r);
 	}
+	ndi.size = size;
 
 	/*
 	 * FIXME: This will not work on 32-bit host because we can not
 	 * mmap large disk. There is not enough virtual address space
 	 * in 32-bit host. However, this works on 64-bit host.
 	 */
-	return disk_image__new(fd, size, &blk_dev_ops, DISK_IMAGE_REGULAR);
+	return disk_image__new(&ndi);
 }
diff --git a/disk/core.c b/disk/core.c
index b232eece9e73..5a1692fc7951 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -59,9 +59,7 @@ int disk_img_name_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
-struct disk_image *disk_image__new(int fd, u64 size,
-				   struct disk_image_operations *ops,
-				   int use_mmap)
+struct disk_image *disk_image__new(struct new_disk_image *ndi)
 {
 	struct disk_image *disk;
 	int r;
@@ -71,16 +69,18 @@ struct disk_image *disk_image__new(int fd, u64 size,
 		return ERR_PTR(-ENOMEM);
 
 	*disk = (struct disk_image) {
-		.fd	= fd,
-		.size	= size,
-		.ops	= ops,
+		.fd	= ndi->fd,
+		.size	= ndi->size,
+		.ops	= ndi->ops,
+		.kvm	= ndi->kvm,
 	};
 
-	if (use_mmap == DISK_IMAGE_MMAP) {
+	if (ndi->flags == DISK_IMAGE_MMAP) {
 		/*
 		 * The write to disk image will be discarded
 		 */
-		disk->priv = mmap(NULL, size, PROT_RW, MAP_PRIVATE | MAP_NORESERVE, fd, 0);
+		disk->priv = mmap(NULL, ndi->size, PROT_RW,
+				  MAP_PRIVATE | MAP_NORESERVE, ndi->fd, 0);
 		if (disk->priv == MAP_FAILED) {
 			r = -errno;
 			goto err_free_disk;
@@ -95,13 +95,14 @@ struct disk_image *disk_image__new(int fd, u64 size,
 
 err_unmap_disk:
 	if (disk->priv)
-		munmap(disk->priv, size);
+		munmap(disk->priv, ndi->size);
 err_free_disk:
 	free(disk);
 	return ERR_PTR(r);
 }
 
-static struct disk_image *disk_image__open(const char *filename, bool readonly, bool direct)
+static struct disk_image *disk_image__open(const char *filename, bool readonly, bool direct,
+					   struct kvm *kvm)
 {
 	struct disk_image *disk;
 	struct stat st;
@@ -118,7 +119,7 @@ static struct disk_image *disk_image__open(const char *filename, bool readonly,
 		return ERR_PTR(-errno);
 
 	/* blk device ?*/
-	disk = blkdev__probe(filename, flags, &st);
+	disk = blkdev__probe(filename, flags, &st, kvm);
 	if (!IS_ERR_OR_NULL(disk)) {
 		disk->readonly = readonly;
 		return disk;
@@ -129,7 +130,7 @@ static struct disk_image *disk_image__open(const char *filename, bool readonly,
 		return ERR_PTR(fd);
 
 	/* qcow image ?*/
-	disk = qcow_probe(fd, true);
+	disk = qcow_probe(fd, true, kvm);
 	if (!IS_ERR_OR_NULL(disk)) {
 		pr_warning("Forcing read-only support for QCOW");
 		disk->readonly = true;
@@ -137,7 +138,7 @@ static struct disk_image *disk_image__open(const char *filename, bool readonly,
 	}
 
 	/* raw image ?*/
-	disk = raw_image__probe(fd, &st, readonly);
+	disk = raw_image__probe(fd, &st, readonly, kvm);
 	if (!IS_ERR_OR_NULL(disk)) {
 		disk->readonly = readonly;
 		return disk;
@@ -188,7 +189,7 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
 		if (!filename)
 			continue;
 
-		disks[i] = disk_image__open(filename, readonly, direct);
+		disks[i] = disk_image__open(filename, readonly, direct, kvm);
 		if (IS_ERR_OR_NULL(disks[i])) {
 			pr_err("Loading disk image '%s' failed", filename);
 			err = disks[i];
diff --git a/disk/qcow.c b/disk/qcow.c
index dd6be62ee183..eed18bb169bb 100644
--- a/disk/qcow.c
+++ b/disk/qcow.c
@@ -1273,8 +1273,13 @@ static void *qcow2_read_header(int fd)
 	return header;
 }
 
-static struct disk_image *qcow2_probe(int fd, bool readonly)
+static struct disk_image *qcow2_probe(int fd, bool readonly, struct kvm *kvm)
 {
+	struct new_disk_image ndi = {
+		.kvm	= kvm,
+		.fd	= fd,
+		.flags	= DISK_IMAGE_REGULAR,
+	};
 	struct disk_image *disk_image;
 	struct qcow_l1_table *l1t;
 	struct qcow_header *h;
@@ -1295,6 +1300,7 @@ static struct disk_image *qcow2_probe(int fd, bool readonly)
 	h = q->header = qcow2_read_header(fd);
 	if (!h)
 		goto free_qcow;
+	ndi.size = h->size;
 
 	q->version = QCOW2_VERSION;
 	q->csize_shift = (62 - (q->header->cluster_bits - 8));
@@ -1329,10 +1335,13 @@ static struct disk_image *qcow2_probe(int fd, bool readonly)
 	/*
 	 * Do not use mmap use read/write instead
 	 */
-	if (readonly)
-		disk_image = disk_image__new(fd, h->size, &qcow_disk_readonly_ops, DISK_IMAGE_REGULAR);
-	else
-		disk_image = disk_image__new(fd, h->size, &qcow_disk_ops, DISK_IMAGE_REGULAR);
+	if (readonly) {
+		ndi.ops = &qcow_disk_readonly_ops;
+		disk_image = disk_image__new(&ndi);
+	} else {
+		ndi.ops = &qcow_disk_ops;
+		disk_image = disk_image__new(&ndi);
+	}
 
 	if (IS_ERR_OR_NULL(disk_image))
 		goto free_refcount_table;
@@ -1418,8 +1427,13 @@ static void *qcow1_read_header(int fd)
 	return header;
 }
 
-static struct disk_image *qcow1_probe(int fd, bool readonly)
+static struct disk_image *qcow1_probe(int fd, bool readonly, struct kvm *kvm)
 {
+	struct new_disk_image ndi = {
+		.kvm	= kvm,
+		.fd	= fd,
+		.flags	= DISK_IMAGE_REGULAR,
+	};
 	struct disk_image *disk_image;
 	struct qcow_l1_table *l1t;
 	struct qcow_header *h;
@@ -1441,6 +1455,7 @@ static struct disk_image *qcow1_probe(int fd, bool readonly)
 	h = q->header = qcow1_read_header(fd);
 	if (!h)
 		goto free_qcow;
+	ndi.size = h->size;
 
 	q->version = QCOW1_VERSION;
 	q->cluster_size = 1 << q->header->cluster_bits;
@@ -1465,10 +1480,13 @@ static struct disk_image *qcow1_probe(int fd, bool readonly)
 	/*
 	 * Do not use mmap use read/write instead
 	 */
-	if (readonly)
-		disk_image = disk_image__new(fd, h->size, &qcow_disk_readonly_ops, DISK_IMAGE_REGULAR);
-	else
-		disk_image = disk_image__new(fd, h->size, &qcow_disk_ops, DISK_IMAGE_REGULAR);
+	if (readonly) {
+		ndi.ops = &qcow_disk_readonly_ops;
+		disk_image = disk_image__new(&ndi);
+	} else {
+		ndi.ops = &qcow_disk_ops;
+		disk_image = disk_image__new(&ndi);
+	}
 
 	if (!disk_image)
 		goto free_l1_table;
@@ -1514,13 +1532,13 @@ static bool qcow1_check_image(int fd)
 	return true;
 }
 
-struct disk_image *qcow_probe(int fd, bool readonly)
+struct disk_image *qcow_probe(int fd, bool readonly, struct kvm *kvm)
 {
 	if (qcow1_check_image(fd))
-		return qcow1_probe(fd, readonly);
+		return qcow1_probe(fd, readonly, kvm);
 
 	if (qcow2_check_image(fd))
-		return qcow2_probe(fd, readonly);
+		return qcow2_probe(fd, readonly, kvm);
 
 	return NULL;
 }
diff --git a/disk/raw.c b/disk/raw.c
index 54b4e7408661..9ad09d20db12 100644
--- a/disk/raw.c
+++ b/disk/raw.c
@@ -83,8 +83,14 @@ struct disk_image_operations ro_ops_nowrite = {
 	.async	= true,
 };
 
-struct disk_image *raw_image__probe(int fd, struct stat *st, bool readonly)
+struct disk_image *raw_image__probe(int fd, struct stat *st, bool readonly,
+				    struct kvm *kvm)
 {
+	struct new_disk_image new = {
+		.kvm	= kvm,
+		.size	= st->st_size,
+		.fd	= fd,
+	};
 	if (readonly) {
 		/*
 		 * Use mmap's MAP_PRIVATE to implement non-persistent write
@@ -92,16 +98,23 @@ struct disk_image *raw_image__probe(int fd, struct stat *st, bool readonly)
 		 */
 		struct disk_image *disk;
 
-		disk = disk_image__new(fd, st->st_size, &ro_ops, DISK_IMAGE_MMAP);
+		new.ops = &ro_ops;
+		new.flags = DISK_IMAGE_MMAP;
+		disk = disk_image__new(&new);
+
 		if (IS_ERR_OR_NULL(disk)) {
-			disk = disk_image__new(fd, st->st_size, &ro_ops_nowrite, DISK_IMAGE_REGULAR);
+			new.ops = &ro_ops_nowrite;
+			new.flags = DISK_IMAGE_REGULAR;
+			disk = disk_image__new(&new);
 		}
 
 		return disk;
 	} else {
+		new.ops = &raw_image_regular_ops;
+		new.flags = DISK_IMAGE_REGULAR;
 		/*
 		 * Use read/write instead of mmap
 		 */
-		return disk_image__new(fd, st->st_size, &raw_image_regular_ops, DISK_IMAGE_REGULAR);
+		return disk_image__new(&new);
 	}
 }
diff --git a/epoll.c b/epoll.c
index 8cb0cee5822e..0ddd235d89a8 100644
--- a/epoll.c
+++ b/epoll.c
@@ -58,7 +58,7 @@ int epoll__init(struct kvm *kvm, struct kvm__epoll *epoll,
 	if (r < 0)
 		goto err_close_all;
 
-	r = pthread_create(&epoll->thread, NULL, epoll__thread, epoll);
+	r = kvm_create_thread(kvm, &epoll->thread, epoll__thread, epoll);
 	if (r < 0)
 		goto err_close_all;
 
diff --git a/include/kvm/disk-image.h b/include/kvm/disk-image.h
index cbe91b07af0b..f1c61f0403e3 100644
--- a/include/kvm/disk-image.h
+++ b/include/kvm/disk-image.h
@@ -26,11 +26,6 @@
 #define SECTOR_SHIFT		9
 #define SECTOR_SIZE		(1UL << SECTOR_SHIFT)
 
-enum {
-	DISK_IMAGE_REGULAR,
-	DISK_IMAGE_MMAP,
-};
-
 #define MAX_DISK_IMAGES         4
 
 struct disk_image;
@@ -54,6 +49,20 @@ struct disk_image_params {
 	bool direct;
 };
 
+enum new_disk_image_flags {
+	DISK_IMAGE_REGULAR,
+	DISK_IMAGE_MMAP,
+};
+
+struct kvm;
+struct new_disk_image {
+	struct disk_image_operations	*ops;
+	struct kvm			*kvm;
+	u64				size;
+	int				fd;
+	enum new_disk_image_flags	flags;
+};
+
 struct disk_image {
 	int				fd;
 	u64				size;
@@ -61,6 +70,7 @@ struct disk_image {
 	void				*priv;
 	void				*disk_req_cb_param;
 	void				(*disk_req_cb)(void *param, long len);
+	struct kvm			*kvm;
 	bool				readonly;
 	bool				async;
 #ifdef CONFIG_HAS_AIO
@@ -76,7 +86,7 @@ struct disk_image {
 int disk_img_name_parser(const struct option *opt, const char *arg, int unset);
 int disk_image__init(struct kvm *kvm);
 int disk_image__exit(struct kvm *kvm);
-struct disk_image *disk_image__new(int fd, u64 size, struct disk_image_operations *ops, int mmap);
+struct disk_image *disk_image__new(struct new_disk_image *ndi);
 int disk_image__flush(struct disk_image *disk);
 int disk_image__wait(struct disk_image *disk);
 ssize_t disk_image__read(struct disk_image *disk, u64 sector, const struct iovec *iov,
@@ -86,8 +96,10 @@ ssize_t disk_image__write(struct disk_image *disk, u64 sector, const struct iove
 ssize_t disk_image__get_serial(struct disk_image *disk, struct iovec *iov,
 			       int iovcount, ssize_t len);
 
-struct disk_image *raw_image__probe(int fd, struct stat *st, bool readonly);
-struct disk_image *blkdev__probe(const char *filename, int flags, struct stat *st);
+struct disk_image *raw_image__probe(int fd, struct stat *st, bool readonly,
+				    struct kvm *kvm);
+struct disk_image *blkdev__probe(const char *filename, int flags, struct stat *st,
+				 struct kvm *kvm);
 
 ssize_t raw_image__read_sync(struct disk_image *disk, u64 sector,
 			     const struct iovec *iov, int iovcount, void *param);
diff --git a/include/kvm/qcow.h b/include/kvm/qcow.h
index f8492462ddaa..c0293ef8bf75 100644
--- a/include/kvm/qcow.h
+++ b/include/kvm/qcow.h
@@ -128,6 +128,7 @@ struct qcow2_header_disk {
 	u64				snapshots_offset;
 };
 
-struct disk_image *qcow_probe(int fd, bool readonly);
+struct kvm;
+struct disk_image *qcow_probe(int fd, bool readonly, struct kvm *kvm);
 
 #endif /* KVM__QCOW_H */
diff --git a/include/kvm/uip.h b/include/kvm/uip.h
index efa508a50f51..39db4b656fd5 100644
--- a/include/kvm/uip.h
+++ b/include/kvm/uip.h
@@ -184,6 +184,7 @@ struct uip_dhcp {
 	u8 option[UIP_DHCP_OPTION_LEN];
 } __attribute__((packed));
 
+struct kvm;
 struct uip_info {
 	struct list_head udp_socket_head;
 	struct list_head tcp_socket_head;
@@ -196,6 +197,7 @@ struct uip_info {
 	struct list_head buf_head;
 	struct mutex buf_lock;
 	pthread_t udp_thread;
+	struct kvm *kvm;
 	u8 *udp_buf;
 	int udp_epollfd;
 	int buf_free_nr;
diff --git a/include/kvm/util.h b/include/kvm/util.h
index 0f5a4bba5714..86edb77edfce 100644
--- a/include/kvm/util.h
+++ b/include/kvm/util.h
@@ -151,6 +151,8 @@ void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
 void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
 void *mmap_guest_memfd(struct kvm *kvm, u64 size);
 
+int kvm_create_thread(struct kvm *kvm, pthread_t *thread,
+		      void *(*start_routine)(void *), void *arg);
 int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
 			   void *(*start_routine)(void *), void *arg);
 
diff --git a/net/uip/tcp.c b/net/uip/tcp.c
index 42e6e992cd6a..54252016ac02 100644
--- a/net/uip/tcp.c
+++ b/net/uip/tcp.c
@@ -253,7 +253,7 @@ out:
 	return NULL;
 }
 
-static int uip_tcp_socket_receive(struct uip_tcp_socket *sk)
+static int uip_tcp_socket_receive(struct uip_tcp_socket *sk, struct kvm *kvm)
 {
 	int ret;
 
@@ -261,8 +261,7 @@ static int uip_tcp_socket_receive(struct uip_tcp_socket *sk)
 		sk->buf = malloc(UIP_MAX_TCP_PAYLOAD);
 		if (!sk->buf)
 			return -ENOMEM;
-		ret = pthread_create(&sk->thread, NULL, uip_tcp_socket_thread,
-				     (void *)sk);
+		ret = kvm_create_thread(kvm, &sk->thread, uip_tcp_socket_thread, sk);
 		if (ret)
 			free(sk->buf);
 		return ret;
@@ -324,7 +323,7 @@ int uip_tx_do_ipv4_tcp(struct uip_tx_arg *arg)
 		/*
 		 * Start receive thread for data from remote to guest
 		 */
-		uip_tcp_socket_receive(sk);
+		uip_tcp_socket_receive(sk, arg->info->kvm);
 
 		goto out;
 	}
diff --git a/net/uip/udp.c b/net/uip/udp.c
index d2580d06e851..e63c8ad97c63 100644
--- a/net/uip/udp.c
+++ b/net/uip/udp.c
@@ -238,10 +238,11 @@ int uip_tx_do_ipv4_udp(struct uip_tx_arg *arg)
 		if (!info->udp_buf)
 			return -1;
 
-		pthread_create(&info->udp_thread, NULL, uip_udp_socket_thread, (void *)info);
+		ret = kvm_create_thread(info->kvm, &info->udp_thread,
+					uip_udp_socket_thread, info);
 	}
 
-	return 0;
+	return ret;
 }
 
 void uip_udp_exit(struct uip_info *info)
diff --git a/term.c b/term.c
index b8a70fe2ab7b..e1b31737e0f7 100644
--- a/term.c
+++ b/term.c
@@ -196,8 +196,8 @@ static int term_init(struct kvm *kvm)
 
 
 	/* Use our own blocking thread to read stdin, don't require a tick */
-	if(pthread_create(&term_poll_thread, NULL, term_poll_thread_loop,kvm))
-		die("Unable to create console input poll thread\n");
+	if (kvm_create_thread(kvm, &term_poll_thread, term_poll_thread_loop, kvm))
+		die_perror("Unable to create console input poll thread");
 
 	signal(SIGTERM, term_sig_cleanup);
 	atexit(term_cleanup);
diff --git a/ui/gtk3.c b/ui/gtk3.c
index 1e08a8f6b76a..b6f3a3000b01 100644
--- a/ui/gtk3.c
+++ b/ui/gtk3.c
@@ -277,7 +277,7 @@ static int kvm_gtk_start(struct framebuffer *fb)
 {
 	pthread_t thread;
 
-	if (pthread_create(&thread, NULL, kvm_gtk_thread, fb) != 0)
+	if (kvm_create_thread(fb->kvm, &thread, kvm_gtk_thread, fb) != 0)
 		return -1;
 
 	return 0;
diff --git a/ui/sdl.c b/ui/sdl.c
index 5035405bb488..2014ec5bcfe9 100644
--- a/ui/sdl.c
+++ b/ui/sdl.c
@@ -277,7 +277,7 @@ static int sdl__start(struct framebuffer *fb)
 
 	running = true;
 
-	if (pthread_create(&thread, NULL, sdl__thread, fb) != 0)
+	if (kvm_create_thread(fb->kvm, &thread, sdl__thread, fb) != 0)
 		return -1;
 
 	return 0;
diff --git a/ui/vnc.c b/ui/vnc.c
index 12e4bd53fe0d..8371b3cc9f8c 100644
--- a/ui/vnc.c
+++ b/ui/vnc.c
@@ -205,7 +205,7 @@ static int vnc__start(struct framebuffer *fb)
 {
 	pthread_t thread;
 
-	if (pthread_create(&thread, NULL, vnc__thread, fb) != 0)
+	if (kvm_create_thread(fb->kvm, &thread, vnc__thread, fb) != 0)
 		return -1;
 
 	return 0;
diff --git a/util/threadpool.c b/util/threadpool.c
index 1dc3bf7e7ef2..05722b5c09a4 100644
--- a/util/threadpool.c
+++ b/util/threadpool.c
@@ -97,7 +97,7 @@ static void *thread_pool__threadfunc(void *param)
 	return NULL;
 }
 
-static int thread_pool__addthread(void)
+static int thread_pool__addthread(struct kvm *kvm)
 {
 	int res;
 	void *newthreads;
@@ -111,9 +111,8 @@ static int thread_pool__addthread(void)
 
 	threads = newthreads;
 
-	res = pthread_create(threads + threadcount, NULL,
-			     thread_pool__threadfunc, NULL);
-
+	res = kvm_create_thread(kvm, threads + threadcount,
+				thread_pool__threadfunc, NULL);
 	if (res == 0)
 		threadcount++;
 	mutex_unlock(&thread_mutex);
@@ -129,7 +128,7 @@ int thread_pool__init(struct kvm *kvm)
 	running = true;
 
 	for (i = 0; i < thread_count; i++)
-		if (thread_pool__addthread() < 0)
+		if (thread_pool__addthread(kvm) < 0)
 			return i;
 
 	return i;
diff --git a/util/util.c b/util/util.c
index ff888bf9e061..7238fe57bace 100644
--- a/util/util.c
+++ b/util/util.c
@@ -207,6 +207,18 @@ void *mmap_guest_memfd(struct kvm *kvm, u64 size)
 	return addr;
 }
 
+int kvm_create_thread(struct kvm *kvm, pthread_t *thread,
+		      void *(*start_routine)(void *), void *arg)
+{
+	int ret;
+
+	ret = pthread_create(thread, NULL, start_routine, arg);
+	if (ret)
+		errno = ret;
+
+	return -ret;
+}
+
 int kvm_create_vcpu_thread(struct kvm *kvm, pthread_t *thread,
 			   void *(*start_routine)(void *), void *arg)
 {
diff --git a/virtio/blk.c b/virtio/blk.c
index b2d6180d118a..0ffafff1663b 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -237,7 +237,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 	if (bdev->io_efd < 0)
 		return -errno;
 
-	if (pthread_create(&bdev->io_thread, NULL, virtio_blk_thread, bdev))
+	if (kvm_create_thread(kvm, &bdev->io_thread, virtio_blk_thread, bdev))
 		return -errno;
 
 	return 0;
diff --git a/virtio/net.c b/virtio/net.c
index 492c57675b1f..097bc32fc12b 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -610,17 +610,23 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 	mutex_init(&net_queue->lock);
 	pthread_cond_init(&net_queue->cond, NULL);
 	if (is_ctrl_vq(ndev, vq)) {
-		pthread_create(&net_queue->thread, NULL, virtio_net_ctrl_thread,
-			       net_queue);
-
+		r = kvm_create_thread(kvm, &net_queue->thread,
+				      virtio_net_ctrl_thread, net_queue);
+		if (r)
+			die_perror("virtio_net_ctrl_thread");
 		return 0;
 	} else if (ndev->vhost_fd == 0 ) {
-		if (vq & 1)
-			pthread_create(&net_queue->thread, NULL,
-				       virtio_net_tx_thread, net_queue);
-		else
-			pthread_create(&net_queue->thread, NULL,
-				       virtio_net_rx_thread, net_queue);
+		if (vq & 1) {
+			r = kvm_create_thread(kvm, &net_queue->thread,
+					      virtio_net_tx_thread, net_queue);
+			if (r)
+				die_perror("virtio_net_tx_thread");
+		} else {
+			r = kvm_create_thread(kvm, &net_queue->thread,
+					      virtio_net_rx_thread, net_queue);
+			if (r)
+				die_perror("virtio_net_rx_thread");
+		}
 
 		return 0;
 	}
@@ -870,6 +876,8 @@ static int virtio_net__init_one(struct virtio_net_params *params)
 	mutex_init(&ndev->mutex);
 	ndev->queue_pairs = max(1, min(VIRTIO_NET_NUM_QUEUES, params->mq));
 
+	ndev->info.kvm = params->kvm;
+
 	for (i = 0 ; i < 6 ; i++) {
 		ndev->config.mac[i]		= params->guest_mac[i];
 		ndev->info.guest_mac.addr[i]	= params->guest_mac[i];
-- 
2.55.0

