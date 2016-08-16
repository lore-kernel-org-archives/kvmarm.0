From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: timer: Workaround misconfigured timer
 interrupt
Date: Tue, 16 Aug 2016 15:03:02 +0100
Message-ID: <1471356182-26034-2-git-send-email-marc.zyngier@arm.com>
References: <1471356182-26034-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E92CC48531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 09:55:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z2rhTzCF-PQ7 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 09:55:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFEA48529
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 09:55:42 -0400 (EDT)
In-Reply-To: <1471356182-26034-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Similarily to f005bd7e3b84 ("clocksource/arm_arch_timer: Force
per-CPU interrupt to be level-triggered"), make sure we can
survive an interrupt that has been misconfigured as edge-triggered
by forcing it to be level-triggered (active low is assumed, but
the GIC doesn't really care whether this is high or low).

Hopefully, the amount of shouting in the kernel log will convince
the user to do something about their firmware.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4fde8c7..77e6ccf 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -33,6 +33,7 @@
 static struct timecounter *timecounter;
 static struct workqueue_struct *wqueue;
 static unsigned int host_vtimer_irq;
+static u32 host_vtimer_irq_flags;
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
@@ -365,7 +366,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 
 static void kvm_timer_init_interrupt(void *info)
 {
-	enable_percpu_irq(host_vtimer_irq, 0);
+	enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
 }
 
 int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
@@ -432,6 +433,14 @@ int kvm_timer_hyp_init(void)
 	}
 	host_vtimer_irq = info->virtual_irq;
 
+	host_vtimer_irq_flags = irq_get_trigger_type(host_vtimer_irq);
+	if (host_vtimer_irq_flags != IRQF_TRIGGER_HIGH &&
+	    host_vtimer_irq_flags != IRQF_TRIGGER_LOW) {
+		kvm_err("Invalid trigger for IRQ%d, assuming level low\n",
+			host_vtimer_irq);
+		host_vtimer_irq_flags = IRQF_TRIGGER_LOW;
+	}
+
 	err = request_percpu_irq(host_vtimer_irq, kvm_arch_timer_handler,
 				 "kvm guest timer", kvm_get_running_vcpus());
 	if (err) {
-- 
2.1.4
