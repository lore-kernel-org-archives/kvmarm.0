Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13814C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 12 Apr 2022 13:14:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C030D40B8D;
	Tue, 12 Apr 2022 09:14:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pqXMepVDvTg3; Tue, 12 Apr 2022 09:14:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7518B4B2E5;
	Tue, 12 Apr 2022 09:14:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E41A4B263
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OIt54QA6qzMJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02A874B2A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2022 09:13:57 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 253CEB81D7A;
 Tue, 12 Apr 2022 13:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDD2C385B2;
 Tue, 12 Apr 2022 13:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1649769234;
 bh=Ut9f0t7P1uj9iDlWM5d1L6gPtrcHpfme+F7WU+3GL4U=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=LLymQ1mUulJsFhiJ4sMb86UekUZtrqwJj5vstOzuKmX23ymHphBBDOrJIGX+p83m5
 S4H5vQ6bGyhkBIi0t0Pmt6YT7bexazwXbXCaTwrxFdb0G9buniVx7b+jjvoW6Fiw8K
 MmopbAAOrEbsCX07bMYEGtGuOnNkClYLjGqtzEev21u5ygVhA4mGsk9ZaD0ioM8myo
 xvkn8V42Lleq8DWHZtYxu+qf+Wk9J6TiG+zAMyqwxmcioa80yxRJxnLCZstiBoKcaX
 4v85z/GIrs1rMPpNikXOdlwAJ7kXmZalIvBrDjhEtr+erhgWp4nMs10dCbxODwkR9B
 p9xhxtIBDJtng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1neGLA-003mvX-79; Tue, 12 Apr 2022 14:13:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 05/10] KVM: arm64: Handle blocking WFIT instruction
Date: Tue, 12 Apr 2022 14:12:58 +0100
Message-Id: <20220412131303.504690-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

When trapping a blocking WFIT instruction, take it into account when
computing the deadline of the background timer.

The state is tracked with a new vcpu flag, and is gated by a new
CPU capability, which isn't currently enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/arch_timer.c       | 22 ++++++++++++++++++++--
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/handle_exit.c      |  7 ++++++-
 arch/arm64/tools/cpucaps          |  1 +
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e3b25dc6c367..9e6e8701933e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -441,6 +441,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
 #define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
 #define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
+#define KVM_ARM64_WFIT			(1 << 16) /* WFIT instruction trapped */
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index c92a68190f6a..4e39ace073af 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -239,6 +239,20 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 		  (ARCH_TIMER_CTRL_IT_MASK | ARCH_TIMER_CTRL_ENABLE)) == ARCH_TIMER_CTRL_ENABLE);
 }
 
+static bool vcpu_has_wfit_active(struct kvm_vcpu *vcpu)
+{
+	return (cpus_have_final_cap(ARM64_HAS_WFXT) &&
+		(vcpu->arch.flags & KVM_ARM64_WFIT));
+}
+
+static u64 wfit_delay_ns(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_context *ctx = vcpu_vtimer(vcpu);
+	u64 val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
+
+	return kvm_counter_compute_delta(ctx, val);
+}
+
 /*
  * Returns the earliest expiration time in ns among guest timers.
  * Note that it will return 0 if none of timers can fire.
@@ -256,6 +270,9 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 			min_delta = min(min_delta, kvm_timer_compute_delta(ctx));
 	}
 
+	if (vcpu_has_wfit_active(vcpu))
+		min_delta = min(min_delta, wfit_delay_ns(vcpu));
+
 	/* If none of timers can fire, then return 0 */
 	if (min_delta == ULLONG_MAX)
 		return 0;
@@ -355,7 +372,7 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return 0;
+	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) == 0;
 }
 
 /*
@@ -481,7 +498,8 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 	 */
 	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
 	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
-	    !kvm_timer_irq_can_fire(map.emul_ptimer))
+	    !kvm_timer_irq_can_fire(map.emul_ptimer) &&
+	    !vcpu_has_wfit_active(vcpu))
 		return;
 
 	/*
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2122c699af06..e7cb8a4d2e81 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -634,6 +634,7 @@ void kvm_vcpu_wfi(struct kvm_vcpu *vcpu)
 	preempt_enable();
 
 	kvm_vcpu_halt(vcpu);
+	vcpu->arch.flags &= ~KVM_ARM64_WFIT;
 	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	preempt_disable();
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97fe14aab1a3..4260f2cd1971 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -85,16 +85,21 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
  * WFI: Simply call kvm_vcpu_halt(), which will halt execution of
  * world-switches and schedule other host processes until there is an
  * incoming IRQ or FIQ to the VM.
+ * WFIT: Same as WFI, with a timed wakeup implemented as a background timer
  */
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+
+	if (esr & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
+		if ((esr & (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT)) == (ESR_ELx_WFx_ISS_RV | ESR_ELx_WFx_ISS_WFxT))
+			vcpu->arch.flags |= KVM_ARM64_WFIT;
 		kvm_vcpu_wfi(vcpu);
 	}
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 3ed418f70e3b..01f7d253dec4 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -38,6 +38,7 @@ HAS_STAGE2_FWB
 HAS_SYSREG_GIC_CPUIF
 HAS_TLB_RANGE
 HAS_VIRT_HOST_EXTN
+HAS_WFXT
 HW_DBM
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
