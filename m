Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94C0C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 42D9864F2B
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42D9864F2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3344B265;
	Thu,  4 Mar 2021 06:55:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rO2B00WJd7j0; Thu,  4 Mar 2021 06:55:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7BC4B662;
	Thu,  4 Mar 2021 06:55:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67A464B64F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jGKUp1-rwak7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:32 -0500 (EST)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D90EF4B265
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:32 -0500 (EST)
Received: by mail-qk1-f202.google.com with SMTP id b78so19301837qkg.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=zq69jRDNlaxce5+vmw4n2CQ1Wp5ynX9+rSiD/kv0Yt0=;
 b=XaXZ9qSAR6zGhWe1UcEluD9TtpvH5rGf9c09lDs42VVUj8D3sDl6U/750SfE8R5Gwy
 OEQvhWgkngQYO9Vw5qSWoB9hfgUxponqtPdrexWPtm9CORhT7IiCe5mDSEIkr7F8/5YS
 EwGWEATAiHisqrbysQmVzEyvQVYcItBf2e5G4wceTkswpRwVO74GQkz8Efxb1OT0LsRm
 sagkHpU+XwxeIc8BICfC3Zz6unerdewW0PWIfXhFuZoYfaEE6fn9+hpfgSC56IwEfik5
 22suzWSzou61JUne+GSaOk/V2V7LS0YnpO5ihAHM+5s18yprVX7PH0iOZnPfbx6Sz0Mk
 lZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=zq69jRDNlaxce5+vmw4n2CQ1Wp5ynX9+rSiD/kv0Yt0=;
 b=G/R413GP/iy96r+bbacatKblyRjdNTR+0WdiKKXV0a26Z8PNSg2dHKRn5Y5HaDC57Y
 ZCZX3RoiwBlokfukRyt42p9kkReWOca5YvbelwHc8g0xvERJ1u5S9EHqPFWoKeLBEh4v
 Vz8JHvO7aWwJyco3XjixyK1wPvYUBlLU+ofobY+H7RCKoS/H0OA+SKPjIPhYNU5n6m05
 rz1oGNXTzYbEUtpLgGULqLKmz4aLxupntJarMvB/Gbrcx8+r7XDNABJ8bqaI4OipRkQr
 Q74nPoNSUF6OHyIGR4lYKH/155Qr0kGqzHaIzgZ+xwDp9NCrDZzuyvV91UbfD9rpDyMF
 U8iQ==
X-Gm-Message-State: AOAM5310GDcrzcsamHGZYtECh5YflP4X+pY/DKUEVmZHIkuMoyKRxw+w
 MsNt8Uxg5m8KOOUqdONHA7bjHFOGHBGOqP0H5GzpOflQ1rls4rsfFceipQPZvyxBouR9lBy9sOb
 EZBF8lCDJzszpIYgeGDopgjHh9JaYISMmlow6/0gpvLgbOwGw5dz2ADmzNKZPB7sOFHKkaQ==
X-Google-Smtp-Source: ABdhPJyBOkU1SFhD4LYCTwByCmlB3+fIszpymai9fuuNVr1oMop2b9pbo+V5x5x32RpmG2wph51kb0qm7/k=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a0c:e750:: with SMTP id
 g16mr3537710qvn.57.1614858932249; 
 Thu, 04 Mar 2021 03:55:32 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:53 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-11-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 10/10] RFC: KVM: arm64: Manage FPSIMD state at EL2 for
 protected vCPUs
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Dave.Martin@arm.com
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

Protected VM's FPSIMD state must not be exposed to the host. Since the
FPSIMD state is switched lazily, hyp must take precautions to prevent
leaks. Do this by trapping FP access to EL2 to lazily save a protected
guest's state and lazily restore the hosts's state.

This is a little ahead of its time since it requires knowledge which
vcpus are protected or not (see the TODO).

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  5 ++
 arch/arm64/include/asm/kvm_hyp.h        |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h | 21 +++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 24 ++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 64 +++++++++++++++++++++----
 arch/arm64/kvm/hyp/vhe/switch.c         |  1 +
 6 files changed, 105 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8c5242d4ed73..5e39e1d7b41b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -236,6 +236,8 @@ struct kvm_pmu_events {
 
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
+	uint64_t fpexc32_el2;
+	struct user_fpsimd_state fpsimd_state;
 	struct kvm_pmu_events pmu_events;
 };
 
