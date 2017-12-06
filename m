From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 02/18] arm64: asm-offsets: Remove unused definitions
Date: Wed,  6 Dec 2017 14:38:23 +0000
Message-ID: <20171206143839.29223-3-marc.zyngier@arm.com>
References: <20171206143839.29223-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF8A249D78
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:35:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 15h6noDn3gei for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 09:35:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D293E49D20
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:35:35 -0500 (EST)
In-Reply-To: <20171206143839.29223-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
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
