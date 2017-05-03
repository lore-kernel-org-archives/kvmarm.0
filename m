From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v3 06/10] KVM: arm/arm64: use vcpu requests for power_off
Date: Wed,  3 May 2017 18:06:31 +0200
Message-ID: <20170503160635.21669-7-drjones@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01A8D40296
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AAJMAULV9yXp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 12:03:48 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B32C40BBC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:48 -0400 (EDT)
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

System shutdown is currently using request-less VCPU kicks. This
leaves open a tiny race window, as it doesn't ensure the state
change to power_off is seen by a VCPU just about to enter guest
mode. VCPU requests, OTOH, are guaranteed to be seen (see "Ensuring
Requests Are Seen" of Documentation/virtual/kvm/vcpu-requests.rst)
This patch applies the EXIT request used by pause to power_off,
closing the race window and also allowing us to remove the final
check of power_off in VCPU RUN, as the final check for requests
is sufficient.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/kvm/arm.c  | 3 +--
 arch/arm/kvm/psci.c | 5 ++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 7be0d9b0c63a..26d9d4d72853 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -670,8 +670,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
-		    kvm_request_pending(vcpu) ||
-		    vcpu->arch.power_off) {
+		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index f68be2cc6256..f189d0ad30d5 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -179,10 +179,9 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 	 * after this call is handled and before the VCPUs have been
 	 * re-initialized.
 	 */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
 		tmp->arch.power_off = true;
-		kvm_vcpu_kick(tmp);
-	}
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_VCPU_EXIT);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
-- 
2.9.3
