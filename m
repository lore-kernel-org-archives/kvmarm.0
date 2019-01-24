From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 040/104] arm64/kvm: consistently handle host HCR_EL2 flags
Date: Thu, 24 Jan 2019 20:19:29 +0100
Message-ID: <20190124190159.774535855@linuxfoundation.org>
References: <20190124190154.968308875@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190124190154.968308875@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Richard Henderson <richard.henderson@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, Sasha Levin <sashal@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Backport of upstream commit 4eaed6aa2c628101246bcabc91b203bfac1193f8 ]

In KVM we define the configuration of HCR_EL2 for a VHE HOST in
HCR_HOST_VHE_FLAGS, but we don't have a similar definition for the
non-VHE host flags, and open-code HCR_RW. Further, in head.S we
open-code the flags for VHE and non-VHE configurations.

In future, we're going to want to configure more flags for the host, so
lets add a HCR_HOST_NVHE_FLAGS defintion, and consistently use both
HCR_HOST_VHE_FLAGS and HCR_HOST_NVHE_FLAGS in the kvm code and head.S.

We now use mov_q to generate the HCR_EL2 value, as we use when
configuring other registers in head.S.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Will Deacon <will.deacon@arm.com>
[kristina: backport to 4.4.y: non-VHE only; __deactivate_traps_nvhe in
  assembly; add #include]
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 1 +
 arch/arm64/kernel/head.S         | 3 ++-
 arch/arm64/kvm/hyp.S             | 2 +-
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index ef8e13d379cb..013b7de45ee7 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -81,6 +81,7 @@
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW)
 #define HCR_VIRT_EXCP_MASK (HCR_VA | HCR_VI | HCR_VF)
 #define HCR_INT_OVERRIDE   (HCR_FMO | HCR_IMO)
+#define HCR_HOST_NVHE_FLAGS (HCR_RW)
 
 
 /* Hyp System Control Register (SCTLR_EL2) bits */
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d019c3a58cc2..0382eba4bf7b 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -30,6 +30,7 @@
 #include <asm/cache.h>
 #include <asm/cputype.h>
 #include <asm/kernel-pgtable.h>
+#include <asm/kvm_arm.h>
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
 #include <asm/pgtable.h>
@@ -464,7 +465,7 @@ CPU_LE(	bic	x0, x0, #(3 << 24)	)	// Clear the EE and E0E bits for EL1
 	ret
 
 	/* Hyp configuration. */
-2:	mov	x0, #(1 << 31)			// 64-bit EL1
+2:	mov_q	x0, HCR_HOST_NVHE_FLAGS
 	msr	hcr_el2, x0
 
 	/* Generic timers. */
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 86c289832272..8d3da858c257 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -494,7 +494,7 @@
 .endm
 
 .macro deactivate_traps
-	mov	x2, #HCR_RW
+	mov_q	x2, HCR_HOST_NVHE_FLAGS
 	msr	hcr_el2, x2
 	msr	hstr_el2, xzr
 
-- 
2.19.1
