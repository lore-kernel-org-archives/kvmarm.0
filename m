From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 20/31] KVM: arm64: vgic-v3: Add ICV_IGNREN0_EL1 handler
Date: Wed,  3 May 2017 11:45:55 +0100
Message-ID: <20170503104606.19342-21-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E25C740C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZybQhj-AN1az for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:43:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F285840969
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:41 -0400 (EDT)
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

Add a handler for reading/writing the guest's view of the ICC_IGRPEN0_EL1
register, which is located in the ICH_VMCR_EL2.VENG0 field.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c   | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d20be0b28ca4..ba93bc7ac8e4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -190,6 +190,7 @@
 #define SYS_ICC_BPR1_EL1		sys_reg(3, 0, 12, 12, 3)
 #define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
 #define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
+#define SYS_ICC_GRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
 #define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
 #define SYS_CONTEXTIDR_EL1		sys_reg(3, 0, 13, 0, 1)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index b21bb0c77ec2..77d5d12389ec 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -649,11 +649,28 @@ static void __hyp_text __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int
 	__vgic_v3_clear_active_lr(lr, lr_val);
 }
 
+static void __hyp_text __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+}
+
 static void __hyp_text __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
 }
 
+static void __hyp_text __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
+{
+	u64 val = vcpu_get_reg(vcpu, rt);
+
+	if (val & 1)
+		vmcr |= ICH_VMCR_ENG0_MASK;
+	else
+		vmcr &= ~ICH_VMCR_ENG0_MASK;
+
+	__vgic_v3_write_vmcr(vmcr);
+}
+
 static void __hyp_text __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u64 val = vcpu_get_reg(vcpu, rt);
@@ -876,6 +893,12 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	case SYS_ICC_HPPIR1_EL1:
 		fn = __vgic_v3_read_hppir;
 		break;
+	case SYS_ICC_GRPEN0_EL1:
+		if (is_read)
+			fn = __vgic_v3_read_igrpen0;
+		else
+			fn = __vgic_v3_write_igrpen0;
+		break;
 	case SYS_ICC_BPR0_EL1:
 		if (is_read)
 			fn = __vgic_v3_read_bpr0;
-- 
2.11.0
