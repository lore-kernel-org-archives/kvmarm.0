Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208B551AEDE;
	Tue, 29 Sep 2026 11:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790683120; cv=none; b=dAGpqhi9DwgZih0BR504C/cXm8nU8x/RFwg7mwDMEBUKD/4WasAGs8FMKN1XyzbRsUIHPYjWnuMCq3mbo8hzS+l2VIXXY4w/yUxQGz52OJBM2fCVuAIUkTC1CsJOEcIJLaOI9LEIoE00TBjpOikhEtOB6EgUZlE510hF++5QKD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790683120; c=relaxed/simple;
	bh=21OENh3wiuy2hkOt0sg1kbEyd5xBBJKJst+cyHiOzf0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=j1C9jjR6XSnGx1tudcPWgA4Ea6dSaBlfLbUDkEmgrNM+Ds1s2wBRi4BFhtyKKVJLk1vKYOCRMYESM4TDGOAf21DBga/AxsNwfbtIe+/isQFkm3I33k31mTZxTWBG/nnGg4VhX3vI0Z8IRqRDUzqL5HFSVJwu0cWeSeFtsIwY2dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJ+Ri+Jj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJ+Ri+Jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B221F000FF;
	Tue, 29 Sep 2026 11:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790683118;
	bh=/aHhaa9iwWLj4k3qkP/UV/W0Eq2e/p8sJav6sO7R2Kg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oJ+Ri+JjhGVh3jkGb6ij7D1qQx//rs5djlnS9ak2YkJ+YCnyVoiTGE2CQ0Vu+DaKN
	 6wKeofZEicCqmr/gugcvKVk6Ys4kKAm2+ttppmxvemXcAiDM3zmgsGTpnaF4xx8ywh
	 LhKJ5ZHTxJ28dJ7QiX6fgXIyZMM4qfwZdzEzd+rDipcKwGMwpN1tWXagpWE4jFIw+C
	 eeyJ7dMIZf2Vte5fiedIdCTsEuVBYDP7Cf4mBNufrS4bqe4VlD47PvkPnhmxHlylrI
	 39tamqwoirSfbucw0G+cfn6ZVoyZhth559zChQoZcJA+5X4Cfef5rQapOwl978GCId
	 48xI6APAdIKiQ==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 29 Sep 2026 12:58:00 +0100
Subject: [PATCH v4 3/3] KVM: arm64: selftests: Check ID regs are immutable
 after a failed run
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-kvm-arm64-idreg-final-v4-3-75296dde994d@kernel.org>
References: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
In-Reply-To: <20260929-kvm-arm64-idreg-final-v4-0-75296dde994d@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5225; i=broonie@kernel.org;
 h=from:subject:message-id; bh=ARpusrkiKBa7FifX/OtnNfFMe6PS+8J/LSSKLcTpZEw=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqu6fg/oLBcwiuYcHLVB5M28oUJNC6iWq+STB8r
 RodK8DO1VaJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCarun4AAKCRAk1otyXVSH
 0EYqB/9lW9ImwLWPPu8fCnJQVG72KrXPFpqGOywDtAFEBGRjWmrMgdiw9u1GYvHuHmXPYyvtF35
 Jo0zgM0KqNAD4X/+K/vPW9iMZCyitItu/+mcRWM6qoB9JBv9xxT4QE5xoheZfhmeiKkx3uPeV+a
 X3k8Vt7OTp1LjlNPC5LcytxZFTdevKJVEIhA11ZY8FiPY0XNd9lZE+M1+/nN3s3FuWkAxqERLqQ
 pYqGxFViXbLeW16wyofXXmktUlrrNJaRTYOqLG3wvdb9EuBLiqaeo+rtgUVH1vdjslDqHzuqIKZ
 snnSyKMygjIFe5Jp465/qkxvh0qe0cMVM6D7bh/M0QgsfcI9
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Fuad Tabba <fuad.tabba@linux.dev>

Add a set_id_regs case covering ID register immutability when a vCPU's
first KVM_RUN fails after finalization but before
KVM_ARCH_FLAG_HAS_RAN_ONCE is set. The test provokes such a failure with
a PMUv3-enabled vCPU whose PMU is left uninitialized, then checks that
KVM_SET_ONE_REG on the feature and implementation ID registers, and
KVM_CREATE_DEVICE for a vGIC, are all rejected with -EBUSY.

