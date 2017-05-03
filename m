From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v3 08/10] KVM: arm/arm64: change exit request to sleep request
Date: Wed,  3 May 2017 18:06:33 +0200
Message-ID: <20170503160635.21669-9-drjones@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21E4D40C58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pqk2iQ9Bh0p8 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 May 2017 12:03:52 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4252C40A66
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 May 2017 12:03:52 -0400 (EDT)
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

A request called EXIT is too generic. All requests are meant to cause
exits, but different requests have different flags. Let's not make
it difficult to decide if the EXIT request is correct for some case
by just always providing unique requests for each case. This patch
changes EXIT to SLEEP, because that's what the request is asking the
VCPU to do.

We can also remove the 'if (power_off || pause)' condition because it's
likely one of them will be true when the request is pending, and the
same condition will be checked in swait_event_interruptible() before
actually going to sleep anyway.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_host.h   |  2 +-
 arch/arm/kvm/arm.c                | 14 ++++++--------
 arch/arm/kvm/psci.c               |  4 ++--
 arch/arm64/include/asm/kvm_host.h |  2 +-
 4 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index a95d8e315507..41669578b3df 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -45,7 +45,7 @@
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
 #endif
 
-#define KVM_REQ_VCPU_EXIT \
+#define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)
 
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 24bbc7671d89..d62e99885434 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -374,7 +374,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static void vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
+	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
@@ -546,13 +546,13 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		vcpu->arch.pause = true;
-	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
 }
 
 void kvm_arm_halt_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pause = true;
-	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
+	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
@@ -573,7 +573,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 		kvm_arm_resume_vcpu(vcpu);
 }
 
-static void vcpu_sleep(struct kvm_vcpu *vcpu)
+static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 {
 	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
 
@@ -632,10 +632,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		update_vttbr(vcpu->kvm);
 
 		if (kvm_request_pending(vcpu)) {
-			if (kvm_check_request(KVM_REQ_VCPU_EXIT, vcpu)) {
-				if (vcpu->arch.power_off || vcpu->arch.pause)
-					vcpu_sleep(vcpu);
-			}
+			if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
+				vcpu_req_sleep(vcpu);
 		}
 
 		/*
diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 4a436685c552..f1e363bab5e8 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -65,7 +65,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
+	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
@@ -183,7 +183,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
 		tmp->arch.power_off = true;
-	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_VCPU_EXIT);
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8631d210dde1..04c0f9d37386 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -42,7 +42,7 @@
 
 #define KVM_VCPU_MAX_FEATURES 4
 
-#define KVM_REQ_VCPU_EXIT \
+#define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)
 
 int __attribute_const__ kvm_target_cpu(void);
-- 
2.9.3
