Received: from out-101.mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE6717FE8
	for <kvmarm@lists.linux.dev>; Wed,  2 Aug 2023 23:43:42 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1691019820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9tEhkLhf0vuFOgnhgXsn9AiSJya0oEnK4+icOZ8D8/g=;
	b=GopFHnSoLEvqyqRD9BiGuoYJgX/NhxIa748KsYYQqaEdjm63HvmRA3gSKRdueNw1RP1jcQ
	WytaRNxuyZpQYdY3H+xPKXwfyrSnqniF39Wv4k6QdTlZYHzQIcniRjI2t11nbWgDGJOqti
	QGL7GHELoD2ZfIHeX62IM/uxCMiliVY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 14/17] aarch64: psci: Implement AFFINITY_INFO
Date: Wed,  2 Aug 2023 23:42:52 +0000
Message-ID: <20230802234255.466782-15-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Implement support for PSCI AFFINITY_INFO by iteratively searching all of
the vCPUs in a VM for those that match the specified affinity. Pause the
VM to avoid racing against other PSCI calls in the system that might
change the power state of the vCPUs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-cpu-arch.h | 12 +++++-
 arm/aarch64/psci.c                     | 59 ++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index 264d0016f7db..5dced04d4035 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -5,12 +5,22 @@
 
 #include "arm-common/kvm-cpu-arch.h"
 
-#define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 #define ARM_CPU_CTRL		3, 0, 1, 0
 #define ARM_CPU_CTRL_SCTLR_EL1	0
 
+#define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
+#define ARM_MPIDR_LEVEL_BITS_SHIFT	3
+#define ARM_MPIDR_LEVEL_BITS	(1 << ARM_MPIDR_LEVEL_BITS_SHIFT)
+#define ARM_MPIDR_LEVEL_MASK	((1 << ARM_MPIDR_LEVEL_BITS) - 1)
+
+#define ARM_MPIDR_LEVEL_SHIFT(level) \
+	(((1 << level) >> 1) << ARM_MPIDR_LEVEL_BITS_SHIFT)
+
+#define ARM_MPIDR_AFFINITY_LEVEL(mpidr, level) \
+	((mpidr >> ARM_MPIDR_LEVEL_SHIFT(level)) & ARM_MPIDR_LEVEL_MASK)
+
 static inline __u64 __core_reg_id(__u64 offset)
 {
 	__u64 id = KVM_REG_ARM64 | KVM_REG_ARM_CORE | offset;
diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
index 254e16e7985d..ac49d7aa8f22 100644
--- a/arm/aarch64/psci.c
+++ b/arm/aarch64/psci.c
@@ -6,6 +6,16 @@
 #include <linux/psci.h>
 #include <linux/types.h>
 
+#define AFFINITY_MASK(level)	~((0x1UL << ((level) * ARM_MPIDR_LEVEL_BITS)) - 1)
+
+static unsigned long psci_affinity_mask(unsigned long affinity_level)
+{
+	if (affinity_level <= 3)
+		return ARM_MPIDR_HWID_BITMASK & AFFINITY_MASK(affinity_level);
+
+	return 0;
+}
+
 static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	u32 arg = smccc_get_arg(vcpu, 1);
@@ -20,6 +30,8 @@ static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN_CPU_OFF:
 	case PSCI_0_2_FN_CPU_ON:
 	case PSCI_0_2_FN64_CPU_ON:
+	case PSCI_0_2_FN_AFFINITY_INFO:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
 	case ARM_SMCCC_VERSION_FUNC_ID:
 		res->a0 = PSCI_RET_SUCCESS;
 		break;
@@ -111,6 +123,49 @@ out_continue:
 	kvm_cpu__continue_vm(vcpu);
 }
 
+static void affinity_info(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
+{
+	u64 target_affinity = smccc_get_arg(vcpu, 1);
+	u64 lowest_level = smccc_get_arg(vcpu, 2);
+	u64 mpidr_mask = psci_affinity_mask(lowest_level);
+	struct kvm *kvm = vcpu->kvm;
+	bool matched = false;
+	int i;
+
+	if (!psci_valid_affinity(target_affinity) || lowest_level > 3) {
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+		return;
+	}
+
+	kvm_cpu__pause_vm(vcpu);
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_cpu *tmp = kvm->cpus[i];
+		u64 mpidr = kvm_cpu__get_vcpu_mpidr(tmp);
+		struct kvm_mp_state mp_state;
+
+		if ((mpidr & mpidr_mask) != target_affinity)
+			continue;
+
+		if (ioctl(tmp->vcpu_fd, KVM_GET_MP_STATE, &mp_state))
+			die_perror("KVM_GET_MP_STATE failed");
+
+		if (mp_state.mp_state != KVM_MP_STATE_STOPPED) {
+			res->a0 = PSCI_0_2_AFFINITY_LEVEL_ON;
+			goto out_continue;
+		}
+
+		matched = true;
+	}
+
+	if (matched)
+		res->a0 = PSCI_0_2_AFFINITY_LEVEL_OFF;
+	else
+		res->a0 = PSCI_RET_INVALID_PARAMS;
+out_continue:
+	kvm_cpu__continue_vm(vcpu);
+}
+
 void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 {
 	switch (vcpu->kvm_run->hypercall.nr) {
@@ -131,6 +186,10 @@ void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
 	case PSCI_0_2_FN64_CPU_ON:
 		cpu_on(vcpu, res);
 		break;
+	case PSCI_0_2_FN_AFFINITY_INFO:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+		affinity_info(vcpu, res);
+		break;
 	default:
 		res->a0 = PSCI_RET_NOT_SUPPORTED;
 	}
-- 
2.41.0.585.gd2178a4bd4-goog

