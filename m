From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 02/19] arm64: asm-offsets: Remove unused definitions
Date: Mon, 18 Dec 2017 17:39:09 +0000
Message-ID: <20171218173926.16911-3-marc.zyngier@arm.com>
References: <20171218173926.16911-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171218173926.16911-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

asm-offsets.h contains a number of definitions that are not used
at all, and in some cases conflict with other definitions (such as
NSEC_PER_SEC).

Spring clean-up time.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/asm-offsets.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 7e8be0c22ce0..742887330101 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -83,10 +83,6 @@ int main(void)
   DEFINE(VMA_VM_MM,		offsetof(struct vm_area_struct, vm_mm));
   DEFINE(VMA_VM_FLAGS,		offsetof(struct vm_area_struct, vm_flags));
   BLANK();
-  DEFINE(VM_EXEC,	       	VM_EXEC);
-  BLANK();
-  DEFINE(PAGE_SZ,	       	PAGE_SIZE);
-  BLANK();
   DEFINE(__DMA_BIDIRECTIONAL,	DMA_BIDIRECTIONAL);
   DEFINE(__DMA_TO_DEVICE,	DMA_TO_DEVICE);
   DEFINE(__DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
@@ -98,7 +94,6 @@ int main(void)
   DEFINE(CLOCK_REALTIME_COARSE,	CLOCK_REALTIME_COARSE);
   DEFINE(CLOCK_MONOTONIC_COARSE,CLOCK_MONOTONIC_COARSE);
   DEFINE(CLOCK_COARSE_RES,	LOW_RES_NSEC);
-  DEFINE(NSEC_PER_SEC,		NSEC_PER_SEC);
   BLANK();
   DEFINE(VDSO_CS_CYCLE_LAST,	offsetof(struct vdso_data, cs_cycle_last));
   DEFINE(VDSO_RAW_TIME_SEC,	offsetof(struct vdso_data, raw_time_sec));
-- 
2.14.2
