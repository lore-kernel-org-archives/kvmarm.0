From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] KVM: arm/arm64: arch_timer: remove unused error handling
Date: Thu,  8 Sep 2016 15:58:44 +0200
Message-ID: <20160908135908.1312349-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA1B9407A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 09:50:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qxl1H7viFcXn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2016 09:50:14 -0400 (EDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E5BF400E9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 09:50:13 -0400 (EDT)
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
Cc: kvm@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Eric Auger <eric.auger@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

A cleanup removed the call to create_singlethread_workqueue(), but did not
remove the code that was used in case it failed:

virt/kvm/arm/arch_timer.c: In function 'kvm_timer_hyp_init':
virt/kvm/arm/arch_timer.c:457:1: error: label 'out_free' defined but not used [-Werror=unused-label]

This removes the now dead code too.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 3706feacd007 ("KVM: Remove deprecated create_singlethread_workqueue")
---
 virt/kvm/arm/arch_timer.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4309b60ebf17..46980a49a3bb 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -453,9 +453,6 @@ int kvm_timer_hyp_init(void)
 	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
 			  "AP_KVM_ARM_TIMER_STARTING", kvm_timer_starting_cpu,
 			  kvm_timer_dying_cpu);
-	goto out;
-out_free:
-	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
 out:
 	return err;
 }
-- 
2.9.0
