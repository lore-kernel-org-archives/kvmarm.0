Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2D8C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3CFD61407
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E3CFD61407
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B1214B1FB;
	Fri, 24 Sep 2021 08:55:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZtIIsQLR1rbp; Fri, 24 Sep 2021 08:55:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF484B219;
	Fri, 24 Sep 2021 08:55:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 297474B08F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:55:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rfoVfqBIvbt5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:59 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E685A4B20C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:58 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 m16-20020a25d410000000b005ab243aaaf4so3247703ybf.20
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6pASbSsT/Yef+KNtWRsM7REwBs8GiQAxHWrM4DAwh1s=;
 b=oYStHblXmyttk5JHb7mn/QeeOuyrSd9jwYFYzrB6dav9dTynlqaP3PEkx4wfPblOZ8
 xp41B097EPMoLP9xWck4D48TFdIQCmqPXQLfPXAMJv8vr0BPDf/h6yIlGb/6jibiVK96
 U1S32OOmVXqWVIa5Ays6LyLJ9/5Su8IRzQJak9EaCdedq4ixS1rUxKrxoxBsMGgaEK38
 r4xLPHw/Dijs2WEajb/iV+BetQ3xx/Fl+sTIBpcnuchQrWIk9VilcecF9ysdUfiiwQh9
 uKgtpvVv4hBbZp9kgr+K1J/uKpBrB+7OEQFPv5EPVyEmdR8t9M/6KEfoN54/27SEYeAi
 7KZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6pASbSsT/Yef+KNtWRsM7REwBs8GiQAxHWrM4DAwh1s=;
 b=ashI2RV4yeSeE9aIDBjIjuRF7BCDB5Ef46aM53GQ8TIgoT+PgsXZzu6CaNoL3WvAgX
 tyNZZEoiJptV9+i2cCsCAo0/9+8iYU/mQ2NKNDMo30YL4guILbkIRMPN0w2F29HJV+8S
 sVcrYH/hOBZE3AjyeMDhu/2PG3DIxaaY9pIMcO6PLdXbFNwNXDDRE0e7lyitOuyN/7Qt
 LfuFdpoMsGYL4NVUdWdwo5siy8NFrTPFo5ytUZPRNRJlLqT+CWz37ZxU68MU8c8ntX1J
 KNL+e+BxabWeF4pEJ5p8XS/N3SAc8D+hv6P59avK+954JEikmt2Pj7Cdqq+I8xUpZZIK
 uPlg==
X-Gm-Message-State: AOAM531QbHUTVmVRXJDrstlpVT1uat5bMx2xPymcO06lQ3KO4iyuDK5M
 2pRS6lRuaCFi63hea4g7tHCwqoxD2Eok4fZle43pe1KDOX8U9siWGLLBdPNi8dnGlNUTci2vbKc
 SQdqYx9l+FGle0OP0OXfl/QVg7XklDYefYRqjfpj40rjrRdKSV1d7gmSpWhianSGSdoY=
X-Google-Smtp-Source: ABdhPJz5QSOUNSvYae9zYQoRjlhXT3uab0VnL6rjHZdQg2Hs0A2XNNOhm8ErqHE0DojL6wYHc3wByV8RRw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:bdc5:: with SMTP id
 g5mr12073562ybk.403.1632488098448; 
 Fri, 24 Sep 2021 05:54:58 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:56 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-28-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 27/30] KVM: arm64: remove unsupported pVM features
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Remove code for unsupported features for protected VMs from
__kvm_vcpu_run_pvm(). Do not run unsupported code (SVE) in
__hyp_handle_fpsimd().

Enforcement of this is in the fixed features patch series [1].
The code removed or disabled is related to the following:
- PMU
- Debug
- Arm32
- SPE
- SVE

[1]
Link: https://lore.kernel.org/kvmarm/20210922124704.600087-1-tabba@google.com/T/#u

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  5 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        | 36 -------------------------
 2 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 433601f79b94..3ef429cfd9af 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -232,6 +232,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	const bool is_protected = is_nvhe_hyp_code() && kvm_vm_is_protected(kern_hyp_va(vcpu->kvm));
 	bool sve_guest, sve_host;
 	u8 esr_ec;
 	u64 reg;
@@ -239,7 +240,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	if (!system_supports_fpsimd())
 		return false;
 
-	if (system_supports_sve()) {
+	if (system_supports_sve() && !is_protected) {
 		sve_guest = hyp_state_has_sve(vcpu_hyps);
 		sve_host = hyp_state_flags(vcpu_hyps) & KVM_ARM64_HOST_SVE_IN_USE;
 	} else {
@@ -247,7 +248,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		sve_host = false;
 	}
 
-	esr_ec = kvm_vcpu_trap_get_class(vcpu);
+	esr_ec = kvm_hyp_state_trap_get_class(vcpu_hyps);
 	if (esr_ec != ESR_ELx_EC_FP_ASIMD &&
 	    esr_ec != ESR_ELx_EC_SVE)
 		return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0d654b324612..aa0dc4f0433b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -288,7 +288,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
-	bool pmu_switch_needed;
 	u64 exit_code;
 
 	/*
@@ -306,29 +305,10 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	set_hyp_running_vcpu(host_ctxt, vcpu);
 	guest_ctxt = &vcpu->arch.ctxt;
 
-	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
-
 	__sysreg_save_state_nvhe(host_ctxt);
-	/*
-	 * We must flush and disable the SPE buffer for nVHE, as
-	 * the translation regime(EL1&0) is going to be loaded with
-	 * that of the guest. And we must do this before we change the
-	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
-	 * before we load guest Stage1.
-	 */
-	__debug_save_host_buffers_nvhe(vcpu);
 
 	kvm_adjust_pc(vcpu_ctxt, vcpu_hyps);
 
-	/*
-	 * We must restore the 32-bit state before the sysregs, thanks
-	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
-	 *
-	 * Also, and in order to be able to deal with erratum #1319537 (A57)
-	 * and #1319367 (A72), we must ensure that all VM-related sysreg are
-	 * restored before we enable S2 translation.
-	 */
-	__sysreg32_restore_state(vcpu);
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
@@ -337,8 +317,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps();
 
-	__debug_switch_to_guest(vcpu);
-
 	do {
 		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
 		set_hyp_running_vcpu(hyp_ctxt, vcpu);
@@ -350,7 +328,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
-	__sysreg32_save_state(vcpu);
 	__timer_disable_traps();
 	__hyp_vgic_save_state(vcpu);
 
@@ -359,19 +336,6 @@ static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED)
-		__fpsimd_save_fpexc32(vcpu);
-
-	__debug_switch_to_host(vcpu);
-	/*
-	 * This must come after restoring the host sysregs, since a non-VHE
-	 * system may enable SPE here and make use of the TTBRs.
-	 */
-	__debug_restore_host_buffers_nvhe(vcpu);
-
-	if (pmu_switch_needed)
-		__pmu_switch_to_host(host_ctxt);
-
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQOFF);
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
