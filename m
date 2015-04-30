From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 2/2] KVM: arm/mips/x86/power use __kvm_guest_{enter|exit}
Date: Thu, 30 Apr 2015 13:43:31 +0200
Message-ID: <1430394211-25209-3-git-send-email-borntraeger@de.ibm.com>
References: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1430394211-25209-1-git-send-email-borntraeger@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mips@linux-mips.org, Cornelia Huck <cornelia.huck@de.ibm.com>, Alexander Graf <agraf@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Use __kvm_guest_{enter|exit} instead of kvm_guest_{enter|exit}
where interrupts are disabled.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/arm/kvm/arm.c         | 4 ++--
 arch/mips/kvm/mips.c       | 4 ++--
 arch/powerpc/kvm/powerpc.c | 2 +-
 arch/x86/kvm/x86.c         | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5560f74..050c274 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -533,13 +533,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * Enter the guest
 		 */
 		trace_kvm_entry(*vcpu_pc(vcpu));
-		kvm_guest_enter();
+		__kvm_guest_enter();
 		vcpu->mode = IN_GUEST_MODE;
 
 		ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
 
 		vcpu->mode = OUTSIDE_GUEST_MODE;
-		kvm_guest_exit();
+		__kvm_guest_exit();
 		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 		/*
 		 * We may have taken a host interrupt in HYP mode (ie
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index c9eccf5..539c12c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -388,7 +388,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	kvm_mips_deliver_interrupts(vcpu,
 				    kvm_read_c0_guest_cause(vcpu->arch.cop0));
 
-	kvm_guest_enter();
+	__kvm_guest_enter();
 
 	/* Disable hardware page table walking while in guest */
 	htw_stop();
@@ -398,7 +398,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	/* Re-enable HTW before enabling interrupts */
 	htw_start();
 
-	kvm_guest_exit();
+	__kvm_guest_exit();
 	local_irq_enable();
 
 	if (vcpu->sigset_active)
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 27c0fac..e5c0be5 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -115,7 +115,7 @@ int kvmppc_prepare_to_enter(struct kvm_vcpu *vcpu)
 			continue;
 		}
 
-		kvm_guest_enter();
+		__kvm_guest_enter();
 		return 1;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32bf19e..eb8aa96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6292,7 +6292,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (req_immediate_exit)
 		smp_send_reschedule(vcpu->cpu);
 
-	kvm_guest_enter();
+	__kvm_guest_enter();
 
 	if (unlikely(vcpu->arch.switch_db_regs)) {
 		set_debugreg(0, 7);
-- 
2.3.0

