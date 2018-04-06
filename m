From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] ARM64: KVM: use lm_alias() for kvm_ksym_ref()
Date: Fri,  6 Apr 2018 16:19:09 +0100
Message-ID: <20180406151909.57197-1-mark.rutland@arm.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

For historical reasons, we open-code lm_alias() in kvm_ksym_ref().

Let's use lm_alias() to avoid duplication and make things clearer.

As we have to pull this from <linux/mm.h> (which is not safe for
includion in assembly), we may as well move the kvm_ksym_ref()
definition into the existing !__ASSEMBLY__ block.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/include/asm/kvm_asm.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 24961b732e65..306aaead8204 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -33,15 +33,18 @@
 #define KVM_ARM64_DEBUG_DIRTY_SHIFT	0
 #define KVM_ARM64_DEBUG_DIRTY		(1 << KVM_ARM64_DEBUG_DIRTY_SHIFT)
 
+#ifndef __ASSEMBLY__
+
+#include <linux/mm.h>
+
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
