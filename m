Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2990B2DC32D
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995730; cv=none; b=Pz/zzOzjGUx25rJgJ5cDBMOlCgl1Asn07ONOFL6LT7k3Ufo5wAVADYHNmdfF8HyM0av+CrymCltEcQm3HNugYlclbC8xpg7JLUqzrSRZ899kcFeI0EA0aKyVMpIQ0X2Q4061+eaDGBYF7N8wOaQKy+WQLfmcjkM5MJgK3ZaLs/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995730; c=relaxed/simple;
	bh=GlTMA58L1Mya9RBcuI11PLDMkjF/olewW1CaZC3iQjk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mcbZDARI3z+PUcsRPsvqaPD1E/4hY5BkzMcHxQOZJBcS3OOJheks+6NHsEEyXJ+PPv/NuM5o3xYxdiEda8ZUJSQCEIDKpl4Zb0ixLGt4jMnNcNk6HoFc8aOHxZEL08PmLNwqRKrp6LcU4R/Kr/opO5KMPt2WBI3C3kPqsZydE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w9Ozc6rr; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w9Ozc6rr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751995724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+C8PDzj/94kFZTJM1b9ZF5SImggYJZ37ezi6in8+doM=;
	b=w9Ozc6rrTLnwemct+EhjIIElzman2vwvGEslZq9zwmX0dCmhKpKf4Zx2YhEuYTfBHM6iZ3
	JMKZZ8RLH4fP5u3kESuO7GrxQnS6UoOph4TtUxj4WRHafNU/zHGV1M2ZHE506urC7fGP3S
	mToPg+EEH6AC4M7GVlsTQDZnzQKQtPY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 25/27] KVM: arm64: selftests: Test SEAs are taken to SError vector when EASE=1
Date: Tue,  8 Jul 2025 10:25:30 -0700
Message-Id: <20250708172532.1699409-26-oliver.upton@linux.dev>
In-Reply-To: <20250708172532.1699409-1-oliver.upton@linux.dev>
References: <20250708172532.1699409-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ensure KVM routes SEAs to the correct vector depending on
SCTLR2_EL1.EASE.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/arm64/external_aborts.c     | 42 ++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/external_aborts.c b/tools/testing/selftests/kvm/arm64/external_aborts.c
index f49c98bda60e..ec7e30776a0e 100644
--- a/tools/testing/selftests/kvm/arm64/external_aborts.c
+++ b/tools/testing/selftests/kvm/arm64/external_aborts.c
@@ -86,7 +86,7 @@ static void vcpu_run_expect_sync(struct kvm_vcpu *vcpu)
 
 extern char test_mmio_abort_insn;
 
-static void test_mmio_abort_guest(void)
+static noinline void test_mmio_abort_guest(void)
 {
 	WRITE_ONCE(expected_abort_pc, (u64)&test_mmio_abort_insn);
 
@@ -251,6 +251,45 @@ static void test_serror_emulated(void)
 	kvm_vm_free(vm);
 }
 
+static void test_mmio_ease_guest(void)
+{
+	sysreg_clear_set_s(SYS_SCTLR2_EL1, 0, SCTLR2_EL1_EASE);
+	isb();
+
+	test_mmio_abort_guest();
+}
+
+/*
+ * Test that KVM doesn't complete MMIO emulation when userspace has made an
+ * external abort pending for the instruction.
+ */
+static void test_mmio_ease(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm = vm_create_with_dabt_handler(&vcpu, test_mmio_ease_guest,
+							unexpected_dabt_handler);
+	struct kvm_run *run = vcpu->run;
+	u64 pfr1;
+
+	pfr1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64PFR1_EL1));
+	if (!SYS_FIELD_GET(ID_AA64PFR1_EL1, DF2, pfr1)) {
+		pr_debug("Skipping %s\n", __func__);
+		return;
+	}
+
+	vm_install_exception_handler(vm, VECTOR_ERROR_CURRENT, expect_serror_handler);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
+	TEST_ASSERT_EQ(run->mmio.phys_addr, MMIO_ADDR);
+	TEST_ASSERT_EQ(run->mmio.len, sizeof(unsigned long));
+	TEST_ASSERT(!run->mmio.is_write, "Expected MMIO read");
+
+	vcpu_inject_sea(vcpu);
+	vcpu_run_expect_done(vcpu);
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
 	test_mmio_abort();
@@ -259,4 +298,5 @@ int main(void)
 	test_serror();
 	test_serror_masked();
 	test_serror_emulated();
+	test_mmio_ease();
 }
-- 
2.39.5

