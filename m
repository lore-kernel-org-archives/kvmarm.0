From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH] arm64: KVM: report configured SRE value to 32-bit world
Date: Wed, 10 Aug 2016 10:49:43 +0100
Message-ID: <1470822583-9014-2-git-send-email-vladimir.murzin@arm.com>
References: <1470822583-9014-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37CE7412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 05:42:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0nUXxBkI8ZzJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2016 05:42:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB01A40FA7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2016 05:42:51 -0400 (EDT)
In-Reply-To: <1470822583-9014-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

After commit b34f2bc ("arm64: KVM: Make ICC_SRE_EL1 access return the
configured SRE value") we report SRE value to 64-bit guest, but 32-bit
one still handled as RAZ/WI what leads to funny promise we do not keep:

"GICv3: GIC: unable to set SRE (disabled at EL2), panic ahead"

We could keep that promise and force panic, but it doesn't look
reliable, instead report configured SRE value to 32-bit guest.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b0b225c..0940bfc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1360,7 +1360,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn(10), CRm( 3), Op2( 1), access_vm_reg, NULL, c10_AMAIR1 },
 
 	/* ICC_SRE */
-	{ Op1( 0), CRn(12), CRm(12), Op2( 5), trap_raz_wi },
+	{ Op1( 0), CRn(12), CRm(12), Op2( 5), access_gic_sre },
 
 	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
 
-- 
2.0.0
