Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93211C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 44841614C8
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:55:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 44841614C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDCDE4B20F;
	Fri, 24 Sep 2021 08:55:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fxgNFjHm12YI; Fri, 24 Sep 2021 08:54:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 067F94B211;
	Fri, 24 Sep 2021 08:54:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 203F04B156
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FSVHeQzuy7Gi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:54 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50A134B186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:54 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 z8-20020a056214040800b00380dea65c01so31191177qvx.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=h7avwCelVLDXrW65ivowhx5L97uC6oG1q5eldj7v03E=;
 b=HSj7gZGfE1Et2vmg3ht8IP44LkLd1mywKH9lU+M+SaqxPAhQomtoiMQDSdpuE1jlH0
 VjMgAJVQhNWJ6IR0dBYuKqen9a8e6ZwcErT6sKmrbHkSet6C+kMNx2fpZCShgK7tJ8i5
 Tfkk+GKBNixa2P/T7o4dn5RBzfOEocv2ZLWrqxfAOv+pXLMVKoRwTppWAkyyYZsYu5JF
 HdwISigqSEVHD9UFMlP8vbCfGs7HYpwttcpvRskdAZxLkbT4Mu8udkC7KtNx1ZUP139m
 RIxeaVjv2wRJ0JACk4h1lm/7OGP26Nfp3hla/AqHq6Sdwt8v4aXZ36GDhNxuFubJoe7E
 mwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=h7avwCelVLDXrW65ivowhx5L97uC6oG1q5eldj7v03E=;
 b=R9FUQpt61DkQweBbzZQdQ9FvgJvrHarQjgXws9vJoy0XBByJ+MIjcK8H1y3uuMyKHU
 +anuVIDP7ZnLuT5Xy6oWAloVV/vnTzMA01dDNARN8f8Z/4LBHisE3gR928qLPuYbWLWO
 2S3wpP7jTL/YSOwvvuYZF3ftqDhjeBH7K0HGBCuyRWiModm5PyPThPXHRvDmMzl1YW9J
 EiufYX3or8MpI8CgxMHfRUDBKbZO84VTb+cdt+w6v9mf8ERIe4I8DCCCJDhMiqNTIXNh
 CFTZ09R0Eph0ONe7CnqnJi+PqvbO8tf4tLqzmS/Uj0W2GuaT4PJU0kwEp7HdonAPtXoD
 MgTw==
X-Gm-Message-State: AOAM532m8EPwX+ds5qWBXIvy63cC24JH93/G2fwdPKJUIRt7vRN3x3aV
 T39jka4TvH7mucNiJjDRinLUUCGkJ9yIop2cMSKq3Yj0puuZcNaQs2rC/lKzVznvlshNC/ySUh6
 +tr9K8OlmAC5h1EfBSJ5HuINVtHTR94F0AbiTOOWWKwDDPgiRUTbkZOBdOlWAMvqZFAo=
X-Google-Smtp-Source: ABdhPJyL0t+coFpdVZMGEPsDbytWRe779HP4gPBcO06ejSv04CQaDTyhghz78sdKCUcnBSSiAMc7iJUGkA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:d989:: with SMTP id
 y9mr9535459qvj.67.1632488093954; 
 Fri, 24 Sep 2021 05:54:53 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:54 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-26-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 25/30] KVM: arm64: separate kvm_run() for protected VMs
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

Split kvm_run() for protected and non-protected VMs. Protected
VMs support fewer features, separating it out will ease the
refactoring and simplify the code.

This patch starts only by replicated the code from the
non-protected case, to make it easier to diff against future
patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 119 ++++++++++++++++++++++++++++++-
 1 file changed, 116 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index b90ec8db5864..9e79f97ba49e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -119,7 +119,7 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 	}
 }
 
-/* Restore VGICv3 state on non_VEH systems */
+/* Restore VGICv3 state on nVHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
@@ -166,8 +166,110 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
-/* Switch to the guest for legacy non-VHE systems */
-int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+/* Switch to the non-protected guest */
+static int __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_hyp_state *vcpu_hyps = &vcpu->arch.hyp_state;
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu->arch.ctxt;
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	bool pmu_switch_needed;
+	u64 exit_code;
+
+	/*
+	 * Having IRQs masked via PMR when entering the guest means the GIC
+	 * will not signal the CPU of interrupts of lower priority, and the
+	 * only way to get out will be via guest exceptions.
+	 * Naturally, we want to avoid this.
+	 */
+	if (system_uses_irq_prio_masking()) {
+		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
+		pmr_sync();
+	}
+
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	set_hyp_running_vcpu(host_ctxt, vcpu);
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
+
+	__sysreg_save_state_nvhe(host_ctxt);
+	/*
+	 * We must flush and disable the SPE buffer for nVHE, as
+	 * the translation regime(EL1&0) is going to be loaded with
+	 * that of the guest. And we must do this before we change the
+	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
+	 * before we load guest Stage1.
+	 */
+	__debug_save_host_buffers_nvhe(vcpu);
+
+	kvm_adjust_pc(vcpu_ctxt, vcpu_hyps);
+
+	/*
+	 * We must restore the 32-bit state before the sysregs, thanks
+	 * to erratum #852523 (Cortex-A57) or #853709 (Cortex-A72).
+	 *
+	 * Also, and in order to be able to deal with erratum #1319537 (A57)
+	 * and #1319367 (A72), we must ensure that all VM-related sysreg are
+	 * restored before we enable S2 translation.
+	 */
+	__sysreg32_restore_state(vcpu);
+	__sysreg_restore_state_nvhe(guest_ctxt);
+
+	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
+	__activate_traps(vcpu);
+
+	__hyp_vgic_restore_state(vcpu);
+	__timer_enable_traps();
+
+	__debug_switch_to_guest(vcpu);
+
+	do {
+		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
+		set_hyp_running_vcpu(hyp_ctxt, vcpu);
+
+		/* Jump in the fire! */
+		exit_code = __guest_enter(guest_ctxt);
+
+		/* And we're baaack! */
+	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
+
+	__sysreg_save_state_nvhe(guest_ctxt);
+	__sysreg32_save_state(vcpu);
+	__timer_disable_traps();
+	__hyp_vgic_save_state(vcpu);
+
+	__deactivate_traps(vcpu_hyps);
+	__load_host_stage2();
+
+	__sysreg_restore_state_nvhe(host_ctxt);
+
+	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED)
+		__fpsimd_save_fpexc32(vcpu);
+
+	__debug_switch_to_host(vcpu);
+	/*
+	 * This must come after restoring the host sysregs, since a non-VHE
+	 * system may enable SPE here and make use of the TTBRs.
+	 */
+	__debug_restore_host_buffers_nvhe(vcpu);
+
+	if (pmu_switch_needed)
+		__pmu_switch_to_host(host_ctxt);
+
+	/* Returning to host will clear PSR.I, remask PMR if needed */
+	if (system_uses_irq_prio_masking())
+		gic_write_pmr(GIC_PRIO_IRQOFF);
+
+	set_hyp_running_vcpu(host_ctxt, NULL);
+
+	return exit_code;
+}
+
+/* Switch to the protected guest */
+static int __kvm_vcpu_run_pvm(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
@@ -268,6 +370,17 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
+/* Switch to the guest for non-VHE and protected KVM systems */
+int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	vcpu = kern_hyp_va(vcpu);
+
+	if (likely(!kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+		return __kvm_vcpu_run_nvhe(vcpu);
+	else
+		return __kvm_vcpu_run_pvm(vcpu);
+}
+
 void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