Assisted-by: LLM
[Fixed for latest tag standard -- broonie]
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260805064740.3013538-1-fuad.tabba@linux.dev
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 106 +++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df5..10849d21c0dd 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -13,6 +13,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
+#include "vgic.h"
 #include <linux/bitfield.h>
 
 enum ftr_type {
@@ -803,6 +804,107 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 	ksft_test_result_pass("%s\n", __func__);
 }
 
+/*
+ * ID registers must stay immutable even when a vCPU's first KVM_RUN fails
+ * after finalization but before KVM_ARCH_FLAG_HAS_RAN_ONCE is set.
+ */
+static void test_idreg_frozen_after_failed_run(void)
+{
+	static const u32 imp_id_regs[] = {
+		SYS_MIDR_EL1,
+		SYS_REVIDR_EL1,
+		SYS_AIDR_EL1,
+	};
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int r;
+
+	if (!kvm_has_cap(KVM_CAP_ARM_PMU_V3)) {
+		ksft_print_msg("PMUv3 unsupported, cannot fail the first run\n");
+		ksft_test_result_skip("%s\n", __func__);
+		return;
+	}
+
+	/* Skip the default vGIC so the KVM_CREATE_DEVICE gate is reachable. */
+	test_disable_default_vgic();
+
+	vm = vm_create(1);
+	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	/*
+	 * A PMUv3 vCPU left without PMU init is rejected by
+	 * kvm_arm_pmu_v3_enable(), which runs after sysreg finalization.
+	 */
+	r = _vcpu_run(vcpu);
+	TEST_ASSERT(r < 0 && errno == EINVAL,
+		    "first KVM_RUN should fail post-finalization: r=%d errno=%d",
+		    r, errno);
+
+	/*
+	 * Feature ID registers: use values that would have been accepted before
+	 * finalization, so that a rejection means the registers are final
+	 * rather than the value being invalid.
+	 */
+	for (int i = 0; i < ARRAY_SIZE(test_regs); i++) {
+		const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
+		u64 reg = KVM_ARM64_SYS_REG(test_regs[i].reg);
+		u64 val = vcpu_get_reg(vcpu, reg);
+
+		for (int j = 0; ftr_bits[j].type != FTR_END; j++) {
+			u64 ftr = (val & ftr_bits[j].mask) >> ftr_bits[j].shift;
+			u64 safe = get_safe_value(&ftr_bits[j], ftr);
+			u64 new_val;
+
+			if (safe == ftr)
+				continue;
+
+			new_val = (val & ~ftr_bits[j].mask) |
+				  (safe << ftr_bits[j].shift);
+
+			r = __vcpu_set_reg(vcpu, reg, new_val);
+			TEST_ASSERT(r < 0 && errno == EBUSY,
+				    "%s write after failed first run: r=%d errno=%d",
+				    ftr_bits[j].name, r, errno);
+			TEST_ASSERT_EQ(vcpu_get_reg(vcpu, reg), val);
+		}
+
+		/* A write matching the finalized value is still accepted. */
+		vcpu_set_reg(vcpu, reg, val);
+	}
+
+	/*
+	 * The VM-wide implementation ID registers are gated separately. Bit 0
+	 * is within the writable mask of all three, so flipping it is a change
+	 * KVM would otherwise accept.
+	 */
+	for (int i = 0; i < ARRAY_SIZE(imp_id_regs); i++) {
+		u64 reg = KVM_ARM64_SYS_REG(imp_id_regs[i]);
+		u64 val = vcpu_get_reg(vcpu, reg);
+
+		r = __vcpu_set_reg(vcpu, reg, val ^ 1);
+		TEST_ASSERT(r < 0 && errno == EBUSY,
+			    "implementation ID reg write after failed first run: r=%d errno=%d",
+			    r, errno);
+		TEST_ASSERT_EQ(vcpu_get_reg(vcpu, reg), val);
+	}
+
+	/* Creating an in-kernel irqchip would change the ID registers too. */
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
@@ -828,7 +930,7 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
+	test_cnt = 4 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;
@@ -847,5 +949,7 @@ int main(void)
 
 	kvm_vm_free(vm);
 
+	test_idreg_frozen_after_failed_run();
+
 	ksft_finished();
 }

-- 
2.47.3

