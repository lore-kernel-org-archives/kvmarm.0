From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v3 03/10] KVM: arm/arm64: prepare to use vcpu requests
Date: Wed,  3 May 2017 18:06:28 +0200
Message-ID: <20170503160635.21669-4-drjones@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D58CC40296
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G5QfAkoYotLL for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 12:03:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA6BF40C28
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:41 -0400 (EDT)
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

Make sure we don't leave vcpu requests we don't intend to
handle later set in the request bitmap. If we don't clear
them, then kvm_request_pending() may return true when we
don't want it to. Also, make sure we set vcpu->mode at the
appropriate time (before the last requests check) and with
the appropriate barriers. See
Documentation/virtual/kvm/vcpu-requests.rst

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/arm.c           | 14 ++++++++++++--
 arch/arm/kvm/handle_exit.c   |  1 +
 arch/arm/kvm/psci.c          |  1 +
 arch/arm64/kvm/handle_exit.c |  1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 7941699a766d..47f6c7fdca96 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -552,6 +552,7 @@ void kvm_arm_resume_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
 
+	kvm_clear_request(KVM_REQ_VCPU_EXIT, vcpu);
 	vcpu->arch.pause = false;
 	swake_up(wq);
 }
@@ -653,8 +654,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
+		/*
+		 * Ensure we set mode to IN_GUEST_MODE after we disable
+		 * interrupts and before the final VCPU requests check.
+		 * See the comment in kvm_vcpu_exiting_guest_mode() and
+		 * Documentation/virtual/kvm/vcpu-requests.rst
+		 */
+		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
-			vcpu->arch.power_off || vcpu->arch.pause) {
+		    kvm_request_pending(vcpu) ||
+		    vcpu->arch.power_off || vcpu->arch.pause) {
+			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
 			kvm_timer_sync_hwstate(vcpu);
@@ -670,7 +681,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		trace_kvm_entry(*vcpu_pc(vcpu));
 		guest_enter_irqoff();
-		vcpu->mode = IN_GUEST_MODE;
 
 		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
 
diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index 5fd7968cdae9..a2b4f7b82356 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -72,6 +72,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_wfx(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
+		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
 
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index a08d7a93aebb..f68be2cc6256 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -57,6 +57,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	 * for KVM will preserve the register state.
 	 */
 	kvm_vcpu_block(vcpu);
+	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 
 	return PSCI_RET_SUCCESS;
 }
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index fa1b18e364fc..17d8a1677a0b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -89,6 +89,7 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_block(vcpu);
+		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
 
 	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
-- 
2.9.3
