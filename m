From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 06/25] KVM: arm64: vgic-v3: Add ICV_IGRPEN1_EL1 handler
Date: Thu,  1 Jun 2017 11:20:58 +0100
Message-ID: <20170601102117.17750-7-marc.zyngier@arm.com>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3805C40CD2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:17:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OGBTrwTHpmKC for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 06:17:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 702C040C25
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 06:17:41 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICC_IGRPEN1_EL1
register, which is located in the ICH_VMCR_EL2.VENG1 field.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 6254eaf72a77..168539dfd0b9 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -395,6 +395,23 @@ static unsigned int __hyp_text __vgic_v3_get_bpr1(u32 vmcr)
 	return bpr;
 }
 
+static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+}
+
+static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	u64 val = vcpu_get_reg(vcpu, rt);
+
+	if (val & 1)
+		vmcr |= ICH_VMCR_ENG1_MASK;
+	else
+		vmcr &= ~ICH_VMCR_ENG1_MASK;
+
+	__vgic_v3_write_vmcr(vmcr);
+}
+
 static void __hyp_text __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
@@ -442,6 +459,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
 
 	switch (sysreg) {
+	case SYS_ICC_GRPEN1_EL1:
+		if (is_read)
+			fn = __vgic_v3_read_igrpen1;
+		else
+			fn = __vgic_v3_write_igrpen1;
+		break;
 	case SYS_ICC_BPR1_EL1:
 		if (is_read)
 			fn = __vgic_v3_read_bpr1;
-- 
2.11.0
