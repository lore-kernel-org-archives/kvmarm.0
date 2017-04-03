From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 04/34] arm64: hyp-stub: Define a return value for failed stub calls
Date: Mon,  3 Apr 2017 19:37:37 +0100
Message-ID: <20170403183807.1620-5-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Define a standard return value to be returned when a hyp stub
call fails, and make KVM use it for ARM_EXCEPTION_HYP_GONE
(instead of using a KVM-specific value).

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h | 2 +-
 arch/arm64/include/asm/virt.h    | 3 +++
 arch/arm64/kernel/hyp-stub.S     | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ec3553eb9349..1769380a8fc0 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -28,7 +28,7 @@
 #define ARM_EXCEPTION_EL1_SERROR  1
 #define ARM_EXCEPTION_TRAP	  2
 /* The hyp-stub will return this for any kvm_call_hyp() call */
-#define ARM_EXCEPTION_HYP_GONE	  3
+#define ARM_EXCEPTION_HYP_GONE	  HVC_STUB_ERR
 
 #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
 #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 439f6b5d31f6..1466d14c664d 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -39,6 +39,9 @@
  */
 #define HVC_SOFT_RESTART 2
 
+/* Error returned when an invalid stub number is passed into x0 */
+#define HVC_STUB_ERR	0xbadca11
+
 #define BOOT_CPU_MODE_EL1	(0xe11)
 #define BOOT_CPU_MODE_EL2	(0xe12)
 
diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index 193dfb25ce2f..f53e8b84cd3a 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -74,7 +74,7 @@ el1_sync:
 	br	x4				// no return
 
 	/* Someone called kvm_call_hyp() against the hyp-stub... */
-3:	mov	x0, #ARM_EXCEPTION_HYP_GONE
+3:	ldr	x0, =HVC_STUB_ERR
 
 9:	eret
 ENDPROC(el1_sync)
-- 
2.11.0
