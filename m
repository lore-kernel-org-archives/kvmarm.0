From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 13/20] KVM: arm/arm64: Set VCPU affinity for virt timer irq
Date: Sat, 23 Sep 2017 02:42:00 +0200
Message-ID: <20170923004207.22356-14-cdall@linaro.org>
References: <20170923004207.22356-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEA5149C69
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DkMItCm1WRNg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Sep 2017 20:42:13 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 297D649C73
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:13 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id m127so7644273wmm.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 17:42:24 -0700 (PDT)
In-Reply-To: <20170923004207.22356-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

As we are about to take physical interrupts for the virtual timer on the
host but want to leave those active while running the VM (and let the VM
deactivate them), we need to set the vtimer PPI affinity accordingly.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4254f88..4275f8f 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -650,11 +650,20 @@ int kvm_timer_hyp_init(void)
 		return err;
 	}
 
+	err = irq_set_vcpu_affinity(host_vtimer_irq, kvm_get_running_vcpus());
+	if (err) {
+		kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
+		goto out_free_irq;
+	}
+
 	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
 
 	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
 			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
 			  kvm_timer_dying_cpu);
+	return 0;
+out_free_irq:
+	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
 	return err;
 }
 
-- 
2.9.0
