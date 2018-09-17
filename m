From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 06/18] kvm: arm/arm64: Allow arch specific configurations for VM
Date: Mon, 17 Sep 2018 11:41:28 +0100
Message-ID: <20180917104144.19188-7-suzuki.poulose@arm.com>
References: <20180917104144.19188-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917104144.19188-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, dave.martin@arm.com, julien.grall@arm.com, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Allow the arch backends to perform VM specific initialisation.
This will be later used to handle IPA size configuration and per-VM
VTCR configuration on arm64.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/include/asm/kvm_host.h   | 7 +++++++
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/reset.c            | 7 +++++++
 virt/kvm/arm/arm.c                | 5 +++--
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 3ad482d2f1eb..72d46418e1ef 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -354,4 +354,11 @@ static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
+static inline int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
+{
+	if (type)
+		return -EINVAL;
+	return 0;
+}
+
 #endif /* __ARM_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d6d7336f871..b04280ae1be0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -513,4 +513,6 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
 struct kvm *kvm_arch_alloc_vm(void);
 void kvm_arch_free_vm(struct kvm *kvm);
 
+int kvm_arm_config_vm(struct kvm *kvm, unsigned long type);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index e37c78bbe1ca..b0c07dab5cb3 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -133,3 +133,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	/* Reset timer */
 	return kvm_timer_vcpu_reset(vcpu);
 }
+
+int kvm_arm_config_vm(struct kvm *kvm, unsigned long type)
+{
+	if (type)
+		return -EINVAL;
+	return 0;
+}
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index c92053bc3f96..327d0fd28380 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -120,8 +120,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int ret, cpu;
 
-	if (type)
-		return -EINVAL;
+	ret = kvm_arm_config_vm(kvm, type);
+	if (ret)
+		return ret;
 
 	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
 	if (!kvm->arch.last_vcpu_ran)
-- 
2.19.0
