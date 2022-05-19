Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A71C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FE564B3BE;
	Thu, 19 May 2022 09:44:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NItfJtcqqtmW; Thu, 19 May 2022 09:44:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE0D44B37B;
	Thu, 19 May 2022 09:44:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D4C34B105
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sQASlAbQC4kJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:10 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DE994B32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:09 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 04F1661795;
 Thu, 19 May 2022 13:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC73C385AA;
 Thu, 19 May 2022 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967848;
 bh=IhSeOWQnVbLScTEq7xNJkFboB+w6CZDfIqkfMBGCjiM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Q9r6DPcBOzmStsuUUfc3UU7T7QcuduC5In0lc9hRBgmHPF+9ZpRFpGvm7y/bNY1Fz
 WzKnjAYdPbvwzbHhhlEeGIdkx44ml6A50hfRtUVu0j7l2VRmd3llDu9GA0o7BC7ZHl
 e6E9nAzaLoEwqDvGLMZMPVJQxJxyYp1uome95uL8qzP9Kx1anpNDThG9NNAQbJcAgx
 pMksAfq2wqlmNu0VtzOjETnS/BLYqsNiUosjhG7L22YO3XMhafBoGZhNkukkxsElT5
 UMvZmGCxAmGH84KawM/xtHQPsSrfPhw5H6SSTe2v5qgFOKZhc1i4FL/pW0BhkCOoOF
 pUexcEEEbhcWg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 26/89] KVM: arm64: Provide a hypercall for the host to reclaim
 guest memory
Date: Thu, 19 May 2022 14:41:01 +0100
Message-Id: <20220519134204.5379-27-will@kernel.org>
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

Implement a new hypercall, __pkvm_host_reclaim_page(), so that the host
at EL1 can reclaim pages that were previously donated to EL2. This
allows EL2 to defer clearing of guest memory on teardown and allows
preemption in the host after reclaiming each page.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |  7 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  8 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 91 ++++++++++++++++++-
 5 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f5030e88eb58..a68381699c40 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -64,6 +64,7 @@ enum __kvm_host_smccc_func {
 	/* Hypercalls available after pKVM finalisation */
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_reclaim_page,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 663019992b67..ecedc545e608 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -64,6 +64,7 @@ extern unsigned long hyp_nr_cpus;
 int __pkvm_prot_finalize(void);
 int __pkvm_host_share_hyp(u64 pfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
+int __pkvm_host_reclaim_page(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 29f2ebe306bc..15b719fefc86 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -7,6 +7,13 @@
 
 #include <linux/types.h>
 
+/*
+ * Accesses to struct hyp_page flags are serialized by the host stage-2
+ * page-table lock.
+ */
+#define HOST_PAGE_NEED_POISONING	BIT(0)
+#define HOST_PAGE_PENDING_RECLAIM	BIT(1)
+
 struct hyp_page {
 	unsigned short refcount;
 	u8 order;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8e51cdab00b7..629d306c91c0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -155,6 +155,13 @@ static void handle___pkvm_host_unshare_hyp(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_host_unshare_hyp(pfn);
 }
 
+static void handle___pkvm_host_reclaim_page(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, pfn, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_host_reclaim_page(pfn);
+}
+
 static void handle___pkvm_create_private_mapping(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
@@ -211,6 +218,7 @@ static const hcall_t host_hcall[] = {
 
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+	HANDLE_FUNC(__pkvm_host_reclaim_page),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bcf84e157d4b..adb6a880c684 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -260,15 +260,51 @@ int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd)
 	return 0;
 }
 
+static int reclaim_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+		enum kvm_pgtable_walk_flags flag,
+		void * const arg)
+{
+	kvm_pte_t pte = *ptep;
+	struct hyp_page *page;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	page = hyp_phys_to_page(kvm_pte_to_phys(pte));
+	switch (pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte))) {
+	case PKVM_PAGE_OWNED:
+		page->flags |= HOST_PAGE_NEED_POISONING;
+		fallthrough;
+	case PKVM_PAGE_SHARED_BORROWED:
+	case PKVM_PAGE_SHARED_OWNED:
+		page->flags |= HOST_PAGE_PENDING_RECLAIM;
+		break;
+	default:
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 void reclaim_guest_pages(struct kvm_shadow_vm *vm, struct kvm_hyp_memcache *mc)
 {
+
+	struct kvm_pgtable_walker walker = {
+		.cb     = reclaim_walker,
+		.flags  = KVM_PGTABLE_WALK_LEAF
+	};
 	void *addr;
 
-	/* Dump all pgtable pages in the hyp_pool */
+	host_lock_component();
 	guest_lock_component(vm);
+
+	/* Reclaim all guest pages and dump all pgtable pages in the hyp_pool */
+	BUG_ON(kvm_pgtable_walk(&vm->pgt, 0, BIT(vm->pgt.ia_bits), &walker));
 	kvm_pgtable_stage2_destroy(&vm->pgt);
 	vm->kvm.arch.mmu.pgd_phys = 0ULL;
+
 	guest_unlock_component(vm);
+	host_unlock_component();
 
 	/* Drain the hyp_pool into the memcache */
 	addr = hyp_alloc_pages(&vm->pool, 0);
@@ -1225,3 +1261,56 @@ void hyp_unpin_shared_mem(void *from, void *to)
 	hyp_unlock_component();
 	host_unlock_component();
 }
+
+static int hyp_zero_page(phys_addr_t phys)
+{
+	void *addr;
+
+	addr = hyp_fixmap_map(phys);
+	if (!addr)
+		return -EINVAL;
+	memset(addr, 0, PAGE_SIZE);
+	__clean_dcache_guest_page(addr, PAGE_SIZE);
+
+	return hyp_fixmap_unmap();
+}
+
+int __pkvm_host_reclaim_page(u64 pfn)
+{
+	u64 addr = hyp_pfn_to_phys(pfn);
+	struct hyp_page *page;
+	kvm_pte_t pte;
+	int ret;
+
+	host_lock_component();
+
+	ret = kvm_pgtable_get_leaf(&host_kvm.pgt, addr, &pte, NULL);
+	if (ret)
+		goto unlock;
+
+	if (host_get_page_state(pte) == PKVM_PAGE_OWNED)
+		goto unlock;
+
+	page = hyp_phys_to_page(addr);
+	if (!(page->flags & HOST_PAGE_PENDING_RECLAIM)) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
+	if (page->flags & HOST_PAGE_NEED_POISONING) {
+		ret = hyp_zero_page(addr);
+		if (ret)
+			goto unlock;
+		page->flags &= ~HOST_PAGE_NEED_POISONING;
+	}
+
+	ret = host_stage2_set_owner_locked(addr, PAGE_SIZE, PKVM_ID_HOST);
+	if (ret)
+		goto unlock;
+	page->flags &= ~HOST_PAGE_PENDING_RECLAIM;
+
+unlock:
+	host_unlock_component();
+
+	return ret;
+}
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
