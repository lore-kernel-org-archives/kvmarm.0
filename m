From: Anna-Maria Gleixner <anna-maria@linutronix.de>
Subject: [patch V2 45/67] arm/kvm/arch_timer: Convert to hotplug state machine
Date: Wed, 13 Jul 2016 17:16:47 -0000
Message-ID: <20160713153336.634155707@linutronix.de>
References: <20160713153219.128052238@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7DFE49B2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 13:13:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jmf3DF89ifT4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jul 2016 13:13:33 -0400 (EDT)
Received: from Galois.linutronix.de (www.linutronix.de [62.245.132.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6185549B1A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jul 2016 13:13:33 -0400 (EDT)
Content-Disposition: inline;
 filename=0044-arm-kvm-arch_timer-Convert-to-hotplug-state-machine.patch
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Richard Cochran <rcochran@linutronix.de>, kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, kvmarm@lists.cs.columbia.edu, Gleb Natapov <gleb@kernel.org>, rt@linutronix.de, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Richard Cochran <rcochran@linutronix.de>

Install the callbacks via the state machine and let the core invoke
the callbacks on the already online CPUs.

Signed-off-by: Richard Cochran <rcochran@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Radim Krcmar <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
---
 include/linux/cpuhotplug.h |  1 +
 virt/kvm/arm/arch_timer.c  | 35 +++++++++++------------------------
 2 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 80c15ce..0a36e61 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -44,6 +44,7 @@ enum cpuhp_state {
 	CPUHP_AP_MIPS_GIC_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_STARTING,
+	CPUHP_AP_KVM_ARM_TIMER_STARTING,
 	CPUHP_AP_LEDTRIG_STARTING,
 	CPUHP_AP_NOTIFY_STARTING,
 	CPUHP_AP_ONLINE,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index e2d5b6f..4fde8c7 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -405,26 +405,17 @@ u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
 	return (u64)-1;
 }
 
-static int kvm_timer_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *cpu)
+static int kvm_timer_starting_cpu(unsigned int cpu)
 {
-	switch (action) {
-	case CPU_STARTING:
-	case CPU_STARTING_FROZEN:
-		kvm_timer_init_interrupt(NULL);
-		break;
-	case CPU_DYING:
-	case CPU_DYING_FROZEN:
-		disable_percpu_irq(host_vtimer_irq);
-		break;
-	}
-
-	return NOTIFY_OK;
+	kvm_timer_init_interrupt(NULL);
+	return 0;
 }
 
-static struct notifier_block kvm_timer_cpu_nb = {
-	.notifier_call = kvm_timer_cpu_notify,
-};
+static int kvm_timer_dying_cpu(unsigned int cpu)
+{
+	disable_percpu_irq(host_vtimer_irq);
+	return 0;
+}
 
 int kvm_timer_hyp_init(void)
 {
@@ -449,12 +440,6 @@ int kvm_timer_hyp_init(void)
 		goto out;
 	}
 
-	err = __register_cpu_notifier(&kvm_timer_cpu_nb);
-	if (err) {
-		kvm_err("Cannot register timer CPU notifier\n");
-		goto out_free;
-	}
-
 	wqueue = create_singlethread_workqueue("kvm_arch_timer");
 	if (!wqueue) {
 		err = -ENOMEM;
@@ -462,8 +447,10 @@ int kvm_timer_hyp_init(void)
 	}
 
 	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
-	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
 
+	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
+			  "AP_KVM_ARM_TIMER_STARTING", kvm_timer_starting_cpu,
+			  kvm_timer_dying_cpu);
 	goto out;
 out_free:
 	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
-- 
2.8.1
