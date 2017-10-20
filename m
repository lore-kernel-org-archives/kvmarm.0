From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 13/20] KVM: arm/arm64: Set VCPU affinity for virt timer irq
Date: Fri, 20 Oct 2017 13:49:32 +0200
Message-ID: <20171020114939.12554-14-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14BA84078A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:48:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I9U9sgzzID3l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:48:55 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2AA7749D4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:48:55 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id m72so335143wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 04:50:01 -0700 (PDT)
In-Reply-To: <20171020114939.12554-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, Shih-Wei Li <shihwei@cs.columbia.edu>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

As we are about to take physical interrupts for the virtual timer on the
host but want to leave those active while running the VM (and let the VM
deactivate them), we need to set the vtimer PPI affinity accordingly.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 93c8973a71f4..eac1b3d83a86 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -649,11 +649,20 @@ int kvm_timer_hyp_init(void)
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
2.14.2
