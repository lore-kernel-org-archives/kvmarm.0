Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CBDC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:23:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 66EAA61242
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 11:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 66EAA61242
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BBCF4B11F;
	Thu, 23 Sep 2021 07:23:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ntLzy2zVNDAM; Thu, 23 Sep 2021 07:23:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3C4F4B11A;
	Thu, 23 Sep 2021 07:23:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E24F4B104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:23:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J1TozF8soK7E for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 07:23:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0B2394B118
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 07:23:07 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D220061241;
 Thu, 23 Sep 2021 11:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1632396186;
 bh=/zJUSJKXZe/aGPOpfIYreLSK8t3hSTo2hsTEZp3Ikqk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=bnqY0KwUADqS8/Np/UzJ+g2TMa8/7N+uBeREmHHeqa3yqKJysd/0GDn8C6TFnvZPx
 QwWRM5eFl0tAhYQumLns7Ngq4pqviU/d880hB3Ez+gQcV1zMfrdsjLp9rVYB4MX5Qr
 gNYJjMk8fGZj8T5TFcslxQpPk/M4HduVW1NZGGWTWzPZZqSxzHRapu9QQcNXWgDIX2
 wtGHKo+b/U3IWMIjFUCgPyML7godbRP6Ra0urH6lCrlAn4qNHag88YN9hMQhFIVVd1
 uGTdQ/dvU0fsQhRHBfRhemQ2Qg2QcVN3qg2QyV2teMvBGgOn70H6QmuxqOfGvR6pim
 Q37kDgzlo4LIg==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/5] KVM: arm64: Reject stub hypercalls after pKVM has been
 initialised
Date: Thu, 23 Sep 2021 12:22:53 +0100
Message-Id: <20210923112256.15767-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210923112256.15767-1-will@kernel.org>
References: <20210923112256.15767-1-will@kernel.org>
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
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
