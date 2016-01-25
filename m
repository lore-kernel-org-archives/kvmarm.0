From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 18/21] arm64: KVM: Introduce hyp_alternate_value helper
Date: Mon, 25 Jan 2016 15:53:52 +0000
Message-ID: <1453737235-16522-19-git-send-email-marc.zyngier@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7AFF40FA6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 10:49:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GnQ7ukeTEiW9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2016 10:49:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5372848529
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 10:49:50 -0500 (EST)
In-Reply-To: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
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

We already have hyp_alternate_select() to define a function pointer
that gets changed by a kernel feature or workaround.

It would be useful to have a similar feature that resolves in a
direct value, without requiring a function call. For this purpose,
introduce hyp_alternate_value(), which returns one of two values
depending on the state of the alternative.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/hyp.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
index 44eaff7..dc75fdb 100644
--- a/arch/arm64/kvm/hyp/hyp.h
+++ b/arch/arm64/kvm/hyp/hyp.h
@@ -144,6 +144,17 @@ typeof(orig) * __hyp_text fname(void)					\
 	return val;							\
 }
 
+#define hyp_alternate_value(fname, orig, alt, cond)			\
+typeof(orig) __hyp_text fname(void)					\
+{									\
+	typeof(alt) val = orig;						\
+	asm volatile(ALTERNATIVE("nop		\n",			\
+				 "mov	%0, %1	\n",			\
+				 cond)					\
+		     : "+r" (val) : "r" ((typeof(orig))alt));		\
+	return val;							\
+}
+
 void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
 
-- 
2.1.4
