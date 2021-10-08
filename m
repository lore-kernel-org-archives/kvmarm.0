Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61229C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 00FE561056
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 13:59:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 00FE561056
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A979A4B0BF;
	Fri,  8 Oct 2021 09:59:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cJqfVK-jQysv; Fri,  8 Oct 2021 09:59:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 78ED34B119;
	Fri,  8 Oct 2021 09:59:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 275694B0B8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2GnX7e8cMaIO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 09:58:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09C854B163
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 09:58:58 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18E0861056;
 Fri,  8 Oct 2021 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1633701535;
 bh=THAlxcDV712qvLejzcM9lEPGBVTOj85hI6UndSHWDKg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=nOWO2PXB0Gu+Ow9FoCztac2S16PKjIm0eujzQk36OfMS96Lcbn033D4OiMXTs8G9c
 vaSwXz1k51S1DF9Argmhs183BwNAEAw5jlStx8fOHa+MbA194MO6k3M/teNh5Ts3GM
 syCr5UfKQ5rPEwPkRxAhwWm9ZTNdROYxIuYbe1xaN0FRcVG13RzeAPUnUDmXvpPRjS
 lHHzd3W1wzExcpRld5I4xs8B2+6zlgwARwg/S6KHTZPQlQOqvdZTVdkflnctMaV90q
 ZPLKZ4bJmMPid52WWHq/bmg9sCeWpCRpxUtFrn+neSB09nsWcBezt5g5n6yGnnUGFk
 vqY14/+xltMFA==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 3/6] KVM: arm64: Reject stub hypercalls after pKVM has been
 initialised
Date: Fri,  8 Oct 2021 14:58:36 +0100
Message-Id: <20211008135839.1193-4-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211008135839.1193-1-will@kernel.org>
References: <20211008135839.1193-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

The stub hypercalls provide mechanisms to reset and replace the EL2 code,
so uninstall them once pKVM has been initialised in order to ensure the
integrity of the hypervisor code.

To ensure pKVM initialisation remains functional, split cpu_hyp_reinit()
into two helper functions to separate usage of the stub from usage of
pkvm hypercalls either side of __pkvm_init on the boot CPU.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c           | 31 +++++++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/host.S | 26 +++++++++++++++++---------
 2 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..9506cf88fa0e 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1579,25 +1579,33 @@ static void cpu_set_hyp_vector(void)
 		kvm_call_hyp_nvhe(__pkvm_cpu_set_vector, data->slot);
 }
 
-static void cpu_hyp_reinit(void)
+static void cpu_hyp_init_context(void)
 {
 	kvm_init_host_cpu_context(&this_cpu_ptr_hyp_sym(kvm_host_data)->host_ctxt);
 
-	cpu_hyp_reset();
-
-	if (is_kernel_in_hyp_mode())
-		kvm_timer_init_vhe();
-	else
+	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
+}
 
+static void cpu_hyp_init_features(void)
+{
 	cpu_set_hyp_vector();
-
 	kvm_arm_init_debug();
 
+	if (is_kernel_in_hyp_mode())
+		kvm_timer_init_vhe();
+
 	if (vgic_present)
 		kvm_vgic_init_cpu_hardware();
 }
 
+static void cpu_hyp_reinit(void)
+{
+	cpu_hyp_reset();
+	cpu_hyp_init_context();
+	cpu_hyp_init_features();
+}
+
 static void _kvm_arch_hardware_enable(void *discard)
 {
 	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
@@ -1788,10 +1796,17 @@ static int do_pkvm_init(u32 hyp_va_bits)
 	int ret;
 
 	preempt_disable();
-	hyp_install_host_vector();
+	cpu_hyp_init_context();
 	ret = kvm_call_hyp_nvhe(__pkvm_init, hyp_mem_base, hyp_mem_size,
 				num_possible_cpus(), kern_hyp_va(per_cpu_base),
 				hyp_va_bits);
+	cpu_hyp_init_features();
+
+	/*
+	 * The stub hypercalls are now disabled, so set our local flag to
+	 * prevent a later re-init attempt in kvm_arch_hardware_enable().
+	 */
+	__this_cpu_write(kvm_arm_hardware_enabled, 1);
 	preempt_enable();
 
 	return ret;
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 4b652ffb591d..0c6116d34e18 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -110,17 +110,14 @@ SYM_FUNC_START(__hyp_do_panic)
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
-.macro host_el1_sync_vect
-	.align 7
-.L__vect_start\@:
-	stp	x0, x1, [sp, #-16]!
-	mrs	x0, esr_el2
-	lsr	x0, x0, #ESR_ELx_EC_SHIFT
-	cmp	x0, #ESR_ELx_EC_HVC64
-	b.ne	__host_exit
-
+SYM_FUNC_START(__host_hvc)
 	ldp	x0, x1, [sp]		// Don't fixup the stack yet
 
+	/* No stub for you, sonny Jim */
+alternative_if ARM64_KVM_PROTECTED_MODE
+	b	__host_exit
+alternative_else_nop_endif
+
 	/* Check for a stub HVC call */
 	cmp	x0, #HVC_STUB_HCALL_NR
 	b.hs	__host_exit
@@ -137,6 +134,17 @@ SYM_FUNC_END(__hyp_do_panic)
 	ldr	x5, =__kvm_handle_stub_hvc
 	hyp_pa	x5, x6
 	br	x5
+SYM_FUNC_END(__host_hvc)
+
+.macro host_el1_sync_vect
+	.align 7
+.L__vect_start\@:
+	stp	x0, x1, [sp, #-16]!
+	mrs	x0, esr_el2
+	lsr	x0, x0, #ESR_ELx_EC_SHIFT
+	cmp	x0, #ESR_ELx_EC_HVC64
+	b.eq	__host_hvc
+	b	__host_exit
 .L__vect_end\@:
 .if ((.L__vect_end\@ - .L__vect_start\@) > 0x80)
 	.error "host_el1_sync_vect larger than vector entry"
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
