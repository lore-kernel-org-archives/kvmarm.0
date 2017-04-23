From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 53/79] ARM: hyp-stub: Define a return value for failed stub
 calls
Date: Sun, 23 Apr 2017 19:09:03 +0200
Message-ID: <20170423170929.27334-54-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E418C49C8F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oFx8kRhqGSnW for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:42 -0400 (EDT)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2907249D0D
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:41 -0400 (EDT)
Received: by mail-wr0-f174.google.com with SMTP id z109so79245736wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:28 -0700 (PDT)
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

Define a standard return value to be returned when a hyp stub
call fails.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/virt.h | 2 ++
 arch/arm/kernel/hyp-stub.S  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 4ea16fc..c16f70d 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -104,4 +104,6 @@ extern char __hyp_text_end[];
 
 #endif /* __ASSEMBLY__ */
 
+#define HVC_STUB_ERR	0xbadca11
+
 #endif /* ! VIRT_H */
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 15eaa14..b20ca88 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -216,7 +216,7 @@ __hyp_stub_do_trap:
 	bne	1f
 	bx	r1
 
-1:	mov	r0, #-1
+1:	ldr	r0, =HVC_STUB_ERR
 
 __hyp_stub_exit:
 	__ERET
-- 
2.9.0
