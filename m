Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 905FC145A17
	for <kvmarm@lists.linux.dev>; Fri,  4 Oct 2024 11:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040057; cv=none; b=fTtHjcY0RazybbdIeWcP2zpd5oLRMI29h+kfbO4o4COEUZyOy1wfyGYF7Opo02OFc3o0pkqeZdFRH8t6Ne/7IORuUmShWQI+RkaedW5aLSo68WCa98tjq4BPsUrWPG0t0TZb+h2/xoUeZhTJsoE1VnkgHU4cpHUPECaQeHW9+p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040057; c=relaxed/simple;
	bh=7ArrqeheIeAENcSgTtsbglX7A+t6sTvBce+mm8xA4sM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=faPFgAEe2drX1eMGmnp3eWubacxslx3UNn161NsiFwdwcPq5HYOzgHEWFUbhm+WBR8SaUCpMk6khAF8ZpQ8DVu09AgHN4Lujdi5LmGrf3Tit5LrLRHgDfEWtCOBcUFMAnEr2ykC0esIpmZEN80D01/9UGKbyQU+Cd9aQYlWCk+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEB1E153B;
	Fri,  4 Oct 2024 04:08:04 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCECE3F640;
	Fri,  4 Oct 2024 04:07:33 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v4 7/7] KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely ignored
Date: Fri,  4 Oct 2024 12:07:14 +0100
Message-Id: <20241004110714.2051604-8-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241004110714.2051604-1-joey.gouly@arm.com>
References: <20241004110714.2051604-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

The ID_AA64PFR0.MPAM bit was previously accidentally exposed to guests,
and is ignored by KVM. KVM will always present the guest with 0 here,
and trap the MPAM system registers to inject an undef.

But, this value is still needed to prevent migration when the value
is incompatible with the target hardware. Add a kvm unit test to try
and write multiple values to ID_AA64PFR0.MPAM. Only the hardware value
previously exposed should be ignored, all other values should be
rejected.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 .../selftests/kvm/aarch64/set_id_regs.c       | 100 +++++++++++++++++-
 1 file changed, 99 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index 2a3fe7914b72..d985ead2cc45 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -433,6 +433,103 @@ static void test_vm_ftr_id_regs(struct kvm_vcpu *vcpu, bool aarch64_only)
 	}
 }
 
+#define MPAM_IDREG_TEST	6
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
+	idx = encoding_to_range_idx(SYS_ID_AA64PFR0_EL1);
+	ftr_mask = ID_AA64PFR0_EL1_MPAM_MASK;
+	if ((masks[idx] & ftr_mask) == ftr_mask) {
+		ksft_test_result_skip("ID_AA64PFR0_EL1.MPAM is officially writable, nothing to test\n");
+		return;
+	}
+
+	/* Get the id register value */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), &val);
+
+	/* Try to set MPAM=0. This should always be possible. */
+	val &= ~GENMASK_ULL(44, 40);
+	val |= FIELD_PREP(GENMASK_ULL(44, 40), 0);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
+	if (err)
+		ksft_test_result_fail("ID_AA64PFR0_EL1.MPAM=0 was not accepted\n");
+	else
+		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM=0 worked\n");
+
+	/* Try to set MPAM=1 */
+	val &= ~GENMASK_ULL(44, 40);
+	val |= FIELD_PREP(GENMASK_ULL(44, 40), 1);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
+	if (err)
+		ksft_test_result_skip("ID_AA64PFR0_EL1.MPAM is not writable, nothing to test\n");
+	else
+		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM=1 was writable\n");
+
+	/* Try to set MPAM=2 */
+	val &= ~GENMASK_ULL(43, 40);
+	val |= FIELD_PREP(GENMASK_ULL(43, 40), 2);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1), val);
+	if (err)
+		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM not arbitrarily modifiable\n");
+	else
+		ksft_test_result_fail("ID_AA64PFR0_EL1.MPAM value should not be ignored\n");
+
+	/* And again for ID_AA64PFR1_EL1.MPAM_frac */
+	idx = encoding_to_range_idx(SYS_ID_AA64PFR1_EL1);
+	ftr_mask = ID_AA64PFR1_EL1_MPAM_frac_MASK;
+	if ((masks[idx] & ftr_mask) == ftr_mask) {
+		ksft_test_result_skip("ID_AA64PFR1_EL1.MPAM_frac is officially writable, nothing to test\n");
+		return;
+	}
+
+	/* Get the id register value */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), &val);
+
+	/* Try to set MPAM_frac=0. This should always be possible. */
+	val &= ~GENMASK_ULL(19, 16);
+	val |= FIELD_PREP(GENMASK_ULL(19, 16), 0);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), val);
+	if (err)
+		ksft_test_result_fail("ID_AA64PFR0_EL1.MPAM_frac=0 was not accepted\n");
+	else
+		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM_frac=0 worked\n");
+
+	/* Try to set MPAM_frac=1 */
+	val &= ~GENMASK_ULL(19, 16);
+	val |= FIELD_PREP(GENMASK_ULL(19, 16), 1);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), val);
+	if (err)
+		ksft_test_result_skip("ID_AA64PFR1_EL1.MPAM_frac is not writable, nothing to test\n");
+	else
+		ksft_test_result_pass("ID_AA64PFR0_EL1.MPAM_frac=1 was writable\n");
+
+	/* Try to set MPAM_frac=2 */
+	val &= ~GENMASK_ULL(19, 16);
+	val |= FIELD_PREP(GENMASK_ULL(19, 16), 2);
+	err = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1), val);
+	if (err)
+		ksft_test_result_pass("ID_AA64PFR1_EL1.MPAM_frac not arbitrarily modifiable\n");
+	else
+		ksft_test_result_fail("ID_AA64PFR1_EL1.MPAM_frac value should not be ignored\n");
+}
+
 static void test_guest_reg_read(struct kvm_vcpu *vcpu)
 {
 	bool done = false;
@@ -571,12 +668,13 @@ int main(void)
 		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64mmfr0_el1) + ARRAY_SIZE(ftr_id_aa64mmfr1_el1) +
 		   ARRAY_SIZE(ftr_id_aa64mmfr2_el1) + ARRAY_SIZE(ftr_id_aa64zfr0_el1) -
-		   ARRAY_SIZE(test_regs) + 2;
+		   ARRAY_SIZE(test_regs) + 2 + MPAM_IDREG_TEST;
 
 	ksft_set_plan(test_cnt);
 
 	test_vm_ftr_id_regs(vcpu, aarch64_only);
 	test_vcpu_ftr_id_regs(vcpu);
+	test_user_set_mpam_reg(vcpu);
 
 	test_guest_reg_read(vcpu);
 
-- 
2.25.1

