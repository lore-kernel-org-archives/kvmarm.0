From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 46/58] KVM: arm64: vgic-v3: Add ICV_DIR_EL1 handler
Date: Fri, 30 Jun 2017 09:45:02 +0100
Message-ID: <20170630084514.6779-47-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BBBD40DCE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dg1cEBID6LHl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:30 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE9C6411E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:29 -0400 (EDT)
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

Add a handler for writing the guest's view of the ICC_DIR_EL1
register, performing the deactivation of an interrupt if EOImode
is set ot 1.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
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
