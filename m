Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBD9C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 00:56:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C227249F22;
	Wed, 16 Mar 2022 20:56:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Umssh-0Ssz-g; Wed, 16 Mar 2022 20:56:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1FC2E49F1E;
	Wed, 16 Mar 2022 20:56:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1935649EFB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 20:56:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZqGWQq8x6GB7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 20:56:41 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 89B0949E2B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 20:56:41 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 p21-20020a631e55000000b00372d919267cso884866pgm.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 17:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SfRZ2nJezeRkn8Q7eug5nt9PRgEWCVYeYSijk8DC2dM=;
 b=V5bCzuMRvj+qRCG4E6WF48LadjBU4M7IHLR67q5kMZthAjuMGDLJFtFtKoaZtWb2wm
 DMA7sQwH50JHjD6Gwe0cmC1aIUbpWcoWabQiXHC5k7mHWSKaOo4ZP3ESypcZpelKT9Yx
 4WVecX7AFkNYa/6AVQv2mYASSLxH32FqjNR07ZZSRBBSvDwjXClmAa3z0Gbz3joQ1zx0
 2YphMidAfA9MRwsVvwhqzK12v1MkO3XWdi4UMfF/ZyTdunhbJcBT7zKRuIwXAKjy311A
 s4PyFqADv9pvBZy8Ucp3iYyHBQgjWm53QZacFjvc8jOgmLWtGRrlvYyATbm+vYeJ3ktS
 Ndsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SfRZ2nJezeRkn8Q7eug5nt9PRgEWCVYeYSijk8DC2dM=;
 b=VrqIezywQ7j24ew9K5yCB/DKJ1lgizk1nUooZ34VCOQPR2J4pHYKtJeuYqCAQmQedF
 PKdw5DsGDA8Z1VLSKx+PmoPNo/k7xQJrIi6cG7hWtklr/I4lL+zct3TqQCln55bnGsal
 W1D/mPfzeUo2Rx5jyYANfnXyGSu/aq33nr6/Na8VgxUpiqiAlwFL2IcChV5/h1PrwJsO
 4ZZQitfLRBzoGeuLmSmoAjya6hD64HoK3UPHgfA3NTcqiaGwrIsYXp1+DyQumJ80bPjC
 ksljvodNwl99+3oODca/bBYta9kU6rYZn+uPdrZwT+j3bW7zSL6jR3FgelkGVE6c/o8v
 SmlQ==
X-Gm-Message-State: AOAM530OK4EZDGWjsscYSoHcf23BcUU/WbUiGDDdD6gr1fmQvxgvokLK
 kTZZMgpGQuawoQkKoyZn7E1Z4Lk79CPqsqL8sQ==
X-Google-Smtp-Source: ABdhPJx0f/Orl6ssEd7UHpXnCPHRVu7z03nPQzsQ2YsGzy1C46oijjKvFmRZzU3PoVc67pFIkFTwxP29//QVCwSYUg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP
 id fv1-20020a17090b0e8100b001c65a9c5afamr219683pjb.1.1647478600405; Wed, 16
 Mar 2022 17:56:40 -0700 (PDT)
Date: Thu, 17 Mar 2022 00:56:29 +0000
In-Reply-To: <20220317005630.3666572-1-jingzhangos@google.com>
Message-Id: <20220317005630.3666572-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220317005630.3666572-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v1 1/2] KVM: arm64: Add arch specific exit reasons
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Sean Christopherson <seanjc@google.com>, 
 Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, 
 Ricardo Koller <ricarkol@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
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

Arch specific exit reasons have been available for other architectures.
Add arch specific exit reason support for ARM64, which would be used in
KVM stats for monitoring VCPU status.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 +++
 arch/arm64/include/asm/kvm_host.h    | 33 +++++++++++++++
 arch/arm64/kvm/handle_exit.c         | 62 +++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 ++
 arch/arm64/kvm/sys_regs.c            |  6 +++
 5 files changed, 105 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..f73c8d900642 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -321,6 +321,11 @@ static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
 }
 
+static inline bool kvm_vcpu_trap_is_dabt(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW;
+}
+
 static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 76f795b628f1..daa68b053bdc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -282,6 +282,36 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+enum arm_exit_reason {
+	ARM_EXIT_UNKNOWN,
+	ARM_EXIT_IRQ,
+	ARM_EXIT_EL1_SERROR,
+	ARM_EXIT_HYP_GONE,
+	ARM_EXIT_IL,
+	ARM_EXIT_WFI,
+	ARM_EXIT_WFE,
+	ARM_EXIT_CP15_32,
+	ARM_EXIT_CP15_64,
+	ARM_EXIT_CP14_32,
+	ARM_EXIT_CP14_LS,
+	ARM_EXIT_CP14_64,
+	ARM_EXIT_HVC32,
+	ARM_EXIT_SMC32,
+	ARM_EXIT_HVC64,
+	ARM_EXIT_SMC64,
+	ARM_EXIT_SYS64,
+	ARM_EXIT_SVE,
+	ARM_EXIT_IABT_LOW,
+	ARM_EXIT_DABT_LOW,
+	ARM_EXIT_SOFTSTP_LOW,
+	ARM_EXIT_WATCHPT_LOW,
+	ARM_EXIT_BREAKPT_LOW,
+	ARM_EXIT_BKPT32,
+	ARM_EXIT_BRK64,
+	ARM_EXIT_FP_ASIMD,
+	ARM_EXIT_PAC,
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
@@ -382,6 +412,9 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	/* Arch specific exit reason */
+	enum arm_exit_reason exit_reason;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e3140abd2e2e..cee0edaacded 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -49,6 +49,18 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int handle_hvc32(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_HVC32;
+	return handle_hvc(vcpu);
+}
+
+static int handle_hvc64(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_HVC64;
+	return handle_hvc(vcpu);
+}
+
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -64,12 +76,25 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_smc32(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_SMC32;
+	return handle_smc(vcpu);
+}
+
+static int handle_smc64(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_SMC64;
+	return handle_smc(vcpu);
+}
+
 /*
  * Guest access to FP/ASIMD registers are routed to this handler only
  * when the system doesn't support FP/ASIMD.
  */
 static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_FP_ASIMD;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -91,11 +116,13 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
+		vcpu->arch.exit_reason = ARM_EXIT_WFE;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_wfi(vcpu);
+		vcpu->arch.exit_reason = ARM_EXIT_WFI;
 	}
 
 	kvm_incr_pc(vcpu);
