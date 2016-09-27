From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 36/50] KVM: ARM: cleanup kvm_timer_hyp_init
Date: Tue, 27 Sep 2016 20:05:44 +0200
Message-ID: <20160927180558.14699-37-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01EBB49BDA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F7k06AryJ4dM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:02 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0695F49BB7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:56:59 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id l132so190655821wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:22 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Paolo Bonzini <pbonzini@redhat.com>

Remove two unnecessary labels now that kvm_timer_hyp_init is not
creating its own workqueue anymore.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4309b60..27a1f63 100644
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
2.9.0
