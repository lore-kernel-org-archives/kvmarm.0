From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 21/27] arm64/sve: KVM: Prevent guests from using SVE
Date: Wed,  9 Aug 2017 13:05:27 +0100
Message-ID: <1502280338-23002-22-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7102449C48
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:06:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tBi5K1h019rP for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Aug 2017 08:06:42 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70EE449C40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Aug 2017 08:06:42 -0400 (EDT)
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
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
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Until KVM has full SVE support, guests must not be allowed to
execute SVE instructions.

This patch enables the necessary traps, and also ensures that the
traps are disabled again on exit from the guest so that the host
can still use SVE if it wants to.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 3 ++-
 arch/arm64/kvm/hyp/switch.c      | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index dbf0537..8a19651 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -186,7 +186,7 @@
 #define CPTR_EL2_TTA	(1 << 20)
 #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 #define CPTR_EL2_TZ	(1 << 8)
-#define CPTR_EL2_DEFAULT	0x000033ff
+#define CPTR_EL2_DEFAULT	(0x000033ff & ~CPTR_EL2_TZ)
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_TPMS		(1 << 14)
@@ -237,5 +237,6 @@
 
 #define CPACR_EL1_FPEN		(3 << 20)
 #define CPACR_EL1_TTA		(1 << 28)
+#define CPACR_EL1_DEFAULT	(CPACR_EL1_FPEN | CPACR_EL1_ZEN_EL1EN)
 
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 35a90b8..951f3eb 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -48,7 +48,7 @@ static void __hyp_text __activate_traps_vhe(void)
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
-	val &= ~CPACR_EL1_FPEN;
+	val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
 	write_sysreg(val, cpacr_el1);
 
 	write_sysreg(__kvm_hyp_vector, vbar_el1);
@@ -59,7 +59,7 @@ static void __hyp_text __activate_traps_nvhe(void)
 	u64 val;
 
 	val = CPTR_EL2_DEFAULT;
-	val |= CPTR_EL2_TTA | CPTR_EL2_TFP;
+	val |= CPTR_EL2_TTA | CPTR_EL2_TFP | CPTR_EL2_TZ;
 	write_sysreg(val, cptr_el2);
 }
 
@@ -117,7 +117,7 @@ static void __hyp_text __deactivate_traps_vhe(void)
 
 	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
-	write_sysreg(CPACR_EL1_FPEN, cpacr_el1);
+	write_sysreg(CPACR_EL1_DEFAULT, cpacr_el1);
 	write_sysreg(vectors, vbar_el1);
 }
 
-- 
2.1.4
