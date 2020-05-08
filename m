Return-Path: <SRS0=TDzU=6W=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF55C38A2A
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 12:11:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4B06720725
	for <kvmarm@archiver.kernel.org>; Fri,  8 May 2020 12:11:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FyQ12mCz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B06720725
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 032354B1BE;
	Fri,  8 May 2020 08:11:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3rBv0r+iCQT2; Fri,  8 May 2020 08:11:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 061CE4B1D6;
	Fri,  8 May 2020 08:11:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1A334B582
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 23:30:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c-MnXaGYXcNE for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2020 23:30:50 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 211674B580
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2020 23:30:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1588908650;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=h9lhs1PcBHTpdjq8SBzGlhFV+gCwN7XkqnGXb6+NKkI=;
 b=FyQ12mCzWNGIBotYQDvb8atYkO7oINEaIuPQzc55F3/KBnyaALVXEyyGLv276LRasA8K4p
 6Jg7N5LZtI5ht6AjRVT/yVbOLcMKxkOxSBqEK5zvkTekAgVO08jyRHsmKWLIjz8x+ht8Mf
 pJhSW4OiG2hYv+RDxGa8Vr2ziKgIdJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-qECf7BuGNIebsBd8UiLMzg-1; Thu, 07 May 2020 23:30:46 -0400
X-MC-Unique: qECf7BuGNIebsBd8UiLMzg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76DC8107ACCA;
 Fri,  8 May 2020 03:30:44 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-199.bne.redhat.com
 [10.64.54.199])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A46EC99CF;
 Fri,  8 May 2020 03:30:35 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH RFCv2 4/9] kvm/arm64: Detach ESR operator from vCPU struct
Date: Fri,  8 May 2020 13:29:14 +1000
Message-Id: <20200508032919.52147-5-gshan@redhat.com>
In-Reply-To: <20200508032919.52147-1-gshan@redhat.com>
References: <20200508032919.52147-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mailman-Approved-At: Fri, 08 May 2020 08:11:07 -0400
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

There are a set of inline functions defined in kvm_emulate.h. Those
functions reads ESR from vCPU fault information struct and then operate
on it. So it's tied with vCPU fault information and vCPU struct. It
limits their usage scope.

This detaches these functions from the vCPU struct. With this, the
caller has flexibility on where the ESR is read. It shouldn't cause
any functional changes.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_emulate.h     | 83 +++++++++++-------------
 arch/arm64/kvm/handle_exit.c             | 20 ++++--
 arch/arm64/kvm/hyp/switch.c              | 24 ++++---
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  7 +-
 arch/arm64/kvm/inject_fault.c            |  4 +-
 arch/arm64/kvm/sys_regs.c                | 12 ++--
 virt/kvm/arm/arm.c                       |  4 +-
 virt/kvm/arm/hyp/aarch32.c               |  2 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c            |  5 +-
 virt/kvm/arm/mmio.c                      | 27 ++++----
 virt/kvm/arm/mmu.c                       | 22 ++++---
 11 files changed, 112 insertions(+), 98 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bd1a69e7c104..2873bf6dc85e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -270,10 +270,8 @@ static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.esr_el2;
 }
 
-static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
+static __always_inline int kvm_vcpu_get_condition(u32 esr)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
-
 	if (esr & ESR_ELx_CV)
 		return (esr & ESR_ELx_COND_MASK) >> ESR_ELx_COND_SHIFT;
 
@@ -295,88 +293,86 @@ static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault.disr_el1;
 }
 
-static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
+static __always_inline u32 kvm_vcpu_hvc_get_imm(u32 esr)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_xVC_IMM_MASK;
+	return esr & ESR_ELx_xVC_IMM_MASK;
 }
 
-static __always_inline bool kvm_vcpu_dabt_isvalid(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_dabt_isvalid(u32 esr)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_ISV);
+	return !!(esr & ESR_ELx_ISV);
 }
 
-static inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(const struct kvm_vcpu *vcpu)
+static __always_inline unsigned long kvm_vcpu_dabt_iss_nisv_sanitized(u32 esr)
 {
-	return kvm_vcpu_get_esr(vcpu) &
-	       (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
+	return esr & (ESR_ELx_CM | ESR_ELx_WNR | ESR_ELx_FSC);
 }
 
-static inline bool kvm_vcpu_dabt_issext(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_dabt_issext(u32 esr)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SSE);
+	return !!(esr & ESR_ELx_SSE);
 }
 
