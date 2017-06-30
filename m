From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 31/58] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Fri, 30 Jun 2017 09:44:47 +0100
Message-ID: <20170630084514.6779-32-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B774440D55
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8FdwQl6MLGig for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4816340DDC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:52 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICC_BPR1_EL1
register, which is located in the ICH_VMCR_EL2.BPR1 field.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index e6c05b95a1b1..fe021abc8b51 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -375,6 +375,57 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
 
 #ifdef CONFIG_ARM64
 
+static int __hyp_text __vgic_v3_bpr_min(void)
+{
+	/* See Pseudocode for VPriorityGroup */
+	return 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
+}
+
+static unsigned int __hyp_text __vgic_v3_get_bpr0(u32 vmcr)
+{
+	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+}
+
+static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
+{
+	unsigned int bpr;
+
+	if (vmcr & ICH_VMCR_CBPR_MASK) {
+		bpr = __vgic_v3_get_bpr0(vmcr);
+		if (bpr < 7)
+			bpr++;
+	} else {
+		bpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+	}
+
+	return bpr;
+}
+
+static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
+}
+
+static void __hyp_text __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	u64 val = vcpu_get_reg(vcpu, rt);
+	u8 bpr_min = __vgic_v3_bpr_min();
+
+	if (vmcr & ICH_VMCR_CBPR_MASK)
+		return;
+
+	/* Enforce BPR limiting */
+	if (val < bpr_min)
+		val = bpr_min;
+
+	val <<= ICH_VMCR_BPR1_SHIFT;
+	val &= ICH_VMCR_BPR1_MASK;
+	vmcr &= ~ICH_VMCR_BPR1_MASK;
+	vmcr |= val;
+
+	__vgic_v3_write_vmcr(vmcr);
+}
+
 int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
@@ -397,6 +448,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
 
 	switch (sysreg) {
+	case SYS_ICC_BPR1_EL1:
+		if (is_read)
+			fn = __vgic_v3_read_bpr1;
+		else
+			fn = __vgic_v3_write_bpr1;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
