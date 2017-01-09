From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2] KVM: arm/arm64: Fix occasional warning from the timer work
 function
Date: Mon,  9 Jan 2017 12:18:56 +0100
Message-ID: <20170109111856.8439-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECEEC406BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 06:17:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 00x+bRtJkbwr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 06:17:21 -0500 (EST)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE2864066D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 06:17:20 -0500 (EST)
Received: by mail-lf0-f51.google.com with SMTP id o140so37387372lff.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Jan 2017 03:19:02 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, mbrugger@suse.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When a VCPU blocks (WFI) and has programmed the vtimer, we program a
soft timer to expire in the future to wake up the vcpu thread when
appropriate.  Because such as wake up involves a vcpu kick, and the
timer expire function can get called from interrupt context, and the
kick may sleep, we have to schedule the kick in the work function.

The work function currently has a warning that gets raised if it turns
out that the timer shouldn't fire when it's run, which was added because
the idea was that in that case the work should never have been cancelled.

However, it turns out that this whole thing is racy and we can get
spurious warnings.  The problem is that we clear the armed flag in the
work function, which may run in parallel with the
kvm_timer_unschedule->timer_disarm() call.  This results in a possible
situation where the timer_disarm() call does not call
cancel_work_sync(), which effectively synchronizes the completion of the
work function with running the VCPU.  As a result, the VCPU thread
proceeds before the work function completees, causing changes to the
timer state such that kvm_timer_should_fire(vcpu) returns false in the
work function.

All we do in the work function is to kick the VCPU, and an occasional
rare extra kick never harmed anyone.  Since the race above is extremely
rare, we don't bother checking if the race happens but simply remove the
check and the clearing of the armed flag from the work function.

Reported-by: Matthias Brugger <mbrugger@suse.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changes since v1:
 - Don't add a second call to cancel_work_sync, but avoid clearing
   the armed flag to let the timer_disarm() function call
   cancel_work_sync on every unschedule call.
 - Note that I chose to remove the warning, despite it shouldn't really
   happen anymore, because I don't see the value in the warning and
   it does a bit of potentially unnecessary checking in a potentially
   hot path.

 virt/kvm/arm/arch_timer.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index a2dbbcc..a7fe606 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -89,9 +89,6 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
 	struct kvm_vcpu *vcpu;
 
 	vcpu = container_of(work, struct kvm_vcpu, arch.timer_cpu.expired);
-	vcpu->arch.timer_cpu.armed = false;
-
-	WARN_ON(!kvm_timer_should_fire(vcpu));
 
 	/*
 	 * If the vcpu is blocked we want to wake it up so that it will see
-- 
2.9.0
