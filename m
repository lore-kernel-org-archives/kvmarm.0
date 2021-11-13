Return-Path: <SRS0=3yKf=QA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73742C4321E
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:22:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 236D6610A5
	for <kvmarm@archiver.kernel.org>; Sat, 13 Nov 2021 01:22:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 236D6610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C59344B2FA;
	Fri, 12 Nov 2021 20:22:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id m+dPwxqm0Wya; Fri, 12 Nov 2021 20:22:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D95F4B2F7;
	Fri, 12 Nov 2021 20:22:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521A44B295
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xbQn-ZZ8HhjT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 20:22:50 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7D734B299
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 20:22:49 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 a16-20020a17090aa51000b001a78699acceso5562384pjq.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 17:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=K2RrFeCoM3oSUmdtd3lbeaWPVCloJKULJo2uGZ1r79E=;
 b=ZtlR2+nS0IKTZkdZ+iOB/3biPj5mqutgRk8kNQsIEw7z+XWEo+BqN3FnuTCtrKmxet
 xNbwn80O8CG3bALgllFt7Of37R9JN5+ezAmmYga3PViucXn1Wnep5A4SP/0ZPL0NTIN6
 AhhJuelp0+TnzXGrC++hwN40dscFhSY6Byq/AhFM1m93gKU0BgVKAqPinBR6XkrBLZf3
 nVQcov7Qv2xjfCP6yHNUXxuIwImLhmkRHw/SoupitowgMors3vwezLwgyCJghjcbHDa8
 jZqnC/Xe7SZLkEqGg+UcGe33Hsvzh4eGCusKcFFPy0KgYQmmVthhe7dxNA0AVJirjbqM
 bDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=K2RrFeCoM3oSUmdtd3lbeaWPVCloJKULJo2uGZ1r79E=;
 b=x6GfYy6WoREAwgskqx9jlOFw5qJCudczEoF2VaTZDQCV2zNiRRudZyYIHgOdF80KBR
 7cPnoaaDj2Kt8CU6EEup57NZpSAIsCHH8pmSTyxYVD9Tp16B4lMIyyu8d77ULSro5zkr
 vNT9IafL6NTEtRWSWTddJpS+kmegbrTlY+RGSiqIZUYyzc35WxosqW6ZpSuFXe1ARZPa
 25oU9NhjD6qLgKeFn8EISZRP3l0ewbI1J6yhzUTaNnmvS00MWqEE+/RHVWtMlLLmwv+i
 h3IAoNNXM3mGJlqCut6soYCjIh0XXSeXT6u1NB8JvbWYjGw+rD6kkoRvQiJg/4+Y3bg7
 P84Q==
X-Gm-Message-State: AOAM533a+6SulnxKIVMEwsqAbnnVDEKl5uaW6zOtZYSFdG72iqWsNJGI
 YXF6vbl4KwGqc877IDa93bZOtY7o2Nd7
X-Google-Smtp-Source: ABdhPJwF3UWNAsLH1G2l2TXGsB0hvJnIBmWY3EVPoDjpML3MqbXumCuHHbdlyxNGDRm7QYJjESgDoDoTwgEz
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a62:7a54:0:b0:494:6e78:994b with SMTP id
 v81-20020a627a54000000b004946e78994bmr17996474pfc.5.1636766568955; Fri, 12
 Nov 2021 17:22:48 -0800 (PST)
Date: Sat, 13 Nov 2021 01:22:25 +0000
In-Reply-To: <20211113012234.1443009-1-rananta@google.com>
Message-Id: <20211113012234.1443009-3-rananta@google.com>
Mime-Version: 1.0
References: <20211113012234.1443009-1-rananta@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v2 02/11] KVM: Introduce kvm_vcpu_has_run_once
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Architectures such as arm64 and riscv uses vcpu variables
such as has_run_once and ran_atleast_once, respectively,
to mark if the vCPU has started running. Since these are
architecture agnostic variables, introduce
kvm_vcpu_has_run_once() as a core kvm functionality and
use this instead of the architecture defined variables.

