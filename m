Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D54247CA8B;
	Wed, 23 Sep 2026 09:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157575; cv=none; b=GzVbIplzyHS+HIlcKRoYW7vEWrGIo6Rr0yJpwJ+p+QhKnLAP5kaG9TjDcG9m4+Rvm3xj5/D2IAF3gYl1ugybrN9Wu41LlyC7vMVIlyzA55Sye/mfqliS8awlhLwweTzkfreM3Fk8nhlVR6CMd6oYPcx2IGDRnHiNvD18sHHjmOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157575; c=relaxed/simple;
	bh=mpAuMFhBmyJnMWABt7F3BE4AWwLPMCL1Z7ICe8ORsu4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RpsdwcWmw6b3MEXu6CwF75CkDRweca0XvrlMbwJTgC0oqOPpqleMdHIRbFsLKhJepmEXF17TSDXmMUWcQi1Npn0x+OCHjDcHvIU5zsMtD0IyO/+UlwGXtI6o4pemfch6LR0konFqH7gueO1culZ5CKYlGirsd4USKSzrao2zdmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VpbxY1RO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VpbxY1RO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F26A1F00893;
	Wed, 23 Sep 2026 09:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790157572;
	bh=/Dq4C/pVHuDUoiKztfYPDatcpJDPl1j7cKm8JIbK0bQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VpbxY1ROYD0ULQgZS7i2CN1mUFOgAp3faj3NKoX1N3wrq5ZMhMSsoUPVB55tXVCcf
	 Fubu3/FBkgC8wzWnEg0QxLAmpYYCN6st9cEXpmjPSThJHwo+aSyBb4QKrkrWwEoUqk
	 li4JmELZ5+CpCMqEIqBiVeVfMGVjX6OW1NJ2EzPsJMYgNBaMkmHzOo/T/vOb3aQyR7
	 mLXCOfZixIydD5wUfmXwJIbnR+jRnx7Z/CuxH0WjmI5JF0jWkQOq7mSPmxQ8mT5o9j
	 79rjZ6LWHTKc/fosHxZ+9/6QjdygUFT7+o223mnVZhJIdrSYNfTxpk041Qpy0sDrkj
	 Jd4hrx8NJ+qNw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
In-Reply-To: <arOfD6syXOgQhZYA@arm.com>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com> <yq5aik3w344o.fsf@kernel.org>
 <arOfD6syXOgQhZYA@arm.com>
Date: Wed, 23 Sep 2026 15:29:22 +0530
Message-ID: <yq5aa4p82sqt.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Wed, Sep 23, 2026 at 11:23:27AM +0530, Aneesh Kumar K.V wrote:
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>> > On Mon, Sep 21, 2026 at 08:18:36PM +0530, Aneesh Kumar K.V (Arm) wrote:

 [ ... 79 lines skipped ... ] 

>
> On pKVM, we want set_memory_decrypted() to zero the buffer
> before the host can access it (I guess currently relying on __GFP_ZERO
> allocations). Since no cryptographic encryption takes place, there's not
> much point in memset'ing again after the operation as the content was
> already zeroed.
>
> I don't think cc_make_shared() has the right information on how to
> safely and efficiently do the zeroing. That's only known to the
> set_memory_* backend. So you'd have to propagate the flag down.
>


This is my attempt to do that using Codex. Quite a few paths already
call memset() outside set_memory_decrypted(), and there is a fixup
series for the ITS and other paths here:

https://lore.kernel.org/all/c25502d3-35c6-4281-a9ec-856f789fb1b4@arm.com

commit 0317b02d6759a8b55e9ec854e15b5b94025800e3
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Date:   Wed Sep 23 11:09:40 2026 +0530

    mm: Add zeroing support to shared memory transitions
    
    Architectures need to zero memory at different points in a private-to-shared
    transition.  For example, pKVM needs to clear the memory before sharing it,
    while Arm CCA needs to clear it after the RSI transition has completed.
    
    Add CC_SHARED_ZERO to cc_make_shared() and pass it through
    set_memory_decrypted() so each architecture or platform can select the safe
    ordering.  Thread the flag through the arm64 memory-encryption operations and
    the x86 encryption-status hooks.  Clear memory immediately before sharing in
    the other implementations, while keeping CCA zeroing after a successful RSI
    transition.
    
    Keep allocations on platforms without memory encryption on the ordinary page
    allocator path so the original GFP constraints, including __GFP_ZERO, remain
    intact.  Callers that need zero-filled memory request zeroing as part of an
    actual transition and explicitly clear the memory when no transition is
    needed.  This also removes redundant post-transition memset() calls where the
    transition now provides that guarantee.
    
    Assisted-by: Codex:gpt-5

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index 636f45b4d8af..cf8dd5e84c86 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -9,14 +9,13 @@ struct device;
 
 struct arm64_mem_crypt_ops {
 	int (*encrypt)(unsigned long addr, int numpages);
-	int (*decrypt)(unsigned long addr, int numpages);
+	int (*decrypt)(unsigned long addr, int numpages, unsigned int flags);
 };
 
 int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
