From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL v2 6/6] arm: KVM: Allow unaligned accesses at HYP
Date: Wed,  7 Jun 2017 19:11:52 +0200
Message-ID: <20170607171152.21874-7-cdall@linaro.org>
References: <20170607171152.21874-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6192E40C4A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 13:08:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yp-Nd88oYb5V for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Jun 2017 13:08:07 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA8E340CD1
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Jun 2017 13:08:04 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id d73so15626966wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 07 Jun 2017 10:12:12 -0700 (PDT)
In-Reply-To: <20170607171152.21874-1-cdall@linaro.org>
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
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We currently have the HSCTLR.A bit set, trapping unaligned accesses
at HYP, but we're not really prepared to deal with it.

Since the rest of the kernel is pretty happy about that, let's follow
its example and set HSCTLR.A to zero. Modern CPUs don't really care.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/init.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 570ed4a..5386528 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -104,7 +104,6 @@ __do_hyp_init:
 	@  - Write permission implies XN: disabled
 	@  - Instruction cache: enabled
 	@  - Data/Unified cache: enabled
-	@  - Memory alignment checks: enabled
 	@  - MMU: enabled (this code must be run from an identity mapping)
 	mrc	p15, 4, r0, c1, c0, 0	@ HSCR
 	ldr	r2, =HSCTLR_MASK
@@ -112,8 +111,8 @@ __do_hyp_init:
 	mrc	p15, 0, r1, c1, c0, 0	@ SCTLR
 	ldr	r2, =(HSCTLR_EE | HSCTLR_FI | HSCTLR_I | HSCTLR_C)
 	and	r1, r1, r2
- ARM(	ldr	r2, =(HSCTLR_M | HSCTLR_A)			)
- THUMB(	ldr	r2, =(HSCTLR_M | HSCTLR_A | HSCTLR_TE)		)
+ ARM(	ldr	r2, =(HSCTLR_M)					)
+ THUMB(	ldr	r2, =(HSCTLR_M | HSCTLR_TE)			)
 	orr	r1, r1, r2
 	orr	r0, r0, r1
 	mcr	p15, 4, r0, c1, c0, 0	@ HSCR
-- 
2.9.0
