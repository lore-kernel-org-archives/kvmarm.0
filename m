From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/13] arm64: KVM: VHE: Patch out use of HVC
Date: Wed,  8 Jul 2015 17:19:10 +0100
Message-ID: <1436372356-30410-8-git-send-email-marc.zyngier@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CC558120
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mk-vCED4gpUe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2015 12:08:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08B875812B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2015 12:08:06 -0400 (EDT)
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

With VHE, the host never issues an HVC instruction to get into the
KVM code, as we can simply branch there.

Use runtime code patching to simplify things a bit.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp.S        | 43 ++++++++++++++++++++++++++++++++++++-------
 arch/arm64/kvm/vhe-macros.h | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/kvm/vhe-macros.h

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 17a8fb1..a65e053 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -30,6 +30,8 @@
 #include <asm/kvm_mmu.h>
 #include <asm/memory.h>
 
+#include "vhe-macros.h"
+
 #define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
 #define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
 #define CPU_SPSR_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_SPSR + 8*x)
@@ -39,6 +41,19 @@
 	.pushsection	.hyp.text, "ax"
 	.align	PAGE_SHIFT
 
+.macro do_el2_call
+	/*
+	 * Shuffle the parameters before calling the function
+	 * pointed to in x0. Assumes parameters in x[1,2,3],
+	 * clobbers lr.
+	 */
+	mov     lr, x0
+	mov     x0, x1
+	mov     x1, x2
+	mov     x2, x3
+	blr     lr
+.endm
+
 .macro save_common_regs
 	// x2: base address for cpu context
 	// x3: tmp register
@@ -1124,7 +1139,23 @@ __hyp_panic_str:
  * arch/arm64/kernel/hyp_stub.S.
  */
 ENTRY(kvm_call_hyp)
-	hvc	#0
+	/*
+	 * NOP out the hvc/ret sequence on VHE, and fall through.
+	 */
+ifnvhe	hvc #0,					nop
+ifnvhe	ret,				       "push	lr, xzr"
+
+	do_el2_call
+
+	/*
+	 * We used to rely on having an exception return to get
+	 * an implicit isb. In the E2H case, we don't have it anymore.
+	 * rather than changing all the leaf functions, just do it here
+	 * before returning to the rest of the kernel.
+	 */
+	isb
+
+	pop     lr, xzr
 	ret
 ENDPROC(kvm_call_hyp)
 
@@ -1156,7 +1187,9 @@ el1_sync:					// Guest trapped into EL2
 	mrs	x1, esr_el2
 	lsr	x2, x1, #ESR_ELx_EC_SHIFT
 
-	cmp	x2, #ESR_ELx_EC_HVC64
+	// Ugly shortcut for VHE. We can do this early because the
+	// host cannot do an HVC.
+ifnvhe  _S_(cmp	x2, #ESR_ELx_EC_HVC64),		"b	el1_trap"
 	b.ne	el1_trap
 
 	mrs	x3, vttbr_el2			// If vttbr is valid, the 64bit guest
@@ -1177,11 +1210,7 @@ el1_sync:					// Guest trapped into EL2
 	 * Compute the function address in EL2, and shuffle the parameters.
 	 */
 	kern_hyp_va	x0
-	mov	lr, x0
-	mov	x0, x1
-	mov	x1, x2
-	mov	x2, x3
-	blr	lr
+	do_el2_call
 
 	pop	lr, xzr
 2:	eret
diff --git a/arch/arm64/kvm/vhe-macros.h b/arch/arm64/kvm/vhe-macros.h
new file mode 100644
index 0000000..da7f9da
--- /dev/null
+++ b/arch/arm64/kvm/vhe-macros.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2015 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __ARM64_VHE_MACROS_H__
+#define __ARM64_VHE_MACROS_H__
+
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
+
+#ifdef __ASSEMBLY__
+
+/* Hack to allow stringification of macros... */
+#define __S__(a,args...)	__stringify(a, ##args)
+#define _S_(a,args...)		__S__(a, args)
+
+.macro ifnvhe nonvhe vhe
+	alternative_insn	"\nonvhe", "\vhe", ARM64_HAS_VIRT_HOST_EXTN
+.endm
+
+#endif
+
+#endif	/*__ARM64_VHE_MACROS_H__  */
-- 
2.1.4
