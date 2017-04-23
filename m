From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 49/79] ARM: KVM: Convert KVM to use HVC_GET_VECTORS
Date: Sun, 23 Apr 2017 19:08:59 +0200
Message-ID: <20170423170929.27334-50-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65BF049D2A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8FztbK7iOcip for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:40 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6169849CED
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:37 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id m123so50340599wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:24 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The conversion of the HYP stub ABI to something similar to arm64
left the KVM code broken, as it doesn't know about the new
stub numbering. Let's move the various #defines to virt.h, and
let KVM use HVC_GET_VECTORS.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/virt.h  | 8 ++++++++
 arch/arm/kernel/hyp-stub.S   | 4 ----
 arch/arm/kvm/hyp/hyp-entry.S | 2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 6dae195..4ea16fc 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -94,6 +94,14 @@ extern char __hyp_text_start[];
 extern char __hyp_text_end[];
 #endif
 
+#else
+
+/* Only assembly code should need those */
+
+#define HVC_GET_VECTORS 0
+#define HVC_SET_VECTORS 1
+#define HVC_SOFT_RESTART 2
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* ! VIRT_H */
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 8291523..8301db9 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -22,10 +22,6 @@
 #include <asm/assembler.h>
 #include <asm/virt.h>
 
-#define HVC_GET_VECTORS 0
-#define HVC_SET_VECTORS 1
-#define HVC_SOFT_RESTART 2
-
 #ifndef ZIMAGE
 /*
  * For the kernel proper, we need to find out the CPU boot mode long after
diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index 96beb53..1f8db7d 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -127,7 +127,7 @@ hyp_hvc:
 	pop	{r0, r1, r2}
 
 	/* Check for __hyp_get_vectors */
-	cmp	r0, #-1
+	cmp	r0, #HVC_GET_VECTORS
 	mrceq	p15, 4, r0, c12, c0, 0	@ get HVBAR
 	beq	1f
 
-- 
2.9.0
