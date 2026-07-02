Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5300C4DA528
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002580; cv=none; b=Tll7OBRki0npENdAbuN/WI8tirBZtuX25Y62NSxgZ6CAr5PqSb3zToYJv9KnWtgW8RvO2TdQsSZwnWn1mh2YPhH9iHL2aE7cJZtMuK7NqhlREH8UmdCOItrtEey4K/ZUWTrPHOmdNJehtfNp8w2+BZ5r3W+NVZzKLEEMKqTijPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002580; c=relaxed/simple;
	bh=WgbFyb2eXKItzxCgEFOpscwp6g8ppePS7so0jNHjZjw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OW2f6N8g8DQLa9mN0+O5dSsE6WQ5QehYK2Is66trz4Er1qc3LmR4NDX71KgJ4eOw300sHwbSFOQvMFOk31RaHAITG9hmXYOWiBtt59ZoTKtClytk6Vh70GlojMU/5DLVdqk7fyXh52UJXzBhzxGfv9qDzqik/O7HW/mupSyeE2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IQNpx2yg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IQNpx2yg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6171B35A8;
	Thu,  2 Jul 2026 07:29:33 -0700 (PDT)
Received: from e140010.cambridge.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B6083F673;
	Thu,  2 Jul 2026 07:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783002577; bh=WgbFyb2eXKItzxCgEFOpscwp6g8ppePS7so0jNHjZjw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IQNpx2ygYdLi5rjfHPz6RVqdHIILBz/xGJlQ43+Jep0KnmVtbP2oWgxlW7bUO0Nhd
	 Neno79ZUQcjtMuEDhvDymCvrwhR8RagigtSsHrE8c/UNH9Qcux/w+xQXDSPEVatN/V
	 tcTWt8abSekDA1LhpmLBWqY4VbSEMyGGHLbTb0Xw=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com,
	kvm@vger.kernel.org,
	seanjc@google.com,
	david.hildenbrand@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com
Subject: [RFC PATCH 2/3] KVM: Implement dirty page logging for guest_memfd-only memslots
Date: Thu,  2 Jul 2026 15:29:11 +0100
Message-ID: <20260702142912.6395-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702142912.6395-1-alexandru.elisei@arm.com>
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The entire memory represented by guest_memfd-only memslot is shared and
accessible by userspace. Enable dirty page logging for such memslots, and
allow architectures to advertise support for it with the
KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES capability.

No architecture supports it yet.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Documentation/virt/kvm/api.rst |  9 +++++
 include/linux/kvm_host.h       | 15 ++++++++
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/guest_memfd.c         | 70 ++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c            | 44 ++++++++++-----------
 virt/kvm/kvm_mm.h              | 11 ++++++
 6 files changed, 128 insertions(+), 22 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5f9ee92f43e..5012afe6a9b5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -9493,6 +9493,15 @@ take care to differentiate between these cases.
 The presence of this capability indicates that the nested KVM guest can
 start in ESA mode.
 
+8.48 KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES
+---------------------------------------------
+
+:Architectures: all
+
+The presence of this capability indicates that memslots backed by a guest_memfd
+file descriptor created with the GUEST_MEMFD_FLAG_MMAP flag can have dirty
+page logging enabled.
+
 9. Known KVM API problems
 =========================
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d3..c44e9253eb40 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -56,6 +56,7 @@
  */
 #define KVM_MEMSLOT_INVALID			(1UL << 16)
 #define KVM_MEMSLOT_GMEM_ONLY			(1UL << 17)
