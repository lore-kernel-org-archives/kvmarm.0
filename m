From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v3 01/41] KVM: arm/arm64: Avoid vcpu_load for other vcpu ioctls than KVM_RUN
Date: Fri, 12 Jan 2018 13:07:07 +0100
Message-ID: <20180112120747.27999-2-christoffer.dall@linaro.org>
References: <20180112120747.27999-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180112120747.27999-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Calling vcpu_load() registers preempt notifiers for this vcpu and calls
kvm_arch_vcpu_load().  The latter will soon be doing a lot of heavy
lifting on arm/arm64 and will try to do things such as enabling the
virtual timer and setting us up to handle interrupts from the timer
hardware.

Loading state onto hardware registers and enabling hardware to signal
interrupts can be problematic when we're not actually about to run the
VCPU, because it makes it difficult to establish the right context when
handling interrupts from the timer, and it makes the register access
code difficult to reason about.

Luckily, now when we call vcpu_load in each ioctl implementation, we can
simply remove the call from the non-KVM_RUN vcpu ioctls, and our
kvm_arch_vcpu_load() is only used for loading vcpu content to the
physical CPU when we're actually going to run the vcpu.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/guest.c | 3 ---
 virt/kvm/arm/arm.c     | 9 ---------
 2 files changed, 12 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d7e3299a7734..959e50d2588c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -363,8 +363,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 {
 	int ret = 0;
 
-	vcpu_load(vcpu);
-
 	trace_kvm_set_guest_debug(vcpu, dbg->control);
 
 	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK) {
@@ -386,7 +384,6 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	}
 
 out:
-	vcpu_put(vcpu);
 	return ret;
 }
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7a6ce4830cc5..5e3c149a6e28 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -383,14 +383,11 @@ static void vcpu_power_off(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	vcpu_load(vcpu);
-
 	if (vcpu->arch.power_off)
 		mp_state->mp_state = KVM_MP_STATE_STOPPED;
 	else
 		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
 
-	vcpu_put(vcpu);
 	return 0;
 }
 
@@ -399,8 +396,6 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 {
 	int ret = 0;
 
-	vcpu_load(vcpu);
-
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
 		vcpu->arch.power_off = false;
@@ -412,7 +407,6 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		ret = -EINVAL;
 	}
 
-	vcpu_put(vcpu);
 	return ret;
 }
 
@@ -1028,8 +1022,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	struct kvm_device_attr attr;
 	long r;
 
-	vcpu_load(vcpu);
-
 	switch (ioctl) {
 	case KVM_ARM_VCPU_INIT: {
 		struct kvm_vcpu_init init;
@@ -1106,7 +1098,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 	}
 
-	vcpu_put(vcpu);
 	return r;
 }
 
-- 
2.14.2
