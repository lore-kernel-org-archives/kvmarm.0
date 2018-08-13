From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 31/37] KVM: arm64: vgic-v3: Add support for ICC_SGI0R_EL1 and
 ICC_ASGI1R_EL1 accesses
Date: Mon, 13 Aug 2018 15:57:49 +0100
Message-ID: <20180813145755.16566-32-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A78E4A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L63No92CTfsd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DD9D4A245
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:29 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In order to generate Group0 SGIs, let's add some decoding logic to
access_gic_sgi(), and pass the generating group accordingly.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/sysreg.h |  2 ++
 arch/arm64/kvm/sys_regs.c       | 41 +++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 98af0b37fb31..b0d2a52a71a3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -314,6 +314,8 @@
 #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
 #define SYS_ICC_RPR_EL1			sys_reg(3, 0, 12, 11, 3)
 #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
+#define SYS_ICC_ASGI1R_EL1		sys_reg(3, 0, 12, 11, 6)
+#define SYS_ICC_SGI0R_EL1		sys_reg(3, 0, 12, 11, 7)
 #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
 #define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
 #define SYS_ICC_HPPIR1_EL1		sys_reg(3, 0, 12, 12, 2)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index aba6755c816d..22fbbdbece3c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -252,10 +252,43 @@ static bool access_gic_sgi(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
+	bool g1;
+
 	if (!p->is_write)
 		return read_from_write_only(vcpu, p, r);
 
-	vgic_v3_dispatch_sgi(vcpu, p->regval, true);
+	/*
+	 * In a system where GICD_CTLR.DS=1, a ICC_SGI0R_EL1 access generates
+	 * Group0 SGIs only, while ICC_SGI1R_EL1 can generate either group,
+	 * depending on the SGI configuration. ICC_ASGI1R_EL1 is effectively
+	 * equivalent to ICC_SGI0R_EL1, as there is no "alternative" secure
+	 * group.
+	 */
+	if (p->is_aarch32) {
+		switch (p->Op1) {
+		default:		/* Keep GCC quiet */
+		case 0:			/* ICC_SGI1R */
+			g1 = true;
+			break;
+		case 1:			/* ICC_ASGI1R */
+		case 2:			/* ICC_SGI0R */
+			g1 = false;
+			break;
+		}
+	} else {
+		switch (p->Op2) {
+		default:		/* Keep GCC quiet */
+		case 5:			/* ICC_SGI1R_EL1 */
+			g1 = true;
+			break;
+		case 6:			/* ICC_ASGI1R_EL1 */
+		case 7:			/* ICC_SGI0R_EL1 */
+			g1 = false;
+			break;
+		}
+	}
+
+	vgic_v3_dispatch_sgi(vcpu, p->regval, g1);
 
 	return true;
 }
@@ -1312,6 +1345,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_ICC_DIR_EL1), read_from_write_only },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
+	{ SYS_DESC(SYS_ICC_ASGI1R_EL1), access_gic_sgi },
+	{ SYS_DESC(SYS_ICC_SGI0R_EL1), access_gic_sgi },
 	{ SYS_DESC(SYS_ICC_IAR1_EL1), write_to_read_only },
 	{ SYS_DESC(SYS_ICC_EOIR1_EL1), read_from_write_only },
 	{ SYS_DESC(SYS_ICC_HPPIR1_EL1), write_to_read_only },
@@ -1744,8 +1779,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 static const struct sys_reg_desc cp15_64_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 0), CRm( 9), Op2( 0), access_pmu_evcntr },
-	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi },
+	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI1R */
 	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR1 },
+	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
+	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
 	{ Op1( 2), CRn( 0), CRm(14), Op2( 0), access_cntp_cval },
 };
 
-- 
2.18.0
