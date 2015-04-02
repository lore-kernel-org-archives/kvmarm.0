From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/27] arm/arm64: KVM: Fix migration race in the arch timer
Date: Thu,  2 Apr 2015 11:05:19 +0100
Message-ID: <1427969131-8445-16-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Eric Auger <eric.auger@linaro.org>, Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Christoffer Dall <christoffer.dall@linaro.org>

When a VCPU is no longer running, we currently check to see if it has a
timer scheduled in the future, and if it does, we schedule a host
hrtimer to notify is in case the timer expires while the VCPU is still
not running.  When the hrtimer fires, we mask the guest's timer and
inject the timer IRQ (still relying on the guest unmasking the time whe=
n
it receives the IRQ).

This is all good and fine, but when migration a VM (checkpoint/restore)
this introduces a race.  It is unlikely, but possible, for the followin=
g
sequence of events to happen:

 1. Userspace stops the VM
 2. Hrtimer for VCPU is scheduled
 3. Userspace checkpoints the VGIC state (no pending timer interrupts)
 4. The hrtimer fires, schedules work in a workqueue
 5. Workqueue function runs, masks the timer and injects timer interrup=
t
 6. Userspace checkpoints the timer state (timer masked)

At restore time, you end up with a masked timer without any timer
interrupts and your guest halts never receiving timer interrupts.

=46ix this by only kicking the VCPU in the workqueue function, and samp=
le
the expired state of the timer when entering the guest again and inject
the interrupt and mask the timer only then.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c           |  2 +-
 include/kvm/arm_arch_timer.h |  2 ++
 virt/kvm/arm/arch_timer.c    | 45 +++++++++++++++++++++++++++++++++++-=
--------
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9a5f057..e98370c 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -266,7 +266,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return 0;
+	return kvm_timer_should_fire(vcpu);
 }
=20
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.=
h
index a74e4c2..e596675 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -67,4 +67,6 @@ void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
 int kvm_arm_timer_set_reg(struct kvm_vcpu *, u64 regid, u64 value);
=20
+bool kvm_timer_should_fire(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 6e54f35..98c95f2 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -85,13 +85,22 @@ static irqreturn_t kvm_arch_timer_handler(int irq, =
void *dev_id)
 	return IRQ_HANDLED;
 }
=20
+/*
+ * Work function for handling the backup timer that we schedule when a=
 vcpu is
+ * no longer running, but had a timer programmed to fire in the future=
=2E
+ */
 static void kvm_timer_inject_irq_work(struct work_struct *work)
 {
 	struct kvm_vcpu *vcpu;
=20
 	vcpu =3D container_of(work, struct kvm_vcpu, arch.timer_cpu.expired);
 	vcpu->arch.timer_cpu.armed =3D false;
-	kvm_timer_inject_irq(vcpu);
+
+	/*
+	 * If the vcpu is blocked we want to wake it up so that it will see
+	 * the timer has expired when entering the guest.
+	 */
+	kvm_vcpu_kick(vcpu);
 }
=20
 static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
@@ -102,6 +111,21 @@ static enum hrtimer_restart kvm_timer_expire(struc=
t hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
=20
+bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer =3D &vcpu->arch.timer_cpu;
+	cycle_t cval, now;
+
+	if ((timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) ||
+		!(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE))
+		return false;
+
+	cval =3D timer->cntv_cval;
+	now =3D kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
+
+	return cval <=3D now;
+}
+
 /**
  * kvm_timer_flush_hwstate - prepare to move the virt timer to the cpu
  * @vcpu: The vcpu pointer
@@ -119,6 +143,13 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu=
)
 	 * populate the CPU timer again.
 	 */
 	timer_disarm(timer);
+
+	/*
+	 * If the timer expired while we were not scheduled, now is the time
+	 * to inject it.
+	 */
+	if (kvm_timer_should_fire(vcpu))
+		kvm_timer_inject_irq(vcpu);
 }
=20
 /**
@@ -134,16 +165,9 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	cycle_t cval, now;
 	u64 ns;
=20
-	if ((timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) ||
-		!(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE))
-		return;
-
-	cval =3D timer->cntv_cval;
-	now =3D kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
-
 	BUG_ON(timer_is_armed(timer));
=20
-	if (cval <=3D now) {
+	if (kvm_timer_should_fire(vcpu)) {
 		/*
 		 * Timer has already expired while we were not
 		 * looking. Inject the interrupt and carry on.
@@ -152,6 +176,9 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
+	cval =3D timer->cntv_cval;
+	now =3D kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
+
 	ns =3D cyclecounter_cyc2ns(timecounter->cc, cval - now, timecounter->=
mask,
 				 &timecounter->frac);
 	timer_arm(timer, ns);
--=20
2.1.4

