From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/31] KVM: arm64: vgic-v3: Add ICV_EOIR1_EL1 handler
Date: Wed,  3 May 2017 11:45:49 +0100
Message-ID: <20170503104606.19342-15-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE54B40BE3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JLLjUkkI1cwl for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:43:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 799DE40AF5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:32 -0400 (EDT)
In-Reply-To: <20170503104606.19342-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a handler for writing the guest's view of the ICC_EOIR1_EL1
register. This involves dropping the priority of the interrupt,
and deactivating it if required (EOImode == 0).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/irqchip/arm-gic-v3.h |   2 +
 virt/kvm/arm/hyp/vgic-v3-sr.c      | 119 +++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 7610ea4e8337..c56d9bc2c904 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -403,6 +403,8 @@
 
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
+#define ICH_HCR_EOIcount_SHIFT		27
+#define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
 
 #define ICH_VMCR_CBPR_SHIFT		4
 #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 49aad1de3ac8..a76351b3ad66 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -425,6 +425,26 @@ static int __hyp_text __vgic_v3_highest_priority_lr(struct kvm_vcpu *vcpu,
 	return lr;
 }
 
+static int __hyp_text __vgic_v3_find_active_lr(struct kvm_vcpu *vcpu,
+					       int intid, u64 *lr_val)
+{
+	unsigned int used_lrs = vcpu->arch.vgic_cpu.used_lrs;
+	int i;
+
+	for (i = 0; i < used_lrs; i++) {
+		u64 val = __gic_v3_get_lr(i);
+
+		if ((val & ICH_LR_VIRTUAL_ID_MASK) == intid &&
+		    (val & ICH_LR_ACTIVE_BIT)) {
+			*lr_val = val;
+			return i;
+		}
+	}
+
+	*lr_val = ICC_IAR1_EL1_SPURIOUS;
+	return -1;
+}
+
 static int __hyp_text __vgic_v3_get_highest_active_priority(void)
 {
 	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
@@ -490,6 +510,44 @@ static void __hyp_text __vgic_v3_set_active_priority(u8 pre)
 	__vgic_v3_write_ap1rn(val | bit, apr);
 }
 
+static int __hyp_text __vgic_v3_clear_highest_active_priority(void)
+{
+	u8 nr_pre_bits = vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
+	u8 nr_aprs = 1 << (nr_pre_bits - 5);
+	u32 hap = 0;
+	int i;
+
+	for (i = 0; i < nr_aprs; i++) {
+		u32 ap0, ap1;
+		int c0, c1;
+
+		ap0 = __vgic_v3_read_ap0rn(i);
+		ap1 = __vgic_v3_read_ap1rn(i);
+		if (!ap0 && !ap1) {
+			hap += 32;
+			continue;
+		}
+
+		c0 = ap0 ? __ffs(ap0) : 32;
+		c1 = ap1 ? __ffs(ap1) : 32;
+
+		/* Always clear the LSB, which is the highest priority */
+		if (c0 < c1) {
+			ap0 &= ap0 - 1;
+			__vgic_v3_write_ap0rn(ap0, i);
+			hap += c0;
+		} else {
+			ap1 &= ap1 - 1;
+			__vgic_v3_write_ap1rn(ap1, i);
+			hap += c1;
+		}
+
+		return hap << (8 - nr_pre_bits);
+	}
+
+	return GICv3_IDLE_PRIORITY;
+}
+
 static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 lr_val;
@@ -526,6 +584,64 @@ static void __hyp_text __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int r
 	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
 }
 
+static void __hyp_text __vgic_v3_clear_active_lr(int lr, u64 lr_val)
+{
+	lr_val &= ~ICH_LR_ACTIVE_BIT;
+	if (lr_val & ICH_LR_HW) {
+		u32 pid;
+		pid = (lr_val & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
+		gic_write_dir(pid);
+	}
+
+	__gic_v3_set_lr(lr_val, lr);
+}
+
+static void __hyp_text __vgic_v3_bump_eoicount(void)
+{
+	u32 hcr;
+
+	hcr = read_gicreg(ICH_HCR_EL2);
+	hcr += 1 << ICH_HCR_EOIcount_SHIFT;
+	write_gicreg(hcr, ICH_HCR_EL2);
+}
+
+static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	u32 vid = vcpu_get_reg(vcpu, rt);
+	u64 lr_val;
+	u8 lr_prio, act_prio;
+	int lr, grp;
+
+	grp = __vgic_v3_get_group(vcpu);
+
+	/* Drop priority in any case */
+	act_prio = __vgic_v3_clear_highest_active_priority();
+
+	/* If EOIing an LPI, no deactivate to be performed */
+	if (vid >= VGIC_MIN_LPI)
+		return;
+
+	/* EOImode == 1, nothing to be done here */
+	if (vmcr & ICH_VMCR_EOIM_MASK)
+		return;
+
+	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
+	if (lr == -1) {
+		__vgic_v3_bump_eoicount();
+		return;
+	}
+
+	lr_prio = (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
+
+	/* If priorities or group do not match, the guest has fscked-up. */
+	if (grp != !!(lr_val & ICH_LR_GROUP) ||
+	    __vgic_v3_pri_to_pre(lr_prio, vmcr, grp) != act_prio)
+		return;
+
+	/* Let's now perform the deactivation */
+	__vgic_v3_clear_active_lr(lr, lr_val);
+}
+
 static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
@@ -591,6 +707,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	case SYS_ICC_IAR1_EL1:
 		fn = __vgic_v3_read_iar;
 		break;
+	case SYS_ICC_EOIR1_EL1:
+		fn = __vgic_v3_write_eoir;
+		break;
 	case SYS_ICC_GRPEN1_EL1:
 		if (is_read)
 			fn = __vgic_v3_read_igrpen1;
-- 
2.11.0