-int set_memory_decrypted(unsigned long addr, int numpages);
-
+int set_memory_decrypted(unsigned long addr, int numpages, unsigned int flags);
 int realm_register_memory_enc_ops(void);
 
 static inline bool force_dma_unencrypted(struct device *dev)
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..10278a7ba5a9 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -17,6 +17,6 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
-int set_memory_decrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages, unsigned int flags);
 
 #endif /* _ASM_ARM64_SET_MEMORY_H */
diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
index ee3c0ab04384..4da91f73a620 100644
--- a/arch/arm64/mm/mem_encrypt.c
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -40,11 +40,11 @@ int set_memory_encrypted(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
-int set_memory_decrypted(unsigned long addr, int numpages)
+int set_memory_decrypted(unsigned long addr, int numpages, unsigned int flags)
 {
 	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
 		return 0;
 
-	return crypt_ops->decrypt(addr, numpages);
+	return crypt_ops->decrypt(addr, numpages, flags);
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..f565996efbef 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/pagewalk.h>
+#include <linux/cc_shared.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -335,10 +336,14 @@ static int realm_set_memory_encrypted(unsigned long addr, int numpages)
 	return ret;
 }
 
-static int realm_set_memory_decrypted(unsigned long addr, int numpages)
+static int realm_set_memory_decrypted(unsigned long addr, int numpages,
+				      unsigned int flags)
 {
 	int ret = __set_memory_enc_dec(addr, numpages, false);
 
+	if (!ret && (flags & CC_SHARED_ZERO))
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	WARN(ret, "Failed to decrypt memory, %d pages will be leaked",
 	     numpages);
 
diff --git a/arch/powerpc/include/asm/mem_encrypt.h b/arch/powerpc/include/asm/mem_encrypt.h
index e355ca46fad9..e03c90d70d3c 100644
--- a/arch/powerpc/include/asm/mem_encrypt.h
+++ b/arch/powerpc/include/asm/mem_encrypt.h
@@ -19,6 +19,6 @@ static inline bool force_dma_unencrypted(struct device *dev)
 }
 
 int set_memory_encrypted(unsigned long addr, int numpages);
-int set_memory_decrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages, unsigned int flags);
 
 #endif /* _ASM_POWERPC_MEM_ENCRYPT_H */
diff --git a/arch/powerpc/platforms/pseries/svm.c b/arch/powerpc/platforms/pseries/svm.c
index 7a403dbd35ee..46e940b40752 100644
--- a/arch/powerpc/platforms/pseries/svm.c
+++ b/arch/powerpc/platforms/pseries/svm.c
@@ -9,7 +9,9 @@
 #include <linux/mm.h>
 #include <linux/memblock.h>
 #include <linux/mem_encrypt.h>
+#include <linux/string.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 #include <asm/machdep.h>
 #include <asm/svm.h>
 #include <asm/swiotlb.h>
@@ -51,7 +53,7 @@ int set_memory_encrypted(unsigned long addr, int numpages)
 	return 0;
 }
 
-int set_memory_decrypted(unsigned long addr, int numpages)
+int set_memory_decrypted(unsigned long addr, int numpages, unsigned int flags)
 {
 	if (!cc_platform_has(CC_ATTR_MEM_ENCRYPT))
 		return 0;
@@ -59,6 +61,8 @@ int set_memory_decrypted(unsigned long addr, int numpages)
 	if (!PAGE_ALIGNED(addr))
 		return -EINVAL;
 
+	if (flags & CC_SHARED_ZERO)
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 	uv_share_page(PHYS_PFN(__pa(addr)), numpages);
 
 	return 0;
diff --git a/arch/s390/include/asm/mem_encrypt.h b/arch/s390/include/asm/mem_encrypt.h
index 28c83ec1f243..97813680093c 100644
--- a/arch/s390/include/asm/mem_encrypt.h
+++ b/arch/s390/include/asm/mem_encrypt.h
@@ -5,7 +5,7 @@
 #ifndef __ASSEMBLER__
 
 int set_memory_encrypted(unsigned long vaddr, int numpages);
-int set_memory_decrypted(unsigned long vaddr, int numpages);
+int set_memory_decrypted(unsigned long vaddr, int numpages, unsigned int flags);
 
 #endif	/* __ASSEMBLER__ */
 
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index be7e009e7b59..b7aaba663889 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -51,6 +51,7 @@
 #include <linux/virtio_config.h>
 #include <linux/execmem.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 
 pgd_t swapper_pg_dir[PTRS_PER_PGD] __section(".bss..swapper_pg_dir");
 pgd_t invalid_pg_dir[PTRS_PER_PGD] __section(".bss..invalid_pg_dir");
@@ -126,9 +127,13 @@ int set_memory_encrypted(unsigned long vaddr, int numpages)
 	return 0;
 }
 
