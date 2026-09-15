Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A983C4CA29C;
	Tue, 15 Sep 2026 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488185; cv=none; b=jKyvda+bvO5Lg04zGsS4qySyYNWESE2XzKFOiqIdfCjAgPAsz+PudZe8cm5eQdAqy+sNqABe7mcyfuJSZPQ+tZTjX/0IQq6n4bjpABmL4RdmrtN62zRpqsA2JqSsNiwzn3gWDGzCvuugKv2lhjbLdsBlEJ4ZcVgCNZDGfwjygvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488185; c=relaxed/simple;
	bh=mmi6VEWU9VuEsCf9DcQoojukGEJWWKDyBgEMumw2iIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvtgfiooJQZFCfhTGX/hKcjNkza1cBmzQbKwboFfRRS5dWKeYv5yp3zewQS/fza0zUz3SMRBKfBmXn4ZHONLqR7KsJ8Cy3DZsQ6rgH5VpCZrSQSY0akPqj62Ia1av+G1DSa4tE800Z2vvnfgi+v76/8FPHRpbaZcsXAFXJ9N3QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bdFSVjp8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bdFSVjp8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DC0C1D70;
	Tue, 15 Sep 2026 09:02:58 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5B2393F882;
	Tue, 15 Sep 2026 09:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488182; bh=mmi6VEWU9VuEsCf9DcQoojukGEJWWKDyBgEMumw2iIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdFSVjp8EvWuv6uNe0bC1gC3Jff0pK6fz9Hf2o4MnE+98QgymeO15EnDC9P22GGd9
	 l7vgRs+WZmKl8iEr0eiPGo0S9vdQKjdb/zyvk5zuQbJyG2rWdBKbDjEwx30+Nr9HaI
	 cSyJ2tI8Du1VTwP83+HE99Yfxy+noLq2+HtENGyI=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 23/23] KVM: arm64: CCA: Control user register access for Realms
Date: Tue, 15 Sep 2026 17:01:41 +0100
Message-ID: <20260915160141.3543048-24-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915160141.3543048-1-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

The RMM restricts the access to the register states that the host can
read/modify for a given Realm.

e.g., At VCPU creation, can modify GPRS (x0-x30) and PC.
      While servicing SMCCC calls via RSI_HOST_CALL or servicing PSCI requests.
      MMIO emulation in the unprotected space.

Additionally we use the sysreg configuration to advertise/configure the following
Realm parameters, which are required before the Realm Descriptor is created:
 - SVE Vector Length
 - Number of HW Breakpoints/Watchpoints
 - PMU Counters.

Thus KVM also additionally allows access to ID_AA64DFR0_EL1 and SVE_VLS for
the configuration of Realm creation paramters.

The RMM makes similar restrictions for reading of the guest's registers
(this is *confidential* compute after all), however we don't impose the
restriction here. This allows the VMM to read (stale) values from the
registers which might be useful to read back the initial values even if
the RMM doesn't provide the latest version. For migration of a realm VM,
a new interface will be needed so that the VMM can receive an
(encrypted) blob of the VM's state.

Reflect the above in KVM_GET_REG_LIST, KVM_SET_ONE_REG calls.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v17:
  - Merge related changes into one single patch for the user set/get registers
    I have retained the Review tags, as the code hasn't changed, just the patches
    were merged into a single one with the same tags.
  - Limit KVM_GET_REG_LIST to the allowed CORE registers.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/guest.c      | 63 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hypercalls.c |  4 +--
 arch/arm64/kvm/sys_regs.c   | 29 +++++++++++++----
 3 files changed, 88 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index c3ca369882273..4ec95810ca89b 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -73,6 +73,25 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
