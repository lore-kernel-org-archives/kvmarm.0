Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F15239E67
	for <kvmarm@lists.linux.dev>; Tue,  7 Oct 2025 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759875282; cv=none; b=ShD81Fd8WJuye0LCoG6g5C4p7Jga4WXJfB5mef+YAsSjR/vZ3dbbXiYQnfezVw72bK7fX4RitN6g51oC7kM32Tym8+LVBcp4L+aZkUVRf2RapeqLn1Kmfn3DdIZgPJ7mX7MSidhxzLHxU2IrDBb0bseozzSZY1nrDsglUZkCwDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759875282; c=relaxed/simple;
	bh=UIqBgwsb+vRNqfEauPUfOsNdF2dMfog0jQ1gcUf0ha8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F2kcqeL1PdptobpaLpBLTIqH1TnEwipoPiuFF/aaVXarKB+8bzMpNwPnGJnHWAnVRfx6HvPGa3bYxkyGAJAmXWtH3+KhmC1hnYhXKm/bT1/jD4u4+nkEmwGQgLG+y8r7Wu0BKTq3N5W/v6M/L5V9ZdgSkqWjHwK5NLddv1WDhFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zZr4GJuI; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zZr4GJuI"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28e538b5f23so73931285ad.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Oct 2025 15:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759875279; x=1760480079; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=icsR5rcCxPu2mbO19M+4yBFFv/b0hAKJOcgfFqtENIY=;
        b=zZr4GJuI83TUhYgpKKJTiS36hBAAUDSm2pddFqvl/bLvpq5zTXFONPO+pYAuNMmd4k
         uKj92F/pyqNhiYkJUgF9LIwYu+gELbR8UNWLyVHHwuLgFIaOw9UpmJes62PBIoSxYyxP
         sroJvx432Zt25QbcZKZzc4Vf9cLIGXTA8uCO30pk+faMkGz5x31NLGTHIgaxoNeSFktn
         oObOfn4gLKeyB5NNX+yw5yJy7+u98WyYcXlAOz7YKETSdiUxBdmEvnAXfylUojnlhGuJ
         euddNqVXgYd8chO0lpjPu8GIFG7GlnAj5gZ4OSUzbG9NURocu9sOBoatXoCTNKuxABmT
         FjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759875279; x=1760480079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=icsR5rcCxPu2mbO19M+4yBFFv/b0hAKJOcgfFqtENIY=;
        b=PyFqO+3vLf6UJyDrDKDjf+pBXRfbjm8/UpW5Se/yahJSuCScfQ8bPNZyZKh+i9FWoG
         9izB1Hy+Ezf3l8Fa/N4Rd4zCXBv+zd00QLxiC6X3UYMqaKaRkMAAEFSc7oi7UsBNk3td
         NrHnvUEcX8QHbeRm7gVN8+9T7XgkrTFT5PR9+HqmBEMlTBqi1/FFQ4964KtairMyhA00
         ABz5LdSnMn0ixzHQwsLE09UmNSZbw06qDSYd9N+j47KV6DbMp/ZuzpDmBECORUHzs1yR
         i+yxaG9Aj8DxlbLchu/tOZoEiGt63WLNuOvojQXALBXq/ytS7iTcKkyg3KcH0z3E52uR
         4OFg==
X-Forwarded-Encrypted: i=1; AJvYcCXd9k4dCjtk5tYIKHx4o6xbUjcylIWGo6RJlFXk+FwPWahs78nkZzXL3YBgWQtKkp109NSQhxw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyI8IbSnYxi7HyGwf/SgJ4NI16zJz5rugA6a0yUZ9+mo8WQGoZr
	/NSXOWs334O3rIwL16tInHduhMa9Kkihvs8BZyq/vVPluHc/cBVl40TBtNX8uTGbnGi0VE6JHBt
	ucagi8A==
X-Google-Smtp-Source: AGHT+IFzjZnIWMgQjMlS5yIf3CAjQgFHrvUBdvw28xfclFFsf//YAI6F0Vd324LvQxWiJFyU7jWQTlDOCyA=
X-Received: from plbcp5.prod.google.com ([2002:a17:902:e785:b0:290:28e2:ce55])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1aa4:b0:27c:a35a:1321
 with SMTP id d9443c01a7336-290272e6f79mr13157245ad.51.1759875278814; Tue, 07
 Oct 2025 15:14:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Oct 2025 15:14:09 -0700
In-Reply-To: <20251007221420.344669-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.710.ga91ca5db03-goog
Message-ID: <20251007221420.344669-2-seanjc@google.com>
Subject: [PATCH v12 01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to
 "struct gmem_file"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/guest_memfd.c | 100 ++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 46 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fbca8c0972da..3c57fb42f12c 100644
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
@@ -110,16 +119,16 @@ static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *in
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
@@ -152,20 +161,20 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
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
@@ -176,10 +185,10 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
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
@@ -277,9 +286,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
-	struct kvm_gmem *gmem = file->private_data;
+	struct gmem_file *f = file->private_data;
 	struct kvm_memory_slot *slot;
-	struct kvm *kvm = gmem->kvm;
+	struct kvm *kvm = f->kvm;
 	unsigned long index;
 
 	/*
@@ -299,7 +308,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 
 	filemap_invalidate_lock(inode->i_mapping);
 
-	xa_for_each(&gmem->bindings, index, slot)
+	xa_for_each(&f->bindings, index, slot)
 		WRITE_ONCE(slot->gmem.file, NULL);
 
 	/*
@@ -307,18 +316,18 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
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
 
@@ -493,7 +502,7 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	const char *anon_name = "[kvm-gmem]";
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
 	int fd, err;
@@ -502,14 +511,13 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
@@ -531,15 +539,15 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
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
@@ -564,7 +572,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	loff_t size = slot->npages << PAGE_SHIFT;
 	unsigned long start, end;
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 	struct inode *inode;
 	struct file *file;
 	int r = -EINVAL;
@@ -578,8 +586,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (file->f_op != &kvm_gmem_fops)
 		goto err;
 
-	gmem = file->private_data;
-	if (gmem->kvm != kvm)
+	f = file->private_data;
+	if (f->kvm != kvm)
 		goto err;
 
 	inode = file_inode(file);
@@ -593,8 +601,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	start = offset >> PAGE_SHIFT;
 	end = start + slot->npages;
 
-	if (!xa_empty(&gmem->bindings) &&
-	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
+	if (!xa_empty(&f->bindings) &&
+	    xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
 		filemap_invalidate_unlock(inode->i_mapping);
 		goto err;
 	}
@@ -609,7 +617,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
-	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
+	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
 	filemap_invalidate_unlock(inode->i_mapping);
 
 	/*
@@ -627,7 +635,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
 	unsigned long start = slot->gmem.pgoff;
 	unsigned long end = start + slot->npages;
-	struct kvm_gmem *gmem;
+	struct gmem_file *f;
 	struct file *file;
 
 	/*
@@ -638,10 +646,10 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	if (!file)
 		return;
 
-	gmem = file->private_data;
+	f = file->private_data;
 
 	filemap_invalidate_lock(file->f_mapping);
-	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
+	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
 
 	/*
 	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
@@ -659,18 +667,18 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
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
 
-	gmem = file->private_data;
-	if (xa_load(&gmem->bindings, index) != slot) {
-		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
+	f = file->private_data;
+	if (xa_load(&f->bindings, index) != slot) {
+		WARN_ON_ONCE(xa_load(&f->bindings, index));
 		return ERR_PTR(-EIO);
 	}
 
-- 
2.51.0.710.ga91ca5db03-goog

