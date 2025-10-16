Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DC9149C6F
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760635812; cv=none; b=eJOflWEJ5XbzqXrzPpeBIk4oVt7rigKbpoK4jkqSRgt3hk/9WSyridtX8FlicA+4FmmY874Cx+wAjzT44DBwbTdzzaekRc++uWsbhDXno9DD9r/qYTHvpmsTJL7u106DTloJVMI2bg96ZSoYUrGBZ3XTDt5Uyb9fYBEFe8/B6Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760635812; c=relaxed/simple;
	bh=itHMf3dOY7/pa7dZPvih/oiz3WtoZDKZziAtaSntews=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l1tEGeCMnpbE18DwsRIJTrq9EI2NMsdHs9xc/PyrIzL9d7dlCz6W4Dd9gufQM6CeYKgbaJkyr3y18a4ajSVwkDbPBhkXddJF4T9tf3fTcZC1V9RswKXJJYXuCFpTDky4kVjb6zJtfAfB+2OvagmsQhNqNhMihqWLhHKDktOGbVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vYH9Z/om; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vYH9Z/om"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befc49so1749232a91.0
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 10:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760635810; x=1761240610; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KbValAQi3mVPkQeBnxJpdOpCqapDSSet7GA9qMeIyHY=;
        b=vYH9Z/omt5Sgq8KDxaOWQ+xTVRc5PINZI9ifob4u+YiMDcloWYZee35ZAmSLgwJLSA
         KMrx4wUoxdseftHkiC2NffC8JSIi9hAt1t/V4/An6EZCdKCRTNl+0kMAMtxK1C6FK/ey
         ngFl8sPYCM8Mim5O6IwcKNMk4ipYksQ3FX3tEoaM2ZAcaTAnSVhWJbkQgFcjskVuQndV
         UyLgxBcMWI3sjxW80qM3rcF8660Z8jS7HS1T/MQ7maU96aY6Nn80n3YpOv027zMd+1Or
         zjDXU3KAbJBRwm3yDVKHejYPlbCrket/PVelVEEuwZkANB72Pg56683WKhmKscSYVToY
         jrbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760635810; x=1761240610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KbValAQi3mVPkQeBnxJpdOpCqapDSSet7GA9qMeIyHY=;
        b=rFlyP000C4I2tDZ829O/hzQbMOkt3iYCXVu7VuO+k/q14l2C3/CEZ2KEHmL/1tD0m4
         H5/bLxgVSAMeRES/+cPgkAR6fa4zjdj6QXux6MDfOy3TQOvkB+QetLdtNEbJjYxbp92f
         RKJZ3DaX7z+8lYFl4FRwgWt6kgxr+judwGHK5n/v83RoHK2d/KYv6zTsGEH041fRnTVX
         8sHv4AeXWuFnflY9kIm78j+pux5LLyCoYl0/pP5gXY6ylvtAVID4XzaAYjpaCCgDXWuE
         UZPUBFEdW3edpG980aDps22xeTeEvhgRinKedpsybyQcibCSEWw+Knpnka+emwdFjp1u
         +30w==
X-Forwarded-Encrypted: i=1; AJvYcCVUfs2CwaMDS/lRZKxM6PBL2qES1tQEyOKFDaqwwxtbAle4znBk+dpzjaAQrh9592LrAihhM9I=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWeR6udFolmAV1pyN1lR6XcCC0o90jOFl6SLgZAEIELH3QIDpN
	BYl91aZgbDVkxJzNEMnu3G/8YoN+0cU/gmpne0JvOXkVHni2TUtwGkLEZ+1UBVnXYv8/nV0qBLI
	+E4FggA==