-int set_memory_decrypted(unsigned long vaddr, int numpages)
+int set_memory_decrypted(unsigned long vaddr, int numpages, unsigned int flags)
 {
 	int i;
+
+	if (flags & CC_SHARED_ZERO)
+		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	/* make specified pages shared (swiotlb, dma_alloca) */
 	for (i = 0; i < numpages; ++i) {
 		uv_set_shared(virt_to_phys((void *)vaddr));
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index cc292d7c6fd1..249054d53915 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1497,7 +1497,8 @@ static void *alloc_shared_pages(size_t sz)
 	if (!page)
 		return NULL;
 
-	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
+	ret = set_memory_decrypted((unsigned long)page_address(page), npages,
+				   0);
 	if (ret) {
 		pr_err("failed to mark page shared, ret=%d\n", ret);
 		__free_pages(page, get_order(sz));
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index f904a636d449..748e4d19b15e 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -5,6 +5,7 @@
 #define pr_fmt(fmt)     "tdx: " fmt
 
 #include <linux/cpufeature.h>
+#include <linux/cc_shared.h>
 #include <linux/export.h>
 #include <linux/io.h>
 #include <linux/kexec.h>
@@ -976,8 +977,11 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
 }
 
 static int tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
-					 bool enc)
+					 bool enc, unsigned int flags)
 {
+	if (!enc && (flags & CC_SHARED_ZERO))
+		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	/*
 	 * Only handle shared->private conversion here.
 	 * See the comment in tdx_early_init().
@@ -989,7 +993,7 @@ static int tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
 }
 
 static int tdx_enc_status_change_finish(unsigned long vaddr, int numpages,
-					 bool enc)
+					 bool enc, unsigned int flags)
 {
 	/*
 	 * Only handle private->shared conversion here.
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 0b4a1c0b0b16..9f5113868c7a 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/types.h>
 #include <linux/bitfield.h>
+#include <linux/cc_shared.h>
 #include <linux/io.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
@@ -156,8 +157,11 @@ static int hv_cpu_init(unsigned int cpu)
 			 * page in non-root partition here.
 			 */
 			if (*hvp && !ms_hyperv.paravisor_present && hv_isolation_type_snp()) {
-				WARN_ON_ONCE(set_memory_decrypted((unsigned long)(*hvp), 1));
-				memset(*hvp, 0, PAGE_SIZE);
+				int ret;
+
+				ret = set_memory_decrypted((unsigned long)*hvp, 1,
+							   CC_SHARED_ZERO);
+				WARN_ON_ONCE(ret);
 			}
 		}
 
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 2ce4dfe53472..104e45d4605d 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/cc_shared.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
@@ -753,8 +754,13 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
  * transition is complete, hv_vtom_set_host_visibility() marks the pages
  * as "present" again.
  */
-static int hv_vtom_clear_present(unsigned long kbuffer, int pagecount, bool enc)
+static int hv_vtom_clear_present(unsigned long kbuffer, int pagecount, bool enc,
+				 unsigned int flags)
 {
+	if (!enc && (flags & CC_SHARED_ZERO))
+		memset((void *)kbuffer, 0,
+		       (size_t)pagecount << PAGE_SHIFT);
+
 	return set_memory_np(kbuffer, pagecount);
 }
 
@@ -766,7 +772,8 @@ static int hv_vtom_clear_present(unsigned long kbuffer, int pagecount, bool enc)
  * with host. This function works as wrap of hv_mark_gpa_visibility()
  * with memory base and size.
  */
-static int hv_vtom_set_host_visibility(unsigned long kbuffer, int pagecount, bool enc)
+static int hv_vtom_set_host_visibility(unsigned long kbuffer, int pagecount,
+				       bool enc, unsigned int flags)
 {
 	enum hv_mem_host_visibility visibility = enc ?
 			VMBUS_PAGE_NOT_VISIBLE : VMBUS_PAGE_VISIBLE_READ_WRITE;
@@ -816,7 +823,6 @@ static int hv_vtom_set_host_visibility(unsigned long kbuffer, int pagecount, boo
 	err = set_memory_p(kbuffer, pagecount);
 	if (err && !ret)
 		ret = err;
-
 	return ret;
 }
 
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4362c26aa992..117f8ae05fee 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -51,7 +51,7 @@ int set_memory_4k(unsigned long addr, int numpages);
 
 bool set_memory_enc_stop_conversion(void);
 int set_memory_encrypted(unsigned long addr, int numpages);
-int set_memory_decrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages, unsigned int flags);
 
 int set_memory_np_noalias(unsigned long addr, int numpages);
 int set_memory_nonglobal(unsigned long addr, int numpages);
diff --git a/arch/x86/include/asm/vga.h b/arch/x86/include/asm/vga.h
index 46f9b2deab4d..b71311270b21 100644
--- a/arch/x86/include/asm/vga.h
+++ b/arch/x86/include/asm/vga.h
@@ -22,7 +22,7 @@
 	unsigned long start = (unsigned long)phys_to_virt(x);	\
 								\
 	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))			\
