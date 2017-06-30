From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 33/58] KVM: arm64: vgic-v3: Add ICV_IAR1_EL1 handler
Date: Fri, 30 Jun 2017 09:44:49 +0100
Message-ID: <20170630084514.6779-34-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A455A40D59
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BFlvr0FCs7uI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4770B40FF9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:57 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a handler for reading the guest's view of the ICC_IAR1_EL1
register. This involves finding the highest priority Group-1
interrupt, checking against both PMR and the active group
priority, activating the interrupt and setting the group
priority as active.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/linux/irqchip/arm-gic-v3.h |   1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c      | 163 +++++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 1fa293a37f4a..d70668fae003 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -405,6 +405,7 @@
 #define ICH_LR_PHYS_ID_SHIFT		32
 #define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
 #define ICH_LR_PRIORITY_SHIFT		48
+#define ICH_LR_PRIORITY_MASK		(0xffULL << ICH_LR_PRIORITY_SHIFT)
 
 /* These are for GICv2 emulation only */
 #define GICH_LR_VIRTUALID		(0x3ffUL << 0)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 25f09721241f..5a20f8d5bada 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -24,6 +24,7 @@
 
 #define vtr_to_max_lr_idx(v)		((v) & 0xf)
 #define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
+#define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
 
 static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
 {
@@ -381,6 +382,88 @@ static int __hyp_text __vgic_v3_bpr_min(void)
 	return 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
 }
 
+static int __hyp_text __vgic_v3_get_group(struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_hsr(vcpu);
+	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
+
+	return crm != 8;
+}
+
+#define GICv3_IDLE_PRIORITY	0xff
+
+static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
+						    u32 vmcr,
+						    u64 *lr_val)
+{
+	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	u8 priority = GICv3_IDLE_PRIORITY;
+	int i, lr = -1;
+
+	for (i = 0; i < used_lrs; i++) {
+		u64 val = __gic_v3_get_lr(i);
+		u8 lr_prio = (val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
+
+		/* Not pending in the state? */
+		if ((val & ICH_LR_STATE) != ICH_LR_PENDING_BIT)
+			continue;
+
+		/* Group-0 interrupt, but Group-0 disabled? */
+		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
+			continue;
+
+		/* Group-1 interrupt, but Group-1 disabled? */
+		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
+			continue;
+
+		/* Not the highest priority? */
+		if (lr_prio >= priority)
+			continue;
+
+		/* This is a candidate */
+		priority = lr_prio;
+		*lr_val = val;
+		lr = i;
+	}
+
+	if (lr == -1)
+		*lr_val = ICC_IAR1_EL1_SPURIOUS;
+
+	return lr;
+}
+
+static int __hyp_text __vgic_v3_get_highest_active_priority(void)
+{
+	u8 nr_apr_regs = vtr_to_nr_apr_regs(read_gicreg(ICH_VTR_EL2));
+	u32 hap = 0;
+	int i;
+
+	for (i = 0; i < nr_apr_regs; i++) {
+		u32 val;
+
+		/*
+		 * The ICH_AP0Rn_EL2 and ICH_AP1Rn_EL2 registers
+		 * contain the active priority levels for this VCPU
+		 * for the maximum number of supported priority
+		 * levels, and we return the full priority level only
+		 * if the BPR is programmed to its minimum, otherwise
+		 * we return a combination of the priority level and
+		 * subpriority, as determined by the setting of the
+		 * BPR, but without the full subpriority.
+		 */
+		val  = __vgic_v3_read_ap0rn(i);
+		val |= __vgic_v3_read_ap1rn(i);
+		if (!val) {
+			hap += 32;
+			continue;
+		}
+
+		return (hap + __ffs(val)) << __vgic_v3_bpr_min();
+	}
+
+	return GICv3_IDLE_PRIORITY;
+}
+
 static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
 {
 	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
@@ -401,6 +484,83 @@ static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
 	return bpr;
 }
 
+/*
+ * Convert a priority to a preemption level, taking the relevant BPR
+ * into account by zeroing the sub-priority bits.
+ */
+static u8 __hyp_text __vgic_v3_pri_to_pre(u8 pri, u32 vmcr, int grp)
+{
+	unsigned int bpr;
+
+	if (!grp)
+		bpr = __vgic_v3_get_bpr0(vmcr) + 1;
+	else
+		bpr = __vgic_v3_get_bpr1(vmcr);
+
+	return pri & (GENMASK(7, 0) << bpr);
+}
+
+/*
+ * The priority value is independent of any of the BPR values, so we
+ * normalize it using the minumal BPR value. This guarantees that no
+ * matter what the guest does with its BPR, we can always set/get the
+ * same value of a priority.
+ */
+static void __hyp_text __vgic_v3_set_active_priority(u8 pri, u32 vmcr, int grp)
+{
+	u8 pre, ap;
+	u32 val;
+	int apr;
+
+	pre = __vgic_v3_pri_to_pre(pri, vmcr, grp);
+	ap = pre >> __vgic_v3_bpr_min();
+	apr = ap / 32;
+
+	if (!grp) {
+		val = __vgic_v3_read_ap0rn(apr);
+		__vgic_v3_write_ap0rn(val | BIT(ap % 32), apr);
+	} else {
+		val = __vgic_v3_read_ap1rn(apr);
+		__vgic_v3_write_ap1rn(val | BIT(ap % 32), apr);
+	}
+}
+
+static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	u64 lr_val;
+	u8 lr_prio, pmr;
+	int lr, grp;
+
+	grp = __vgic_v3_get_group(vcpu);
+
+	lr = __vgic_v3_highest_priority_lr(vcpu, vmcr, &lr_val);
+	if (lr < 0)
+		goto spurious;
+
+	if (grp != !!(lr_val & ICH_LR_GROUP))
+		goto spurious;
+
+	pmr = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
+	if (pmr <= lr_prio)
+		goto spurious;
+
+	if (__vgic_v3_get_highest_active_priority() <= __vgic_v3_pri_to_pre(lr_prio, vmcr, grp))
+		goto spurious;
+
+	lr_val &= ~ICH_LR_STATE;
+	/* No active state for LPIs */
+	if ((lr_val & ICH_LR_VIRTUAL_ID_MASK) <= VGIC_MAX_SPI)
+		lr_val |= ICH_LR_ACTIVE_BIT;
+	__gic_v3_set_lr(lr_val, lr);
+	__vgic_v3_set_active_priority(lr_prio, vmcr, grp);
+	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
+	return;
+
+spurious:
+	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
+}
+
 static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
@@ -465,6 +625,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
 
 	switch (sysreg) {
+	case SYS_ICC_IAR1_EL1:
+		fn = __vgic_v3_read_iar;
+		break;
 	case SYS_ICC_GRPEN1_EL1:
 		if (is_read)
 			fn = __vgic_v3_read_igrpen1;
-- 
2.11.0
