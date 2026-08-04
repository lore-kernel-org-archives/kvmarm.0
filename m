Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8F43BDD5
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 09:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835481; cv=none; b=EKOCHkG8yOkkvsCnwSDYiJgg89XNGOErrqhPy8XrUOzYYbgh+3DAOMPDsYZHRFqfKc9sWLvV1QKvh85iqE0j1NKzeXTALjZnLpm2EXCbRzGM5BzEnaMIQLPutct5qREcrWetajbK4RFM6cqykERLqZw4FL4Lqf/ZrHQMp2BUiMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835481; c=relaxed/simple;
	bh=7FOYUIBswisjsxwONoRIeFiw1gKR8bWnbpGKCBD6vWk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lD7yNoLDvICLTsHmiDW0nHyKMufhhYtqBHaZc0IzTp9JrltdTKKDsi+qwT2zbTOka8YHrnoDTOafrEuHUtTh2k160PUaSlCxwWEBWp0zLKVlXJ5ExlCRzQoJfTAk6fbgODWGQgvyAbYhS38a0ZafGRbtZ783slUCwcljNHyHokI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bJJfzkrd; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bJJfzkrd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785835477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d6zoN+flJ4ZUzNrkimS+RY+Of6WNDF21txkvlime1Eg=;
	b=bJJfzkrdfdT2CJyukz9OYoDhbdu2tPpTQbNJhsgYwMCfN2aGh4a4dwyzX0HP7ohqH4pfMQ
	mwdw+i2NMNuJRXtidJvY+Sxo2vNMw7jBslLjzVTPbSsd+06witQfDXmWDW28x9yQnM+gYF
	yoALFABdD5v2kwPk/NHG9PipnJf24NQ=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: selftests: Check ID regs are immutable after a failed run
Date: Tue,  4 Aug 2026 10:24:21 +0100
Message-Id: <20260804092421.1728880-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a set_id_regs case covering ID register immutability when a vCPU's
first KVM_RUN fails after finalization but before
KVM_ARCH_FLAG_HAS_RAN_ONCE is set. The test provokes such a failure with
a PMUv3-enabled vCPU whose PMU is left uninitialized, then checks that
KVM_SET_ONE_REG on an ID register and KVM_CREATE_DEVICE for a vGIC are
both rejected with -EBUSY.

Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    This exercises the bug fixed by the KVM/arm64 ID register finalisation
    series and fails without it, so it should be applied on top of that
    series:
    
    https://lore.kernel.org/r/20260803-kvm-arm64-idreg-final-v2-0-d7d7e4efc640@kernel.org

 .../testing/selftests/kvm/arm64/set_id_regs.c | 92 ++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df56..f153d56b6e7f0 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -13,6 +13,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
+#include "vgic.h"
 #include <linux/bitfield.h>
 
 enum ftr_type {
@@ -803,6 +804,93 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
+/*
+ * ID registers must stay immutable even when a vCPU's first KVM_RUN fails
+ * after finalization but before KVM_ARCH_FLAG_HAS_RAN_ONCE is set.
+ */
+static void test_idreg_frozen_after_failed_run(void)
+{
+	u64 reg = 0, val = 0, new_val = 0;
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	bool found = false;
+	int r;
+
+	if (!kvm_has_cap(KVM_CAP_ARM_PMU_V3)) {
+		ksft_test_result_skip("%s (PMUv3 unsupported)\n", __func__);
+		return;
+	}
+
+	/*
+	 * Fail the first run after finalization: a PMUv3 vCPU left without PMU
+	 * init is rejected by kvm_arm_pmu_v3_enable(). Skip the default vGIC so
+	 * the KVM_CREATE_DEVICE gate can also be exercised.
+	 */
+	test_disable_default_vgic();
+
+	vm = vm_create(1);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	r = _vcpu_run(vcpu);
+	TEST_ASSERT(r < 0 && errno == EINVAL,
+		    "first KVM_RUN should fail post-finalization: r=%d errno=%d",
+		    r, errno);
+
+	/* Pick a field whose lower value would be accepted before finalization. */
+	for (int i = 0; i < ARRAY_SIZE(test_regs) && !found; i++) {
+		const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
+
+		reg = KVM_ARM64_SYS_REG(test_regs[i].reg);
+		val = vcpu_get_reg(vcpu, reg);
+
+		for (int j = 0; ftr_bits[j].type != FTR_END; j++) {
+			u64 ftr = (val & ftr_bits[j].mask) >> ftr_bits[j].shift;
+			u64 safe = get_safe_value(&ftr_bits[j], ftr);
+
+			/* Skip fields KVM re-derives itself, e.g. the GIC field. */
+			if (ftr_bits[j].mutable || safe == ftr)
+				continue;
+
+			new_val = (val & ~ftr_bits[j].mask) |
+				  (safe << ftr_bits[j].shift);
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		ksft_test_result_skip("%s (no immutable ID reg field to test)\n",
+				      __func__);
+		kvm_vm_free(vm);
+		return;
+	}
+
+	r = __vcpu_set_reg(vcpu, reg, new_val);
+	TEST_ASSERT(r < 0 && errno == EBUSY,
+		    "ID reg write after failed first run: r=%d errno=%d",
+		    r, errno);
+	TEST_ASSERT_EQ(vcpu_get_reg(vcpu, reg), val);
+
+	/* A write matching the finalized value is still accepted. */
+	r = __vcpu_set_reg(vcpu, reg, val);
+	TEST_ASSERT(!r, "matching ID reg write should be accepted: r=%d", r);
+
+	/* Creating an in-kernel irqchip after finalization must be rejected. */
+	if (kvm_supports_vgic_v3()) {
+		r = __kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3);
+		TEST_ASSERT(r < 0 && errno == EBUSY,
+			    "vGIC creation after failed first run: r=%d errno=%d",
+			    r, errno);
+	}
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("%s\n", __func__);
+}
+
 int main(void)
 {
 	struct kvm_vcpu *vcpu;
@@ -828,7 +916,7 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
+	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;
@@ -847,5 +935,7 @@ int main(void)
 
 	kvm_vm_free(vm);
 
+	test_idreg_frozen_after_failed_run();
+
 	ksft_finished();
 }
-- 
2.39.5