+#define MEMSLOT_USER_FLAGS_MASK			0xffff
 
 /*
  * Bit 63 of the memslot generation number is an "update in-progress flag",
@@ -731,6 +732,9 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+bool kvm_arch_supports_gmem_mmap_dirty_logging(struct kvm *kvm);
+int kvm_gmem_check_no_change(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     unsigned int fd, loff_t offset);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 {
@@ -741,6 +745,17 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 
 	return flags;
 }
+#else
+static inline bool kvm_arch_supports_gmem_mmap_dirty_logging(struct kvm *kvm)
+{
+	return false;
+}
+static inline int kvm_gmem_check_no_change(struct kvm *kvm, struct kvm_memory_slot *slot,
+					   unsigned int fd, loff_t offset)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
 #endif
 
 #ifndef kvm_arch_has_readonly_mem
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8..5a53e2e19b2f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -997,6 +997,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_S390_VSIE_ESAMODE 248
 #define KVM_CAP_S390_HPAGE_2G 249
+#define KVM_CAP_GUEST_MEMFD_MMAP_LOG_DIRTY_PAGES 250
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 43ef8e908aaf..210bdd76f0aa 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -622,6 +622,11 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
+bool __weak kvm_arch_supports_gmem_mmap_dirty_logging(struct kvm *kvm)
+{
+	return false;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	static const char *name = "[kvm-gmem]";
@@ -705,6 +710,66 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 	return __kvm_gmem_create(kvm, size, flags);
 }
 
+static int __kvm_gmem_check_no_change(struct kvm *kvm, struct kvm_memory_slot *old,
+				      struct file *old_file, unsigned int fd,
+				      loff_t offset)
+{
+	struct file *new_file;
+
+	new_file = fget(fd);
+	if (!new_file)
+		return -EBADF;
+	if (new_file != old_file) {
+		fput(new_file);
+		return -EBADF;
+	}
+	fput(new_file);
+
+	if (old->gmem.pgoff != offset >> PAGE_SHIFT)
+		return -EINVAL;
+
+	return 0;
+}
+
+int kvm_gmem_check_no_change(struct kvm *kvm, struct kvm_memory_slot *old,
+			     unsigned int fd, loff_t offset)
+{
+	CLASS(gmem_get_file, old_file)(old);
+
+	return __kvm_gmem_check_no_change(kvm, old, old_file, fd, offset);
+}
+
+int kvm_gmem_change_flags(struct kvm *kvm, struct kvm_memory_slot *old,
+			  struct kvm_memory_slot *new, unsigned int fd,
+			  loff_t offset)
+{
+	struct gmem_file *old_f;
+	int ret;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	if (!kvm_memslot_is_gmem_only(old))
+		return -EINVAL;
+
+	CLASS(gmem_get_file, old_file)(old);
+
+	ret = __kvm_gmem_check_no_change(kvm, old, old_file, fd, offset);
+	if (ret)
+		return ret;
+
+	old_f = old_file->private_data;
+	if (xa_load(&old_f->bindings, old->gmem.pgoff) != memslot_to_xa_value(new)) {
+		WARN_ON_ONCE(xa_to_value(xa_load(&old_f->bindings, old->gmem.pgoff)));
+		return -EIO;
+	}
+
+	new->gmem.file = old->gmem.file;
+	new->gmem.pgoff = old->gmem.pgoff;
+	new->flags |= KVM_MEMSLOT_GMEM_ONLY;
+
+	return 0;
+}
+
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, uoff_t offset)
 {
@@ -734,6 +799,11 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
 		goto err;
 
+	if (slot->flags & KVM_MEM_LOG_DIRTY_PAGES &&
+	    (!kvm_gmem_supports_mmap(inode) ||
+	     !kvm_arch_supports_gmem_mmap_dirty_logging(kvm)))
+		goto err;
+
 	filemap_invalidate_lock(inode->i_mapping);
 
 	start = offset >> PAGE_SHIFT;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e44c20c04961..af380e8f2b68 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1573,14 +1573,14 @@ static void kvm_replace_memslot(struct kvm *kvm,
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	u32 valid_flags = 0;
 
 	if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
 		valid_flags |= KVM_MEM_GUEST_MEMFD;
 
-	/* Dirty logging private memory is not currently supported. */
-	if (mem->flags & KVM_MEM_GUEST_MEMFD)
-		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
+	if (!(mem->flags & KVM_MEM_GUEST_MEMFD) ||
+	    kvm_arch_supports_gmem_mmap_dirty_logging(kvm))
+		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
 
 	/*
 	 * GUEST_MEMFD is incompatible with read-only memslots, as writes to
@@ -1739,16 +1739,6 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		 */
 		if (old->dirty_bitmap && !new->dirty_bitmap)
 			kvm_destroy_dirty_bitmap(old);
