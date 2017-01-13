From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/3] KVM: arm/arm64: Fix occasional warning from the timer
 work function
Date: Fri, 13 Jan 2017 11:31:31 +0000
Message-ID: <1484307093-29153-2-git-send-email-marc.zyngier@arm.com>
References: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EECA540693
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 06:30:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fOUWIiylWx3g for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Jan 2017 06:30:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6481402EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Jan 2017 06:30:13 -0500 (EST)
In-Reply-To: <1484307093-29153-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

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
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
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
2.1.4
