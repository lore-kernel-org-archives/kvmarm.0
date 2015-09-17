From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 6/8] arm: KVM: Disable virtual timer even if the guest is not
 using it
Date: Thu, 17 Sep 2015 15:46:09 +0100
Message-ID: <1442501171-24484-7-git-send-email-marc.zyngier@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F270E487C5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 10:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oAHRV3jVBI1T for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2015 10:45:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9792742E58
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 10:45:34 -0400 (EDT)
In-Reply-To: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: kvm@vger.kernel.org, Marek Majtyka <marek.majtyka@tieto.com>, Will Deacon <will.deacon@arm.com>, Ming Lei <ming.lei@canonical.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When running a guest with the architected timer disabled (with QEMU and
the kernel_irqchip=off option, for example), it is important to make
sure the timer gets turned off. Otherwise, the guest may try to
enable it anyway, leading to a screaming HW interrupt.

The fix is to unconditionally turn off the virtual timer on guest
exit.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/interrupts_head.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 702740d..51a5950 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -515,8 +515,7 @@ ARM_BE8(rev	r6, r6  )
 
 	mrc	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
 	str	r2, [vcpu, #VCPU_TIMER_CNTV_CTL]
-	bic	r2, #1			@ Clear ENABLE
-	mcr	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
+
 	isb
 
 	mrrc	p15, 3, rr_lo_hi(r2, r3), c14	@ CNTV_CVAL
@@ -529,6 +528,9 @@ ARM_BE8(rev	r6, r6  )
 	mcrr	p15, 4, r2, r2, c14	@ CNTVOFF
 
 1:
+	mov	r2, #0			@ Clear ENABLE
+	mcr	p15, 0, r2, c14, c3, 1	@ CNTV_CTL
+
 	@ Allow physical timer/counter access for the host
 	mrc	p15, 4, r2, c14, c1, 0	@ CNTHCTL
 	orr	r2, r2, #(CNTHCTL_PL1PCEN | CNTHCTL_PL1PCTEN)
-- 
2.1.4
