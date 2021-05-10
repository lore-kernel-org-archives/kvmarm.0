Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE809C43470
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:28:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C53861613
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 17:28:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C53861613
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E04874B54E;
	Mon, 10 May 2021 13:28:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oQvv0TOPL6-M; Mon, 10 May 2021 13:28:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA564B5E4;
	Mon, 10 May 2021 13:28:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E35BD4B54E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:28:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4hzgwEudv8TZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 13:28:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A7534B5E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 13:28:12 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8443E6157E;
 Mon, 10 May 2021 17:28:11 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lg9Go-000Uqg-7F; Mon, 10 May 2021 18:00:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v4 59/66] KVM: arm64: nv: Move nested vgic state into the
 sysreg file
Date: Mon, 10 May 2021 17:59:13 +0100
Message-Id: <20210510165920.1913477-60-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>
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

The vgic nested state needs to be accessible from the VNCR page, and
thus needs to be part of the normal sysreg file. Let's move it there.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h    |  9 +++
 arch/arm64/kvm/sys_regs.c            | 53 +++++++++++------
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 88 ++++++++++++++--------------
 arch/arm64/kvm/vgic/vgic-v3.c        | 17 ++++--
 arch/arm64/kvm/vgic/vgic.h           | 10 ++++
 include/kvm/arm_vgic.h               |  7 ---
 6 files changed, 110 insertions(+), 74 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 815ae39f7857..3d4543b0c116 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -297,6 +297,15 @@ enum vcpu_sysreg {
 	VNCR(CNTP_CVAL_EL0),
 	VNCR(CNTP_CTL_EL0),
 
+	VNCR(ICH_LR0_EL2),
+	ICH_LR15_EL2 = ICH_LR0_EL2 + 15,
+	VNCR(ICH_AP0R0_EL2),
+	ICH_AP0R3_EL2 = ICH_AP0R0_EL2 + 3,
+	VNCR(ICH_AP1R0_EL2),
+	ICH_AP1R3_EL2 = ICH_AP1R0_EL2 + 3,
+	VNCR(ICH_HCR_EL2),
+	VNCR(ICH_VMCR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4db1a9333afa..084230f6b993 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1796,17 +1796,17 @@ static bool access_gic_apr(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
-	u32 index, *base;
+	u64 *base;
+	u8 index;
 
 	index = r->Op2;
 	if (r->CRm == 8)
-		base = cpu_if->vgic_ap0r;
+		base = __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_AP0R0_EL2);
 	else
-		base = cpu_if->vgic_ap1r;
+		base = __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_AP1R0_EL2);
 
 	if (p->is_write)
-		base[index] = p->regval;
+		base[index] = lower_32_bits(p->regval);
 	else
 		p->regval = base[index];
 
@@ -1817,12 +1817,10 @@ static bool access_gic_hcr(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
-
 	if (p->is_write)
-		cpu_if->vgic_hcr = p->regval;
+		__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = lower_32_bits(p->regval);
 	else
-		p->regval = cpu_if->vgic_hcr;
+		p->regval = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
 
 	return true;
 }
@@ -1879,12 +1877,19 @@ static bool access_gic_vmcr(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
-
 	if (p->is_write)
-		cpu_if->vgic_vmcr = p->regval;
+		__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = (p->regval	&
+						      (ICH_VMCR_ENG0_MASK	|
+						       ICH_VMCR_ENG1_MASK	|
+						       ICH_VMCR_PMR_MASK	|
+						       ICH_VMCR_BPR0_MASK	|
+						       ICH_VMCR_BPR1_MASK	|
+						       ICH_VMCR_EOIM_MASK	|
+						       ICH_VMCR_CBPR_MASK	|
+						       ICH_VMCR_FIQ_EN_MASK	|
+						       ICH_VMCR_ACK_CTL_MASK));
 	else
-		p->regval = cpu_if->vgic_vmcr;
+		p->regval = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
 
 	return true;
 }
@@ -1893,17 +1898,29 @@ static bool access_gic_lr(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
 	u32 index;
+	u64 *base;
 
+	base = __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_LR0_EL2);
 	index = p->Op2;
 	if (p->CRm == 13)
 		index += 8;
 
-	if (p->is_write)
-		cpu_if->vgic_lr[index] = p->regval;
-	else
-		p->regval = cpu_if->vgic_lr[index];
+	if (p->is_write) {
+		u64 mask = (ICH_LR_VIRTUAL_ID_MASK	|
+			    ICH_LR_GROUP		|
+			    ICH_LR_HW			|
+			    ICH_LR_STATE);
+
+		if (p->regval & ICH_LR_HW)
+			mask |= ICH_LR_PHYS_ID_MASK;
+		else
+			mask |= ICH_LR_EOI;
+
+		base[index] = p->regval & mask;
+	} else {
+		p->regval = base[index];
+	}
 
 	return true;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 94b1edb67011..51f7a521e829 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -16,11 +16,6 @@
 #define CREATE_TRACE_POINTS
 #include "vgic-nested-trace.h"
 
-static inline struct vgic_v3_cpu_if *vcpu_nested_if(struct kvm_vcpu *vcpu)
-{
-	return &vcpu->arch.vgic_cpu.nested_vgic_v3;
-}
-
 static inline struct vgic_v3_cpu_if *vcpu_shadow_if(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.vgic_cpu.shadow_vgic_v3;
@@ -33,12 +28,11 @@ static inline bool lr_triggers_eoi(u64 lr)
 
 u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	u16 reg = 0;
 	int i;
 
 	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
-		if (lr_triggers_eoi(cpu_if->vgic_lr[i]))
+		if (lr_triggers_eoi(__vcpu_sys_reg(vcpu, ICH_LRN(i))))
 			reg |= BIT(i);
 	}
 
@@ -47,12 +41,11 @@ u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu)
 
 u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	u16 reg = 0;
 	int i;
 
 	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
