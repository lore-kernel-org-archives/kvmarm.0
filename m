From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 48/58] KVM: arm64: vgic-v3: Add ICV_CTLR_EL1 handler
Date: Fri, 30 Jun 2017 09:45:04 +0100
Message-ID: <20170630084514.6779-49-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D8ECF411E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B2uwlpbfdura for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:34 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7F64121F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:34 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICV_CTLR_EL1
register. only EOIMode and CBPR are of interest here, as all the other
bits directly come from ICH_VTR_EL2 and are Read-Only.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 46 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 406da9c667ff..a8a58dedc38e 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -891,6 +891,46 @@ static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
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
@@ -983,6 +1023,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
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
