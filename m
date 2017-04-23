From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 67/79] arm64: hyp-stub: Zero x0 on successful stub handling
Date: Sun, 23 Apr 2017 19:09:17 +0200
Message-ID: <20170423170929.27334-68-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40DA149D65
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zaLqh-rSXxvB for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:59 -0400 (EDT)
Received: from mail-wr0-f174.google.com (mail-wr0-f174.google.com
 [209.85.128.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FC9F49C34
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:57 -0400 (EDT)
Received: by mail-wr0-f174.google.com with SMTP id w50so55838696wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:44 -0700 (PDT)
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
leave whatever was in x0 on success. Zeroing it on return seems
like a good idea.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kernel/hyp-stub.S | 4 +++-
 arch/arm64/kvm/hyp-init.S    | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
index d55604d..e1261fb 100644
--- a/arch/arm64/kernel/hyp-stub.S
+++ b/arch/arm64/kernel/hyp-stub.S
@@ -73,8 +73,10 @@ el1_sync:
 
 	/* Someone called kvm_call_hyp() against the hyp-stub... */
 	ldr	x0, =HVC_STUB_ERR
+	eret
 
-9:	eret
+9:	mov	x0, xzr
+	eret
 ENDPROC(el1_sync)
 
 .macro invalid_vector	label
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3734e63..839425c 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -154,13 +154,13 @@ reset:
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-	b	exit
+	mov	x0, xzr
+	eret
 
 1:	/* Bad stub call */
 	ldr	x0, =HVC_STUB_ERR
-
-exit:
 	eret
+
 ENDPROC(__kvm_handle_stub_hvc)
 
 	.ltorg
-- 
2.9.0
