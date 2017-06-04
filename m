From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v5 07/11] KVM: arm/arm64: optimize VCPU RUN
Date: Sun,  4 Jun 2017 14:43:57 +0200
Message-ID: <20170604124401.24902-8-drjones@redhat.com>
References: <20170604124401.24902-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A64340C5A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8mt8v-c2O3jp for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Jun 2017 08:40:16 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C854040D38
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:15 -0400 (EDT)
In-Reply-To: <20170604124401.24902-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: marc.zyngier@arm.com, cdall@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

We can make a small optimization by not checking the state of
the power_off field on each run. This is done by treating
power_off like pause, only checking it when we get the EXIT
VCPU request. When a VCPU powers off another VCPU the EXIT
request is already made, so we just need to make sure the
request is also made on self power off. kvm_vcpu_kick() isn't
necessary for these cases, as the VCPU would just be kicking
itself, but we add it anyway as a self kick doesn't cost much,
and it makes the code more future-proof.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arm.c  | 19 +++++++++++--------
 virt/kvm/arm/psci.c |  2 ++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 21a4db90073f..9379b1d75ad3 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -368,6 +368,13 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_put(vcpu);
 }
 
+static void vcpu_power_off(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.power_off = true;
+	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
@@ -387,7 +394,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		vcpu->arch.power_off = false;
 		break;
 	case KVM_MP_STATE_STOPPED:
-		vcpu->arch.power_off = true;
+		vcpu_power_off(vcpu);
 		break;
 	default:
 		return -EINVAL;
@@ -557,7 +564,7 @@ static void vcpu_sleep(struct kvm_vcpu *vcpu)
 	swait_event_interruptible(*wq, ((!vcpu->arch.power_off) &&
 				       (!vcpu->arch.pause)));
 
-	if (vcpu->arch.pause) {
+	if (vcpu->arch.power_off || vcpu->arch.pause) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
 	}
@@ -623,9 +630,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		check_vcpu_requests(vcpu);
 
-		if (vcpu->arch.power_off)
-			vcpu_sleep(vcpu);
-
 		/*
 		 * Preparing the interrupts to be injected also
 		 * involves poking the GIC, which must be done in a
@@ -662,8 +666,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
-		    kvm_request_pending(vcpu) ||
-		    vcpu->arch.power_off) {
+		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
@@ -896,7 +899,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Handle the "start in power-off" case.
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
-		vcpu->arch.power_off = true;
+		vcpu_power_off(vcpu);
 	else
 		vcpu->arch.power_off = false;
 
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index f189d0ad30d5..4a436685c552 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -65,6 +65,8 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
+	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
+	kvm_vcpu_kick(vcpu);
 }
 
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
-- 
2.9.4
