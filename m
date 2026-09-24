Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25E043CE56;
	Thu, 24 Sep 2026 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244395; cv=none; b=pe7VqWcv3kvHrVvvvrZc2EPsknLy6a5RACLd3OcLtIko7TQSO7rvxm4H7oW+uRVMIkseI8gnfmnrAOj3S7k/BeZO5Me0EVNC2qK9Ryed7aTmbT6GEFhgAw9MhSTjban1CJ4Ju7mYB9ZADLF+c5LzMpLUfCcqVPQRankqe6hz0nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244395; c=relaxed/simple;
	bh=2QYvsokSFmesMS1hra/fv9j0z3vvm9MNiLpq/KcP4pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uP1WA4+wLhy1ienuame0vWubcu4JnJNjFr15NptY54RcWSmeSx/t6a4Lf/9nPEbgUu6aEIwerleTflGYy3sNUbiJiedG2gXGprUnJSnC6wLUl3O14nzy8TFtRnKCvGr3H+S7xDU4TmsAK8LVDD/VyBeyxiOhrTOCRzOWj4thC3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AM+mpu9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AM+mpu9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD31D1F000FF;
	Thu, 24 Sep 2026 10:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244384;
	bh=Ied2AelGOAUoBLypHiwb2BL1zLogQy2LqP9NEecl9Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AM+mpu9qGXxDz7bD9e86xWdXibQkZA/5cUFq8K+AJhu+OLOZOG3vMF9mBRTc+zGqI
	 yRj9S4yaKhbuaIGypSGuFG49BwMWg7fZoz4YBrRNXGjOa8KkLOa6Kqdg9Mmjwt0q9Q
	 ehXg0pJlZ1ALhgUqcXmE6XX5MLHMwgqnU3WirpecNc1Es05E37mMF/ufHlErk7/MSf
	 iYgfs7myFqVwvkuOx0gREfI/UFZ+04YCqr2grhPtJdc/U8KkMMPJgqf3yT/2Rfmqui
	 JTCFvApGvxYleMqambDrmxZ3rg9Pz/jTjTmV4Ve6a523KZYTJFPlknUQuc9r3kvPDT
	 oi++Sb59RmMoQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 02/14] mm: Zero memory during shared memory transitions
Date: Thu, 24 Sep 2026 15:35:17 +0530
Message-ID: <20260924100529.1398790-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Architectures need to zero memory at different points in a private-to-shared
transition. For example, pKVM must clear memory before sharing it, while Arm
CCA can only clear it after the RSI transition has completed.

Make zeroing an implicit property of set_memory_decrypted(). Each architecture
or platform performs the clear at the safe point in its transition. On x86,
perform it in the prepare callback while the private mapping remains
accessible. This avoids adding a flag to set_memory_decrypted() and threading
it through the architecture-specific callbacks.

Keep allocations on platforms without memory encryption on the ordinary page
allocator path so the original GFP constraints, including __GFP_ZERO, remain
intact. Remove post-transition memset() calls that are now redundant and
explicitly clear allocations on paths where no transition occurs.

This intentionally makes every private-to-shared transition destructive;
callers can no longer use set_memory_decrypted() to preserve existing contents.