+static bool kvm_realm_validate_core_reg(u64 off)
+{
+	/*
+	 * Note that GPRs can only sometimes be controlled by the VMM.
+	 * For PSCI only X0-X6 are used, higher registers are ignored (restored
+	 * from the REC).
+	 * For HOST_CALL all of X0-X30 are copied to the RsiHostCall structure.
+	 * For emulated MMIO X0 is always used.
+	 * PC can only be set before the realm is activated.
+	 */
+	switch (off) {
+	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
+	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
+	case KVM_REG_ARM_CORE_REG(regs.pc):
+		return true;
+	}
+	return false;
+}
+
 static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 {
 	int size;
@@ -553,6 +572,9 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
 		u64 reg = KVM_REG_ARM64 | KVM_REG_ARM_CORE | i;
 		int size = core_reg_size_from_offset(vcpu, i);
 
+		if (vcpu_is_rec(vcpu) && !kvm_realm_validate_core_reg(i))
+			continue;
+
 		if (size < 0)
 			continue;
 
@@ -598,6 +620,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 	if (!vcpu_has_sve(vcpu))
 		return 0;
 
+	if (kvm_vm_is_realm(vcpu->kvm))
+		return 1; /* KVM_REG_ARM64_SVE_VLS */
+
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return 1; /* KVM_REG_ARM64_SVE_VLS */
 
@@ -625,6 +650,10 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	++num_regs;
 
+	/* For Realms only support SVE_VLS */
+	if (kvm_vm_is_realm(vcpu->kvm))
+		return num_regs;
+
 	if (!kvm_arm_vcpu_sve_finalized(vcpu))
 		return num_regs;
 
@@ -705,6 +734,11 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
 		return -EINVAL;
 
+	/*
+	  * We don't filter out the register reads for Realms, like we do for
+	  * the user writes. We expose junk data for the VMM instead of
+	  * denying the requests.
+	  */
 	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
 	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
 	case KVM_REG_ARM_FW:
@@ -716,12 +750,41 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
 }
 
+#define KVM_REG_ARM_ID_AA64DFR0_EL1	ARM64_SYS_REG(3, 0, 0, 5, 0)
+/*
+ * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
+ * that are available depends on the Realm state and the reason for the last
+ * exit.  All other registers are reset to architectural or otherwise defined
+ * reset values by the RMM, except for a few configuration fields that
+ * correspond to Realm parameters.
+ */
+static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
+				   const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
+		u64 off = core_reg_offset_from_id(reg->id);
+
+		return kvm_realm_validate_core_reg(off);
+	} else {
+		switch (reg->id) {
+		case KVM_REG_ARM_ID_AA64DFR0_EL1:
+		case KVM_REG_ARM64_SVE_VLS:
+			return true;
+		}
+	}
+
+	return false;
+}
+
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	/* We currently use nothing arch-specific in upper 32 bits */
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
 		return -EINVAL;
 
+	if (kvm_vm_is_realm(vcpu->kvm) && !validate_realm_set_reg(vcpu, reg))
+		return -EINVAL;
+
 	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
 	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
 	case KVM_REG_ARM_FW:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b11b8821c9fbc..2b1e6fdeb4d5c 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -414,14 +414,14 @@ void kvm_arm_teardown_hypercalls(struct kvm *kvm)
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
+	return vcpu_is_rec(vcpu) ? 0 : ARRAY_SIZE(kvm_arm_fw_reg_ids);
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
+	for (i = 0; i < kvm_arm_get_fw_num_regs(vcpu); i++) {
 		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
 			return -EFAULT;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d7..520cec19f49fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5638,18 +5638,18 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
 
-static unsigned int num_demux_regs(void)
+static inline unsigned int num_demux_regs(struct kvm_vcpu *vcpu)
 {
-	return CSSELR_MAX;
+	return vcpu_is_rec(vcpu) ? 0 : CSSELR_MAX;
 }
 
-static int write_demux_regids(u64 __user *uindices)
+static int write_demux_regids(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
 	unsigned int i;
 
 	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
-	for (i = 0; i < CSSELR_MAX; i++) {
+	for (i = 0; i < num_demux_regs(vcpu); i++) {
 		if (put_user(val | i, uindices))
 			return -EFAULT;
 		uindices++;
@@ -5693,11 +5693,28 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
+static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu,
+						 u64 reg)
+{
+	if (!vcpu_is_rec(vcpu))
+		return false;
+
+	switch (reg) {
+	case SYS_ID_AA64DFR0_EL1:
+	case SYS_PMCR_EL0:
+		return false;
+	}
+	return true;
+}
+
 static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 			    const struct sys_reg_desc *rd,
 			    u64 __user **uind,
 			    unsigned int *total)
 {
+	if (kvm_realm_sys_reg_hidden_user(vcpu, reg_to_encoding(rd)))
+		return 0;
+
 	/*
 	 * Ignore registers we trap but don't save,
 	 * and for which no custom user accessor is provided.
@@ -5735,7 +5752,7 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 
 unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
 {
-	return num_demux_regs()
+	return num_demux_regs(vcpu)
 		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
 }
 
@@ -5748,7 +5765,7 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 		return err;
 	uindices += err;
 
-	return write_demux_regids(uindices);
+	return write_demux_regids(vcpu, uindices);
 }
 
 #define KVM_ARM_FEATURE_ID_RANGE_INDEX(r)			\
-- 
2.43.0