-		set_memory_decrypted(start, (s) >> PAGE_SHIFT);	\
+		set_memory_decrypted(start, (s) >> PAGE_SHIFT, 0);	\
 								\
 	start;							\
 })
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 953d3199408a..a10de48b27d4 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -162,8 +162,10 @@ struct x86_init_acpi {
  *				and with interrupts disabled.
  */
 struct x86_guest {
-	int (*enc_status_change_prepare)(unsigned long vaddr, int npages, bool enc);
-	int (*enc_status_change_finish)(unsigned long vaddr, int npages, bool enc);
+	int (*enc_status_change_prepare)(unsigned long vaddr, int npages, bool enc,
+					 unsigned int flags);
+	int (*enc_status_change_finish)(unsigned long vaddr, int npages, bool enc,
+					unsigned int flags);
 	bool (*enc_tlb_flush_required)(bool enc);
 	bool (*enc_cache_flush_required)(void);
 	void (*enc_kexec_begin)(void);
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index cb3d0ca1fa22..4e87c0657db9 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -248,17 +248,17 @@ static void __init kvmclock_init_mem(void)
 	 * be mapped decrypted.
 	 */
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
-		r = set_memory_decrypted((unsigned long) hvclock_mem,
-					 1UL << order);
+		r = set_memory_decrypted((unsigned long)hvclock_mem,
+					 1UL << order, CC_SHARED_ZERO);
 		if (r) {
 			__free_pages(p, order);
 			hvclock_mem = NULL;
 			pr_warn("kvmclock: set_memory_decrypted() failed. Disabling\n");
 			return;
 		}
+	} else {
+		memset(hvclock_mem, 0, PAGE_SIZE << order);
 	}
-
-	memset(hvclock_mem, 0, PAGE_SIZE << order);
 }
 
 static int __init kvm_setup_vsyscall_timeinfo(void)
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index c3f4a389992d..3fe4cdc265d1 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/efi.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 
 #include <asm/init.h>
 #include <asm/tlbflush.h>
@@ -693,7 +694,8 @@ int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages, gfp_t gfp)
 	 * pages are not encrypted because when we boot to the new kernel the
 	 * pages won't be accessed encrypted (initially).
 	 */
-	return set_memory_decrypted((unsigned long)vaddr, pages);
+	return set_memory_decrypted((unsigned long)vaddr, pages,
+				    gfp & __GFP_ZERO ? CC_SHARED_ZERO : 0);
 }
 
 void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages)
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 252c5827d063..187e2a888c32 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -138,8 +138,17 @@ struct x86_cpuinit_ops x86_cpuinit = {
 
 static void default_nmi_init(void) { };
 
-static int enc_status_change_prepare_noop(unsigned long vaddr, int npages, bool enc) { return 0; }
-static int enc_status_change_finish_noop(unsigned long vaddr, int npages, bool enc) { return 0; }
+static int enc_status_change_prepare_noop(unsigned long vaddr, int npages, bool enc,
+					  unsigned int flags)
+{
+	return 0;
+}
+
+static int enc_status_change_finish_noop(unsigned long vaddr, int npages, bool enc,
+					 unsigned int flags)
+{
+	return 0;
+}
 static bool enc_tlb_flush_required_noop(bool enc) { return false; }
 static bool enc_cache_flush_required_noop(void) { return false; }
 static void enc_kexec_begin_noop(void) {}
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 064ecc33b926..8fdec6c8090d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6852,7 +6852,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, struct k
 	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
 	 */
 	if (!tdp_enabled)
-		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
+		set_memory_decrypted((unsigned long)mmu->pae_root, 1, 0);
 	else
 		WARN_ON_ONCE(shadow_me_value);
 
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 2f8c32173972..ba3cfb89d155 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -13,11 +13,13 @@
 #include <linux/dma-direct.h>
 #include <linux/swiotlb.h>
 #include <linux/mem_encrypt.h>
+#include <linux/string.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 #include <linux/cc_platform.h>
+#include <linux/cc_shared.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -283,8 +285,12 @@ static void enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc)
 #endif
 }
 
-static int amd_enc_status_change_prepare(unsigned long vaddr, int npages, bool enc)
+static int amd_enc_status_change_prepare(unsigned long vaddr, int npages,
+					 bool enc, unsigned int flags)
 {
+	if (!enc && (flags & CC_SHARED_ZERO))
+		memset((void *)vaddr, 0, (size_t)npages << PAGE_SHIFT);
+
 	/*
 	 * To maintain the security guarantees of SEV-SNP guests, make sure
 	 * to invalidate the memory before encryption attribute is cleared.
@@ -296,7 +302,8 @@ static int amd_enc_status_change_prepare(unsigned long vaddr, int npages, bool e
 }
 
 /* Return true unconditionally: return value doesn't matter for the SEV side */
-static int amd_enc_status_change_finish(unsigned long vaddr, int npages, bool enc)
+static int amd_enc_status_change_finish(unsigned long vaddr, int npages, bool enc,
+					unsigned int flags)
 {
 	/*
 	 * After memory is mapped encrypted in the page table, validate it
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 4652487b5572..81be379f43b1 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2420,7 +2420,8 @@ int set_memory_global(unsigned long addr, int numpages)
  * __set_memory_enc_pgtable() is used for the hypervisors that get
  * informed about "encryption" status via page tables.
  */
-static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
+static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc,
+				    unsigned int flags)
 {
 	pgprot_t empty = __pgprot(0);
 	struct cpa_data cpa;
@@ -2446,7 +2447,8 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 		cpa_flush(&cpa, x86_platform.guest.enc_cache_flush_required());
 
 	/* Notify hypervisor that we are about to set/clr encryption attribute. */
-	ret = x86_platform.guest.enc_status_change_prepare(addr, numpages, enc);
+	ret = x86_platform.guest.enc_status_change_prepare(addr, numpages, enc,
+							  flags);
 	if (ret)
 		goto vmm_fail;
 
@@ -2465,7 +2467,8 @@ static int __set_memory_enc_pgtable(unsigned long addr, int numpages, bool enc)
 		return ret;
 
 	/* Notify hypervisor that we have successfully set/clr encryption attribute. */
-	ret = x86_platform.guest.enc_status_change_finish(addr, numpages, enc);
+	ret = x86_platform.guest.enc_status_change_finish(addr, numpages, enc,
+							 flags);
 	if (ret)
 		goto vmm_fail;
 
@@ -2506,7 +2509,8 @@ bool set_memory_enc_stop_conversion(void)
 	return true;
 }
 
-static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
+static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc,
+				unsigned int flags)
 {
 	int ret = 0;
 
@@ -2514,7 +2518,7 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 		if (!down_read_trylock(&mem_enc_lock))
 			return -EBUSY;
 
-		ret = __set_memory_enc_pgtable(addr, numpages, enc);
+		ret = __set_memory_enc_pgtable(addr, numpages, enc, flags);
 
 		up_read(&mem_enc_lock);
 	}
