From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: ARM: cleanup kvm_timer_hyp_init
Date: Thu,  8 Sep 2016 12:45:59 +0200
Message-ID: <1473331560-3103-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, "moderated list:KERNEL VIRTUAL
        MACHINE KVM FOR ARM" <linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE KVM
        FOR ARM" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Remove two unnecessary labels now that kvm_timer_hyp_init is not
creating its own workqueue anymore.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/arm/arch_timer.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4309b60ebf17..27a1f6341d41 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -445,7 +445,7 @@ int kvm_timer_hyp_init(void)
 	if (err) {
 		kvm_err("kvm_arch_timer: can't request interrupt %d (%d)\n",
 			host_vtimer_irq, err);
-		goto out;
+		return err;
 	}
 
 	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
@@ -453,10 +453,6 @@ int kvm_timer_hyp_init(void)
 	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
 			  "AP_KVM_ARM_TIMER_STARTING", kvm_timer_starting_cpu,
 			  kvm_timer_dying_cpu);
-	goto out;
-out_free:
-	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
-out:
 	return err;
 }
 
-- 
1.8.3.1
