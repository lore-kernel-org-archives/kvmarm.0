From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 20/27] KVM: arm64: vgic-v3: Add ICV_DIR_EL1 handler
Date: Fri,  9 Jun 2017 12:49:49 +0100
Message-ID: <20170609114956.25963-21-marc.zyngier@arm.com>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170609114956.25963-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add a handler for writing the guest's view of the ICC_DIR_EL1
register, performing the deactivation of an interrupt if EOImode
is set ot 1.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 08a5d76c82c7..2f2af03e8932 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -652,6 +652,30 @@ static void __hyp_text __vgic_v3_bump_eoicount(void)
 	write_gicreg(hcr, ICH_HCR_EL2);
 }
 
+static void __hyp_text __vgic_v3_write_dir(struct kvm_vcpu *vcpu,
+					   u32 vmcr, int rt)
+{
+	u32 vid = vcpu_get_reg(vcpu, rt);
+	u64 lr_val;
+	int lr;
+
+	/* EOImode == 0, nothing to be done here */
+	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+		return;
+
+	/* No deactivate to be performed on an LPI */
+	if (vid >= VGIC_MIN_LPI)
+		return;
+
+	lr = __vgic_v3_find_active_lr(vcpu, vid, &lr_val);
+	if (lr == -1) {
+		__vgic_v3_bump_eoicount();
+		return;
+	}
+
+	__vgic_v3_clear_active_lr(lr, lr_val);
+}
+
 static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 vid = vcpu_get_reg(vcpu, rt);
@@ -946,6 +970,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		else
 			fn = __vgic_v3_write_bpr0;
 		break;
+	case SYS_ICC_DIR_EL1:
+		fn = __vgic_v3_write_dir;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
