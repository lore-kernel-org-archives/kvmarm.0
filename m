From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/4] KVM: arm64: Remove non-existent AArch32 ICC_SGI1R encoding
Date: Wed,  8 Aug 2018 14:14:58 +0100
Message-ID: <20180808131501.584-2-marc.zyngier@arm.com>
References: <20180808131501.584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69F0B4A1CF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 09:15:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0itiY+4z8pch for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Aug 2018 09:15:13 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A216D4A0E1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Aug 2018 09:15:13 -0400 (EDT)
In-Reply-To: <20180808131501.584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

ICC_SGI1R is a 64bit system register, even on AArch32. It is thus
pointless to have such an encoding in the 32bit cp15 array. Let's
drop it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 774d72155904..e04aacb2a24c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1622,8 +1622,6 @@ static const struct sys_reg_desc cp14_64_regs[] = {
  * register).
  */
 static const struct sys_reg_desc cp15_regs[] = {
-	{ Op1( 0), CRn( 0), CRm(12), Op2( 0), access_gic_sgi },
-
 	{ Op1( 0), CRn( 1), CRm( 0), Op2( 0), access_vm_reg, NULL, c1_SCTLR },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 0), access_vm_reg, NULL, c2_TTBR0 },
 	{ Op1( 0), CRn( 2), CRm( 0), Op2( 1), access_vm_reg, NULL, c2_TTBR1 },
-- 
2.18.0
