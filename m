From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 3/5] KVM: arm/arm64: Require VCPU threads to turn them self off
Date: Fri, 25 Jan 2019 10:46:54 +0100
Message-ID: <20190125094656.5026-4-christoffer.dall@arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 511664A3DD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4gE2bcBDX9c for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 04:47:10 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590D44A3F4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 04:47:08 -0500 (EST)
In-Reply-To: <20190125094656.5026-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

To avoid a race between turning VCPUs off and turning them on, make sure
that only the VCPU threat itself turns off the VCPU.  When other threads
want to turn of a VCPU, they now do this via a request.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  2 ++
 arch/arm64/include/asm/kvm_host.h |  2 ++
 virt/kvm/arm/arm.c                |  8 ++++++--
 virt/kvm/arm/psci.c               | 11 ++---------
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 50e89869178a..b1cfae222441 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -49,6 +49,8 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_VCPU_OFF \
+	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index da3fc7324d68..d43b13421987 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -49,6 +49,8 @@
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
+#define KVM_REQ_VCPU_OFF \
+	KVM_ARCH_REQ_FLAGS(3, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9c486fad3f9f..785076176814 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -404,8 +404,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 static void vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_SLEEP, vcpu);
+	kvm_make_request(KVM_REQ_VCPU_OFF, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
@@ -646,6 +645,11 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
 			vcpu_req_sleep(vcpu);
 
+		if (kvm_check_request(KVM_REQ_VCPU_OFF, vcpu)) {
+			vcpu->arch.power_off = true;
+			vcpu_req_sleep(vcpu);
+		}
+
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
 
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index b9cff1d4b06d..20255319e193 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -97,9 +97,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 
 static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_SLEEP, vcpu);
-	kvm_vcpu_kick(vcpu);
+	kvm_make_request(KVM_REQ_VCPU_OFF, vcpu);
 }
 
 static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
@@ -198,9 +196,6 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 
 static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 {
-	int i;
-	struct kvm_vcpu *tmp;
-
 	/*
 	 * The KVM ABI specifies that a system event exit may call KVM_RUN
 	 * again and may perform shutdown/reboot at a later time that when the
@@ -210,9 +205,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type)
 	 * after this call is handled and before the VCPUs have been
 	 * re-initialized.
 	 */
-	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
-	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_VCPU_OFF);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
 	vcpu->run->system_event.type = type;
-- 
2.18.0
