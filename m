From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 22/25] KVM: arm64: vgic-v3: Add ICV_CTLR_EL1 handler
Date: Thu,  1 Jun 2017 11:21:14 +0100
Message-ID: <20170601102117.17750-23-marc.zyngier@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64D1A40C26
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:18:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KkNMzkdBdX27 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 06:18:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3209A40CE6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:18:10 -0400 (EDT)
In-Reply-To: <20170601102117.17750-1-marc.zyngier@arm.com>
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

Add a handler for reading/writing the guest's view of the ICV_CTLR_EL1
register. only EOIMode and CBPR are of interest here, as all the other
bits directly come from ICH_VTR_EL2 and are Read-Only.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 46 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index cac9d563d97d..3a5749e6c797 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -881,6 +881,46 @@ static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, rt, val);
 }
 
+static void __hyp_text __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu,
+					   u32 vmcr, int rt)
+{
+	u32 vtr, val;
+
+	vtr = read_gicreg(ICH_VTR_EL2);
+	/* PRIbits */
+	val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
+	/* IDbits */
+	val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
+	/* SEIS */
+	val |= ((vtr >> 22) & 1) << ICC_CTLR_EL1_SEIS_SHIFT;
+	/* A3V */
+	val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
+	/* EOImode */
+	val |= ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR_EL1_EOImode_SHIFT;
+	/* CBPR */
+	val |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+
+	vcpu_set_reg(vcpu, rt, val);
+}
+
+static void __hyp_text __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu,
+					    u32 vmcr, int rt)
+{
+	u32 val = vcpu_get_reg(vcpu, rt);
+
+	if (val & ICC_CTLR_EL1_CBPR_MASK)
+		vmcr |= ICH_VMCR_CBPR_MASK;
+	else
+		vmcr &= ~ICH_VMCR_CBPR_MASK;
+
+	if (val & ICC_CTLR_EL1_EOImode_MASK)
+		vmcr |= ICH_VMCR_EOIM_MASK;
+	else
+		vmcr &= ~ICH_VMCR_EOIM_MASK;
+
+	write_gicreg(vmcr, ICH_VMCR_EL2);
+}
+
 int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
@@ -973,6 +1013,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	case SYS_ICC_RPR_EL1:
 		fn = __vgic_v3_read_rpr;
 		break;
+	case SYS_ICC_CTLR_EL1:
+		if (is_read)
+			fn = __vgic_v3_read_ctlr;
+		else
+			fn = __vgic_v3_write_ctlr;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
