From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 05/17] arm64: Helper for parange to PASize
Date: Tue, 27 Mar 2018 14:15:15 +0100
Message-ID: <1522156531-28348-6-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 997F14A088
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 09:08:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sknZYujoSm77 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Mar 2018 09:08:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4E749F7F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 09:08:08 -0400 (EDT)
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add a helper to convert ID_AA64MMFR0_EL1:PARange to they physical
size shift. Limit the size to the maximum supported by the kernel.
We are about to move the user of this code and this helps to
keep the changes cleaner.

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 16 ++++++++++++++++
 arch/arm64/kvm/hyp/s2-setup.c       | 28 +++++-----------------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index fbf0aab..1f2a5dd 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -311,6 +311,22 @@ static inline u64 read_zcr_features(void)
 	return zcr;
 }
 
+static inline u32 id_aa64mmfr0_parange_to_phys_shift(int parange)
+{
+	switch (parange) {
+	case 0: return 32;
+	case 1: return 36;
+	case 2: return 40;
+	case 3: return 42;
+	case 4: return 44;
+	/* Report 48 bit if the kernel doesn't support 52bit */
+	default:
+	case 5: return 48;
+#ifdef CONFIG_ARM64_PA_BITS_52
+	case 6: return 52;
+#endif
+	}
+}
 #endif /* __ASSEMBLY__ */
 
 #endif
diff --git a/arch/arm64/kvm/hyp/s2-setup.c b/arch/arm64/kvm/hyp/s2-setup.c
index 603e1ee..b1129c8 100644
--- a/arch/arm64/kvm/hyp/s2-setup.c
+++ b/arch/arm64/kvm/hyp/s2-setup.c
@@ -19,11 +19,13 @@
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/cpufeature.h>
 
 u32 __hyp_text __init_stage2_translation(void)
 {
 	u64 val = VTCR_EL2_FLAGS;
 	u64 parange;
+	u32 phys_shift;
 	u64 tmp;
 
 	/*
@@ -37,27 +39,7 @@ u32 __hyp_text __init_stage2_translation(void)
 	val |= parange << 16;
 
 	/* Compute the actual PARange... */
-	switch (parange) {
-	case 0:
-		parange = 32;
-		break;
-	case 1:
-		parange = 36;
-		break;
-	case 2:
-		parange = 40;
-		break;
-	case 3:
-		parange = 42;
-		break;
-	case 4:
-		parange = 44;
-		break;
-	case 5:
-	default:
-		parange = 48;
-		break;
-	}
+	phys_shift = id_aa64mmfr0_parange_to_phys_shift(parange);
 
 	/*
 	 * ... and clamp it to 40 bits, unless we have some braindead
@@ -65,7 +47,7 @@ u32 __hyp_text __init_stage2_translation(void)
 	 * return that value for the rest of the kernel to decide what
 	 * to do.
 	 */
-	val |= 64 - (parange > 40 ? 40 : parange);
+	val |= 64 - (phys_shift > 40 ? 40 : phys_shift);
 
 	/*
 	 * Check the availability of Hardware Access Flag / Dirty Bit
@@ -86,5 +68,5 @@ u32 __hyp_text __init_stage2_translation(void)
 
 	write_sysreg(val, vtcr_el2);
 
-	return parange;
+	return phys_shift;
 }
-- 
2.7.4
