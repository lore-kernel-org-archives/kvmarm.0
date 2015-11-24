From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 4/8] KVM: arm/arm64: Fix preemptible timer active state
 crazyness
Date: Tue, 24 Nov 2015 18:35:32 +0100
Message-ID: <1448386536-30118-5-git-send-email-christoffer.dall@linaro.org>
References: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3EB41145
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 70BHwELP8Oo9 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 12:34:23 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 371E048912
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:22 -0500 (EST)
Received: by wmww144 with SMTP id w144so36430066wmw.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 09:35:20 -0800 (PST)
In-Reply-To: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We were setting the physical active state on the GIC distributor in a
preemptible section, which could cause us to set the active state on
different physical CPU from the one we were actually going to run on,
hacoc ensues.

Since we are no longer descheduling/scheduling soft timers in the
flush/sync timer functions, simply moving the timer flush into a
non-preemptible section.

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index eab83b2..e06fd29 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -564,17 +564,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			vcpu_sleep(vcpu);
 
 		/*
-		 * Disarming the background timer must be done in a
-		 * preemptible context, as this call may sleep.
-		 */
-		kvm_timer_flush_hwstate(vcpu);
-
-		/*
 		 * Preparing the interrupts to be injected also
 		 * involves poking the GIC, which must be done in a
 		 * non-preemptible context.
 		 */
 		preempt_disable();
+		kvm_timer_flush_hwstate(vcpu);
 		kvm_vgic_flush_hwstate(vcpu);
 
 		local_irq_disable();
-- 
2.1.2.330.g565301e.dirty