-static inline bool kvm_vcpu_dabt_issf(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_dabt_issf(u32 esr)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_SF);
+	return !!(esr & ESR_ELx_SF);
 }
 
-static __always_inline int kvm_vcpu_dabt_get_rd(const struct kvm_vcpu *vcpu)
+static __always_inline int kvm_vcpu_dabt_get_rd(u32 esr)
 {
-	return (kvm_vcpu_get_esr(vcpu) & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
+	return (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
 }
 
-static __always_inline bool kvm_vcpu_dabt_iss1tw(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_dabt_iss1tw(u32 esr)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_S1PTW);
+	return !!(esr & ESR_ELx_S1PTW);
 }
 
-static __always_inline bool kvm_vcpu_dabt_iswrite(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_dabt_iswrite(u32 esr)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_WNR) ||
-		kvm_vcpu_dabt_iss1tw(vcpu); /* AF/DBM update */
+	return !!(esr & ESR_ELx_WNR) ||
+		kvm_vcpu_dabt_iss1tw(esr); /* AF/DBM update */
 }
 
-static inline bool kvm_vcpu_dabt_is_cm(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_dabt_is_cm(u32 esr)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_CM);
+	return !!(esr & ESR_ELx_CM);
 }
 
-static __always_inline unsigned int kvm_vcpu_dabt_get_as(const struct kvm_vcpu *vcpu)
+static __always_inline unsigned int kvm_vcpu_dabt_get_as(u32 esr)
 {
-	return 1 << ((kvm_vcpu_get_esr(vcpu) & ESR_ELx_SAS) >>
-		     ESR_ELx_SAS_SHIFT);
+	return 1 << ((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
 }
 
 /* This one is not specific to Data Abort */
-static __always_inline bool kvm_vcpu_trap_il_is32bit(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_trap_il_is32bit(u32 esr)
 {
-	return !!(kvm_vcpu_get_esr(vcpu) & ESR_ELx_IL);
+	return !!(esr & ESR_ELx_IL);
 }
 
-static __always_inline u8 kvm_vcpu_trap_get_class(const struct kvm_vcpu *vcpu)
+static __always_inline u8 kvm_vcpu_trap_get_class(u32 esr)
 {
-	return ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
+	return ESR_ELx_EC(esr);
 }
 
-static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_trap_is_iabt(u32 esr)
 {
-	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
+	return kvm_vcpu_trap_get_class(esr) == ESR_ELx_EC_IABT_LOW;
 }
 
-static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
+static __always_inline u8 kvm_vcpu_trap_get_fault(u32 esr)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
+	return esr & ESR_ELx_FSC;
 }
 
-static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
+static __always_inline u8 kvm_vcpu_trap_get_fault_type(u32 esr)
 {
-	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
+	return esr & ESR_ELx_FSC_TYPE;
 }
 
-static __always_inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_vcpu_dabt_isextabt(u32 esr)
 {
-	switch (kvm_vcpu_trap_get_fault(vcpu)) {
+	switch (kvm_vcpu_trap_get_fault(esr)) {
 	case FSC_SEA:
 	case FSC_SEA_TTW0:
 	case FSC_SEA_TTW1:
@@ -393,18 +389,17 @@ static __always_inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
 	}
 }
 
-static __always_inline int kvm_vcpu_sys_get_rt(struct kvm_vcpu *vcpu)
+static __always_inline int kvm_vcpu_sys_get_rt(u32 esr)
 {
-	u32 esr = kvm_vcpu_get_esr(vcpu);
 	return ESR_ELx_SYS64_ISS_RT(esr);
 }
 
-static inline bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_is_write_fault(u32 esr)
 {
-	if (kvm_vcpu_trap_is_iabt(vcpu))
+	if (kvm_vcpu_trap_is_iabt(esr))
 		return false;
 
-	return kvm_vcpu_dabt_iswrite(vcpu);
+	return kvm_vcpu_dabt_iswrite(esr);
 }
 
 static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
@@ -527,7 +522,7 @@ static __always_inline void __hyp_text __kvm_skip_instr(struct kvm_vcpu *vcpu)
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	vcpu->arch.ctxt.gp_regs.regs.pstate = read_sysreg_el2(SYS_SPSR);
 
-	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(kvm_vcpu_get_esr(vcpu)));
 
 	write_sysreg_el2(vcpu->arch.ctxt.gp_regs.regs.pstate, SYS_SPSR);
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index c5b75a4d5eda..00858db82a64 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -38,7 +38,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	int ret;
 
 	trace_kvm_hvc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
-			    kvm_vcpu_hvc_get_imm(vcpu));
+			    kvm_vcpu_hvc_get_imm(kvm_vcpu_get_esr(vcpu)));
 	vcpu->stat.hvc_exit_stat++;
 
 	ret = kvm_hvc_call_handler(vcpu);
