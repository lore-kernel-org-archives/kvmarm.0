From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 10/21] arm64: KVM: Add patchable function selector
Date: Fri, 27 Nov 2015 18:50:04 +0000
Message-ID: <1448650215-15218-11-git-send-email-marc.zyngier@arm.com>
References: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5D2A412D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2GkWb5kNA+xF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Nov 2015 13:49:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C33148535
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Nov 2015 13:49:35 -0500 (EST)
In-Reply-To: <1448650215-15218-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM so far relies on code patching, and is likely to use it more
in the future. The main issue is that our alternative system works
at the instruction level, while we'd like to have alternatives at
the function level.

In order to cope with this, add the "hyp_alternate_select" macro that
outputs a brief sequence of code that in turn can be patched, allowing
al alternative function to be selected.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 7ac8e11..f0427ee 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -27,6 +27,22 @@
 
 #define kern_hyp_va(v) (typeof(v))((unsigned long)v & HYP_PAGE_OFFSET_MASK)
 
+/*
+ * Generates patchable code sequences that are used to switch between
+ * two implementations of a function, depending on the availability of
+ * a feature.
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
