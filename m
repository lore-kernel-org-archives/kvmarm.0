Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC7C1A3052
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065444; cv=none; b=RVKBXRWyAKt+64SfjNdFTxONsE0CdLT0iYkPfMBM/NUxtA9DlBkEkPeJCKR6giF0o2XpMIOZKjAs2ae7IBUVeJdCZZOgterpTkmc2Yf2Tn0eYN5AXwToqPoMVTnTfd4zsQnnnyjuTASl3/GbtXhDu32dAoAxAjSl1imgrSzx+/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065444; c=relaxed/simple;
	bh=Si9Upc2GbecJX04sbCs0KyaR9A+PIgrmZDDDvD8elO0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EnvKdDoZ6GFh/5h8gMbQI5Hxxc50IsHGwUoHvacRcZTZty8QFzv23K2rIRkh5JGicgfm5rmfqeAAmLO3MmFJoUcpOcFoGuyGS3C3ihFtKhCBaOZVrJq4/JJn9ts22KAfQ7e5KN4HAW6Vm9jNhCADohdV2aBx3B/lTx4zHp1kzrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=XYr+zwGl; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="XYr+zwGl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065443; x=1757601443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y9TjOwsiSXZl9P0/RyFMFJbYNQPYXtbeuapzd5F/ewk=;
  b=XYr+zwGlH55XI96nFXDiIY5McYjBEVJ/8yObeJ9oiZmCWjVZSpKAirIT
   nAFN6UBfUr4QtP/c/wfkp30gX8y4FtdBuA2wJIT28NzLqHhhni8ZarT/r
   G21Fdlg0g3CwmpyRFb67FsLWOoFQnWchiSYGc4+fdWPHkieZMrTQKqZYU
   g=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="231193640"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:36:07 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:61643]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.38.136:2525] with esmtp (Farcaster)
 id 3550e7db-38ee-4821-b3d5-b8907b20a81c; Wed, 11 Sep 2024 14:36:06 +0000 (UTC)