No functional change intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 8 ++++----
 arch/arm64/kvm/vgic/vgic-init.c   | 2 +-
 arch/riscv/include/asm/kvm_host.h | 3 ---
 arch/riscv/kvm/vcpu.c             | 7 ++-----
 include/linux/kvm_host.h          | 7 +++++++
 virt/kvm/kvm_main.c               | 1 +
 7 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4be8486042a7..02dffe50a20c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,9 +367,6 @@ struct kvm_vcpu_arch {
 	int target;
 	DECLARE_BITMAP(features, KVM_VCPU_MAX_FEATURES);
 
-	/* Detect first run of a vcpu */
-	bool has_run_once;
-
 	/* Virtual SError ESR to restore when HCR_EL2.VSE is set */
 	u64 vsesr_el2;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f5490afe1ebf..0cc148211b4e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -344,7 +344,7 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.has_run_once && unlikely(!irqchip_in_kernel(vcpu->kvm)))
+	if (kvm_vcpu_has_run_once(vcpu) && unlikely(!irqchip_in_kernel(vcpu->kvm)))
 		static_branch_dec(&userspace_irqchip_in_use);
 
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
@@ -582,13 +582,13 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	struct kvm *kvm = vcpu->kvm;
 	int ret = 0;
 
-	if (likely(vcpu->arch.has_run_once))
+	if (likely(kvm_vcpu_has_run_once(vcpu)))
 		return 0;
 
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
-	vcpu->arch.has_run_once = true;
+	vcpu->has_run_once = true;
 
 	kvm_arm_vcpu_init_debug(vcpu);
 
@@ -1116,7 +1116,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * need to invalidate the I-cache though, as FWB does *not*
 	 * imply CTR_EL0.DIC.
 	 */
-	if (vcpu->arch.has_run_once) {
+	if (kvm_vcpu_has_run_once(vcpu)) {
 		if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
 			stage2_unmap_vm(vcpu->kvm);
 		else
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0a06d0648970..6fb41097880b 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -91,7 +91,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		return ret;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (vcpu->arch.has_run_once)
+		if (kvm_vcpu_has_run_once(vcpu))
 			goto out_unlock;
 	}
 	ret = 0;
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 25ba21f98504..645e95f61d47 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -147,9 +147,6 @@ struct kvm_vcpu_csr {
 };
 
 struct kvm_vcpu_arch {
-	/* VCPU ran at least once */
-	bool ran_atleast_once;
-
 	/* ISA feature bits (similar to MISA) */
 	unsigned long isa;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index e3d3aed46184..18cbc8b0c03d 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -75,9 +75,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *cntx;
 
-	/* Mark this VCPU never ran */
-	vcpu->arch.ran_atleast_once = false;
-
 	/* Setup ISA features available to VCPU */
 	vcpu->arch.isa = riscv_isa_extension_base(NULL) & KVM_RISCV_ISA_ALLOWED;
 
@@ -190,7 +187,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
 
 	switch (reg_num) {
 	case KVM_REG_RISCV_CONFIG_REG(isa):
-		if (!vcpu->arch.ran_atleast_once) {
+		if (!kvm_vcpu_has_run_once(vcpu)) {
 			vcpu->arch.isa = reg_val;
 			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
 			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
@@ -682,7 +679,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *run = vcpu->run;
 
 	/* Mark this VCPU ran at least once */
-	vcpu->arch.ran_atleast_once = true;
+	vcpu->has_run_once = true;
 
 	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..b373929c71eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -360,6 +360,8 @@ struct kvm_vcpu {
 	 * it is a valid slot.
 	 */
 	int last_used_slot;
+
+	bool has_run_once;
 };
 
 /* must be called with irqs disabled */
@@ -1847,4 +1849,9 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+static inline bool kvm_vcpu_has_run_once(struct kvm_vcpu *vcpu)
+{
+	return vcpu->has_run_once;
+}
+
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..1ec8a8e959b2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -433,6 +433,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 	vcpu->last_used_slot = 0;
+	vcpu->has_run_once = false;
 }
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
