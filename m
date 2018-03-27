From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 16/17] kvm: arm64: Add support for handling 52bit IPA
Date: Tue, 27 Mar 2018 14:15:26 +0100
Message-ID: <1522156531-28348-17-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, cdall@kernel.org, marc.zyngier@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, ard.biesheuvel@linaro.org, peter.maydell@linaro.org, kristina.martsenko@arm.com, mark.rutland@arm.com, Suzuki K Poulose <suzuki.poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add support for handling the 52bit IPA. 52bit IPA
support needs changes to the following :

 1) Page-table entries - We use kernel page table helpers for setting
 up the stage2. Hence we don't explicit changes here

 2) VTTBR:BADDR - This is already supported with :
   commit 529c4b05a3cb2f324aa ("arm64: handle 52-bit addresses in TTBR")

 3) VGIC support for 52bit: Supported with a patch in this series.

That leaves us with the handling for PAR and HPAR. This patch adds
support for handling the 52bit addresses in PAR and HPFAR,
which are used while handling the permission faults in stage1.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 7 +++++++
 arch/arm64/kvm/hyp/switch.c      | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 2b278dc..e48852c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -302,6 +302,13 @@
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
+/*
+ * We have
+ *	PAR	[PA_Shift - 1	: 12] = PA	[PA_Shift - 1 : 12]
+ *	HPFAR	[PA_Shift - 9	: 4]  = FIPA	[PA_Shift - 1 : 12]
+ */
+#define PAR_TO_HPFAR(par)		\
+	(((par) & GENMASK_ULL(PHYS_MASK_SHIFT - 1, 12)) >> 8)
 
 #define kvm_arm_exception_type	\
 	{0, "IRQ" }, 		\
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 794da55..b785853 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -241,7 +241,7 @@ static bool __hyp_text __translate_far_to_hpfar(u64 far, u64 *hpfar)
 		return false; /* Translation failed, back to guest */
 
 	/* Convert PAR to HPFAR format */
-	*hpfar = ((tmp >> 12) & ((1UL << 36) - 1)) << 4;
+	*hpfar = PAR_TO_HPFAR(tmp);
 	return true;
 }
 
-- 
2.7.4
