From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 03/12] arm/arm64: KVM: Formalise end of direct linear map
Date: Mon,  4 Dec 2017 14:13:04 +0000
Message-ID: <20171204141313.31604-4-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F40349D74
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jKdBtaSRbvuF for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:29 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E9C540651
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:29 -0500 (EST)
In-Reply-To: <20171204141313.31604-1-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

We assume that the direct linear map ends at ~0 in the KVM HYP map
intersection checking code. This assumption will become invalid later on
for arm64 when the address space of the kernel is re-arranged.

This patch introduces a new constant PAGE_OFFSET_END for both arm and
arm64 and defines it to be ~0UL

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm/include/asm/memory.h   | 1 +
 arch/arm64/include/asm/memory.h | 1 +
 virt/kvm/arm/mmu.c              | 4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 1f54e4e98c1e..e223a945c361 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -30,6 +30,7 @@
 
 /* PAGE_OFFSET - the virtual address of the start of the kernel image */
 #define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
+#define PAGE_OFFSET_END		(~0UL)
 
 #ifdef CONFIG_MMU
 
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index d4bae7d6e0d8..2dedc775d151 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -67,6 +67,7 @@
 	(UL(1) << VA_BITS) + 1)
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) - \
 	(UL(1) << (VA_BITS - 1)) + 1)
+#define PAGE_OFFSET_END		(~0UL)
 #define KIMAGE_VADDR		(MODULES_END)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
 #define MODULES_VADDR		(VA_START + KASAN_SHADOW_SIZE)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index b36945d49986..4ff903409c65 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1764,10 +1764,10 @@ int kvm_mmu_init(void)
 
 	kvm_info("IDMAP page: %lx\n", hyp_idmap_start);
 	kvm_info("HYP VA range: %lx:%lx\n",
-		 kern_hyp_va(PAGE_OFFSET), kern_hyp_va(~0UL));
+		 kern_hyp_va(PAGE_OFFSET), kern_hyp_va(PAGE_OFFSET_END));
 
 	if (hyp_idmap_start >= kern_hyp_va(PAGE_OFFSET) &&
-	    hyp_idmap_start <  kern_hyp_va(~0UL) &&
+	    hyp_idmap_start <  kern_hyp_va(PAGE_OFFSET_END) &&
 	    hyp_idmap_start != (unsigned long)__hyp_idmap_text_start) {
 		/*
 		 * The idmap page is intersecting with the VA space,
-- 
2.11.0
