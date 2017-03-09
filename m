From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 15/15] KVM: arm64: Use common Set/Way sys definitions
Date: Thu,  9 Mar 2017 17:07:27 +0000
Message-ID: <1489079247-31092-16-git-send-email-mark.rutland@arm.com>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5599840AF9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:07:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YrlNWRzU1-Up for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 12:07:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90E7F40B3E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:07:27 -0500 (EST)
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

Now that we have common definitions for the encoding of Set/Way cache
maintenance operations, make the KVM code use these, simplifying the
sys_reg_descs table.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index effa5ce..0e6c477 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -879,15 +879,9 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
  * more demanding guest...
  */
 static const struct sys_reg_desc sys_reg_descs[] = {
-	/* DC ISW */
-	{ Op0(0b01), Op1(0b000), CRn(0b0111), CRm(0b0110), Op2(0b010),
-	  access_dcsw },
-	/* DC CSW */
-	{ Op0(0b01), Op1(0b000), CRn(0b0111), CRm(0b1010), Op2(0b010),
-	  access_dcsw },
-	/* DC CISW */
-	{ Op0(0b01), Op1(0b000), CRn(0b0111), CRm(0b1110), Op2(0b010),
-	  access_dcsw },
+	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
 
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
-- 
1.9.1
