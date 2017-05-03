From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v3 04/10] KVM: arm/arm64: use vcpu request in kvm_arm_halt_vcpu
Date: Wed,  3 May 2017 18:06:29 +0200
Message-ID: <20170503160635.21669-5-drjones@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE84640C2E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RVI5jVtYdNM9 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 12:03:44 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA5BF40B5B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:43 -0400 (EDT)
In-Reply-To: <20170503160635.21669-1-drjones@redhat.com>
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

VCPU halting/resuming is partially implemented with VCPU requests.
When kvm_arm_halt_guest() is called all VCPUs get the EXIT request,
telling them to exit guest mode and look at the state of 'pause',
which will be true, telling them to sleep.  As ARM's VCPU RUN
implements the memory barrier pattern described in "Ensuring Requests
Are Seen" of Documentation/virtual/kvm/vcpu-requests.rst, there's
no way for a VCPU halted by kvm_arm_halt_guest() to miss the pause
state change.  However, before this patch, a single VCPU halted with
kvm_arm_halt_vcpu() did not get a request, opening a tiny race window.
This patch adds the request, closing the race window and also allowing
us to remove the final check of pause in VCPU RUN, as the final check
for requests is sufficient.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---

I have two questions about the halting/resuming.

Question 1:

Do we even need kvm_arm_halt_vcpu()/kvm_arm_resume_vcpu()? It should
only be necessary if one VCPU can activate or inactivate the private
IRQs of another VCPU, right?  That doesn't seem like something that
should be possible, but I'm GIC-illiterate...

Question 2:

It's not clear to me if we have another problem with halting/resuming
or not.  If it's possible for VCPU1 and VCPU2 to race in
vgic_mmio_write_s/cactive(), then the following scenario could occur,
leading to VCPU3 being in guest mode when it should not be.  Does the
hardware prohibit more than one VCPU entering trap handlers that lead
to these functions at the same time?  If not, then I guess pause needs
to be a counter instead of a boolean.

 VCPU1                 VCPU2                  VCPU3
 -----                 -----                  -----
                       VCPU3->pause = true;
                       halt(VCPU3);
                                              if (pause)
                                                sleep();
 VCPU3->pause = true;
 halt(VCPU3);
                       VCPU3->pause = false;
                       resume(VCPU3);
                                              ...wake up...
                                              if (!pause)
                                                Enter guest mode. Bad!
 VCPU3->pause = false;
 resume(VCPU3);

(Yes, the "Bad!" is there to both identify something we don't want
 occurring and to make fun of Trump's tweeting style.)
---
 arch/arm/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 47f6c7fdca96..9174ed13135a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -545,6 +545,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pause = true;
+	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
@@ -664,7 +665,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
 		    kvm_request_pending(vcpu) ||
-		    vcpu->arch.power_off || vcpu->arch.pause) {
+		    vcpu->arch.power_off) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
-- 
2.9.3