-		if (!(cpu_if->vgic_lr[i] & ICH_LR_STATE))
+		if (!(__vcpu_sys_reg(vcpu, ICH_LRN(i)) & ICH_LR_STATE))
 			reg |= BIT(i);
 	}
 
@@ -61,14 +54,13 @@ u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu)
 
 u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	int nr_lr = kvm_vgic_global_state.nr_lr;
 	u64 reg = 0;
 
 	if (vgic_v3_get_eisr(vcpu))
 		reg |= ICH_MISR_EOI;
 
-	if (cpu_if->vgic_hcr & ICH_HCR_UIE) {
+	if (__vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_UIE) {
 		int used_lrs;
 
 		used_lrs = nr_lr - hweight16(vgic_v3_get_elrsr(vcpu));
@@ -87,13 +79,12 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
  */
 static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
 	struct vgic_irq *irq;
 	int i, used_lrs = 0;
 
 	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
-		u64 lr = cpu_if->vgic_lr[i];
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 		int l1_irq;
 
 		if (!(lr & ICH_LR_HW))
@@ -123,36 +114,20 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu)
 	}
 
 	trace_vgic_create_shadow_lrs(vcpu, kvm_vgic_global_state.nr_lr,
-				     s_cpu_if->vgic_lr, cpu_if->vgic_lr);
+				     s_cpu_if->vgic_lr,
+				     __ctxt_sys_reg(&vcpu->arch.ctxt, ICH_LR0_EL2));
 
 	s_cpu_if->used_lrs = used_lrs;
 }
 
-/*
- * Change the shadow HWIRQ field back to the virtual value before copying over
- * the entire shadow struct to the nested state.
- */
-static void vgic_v3_fixup_shadow_lr_state(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
-	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
-	int lr;
-
-	for (lr = 0; lr < kvm_vgic_global_state.nr_lr; lr++) {
-		s_cpu_if->vgic_lr[lr] &= ~ICH_LR_PHYS_ID_MASK;
-		s_cpu_if->vgic_lr[lr] |= cpu_if->vgic_lr[lr] & ICH_LR_PHYS_ID_MASK;
-	}
-}
-
 void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
 	struct vgic_irq *irq;
 	int i;
 
 	for (i = 0; i < s_cpu_if->used_lrs; i++) {
-		u64 lr = cpu_if->vgic_lr[i];
+		u64 lr = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 		int l1_irq;
 
 		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
@@ -178,14 +153,27 @@ void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
 	}
 }
 
+void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+	int i;
+
+	cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
+
+	for (i = 0; i < 4; i++) {
+		cpu_if->vgic_ap0r[i] = __vcpu_sys_reg(vcpu, ICH_AP0RN(i));
+		cpu_if->vgic_ap1r[i] = __vcpu_sys_reg(vcpu, ICH_AP1RN(i));
+	}
+
+	vgic_v3_create_shadow_lr(vcpu);
+}
+
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
 	unsigned long flags;
 
-	vgic_cpu->shadow_vgic_v3 = vgic_cpu->nested_vgic_v3;
-	vgic_v3_create_shadow_lr(vcpu);
 	__vgic_v3_restore_state(vcpu_shadow_if(vcpu));
 
 	irq = vgic_get_irq(vcpu->kvm, vcpu, vcpu->kvm->arch.vgic.maint_irq);
