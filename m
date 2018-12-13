From: Will Deacon <will.deacon@arm.com>
Subject: [PATCH] arm64: kvm: Avoid setting the upper 32 bits of VTCR_EL2 to 1
Date: Thu, 13 Dec 2018 16:06:14 +0000
Message-ID: <1544717174-15116-1-git-send-email-will.deacon@arm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Although bit 31 of VTCR_EL2 is RES1, we inadvertently end up setting all
of the upper 32 bits to 1 as well because we define VTCR_EL2_RES1 as
signed, which is sign-extended when assigning to kvm->arch.vtcr.

Lucky for us, the architecture currently treats these upper bits as RES0
so, whilst we've been naughty, we haven't set fire to anything yet.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 6f602af5263c..2dafd936d84d 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -104,7 +104,7 @@
 			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK | TCR_EL2_T0SZ_MASK)
 
 /* VTCR_EL2 Registers bits */
-#define VTCR_EL2_RES1		(1 << 31)
+#define VTCR_EL2_RES1		(1U << 31)
 #define VTCR_EL2_HD		(1 << 22)
 #define VTCR_EL2_HA		(1 << 21)
 #define VTCR_EL2_PS_SHIFT	TCR_EL2_PS_SHIFT
-- 
2.1.4