@@ -52,6 +52,8 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
@@ -61,7 +63,7 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	 * otherwise return to the same address...
 	 */
 	vcpu_set_reg(vcpu, 0, ~0UL);
-	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(esr));
 	return 1;
 }
 
@@ -89,7 +91,9 @@ static int handle_no_fpsimd(struct kvm_vcpu *vcpu, struct kvm_run *run)
  */
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+
+	if (esr & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
@@ -100,7 +104,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
 
-	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(esr));
 
 	return 1;
 }
@@ -240,6 +244,7 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
  */
 static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	int handled;
 
 	/*
@@ -247,7 +252,7 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	 * that fail their condition code check"
 	 */
 	if (!kvm_condition_valid(vcpu)) {
-		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(esr));
 		handled = 1;
 	} else {
 		exit_handle_fn exit_handler;
@@ -267,7 +272,8 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		       int exception_index)
 {
 	if (ARM_SERROR_PENDING(exception_index)) {
-		u8 hsr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
+		u32 esr = kvm_vcpu_get_esr(vcpu);
+		u8 hsr_ec = ESR_ELx_EC(esr);
 
 		/*
 		 * HVC/SMC already have an adjusted PC, which we need
@@ -276,7 +282,7 @@ int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 */
 		if (hsr_ec == ESR_ELx_EC_HVC32 || hsr_ec == ESR_ELx_EC_HVC64 ||
 		    hsr_ec == ESR_ELx_EC_SMC32 || hsr_ec == ESR_ELx_EC_SMC64) {
-			u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
+			u32 adj =  kvm_vcpu_trap_il_is32bit(esr) ? 4 : 2;
 			*vcpu_pc(vcpu) -= adj;
 		}
 
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 2c3242bcfed2..369f22f49f3d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -355,6 +355,7 @@ static bool __hyp_text __populate_fault_info(struct kvm_vcpu *vcpu)
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
 static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	bool vhe, sve_guest, sve_host;
 	u8 hsr_ec;
 
@@ -371,7 +372,7 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		vhe = has_vhe();
 	}
 
-	hsr_ec = kvm_vcpu_trap_get_class(vcpu);
+	hsr_ec = kvm_vcpu_trap_get_class(esr);
 	if (hsr_ec != ESR_ELx_EC_FP_ASIMD &&
 	    hsr_ec != ESR_ELx_EC_SVE)
 		return false;
@@ -438,7 +439,8 @@ static bool __hyp_text __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 static bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
 {
 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
-	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	int rt = kvm_vcpu_sys_get_rt(esr);
 	u64 val = vcpu_get_reg(vcpu, rt);
 
 	/*
@@ -497,6 +499,8 @@ static bool __hyp_text handle_tx2_tvm(struct kvm_vcpu *vcpu)
  */
 static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
@@ -510,7 +514,7 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 		goto exit;
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
-	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 &&
+	    kvm_vcpu_trap_get_class(esr) == ESR_ELx_EC_SYS64 &&
 	    handle_tx2_tvm(vcpu))
 		return true;
 
@@ -530,11 +534,11 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		bool valid;
 
-		valid = kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW &&
-			kvm_vcpu_trap_get_fault_type(vcpu) == FSC_FAULT &&
-			kvm_vcpu_dabt_isvalid(vcpu) &&
-			!kvm_vcpu_dabt_isextabt(vcpu) &&
-			!kvm_vcpu_dabt_iss1tw(vcpu);
+		valid = kvm_vcpu_trap_get_class(esr) == ESR_ELx_EC_DABT_LOW &&
+			kvm_vcpu_trap_get_fault_type(esr) == FSC_FAULT &&
+			kvm_vcpu_dabt_isvalid(esr) &&
+			!kvm_vcpu_dabt_isextabt(esr) &&
+			!kvm_vcpu_dabt_iss1tw(esr);
 
 		if (valid) {
 			int ret = __vgic_v2_perform_cpuif_access(vcpu);
@@ -551,8 +555,8 @@ static bool __hyp_text fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	}
 
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
-	    (kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_SYS64 ||
-	     kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_CP15_32)) {
+	    (kvm_vcpu_trap_get_class(esr) == ESR_ELx_EC_SYS64 ||
+	     kvm_vcpu_trap_get_class(esr) == ESR_ELx_EC_CP15_32)) {
 		int ret = __vgic_v3_perform_cpuif_access(vcpu);
 
 		if (ret == 1)
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 4f3a087e36d5..bcf13a074b69 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -36,6 +36,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	phys_addr_t fault_ipa;
 	void __iomem *addr;
 	int rd;
@@ -50,7 +51,7 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return 0;
 
 	/* Reject anything but a 32bit access */
-	if (kvm_vcpu_dabt_get_as(vcpu) != sizeof(u32)) {
+	if (kvm_vcpu_dabt_get_as(esr) != sizeof(u32)) {
 		__kvm_skip_instr(vcpu);
 		return -1;
 	}
@@ -61,11 +62,11 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 	}
 
-	rd = kvm_vcpu_dabt_get_rd(vcpu);
+	rd = kvm_vcpu_dabt_get_rd(esr);
 	addr  = hyp_symbol_addr(kvm_vgic_global_state)->vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
-	if (kvm_vcpu_dabt_iswrite(vcpu)) {
+	if (kvm_vcpu_dabt_iswrite(esr)) {
 		u32 data = vcpu_get_reg(vcpu, rd);
 		if (__is_be(vcpu)) {
 			/* guest pre-swabbed data, undo this for writel() */
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index 6aafc2825c1c..0ae7c2e40e02 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -128,7 +128,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	 * Build an {i,d}abort, depending on the level and the
 	 * instruction set. Report an external synchronous abort.
 	 */
-	if (kvm_vcpu_trap_il_is32bit(vcpu))
+	if (kvm_vcpu_trap_il_is32bit(kvm_vcpu_get_esr(vcpu)))
 		esr |= ESR_ELx_IL;
 
 	/*
@@ -161,7 +161,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	 * Build an unknown exception, depending on the instruction
 	 * set.
 	 */
-	if (kvm_vcpu_trap_il_is32bit(vcpu))
+	if (kvm_vcpu_trap_il_is32bit(kvm_vcpu_get_esr(vcpu)))
 		esr |= ESR_ELx_IL;
 
 	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5b61465927b7..012fff834a4b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2126,6 +2126,7 @@ static void perform_access(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params,
 			   const struct sys_reg_desc *r)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
 
 	/* Check for regs disabled by runtime config */
@@ -2143,7 +2144,7 @@ static void perform_access(struct kvm_vcpu *vcpu,
 
 	/* Skip instruction if instructed so */
 	if (likely(r->access(vcpu, params, r)))
-		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(esr));
 }
 
 /*
@@ -2180,7 +2181,8 @@ static int emulate_cp(struct kvm_vcpu *vcpu,
 static void unhandled_cp_access(struct kvm_vcpu *vcpu,
 				struct sys_reg_params *params)
 {
-	u8 hsr_ec = kvm_vcpu_trap_get_class(vcpu);
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 hsr_ec = kvm_vcpu_trap_get_class(esr);
 	int cp = -1;
 
 	switch(hsr_ec) {
@@ -2215,7 +2217,7 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
 {
 	struct sys_reg_params params;
 	u32 hsr = kvm_vcpu_get_esr(vcpu);
-	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+	int Rt = kvm_vcpu_sys_get_rt(hsr);
 	int Rt2 = (hsr >> 10) & 0x1f;
 
 	params.is_aarch32 = true;
@@ -2272,7 +2274,7 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 {
 	struct sys_reg_params params;
 	u32 hsr = kvm_vcpu_get_esr(vcpu);
-	int Rt  = kvm_vcpu_sys_get_rt(vcpu);
+	int Rt  = kvm_vcpu_sys_get_rt(hsr);
 
 	params.is_aarch32 = true;
 	params.is_32bit = true;
@@ -2388,7 +2390,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
-	int Rt = kvm_vcpu_sys_get_rt(vcpu);
+	int Rt = kvm_vcpu_sys_get_rt(esr);
 	int ret;
 
 	trace_kvm_handle_sys_reg(esr);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 48d0ec44ad77..2cbb57485760 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -808,7 +808,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * guest time.
 		 */
 		guest_exit();
-		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		trace_kvm_exit(ret,
+			kvm_vcpu_trap_get_class(kvm_vcpu_get_esr(vcpu)),
+			*vcpu_pc(vcpu));
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, run, ret);
diff --git a/virt/kvm/arm/hyp/aarch32.c b/virt/kvm/arm/hyp/aarch32.c
index 864b477e660a..df3055ab3a42 100644
--- a/virt/kvm/arm/hyp/aarch32.c
+++ b/virt/kvm/arm/hyp/aarch32.c
@@ -55,7 +55,7 @@ bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 		return true;
 
 	/* Is condition field valid? */
-	cond = kvm_vcpu_get_condition(vcpu);
+	cond = kvm_vcpu_get_condition(kvm_vcpu_get_esr(vcpu));
 	if (cond == 0xE)
 		return true;
 
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 8a7a14ec9120..bb2174b8a086 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -1000,14 +1000,13 @@ static void __hyp_text __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu,
 
 int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	int rt;
-	u32 esr;
 	u32 vmcr;
 	void (*fn)(struct kvm_vcpu *, u32, int);
 	bool is_read;
 	u32 sysreg;
 
-	esr = kvm_vcpu_get_esr(vcpu);
 	if (vcpu_mode_is_32bit(vcpu)) {
 		if (!kvm_condition_valid(vcpu)) {
 			__kvm_skip_instr(vcpu);
@@ -1119,7 +1118,7 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	}
 
 	vmcr = __vgic_v3_read_vmcr();
-	rt = kvm_vcpu_sys_get_rt(vcpu);
+	rt = kvm_vcpu_sys_get_rt(esr);
 	fn(vcpu, vmcr, rt);
 
 	__kvm_skip_instr(vcpu);
diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
index aedfcff99ac5..d92bee8c75e3 100644
--- a/virt/kvm/arm/mmio.c
+++ b/virt/kvm/arm/mmio.c
@@ -81,6 +81,7 @@ unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len)
  */
 int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	unsigned long data;
 	unsigned int len;
 	int mask;
@@ -91,30 +92,30 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	vcpu->mmio_needed = 0;
 
-	if (!kvm_vcpu_dabt_iswrite(vcpu)) {
-		len = kvm_vcpu_dabt_get_as(vcpu);
+	if (!kvm_vcpu_dabt_iswrite(esr)) {
+		len = kvm_vcpu_dabt_get_as(esr);
 		data = kvm_mmio_read_buf(run->mmio.data, len);
 
-		if (kvm_vcpu_dabt_issext(vcpu) &&
+		if (kvm_vcpu_dabt_issext(esr) &&
 		    len < sizeof(unsigned long)) {
 			mask = 1U << ((len * 8) - 1);
 			data = (data ^ mask) - mask;
 		}
 
-		if (!kvm_vcpu_dabt_issf(vcpu))
+		if (!kvm_vcpu_dabt_issf(esr))
 			data = data & 0xffffffff;
 
 		trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
 			       &data);
 		data = vcpu_data_host_to_guest(vcpu, data, len);
-		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
+		vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(esr), data);
 	}
 
 	/*
 	 * The MMIO instruction is emulated and should not be re-executed
 	 * in the guest.
 	 */
-	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(esr));
 
 	return 0;
 }
