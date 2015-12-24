From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 13/31] arm64: KVM: Add patchable function selector
Date: Thu, 24 Dec 2015 11:12:21 +0000
Message-ID: <1450955559-15639-14-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Amit Singh Tomar <amittomer25@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Jisheng Zhang <jszhang@marvell.com>, Mark Rutland <mark.rutland@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM so far relies on code patching, and is likely to use it more
in the future. The main issue is that our alternative system works
at the instruction level, while we'd like to have alternatives at
the function level.

In order to cope with this, add the "hyp_alternate_select" macro that
outputs a brief sequence of code that in turn can be patched, allowing
an alternative function to be selected.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 0809653..73419a7 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -29,6 +29,30 @@
 #define hyp_kern_va(v) (typeof(v))((unsigned long)(v) - HYP_PAGE_OFFSET \
 						      + PAGE_OFFSET)
 
+/**
+ * hyp_alternate_select - Generates patchable code sequences that are
+ * used to switch between two implementations of a function, depending
+ * on the availability of a feature.
+ *
+ * @fname: a symbol name that will be defined as a function returning a
+ * function pointer whose type will match @orig and @alt
+ * @orig: A pointer to the default function, as returned by @fname when
+ * @cond doesn't hold
+ * @alt: A pointer to the alternate function, as returned by @fname
+ * when @cond holds
+ * @cond: a CPU feature (as described in asm/cpufeature.h)
+ */
+#define hyp_alternate_select(fname, orig, alt, cond)			\
+typeof(orig) * __hyp_text fname(void)					\
+{									\
+	typeof(alt) *val = orig;					\
+	asm volatile(ALTERNATIVE("nop		\n",			\
+				 "mov	%0, %1	\n",			\
+				 cond)					\
+		     : "+r" (val) : "r" (alt));				\
+	return val;							\
+}
+
 void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
-- 
2.1.4

