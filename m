From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 43/50] ARM: Introduce MPIDR_LEVEL_SHIFT macro
Date: Tue, 27 Sep 2016 20:05:51 +0200
Message-ID: <20160927180558.14699-44-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8205549BC7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pFiLC1KKcBkW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:10 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F10E749BD1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:06 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id b130so27083978wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:30 -0700 (PDT)
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Russell King <rmk+kernel@armlinux.org.uk>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

vgic-v3 driver uses architecture specific MPIDR_LEVEL_SHIFT macro to
encode the affinity in a form compatible with ICC_SGI* registers.
Unfortunately, that macro is missing on ARM, so let's add it.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/cputype.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index 1ee94c7..e2d94c1 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -55,6 +55,7 @@
 
 #define MPIDR_LEVEL_BITS 8
 #define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
+#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
 
 #define MPIDR_AFFINITY_LEVEL(mpidr, level) \
 	((mpidr >> (MPIDR_LEVEL_BITS * level)) & MPIDR_LEVEL_MASK)
-- 
2.9.0
