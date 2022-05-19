Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB60C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:43:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8284B393;
	Thu, 19 May 2022 09:43:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i24CSoIGqbSg; Thu, 19 May 2022 09:43:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB8A54B348;
	Thu, 19 May 2022 09:43:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C96F24B32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eO0K-mavfHQ7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:43:43 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 638584B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:43:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 047DBB824AA;
 Thu, 19 May 2022 13:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFD8C34116;
 Thu, 19 May 2022 13:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967820;
 bh=ZKFkdmQPlHoIGxtsviQjoI5whn3KGkXdjZ9/Hq7eV5o=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=fYocypmRqQAjksl1sou8UeHVogLdcxfGY5ei08yODBnJD8cunzCU47bnzdvuMa3Or
 nrPcI3DlkILGnfJb1bx6tSBUtpxgErrAJYsSteRTTXECFZJxrf2p+TYvNzWJHMWdJG
 J6jfPUX7+mS8aaEAQD0X9B1q7BJkgmJUYuRItzWEKHkqnNYEnp3TNqLpkI2+zgNCCp
 kNESjIWdXbcnxRkBNWRU1ARTEWkMguHMCZnHJoMdplEOwZhNl8FVWCdAt14macV5cc
 W5pyD8izX+t1RZ0LF4XVXd3Ji+Xtiy6Ay0hdTwuRYRXZVCDf7u5Zj0v+eW3udpuAex
 PFE/l80nd0Ndg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 19/89] KVM: arm64: Add pcpu fixmap infrastructure at EL2
Date: Thu, 19 May 2022 14:40:54 +0100
Message-Id: <20220519134204.5379-20-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Quentin Perret <qperret@google.com>

We will soon need to temporarily map pages into the hypervisor stage-1
in nVHE protected mode. To do this efficiently, let's introduce a
per-cpu fixmap allowing to map a single page without needing to take any
lock or to allocate memory.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  4 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  1 -
 arch/arm64/kvm/hyp/nvhe/mm.c                  | 85 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c               |  4 +
 5 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 3a0817b5c739..d11d9d68a680 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -59,6 +59,8 @@ enum pkvm_component_id {
 	PKVM_ID_HYP,
 };
 
+extern unsigned long hyp_nr_cpus;
+
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 73309ccc192e..45b04bfee171 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -13,6 +13,10 @@
 extern struct kvm_pgtable pkvm_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
 
+int hyp_create_pcpu_fixmap(void);
+void *hyp_fixmap_map(phys_addr_t phys);
+int hyp_fixmap_unmap(void);
+
 int hyp_create_idmap(u32 hyp_va_bits);
 int hyp_map_vectors(void);
 int hyp_back_vmemmap(phys_addr_t back);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 502bc0d04858..707bd832145f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -21,7 +21,6 @@
 
 #define KVM_HOST_S2_FLAGS (KVM_PGTABLE_S2_NOFWB | KVM_PGTABLE_S2_IDMAP)
 
-extern unsigned long hyp_nr_cpus;
 struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 4377b067dc0e..bdb39897343f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -14,6 +14,7 @@
 #include <nvhe/early_alloc.h>
 #include <nvhe/gfp.h>
 #include <nvhe/memory.h>
+#include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
 #include <nvhe/spinlock.h>
 
@@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
 unsigned int hyp_memblock_nr;
 
 static u64 __io_map_base;
+static DEFINE_PER_CPU(void *, hyp_fixmap_base);
 
 static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 				  unsigned long phys, enum kvm_pgtable_prot prot)
@@ -198,6 +200,89 @@ int hyp_map_vectors(void)
 	return 0;
 }
 
+void *hyp_fixmap_map(phys_addr_t phys)
+{
+	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
+	int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
+				      phys, PAGE_HYP);
+	return ret ? NULL : addr;
+}
+
+int hyp_fixmap_unmap(void)
+{
+	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
+	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
+
+	return (ret != PAGE_SIZE) ? -EINVAL : 0;
+}
+
+static int __pin_pgtable_cb(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			    enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+	if (!kvm_pte_valid(*ptep) || level != KVM_PGTABLE_MAX_LEVELS - 1)
+		return -EINVAL;
+	hyp_page_ref_inc(hyp_virt_to_page(ptep));
+
+	return 0;
+}
+
+static int hyp_pin_pgtable_pages(u64 addr)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= __pin_pgtable_cb,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+
+	return kvm_pgtable_walk(&pkvm_pgtable, addr, PAGE_SIZE, &walker);
+}
+
+int hyp_create_pcpu_fixmap(void)
+{
+	unsigned long i;
+	int ret = 0;
+	u64 addr;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		addr = hyp_alloc_private_va_range(PAGE_SIZE);
+		if (IS_ERR((void *)addr)) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+
+		/*
+		 * Create a dummy mapping, to get the intermediate page-table
+		 * pages allocated, then take a reference on the last level
+		 * page to keep it around at all times.
+		 */
+		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, PAGE_SIZE,
+					  __hyp_pa(__hyp_bss_start), PAGE_HYP);
+		if (ret) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+
+		ret = hyp_pin_pgtable_pages(addr);
+		if (ret)
+			goto unlock;
+
+		ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, addr, PAGE_SIZE);
+		if (ret != PAGE_SIZE) {
+			ret = -EINVAL;
+			goto unlock;
+		} else {
+			ret = 0;
+		}
+
+		*per_cpu_ptr(&hyp_fixmap_base, i) = (void *)addr;
+	}
+unlock:
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	return ret;
+}
+
 int hyp_create_idmap(u32 hyp_va_bits)
 {
 	unsigned long start, end;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index b306da2b5dae..59a478dde533 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -296,6 +296,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = hyp_create_pcpu_fixmap();
+	if (ret)
+		goto out;
+
 	hyp_shadow_table_init(shadow_table_base);
 out:
 	/*
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