-
-		/*
-		 * Unbind the guest_memfd instance as needed; the @new slot has
-		 * already created its own binding.  TODO: Drop the WARN when
-		 * dirty logging guest_memfd memslots is supported.  Until then,
-		 * flags-only changes on guest_memfd slots should be impossible.
-		 */
-		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
-			kvm_gmem_unbind(old);
-
 		/*
 		 * The final quirk.  Free the detached, old slot, but only its
 		 * memory, not any metadata.  Metadata, including arch specific
@@ -2073,22 +2063,27 @@ static int kvm_set_memory_region(struct kvm *kvm,
 		if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
 			return -EINVAL;
 	} else { /* Modify an existing slot. */
-		/* Private memslots are immutable, they can only be deleted. */
-		if (mem->flags & KVM_MEM_GUEST_MEMFD)
-			return -EINVAL;
 		if ((mem->userspace_addr != old->userspace_addr) ||
 		    (npages != old->npages) ||
 		    ((mem->flags ^ old->flags) & (KVM_MEM_READONLY | KVM_MEM_GUEST_MEMFD)))
 			return -EINVAL;
 
-		if (base_gfn != old->base_gfn)
+		if (base_gfn != old->base_gfn) {
 			change = KVM_MR_MOVE;
-		else if (mem->flags != old->flags)
+		} else if (mem->flags != (old->flags & MEMSLOT_USER_FLAGS_MASK)) {
 			change = KVM_MR_FLAGS_ONLY;
-		else /* Nothing to change. */
+		} else if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+			return kvm_gmem_check_no_change(kvm, old, mem->guest_memfd,
+							mem->guest_memfd_offset);
+		} else {
 			return 0;
+		}
 	}
 
+	if (mem->flags & KVM_MEM_GUEST_MEMFD &&
+	    change != KVM_MR_CREATE && change != KVM_MR_FLAGS_ONLY)
+		return -EINVAL;
+
 	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
 	    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
 		return -EEXIST;
@@ -2105,7 +2100,12 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
 	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
-		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
+		if (change == KVM_MR_CREATE) {
+			r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
+		} else if (change == KVM_MR_FLAGS_ONLY) {
+			r = kvm_gmem_change_flags(kvm, old, new, mem->guest_memfd,
+						  mem->guest_memfd_offset);
+		}
 		if (r)
 			goto out;
 	}
@@ -2117,7 +2117,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	return 0;
 
 out_unbind:
-	if (mem->flags & KVM_MEM_GUEST_MEMFD)
+	if ((mem->flags & KVM_MEM_GUEST_MEMFD) && change == KVM_MR_CREATE)
 		kvm_gmem_unbind(new);
 out:
 	kfree(new);
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 7510ca915dd1..c58dfeb0f3df 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -77,6 +77,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, uoff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
+int kvm_gmem_change_flags(struct kvm *kvm, struct kvm_memory_slot *old,
+			  struct kvm_memory_slot *new, unsigned int fd,
+			  loff_t offset);
 #else
 static inline int kvm_gmem_init(struct module *module)
 {
@@ -95,6 +98,14 @@ static inline void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 {
 	WARN_ON_ONCE(1);
 }
+static inline int kvm_gmem_change_flags(struct kvm *kvm,
+					struct kvm_memory_slot *old,
+					struct kvm_memory_slot *new,
+					unsigned int fd, loff_t offset)
+{
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_GUEST_MEMFD */
 
 #endif /* __KVM_MM_H__ */
-- 
2.43.0