Assisted-by: Codex:gpt-5
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Long Li <longli@microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/mm/pageattr.c                      |  3 ++
 arch/powerpc/platforms/pseries/svm.c          |  2 +
 arch/s390/mm/init.c                           |  3 ++
 arch/x86/coco/tdx/tdx.c                       |  3 ++
 arch/x86/hyperv/hv_init.c                     |  6 ++-
 arch/x86/hyperv/ivm.c                         |  4 ++
 arch/x86/kernel/kvmclock.c                    |  6 +--
 arch/x86/mm/mem_encrypt_amd.c                 |  4 ++
 drivers/hv/connection.c                       | 41 +++++++++----------
 drivers/hv/hv.c                               | 11 ++---
 drivers/hv/hv_common.c                        |  2 -
 drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c |  3 ++
 kernel/dma/direct.c                           | 22 ++++++----
 mm/cc_shared.c                                |  7 +---
 14 files changed, 72 insertions(+), 45 deletions(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..ae1f5de66fad 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -339,6 +339,9 @@ static int realm_set_memory_decrypted(unsigned long addr, int numpages)
 {
 	int ret = __set_memory_enc_dec(addr, numpages, false);
 
+	if (!ret)
+		memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	WARN(ret, "Failed to decrypt memory, %d pages will be leaked",
 	     numpages);
 
diff --git a/arch/powerpc/platforms/pseries/svm.c b/arch/powerpc/platforms/pseries/svm.c
index 7a403dbd35ee..a344e094fe1c 100644
--- a/arch/powerpc/platforms/pseries/svm.c
+++ b/arch/powerpc/platforms/pseries/svm.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/memblock.h>
 #include <linux/mem_encrypt.h>
+#include <linux/string.h>
 #include <linux/cc_platform.h>
 #include <asm/machdep.h>
 #include <asm/svm.h>
@@ -59,6 +60,7 @@ int set_memory_decrypted(unsigned long addr, int numpages)
 	if (!PAGE_ALIGNED(addr))
 		return -EINVAL;
 
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
 	uv_share_page(PHYS_PFN(__pa(addr)), numpages);
 
 	return 0;
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index be7e009e7b59..f2e28a2710e0 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -129,6 +129,9 @@ int set_memory_encrypted(unsigned long vaddr, int numpages)
 int set_memory_decrypted(unsigned long vaddr, int numpages)
 {
 	int i;
+
+	memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	/* make specified pages shared (swiotlb, dma_alloca) */
 	for (i = 0; i < numpages; ++i) {
 		uv_set_shared(virt_to_phys((void *)vaddr));
diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index f904a636d449..1f1f39082391 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -978,6 +978,9 @@ static bool tdx_enc_status_changed(unsigned long vaddr, int numpages, bool enc)
 static int tdx_enc_status_change_prepare(unsigned long vaddr, int numpages,
 					 bool enc)
 {
+	if (!enc)
+		memset((void *)vaddr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	/*
 	 * Only handle shared->private conversion here.
 	 * See the comment in tdx_early_init().
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 0b4a1c0b0b16..a42468e81c34 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -156,8 +156,10 @@ static int hv_cpu_init(unsigned int cpu)
 			 * page in non-root partition here.
 			 */
 			if (*hvp && !ms_hyperv.paravisor_present && hv_isolation_type_snp()) {
-				WARN_ON_ONCE(set_memory_decrypted((unsigned long)(*hvp), 1));
-				memset(*hvp, 0, PAGE_SIZE);
+				int ret;
+
+				ret = set_memory_decrypted((unsigned long)*hvp, 1);
+				WARN_ON_ONCE(ret);
 			}
 		}
 
diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
index 2ce4dfe53472..e9c7799a0094 100644
--- a/arch/x86/hyperv/ivm.c
+++ b/arch/x86/hyperv/ivm.c
@@ -755,6 +755,10 @@ static int hv_mark_gpa_visibility(u16 count, const u64 pfn[],
  */
 static int hv_vtom_clear_present(unsigned long kbuffer, int pagecount, bool enc)
 {
+	if (!enc)
+		memset((void *)kbuffer, 0,
+		       (size_t)pagecount << PAGE_SHIFT);
+
 	return set_memory_np(kbuffer, pagecount);
 }
 
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index cb3d0ca1fa22..3e9b7ad3dea2 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -248,7 +248,7 @@ static void __init kvmclock_init_mem(void)
 	 * be mapped decrypted.
 	 */
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
-		r = set_memory_decrypted((unsigned long) hvclock_mem,
+		r = set_memory_decrypted((unsigned long)hvclock_mem,
 					 1UL << order);
 		if (r) {
 			__free_pages(p, order);
@@ -256,9 +256,9 @@ static void __init kvmclock_init_mem(void)
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
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 2f8c32173972..47cae102acd2 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -13,6 +13,7 @@
 #include <linux/dma-direct.h>
 #include <linux/swiotlb.h>
 #include <linux/mem_encrypt.h>
+#include <linux/string.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/bitops.h>
@@ -285,6 +286,9 @@ static void enc_dec_hypercall(unsigned long vaddr, unsigned long size, bool enc)
 
 static int amd_enc_status_change_prepare(unsigned long vaddr, int npages, bool enc)
 {
+	if (!enc)
+		memset((void *)vaddr, 0, (size_t)npages << PAGE_SHIFT);
+
 	/*
 	 * To maintain the security guarantees of SEV-SNP guests, make sure
 	 * to invalidate the memory before encryption attribute is cleared.
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 1ab3581b096a..3be779093f3c 100644
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
+					   1);
+		ret |= set_memory_decrypted((unsigned long)vmbus_connection.monitor_pages[1],
+					    1);
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
index fe50090dcc01..6e836a02910a 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -123,12 +123,13 @@ static int hv_alloc_page(void **page, bool decrypt, const char *note)
 	if (!*page)
 		return -ENOMEM;
 
-	if (decrypt)
+	if (decrypt) {
 		ret = set_memory_decrypted((unsigned long)*page, 1);
-	if (ret)
-		goto failed;
-
-	memset(*page, 0, PAGE_SIZE);
+		if (ret)
+			goto failed;
+	} else {
+		memset(*page, 0, PAGE_SIZE);
+	}
 	return 0;
 
 failed:
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 31256cb22b39..af6b1531d600 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -505,8 +505,6 @@ int hv_common_cpu_init(unsigned int cpu)
 				/* It may be unsafe to free 'mem' */
 				return ret;
 			}
-
-			memset(mem, 0x00, pgcount * HV_HYP_PAGE_SIZE);
 		}
 
 		/*
diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
index 26fe9c3f22e3..7d922e0a28f9 100644
--- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
+++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
@@ -13,6 +13,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/mm.h>
 #include <linux/pgtable.h>
+#include <linux/string.h>
 
 #include <asm/hypervisor.h>
 
@@ -61,6 +62,8 @@ static int pkvm_set_memory_encrypted(unsigned long addr, int numpages)
 
 static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
 {
+	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
+
 	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
 				  addr, numpages);
 }
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index da665ca22d5c..356d4e09e1c8 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -211,7 +211,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	if (force_dma_unencrypted(dev))
 		attrs |= __DMA_ATTR_ALLOC_CC_SHARED;
 
-	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED) {
+	mark_mem_decrypt = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+	if (mark_mem_decrypt) {
 		/*
 		 * Unencrypted/shared DMA requires a linear-mapped buffer
 		 * address to look up the PFN and set architecture-required PFN
@@ -219,7 +220,6 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		 * allocation.
 		 */
 		allow_highmem = false;
-		mark_mem_decrypt = true;
 	}
 
 	size = PAGE_ALIGN(size);
@@ -324,7 +324,9 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		cpu_addr = page_address(page);
 	}
 
-	memset(cpu_addr, 0, size);
+	/* Zero after remapping because the page may be in HighMem. */
+	if (!mark_mem_decrypt)
+		memset(cpu_addr, 0, size);
 
 	if (set_uncached) {
 		void *uncached_cpu_addr;
@@ -435,10 +437,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 	unsigned long attrs = 0;
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
@@ -449,6 +454,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 			return NULL;
 
 		cpu_addr = page_address(page);
+		mark_mem_decrypt = false;
 		goto setup_page;
 	}
 
@@ -457,11 +463,13 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		return NULL;
 
 	cpu_addr = page_address(page);
-	if ((attrs & __DMA_ATTR_ALLOC_CC_SHARED) &&
-	    dma_set_decrypted(dev, cpu_addr, size))
-		goto out_leak_pages;
 setup_page:
-	memset(cpu_addr, 0, size);
+	if (mark_mem_decrypt) {
+		if (dma_set_decrypted(dev, cpu_addr, size))
+			goto out_leak_pages;
+	} else {
+		memset(cpu_addr, 0, size);
+	}
 	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page),
 					 attrs & __DMA_ATTR_ALLOC_CC_SHARED);
 	return page;
diff --git a/mm/cc_shared.c b/mm/cc_shared.c
index 85e16f4504b8..9eb79832a702 100644
--- a/mm/cc_shared.c
+++ b/mm/cc_shared.c
@@ -104,7 +104,6 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 	struct cc_shared_layout layout;
 	struct page *page;
 	unsigned int order;
-	bool zero = gfp & __GFP_ZERO;
 	int ret;
 
 	ret = cc_shared_calc_layout(requested, &layout);
@@ -117,7 +116,8 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 
 	/*
 	 * State transitions require a linear-map address and may modify memory.
-	 * Allocate from low memory and defer requested zeroing until afterwards.
+	 * Allocate from low memory and let the architecture place zeroing at the
+	 * appropriate point in the transition.
 	 */
 	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
 	if (nid == NUMA_NO_NODE)
@@ -137,9 +137,6 @@ static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
 		return ret;
 	}
 
-	if (zero)
-		memset(page_address(page), 0, layout.shared_size);
-
 	mem->page = page;
 	mem->shared_size = layout.shared_size;
 	return 0;
-- 
2.43.0