@@ -2524,13 +2528,13 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 
 int set_memory_encrypted(unsigned long addr, int numpages)
 {
-	return __set_memory_enc_dec(addr, numpages, true);
+	return __set_memory_enc_dec(addr, numpages, true, 0);
 }
 EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
-int set_memory_decrypted(unsigned long addr, int numpages)
+int set_memory_decrypted(unsigned long addr, int numpages, unsigned int flags)
 {
-	return __set_memory_enc_dec(addr, numpages, false);
+	return __set_memory_enc_dec(addr, numpages, false, flags);
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
 
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 694d80a5c68e..1e15fb863927 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -111,7 +111,8 @@ static void __init setup_real_mode(void)
 	 * successfully. This is not needed for SEV.
 	 */
 	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
-		set_memory_decrypted((unsigned long)base, size >> PAGE_SHIFT);
+		set_memory_decrypted((unsigned long)base, size >> PAGE_SHIFT,
+				     0);
 
 	memcpy(base, real_mode_blob, size);
 
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 7e4cc6f55237..09f7ac96e475 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -474,7 +474,7 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 		 * on the free list.
 		 */
 		ret = set_memory_decrypted((unsigned long)kbuffer,
-					PFN_UP(size));
+					   PFN_UP(size), 0);
 		if (ret) {
 			dev_warn(&channel->device_obj->device,
 				"Failed to set host visibility for new GPADL %d.\n",
@@ -727,7 +727,7 @@ void *vmbus_alloc_buffer(struct vmbus_channel *channel,
 		}
 
 		ret = set_memory_decrypted((unsigned long)page_address(page),
-					   1U << order);
+					   1U << order, 0);
 		if (ret) {
 			/*
 			 * set_memory_decrypted() failed; the page state is
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 1ab3581b096a..cc9f73903c2f 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
+#include <linux/cc_platform.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -263,29 +264,27 @@ int vmbus_connect(void)
 		goto cleanup;
 	}
 
-	ret = set_memory_decrypted((unsigned long)
-				vmbus_connection.monitor_pages[0], 1);
-	ret |= set_memory_decrypted((unsigned long)
-				vmbus_connection.monitor_pages[1], 1);
-	if (ret) {
-		/*
-		 * If set_memory_decrypted() fails, the encryption state
-		 * of the memory is unknown. So leak the memory instead
-		 * of risking returning decrypted memory to the free list.
-		 * For simplicity, always handle both pages the same.
-		 */
-		vmbus_connection.monitor_pages[0] = NULL;
-		vmbus_connection.monitor_pages[1] = NULL;
-		goto cleanup;
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		ret = set_memory_decrypted((unsigned long)vmbus_connection.monitor_pages[0],
+					   1, CC_SHARED_ZERO);
+		ret |= set_memory_decrypted((unsigned long)vmbus_connection.monitor_pages[1],
+					    1, CC_SHARED_ZERO);
+		if (ret) {
+			/*
+			 * If set_memory_decrypted() fails, the encryption state
+			 * of the memory is unknown. So leak the memory instead
+			 * of risking returning decrypted memory to the free list.
+			 * For simplicity, always handle both pages the same.
+			 */
+			vmbus_connection.monitor_pages[0] = NULL;
+			vmbus_connection.monitor_pages[1] = NULL;
+			goto cleanup;
+		}
+	} else {
+		memset(vmbus_connection.monitor_pages[0], 0, HV_HYP_PAGE_SIZE);
+		memset(vmbus_connection.monitor_pages[1], 0, HV_HYP_PAGE_SIZE);
 	}
 
-	/*
-	 * Set_memory_decrypted() will change the memory contents if
-	 * decryption occurs, so zero monitor pages here.
-	 */
-	memset(vmbus_connection.monitor_pages[0], 0x00, HV_HYP_PAGE_SIZE);
-	memset(vmbus_connection.monitor_pages[1], 0x00, HV_HYP_PAGE_SIZE);
-
 	msginfo = kzalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_initiate_contact),
 			  GFP_KERNEL);
diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index fe50090dcc01..f675fe90b78d 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -123,12 +123,14 @@ static int hv_alloc_page(void **page, bool decrypt, const char *note)
 	if (!*page)
 		return -ENOMEM;
 
