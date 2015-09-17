From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/8] arm64: KVM: Disable virtual timer even if the guest is
 not using it
Date: Thu, 17 Sep 2015 15:46:08 +0100
Message-ID: <1442501171-24484-6-git-send-email-marc.zyngier@arm.com>
References: <1442501171-24484-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5309D487FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 10:45:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1de41ln1qulr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Sep 2015 10:45:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 068204880E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Sep 2015 10:45:32 -0400 (EDT)
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
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 39aa322..60a83e2 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -562,8 +562,6 @@
 	mrs	x3, cntv_ctl_el0
 	and	x3, x3, #3
 	str	w3, [x0, #VCPU_TIMER_CNTV_CTL]
-	bic	x3, x3, #1		// Clear Enable
-	msr	cntv_ctl_el0, x3
 
 	isb
 
@@ -571,6 +569,9 @@
 	str	x3, [x0, #VCPU_TIMER_CNTV_CVAL]
 
 1:
+	// Disable the virtual timer
+	msr	cntv_ctl_el0, xzr
+
 	// Allow physical timer/counter access for the host
 	mrs	x2, cnthctl_el2
 	orr	x2, x2, #3
-- 
2.1.4