@@ -199,26 +187,40 @@ void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 {
-	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	int i;
 
-	__vgic_v3_save_state(vcpu_shadow_if(vcpu));
+	__vgic_v3_save_state(s_cpu_if);
 
-	trace_vgic_put_nested(vcpu, kvm_vgic_global_state.nr_lr,
-			      vcpu_shadow_if(vcpu)->vgic_lr);
+	trace_vgic_put_nested(vcpu, kvm_vgic_global_state.nr_lr, s_cpu_if->vgic_lr);
 
 	/*
 	 * Translate the shadow state HW fields back to the virtual ones
 	 * before copying the shadow struct back to the nested one.
 	 */
-	vgic_v3_fixup_shadow_lr_state(vcpu);
-	vgic_cpu->nested_vgic_v3 = vgic_cpu->shadow_vgic_v3;
+	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = s_cpu_if->vgic_hcr;
+	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
+
+	for (i = 0; i < 4; i++) {
+		__vcpu_sys_reg(vcpu, ICH_AP0RN(i)) = s_cpu_if->vgic_ap0r[i];
+		__vcpu_sys_reg(vcpu, ICH_AP1RN(i)) = s_cpu_if->vgic_ap1r[i];
+	}
+
+	for (i = 0; i < kvm_vgic_global_state.nr_lr; i++) {
+		u64 val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+
+		val &= ~ICH_LR_STATE;
+		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
+
+		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
+	}
+
 	irq_set_irqchip_state(kvm_vgic_global_state.maint_irq,
 			      IRQCHIP_STATE_ACTIVE, false);
 }
 
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 {
-	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
 	bool state;
 
 	/*
@@ -230,7 +232,7 @@ void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu)
 	if (!vgic_state_is_nested(vcpu))
 		return;
 
-	state  = cpu_if->vgic_hcr & ICH_HCR_EN;
+	state  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EN;
 	state &= vgic_v3_get_misr(vcpu);
 
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 1c8601bb810a..12c5c6ac92e2 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -294,10 +294,11 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 				     ICC_SRE_EL1_SRE);
 		/*
 		 * If nesting is allowed, force GICv3 onto the nested
-		 * guests as well.
+		 * guests as well by setting the shadow state to the
+		 * same value.
 		 */
 		if (nested_virt_in_use(vcpu))
-			vcpu->arch.vgic_cpu.nested_vgic_v3.vgic_sre = vgic_v3->vgic_sre;
+			vcpu->arch.vgic_cpu.shadow_vgic_v3.vgic_sre = vgic_v3->vgic_sre;
 		vcpu->arch.vgic_cpu.pendbaser = INITIAL_PENDBASER_VALUE;
 	} else {
 		vgic_v3->vgic_sre = 0;
@@ -713,11 +714,15 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
 	/*
-	 * vgic_v3_load_nested only affects the LRs in the shadow
-	 * state, so it is fine to pass the nested state around.
+	 * If the vgic is in nested state, populate the shadow state
+	 * from the guest's nested state. As vgic_v3_load_nested()
+	 * will only load LRs, let's deal with the rest of the state
+	 * here as if it was a non-nested state. Cunning.
 	 */
-	if (vgic_state_is_nested(vcpu))
-		cpu_if = &vcpu->arch.vgic_cpu.nested_vgic_v3;
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_create_shadow_state(vcpu);
+		cpu_if = &vcpu->arch.vgic_cpu.shadow_vgic_v3;
+	}
 
 	/*
 	 * If dealing with a GICv2 emulation on GICv3, VMCR_EL2.VFIQen
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index dc1f3d1657ee..a1de98efe67f 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -320,4 +320,14 @@ void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
 void vgic_v4_get_vlpi_state(struct vgic_irq *irq, bool *val);
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu);
+void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
+void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
+
+#define ICH_LRN(n)	(ICH_LR0_EL2 + (n))
+#define ICH_AP0RN(n)	(ICH_AP0R0_EL2 + (n))
+#define ICH_AP1RN(n)	(ICH_AP1R0_EL2 + (n))
+
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5ef477cc6862..1a9f61ed4c22 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -309,9 +309,6 @@ struct vgic_cpu {
 
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
-	/* CPU vif control registers for the virtual GICH interface */
-	struct vgic_v3_cpu_if	nested_vgic_v3;
-
 	/*
 	 * The shadow vif control register loaded to the hardware when
 	 * running a nested L2 guest with the virtual IMO/FMO bit set.
@@ -375,10 +372,6 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
-void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
-void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 u16 vgic_v3_get_eisr(struct kvm_vcpu *vcpu);
 u16 vgic_v3_get_elrsr(struct kvm_vcpu *vcpu);
 u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu);
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