-	if (decrypt)
-		ret = set_memory_decrypted((unsigned long)*page, 1);
-	if (ret)
-		goto failed;
-
-	memset(*page, 0, PAGE_SIZE);
+	if (decrypt) {
+		ret = set_memory_decrypted((unsigned long)*page, 1,
+					   CC_SHARED_ZERO);
+		if (ret)
+			goto failed;
+	} else {
+		memset(*page, 0, PAGE_SIZE);
+	}
 	return 0;
 
 failed:
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 31256cb22b39..84c950bd82b0 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -500,13 +500,13 @@ int hv_common_cpu_init(unsigned int cpu)
 
 		if (!ms_hyperv.paravisor_present &&
 		    (hv_isolation_type_snp() || hv_isolation_type_tdx())) {
-			ret = set_memory_decrypted((unsigned long)mem, pgcount);
+			ret = set_memory_decrypted((unsigned long)mem,
+						   pgcount,
+						   CC_SHARED_ZERO);
 			if (ret) {
 				/* It may be unsafe to free 'mem' */
 				return ret;
 			}
-
-			memset(mem, 0x00, pgcount * HV_HYP_PAGE_SIZE);
 		}
 
 		/*
diff --git a/drivers/ptp/ptp_kvm_x86.c b/drivers/ptp/ptp_kvm_x86.c
index 6cea4fe39bcf..9b0558af9a8e 100644
--- a/drivers/ptp/ptp_kvm_x86.c
+++ b/drivers/ptp/ptp_kvm_x86.c
@@ -34,7 +34,8 @@ int kvm_arch_ptp_init(void)
 			return -ENOMEM;
 
 		clock_pair = page_address(p);
-		ret = set_memory_decrypted((unsigned long)clock_pair, 1);
+		ret = set_memory_decrypted((unsigned long)clock_pair, 1,
+					   CC_SHARED_ZERO);
 		if (ret) {
 			__free_page(p);
 			clock_pair = NULL;
diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
index 26fe9c3f22e3..87b6dbb468de 100644
--- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
+++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -9,10 +9,12 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/array_size.h>
+#include <linux/cc_shared.h>
 #include <linux/io.h>
 #include <linux/mem_encrypt.h>
 #include <linux/mm.h>
 #include <linux/pgtable.h>
+#include <linux/string.h>
 
 #include <asm/hypervisor.h>
 
@@ -59,8 +61,12 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
 				  addr, numpages);
 }
 
-static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
+static int pkvm_set_memory_decrypted(unsigned long addr, int numpages,
+				     unsigned int flags)
 {
+	if (flags & CC_SHARED_ZERO)
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
 				  addr, numpages);
 }
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 935537a41469..3943c163965d 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -216,7 +216,8 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 		return -ENOMEM;
 
 	pfn = PHYS_PFN(virt_to_phys(req.certs_data));
-	ret = set_memory_decrypted((unsigned long)req.certs_data, npages);
+	ret = set_memory_decrypted((unsigned long)req.certs_data, npages,
+				   CC_SHARED_ZERO);
 	if (ret) {
 		pr_err("failed to mark page shared, ret=%d\n", ret);
 		snp_leak_pages(pfn, npages);
diff --git a/drivers/virt/coco/tdx-guest/tdx-guest.c b/drivers/virt/coco/tdx-guest/tdx-guest.c
index d0303e31e816..db898564cfcf 100644
--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
@@ -232,7 +232,7 @@ static void *alloc_quote_buf(void)
 	if (!addr)
 		return NULL;
 
-	if (set_memory_decrypted((unsigned long)addr, count))
+	if (set_memory_decrypted((unsigned long)addr, count, CC_SHARED_ZERO))
 		return NULL;
 
 	return addr;
diff --git a/include/linux/cc_shared.h b/include/linux/cc_shared.h
index 5f8db7c468c5..35be90246b88 100644
--- a/include/linux/cc_shared.h
+++ b/include/linux/cc_shared.h
@@ -2,11 +2,15 @@
 #ifndef _LINUX_CC_SHARED_H
 #define _LINUX_CC_SHARED_H
 
+#include <linux/bits.h>
 #include <linux/gfp_types.h>
 #include <linux/types.h>
 
 struct page;
 
+/* Zero the range at an architecture-appropriate point while sharing it. */
+#define CC_SHARED_ZERO	BIT(0)
+
 struct cc_shared_pages {
 	struct page *page;
 	size_t shared_size;
@@ -28,7 +32,7 @@ size_t arch_cc_shared_granule_size(void);
 size_t cc_shared_granule_size(void);
 int cc_shared_calc_layout(size_t requested, struct cc_shared_layout *layout);
 bool cc_shared_range_valid(phys_addr_t base, size_t size);
-int cc_make_shared(void *addr, size_t size);
+int cc_make_shared(void *addr, size_t size, unsigned int flags);
 int cc_make_private(void *addr, size_t size);
 int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 		size_t requested, struct cc_shared_pages *mem);
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..a52713f3510c 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -5,6 +5,8 @@
 #ifndef _LINUX_SET_MEMORY_H_
 #define _LINUX_SET_MEMORY_H_
 
