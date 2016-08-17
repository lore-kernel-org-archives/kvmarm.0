From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 12/12] arm64: KVM: report configured SRE value to 32-bit world
Date: Wed, 17 Aug 2016 21:38:59 +0200
Message-ID: <20160817193859.15726-13-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Vladimir Murzin <vladimir.murzin@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

After commit b34f2bc ("arm64: KVM: Make ICC_SRE_EL1 access return the
configured SRE value") we report SRE value to 64-bit guest, but 32-bit
one still handled as RAZ/WI what leads to funny promise we do not keep:

"GICv3: GIC: unable to set SRE (disabled at EL2), panic ahead"

Instead, return the actual value of the ICC_SRE_EL1 register that the
guest should see.

 [ Tweaked commit message - Christoffer ]

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index af5ea86..e51367d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1352,7 +1352,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn(10), CRm( 3), Op2( 1), access_vm_reg, NULL, c10_AMAIR1 },
 
 	/* ICC_SRE */
-	{ Op1( 0), CRn(12), CRm(12), Op2( 5), trap_raz_wi },
+	{ Op1( 0), CRn(12), CRm(12), Op2( 5), access_gic_sre },
 
 	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
 
-- 
2.9.0

