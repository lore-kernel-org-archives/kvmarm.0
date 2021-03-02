Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5BCC433E6
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8077B64F3C
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8077B64F3C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2334B642;
	Tue,  2 Mar 2021 10:00:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pQttv2wV0vVD; Tue,  2 Mar 2021 10:00:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8C734B649;
	Tue,  2 Mar 2021 10:00:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9499A4B335
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oQoFEYgDsajL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:48 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DECA44B663
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:47 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id f3so4384536wrt.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=bwje5/mTjAPXp3ucjvZl1d3xYnpG4DOJqI6qSewZTKg=;
 b=tSH114d1S+uNQoX1kRD+PT///jcNFZH5jQl4y1I39FKxDMU/3Sk/nzK2nY32s3DZf9
 mL7k3exN2AHB4ZPq66MGZyG7q1FEaXJALsmwnbUFPXQI/YMQ/GmienaMnA3fR32YF/0i
 XTK0G6ii03eAGLnaGVfNIse2zOnd+Zg7Xl7jhIdY9I8AE1QjfhEfugAQDu99o4kpmYVD
 26I0Hhq2R71cD5A2582Cf2YgETUOfD4hGCDIviMAgjW9yes0SiyksL6bpH2ex5Iljrzf
 W8T6pvOEg+SLKYRCoHtIR/ruVvjA92TJcf94f9E66xMC2DC/9t07gQ3jGjztpQdJQR9e
 XK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=bwje5/mTjAPXp3ucjvZl1d3xYnpG4DOJqI6qSewZTKg=;
 b=Wc4esR4D+kNMpffn23q1cHG5NxcbposzokDZPHXue4nAUfyem8xOv/XOL5KV9cmYn+
 Z1Sg2aMXShaKQYOhjVv1du+7hrjx2Te3rfQQF5DpXIBmvhpp3h4dDB7PcztZMERVLHVH
 7kua1VyZR9kaR4ucEipnvx49N5Y9shgbn+Dukda11PyMfcfIkKSeo5dhUyXUKQzM9eN1
 Iyd6Yy0JvHOiMq6t4reoAksXDCajkxogIV+gL5IqBPo1j4Fnc5qoU1YnfKeik2Tnrdly
 sCHspwBqMJWFL7AsbV8FRe7w7obSHXJJFvWkzTVPU/6yuu7bb9WoPRDwQJrv7U6x0wuw
 jD+w==
X-Gm-Message-State: AOAM531O2zhiqaTHq0vb6h9R6KwdCCnf1BfFMuADDip1ldBo3GMjNL3e
 mrZ8Ll/YAwKOmahFs3xHKZzPgVO7oAsS
X-Google-Smtp-Source: ABdhPJxElOYIMAIdgYSrQfXOebmZeuQAKDUTFyUl0M9C/M5W0sRKgrJje34shxxo7rpQfJ8MEv13l1k/xiXX
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6000:24b:: with SMTP id
 m11mr14742698wrz.393.1614697247009; Tue, 02 Mar 2021 07:00:47 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:48 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-19-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 18/32] KVM: arm64: Use kvm_arch in kvm_s2_mmu
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
