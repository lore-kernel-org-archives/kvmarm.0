From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 10/12] KVM: arm/arm64: timer: Workaround misconfigured timer interrupt
Date: Wed, 17 Aug 2016 21:38:57 +0200
Message-ID: <20160817193859.15726-11-christoffer.dall@linaro.org>
References: <20160817193859.15726-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160817193859.15726-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

Similarily to f005bd7e3b84 ("clocksource/arm_arch_timer: Force
per-CPU interrupt to be level-triggered"), make sure we can
survive an interrupt that has been misconfigured as edge-triggered
by forcing it to be level-triggered (active low is assumed, but
the GIC doesn't really care whether this is high or low).

Hopefully, the amount of shouting in the kernel log will convince
the user to do something about their firmware.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
2.9.0

