From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2] ARM64: KVM: use lm_alias() for kvm_ksym_ref()
Date: Thu, 10 May 2018 12:13:47 +0100
Message-ID: <20180510111347.32253-1-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

For historical reasons, we open-code lm_alias() in kvm_ksym_ref().

Let's use lm_alias() to avoid duplication and make things clearer.

As we have to pull this from <linux/mm.h> (which is not safe for
inclusion in assembly), we may as well move the kvm_ksym_ref()
definition into the existing !__ASSEMBLY__ block.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_asm.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Since v1 [1]:
* Rebase to v4.17-rc4
* Fix typo in commit message

Mark.

[1] https://lkml.kernel.org/r/20180406151909.57197-1-mark.rutland@arm.com

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f6648a3e4152..a9ceeec5a76f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -33,16 +33,19 @@
 #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
 #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
 
+#ifndef __ASSEMBLY__
+
+#include <linux/mm.h>
+
 /* Translate a kernel address of @sym into its equivalent linear mapping */
 #define kvm_ksym_ref(sym)						\
 	({								\
 		void *val = &sym;					\
 		if (!is_kernel_in_hyp_mode())				\
-			val = phys_to_virt((u64)&sym - kimage_voffset);	\
+			val = lm_alias(&sym);				\
 		val;							\
 	 })
 
-#ifndef __ASSEMBLY__
 struct kvm;
 struct kvm_vcpu;
 
-- 
2.11.0
