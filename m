From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/31] KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
Date: Wed,  3 May 2017 11:45:46 +0100
Message-ID: <20170503104606.19342-12-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE6D40BE3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bUZIppXe1kwy for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:43:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9DB440C2C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:27 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICC_BPR1_EL1
register, which is located in the ICH_VMCR_EL2.BPR1 field.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 61 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 435787a93c6c..f0f038c490a5 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -375,9 +375,57 @@ void __hyp_text __vgic_v3_write_vmcr(u32 vmcr)
 
 #ifdef CONFIG_ARM64
 
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
+	u8 bpr_min = 8 - vtr_to_nr_pre_bits(read_gicreg(ICH_VTR_EL2));
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
-	u32 esr = kvm_vcpu_get_hsr(vcpu);
+	int rt = kvm_vcpu_sys_get_rt(vcpu);
+	u32 vmcr, esr = kvm_vcpu_get_hsr(vcpu);
+	void (*fn)(struct kvm_vcpu *, u32, int);
+	bool is_read;
 	u32 sysreg;
 
 	if (vcpu_mode_is_32bit(vcpu)) {
@@ -389,11 +437,22 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		sysreg = esr_sys64_to_sysreg(esr);
 	}
 
+	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
+
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
 
+	vmcr = __vgic_v3_read_vmcr();
+	fn(vcpu, vmcr, rt);
+
 	return 1;
 }
 
-- 
2.11.0
