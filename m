Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFA31350E3
	for <kvmarm@lists.linux.dev>; Thu, 21 Mar 2024 16:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711040274; cv=none; b=dtMPFkOyBjCoeFL9ze4uc7TSJ0IGk8wUshJhxOGWKU2msEFwfozlYy/E+BYW78pychW74fTSRqgGDHm0j1zvdS0PlHv4UXsdOwtxmifedml6lyzMHvNupfjk+ZeJMmqnGTkwU/Ax1MS4DasDsvjSETgOBIAARMoG//6JvN6fpe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711040274; c=relaxed/simple;
	bh=O6q2cft5zAruRlZnYQbi1uUKxCCQ1mxtCNzkE21G0vE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TSuiTGREdSvMIzijxkLn01CMNlIbdkP3mddx9x+BxO4Tcidr0TnEjf66zAGGfz1S/NE62QAhZUVFKsrA/M7hWfVgxKzuzZ1gt6rp6L3McpLvtaxPaGSSiqDP91DgGEPmKvirXwjL8wnEsaUU/eymKjT+jx0FIvKfT0pZ54vvFE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECC2D1007;
	Thu, 21 Mar 2024 09:58:26 -0700 (PDT)
Received: from merodach.members.linode.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C3A83F67D;
	Thu, 21 Mar 2024 09:57:51 -0700 (PDT)
From: James Morse <james.morse@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>,
	James Morse <james.morse@arm.com>
Subject: [PATCH v3 6/6] KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely ignored
Date: Thu, 21 Mar 2024 16:57:28 +0000
Message-Id: <20240321165728.31907-7-james.morse@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240321165728.31907-1-james.morse@arm.com>
References: <20240321165728.31907-1-james.morse@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ID_AA64PFR0.MPAM bit was previously accidentally exposed to guests,
and is ignored by KVM. KVM will always present the guest with 0 here,
and trap the MPAM system registers to inject an undef.

But, this vaulue is still needed to prevent migration when the value
is incompatible with the target hardware. Add a kvm unit test to try
and write multiple values to ID_AA64PFR0.MPAM. Only the hardware value
previously exposed should be ignored, all other values should be
rejected.

Signed-off-by: James Morse <james.morse@arm.com>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 53 ++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index b42a0dc19852..fbb600111969 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -426,6 +426,56 @@ static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
 	}
 }
 
+#define MPAM_IDREG_TEST	1
+static void test_user_set_mpam_reg(struct kvm_vcpu *vcpu)
+{
+	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
+	struct reg_mask_range range = {
+		.addr = (__u64)masks,
+	};
+	uint64_t val, ftr_mask;
+	int idx, err;
+
+	/*
+	 * If ID_AA64PFR0.MPAM is _not_ officially modifiable and is zero,
+	 * check that if it can be set to 1, (i.e. it is supported by the
+	 * hardware), that it can't be set to other values.
+	 */
+
+	/* Get writable masks for feature ID registers */
+	memset(range.reserved, 0, sizeof(range.reserved));
+	vm_ioctl(vcpu->vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+
+	/* Writeable? Nothing to test! */
+	idx = sys_reg_to_idx(SYS_ID_AA64PFR0_EL1);
+	ftr_mask = ID_AA64PFR0_EL1_MPAM_MASK;
+	if ((masks[idx] & ftr_mask) == ftr_mask) {
+		ksft_test_result_skip("ID_AA64PFR0.MPAM is officially writable, nothing to test\n");
+		return;
+	}
+
+	/* Get the id register value */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
+
+	/* Try to set MPAM=1 */
+	val &= ~GENMASK_ULL(44, 40);
+	val |= FIELD_PREP(GENMASK_ULL(44, 40), 1);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
+	if (err) {
+		ksft_test_result_skip("ID_AA64PFR0.MPAM is not writable, nothing to test\n");
+		return;
+	}
+
+	/* Try to set MPAM=2 */
+	val &= ~GENMASK_ULL(43, 40);
+	val |= FIELD_PREP(GENMASK_ULL(43, 40), 2);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
+	if (err == -EPERM)
+		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM not arbitrarily modifiable\n");
+	else
+		ksft_test_result_fail("ID_AA64PFR0_EL1.MPAM value should not be ignored\n");
+}
+
 static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 {
 	bool done = false;
@@ -477,12 +527,13 @@ int main(void)
 		  ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
 		  ARRAY_SIZE(ftr_id_aa64mmfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) +
 		  ARRAY_SIZE(ftr_id_aa64mmfr2_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
-		  ARRAY_SIZE(test_regs);
+		  ARRAY_SIZE(test_regs) + MPAM_IDREG_TEST;
 
 	ksft_set_plan(ftr_cnt);
 
 	test_user_set_reg(vcpu, aarch64_only);
 	test_guest_reg_read(vcpu);
+	test_user_set_mpam_reg(vcpu);
 
 	kvm_vm_free(vm);
 
-- 
2.39.2

