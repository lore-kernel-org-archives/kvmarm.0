Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CC42571B5
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 00:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740444863; cv=none; b=inAP9typyfxccLFj5GchMasqk+meD9hYfkJqBUlblNbMo1HlbQ/R1q5lmPGv00rHejxOnRyd6LhdyUuWalaNVMc0G8uFOKL2UUXJBfHm0e/Ar1VhdqriD31wGWIpK06Yf3SJnyGo2u0GowlYbyq6/OfRzyQ4GfKMaygU6JZEgRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740444863; c=relaxed/simple;
	bh=btRXhUbfY3VnoB1bkk/xk0XngXNGC/dCb+wVjook21I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TIHlcKIRUX7/HPf3e7gXxX5i+DKfJqB4RzXsJvVEKYfD8RDIn8+TmkKUVWbph/5dmSHWe+Nr/YDqjCf94Oyh6m6caNw0gYNltzQZmh7Zh7k28eV10ZfAJUwEkzyw9CfuWc/2Bst6nKfjt37BaujbGz8F9AHQpApF7K/zbKseX/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EPgCFlpm; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EPgCFlpm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740444860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqnBPTVa00M/qISjZis1yNBtPJ8pQAiKf7EYsfZTJFk=;
	b=EPgCFlpmrOpyQkKyyf1jBDw1X6iF6h1QCACIDU0OMJ2k+/rqCanehaJoGdO9V88iiDkZyw
	D95nzmrnJuv5RF3H4n3EaM93H87A2f5RDcZ58Yjjux8KnNBn4yZSWhgUJ+dhDJ14+jxpqw
	KHQXDhIdyFI3GW/at7Dz3jmJexbaBbk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sebastian Ott <sebott@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 5/5] KVM: selftests: arm64: Test writes to MIDR,REVIDR,AIDR
Date: Mon, 24 Feb 2025 16:54:01 -0800
Message-Id: <20250225005401.679536-6-oliver.upton@linux.dev>
In-Reply-To: <20250225005401.679536-1-oliver.upton@linux.dev>
References: <20250225005401.679536-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Sebastian Ott <sebott@redhat.com>

Assert that MIDR_EL1, REVIDR_EL1, AIDR_EL1 are writable from userspace,
that the changed values are visible to guests, and that they are
preserved across a vCPU reset.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/arm64/set_id_regs.c | 37 +++++++++++++++----
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 217541fe6536..1d65f4a09e6f 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -230,6 +230,9 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
 	GUEST_REG_SYNC(SYS_CTR_EL0);
+	GUEST_REG_SYNC(SYS_MIDR_EL1);
+	GUEST_REG_SYNC(SYS_REVIDR_EL1);
+	GUEST_REG_SYNC(SYS_AIDR_EL1);
 
 	GUEST_DONE();
 }
@@ -609,18 +612,31 @@ static void test_ctr(struct kvm_vcpu *vcpu)
 	test_reg_vals[encoding_to_range_idx(SYS_CTR_EL0)] = ctr;
 }
 
-static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
+static void test_id_reg(struct kvm_vcpu *vcpu, u32 id)
 {
 	u64 val;
 
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(id));
+	val++;
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(id), val);
+	test_reg_vals[encoding_to_range_idx(id)] = val;
+}
+
+static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
+{
 	test_clidr(vcpu);
 	test_ctr(vcpu);
 
-	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1));
-	val++;
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), val);
+	test_id_reg(vcpu, SYS_MPIDR_EL1);
+	ksft_test_result_pass("%s\n", __func__);
+}
+
+static void test_vcpu_non_ftr_id_regs(struct kvm_vcpu *vcpu)
+{
+	test_id_reg(vcpu, SYS_MIDR_EL1);
+	test_id_reg(vcpu, SYS_REVIDR_EL1);
+	test_id_reg(vcpu, SYS_AIDR_EL1);
 
-	test_reg_vals[encoding_to_range_idx(SYS_MPIDR_EL1)] = val;
 	ksft_test_result_pass("%s\n", __func__);
 }
 
@@ -647,6 +663,9 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	test_assert_id_reg_unchanged(vcpu, SYS_MPIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
 	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
+	test_assert_id_reg_unchanged(vcpu, SYS_MIDR_EL1);
+	test_assert_id_reg_unchanged(vcpu, SYS_REVIDR_EL1);
+	test_assert_id_reg_unchanged(vcpu, SYS_AIDR_EL1);
 
 	ksft_test_result_pass("%s\n", __func__);
 }
@@ -660,8 +679,11 @@ int main(void)
 	int test_cnt;
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_WRITABLE_IMP_ID_REGS));
 
-	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm = vm_create(1);
+	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
 
 	/* Check for AARCH64 only system */
 	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR0_EL1));
@@ -675,13 +697,14 @@ int main(void)
 		   ARRAY_SIZE(ftr_id_aa64isar2_el1) + ARRAY_SIZE(ftr_id_aa64pfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64pfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr0_el1) +
 		   ARRAY_SIZE(ftr_id_aa64mmfr1_el1) + ARRAY_SIZE(ftr_id_aa64mmfr2_el1) +
-		   ARRAY_SIZE(ftr_id_aa64zfr0_el1) - ARRAY_SIZE(test_regs) + 2 +
+		   ARRAY_SIZE(ftr_id_aa64zfr0_el1) - ARRAY_SIZE(test_regs) + 3 +
 		   MPAM_IDREG_TEST;
 
 	ksft_set_plan(test_cnt);
 
 	test_vm_ftr_id_regs(vcpu, aarch64_only);
 	test_vcpu_ftr_id_regs(vcpu);
+	test_vcpu_non_ftr_id_regs(vcpu);
 	test_user_set_mpam_reg(vcpu);
 
 	test_guest_reg_read(vcpu);
-- 
2.39.5