+#include <linux/cc_shared.h>
+
 #ifdef CONFIG_ARCH_HAS_SET_MEMORY
 #include <asm/set_memory.h>
 #else
@@ -78,7 +80,8 @@ static inline int set_memory_encrypted(unsigned long addr, int numpages)
 	return 0;
 }
 
-static inline int set_memory_decrypted(unsigned long addr, int numpages)
+static inline int set_memory_decrypted(unsigned long addr, int numpages,
+				       unsigned int flags)
 {
 	return 0;
 }
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index d293198384c3..5b557ee27fd4 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -81,11 +81,12 @@ bool dma_coherent_ok(struct device *dev, phys_addr_t phys, size_t size)
 		min_not_zero(dev->coherent_dma_mask, dev->bus_dma_limit);
 }
 
-static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size)
+static int dma_set_decrypted(struct device *dev, void *vaddr, size_t size,
+			     unsigned int flags)
 {
 	int ret;
 
-	ret = cc_make_shared(vaddr, size);
+	ret = cc_make_shared(vaddr, size, flags);
 	if (ret)
 		pr_warn_ratelimited("leaking DMA memory that can't be decrypted\n");
 	return ret;
@@ -213,7 +214,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	if (force_dma_unencrypted(dev))
 		attrs |= __DMA_ATTR_ALLOC_CC_SHARED;
 
-	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED) {
+	mark_mem_decrypt = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+	if (mark_mem_decrypt) {
 		/*
 		 * Unencrypted/shared DMA requires a linear-mapped buffer
 		 * address to look up the PFN and set architecture-required PFN
@@ -221,7 +223,6 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		 * allocation.
 		 */
 		allow_highmem = false;
-		mark_mem_decrypt = true;
 	}
 
 	size = PAGE_ALIGN(size);
@@ -315,7 +316,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		void *lm_addr;
 
 		lm_addr = page_address(page);
-		if (dma_set_decrypted(dev, lm_addr, size))
+		if (dma_set_decrypted(dev, lm_addr, size, CC_SHARED_ZERO))
 			goto out_leak_pages;
 	}
 
@@ -334,7 +335,9 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		cpu_addr = page_address(page);
 	}
 
-	memset(cpu_addr, 0, size);
+	/* Zero after remapping because the page may be in HighMem. */
+	if (!mark_mem_decrypt)
+		memset(cpu_addr, 0, size);
 
 	if (set_uncached) {
 		void *uncached_cpu_addr;
@@ -452,10 +455,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 	unsigned int align_order = 0;
 	struct page *page;
 	void *cpu_addr;
+	bool mark_mem_decrypt;
 
 	if (force_dma_unencrypted(dev))
 		attrs |= __DMA_ATTR_ALLOC_CC_SHARED;
 
+	mark_mem_decrypt = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+
 	if ((attrs & __DMA_ATTR_ALLOC_CC_SHARED) && dma_direct_use_pool(dev, gfp))
 		return dma_direct_alloc_from_pool(dev, size, dma_handle,
 						  &cpu_addr, gfp, attrs);
@@ -466,10 +472,11 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 			return NULL;
 
 		cpu_addr = page_address(page);
+		mark_mem_decrypt = false;
 		goto setup_page;
 	}
 
