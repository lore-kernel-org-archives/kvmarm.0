From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/13] arm64: KVM: VHE: Patch out kern_hyp_va
Date: Wed,  8 Jul 2015 17:19:09 +0100
Message-ID: <1436372356-30410-7-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EAD058128
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tkCu4-K1rQO4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:08:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6016F5813D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:04 -0400 (EDT)
In-Reply-To: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The kern_hyp_va macro is pretty meaninless with VHE, as there is
only one mapping - the kernel one.

In order to keep the code readable and efficient, use runtime
patching to replace the 'and' instruction used to compute the VA
with a 'nop'.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index b525cd2..285642e 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -55,6 +55,8 @@
 
 #ifdef __ASSEMBLY__
 
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
 #include <asm/kvm_arm.h>
 
 .macro setup_vtcr tmp1, tmp2
@@ -69,12 +71,18 @@
 	msr	vtcr_el2, \tmp1
 	isb
 .endm
+
+/* Stupid macro to deal with multiple level of macro expansion */
+.macro __vhe_nop inst val
+	alternative_insn "\inst\val", "nop", ARM64_HAS_VIRT_HOST_EXTN
+.endm
+
 /*
  * Convert a kernel VA into a HYP VA.
  * reg: VA to be converted.
  */
 .macro kern_hyp_va	reg
-	and	\reg, \reg, #HYP_PAGE_OFFSET_MASK
+	__vhe_nop "and \reg, \reg, #", __stringify(HYP_PAGE_OFFSET_MASK)
 .endm
 
 #else
-- 
2.1.4
