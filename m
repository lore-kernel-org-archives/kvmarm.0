Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8D1C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E2E864FB5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E2E864FB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7B4E4B41F;
	Wed, 10 Mar 2021 12:58:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q-3GjlQfzwTC; Wed, 10 Mar 2021 12:58:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA4E4B600;
	Wed, 10 Mar 2021 12:58:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E99D4B41F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jAQFGLajHotg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:36 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 389D74B3E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:36 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id z6so8297224wrh.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=bwje5/mTjAPXp3ucjvZl1d3xYnpG4DOJqI6qSewZTKg=;
 b=kTiEMz/ZmApZPyPPBuOAVVI1XfEWrDD/FlF9YL2vlvyUk0ZxpWZq3Vi1P8ENfyf0yW
 D17Yf4vX3j1XGW/K8xI2SLf89zP337IPhHEL/jdhn9M1+VDba9SqNKFobPjoh2NGwWSB
 RDixKT/u9Jildo/Y/HLiqJZSyI/IWe2xUBO5AJ5JlBNdkrd0Zu0Vf2n7fqVD+LzeY+4x
 KqhovBFzGi07230Rr2y0RdacrGcazfH8JgFDFtTA2H0NTq1XSLz2+EaWylvc0fhkLnu6
 GBglPu+rtSYfnztBzxRMswohSH+NtYVchzFRw//FT8yJ1Yr6M0pZG+/GE+SR8cI9vlPP
 4yxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bwje5/mTjAPXp3ucjvZl1d3xYnpG4DOJqI6qSewZTKg=;
 b=TiMkFoZZ1CFXxqcfT6fbvoEXJyfZT6G6Klt/mE+fIJDMWgfiD6bv8VHWwnxjfe3RAB
 6054lFXQDPbU1wevhrt9snvJieuFlIMnJl7hQU4PCD1V9Nl08Smufex9jXlOLrGgFOyY
 PfhDdosxuqEyWrO7kapb3cdEg3or3MAXfGTVFUrci/4gnRsgUbSo7csfT9ZCBIV9R5cM
 82vKHNw+OoDGz2rdWQWwbtKfZfV/TPaO/SXehxMPxxUmbVShRxakNJfL4ZjnfVMzePYr
 yr6SxAptJzFOGyV/k82HsAEoaRNKjpEGfJy0MiBrEexFTv4sJD1ZuN0BBBq4+tmHXKQo
 7YVw==
X-Gm-Message-State: AOAM532Pfz+/ZKkQGGI0Rxw54wF2Q5Phw63xI39DDhGhu/7fq6CheRve
 vADZk74OwSrc17WZBJuor3yC/HXXMhKa
X-Google-Smtp-Source: ABdhPJyfj1AGgYu6hP2WiGG5K1co03Lv+9xUcg9I+svgyqAymq4hmK7PO5V/NqSdZBVwz+UtX25b6J8FGq9/
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:4e0f:: with SMTP id
 g15mr4599326wmh.144.1615399115454; Wed, 10 Mar 2021 09:58:35 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:36 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-20-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 19/34] KVM: arm64: Use kvm_arch in kvm_s2_mmu
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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
index b9d45a1f8538..90565782ce3e 100644
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
index 41f9c03cbcc3..3257cadfab24 100644
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
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
