From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 48/50] ARM: gic-v3: Work around definition of gic_write_bpr1
Date: Tue, 27 Sep 2016 20:05:56 +0200
Message-ID: <20160927180558.14699-49-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 10F2D49B77
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xW+wO6DORaJz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:14 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B17A249B83
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:12 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id l132so190667003wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:36 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

A new accessor for gic_write_bpr1 is added to arch_gicv3.h in 4.9,
whilst the CP15 accessors are redifined in a separate branch.
This leads to a horrible clash, where the new accessor ends up with
a crap "asm volatile" definition.

Work around this by carrying our own definition of gic_write_bpr1,
creating a small conflict which will be obvious to resolve.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/arch_gicv3.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/arch_gicv3.h b/arch/arm/include/asm/arch_gicv3.h
index 996848e..1fee657 100644
--- a/arch/arm/include/asm/arch_gicv3.h
+++ b/arch/arm/include/asm/arch_gicv3.h
@@ -216,6 +216,15 @@ static inline void gic_write_sre(u32 val)
 	isb();
 }
 
+static inline void gic_write_bpr1(u32 val)
+{
+#if defined(__write_sysreg) && defined(ICC_BPR1)
+	write_sysreg(val, ICC_BPR1);
+#else
+	asm volatile("mcr " __stringify(ICC_BPR1) : : "r" (val));
+#endif
+}
+
 /*
  * Even in 32bit systems that use LPAE, there is no guarantee that the I/O
  * interface provides true 64bit atomic accesses, so using strd/ldrd doesn't
-- 
2.9.0
