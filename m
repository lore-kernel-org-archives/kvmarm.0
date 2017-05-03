From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 29/31] KVM: arm64: vgic-v3: Add ICV_PMR_EL1 handler
Date: Wed,  3 May 2017 11:46:04 +0100
Message-ID: <20170503104606.19342-30-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2B440969
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NDnANe6UydGX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:43:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBCA640CEA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:55 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICC_PMR_EL1
register, which is located in the ICH_VMCR_EL2.VPMR field.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 981201bf7a5e..4fbeeb54704e 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -848,6 +848,27 @@ static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
 }
 
+static void __hyp_text __vgic_v3_read_pmr(struct kvm_vcpu *vcpu,
+					  u32 vmcr, int rt)
+{
+	vmcr &= ICH_VMCR_PMR_MASK;
+	vmcr >>= ICH_VMCR_PMR_SHIFT;
+	vcpu_set_reg(vcpu, rt, vmcr);
+}
+
+static void __hyp_text __vgic_v3_write_pmr(struct kvm_vcpu *vcpu,
+					   u32 vmcr, int rt)
+{
+	u32 val = vcpu_get_reg(vcpu, rt);
+
+	val <<= ICH_VMCR_PMR_SHIFT;
+	val &= ICH_VMCR_PMR_MASK;
+	vmcr &= ~ICH_VMCR_PMR_MASK;
+	vmcr |= val;
+
+	write_gicreg(vmcr, ICH_VMCR_EL2);
+}
+
 static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
 					  u32 vmcr, int rt)
 {
@@ -991,6 +1012,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		else
 			fn = __vgic_v3_write_ctlr;
 		break;
+	case SYS_ICC_PMR_EL1:
+		if (is_read)
+			fn = __vgic_v3_read_pmr;
+		else
+			fn = __vgic_v3_write_pmr;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
