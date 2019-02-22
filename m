From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/27] arm64: KVM: Fix architecturally invalid reset value for
 FPEXC32_EL2
Date: Fri, 22 Feb 2019 16:26:05 +0000
Message-ID: <20190222162605.5054-28-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF3154A1FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:29:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kEnCRgfAf92N for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:29:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29AFD4A3BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:29:16 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Dave Martin <Dave.Martin@arm.com>

Due to what looks like a typo dating back to the original addition
of FPEXC32_EL2 handling, KVM currently initialises this register to
an architecturally invalid value.

As a result, the VECITR field (RES1) in bits [10:8] is initialised
with 0, and the two reserved (RES0) bits [6:5] are initialised with
1.  (In the Common VFP Subarchitecture as specified by ARMv7-A,
these two bits were IMP DEF.  ARMv8-A removes them.)

This patch changes the reset value from 0x70 to 0x700, which
reflects the architectural constraints and is presumably what was
originally intended.

Cc: <stable@vger.kernel.org> # 4.12.x-
Cc: Christoffer Dall <christoffer.dall@arm.com>
Fixes: 62a89c44954f ("arm64: KVM: 32bit handling of coprocessor traps")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 81a342679e60..a398d04274b7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1523,7 +1523,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x70 },
+	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
 };
 
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
-- 
2.20.1
