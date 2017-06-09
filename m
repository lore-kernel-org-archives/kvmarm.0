From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 21/27] KVM: arm64: vgic-v3: Add ICV_RPR_EL1 handler
Date: Fri,  9 Jun 2017 12:49:50 +0100
Message-ID: <20170609114956.25963-22-marc.zyngier@arm.com>
References: <20170609114956.25963-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08CC640C25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 07:46:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8k9De0lcAknq for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Jun 2017 07:46:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF9C840969
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Jun 2017 07:46:31 -0400 (EDT)
In-Reply-To: <20170609114956.25963-1-marc.zyngier@arm.com>
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

Add a handler for reading the guest's view of the ICV_RPR_EL1
register, returning the highest active priority.

Tested-by: Alexander Graf <agraf@suse.de>
Acked-by: David Daney <david.daney@cavium.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  1 +
 virt/kvm/arm/hyp/vgic-v3-sr.c   | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9971c5c435a7..c4d48e403629 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -187,6 +187,7 @@
 #define SYS_ICC_AP0Rn_EL1(n)		sys_reg(3, 0, 12, 8, 4 | n)
 #define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
 #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
+#define SYS_ICC_RPR_EL1			sys_reg(3, 0, 12, 11, 3)
 #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
 #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
 #define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 2f2af03e8932..406da9c667ff 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -884,6 +884,13 @@ static void __hyp_text __vgic_v3_read_hppir(struct kvm_vcpu *vcpu,
 	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
 }
 
+static void __hyp_text __vgic_v3_read_rpr(struct kvm_vcpu *vcpu,
+					  u32 vmcr, int rt)
+{
+	u32 val = __vgic_v3_get_highest_active_priority();
+	vcpu_set_reg(vcpu, rt, val);
+}
+
 int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
@@ -973,6 +980,9 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	case SYS_ICC_DIR_EL1:
 		fn = __vgic_v3_write_dir;
 		break;
+	case SYS_ICC_RPR_EL1:
+		fn = __vgic_v3_read_rpr;
+		break;
 	default:
 		return 0;
 	}
-- 
2.11.0