-	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED) {
+	if (mark_mem_decrypt) {
 		if (cc_shared_calc_layout(size, &layout))
 			return NULL;
 		size = layout.shared_size;
@@ -481,11 +488,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		return NULL;
 
 	cpu_addr = page_address(page);
-	if ((attrs & __DMA_ATTR_ALLOC_CC_SHARED) &&
-	    dma_set_decrypted(dev, cpu_addr, size))
-		goto out_leak_pages;
 setup_page:
-	memset(cpu_addr, 0, size);
+	if (mark_mem_decrypt) {
+		if (dma_set_decrypted(dev, cpu_addr, size, CC_SHARED_ZERO))
+			goto out_leak_pages;
+	} else {
+		memset(cpu_addr, 0, size);
+	}
 	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page),
 					 attrs & __DMA_ATTR_ALLOC_CC_SHARED);
 	return page;
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 651d3a99c574..4298d5fddf57 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -138,7 +138,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	 * shrink so no re-encryption occurs in dma_direct_free().
 	 */
 	if (dma_pool->cc_shared) {
-		ret = cc_make_shared(page_to_virt(page), pool_size);
+		ret = cc_make_shared(page_to_virt(page), pool_size, 0);
 		if (ret) {
 			leak_pages = true;
 			goto remove_mapping;
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 9577a8807b07..281873ee8fe6 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -383,12 +383,10 @@ void __init swiotlb_update_mem_attributes(void)
 	if (io_tlb_default_mem.cc_shared) {
 		int ret;
 
-		ret = cc_make_shared(mem->vaddr, bytes);
+		ret = cc_make_shared(mem->vaddr, bytes, CC_SHARED_ZERO);
 		if (ret) {
 			pr_warn("Failed to decrypt default memory pool, disabling it\n");
 			swiotlb_mark_pool_used(mem);
-		} else {
-			memset(mem->vaddr, 0, bytes);
 		}
 	}
 }
@@ -642,7 +640,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		goto error_slots;
 
 	if (io_tlb_default_mem.cc_shared) {
-		rc = cc_make_shared(vstart, nslabs << IO_TLB_SHIFT);
+		rc = cc_make_shared(vstart, nslabs << IO_TLB_SHIFT, 0);
 		if (rc) {
 			leak_pages = true;
 			goto error_decrypt;
@@ -746,7 +744,7 @@ static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 	}
 
 	vaddr = phys_to_virt(paddr);
-	if (cc_shared && cc_make_shared(vaddr, bytes))
+	if (cc_shared && cc_make_shared(vaddr, bytes, 0))
 		goto error;
 	return page;
 
@@ -2069,7 +2067,8 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 			int ret;
 
 			mem->cc_shared = true;
-			ret = cc_make_shared(phys_to_virt(rmem->base), rmem->size);
+			ret = cc_make_shared(phys_to_virt(rmem->base),
+					     rmem->size, 0);
 			if (ret) {
 				dev_err(dev, "Failed to decrypt restricted DMA pool\n");
 				kfree(pool->areas);
diff --git a/mm/cc_shared.c b/mm/cc_shared.c
index 3e33681218f1..586a82116ba6 100644
--- a/mm/cc_shared.c
+++ b/mm/cc_shared.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2026 ARM Ltd.
  */
 #include <linux/align.h>
+#include <linux/cc_platform.h>
 #include <linux/cc_shared.h>
 #include <linux/errno.h>
 #include <linux/export.h>
@@ -76,14 +77,17 @@ static int cc_validate_transition(void *addr, size_t size)
 	return 0;
 }
 
-int cc_make_shared(void *addr, size_t size)
+int cc_make_shared(void *addr, size_t size, unsigned int flags)
 {
 	int ret = cc_validate_transition(addr, size);
 
 	if (ret)
 		return ret;
+	if (flags & ~CC_SHARED_ZERO)
+		return -EINVAL;
 
-	return set_memory_decrypted((unsigned long)addr, size >> PAGE_SHIFT);
+	return set_memory_decrypted((unsigned long)addr, size >> PAGE_SHIFT,
+				    flags);
 }
 
 int cc_make_private(void *addr, size_t size)
@@ -96,8 +100,9 @@ int cc_make_private(void *addr, size_t size)
 	return set_memory_encrypted((unsigned long)addr, size >> PAGE_SHIFT);
 }
 
-int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
-		size_t requested, struct cc_shared_pages *mem)
+static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+					size_t requested,
+					struct cc_shared_pages *mem)
 {
 	struct cc_shared_layout layout;
 	struct page *page;
@@ -105,9 +110,6 @@ int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 	bool zero = gfp & __GFP_ZERO;
 	int ret;
 
-	if (!mem)
-		return -EINVAL;
-
 	ret = cc_shared_calc_layout(requested, &layout);
 	if (ret)
 		return ret;
@@ -118,7 +120,8 @@ int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 
 	/*
 	 * State transitions require a linear-map address and may modify memory.
-	 * Allocate from low memory and defer requested zeroing until afterwards.
+	 * Allocate from low memory and let the architecture place requested
+	 * zeroing at the appropriate point in the transition.
 	 */
 	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
 	if (nid == NUMA_NO_NODE)
@@ -128,7 +131,8 @@ int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 	if (!page)
 		return -ENOMEM;
 
-	ret = cc_make_shared(page_address(page), layout.shared_size);
+	ret = cc_make_shared(page_address(page), layout.shared_size,
+			     zero ? CC_SHARED_ZERO : 0);
 	if (ret) {
 		if (!cc_make_private(page_address(page), layout.shared_size))
 			__free_pages(page, order);
@@ -138,13 +142,39 @@ int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 		return ret;
 	}
 
-	if (zero)
-		memset(page_address(page), 0, layout.shared_size);
-
 	mem->page = page;
 	mem->shared_size = layout.shared_size;
 	return 0;
 }
+
+int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+			       size_t requested,
+			       struct cc_shared_pages *mem)
+{
+	struct page *page;
+	unsigned int order;
+
+	if (!mem || !requested)
+		return -EINVAL;
+
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
+		return __alloc_cc_shared_pages_node(nid, gfp, requested, mem);
+
+	order = get_order(requested);
+	if (order > MAX_PAGE_ORDER)
+		return -EINVAL;
+
+	if (nid == NUMA_NO_NODE)
+		page = alloc_pages(gfp, order);
+	else
+		page = alloc_pages_node(nid, gfp, order);
+	if (!page)
+		return -ENOMEM;
+
+	mem->page = page;
+	mem->shared_size = requested;
+	return 0;
+}
 EXPORT_SYMBOL_GPL(alloc_cc_shared_pages_node);
 
 int alloc_cc_shared_pages(gfp_t gfp,
@@ -159,7 +189,8 @@ void free_cc_shared_pages(struct cc_shared_pages *mem)
 	if (!mem || !mem->page)
 		return;
 
-	if (cc_make_private(page_address(mem->page), mem->shared_size)) {
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT) &&
+	    cc_make_private(page_address(mem->page), mem->shared_size)) {
 		pr_warn_ratelimited("leaking %zu bytes that cannot be made private\n",
 				    mem->shared_size);
 		return;
