Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69D61311BD;
	Fri, 12 Apr 2024 08:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911485; cv=none; b=M2Ho5SOfBESzZQqwrJFU/Xrl4WcWO9hO58CNK14D1F43anHkdhqu8XvDnqjPZRijmWWvlRiIaNX4JFIrAt99zD1fx9AMGYQYguTngpQp+7ER6uV2aY/1pqK2LKki5Ms4uOS+kuQizhKc2OpVKEur76b77UtoxzvZFcbJQFGUv5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911485; c=relaxed/simple;
	bh=Rv5D5lf3czKPAezka8rQhkAY8T/XEwin0CCX141gRlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uhdRBpb5h5y+5jqLGx+ZJCEOSkC62vDtjqnyCm3tQpqOiwqcZzTAo1As7an5CFqJKufuJcoZk9GxvxAHpEb2yfP1T1S5nteGs+sSvg4DHOEhKDfxjC6BjbvBHAlU2ocdzCWWvugc7YARehLdLdMkCjAiheCALr3MWUxQwOgCLTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A70D7339;
	Fri, 12 Apr 2024 01:45:12 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 308C03F6C4;
	Fri, 12 Apr 2024 01:44:41 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 36/43] arm64: RME: Set breakpoint parameters through SET_ONE_REG
Date: Fri, 12 Apr 2024 09:43:02 +0100
Message-Id: <20240412084309.1733783-37-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Allow userspace to configure the number of breakpoints and watchpoints
of a Realm VM through KVM_SET_ONE_REG ID_AA64DFR0_EL1.

The KVM sys_reg handler checks the user value against the maximum value
given by RMM (arm64_check_features() gets it from the
read_sanitised_id_aa64dfr0_el1() reset handler).

Userspace discovers that it can write these fields by issuing a
KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/guest.c    |  2 ++
 arch/arm64/kvm/rme.c      |  3 +++
 arch/arm64/kvm/sys_regs.c | 21 ++++++++++++++-------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index d35367cf527d..f9a47ce71a26 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -783,6 +783,7 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 }
 
 #define KVM_REG_ARM_PMCR_EL0		ARM64_SYS_REG(3, 3, 9, 12, 0)
+#define KVM_REG_ARM_ID_AA64DFR0_EL1	ARM64_SYS_REG(3, 0, 0, 5, 0)
 
 /*
  * The RMI ABI only enables setting the lower GPRs (x0-x7) and PC.
@@ -805,6 +806,7 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
 	} else {
 		switch (reg->id) {
 		case KVM_REG_ARM_PMCR_EL0:
+		case KVM_REG_ARM_ID_AA64DFR0_EL1:
 			return true;
 		}
 	}
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 4edc8d98e1e6..51ac8c3462ea 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -305,6 +305,7 @@ static int realm_create_rd(struct kvm *kvm)
 	void *rd = NULL;
 	phys_addr_t rd_phys, params_phys;
 	struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+	u64 dfr0 = IDREG(kvm, SYS_ID_AA64DFR0_EL1);
 	int i, r;
 
 	if (WARN_ON(realm->rd) || WARN_ON(!realm->params))
@@ -335,6 +336,8 @@ static int realm_create_rd(struct kvm *kvm)
 	params->rtt_num_start = pgt->pgd_pages;
 	params->rtt_base = kvm->arch.mmu.pgd_phys;
 	params->vmid = realm->vmid;
+	params->num_bps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0) + 1;
+	params->num_wps = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0) + 1;
 
 	if (kvm->arch.arm_pmu) {
 		params->pmu_num_ctrs = kvm->arch.pmcr_n;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cb3dc640a4a5..5703b63186fd 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1717,6 +1717,9 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
+	u8 bps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, val);
+	u8 wps = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, val);
+	u8 ctx_cmps = SYS_FIELD_GET(ID_AA64DFR0_EL1, CTX_CMPs, val);
 
 	/*
 	 * Prior to commit 3d0dba5764b9 ("KVM: arm64: PMU: Move the
@@ -1736,10 +1739,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 
 	/*
-	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
-	 * nonzero minimum safe value.
+	 * ID_AA64DFR0_EL1.DebugVer, BRPs and WRPs all have to be greater than
+	 * zero. CTX_CMPs is never greater than BRPs.
 	 */
-	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
+	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP || !bps || !wps ||
+	    ctx_cmps > bps)
 		return -EINVAL;
 
 	return set_id_reg(vcpu, rd, val);
@@ -1822,10 +1826,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	mutex_lock(&vcpu->kvm->arch.config_lock);
 
 	/*
-	 * Once the VM has started the ID registers are immutable. Reject any
-	 * write that does not match the final register value.
+	 * Once the VM has started or the Realm descriptor is created, the ID
+	 * registers are immutable. Reject any write that does not match the
+	 * final register value.
 	 */
-	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+	if (kvm_vm_has_ran_once(vcpu->kvm) || kvm_realm_is_created(vcpu->kvm)) {
 		if (val != read_id_reg(vcpu, rd))
 			ret = -EBUSY;
 		else
@@ -2307,7 +2312,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  .set_user = set_id_aa64dfr0_el1,
 	  .reset = read_sanitised_id_aa64dfr0_el1,
 	  .val = ID_AA64DFR0_EL1_PMUVer_MASK |
-		 ID_AA64DFR0_EL1_DebugVer_MASK, },
+		 ID_AA64DFR0_EL1_DebugVer_MASK |
+		 ID_AA64DFR0_EL1_BRPs_MASK |
+		 ID_AA64DFR0_EL1_WRPs_MASK, },
 	ID_SANITISED(ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
 	ID_UNALLOCATED(5,3),
-- 
2.34.1

