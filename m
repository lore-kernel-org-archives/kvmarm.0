From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 20/25] KVM: arm64: vgic-v3: Add ICV_DIR_EL1 handler
Date: Thu,  1 Jun 2017 11:21:12 +0100
Message-ID: <20170601102117.17750-21-marc.zyngier@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E57A40BBC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:18:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kDUsXgFL6duC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 06:18:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 938D540D1A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:18:06 -0400 (EDT)
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

Add a handler for writing the guest's view of the ICC_DIR_EL1
register, performing the deactivation of an interrupt if EOImode
is set ot 1.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 5ff788d308ee..b86a0776c407 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -634,6 +634,30 @@ static void __hyp_text __vgic_v3_bump_eoicount(void)
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
@@ -936,6 +960,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
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
