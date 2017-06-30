From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 55/58] arm64/kvm: vgic: use SYS_DESC()
Date: Fri, 30 Jun 2017 09:45:11 +0100
Message-ID: <20170630084514.6779-56-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2EAF40DB8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ckwI5nNq9L7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:47:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3A0C40E2D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:47:52 -0400 (EDT)
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

Almost all of the arm64 KVM code uses the sysreg mnemonics for AArch64
register descriptions. Move the last straggler over.

To match what we do for SYS_ICH_AP*R*_EL2, the SYS_ICC_AP*R*_EL1
mnemonics are expanded in <asm/sysreg.h>.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Acked-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/include/asm/sysreg.h  |  8 +++++++
 arch/arm64/kvm/vgic-sys-reg-v3.c | 45 ++++++++++++++--------------------------
 2 files changed, 23 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 00d493ba8dbd..040b607cb682 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -185,7 +185,15 @@
 #define SYS_ICC_HPPIR0_EL1		sys_reg(3, 0, 12, 8, 2)
 #define SYS_ICC_BPR0_EL1		sys_reg(3, 0, 12, 8, 3)
 #define SYS_ICC_AP0Rn_EL1(n)		sys_reg(3, 0, 12, 8, 4 | n)
+#define SYS_ICC_AP0R0_EL1		SYS_ICC_AP0Rn_EL1(0)
+#define SYS_ICC_AP0R1_EL1		SYS_ICC_AP0Rn_EL1(1)
+#define SYS_ICC_AP0R2_EL1		SYS_ICC_AP0Rn_EL1(2)
+#define SYS_ICC_AP0R3_EL1		SYS_ICC_AP0Rn_EL1(3)
 #define SYS_ICC_AP1Rn_EL1(n)		sys_reg(3, 0, 12, 9, n)
+#define SYS_ICC_AP1R0_EL1		SYS_ICC_AP1Rn_EL1(0)
+#define SYS_ICC_AP1R1_EL1		SYS_ICC_AP1Rn_EL1(1)
+#define SYS_ICC_AP1R2_EL1		SYS_ICC_AP1Rn_EL1(2)
+#define SYS_ICC_AP1R3_EL1		SYS_ICC_AP1Rn_EL1(3)
 #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
 #define SYS_ICC_RPR_EL1			sys_reg(3, 0, 12, 11, 3)
 #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 5fb3cc9e8f52..116786d2e8e8 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -268,36 +268,21 @@ static bool access_gic_sre(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
-	/* ICC_PMR_EL1 */
-	{ Op0(3), Op1(0), CRn(4), CRm(6), Op2(0), access_gic_pmr },
-	/* ICC_BPR0_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(3), access_gic_bpr0 },
-	/* ICC_AP0R0_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(4), access_gic_ap0r },
-	/* ICC_AP0R1_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(5), access_gic_ap0r },
-	/* ICC_AP0R2_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(6), access_gic_ap0r },
-	/* ICC_AP0R3_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(8), Op2(7), access_gic_ap0r },
-	/* ICC_AP1R0_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(0), access_gic_ap1r },
-	/* ICC_AP1R1_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(1), access_gic_ap1r },
-	/* ICC_AP1R2_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(2), access_gic_ap1r },
-	/* ICC_AP1R3_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(9), Op2(3), access_gic_ap1r },
-	/* ICC_BPR1_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(3), access_gic_bpr1 },
-	/* ICC_CTLR_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(4), access_gic_ctlr },
-	/* ICC_SRE_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(5), access_gic_sre },
-	/* ICC_IGRPEN0_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(6), access_gic_grpen0 },
-	/* ICC_IGRPEN1_EL1 */
-	{ Op0(3), Op1(0), CRn(12), CRm(12), Op2(7), access_gic_grpen1 },
+	{ SYS_DESC(SYS_ICC_PMR_EL1), access_gic_pmr },
+	{ SYS_DESC(SYS_ICC_BPR0_EL1), access_gic_bpr0 },
+	{ SYS_DESC(SYS_ICC_AP0R0_EL1), access_gic_ap0r },
+	{ SYS_DESC(SYS_ICC_AP0R1_EL1), access_gic_ap0r },
+	{ SYS_DESC(SYS_ICC_AP0R2_EL1), access_gic_ap0r },
+	{ SYS_DESC(SYS_ICC_AP0R3_EL1), access_gic_ap0r },
+	{ SYS_DESC(SYS_ICC_AP1R0_EL1), access_gic_ap1r },
+	{ SYS_DESC(SYS_ICC_AP1R1_EL1), access_gic_ap1r },
+	{ SYS_DESC(SYS_ICC_AP1R2_EL1), access_gic_ap1r },
+	{ SYS_DESC(SYS_ICC_AP1R3_EL1), access_gic_ap1r },
+	{ SYS_DESC(SYS_ICC_BPR1_EL1), access_gic_bpr1 },
+	{ SYS_DESC(SYS_ICC_CTLR_EL1), access_gic_ctlr },
+	{ SYS_DESC(SYS_ICC_SRE_EL1), access_gic_sre },
+	{ SYS_DESC(SYS_ICC_IGRPEN0_EL1), access_gic_grpen0 },
+	{ SYS_DESC(SYS_ICC_IGRPEN1_EL1), access_gic_grpen1 },
 };
 
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, bool is_write, u64 id,
-- 
2.11.0
