From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 16/31] KVM: arm64: vgic-v3: Add ICV_HPPIR1_EL1 handler
Date: Wed,  3 May 2017 11:45:51 +0100
Message-ID: <20170503104606.19342-17-marc.zyngier@arm.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0896540A80
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M15kypJL8aTc for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 06:43:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1C340C9F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 06:43:35 -0400 (EDT)
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

Add a handler for reading the guest's view of the ICV_HPPIR1_EL1
register. This is a simple parsing of the available LRs, extracting the
highest available interrupt.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c   | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index aad46b8eea5e..bd000686194a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -185,6 +185,7 @@
 #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
 #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
 #define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
+#define SYS_ICC_HPPIR1_EL1		sys_reg(3, 0, 12, 12, 2)
 #define SYS_ICC_BPR1_EL1		sys_reg(3, 0, 12, 12, 3)
 #define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
 #define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index b6803989da1f..a521e105ade1 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -754,6 +754,26 @@ static void __hyp_text __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu,
 	__vgic_v3_write_apxrn(vcpu, rt, 3);
 }
 
+static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
+					    u32 vmcr, int rt)
+{
+	u64 lr_val;
+	int lr, lr_grp, grp;
+
+	grp = __vgic_v3_get_group(vcpu);
+
+	lr = __vgic_v3_highest_priority_lr(vcpu, vmcr, &lr_val);
+	if (lr == -1)
+		goto spurious;
+
+	lr_grp = !!(lr_val & ICH_LR_GROUP);
+	if (lr_grp != grp)
+		lr_val = ICC_IAR1_EL1_SPURIOUS;
+
+spurious:
+	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
+}
+
 int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt = kvm_vcpu_sys_get_rt(vcpu);
@@ -816,6 +836,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		else
 			fn = __vgic_v3_write_apxr3;
 		break;
+	case SYS_ICC_HPPIR1_EL1:
+		fn = __vgic_v3_read_hppir;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