X-Farcaster-Flow-ID: 3550e7db-38ee-4821-b3d5-b8907b20a81c
Received: from EX19D033EUB004.ant.amazon.com (10.252.61.103) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:36:01 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D033EUB004.ant.amazon.com (10.252.61.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:36:01 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:35:59 +0000
From: Fares Mehanna <faresx@amazon.de>
To: 
CC: <nh-open-source@amazon.com>, Fares Mehanna <faresx@amazon.de>, Roman Kagan
	<rkagan@amazon.de>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>, Ard Biesheuvel
	<ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Javier Martinez
 Canillas" <javierm@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Fuad Tabba
	<tabba@google.com>, Mark Brown <broonie@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "Mike Rapoport (IBM)"
	<rppt@kernel.org>, David Hildenbrand <david@redhat.com>, "moderated
 list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT"
	<linux-mm@kvack.org>
Subject: [RFC PATCH 2/7] mm/secretmem: implement mm-local kernel allocations
Date: Wed, 11 Sep 2024 14:34:01 +0000
Message-ID: <20240911143421.85612-3-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>
References: <20240911143421.85612-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In order to be resilient against cross-process speculation-based
attacks, it makes sense to store certain (secret) items in kernel memory
local to mm.

Implement such allocations on top of secretmem infrastructure.

Specifically, on allocate

1. Create secretmem file.
2. To distinguish it from the conventional memfd_secret()-created one
   and to maintain associated mm-local allocation context, put the
   latter on ->private_data of the file.
3. Create virtual mapping in user virtual address space using mmap().
4. Seal the virtual mapping to disallow the user from affecting it in
   any way.
5. Fault the pages in, effectively calling secretmem fault handler to
   remove the pages from kernel linear address and make them local to
   process mm.
6. Change the PTE from user mode to kernel mode, any access from
   userspace will result in segmentation fault. Kernel can access this
   virtual address now.
7. Return the secure area as a struct containing the pointer to the
   actual memory and providing the context for the release function
   later.

On release,

- if called while mm is still in use, remove the mapping
- otherwise, if performed at mm teardown, no unmapping is necessary

The rest is taken care of by secretmem file cleanup, including returning
the pages to the kernel direct map.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
Signed-off-by: Roman Kagan <rkagan@amazon.de>
---
 include/linux/secretmem.h |  29 ++++++
 mm/Kconfig                |  10 ++
 mm/gup.c                  |   4 +-
 mm/secretmem.c            | 213 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 254 insertions(+), 2 deletions(-)

diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
index e918f96881f5..39cc73a0e4bd 100644
--- a/include/linux/secretmem.h
+++ b/include/linux/secretmem.h
@@ -2,6 +2,10 @@
 #ifndef _LINUX_SECRETMEM_H
 #define _LINUX_SECRETMEM_H
 
+struct secretmem_area {
+	void *ptr;
+};
+
 #ifdef CONFIG_SECRETMEM
 
 extern const struct address_space_operations secretmem_aops;
@@ -33,4 +37,29 @@ static inline bool secretmem_active(void)
 
 #endif /* CONFIG_SECRETMEM */
 
+#ifdef CONFIG_KERNEL_SECRETMEM
+
+bool can_access_secretmem_vma(struct vm_area_struct *vma);
+struct secretmem_area *secretmem_allocate_pages(unsigned int order);
+void secretmem_release_pages(struct secretmem_area *data);
+
+#else
+
+static inline bool can_access_secretmem_vma(struct vm_area_struct *vma)
+{
+	return true;
+}
+
+static inline struct secretmem_area *secretmem_allocate_pages(unsigned int order)
+{
+	return NULL;
+}
+
+static inline void secretmem_release_pages(struct secretmem_area *data)
+{
+	WARN_ONCE(1, "Called secret memory release page without support\n");
+}
+
+#endif /* CONFIG_KERNEL_SECRETMEM */
+
 #endif /* _LINUX_SECRETMEM_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index b72e7d040f78..a327d8def179 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1168,6 +1168,16 @@ config SECRETMEM
 	  memory areas visible only in the context of the owning process and
 	  not mapped to other processes and other kernel page tables.
 
+config KERNEL_SECRETMEM
+	default y
+	bool "Enable kernel usage of memfd_secret()" if EXPERT
+	depends on SECRETMEM
+	depends on MMU
+	help
+	  Enable the kernel usage of memfd_secret() for kernel memory allocations,
+	  The allocated memory is visible only to the kernel in the context of
+	  the owning process.
+
 config ANON_VMA_NAME
 	bool "Anonymous VMA name support"
 	depends on PROC_FS && ADVISE_SYSCALLS && MMU
diff --git a/mm/gup.c b/mm/gup.c
index 54d0dc3831fb..6c2c6a0cbe2a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1076,7 +1076,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 	struct follow_page_context ctx = { NULL };
 	struct page *page;
 
-	if (vma_is_secretmem(vma))
+	if (!can_access_secretmem_vma(vma))
 		return NULL;
 
 	if (WARN_ON_ONCE(foll_flags & FOLL_PIN))
@@ -1281,7 +1281,7 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
 		return -EOPNOTSUPP;
 
-	if (vma_is_secretmem(vma))
+	if (!can_access_secretmem_vma(vma))
 		return -EFAULT;
 
 	if (write) {
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 3afb5ad701e1..86afedc65889 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -13,13 +13,17 @@
 #include <linux/bitops.h>
 #include <linux/printk.h>
 #include <linux/pagemap.h>
+#include <linux/hugetlb.h>
 #include <linux/syscalls.h>
 #include <linux/pseudo_fs.h>
 #include <linux/secretmem.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/mm.h>
 
+#include <uapi/asm-generic/mman-common.h>
 #include <uapi/linux/magic.h>
+#include <uapi/linux/mman.h>
 
 #include <asm/tlbflush.h>
 
@@ -42,6 +46,16 @@ MODULE_PARM_DESC(secretmem_enable,
 
 static atomic_t secretmem_users;
 
+/* secretmem file private context */
+struct secretmem_ctx {
+	struct secretmem_area _area;
+	struct page **_pages;
+	unsigned long _nr_pages;
+	struct file *_file;
+	struct mm_struct *_mm;
+};
+
+
 bool secretmem_active(void)
 {
 	return !!atomic_read(&secretmem_users);
@@ -116,6 +130,7 @@ static const struct vm_operations_struct secretmem_vm_ops = {
 
 static int secretmem_release(struct inode *inode, struct file *file)
 {
+	kfree(file->private_data);
 	atomic_dec(&secretmem_users);
 	return 0;
 }
@@ -123,13 +138,23 @@ static int secretmem_release(struct inode *inode, struct file *file)
 static int secretmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	unsigned long len = vma->vm_end - vma->vm_start;
+	struct secretmem_ctx *ctx = file->private_data;
+	unsigned long kernel_no_permissions;
+
+	kernel_no_permissions = (VM_READ | VM_WRITE | VM_EXEC | VM_MAYEXEC);
 
 	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
 		return -EINVAL;
 
+	if (ctx && (vma->vm_flags & kernel_no_permissions))
+		return -EINVAL;
+
 	if (!mlock_future_ok(vma->vm_mm, vma->vm_flags | VM_LOCKED, len))
 		return -EAGAIN;
 
+	if (ctx)
+		vm_flags_set(vma, VM_MIXEDMAP);
+
 	vm_flags_set(vma, VM_LOCKED | VM_DONTDUMP);
 	vma->vm_ops = &secretmem_vm_ops;
 
@@ -230,6 +255,194 @@ static struct file *secretmem_file_create(unsigned long flags)
 	return file;
 }
 
+#ifdef CONFIG_KERNEL_SECRETMEM
+
+struct secretmem_area *secretmem_allocate_pages(unsigned int order)
+{
+	unsigned long uvaddr, uvaddr_inc, unused, nr_pages, bytes_length;
+	struct file *kernel_secfile;
+	struct vm_area_struct *vma;
+	struct secretmem_ctx *ctx;
+	struct page **sec_pages;
+	struct mm_struct *mm;
+	long nr_pinned_pages;
+	pte_t pte, old_pte;
+	spinlock_t *ptl;
+	pte_t *upte;
+	int rc;
+
+	nr_pages = (1 << order);
+	bytes_length = nr_pages * PAGE_SIZE;
+	mm = current->mm;
+
+	if (!mm || !mmget_not_zero(mm))
+		return NULL;
+
+	/* Create secret memory file / truncate it */
+	kernel_secfile = secretmem_file_create(0);
+	if (IS_ERR(kernel_secfile))
+		goto put_mm;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (IS_ERR(ctx))
+		goto close_secfile;
+	kernel_secfile->private_data = ctx;
+
+	rc = do_truncate(file_mnt_idmap(kernel_secfile),
+			 file_dentry(kernel_secfile), bytes_length, 0, NULL);
+	if (rc)
+		goto close_secfile;
+
+	if (mmap_write_lock_killable(mm))
+		goto close_secfile;
+
+	/* Map pages to the secretmem file */
+	uvaddr = do_mmap(kernel_secfile, 0, bytes_length, PROT_NONE,
+			 MAP_SHARED, 0, 0, &unused, NULL);
+	if (IS_ERR_VALUE(uvaddr))
+		goto unlock_mmap;
+
+	/* mseal() the VMA to make sure it won't change */
+	rc = do_mseal(uvaddr, uvaddr + bytes_length, true);
+	if (rc)
+		goto unmap_pages;
+
+	/* Make sure VMA is there, and is kernel-secure */
+	vma = find_vma(current->mm, uvaddr);
+	if (!vma)
+		goto unseal_vma;
+
+	if (!vma_is_secretmem(vma) ||
+	    !can_access_secretmem_vma(vma))
+		goto unseal_vma;
+
+	/* Pin user pages; fault them in */
+	sec_pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_KERNEL);
+	if (!sec_pages)
+		goto unseal_vma;
+
+	nr_pinned_pages = pin_user_pages(uvaddr, nr_pages, FOLL_FORCE | FOLL_LONGTERM, sec_pages);
+	if (nr_pinned_pages < 0)
+		goto free_sec_pages;
+	if (nr_pinned_pages != nr_pages)
+		goto unpin_pages;
+
+	/* Modify the existing mapping to be kernel accessible, local to this process mm */
+	uvaddr_inc = uvaddr;
+	while (uvaddr_inc < uvaddr + bytes_length) {
+		upte = get_locked_pte(mm, uvaddr_inc, &ptl);
+		if (!upte)
+			goto unpin_pages;
+		old_pte = ptep_modify_prot_start(vma, uvaddr_inc, upte);
+		pte = pte_modify(old_pte, PAGE_KERNEL);
+		ptep_modify_prot_commit(vma, uvaddr_inc, upte, old_pte, pte);
+		pte_unmap_unlock(upte, ptl);
+		uvaddr_inc += PAGE_SIZE;
+	}
+	flush_tlb_range(vma, uvaddr, uvaddr + bytes_length);
+
+	/* Return data */
+	mmgrab(mm);
+	ctx->_area.ptr = (void *) uvaddr;
+	ctx->_pages = sec_pages;
+	ctx->_nr_pages = nr_pages;
+	ctx->_mm = mm;
+	ctx->_file = kernel_secfile;
+
+	mmap_write_unlock(mm);
+	mmput(mm);
+
+	return &ctx->_area;
+
+unpin_pages:
+	unpin_user_pages(sec_pages, nr_pinned_pages);
+free_sec_pages:
+	kfree(sec_pages);
+unseal_vma:
+	rc = do_mseal(uvaddr, uvaddr + bytes_length, false);
+	if (rc)
+		BUG();
+unmap_pages:
+	rc = do_munmap(mm, uvaddr, bytes_length, NULL);
+	if (rc)
+		BUG();
+unlock_mmap:
+	mmap_write_unlock(mm);
+close_secfile:
+	fput(kernel_secfile);
+put_mm:
+	mmput(mm);
+	return NULL;
+}
+
+void secretmem_release_pages(struct secretmem_area *data)
+{
+	unsigned long uvaddr, bytes_length;
+	struct secretmem_ctx *ctx;
+	int rc;
+
+	if (!data || !data->ptr)
+		BUG();
+
+	ctx = container_of(data, struct secretmem_ctx, _area);
+	if (!ctx || !ctx->_file || !ctx->_pages || !ctx->_mm)
+		BUG();
+
+	bytes_length = ctx->_nr_pages * PAGE_SIZE;
+	uvaddr = (unsigned long) data->ptr;
+
+	/*
+	 * Remove the mapping if mm is still in use.
+	 * Not secure to continue if unmapping failed.
+	 */
+	if (mmget_not_zero(ctx->_mm)) {
+		mmap_write_lock(ctx->_mm);
+		rc = do_mseal(uvaddr, uvaddr + bytes_length, false);
+		if (rc) {
+			mmap_write_unlock(ctx->_mm);
+			BUG();
+		}
+		rc = do_munmap(ctx->_mm, uvaddr, bytes_length, NULL);
+		if (rc) {
+			mmap_write_unlock(ctx->_mm);
+			BUG();
+		}
+		mmap_write_unlock(ctx->_mm);
+		mmput(ctx->_mm);
+	}
+
+	mmdrop(ctx->_mm);
+	unpin_user_pages(ctx->_pages, ctx->_nr_pages);
+	fput(ctx->_file);
+	kfree(ctx->_pages);
+
+	ctx->_nr_pages = 0;
+	ctx->_pages = NULL;
+	ctx->_file = NULL;
+	ctx->_mm = NULL;
+	ctx->_area.ptr = NULL;
+}
+
+bool can_access_secretmem_vma(struct vm_area_struct *vma)
+{
+	struct secretmem_ctx *ctx;
+
+	if (!vma_is_secretmem(vma))
+		return true;
+
+	/*
+	 * If VMA is owned by running process, and marked for kernel
+	 * usage, then allow access.
+	 */
+	ctx = vma->vm_file->private_data;
+	if (ctx && current->mm == vma->vm_mm)
+		return true;
+
+	return false;
+}
+
+#endif /* CONFIG_KERNEL_SECRETMEM */
+
 SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
 {
 	struct file *file;
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

