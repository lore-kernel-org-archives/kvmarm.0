From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH] KVM: arm64: Fix architecturally invalid reset value for FPEXC32_EL2
Date: Thu, 21 Feb 2019 11:42:32 +0000
Message-ID: <1550749352-2315-1-git-send-email-Dave.Martin@arm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Julien Thierry <julien.thierry@arm.com>, James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

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
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Fixes: 62a89c44954f ("arm64: KVM: 32bit handling of coprocessor traps")
Signed-off-by: Dave Martin <Dave.Martin@arm.com>

---

For AArch32 the situation is more complicated.  FPEXC[29:0] is
subarchitecture-defined, so the reset value may need to be per-CPU-
implementation.  The machinery for this is incomplete today In fact, I
haven't currently found any reset logic for the VFP registers in
arch/arm/kvm.

Currently I don't attempt to address this, but if anyone has ideas
about the best way to address it, please shout.

I'll try to figure out something in the meantime, but it's not my top
priority.  We have no evidence I'm aware of that this is causing
problems for anybody today.
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c936aa4..b6dac3a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1476,7 +1476,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
 	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
-	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x70 },
+	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
 };
 
 static bool trap_dbgidr(struct kvm_vcpu *vcpu,
-- 
2.1.4
