From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v4 20/20] KVM: arm/arm64: Rework kvm_timer_should_fire
Date: Fri, 20 Oct 2017 13:49:39 +0200
Message-ID: <20171020114939.12554-21-christoffer.dall@linaro.org>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06BB849D23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:49:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VCNf4snmx5Lr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Oct 2017 07:49:06 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A8C3449D1C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 07:49:05 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id p75so2269169wmg.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Oct 2017 04:50:11 -0700 (PDT)
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

kvm_timer_should_fire() can be called in two different situations from
the kvm_vcpu_block().

The first case is before calling kvm_timer_schedule(), used for wait
polling, and in this case the VCPU thread is running and the timer state
is loaded onto the hardware so all we have to do is check if the virtual
interrupt lines are asserted, becasue the timer interrupt handler
functions will raise those lines as appropriate.

The second case is inside the wait loop of kvm_vcpu_block(), where we
have already called kvm_timer_schedule() and therefore the hardware will
be disabled and the software view of the timer state is up to date
(timer->loaded is false), and so we can simply check if the timer should
fire by looking at the software state.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h |  3 ++-
 virt/kvm/arm/arch_timer.c    | 22 +++++++++++++++++++++-
 virt/kvm/arm/arm.c           |  3 +--
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 2352f3a4e88b..01ee473517e2 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -78,7 +78,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
 
-bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
+bool kvm_timer_is_pending(struct kvm_vcpu *vcpu);
+
 void kvm_timer_schedule(struct kvm_vcpu *vcpu);
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 53d9bd4a734f..2035cf251701 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -49,6 +49,7 @@ static const struct kvm_irq_level default_vtimer_irq = {
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx);
+static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
 
 u64 kvm_phys_timer_read(void)
 {
@@ -226,7 +227,7 @@ static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
-bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
+static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
 
@@ -239,6 +240,25 @@ bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 	return cval <= now;
 }
 
+bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+
+	if (vtimer->irq.level || ptimer->irq.level)
+		return true;
+
+	/*
+	 * When this is called from withing the wait loop of kvm_vcpu_block(),
+	 * the software view of the timer state is up to date (timer->loaded
+	 * is false), and so we can simply check if the timer should fire now.
+	 */
+	if (!vtimer->loaded && kvm_timer_should_fire(vtimer))
+		return true;
+
+	return kvm_timer_should_fire(ptimer);
+}
+
 /*
  * Reflect the timer output level into the kvm_run structure
  */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 14c50d142c67..bc126fb99a3d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -307,8 +307,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_timer_should_fire(vcpu_vtimer(vcpu)) ||
-	       kvm_timer_should_fire(vcpu_ptimer(vcpu));
+	return kvm_timer_is_pending(vcpu);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
-- 
2.14.2
