Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C3AC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 01:09:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1503E611C6
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 01:09:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1503E611C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AEC6D4A19A;
	Tue, 21 Sep 2021 21:09:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oERp+18qHTWy; Tue, 21 Sep 2021 21:09:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A3C94A98B;
	Tue, 21 Sep 2021 21:09:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31E404A500
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 21:09:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nMAeknhVzoTU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Sep 2021 21:08:59 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D489D402A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 21:08:58 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 x4-20020a623104000000b004403bf677efso774452pfx.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Sep 2021 18:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=sGW2fsCucwKAx+N9pIkCoPlm26X6U3YR3lmhdqKDVdU=;
 b=WbGe7UNdWma8bLShXJwo7zCE9XwEdT3kcdyp3Nt0t2vfKny7Vpd4GY5SY3XpekAVsQ
 +fvE2hdXCKlG7/xRt5EkyPmnmWMjownUympX+uVs6AePkZt61bFJXVoT8U20VgMvdSyv
 qLVz2UvarX5FSLS5sy61eDd756bwN3HGayLDfVl2y6QwcBWD6MP8sMk9PAnSFl7zCL3s
 JcdnL+bANIVqk+JenFjsZwpi77dWKNKBrsSGCyqkAUbMXrVzH7GPII27gqtM80QMQRVA
 +Uo7+4P8jSwCkJEZi3wEIlnzZ6syamSljmkJjxjx3MvESMGNaggg9AcJo/kgt9JcMBCe
 rqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=sGW2fsCucwKAx+N9pIkCoPlm26X6U3YR3lmhdqKDVdU=;
 b=fgLcEoD3BhM2PKz1ht689nuWmYnQTncxZLTHK5ABTY5tWgotksdxKJ4VXRxfHnbKEa
 mDWUM+uNZP94eUXkCJXFkTCYkhVGH2iKezWbvaQURoQYRLcM9w2UYFW9qNxm7/msirD7
 2svkVnpDAPnvIBPXJRZN5NsQD1BXiDLpdFVearXx+euBSwOvVq5tTOV/HdUEIc54iTke
 gHJvbkZoHiMxOzkblEI3LlhlCC5cuh40M8dbry9nIqinpvkP6pa7AxnHOI9Dx2u23t6A
 vPzaZYKNXEwDpgJQLs/elWCHCrFjEV8wSk7+2YfaBj6OKWc9Ssepm+uqgH0ba1bO6Ss2
 g/nQ==
X-Gm-Message-State: AOAM530LKQtnFdNazrd0E7BmN5DEbD9MjOq4iv3Tt9SMdAuCnZ/Q37/N
 uLixlmdDte3p8+94ooLwAkzO5qQggOgcV5Oc4A==
X-Google-Smtp-Source: ABdhPJx/YywsIUtK6Hp8ZRHYKqWx/mO/ekbYhJ4nF5m/YnCsj8+sYSUQjssIreEdd1QHTiyRpqVqdw1kI1q2F0v6Rw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:100b:: with SMTP id
 gm11mr271591pjb.0.1632272937733;
 Tue, 21 Sep 2021 18:08:57 -0700 (PDT)
Date: Wed, 22 Sep 2021 01:08:50 +0000
In-Reply-To: <20210922010851.2312845-1-jingzhangos@google.com>
Message-Id: <20210922010851.2312845-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210922010851.2312845-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v1 2/3] KVM: arm64: Add counter stats for arch specific exit
 reasons
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, 
 David Matlack <dmatlack@google.com>, Peter Shier <pshier@google.com>, 
 Oliver Upton <oupton@google.com>, Sean Christopherson <seanjc@google.com>
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