@@ -118,12 +145,29 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
 
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = esr;
 
-	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
+	switch (esr_ec) {
+	case ESR_ELx_EC_SOFTSTP_LOW:
+		vcpu->arch.exit_reason = ARM_EXIT_SOFTSTP_LOW;
+		break;
+	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
+		vcpu->arch.exit_reason = ARM_EXIT_WATCHPT_LOW;
+		break;
+	case ESR_ELx_EC_BREAKPT_LOW:
+		vcpu->arch.exit_reason = ARM_EXIT_BREAKPT_LOW;
+		break;
+	case ESR_ELx_EC_BKPT32:
+		vcpu->arch.exit_reason = ARM_EXIT_BKPT32;
+		break;
+	case ESR_ELx_EC_BRK64:
+		vcpu->arch.exit_reason = ARM_EXIT_BRK64;
+		break;
+	}
 
 	return 0;
 }
@@ -135,6 +179,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 	kvm_pr_unimpl("Unknown exception class: esr: %#08x -- %s\n",
 		      esr, esr_get_class_string(esr));
 
+	vcpu->arch.exit_reason = ARM_EXIT_UNKNOWN;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -145,6 +190,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
  */
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_SVE;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -156,6 +202,7 @@ static int handle_sve(struct kvm_vcpu *vcpu)
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_PAC;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -168,10 +215,10 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP14_MR]	= kvm_handle_cp14_32,
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
-	[ESR_ELx_EC_HVC32]	= handle_hvc,
-	[ESR_ELx_EC_SMC32]	= handle_smc,
-	[ESR_ELx_EC_HVC64]	= handle_hvc,
-	[ESR_ELx_EC_SMC64]	= handle_smc,
+	[ESR_ELx_EC_HVC32]	= handle_hvc32,
+	[ESR_ELx_EC_SMC32]	= handle_smc32,
+	[ESR_ELx_EC_HVC64]	= handle_hvc64,
+	[ESR_ELx_EC_SMC64]	= handle_smc64,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
@@ -240,8 +287,10 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
+		vcpu->arch.exit_reason = ARM_EXIT_IRQ;
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
+		vcpu->arch.exit_reason = ARM_EXIT_EL1_SERROR;
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		return handle_trap_exceptions(vcpu);
@@ -250,6 +299,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 * EL2 has been reset to the hyp-stub. This happens when a guest
 		 * is pre-empted by kvm_reboot()'s shutdown call.
 		 */
+		vcpu->arch.exit_reason = ARM_EXIT_HYP_GONE;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return 0;
 	case ARM_EXCEPTION_IL:
@@ -257,11 +307,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 * We attempted an illegal exception return.  Guest state must
 		 * have been corrupted somehow.  Give up.
 		 */
+		vcpu->arch.exit_reason = ARM_EXIT_IL;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return -EINVAL;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
 			      exception_index);
+		vcpu->arch.exit_reason = ARM_EXIT_UNKNOWN;
 		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		return 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1623abc56af2..657babe7857c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1333,6 +1333,10 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
+	if (is_iabt)
+		vcpu->arch.exit_reason = ARM_EXIT_IABT_LOW;
+	else if (kvm_vcpu_trap_is_dabt(vcpu))
+		vcpu->arch.exit_reason = ARM_EXIT_DABT_LOW;
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dd34b5ab51d4..156b6213b17d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2205,6 +2205,7 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_LS;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -2372,21 +2373,25 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP15_64;
 	return kvm_handle_cp_64(vcpu, cp15_64_regs, ARRAY_SIZE(cp15_64_regs));
 }
 
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP15_32;
 	return kvm_handle_cp_32(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
 }
 
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_64;
 	return kvm_handle_cp_64(vcpu, cp14_64_regs, ARRAY_SIZE(cp14_64_regs));
 }
 
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_32;
 	return kvm_handle_cp_32(vcpu, cp14_regs, ARRAY_SIZE(cp14_regs));
 }
 
@@ -2444,6 +2449,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	int ret;
 
 	trace_kvm_handle_sys_reg(esr);
+	vcpu->arch.exit_reason = ARM_EXIT_SYS64;
 
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
