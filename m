From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 49/58] KVM: arm64: vgic-v3: Add ICV_PMR_EL1 handler
Date: Fri, 30 Jun 2017 09:45:05 +0100
Message-ID: <20170630084514.6779-50-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC1F40D94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XBVg-Ty-TFJV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A23840FE9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:37 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICC_PMR_EL1
register, which is located in the ICH_VMCR_EL2.VPMR field.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index a8a58dedc38e..15b557697086 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -884,6 +884,27 @@ static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
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
@@ -1029,6 +1050,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
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