@@ -274,6 +276,9 @@ struct vcpu_reset_state {
  * cannot interfere with the hyp while it is running.
  */
 struct kvm_vcpu_arch_run {
+	/* Whether the vcpu is running as part of a protected vm */
+	bool protected;
+
 	/* Miscellaneous vcpu run state flags */
 	u64 flags;
 };
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index c0450828378b..35f5c939a222 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -13,6 +13,7 @@
 #include <asm/sysreg.h>
 
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+DECLARE_PER_CPU(struct kvm_vcpu *, kvm_protected_vcpu_fpsimd);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 53120cccd2a5..f387e8aa25df 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -181,6 +181,7 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu,
 				       struct kvm_vcpu_arch_run *run)
 {
+	struct kvm_host_data *host_data;
 	bool vhe, sve_guest, sve_host;
 	u8 esr_ec;
 
@@ -228,12 +229,27 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu,
 
 	isb();
 
+
+	if (run->protected) {
+		/* A protected vcpu's state might already be in registers. */
+		if (__this_cpu_read(kvm_protected_vcpu_fpsimd) == vcpu &&
+		    vcpu->arch.fpsimd_cpu == smp_processor_id()) {
+			goto out;
+		}
+
+		host_data = this_cpu_ptr(&kvm_host_data);
+	}
+
 	if (run->flags & KVM_ARM64_RUN_FP_HOST) {
 		/*
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
 		 */
-		if (sve_host) {
+		if (run->protected) {
+			if (cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
+				host_data->fpexc32_el2 = read_sysreg(fpexc32_el2);
+			__fpsimd_save_state(&host_data->fpsimd_state);
+		} else if (sve_host) {
 			struct thread_struct *thread = container_of(
 				vcpu->arch.host_fpsimd_state,
 				struct thread_struct, uw.fpsimd_state);
@@ -260,8 +276,11 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu,
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
 
+	__this_cpu_write(kvm_protected_vcpu_fpsimd, run->protected ? vcpu : NULL);
+
 	vcpu->arch.fpsimd_cpu = smp_processor_id();
 
+out:
 	run->flags |= KVM_ARM64_RUN_FP_ENABLED;
 
 	return true;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f012f8665ecc..bb77578c79d0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -166,6 +166,27 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	kvm_skip_host_instr();
 }
 
+static void handle_host_fpsimd(struct kvm_cpu_context *host_ctxt)
+{
+	struct kvm_host_data *host_data;
+
+	write_sysreg(read_sysreg(cptr_el2) & ~(u64)CPTR_EL2_TFP, cptr_el2);
+
+	/*
+	 * An FPSIMD trap from the host means the host's state has been saved
+	 * by hyp and needs to be restored.
+	 */
+	if (__this_cpu_read(kvm_protected_vcpu_fpsimd) == NULL)
+		return;
+
+	host_data = this_cpu_ptr(&kvm_host_data);
+	if (cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
+		write_sysreg(host_data->fpexc32_el2, fpexc32_el2);
+	__fpsimd_restore_state(&host_data->fpsimd_state);
+
+	__this_cpu_write(kvm_protected_vcpu_fpsimd, NULL);
+}
+
 void handle_trap(struct kvm_cpu_context *host_ctxt)
 {
 	u64 esr = read_sysreg_el2(SYS_ESR);
@@ -177,6 +198,9 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 	case ESR_ELx_EC_SMC64:
 		handle_host_smc(host_ctxt);
 		break;
+	case ESR_ELx_EC_FP_ASIMD:
+		handle_host_fpsimd(host_ctxt);
+		break;
 	default:
 		hyp_panic();
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index a0fbaf0ee309..5723baea14f1 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -30,8 +30,11 @@
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+DEFINE_PER_CPU(struct kvm_vcpu *, kvm_protected_vcpu_fpsimd);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+static DEFINE_PER_CPU(struct kvm_vcpu_arch_run *, kvm_hyp_vcpu_run);
+
 static void __activate_traps(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *run)
 {
 	u64 val;
@@ -64,10 +67,12 @@ static void __activate_traps(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *ru
 	}
 }
 
-static void __deactivate_traps(struct kvm_vcpu *vcpu)
+static void __deactivate_traps(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *run)
 {
 	extern char __kvm_hyp_host_vector[];
 	u64 mdcr_el2;
+	u64 hcr_el2;
+	u64 cptr_el2;
 
 	___deactivate_traps(vcpu);
 
@@ -95,12 +100,18 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
 	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
 
-	write_sysreg(mdcr_el2, mdcr_el2);
 	if (is_protected_kvm_enabled())
-		write_sysreg(HCR_HOST_NVHE_PROTECTED_FLAGS, hcr_el2);
+		hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
-		write_sysreg(HCR_HOST_NVHE_FLAGS, hcr_el2);
-	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
+		hcr_el2 = HCR_HOST_NVHE_FLAGS;
+
+	cptr_el2 = CPTR_EL2_DEFAULT;
+	if (run->protected)
+		cptr_el2 |= CPTR_EL2_TFP;
+
+	write_sysreg(mdcr_el2, mdcr_el2);
+	write_sysreg(hcr_el2, hcr_el2);
+	write_sysreg(cptr_el2, cptr_el2);
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
@@ -172,11 +183,36 @@ void __sync_vcpu_before_run(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *run
 
 	/* Clear host state to make misuse apparent. */
 	vcpu->arch.run.flags = 0;
+
+	if (run->protected) {
+		/*
+		 * For protected vCPUs, always initially disable FPSIMD so we
+		 * can avoid saving the state if it isn't used, but if it is
+		 * used, only save the state for the host if the host state is
+		 * loaded.
+		 */
+		run->flags &= ~(KVM_ARM64_RUN_FP_ENABLED |
+				KVM_ARM64_RUN_FP_HOST);
+		if (__this_cpu_read(kvm_protected_vcpu_fpsimd) == NULL)
+			run->flags |= KVM_ARM64_RUN_FP_HOST;
+	} else {
+		/*
+		 * For non-protecetd vCPUs on a system that can also host
+		 * protected vCPUs, ensure protected vCPU FPSIMD state isn't
+		 * used by another vCPU or saved as the host state.
+		 */
+		if (__this_cpu_read(kvm_protected_vcpu_fpsimd) != NULL)
+			run->flags &= ~(KVM_ARM64_RUN_FP_ENABLED |
+					KVM_ARM64_RUN_FP_HOST);
+	}
 }
 
 /* Sanitize the run state before writing it back to the host. */
 void __sync_vcpu_after_run(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *run)
 {
+	if (run->protected)
+		return;
+
 	vcpu->arch.run.flags = run->flags;
 }
 
@@ -203,10 +239,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	if (is_protected_kvm_enabled()) {
 		run = &protected_run;
+		/* TODO: safely check vcpu and set run->protected accordingly. */
+		run->protected = true;
 		__sync_vcpu_before_run(vcpu, run);
 	} else {
 		run = &vcpu->arch.run;
 	}
+	__this_cpu_write(kvm_hyp_vcpu_run, run);
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
@@ -249,14 +288,17 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
-	__deactivate_traps(vcpu);
+	if (run->flags & KVM_ARM64_RUN_FP_ENABLED) {
+		__fpsimd_save_fpexc32(vcpu);
+		if (run->protected)
+			__fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
+	}
+
+	__deactivate_traps(vcpu, run);
 	__load_host_stage2();
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (run->flags & KVM_ARM64_RUN_FP_ENABLED)
-		__fpsimd_save_fpexc32(vcpu);
-
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
@@ -284,15 +326,17 @@ void __noreturn hyp_panic(void)
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
 	bool restore_host = true;
+	struct kvm_vcpu_arch_run *run;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
+	run = __this_cpu_read(kvm_hyp_vcpu_run);
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	if (vcpu) {
 		__timer_disable_traps(vcpu);
-		__deactivate_traps(vcpu);
+		__deactivate_traps(vcpu, run);
 		__load_host_stage2();
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index ff3ce150d636..c1279d65d287 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -31,6 +31,7 @@ const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\n
 /* VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
+DEFINE_PER_CPU(struct kvm_vcpu *, kvm_protected_vcpu_fpsimd);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
