From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 68/79] ARM: hyp-stub: Zero r0 on successful stub handling
Date: Sun, 23 Apr 2017 19:09:18 +0200
Message-ID: <20170423170929.27334-69-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E5349C34
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TBqrGTwbuez0 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:08:00 -0400 (EDT)
Received: from mail-wr0-f177.google.com (mail-wr0-f177.google.com
 [209.85.128.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B1A340064
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:58 -0400 (EDT)
Received: by mail-wr0-f177.google.com with SMTP id z109so79247972wrb.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:45 -0700 (PDT)
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

We now return HVC_STUB_ERR when a stub hypercall fails, but we
leave whatever was in r0 on success. Zeroing it on return seems
like a good idea.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kernel/hyp-stub.S | 2 ++
 arch/arm/kvm/init.S        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 918c64f..d8523cc 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -215,8 +215,10 @@ __hyp_stub_do_trap:
 	beq	__hyp_stub_exit
 
 	ldr	r0, =HVC_STUB_ERR
+	__ERET
 
 __hyp_stub_exit:
+	mov	r0, #0
 	__ERET
 ENDPROC(__hyp_stub_do_trap)
 
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 87bcd7a..570ed4a 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -155,8 +155,10 @@ reset:
 	b	exit
 
 1:	ldr	r0, =HVC_STUB_ERR
+	eret
 
 exit:
+	mov	r0, #0
 	eret
 ENDPROC(__kvm_handle_stub_hvc)
 
-- 
2.9.0
