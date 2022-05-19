Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02282C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:44:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B02674B3BA;
	Thu, 19 May 2022 09:44:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vi86Y3Lcg5au; Thu, 19 May 2022 09:44:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB064B367;
	Thu, 19 May 2022 09:44:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D95FB4B367
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ji3mW-6cRNB1 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:44:01 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CC954B3BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:44:01 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 10AF46178C;
 Thu, 19 May 2022 13:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09026C36AE5;
 Thu, 19 May 2022 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967840;
 bh=ww7lcjAl/6HWNdYTQ7W0CxccWCjVsOE8/+vp9KoOlaM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=INs/18LVN+1265ynbPoPcB7JGaHB/uPPncEfZ7tJ7W4oh+MulUvoUqrN1mB1tadCf
 mmQicPQI5MxP3BnHckBzGiBJjvneWIctLUFtKJKJS/z54s/dbc8EjCuDqNNxoyJX9g
 Z9ukHZ4LcbB0JNV3ConQEqExUvhmktRXVVfHuHlTpep1zLfj/BtXd8Yzy1uf3ikpFW
 JMqYAK7/zegjzavFpbir1Bc7oJPIaOrnvcKCvDsG4nHvOhKWcZzKie6g5S9MdxJ58D
 a0Vl95/BNsRMjfofMaOghVysAZoCAseOY65PE1MG+nlL04nC6K3srr4p5Lm5ut7d1e
 9Ss06D8qCP0TQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 24/89] KVM: arm64: Return guest memory from EL2 via dedicated
 teardown memcache
Date: Thu, 19 May 2022 14:40:59 +0100
Message-Id: <20220519134204.5379-25-will@kernel.org>
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

Rather than relying on the host to free the shadow VM pages explicitly
on teardown, introduce a dedicated teardown memcache which allows the
host to reclaim guest memory resources without having to keep track of
all of the allocations made by EL2.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h             |  6 +-----
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 17 +++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +++++++-
 arch/arm64/kvm/pkvm.c                         | 12 +-----------
 5 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f4272ce76084..32ac88e60e6b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -161,11 +161,7 @@ struct kvm_arch_memory_slot {
 struct kvm_protected_vm {
 	unsigned int shadow_handle;
 	struct mutex shadow_lock;
-
-	struct {
-		void *pgd;
-		void *shadow;
-	} hyp_donations;
+	struct kvm_hyp_memcache teardown_mc;
 };
 
 struct kvm_arch {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 36eea31a1c5f..663019992b67 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -76,7 +76,7 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
 int hyp_pin_shared_mem(void *from, void *to);
 void hyp_unpin_shared_mem(void *from, void *to);
-void reclaim_guest_pages(struct kvm_shadow_vm *vm);
+void reclaim_guest_pages(struct kvm_shadow_vm *vm, struct kvm_hyp_memcache *mc);
 int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 		    struct kvm_hyp_memcache *host_mc);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 992ef4b668b4..bcf84e157d4b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -260,19 +260,24 @@ int kvm_guest_prepare_stage2(struct kvm_shadow_vm *vm, void *pgd)
 	return 0;
 }
 
-void reclaim_guest_pages(struct kvm_shadow_vm *vm)
+void reclaim_guest_pages(struct kvm_shadow_vm *vm, struct kvm_hyp_memcache *mc)
 {
-	unsigned long nr_pages, pfn;
-
-	nr_pages = kvm_pgtable_stage2_pgd_size(vm->kvm.arch.vtcr) >> PAGE_SHIFT;
-	pfn = hyp_virt_to_pfn(vm->pgt.pgd);
+	void *addr;
 
+	/* Dump all pgtable pages in the hyp_pool */
 	guest_lock_component(vm);
 	kvm_pgtable_stage2_destroy(&vm->pgt);
 	vm->kvm.arch.mmu.pgd_phys = 0ULL;
 	guest_unlock_component(vm);
 
-	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
+	/* Drain the hyp_pool into the memcache */
+	addr = hyp_alloc_pages(&vm->pool, 0);
+	while (addr) {
+		memset(hyp_virt_to_page(addr), 0, sizeof(struct hyp_page));
+		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
+		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
+		addr = hyp_alloc_pages(&vm->pool, 0);
+	}
 }
 
 int __pkvm_prot_finalize(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 114c5565de7d..a4a518b2a43b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -546,8 +546,10 @@ int __pkvm_init_shadow(struct kvm *kvm, unsigned long shadow_hva,
 
 int __pkvm_teardown_shadow(unsigned int shadow_handle)
 {
+	struct kvm_hyp_memcache *mc;
 	struct kvm_shadow_vm *vm;
 	size_t shadow_size;
+	void *addr;
 	int err;
 
 	/* Lookup then remove entry from the shadow table. */
@@ -569,7 +571,8 @@ int __pkvm_teardown_shadow(unsigned int shadow_handle)
 	hyp_spin_unlock(&shadow_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	reclaim_guest_pages(vm);
+	mc = &vm->host_kvm->arch.pkvm.teardown_mc;
+	reclaim_guest_pages(vm, mc);
 	unpin_host_vcpus(vm->shadow_vcpu_states, vm->kvm.created_vcpus);
 
 	/* Push the metadata pages to the teardown memcache */
@@ -577,6 +580,9 @@ int __pkvm_teardown_shadow(unsigned int shadow_handle)
 	hyp_unpin_shared_mem(vm->host_kvm, vm->host_kvm + 1);
 
 	memset(vm, 0, shadow_size);
+	for (addr = vm; addr < (void *)vm + shadow_size; addr += PAGE_SIZE)
+		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
+
 	unmap_donated_memory_noclear(vm, shadow_size);
 	return 0;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index b4466b31d7c8..b174d6dfde36 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -160,8 +160,6 @@ static int __kvm_shadow_create(struct kvm *kvm)
 
 	/* Store the shadow handle given by hyp for future call reference. */
 	kvm->arch.pkvm.shadow_handle = shadow_handle;
-	kvm->arch.pkvm.hyp_donations.pgd = pgd;
-	kvm->arch.pkvm.hyp_donations.shadow = shadow_addr;
 	return 0;
 
 free_shadow:
@@ -185,20 +183,12 @@ int kvm_shadow_create(struct kvm *kvm)
 
 void kvm_shadow_destroy(struct kvm *kvm)
 {
-	size_t pgd_sz, shadow_sz;
-
 	if (kvm->arch.pkvm.shadow_handle)
 		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_shadow,
 					  kvm->arch.pkvm.shadow_handle));
 
 	kvm->arch.pkvm.shadow_handle = 0;
-
-	shadow_sz = PAGE_ALIGN(KVM_SHADOW_VM_SIZE +
-			       KVM_SHADOW_VCPU_STATE_SIZE * kvm->created_vcpus);
-	pgd_sz = kvm_pgtable_stage2_pgd_size(kvm->arch.vtcr);
-
-	free_pages_exact(kvm->arch.pkvm.hyp_donations.shadow, shadow_sz);
-	free_pages_exact(kvm->arch.pkvm.hyp_donations.pgd, pgd_sz);
+	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
 }
 
 int kvm_init_pvm(struct kvm *kvm)
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
