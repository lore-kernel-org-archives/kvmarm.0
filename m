From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 54/58] arm64/kvm: sysreg: fix typo'd SYS_ICC_IGRPEN*_EL1
Date: Fri, 30 Jun 2017 09:45:10 +0100
Message-ID: <20170630084514.6779-55-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1D2040D68
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ePMF0tGIyTJp for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3007540D44
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:50 -0400 (EDT)
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

From: Mark Rutland <mark.rutland@arm.com>

Per ARM DDI 0487B.a, the registers are named ICC_IGRPEN*_EL1 rather than
ICC_GRPEN*_EL1. Correct our mnemonics and comments to match, before we
add more GICv3 register definitions.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Acked-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/arch_gicv3.h | 2 +-
 arch/arm64/include/asm/sysreg.h     | 4 ++--
 arch/arm64/kvm/vgic-sys-reg-v3.c    | 2 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c       | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 1a98bc8602a2..8cef47fa2218 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -89,7 +89,7 @@ static inline void gic_write_ctlr(u32 val)
 
 static inline void gic_write_grpen1(u32 val)
 {
-	write_sysreg_s(val, SYS_ICC_GRPEN1_EL1);
+	write_sysreg_s(val, SYS_ICC_IGRPEN1_EL1);
 	isb();
 }
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 56a3247e928c..00d493ba8dbd 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -195,8 +195,8 @@
 #define SYS_ICC_BPR1_EL1		sys_reg(3, 0, 12, 12, 3)
 #define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
 #define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
-#define SYS_ICC_GRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
-#define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
+#define SYS_ICC_IGRPEN0_EL1		sys_reg(3, 0, 12, 12, 6)
+#define SYS_ICC_IGRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
 #define SYS_CONTEXTIDR_EL1		sys_reg(3, 0, 13, 0, 1)
 #define SYS_TPIDR_EL1			sys_reg(3, 0, 13, 0, 4)
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 6260b69e5622..5fb3cc9e8f52 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -296,7 +296,7 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
 	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(5), access_gic_sre },
 	/* ICC_IGRPEN0_EL1 */
 	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
-	/* ICC_GRPEN1_EL1 */
+	/* ICC_IGRPEN1_EL1 */
 	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
 };
 
diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 79e3c2d3b754..91728faa13fd 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -986,7 +986,7 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 			return 0;
 		fn = __vgic_v3_write_eoir;
 		break;
-	case SYS_ICC_GRPEN1_EL1:
+	case SYS_ICC_IGRPEN1_EL1:
 		if (is_read)
 			fn = __vgic_v3_read_igrpen1;
 		else
@@ -1032,7 +1032,7 @@ int __hyp_text __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 			return 0;
 		fn = __vgic_v3_read_hppir;
 		break;
-	case SYS_ICC_GRPEN0_EL1:
+	case SYS_ICC_IGRPEN0_EL1:
 		if (is_read)
 			fn = __vgic_v3_read_igrpen0;
 		else
-- 
2.11.0
