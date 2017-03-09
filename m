From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 12/15] KVM: arm64: Use common physical timer sysreg definitions
Date: Thu,  9 Mar 2017 17:07:24 +0000
Message-ID: <1489079247-31092-13-git-send-email-mark.rutland@arm.com>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A1A40625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:07:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p7XsiM0ROGLQ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 12:07:21 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B99B40962
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:07:21 -0500 (EST)
In-Reply-To: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Now that we have common definitions for the physical timer control
registers, make the KVM code use these, simplifying the sys_reg_descs
table.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1f3062b..860707f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1016,15 +1016,9 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b011),
 	  NULL, reset_unknown, TPIDRRO_EL0 },
 
-	/* CNTP_TVAL_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b0010), Op2(0b000),
-	  access_cntp_tval },
-	/* CNTP_CTL_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b0010), Op2(0b001),
-	  access_cntp_ctl },
-	/* CNTP_CVAL_EL0 */
-	{ Op0(0b11), Op1(0b011), CRn(0b1110), CRm(0b0010), Op2(0b010),
-	  access_cntp_cval },
+	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_cntp_tval },
+	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_cntp_ctl },
+	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_cntp_cval },
 
 	/* PMEVCNTRn_EL0 */
 	PMU_PMEVCNTR_EL0(0),
-- 
1.9.1
