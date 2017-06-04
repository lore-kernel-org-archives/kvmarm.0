From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH v5 08/11] KVM: arm/arm64: change exit request to sleep request
Date: Sun,  4 Jun 2017 14:43:58 +0200
Message-ID: <20170604124401.24902-9-drjones@redhat.com>
References: <20170604124401.24902-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBBC240969
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BAbWiphhO3ct for <kvmarm@lists.cs.columbia.edu>;
 Sun,  4 Jun 2017 08:40:18 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95B9040C5A
 for <kvmarm@lists.cs.columbia.edu>; Sun,  4 Jun 2017 08:40:17 -0400 (EDT)
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

A request called EXIT is too generic. All requests are meant to cause
exits, but different requests have different flags. Let's not make
it difficult to decide if the EXIT request is correct for some case
by just always providing unique requests for each case. This patch
changes EXIT to SLEEP, because that's what the request is asking the
VCPU to do.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/include/asm/kvm_host.h   |  2 +-
 arch/arm64/include/asm/kvm_host.h |  2 +-
 virt/kvm/arm/arm.c                | 12 ++++++------
 virt/kvm/arm/psci.c               |  4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index c556babe467c..fdd644c01c89 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -44,7 +44,7 @@
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
 #endif
 
-#define KVM_REQ_VCPU_EXIT \
+#define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0ff991c9c66e..9bd0d1040de9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -41,7 +41,7 @@
 
 #define KVM_VCPU_MAX_FEATURES 4
 
-#define KVM_REQ_VCPU_EXIT \
+#define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 int __attribute_const__ kvm_target_cpu(void);
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9379b1d75ad3..ddc833987dfb 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -371,7 +371,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static void vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
+	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
@@ -543,7 +543,7 @@ void kvm_arm_halt_guest(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		vcpu->arch.pause = true;
-	kvm_make_all_cpus_request(kvm, KVM_REQ_VCPU_EXIT);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_SLEEP);
 }
 
 void kvm_arm_resume_guest(struct kvm *kvm)
@@ -557,7 +557,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_sleep(struct kvm_vcpu *vcpu)
+static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 {
 	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
 
@@ -566,7 +566,7 @@ static void vcpu_sleep(struct kvm_vcpu *vcpu)
 
 	if (vcpu->arch.power_off || vcpu->arch.pause) {
 		/* Awaken to handle a signal, request we sleep again later. */
-		kvm_make_request(KVM_REQ_VCPU_EXIT, vcpu);
+		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
 }
 
@@ -578,8 +578,8 @@ static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
 static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_VCPU_EXIT, vcpu))
-			vcpu_sleep(vcpu);
+		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
+			vcpu_req_sleep(vcpu);
 	}
 }
 
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 4a436685c552..f1e363bab5e8 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
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
-- 
2.9.4
