From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 43/79] arm64: KVM: Implement HVC_GET_VECTORS in the init code
Date: Sun, 23 Apr 2017 19:08:53 +0200
Message-ID: <20170423170929.27334-44-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F00549C67
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XihirhQLgNR6 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:33 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFF5D49CA0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:30 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id r190so50452445wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:17 -0700 (PDT)
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

Now that we have an infrastructure to handle hypercalls in the KVM
init code, let's implement HVC_GET_VECTORS there.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm64/kvm/hyp-init.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 5e39ad5..fded932 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -124,7 +124,12 @@ __do_hyp_init:
 ENDPROC(__kvm_hyp_init)
 
 ENTRY(__kvm_handle_stub_hvc)
-	cmp	x0, #HVC_RESET_VECTORS
+	cmp	x0, #HVC_GET_VECTORS
+	b.ne	1f
+	mrs	x0, vbar_el2
+	b	exit
+
+1:	cmp	x0, #HVC_RESET_VECTORS
 	b.ne	1f
 	/*
 	 * Reset kvm back to the hyp stub.
-- 
2.9.0
