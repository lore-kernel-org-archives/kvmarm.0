From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 78/79] ARM: hyp-stub: Fix Thumb-2 compilation
Date: Sun, 23 Apr 2017 19:09:28 +0200
Message-ID: <20170423170929.27334-79-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9D449CA3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c75EnZpTOVxS for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:08:14 -0400 (EDT)
Received: from mail-wm0-f53.google.com (mail-wm0-f53.google.com [74.125.82.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87FCE49DC7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:09 -0400 (EDT)
Received: by mail-wm0-f53.google.com with SMTP id w64so46382648wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:56 -0700 (PDT)
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

The assembler defaults to emiting the short form of ADR, leading
to an out-of-range immediate. Using the wide version solves this
issue.

Fixes: bc845e4fbbbb ("ARM: KVM: Implement HVC_RESET_VECTORS stub hypercall in the init code")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kernel/hyp-stub.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index d8523cc..ec7e737 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -125,7 +125,7 @@ ENTRY(__hyp_stub_install_secondary)
  * (see safe_svcmode_maskall).
  */
 	@ Now install the hypervisor stub:
-	adr	r7, __hyp_stub_vectors
+	W(adr)	r7, __hyp_stub_vectors
 	mcr	p15, 4, r7, c12, c0, 0	@ set hypervisor vector base (HVBAR)
 
 	@ Disable all traps, so we don't get any nasty surprise
-- 
2.9.0
