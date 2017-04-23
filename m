From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 79/79] ARM: KVM: Fix idmap stub entry when running Thumb-2 code
Date: Sun, 23 Apr 2017 19:09:29 +0200
Message-ID: <20170423170929.27334-80-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C052B49CB8
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bPPExCiGpBnO for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:08:15 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15F5049DCD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:08:10 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id w64so46382808wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:57 -0700 (PDT)
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

When entering the hyp stub implemented in the idmap, we try to
be mindful of the fact that we could be running a Thumb-2 kernel
by adding 1 to the address we compute. Unfortunately, the assembler
also knows about this trick, and has already generated an address
that has bit 0 set in the litteral pool.

Our superfluous correction ends up confusing the CPU entierely,
as we now branch to the stub in ARM mode instead of Thumb, and on
a possibly unaligned address for good measure. From that point,
nothing really good happens.

The obvious fix in to remove this stupid target PC correction.

Fixes: 6bebcecb6c5b ("ARM: KVM: Allow the main HYP code to use the init hyp stub implementation")
Reported-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/hyp/hyp-entry.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/kvm/hyp/hyp-entry.S b/arch/arm/kvm/hyp/hyp-entry.S
index a35baa8..95a2fae 100644
--- a/arch/arm/kvm/hyp/hyp-entry.S
+++ b/arch/arm/kvm/hyp/hyp-entry.S
@@ -144,7 +144,6 @@ hyp_hvc:
 	ldr	r1, [r1]
 	ldr	ip, =__kvm_handle_stub_hvc
 	sub	ip, ip, r1
-THUMB(	add	ip, ip, #1)
 	pop	{r1}
 
 	bx	ip
-- 
2.9.0
