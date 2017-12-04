From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v6 8/8] KVM: arm/arm64: Avoid work when userspace iqchips are
 not used
Date: Mon,  4 Dec 2017 21:05:06 +0100
Message-ID: <20171204200506.3224-9-cdall@kernel.org>
References: <20171204200506.3224-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3597B49D72
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 15:02:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zbb1wnJ0Bdmr for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 15:02:13 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D970F49D93
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 15:02:12 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id f9so16571643wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 12:05:21 -0800 (PST)
In-Reply-To: <20171204200506.3224-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

We currently check if the VM has a userspace irqchip on every exit from
the VCPU, and if so, we do some work to ensure correct timer behavior.
This is unfortunate, as we could avoid doing any work entirely, if we
didn't have to support irqchip in userspace.

Realizing the userspace irqchip on ARM is mostly a developer or hobby
feature, and is unlikely to be used in servers or other scenarios where
performance is a priority, we can use a refcounted static key to only
check the irqchip configuration when we have at least one VM that uses
an irqchip in userspace.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 82d4963f63b8..df21451e7654 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -51,6 +51,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx);
 static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
 
+static DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
+
 u64 kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
@@ -569,7 +571,8 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
  */
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	unmask_vtimer_irq_user(vcpu);
+	if (static_branch_unlikely(&userspace_irqchip_in_use))
+		unmask_vtimer_irq_user(vcpu);
 }
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -774,6 +777,8 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 	soft_timer_cancel(&timer->bg_timer, &timer->expired);
 	soft_timer_cancel(&timer->phys_timer, NULL);
 	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
+	if (timer->enabled && !irqchip_in_kernel(vcpu->kvm))
+		static_branch_dec(&userspace_irqchip_in_use);
 }
 
 static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
@@ -826,8 +831,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return 0;
 
 	/* Without a VGIC we do not map virtual IRQs to physical IRQs */
-	if (!irqchip_in_kernel(vcpu->kvm))
+	if (!irqchip_in_kernel(vcpu->kvm)) {
+		static_branch_inc(&userspace_irqchip_in_use);
 		goto no_vgic;
+	}
 
 	if (!vgic_initialized(vcpu->kvm))
 		return -ENODEV;
-- 
2.14.2