@@ -122,6 +123,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		 phys_addr_t fault_ipa)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	unsigned long data;
 	unsigned long rt;
 	int ret;
@@ -133,10 +135,11 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	 * No valid syndrome? Ask userspace for help if it has
 	 * voluntered to do so, and bail out otherwise.
 	 */
-	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
+	if (!kvm_vcpu_dabt_isvalid(esr)) {
 		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
-			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
+			run->arm_nisv.esr_iss =
+				kvm_vcpu_dabt_iss_nisv_sanitized(esr);
 			run->arm_nisv.fault_ipa = fault_ipa;
 			return 0;
 		}
@@ -146,7 +149,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	}
 
 	/* Page table accesses IO mem: tell guest to fix its TTBR */
-	if (kvm_vcpu_dabt_iss1tw(vcpu)) {
+	if (kvm_vcpu_dabt_iss1tw(esr)) {
 		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
 		return 1;
 	}
@@ -156,9 +159,9 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	 * from the CPU. Then try if some in-kernel emulation feels
 	 * responsible, otherwise let user space do its magic.
 	 */
-	is_write = kvm_vcpu_dabt_iswrite(vcpu);
-	len = kvm_vcpu_dabt_get_as(vcpu);
-	rt = kvm_vcpu_dabt_get_rd(vcpu);
+	is_write = kvm_vcpu_dabt_iswrite(esr);
+	len = kvm_vcpu_dabt_get_as(esr);
+	rt = kvm_vcpu_dabt_get_rd(esr);
 
 	if (is_write) {
 		data = vcpu_data_guest_to_host(vcpu, vcpu_get_reg(vcpu, rt),
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 5da0d0e7519b..e462e0368fd9 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1661,6 +1661,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long fault_status)
 {
 	int ret;
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	bool write_fault, writable, force_pte = false;
 	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
@@ -1674,8 +1675,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long vma_pagesize, flags = 0;
 
-	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_iabt(vcpu);
+	write_fault = kvm_is_write_fault(esr);
+	exec_fault = kvm_vcpu_trap_is_iabt(esr);
 	VM_BUG_ON(write_fault && exec_fault);
 
 	if (fault_status == FSC_PERM && !write_fault && !exec_fault) {
@@ -1903,6 +1904,7 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
  */
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
+	u32 esr = kvm_vcpu_get_esr(vcpu);
 	unsigned long fault_status;
 	phys_addr_t fault_ipa;
 	struct kvm_memory_slot *memslot;
@@ -1911,13 +1913,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	gfn_t gfn;
 	int ret, idx;
 
-	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
+	fault_status = kvm_vcpu_trap_get_fault_type(esr);
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
-	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
+	is_iabt = kvm_vcpu_trap_is_iabt(esr);
 
 	/* Synchronous External Abort? */
-	if (kvm_vcpu_dabt_isextabt(vcpu)) {
+	if (kvm_vcpu_dabt_isextabt(esr)) {
 		/*
 		 * For RAS the host kernel may handle this abort.
 		 * There is no need to pass the error into the guest.
@@ -1938,8 +1940,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
 	    fault_status != FSC_ACCESS) {
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
-			kvm_vcpu_trap_get_class(vcpu),
-			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
+			kvm_vcpu_trap_get_class(esr),
+			(unsigned long)kvm_vcpu_trap_get_fault(esr),
 			(unsigned long)kvm_vcpu_get_esr(vcpu));
 		return -EFAULT;
 	}
@@ -1949,7 +1951,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	gfn = fault_ipa >> PAGE_SHIFT;
 	memslot = gfn_to_memslot(vcpu->kvm, gfn);
 	hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
-	write_fault = kvm_is_write_fault(vcpu);
+	write_fault = kvm_is_write_fault(esr);
 	if (kvm_is_error_hva(hva) || (write_fault && !writable)) {
 		if (is_iabt) {
 			/* Prefetch Abort on I/O address */
@@ -1967,8 +1969,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * So let's assume that the guest is just being
 		 * cautious, and skip the instruction.
 		 */
-		if (kvm_vcpu_dabt_is_cm(vcpu)) {
-			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+		if (kvm_vcpu_dabt_is_cm(esr)) {
+			kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(esr));
 			ret = 1;
 			goto out_unlock;
 		}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
