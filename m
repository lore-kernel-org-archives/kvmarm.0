From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 1/3] arm64: KVM: Propagate full Spectre v2 workaround state
 to KVM guests
Date: Mon, 15 Apr 2019 12:15:40 +0100
Message-ID: <20190415111542.119788-2-andre.przywara@arm.com>
References: <20190415111542.119788-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D90F84A4C9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 07:15:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SA3-+pEr8jd9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Apr 2019 07:15:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ED004A480
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Apr 2019 07:15:57 -0400 (EDT)
In-Reply-To: <20190415111542.119788-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>, kvmarm@lists.cs.columbia.edu, Steven Price <steven.price@arm.com>, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Recent commits added the explicit notion of "Not affected" to the state
of the Spectre v2 (aka. BP_HARDENING) workaround, where we just had
"needed" and "unknown" before.

Export this knowledge to the rest of the kernel and enhance the existing
kvm_arm_harden_branch_predictor() to report this new state as well.
Export this new state to guests when they use KVM's firmware interface
emulation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm/include/asm/kvm_host.h     | 12 +++++++++---
 arch/arm64/include/asm/cpufeature.h |  6 ++++++
 arch/arm64/include/asm/kvm_host.h   | 16 ++++++++++++++--
 arch/arm64/kernel/cpu_errata.c      | 23 ++++++++++++++++++-----
 virt/kvm/arm/psci.c                 | 10 +++++++++-
 5 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 770d73257ad9..836479e4b340 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -364,7 +364,11 @@ static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arm_vhe_guest_enter(void) {}
 static inline void kvm_arm_vhe_guest_exit(void) {}
 
-static inline bool kvm_arm_harden_branch_predictor(void)
+#define KVM_BP_HARDEN_UNKNOWN		-1
+#define KVM_BP_HARDEN_NEEDED		0
+#define KVM_BP_HARDEN_MITIGATED		1
+
+static inline int kvm_arm_harden_branch_predictor(void)
 {
 	switch(read_cpuid_part()) {
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
@@ -372,10 +376,12 @@ static inline bool kvm_arm_harden_branch_predictor(void)
 	case ARM_CPU_PART_CORTEX_A12:
 	case ARM_CPU_PART_CORTEX_A15:
 	case ARM_CPU_PART_CORTEX_A17:
-		return true;
+		return KVM_BP_HARDEN_NEEDED;
 #endif
+	case ARM_CPU_PART_CORTEX_A7:
+		return KVM_BP_HARDEN_MITIGATED;
 	default:
-		return false;
+		return KVM_BP_HARDEN_UNKNOWN;
 	}
 }
 
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 6ccdc97e5d6a..3c5b25c1bda1 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -622,6 +622,12 @@ static inline bool system_uses_irq_prio_masking(void)
 	       cpus_have_const_cap(ARM64_HAS_IRQ_PRIO_MASKING);
 }
 
+#define ARM64_BP_HARDEN_UNKNOWN		-1
+#define ARM64_BP_HARDEN_NEEDED		0
+#define ARM64_BP_HARDEN_MITIGATED	1
+
+int get_spectre_v2_workaround_state(void);
+
 #define ARM64_SSBD_UNKNOWN		-1
 #define ARM64_SSBD_FORCE_DISABLE	0
 #define ARM64_SSBD_KERNEL		1
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a01fe087e022..bf9a59b7d1ce 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -555,9 +555,21 @@ static inline void kvm_arm_vhe_guest_exit(void)
 	isb();
 }
 
-static inline bool kvm_arm_harden_branch_predictor(void)
+#define KVM_BP_HARDEN_UNKNOWN		-1
+#define KVM_BP_HARDEN_NEEDED		0
+#define KVM_BP_HARDEN_MITIGATED		1
+
+static inline int kvm_arm_harden_branch_predictor(void)
 {
-	return cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR);
+	switch (get_spectre_v2_workaround_state()) {
+	case ARM64_BP_HARDEN_NEEDED:
+		return KVM_BP_HARDEN_NEEDED;
+	case ARM64_BP_HARDEN_MITIGATED:
+		return KVM_BP_HARDEN_MITIGATED;
+	case ARM64_BP_HARDEN_UNKNOWN:
+	default:
+		return KVM_BP_HARDEN_UNKNOWN;
+	}
 }
 
 #define KVM_SSBD_UNKNOWN		-1
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a1f3188c7be0..7fa23ab09d4e 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -555,6 +555,17 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused)
 static bool __hardenbp_enab = true;
 static bool __spectrev2_safe = true;
 
+int get_spectre_v2_workaround_state(void)
+{
+	if (__spectrev2_safe)
+		return ARM64_BP_HARDEN_MITIGATED;
+
+	if (!__hardenbp_enab)
+		return ARM64_BP_HARDEN_UNKNOWN;
+
+	return ARM64_BP_HARDEN_NEEDED;
+}
+
 /*
  * List of CPUs that do not need any Spectre-v2 mitigation at all.
  */
@@ -834,13 +845,15 @@ ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
 ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	if (__spectrev2_safe)
+	switch (get_spectre_v2_workaround_state()) {
+	case ARM64_BP_HARDEN_MITIGATED:
 		return sprintf(buf, "Not affected\n");
-
-	if (__hardenbp_enab)
+        case ARM64_BP_HARDEN_NEEDED:
 		return sprintf(buf, "Mitigation: Branch predictor hardening\n");
-
-	return sprintf(buf, "Vulnerable\n");
+        case ARM64_BP_HARDEN_UNKNOWN:
+	default:
+		return sprintf(buf, "Vulnerable\n");
+	}
 }
 
 ssize_t cpu_show_spec_store_bypass(struct device *dev,
diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
index 34d08ee63747..1da53e0e38f7 100644
--- a/virt/kvm/arm/psci.c
+++ b/virt/kvm/arm/psci.c
@@ -412,8 +412,16 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		feature = smccc_get_arg1(vcpu);
 		switch(feature) {
 		case ARM_SMCCC_ARCH_WORKAROUND_1:
-			if (kvm_arm_harden_branch_predictor())
+			switch (kvm_arm_harden_branch_predictor()) {
+			case KVM_BP_HARDEN_UNKNOWN:
+				break;
+			case KVM_BP_HARDEN_NEEDED:
 				val = SMCCC_RET_SUCCESS;
+				break;
+			case KVM_BP_HARDEN_MITIGATED:
+				val = SMCCC_RET_NOT_REQUIRED;
+				break;
+			}
 			break;
 		case ARM_SMCCC_ARCH_WORKAROUND_2:
 			switch (kvm_arm_have_ssbd()) {
-- 
2.17.1