X-Google-Smtp-Source: AGHT+IF8IBthLJ6j6SkHq4SrSxFmPl9P4miDt7bIY6TTq8tVebOV0t9zTlMTT00ono8S6O8EZ924QZsF6IQ=
X-Received: from pjre3.prod.google.com ([2002:a17:90a:b383:b0:33b:51fe:1a75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dc4:b0:32e:716d:4d2b
 with SMTP id 98e67ed59e1d1-33bc9b77638mr1287133a91.3.1760635810154; Thu, 16
 Oct 2025 10:30:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 10:28:42 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016172853.52451-2-seanjc@google.com>
Subject: [PATCH v13 01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to
 "struct gmem_file"
From: Sean Christopherson <seanjc@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"

Rename the "kvm_gmem" structure to "gmem_file" in anticipation of using
dedicated guest_memfd inodes instead of anonyomous inodes, at which point
the "kvm_gmem" nomenclature becomes quite misleading.  In guest_memfd,
inodes are effectively the raw underlying physical storage, and will be
used to track properties of the physical memory, while each gmem file is
effectively a single VM's view of that storage, and is used to track assets
specific to its associated VM, e.g. memslots=>gmem bindings.

Using "kvm_gmem" suggests that the per-VM/per-file structures are _the_
guest_memfd instance, which almost the exact opposite of reality.

Opportunistically rename local variables from "gmem" to "f", again to
avoid confusion once guest_memfd specific inodes come along.

No functional change intended.

Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 98 +++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 45 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1e4af29159ea..2989c5fe426f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,7 +7,16 @@
 
 #include "kvm_mm.h"
 
-struct kvm_gmem {
+/*
+ * A guest_memfd instance can be associated multiple VMs, each with its own
+ * "view" of the underlying physical memory.
+ *
+ * The gmem's inode is effectively the raw underlying physical storage, and is
+ * used to track properties of the physical memory, while each gmem file is
+ * effectively a single VM's view of that storage, and is used to track assets
+ * specific to its associated VM, e.g. memslots=>gmem bindings.
+ */
+struct gmem_file {
 	struct kvm *kvm;
 	struct xarray bindings;
 	struct list_head entry;
@@ -115,16 +124,16 @@ static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *in
 	return KVM_FILTER_PRIVATE;
 }
 
-static void __kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
+static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
 					pgoff_t end,
 					enum kvm_gfn_range_filter attr_filter)
 {
 	bool flush = false, found_memslot = false;
 	struct kvm_memory_slot *slot;
-	struct kvm *kvm = gmem->kvm;
+	struct kvm *kvm = f->kvm;
 	unsigned long index;
 
-	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
+	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
 		pgoff_t pgoff = slot->gmem.pgoff;
 
 		struct kvm_gfn_range gfn_range = {
@@ -157,20 +166,20 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
 {
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	enum kvm_gfn_range_filter attr_filter;
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 
 	attr_filter = kvm_gmem_get_invalidate_filter(inode);
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		__kvm_gmem_invalidate_begin(gmem, start, end, attr_filter);
+	list_for_each_entry(f, gmem_list, entry)
+		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
 }
 
-static void __kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
+static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
 				      pgoff_t end)
 {
-	struct kvm *kvm = gmem->kvm;
+	struct kvm *kvm = f->kvm;
 
-	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
+	if (xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
 		KVM_MMU_LOCK(kvm);
 		kvm_mmu_invalidate_end(kvm);
 		KVM_MMU_UNLOCK(kvm);
@@ -181,10 +190,10 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
 				    pgoff_t end)
 {
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 
-	list_for_each_entry(gmem, gmem_list, entry)
-		__kvm_gmem_invalidate_end(gmem, start, end);
+	list_for_each_entry(f, gmem_list, entry)
+		__kvm_gmem_invalidate_end(f, start, end);
 }
 
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
@@ -282,9 +291,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
-	struct kvm_gmem *gmem = file->private_data;
+	struct gmem_file *f = file->private_data;
 	struct kvm_memory_slot *slot;
-	struct kvm *kvm = gmem->kvm;
+	struct kvm *kvm = f->kvm;
 	unsigned long index;
 
 	/*
@@ -304,7 +313,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 
 	filemap_invalidate_lock(inode->i_mapping);
 
-	xa_for_each(&gmem->bindings, index, slot)
+	xa_for_each(&f->bindings, index, slot)
 		WRITE_ONCE(slot->gmem.file, NULL);
 
 	/*
@@ -312,18 +321,18 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Zap all SPTEs pointed at by this file.  Do not free the backing
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
-	__kvm_gmem_invalidate_begin(gmem, 0, -1ul,
+	__kvm_gmem_invalidate_begin(f, 0, -1ul,
 				    kvm_gmem_get_invalidate_filter(inode));
-	__kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	__kvm_gmem_invalidate_end(f, 0, -1ul);
 
-	list_del(&gmem->entry);
+	list_del(&f->entry);
 
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	mutex_unlock(&kvm->slots_lock);
 
-	xa_destroy(&gmem->bindings);
-	kfree(gmem);
+	xa_destroy(&f->bindings);
+	kfree(f);
 
 	kvm_put_kvm(kvm);
 
@@ -491,7 +500,7 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	const char *anon_name = "[kvm-gmem]";
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
 	int fd, err;
@@ -500,14 +509,13 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	if (fd < 0)
 		return fd;
 
-	gmem = kzalloc(sizeof(*gmem), GFP_KERNEL);
-	if (!gmem) {
+	f = kzalloc(sizeof(*f), GFP_KERNEL);
+	if (!f) {
 		err = -ENOMEM;
 		goto err_fd;
 	}
 
-	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
-					 O_RDWR, NULL);
+	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, f, O_RDWR, NULL);
 	if (IS_ERR(file)) {
 		err = PTR_ERR(file);
 		goto err_gmem;
@@ -529,15 +537,15 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 
 	kvm_get_kvm(kvm);
-	gmem->kvm = kvm;
-	xa_init(&gmem->bindings);
-	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
+	f->kvm = kvm;
+	xa_init(&f->bindings);
+	list_add(&f->entry, &inode->i_mapping->i_private_list);
 
 	fd_install(fd, file);
 	return fd;
 
 err_gmem:
-	kfree(gmem);
+	kfree(f);
 err_fd:
 	put_unused_fd(fd);
 	return err;
@@ -562,7 +570,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	loff_t size = slot->npages << PAGE_SHIFT;
 	unsigned long start, end;
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
 	int r = -EINVAL;
@@ -576,8 +584,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (file->f_op != &kvm_gmem_fops)
 		goto err;
 
-	gmem = file->private_data;
-	if (gmem->kvm != kvm)
+	f = file->private_data;
+	if (f->kvm != kvm)
 		goto err;
 
 	inode = file_inode(file);
@@ -591,8 +599,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	start = offset >> PAGE_SHIFT;
 	end = start + slot->npages;
 
-	if (!xa_empty(&gmem->bindings) &&
-	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
+	if (!xa_empty(&f->bindings) &&
+	    xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
 		filemap_invalidate_unlock(inode->i_mapping);
 		goto err;
 	}
@@ -607,7 +615,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
-	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
+	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	/*
@@ -625,7 +633,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 	struct file *file;
 
 	/*
@@ -636,10 +644,10 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	if (!file)
 		return;
 
-	gmem = file->private_data;
+	f = file->private_data;
 
 	filemap_invalidate_lock(file->f_mapping);
-	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
+	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
 
 	/*
 	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
@@ -657,17 +665,17 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 					pgoff_t index, kvm_pfn_t *pfn,
 					bool *is_prepared, int *max_order)
 {
-	struct file *gmem_file = READ_ONCE(slot->gmem.file);
-	struct kvm_gmem *gmem = file->private_data;
+	struct file *slot_file = READ_ONCE(slot->gmem.file);
+	struct gmem_file *f = file->private_data;
 	struct folio *folio;
 
-	if (file != gmem_file) {
-		WARN_ON_ONCE(gmem_file);
+	if (file != slot_file) {
+		WARN_ON_ONCE(slot_file);
 		return ERR_PTR(-EFAULT);
 	}
 
-	if (xa_load(&gmem->bindings, index) != slot) {
-		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
+	if (xa_load(&f->bindings, index) != slot) {
+		WARN_ON_ONCE(xa_load(&f->bindings, index));
 		return ERR_PTR(-EIO);
 	}
 
-- 
2.51.0.858.gf9c4a03a3a-goog

