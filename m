From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v5 02/11] KVM: add kvm_request_pending
Date: Sun,  4 Jun 2017 14:43:52 +0200
Message-ID: <20170604124401.24902-3-drjones@redhat.com>
References: <20170604124401.24902-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170604124401.24902-1-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: cdall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Radim Krčmář <rkrcmar@redhat.com>

A first step in vcpu->requests encapsulation.  Additionally, we now
use READ_ONCE() when accessing vcpu->requests, which ensures we
always load vcpu->requests when it's accessed.  This is important as
other threads can change it any time.  Also, READ_ONCE() documents
that vcpu->requests is used with other threads, likely requiring
memory barriers, which it does.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
[ Documented the new use of READ_ONCE() and converted another check
  in arch/mips/kvm/vz.c ]
Signed-off-by: Andrew Jones <drjones@redhat.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
---
 arch/mips/kvm/trap_emul.c  | 2 +-
 arch/mips/kvm/vz.c         | 2 +-
 arch/powerpc/kvm/booke.c   | 2 +-
 arch/powerpc/kvm/powerpc.c | 5 ++---
 arch/s390/kvm/kvm-s390.c   | 2 +-
 arch/x86/kvm/x86.c         | 4 ++--
 include/linux/kvm_host.h   | 5 +++++
 7 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
index a563759fd142..6a0d7040d882 100644
--- a/arch/mips/kvm/trap_emul.c
+++ b/arch/mips/kvm/trap_emul.c
@@ -1094,7 +1094,7 @@ static void kvm_trap_emul_check_requests(struct kvm_vcpu *vcpu, int cpu,
 	struct mm_struct *mm;
 	int i;
 
-	if (likely(!vcpu->requests))
+	if (likely(!kvm_request_pending(vcpu)))
 		return;
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 71d8856ade64..74805035edc8 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -2337,7 +2337,7 @@ static int kvm_vz_check_requests(struct kvm_vcpu *vcpu, int cpu)
 	int ret = 0;
 	int i;
 
-	if (!vcpu->requests)
+	if (!kvm_request_pending(vcpu))
 		return 0;
 
 	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 3eaac3809977..071b87ee682f 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -687,7 +687,7 @@ int kvmppc_core_prepare_to_enter(struct kvm_vcpu *vcpu)
 
 	kvmppc_core_check_exceptions(vcpu);
 
-	if (vcpu->requests) {
+	if (kvm_request_pending(vcpu)) {
 		/* Exception delivery raised request; start over */
 		return 1;
 	}
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index f7cf2cd564ef..fd64f087737c 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -55,8 +55,7 @@ EXPORT_SYMBOL_GPL(kvmppc_pr_ops);
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	return !!(v->arch.pending_exceptions) ||
-	       v->requests;
+	return !!(v->arch.pending_exceptions) || kvm_request_pending(v);
 }
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
@@ -108,7 +107,7 @@ int kvmppc_prepare_to_enter(struct kvm_vcpu *vcpu)
 		 */
 		smp_mb();
 
-		if (vcpu->requests) {
+		if (kvm_request_pending(vcpu)) {
 			/* Make sure we process requests preemptable */
 			local_irq_enable();
 			trace_kvm_check_requests(vcpu);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 689ac48361c6..ad41e0fa3a21 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2440,7 +2440,7 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 {
 retry:
 	kvm_s390_vcpu_request_handled(vcpu);
-	if (!vcpu->requests)
+	if (!kvm_request_pending(vcpu))
 		return 0;
 	/*
 	 * We use MMU_RELOAD just to re-arm the ipte notifier for the
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 464da936c53d..f81060518635 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6710,7 +6710,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	bool req_immediate_exit = false;
 
-	if (vcpu->requests) {
+	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_MMU_RELOAD, vcpu))
 			kvm_mmu_unload(vcpu);
 		if (kvm_check_request(KVM_REQ_MIGRATE_TIMER, vcpu))
@@ -6874,7 +6874,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_ops->sync_pir_to_irr(vcpu);
 	}
 
-	if (vcpu->mode == EXITING_GUEST_MODE || vcpu->requests
+	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
 	    || need_resched() || signal_pending(current)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
 		smp_wmb();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3724b51aab64..0b50e7b35ed4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1105,6 +1105,11 @@ static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
 	set_bit(req & KVM_REQUEST_MASK, &vcpu->requests);
 }
 
+static inline bool kvm_request_pending(struct kvm_vcpu *vcpu)
+{
+	return READ_ONCE(vcpu->requests);
+}
+
 static inline bool kvm_test_request(int req, struct kvm_vcpu *vcpu)
 {
 	return test_bit(req & KVM_REQUEST_MASK, &vcpu->requests);
-- 
2.9.4
