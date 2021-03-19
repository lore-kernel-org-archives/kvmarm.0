Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF00C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8BD664F45
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8BD664F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64CB34B720;
	Fri, 19 Mar 2021 06:02:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id foCpS4gd7Zy9; Fri, 19 Mar 2021 06:02:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 403954B70A;
	Fri, 19 Mar 2021 06:02:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E08DC4B4C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yAwjTiHYV6tM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:33 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAEEB4B725
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:32 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id p15so21380475wre.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Q749KFSlxhI4VCSiQH1slVzGHfGqH+QjEF4T/jfNWVY=;
 b=hNSKmGsVSywebewepY40RtqmV2qb/zYxefM6ad1P5/nHOptnJuLk+iUHxY/FzU5WSz
 G3TEA0iLYSdCy4hkLy6hwCK8zG7rCNGdNKRGyCvA74SErAz1RrE7OA8U5gcgJM0cnYpD
 tbtu7uVxqq0QyZOS381v7XRYiZYjv4nXltrpHZVXwpceorQUn3Ix/l4nK5RsEcDcR0co
 Scg9wNGIB9bykMV5XqpVGKAVtCcMm7OrfToEgMgCXI5mxI2NGxlE2dJQIRlwOjbtCBxd
 ei+HyKgDULEa+Vg3BRdyoO4pnCVRL+/RP84WoaAr4mDNn/Wz5Rw7712n1GZ7pTTaML8o
 Lweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Q749KFSlxhI4VCSiQH1slVzGHfGqH+QjEF4T/jfNWVY=;
 b=C8NyTRVMUQ/X2YHwbtDYieiH8yMna4SIA3lQOddJzPTQrQ0pWpJwSL90YW1a346JcQ
 X9AxVv10sTWKxZUqTjZM0doRkFXn1EQRF07T1HFaZvN0i09D7GIix7UJB3dXDrEHjWFl
 27HTnP9Ztzg7Vy9m0AOUzh0kJhRhePzDg2DU0DwfV+3mH4hm2ZOzx698pa0qtQBX7J+b
 7j/hAj1C57QoDNuQ+K8ZVvA9BgdGVJwm+A33Wi6b5tl7IJfv0Aksddc+jq17ys7KVPoH
 93gwwe+nigBqbrX5e6h3ieWJFdgOP9fdvjg5c7v0m4y3nO6NUSVKBe4lEKkCSouCerY9
 0I2g==
X-Gm-Message-State: AOAM532Wrp+8Jj58eA6qceo0R32XeyvFTqm/fZ6ofeWoWlcZWL5ucT6Z
 2d/p3oqU56k2BuVg1VoHl7roE+DlwUGU
X-Google-Smtp-Source: ABdhPJxqimdu4udH3YpMhv4DNL7SlC0GK4WlaPmSq55hwqof4iZVOI53YgJLP6O5Bzyu7KGewUovCZWfoeXF
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:7e45:: with SMTP id
 z66mr2968982wmc.126.1616148152068; Fri, 19 Mar 2021 03:02:32 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:28 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-21-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 20/38] KVM: arm64: Use kvm_arch in kvm_s2_mmu
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

In order to make use of the stage 2 pgtable code for the host stage 2,
change kvm_s2_mmu to use a kvm_arch pointer in lieu of the kvm pointer,
as the host will have the former but not the latter.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 arch/arm64/include/asm/kvm_mmu.h  | 6 +++++-
 arch/arm64/kvm/mmu.c              | 8 ++++----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f813e1191027..4859c9de75d7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -94,7 +94,7 @@ struct kvm_s2_mmu {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
-	struct kvm *kvm;
+	struct kvm_arch *arch;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index ce02a4052dcf..6f743e20cb06 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -272,7 +272,7 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
  */
 static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 {
-	write_sysreg(kern_hyp_va(mmu->kvm)->arch.vtcr, vtcr_el2);
+	write_sysreg(kern_hyp_va(mmu->arch)->vtcr, vtcr_el2);
 	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
 
 	/*
@@ -283,5 +283,9 @@ static __always_inline void __load_guest_stage2(struct kvm_s2_mmu *mmu)
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
+static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
+{
+	return container_of(mmu->arch, struct kvm, arch);
+}
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d6eb1fb21232..0f16b70befa8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -165,7 +165,7 @@ static void *kvm_host_va(phys_addr_t phys)
 static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
 				 bool may_block)
 {
-	struct kvm *kvm = mmu->kvm;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	phys_addr_t end = start + size;
 
 	assert_spin_locked(&kvm->mmu_lock);
@@ -470,7 +470,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
-	mmu->kvm = kvm;
+	mmu->arch = &kvm->arch;
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	mmu->vmid.vmid_gen = 0;
@@ -552,7 +552,7 @@ void stage2_unmap_vm(struct kvm *kvm)
 
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
-	struct kvm *kvm = mmu->kvm;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
 
 	spin_lock(&kvm->mmu_lock);
@@ -621,7 +621,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
  */
 static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
-	struct kvm *kvm = mmu->kvm;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
 }
 
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
