Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36DA3E025F
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880680; cv=none; b=WFYL8KPVvCWcvZpDTwpW5T/FKUd8r+zd1umNTho3RuRkC1p7SlW4snYrSOCCmlfjJDzWwAW1bkU3q22EgzAKK/FN5ivvXvYE9pVjVG6pJFT6p40n60rsse3R6U8ShcuuOTMjz9CdehkN3kI9Q3IHe/LStKFTGGfnkIZoipEsC7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880680; c=relaxed/simple;
	bh=buXKF6E8KWZCWobkkDmt7c176g0HkmhdztV5Okvm7jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pwv7CUKfvlWlAP/GU6FzAvrc4qiBhcAIDB4L1B2AKNf/i1Hp6h5POlYBCp8T3k3wroB3uJ32F6srlX7Y89gByGr9M4gUosAtochr+G4HD61buHxYUJMUSlNoPUVQW8Ar3OPl48VAnSs7XT/qGU3jnc3rvwI3OzRGAdaWdNM5VYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AWXAlNk9; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AWXAlNk9"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 364E04515;
	Mon, 30 Mar 2026 07:24:32 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 74C563F915;
	Mon, 30 Mar 2026 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880678; bh=buXKF6E8KWZCWobkkDmt7c176g0HkmhdztV5Okvm7jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWXAlNk9RpQYMvxEgqQiH6PeqndN4aGUPrdEoPLgmvzqpfl4m81e2QbfEFo1b4uzq
	 Bi2kM5xjWzrpdYHhzSqPAbbdidY8a8j4lOwEG3Q578gNLOM4y48D/Kj0LaKT3e64AM
	 +XPQwvuiErWIsgY6Kws+Qn8isJ1xRvDwkmG64Qpk=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 14/17] arm64: psci: Implement AFFINITY_INFO
Date: Mon, 30 Mar 2026 15:23:31 +0100
Message-ID: <20260330142334.3309961-15-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Implement support for PSCI AFFINITY_INFO by iteratively searching all of
the vCPUs in a VM for those that match the specified affinity. Pause the
VM to avoid racing against other PSCI calls in the system that might
change the power state of the vCPUs.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm64/include/kvm/kvm-cpu-arch.h | 12 ++++++-
 arm64/psci.c                     | 59 ++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arm64/include/kvm/kvm-cpu-arch.h b/arm64/include/kvm/kvm-cpu-arch.h
index dbd90647..d9eb5f0e 100644
--- a/arm64/include/kvm/kvm-cpu-arch.h
+++ b/arm64/include/kvm/kvm-cpu-arch.h
@@ -7,7 +7,6 @@
 #include <pthread.h>
 #include <stdbool.h>
 
-#define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 #define ARM_CPU_CTRL		3, 0, 1, 0
@@ -67,6 +66,17 @@ unsigned long kvm_cpu__get_vcpu_mpidr(struct kvm_cpu *vcpu);
 int kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
 int kvm_cpu__teardown_pvtime(struct kvm *kvm);
 
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
diff --git a/arm64/psci.c b/arm64/psci.c
index 14c98639..94e39d40 100644
--- a/arm64/psci.c
+++ b/arm64/psci.c
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
 	kvm__continue(vcpu->kvm);
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
+	kvm__pause(vcpu->kvm);
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
+	kvm__continue(vcpu->kvm);
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
2.43.0

