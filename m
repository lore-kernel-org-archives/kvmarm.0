From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 07/27] ARM: KVM: Add system register accessor macros
Date: Mon, 25 Jan 2016 16:38:23 +0000
Message-ID: <1453739923-17846-8-git-send-email-marc.zyngier@arm.com>
References: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93FCB413E1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:34:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9h1kcvvX6xiD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2016 11:34:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4156A412A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:34:06 -0500 (EST)
In-Reply-To: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to move system register (CP15, mostly) access to C code,
add a few macros to facilitate this, and minimize the difference
between 32 and 64bit CP15 registers.

This will get heavily used in the following patches.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/hyp.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/kvm/hyp/hyp.h b/arch/arm/kvm/hyp/hyp.h
index c723870..727089f 100644
--- a/arch/arm/kvm/hyp/hyp.h
+++ b/arch/arm/kvm/hyp/hyp.h
@@ -27,4 +27,19 @@
 #define kern_hyp_va(v) (v)
 #define hyp_kern_va(v) (v)
 
+#define __ACCESS_CP15(CRn, Op1, CRm, Op2)	\
+	"mrc", "mcr", __stringify(p15, Op1, %0, CRn, CRm, Op2), u32
+#define __ACCESS_CP15_64(Op1, CRm)		\
+	"mrrc", "mcrr", __stringify(p15, Op1, %Q0, %R0, CRm), u64
+
+#define __write_sysreg(v, r, w, c, t)	asm volatile(w " " c : : "r" ((t)(v)))
+#define write_sysreg(v, ...)		__write_sysreg(v, __VA_ARGS__)
+
+#define __read_sysreg(r, w, c, t) ({				\
+	t __val;						\
+	asm volatile(r " " c : "=r" (__val));			\
+	__val;							\
+})
+#define read_sysreg(...)		__read_sysreg(__VA_ARGS__)
+
 #endif /* __ARM_KVM_HYP_H__ */
-- 
2.1.4