The exit reason stats can be used for monitoring the VCPU status.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 33 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/guest.c            | 33 +++++++++++++++++++++++++++----
 arch/arm64/kvm/handle_exit.c      | 22 ++++++++++++++++++---
 arch/arm64/kvm/mmu.c              |  7 +++++--
 arch/arm64/kvm/sys_regs.c         |  6 ++++++
 5 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0f0cea26ce32..4d65de22add3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -607,13 +607,40 @@ struct kvm_vm_stat {
 
 struct kvm_vcpu_stat {
 	struct kvm_vcpu_stat_generic generic;
-	u64 hvc_exit_stat;
-	u64 wfe_exit_stat;
-	u64 wfi_exit_stat;
 	u64 mmio_exit_user;
 	u64 mmio_exit_kernel;
 	u64 signal_exits;
 	u64 exits;
+	/* Stats for arch specific exit reasons */
+	struct {
+		u64 exit_unknown;
+		u64 exit_irq;
+		u64 exit_el1_serror;
+		u64 exit_hyp_gone;
+		u64 exit_il;
+		u64 exit_wfi;
+		u64 exit_wfe;
+		u64 exit_cp15_32;
+		u64 exit_cp15_64;
+		u64 exit_cp14_32;
+		u64 exit_cp14_ls;
+		u64 exit_cp14_64;
+		u64 exit_hvc32;
+		u64 exit_smc32;
+		u64 exit_hvc64;
+		u64 exit_smc64;
+		u64 exit_sys64;
+		u64 exit_sve;
+		u64 exit_iabt_low;
+		u64 exit_dabt_low;
+		u64 exit_softstp_low;
+		u64 exit_watchpt_low;
+		u64 exit_breakpt_low;
+		u64 exit_bkpt32;
+		u64 exit_brk64;
+		u64 exit_fp_asimd;
+		u64 exit_pac;
+	};
 };
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5ce26bedf23c..abd9327d7110 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -43,13 +43,38 @@ const struct kvm_stats_header kvm_vm_stats_header = {
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
-	STATS_DESC_COUNTER(VCPU, hvc_exit_stat),
-	STATS_DESC_COUNTER(VCPU, wfe_exit_stat),
-	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
 	STATS_DESC_COUNTER(VCPU, signal_exits),
-	STATS_DESC_COUNTER(VCPU, exits)
+	STATS_DESC_COUNTER(VCPU, exits),
+	/* Stats for arch specific exit reasons */
+	STATS_DESC_COUNTER(VCPU, exit_unknown),
+	STATS_DESC_COUNTER(VCPU, exit_irq),
+	STATS_DESC_COUNTER(VCPU, exit_el1_serror),
+	STATS_DESC_COUNTER(VCPU, exit_hyp_gone),
+	STATS_DESC_COUNTER(VCPU, exit_il),
+	STATS_DESC_COUNTER(VCPU, exit_wfi),
+	STATS_DESC_COUNTER(VCPU, exit_wfe),
+	STATS_DESC_COUNTER(VCPU, exit_cp15_32),
+	STATS_DESC_COUNTER(VCPU, exit_cp15_64),
+	STATS_DESC_COUNTER(VCPU, exit_cp14_32),
+	STATS_DESC_COUNTER(VCPU, exit_cp14_ls),
+	STATS_DESC_COUNTER(VCPU, exit_cp14_64),
+	STATS_DESC_COUNTER(VCPU, exit_hvc32),
+	STATS_DESC_COUNTER(VCPU, exit_smc32),
+	STATS_DESC_COUNTER(VCPU, exit_hvc64),
+	STATS_DESC_COUNTER(VCPU, exit_smc64),
+	STATS_DESC_COUNTER(VCPU, exit_sys64),
+	STATS_DESC_COUNTER(VCPU, exit_sve),
+	STATS_DESC_COUNTER(VCPU, exit_iabt_low),
+	STATS_DESC_COUNTER(VCPU, exit_dabt_low),
+	STATS_DESC_COUNTER(VCPU, exit_softstp_low),
+	STATS_DESC_COUNTER(VCPU, exit_watchpt_low),
+	STATS_DESC_COUNTER(VCPU, exit_breakpt_low),
+	STATS_DESC_COUNTER(VCPU, exit_bkpt32),
+	STATS_DESC_COUNTER(VCPU, exit_brk64),
+	STATS_DESC_COUNTER(VCPU, exit_fp_asimd),
+	STATS_DESC_COUNTER(VCPU, exit_pac),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 90a47758b23d..e83cd52078b2 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -38,7 +38,6 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
 			    kvm_vcpu_hvc_get_imm(vcpu));
-	vcpu->stat.hvc_exit_stat++;
 
 	ret = kvm_hvc_call_handler(vcpu);
 	if (ret < 0) {
@@ -52,12 +51,14 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 static int handle_hvc32(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_HVC32;
+	++vcpu->stat.exit_hvc32;
 	return handle_hvc(vcpu);
 }
 
 static int handle_hvc64(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_HVC64;
+	++vcpu->stat.exit_hvc64;
 	return handle_hvc(vcpu);
 }
 
@@ -79,12 +80,14 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 static int handle_smc32(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_SMC32;
+	++vcpu->stat.exit_smc32;
 	return handle_smc(vcpu);
 }
 
 static int handle_smc64(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_SMC64;
+	++vcpu->stat.exit_smc64;
 	return handle_smc(vcpu);
 }
 
@@ -95,6 +98,7 @@ static int handle_smc64(struct kvm_vcpu *vcpu)
 static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_FP_ASIMD;
+	++vcpu->stat.exit_fp_asimd;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -115,13 +119,13 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
-		vcpu->stat.wfe_exit_stat++;
 		vcpu->arch.exit_reason = ARM_EXIT_WFE;
+		++vcpu->stat.exit_wfe;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
-		vcpu->stat.wfi_exit_stat++;
 		vcpu->arch.exit_reason = ARM_EXIT_WFI;
+		++vcpu->stat.exit_wfi;
 		kvm_vcpu_block(vcpu);
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
@@ -154,19 +158,24 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 	switch (esr_ec) {
 	case ESR_ELx_EC_SOFTSTP_LOW:
 		vcpu->arch.exit_reason = ARM_EXIT_SOFTSTP_LOW;
+		++vcpu->stat.exit_softstp_low;
 		break;
 	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
 		vcpu->arch.exit_reason = ARM_EXIT_WATCHPT_LOW;
+		++vcpu->stat.exit_watchpt_low;
 		break;
 	case ESR_ELx_EC_BREAKPT_LOW:
 		vcpu->arch.exit_reason = ARM_EXIT_BREAKPT_LOW;
+		++vcpu->stat.exit_breakpt_low;
 		break;
 	case ESR_ELx_EC_BKPT32:
 		vcpu->arch.exit_reason = ARM_EXIT_BKPT32;
+		++vcpu->stat.exit_bkpt32;
 		break;
 	case ESR_ELx_EC_BRK64:
 		vcpu->arch.exit_reason = ARM_EXIT_BRK64;
+		++vcpu->stat.exit_brk64;
 		break;
 	}
 
@@ -181,6 +190,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 		      esr, esr_get_class_string(esr));
 
 	vcpu->arch.exit_reason = ARM_EXIT_UNKNOWN;
+	++vcpu->stat.exit_unknown;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -188,6 +198,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_SVE;
+	++vcpu->stat.exit_sve;
 	/* Until SVE is supported for guests: */
 	kvm_inject_undefined(vcpu);
 	return 1;
@@ -201,6 +212,7 @@ static int handle_sve(struct kvm_vcpu *vcpu)
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_PAC;
+	++vcpu->stat.exit_pac;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -278,9 +290,11 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
 		vcpu->arch.exit_reason = ARM_EXIT_IRQ;
+		++vcpu->stat.exit_irq;
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
 		vcpu->arch.exit_reason = ARM_EXIT_EL1_SERROR;
+		++vcpu->stat.exit_el1_serror;
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		return handle_trap_exceptions(vcpu);
@@ -291,6 +305,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 */
 		vcpu->arch.exit_reason = ARM_EXIT_HYP_GONE;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		++vcpu->stat.exit_hyp_gone;
 		return 0;
 	case ARM_EXCEPTION_IL:
 		/*
@@ -299,6 +314,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 */
 		vcpu->arch.exit_reason = ARM_EXIT_IL;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		++vcpu->stat.exit_il;
 		return -EINVAL;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a6a18d113c98..799c756dd9f5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1197,10 +1197,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
-	if (is_iabt)
+	if (is_iabt) {
 		vcpu->arch.exit_reason = ARM_EXIT_IABT_LOW;
-	else if (kvm_vcpu_trap_is_dabt(vcpu))
+		++vcpu->stat.exit_iabt_low;
+	} else if (kvm_vcpu_trap_is_dabt(vcpu)) {
 		vcpu->arch.exit_reason = ARM_EXIT_DABT_LOW;
+		++vcpu->stat.exit_dabt_low;
+	}
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0915dfa589c7..344a6ff26bf6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2159,6 +2159,7 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_CP14_LS;
+	++vcpu->stat.exit_cp14_ls;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -2327,24 +2328,28 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_CP15_64;
+	++vcpu->stat.exit_cp15_64;
 	return kvm_handle_cp_64(vcpu, cp15_64_regs, ARRAY_SIZE(cp15_64_regs));
 }
 
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_CP15_32;
+	++vcpu->stat.exit_cp15_32;
 	return kvm_handle_cp_32(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
 }
 
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_CP14_64;
+	++vcpu->stat.exit_cp14_64;
 	return kvm_handle_cp_64(vcpu, cp14_64_regs, ARRAY_SIZE(cp14_64_regs));
 }
 
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.exit_reason = ARM_EXIT_CP14_32;
+	++vcpu->stat.exit_cp14_32;
 	return kvm_handle_cp_32(vcpu, cp14_regs, ARRAY_SIZE(cp14_regs));
 }
 
@@ -2403,6 +2408,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 	vcpu->arch.exit_reason = ARM_EXIT_SYS64;
+	++vcpu->stat.exit_sys64;
 
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
