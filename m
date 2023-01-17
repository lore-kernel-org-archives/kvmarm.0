Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892BA15A0
	for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 01:38:53 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id x8-20020a17090a8a8800b0022941842cc0so5318979pjn.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Jan 2023 17:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V9Xdlz5TADTAdGDo/JsJp+XJkTXco9QFzQliqe+E4CA=;
        b=meU+gSSBML0kyeAmNCiSryFqm3DQl4uHU5HeiGkk+xA91l36K+LRriYS+VpZtEil6U
         ozUr987lUi0E/Q7Ya0hhUwEnROtIt1ntc0WiHDkFwtTuEHHAOEFPm0jGpmsweRIu8DpZ
         fuDUB7Q8f0vAs1vFNasM53zLKZD5Vk3oKLYKwPdQETfTtX2gdpBb5PY4WLc7FM5MnaeO
         rDwYfKBUKlZppg9JEGlOv2E3taLpy5Do+X7zrf3zFMjTO7r3zJZB/JO/cozwEbBELV0r
         JF9xY80jGEwptMo03oZWsHRwHBSDRGmuqLHdrGNusBHsjQtXK2BuykvPOCAPIG+Pjy2e
         Z1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V9Xdlz5TADTAdGDo/JsJp+XJkTXco9QFzQliqe+E4CA=;
        b=6pu2o668frUPN5pqwjQEpCqzW51vM4nR6t2cuJh2RJZin+6HuQYsZY9FpNj9k1D7Sz
         xruG0aGvfXzJ1cu3KMXz5K3uEbwVd2C4Gc/1gq5uwGXWQBNToixGgdhUKMY8Z4XJvLGA
         pKreaSKJBFuJLFPdkr2dDOAQIlLHJ/rq8Lkv10NlNX2YSmfuAs3zd3dhKaK5B0jZBM0/
         XFRPkQDMdrOADiDmkEZs7XC0O05CjA91X/bggcUA9eTY47+l4zdsVaxL7OUdA4cvv9vH
         nSAPrZr5EZBwpm2C4Abdh9K5T4HNxE7y/t07KtBnq8kr/C4QqWBoc1STHPbR3Q2NkXwH
         W10A==
X-Gm-Message-State: AFqh2krJ5n6kc8h6fUuc9j9dopZeVGS+mPRGST9hOR2u3FMO399FbDfW
	N0uvs9g+Nar5DzsMKN53vPFiEGoeq9g=
X-Google-Smtp-Source: AMrXdXtTUTubURR3mIjnRFcUYcBmgHTDjj2M7nhKtx2Ovq/uajWaFO0i17CcnIbF7gKr97VufeezGslkKSA=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:c16:0:b0:4ce:53ac:6161 with SMTP id
 b22-20020a630c16000000b004ce53ac6161mr55737pgl.348.1673919533056; Mon, 16 Jan
 2023 17:38:53 -0800 (PST)
Date: Mon, 16 Jan 2023 17:35:40 -0800
In-Reply-To: <20230117013542.371944-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117013542.371944-7-reijiw@google.com>
Subject: [PATCH v2 6/8] KVM: selftests: aarch64: Introduce vpmu_counter_access test
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce vpmu_counter_access test for arm64 platforms.
The test configures PMUv3 for a vCPU, sets PMCR_EL1.N for the vCPU,
and check if the guest can consistently see the same number of the
PMU event counters (PMCR_EL1.N) that userspace sets.
This test case is done with each of the PMCR_EL1.N values from
0 to 31 (With the PMCR_EL1.N values greater than the host value,
the test expects KVM_SET_ONE_REG for the PMCR_EL1 to fail).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 212 ++++++++++++++++++
 2 files changed, 213 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd936..b27fea0ce591 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -143,6 +143,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
new file mode 100644
index 000000000000..704a2500b7e1
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vpmu_counter_access - Test vPMU event counter access
+ *
+ * Copyright (c) 2022 Google LLC.
+ *
+ * This test checks if the guest can see the same number of the PMU event
+ * counters (PMCR_EL1.N) that userspace sets.
+ * This test runs only when KVM_CAP_ARM_PMU_V3 is supported on the host.
+ */
+#include <kvm_util.h>
+#include <processor.h>
+#include <test_util.h>
+#include <vgic.h>
+#include <asm/perf_event.h>
+#include <linux/bitfield.h>
+
+/* The max number of the PMU event counters (excluding the cycle counter) */
+#define ARMV8_PMU_MAX_GENERAL_COUNTERS	(ARMV8_PMU_MAX_COUNTERS - 1)
+
+static uint64_t pmcr_extract_n(uint64_t pmcr_val)
+{
+	return (pmcr_val >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+}
+
+/*
+ * The guest is configured with PMUv3 with @expected_pmcr_n number of
+ * event counters.
+ * Check if @expected_pmcr_n is consistent with PMCR_EL0.N.
+ */
+static void guest_code(uint64_t expected_pmcr_n)
+{
+	uint64_t pmcr, pmcr_n;
+
+	GUEST_ASSERT(expected_pmcr_n <= ARMV8_PMU_MAX_GENERAL_COUNTERS);
+
+	pmcr = read_sysreg(pmcr_el0);
+	pmcr_n = pmcr_extract_n(pmcr);
+
+	/* Make sure that PMCR_EL0.N indicates the value userspace set */
+	GUEST_ASSERT_2(pmcr_n == expected_pmcr_n, pmcr_n, expected_pmcr_n);
+
+	GUEST_DONE();
+}
+
+#define GICD_BASE_GPA	0x8000000ULL
+#define GICR_BASE_GPA	0x80A0000ULL
+
+/* Create a VM that has one vCPU with PMUv3 configured. */
+static struct kvm_vm *create_vpmu_vm(void *guest_code, struct kvm_vcpu **vcpup,
+				     int *gic_fd)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu_init init;
+	uint8_t pmuver;
+	uint64_t dfr0, irq = 23;
+	struct kvm_device_attr irq_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_IRQ,
+		.addr = (uint64_t)&irq,
+	};
+	struct kvm_device_attr init_attr = {
+		.group = KVM_ARM_VCPU_PMU_V3_CTRL,
+		.attr = KVM_ARM_VCPU_PMU_V3_INIT,
+	};
+
+	vm = vm_create(1);
+
+	/* Create vCPU with PMUv3 */
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	*gic_fd = vgic_v3_setup(vm, 1, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+
+	/* Make sure that PMUv3 support is indicated in the ID register */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64DFR0_EL1), &dfr0);
+	pmuver = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_PMUVER), dfr0);
+	TEST_ASSERT(pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
+		    pmuver >= ID_AA64DFR0_PMUVER_8_0,
+		    "Unexpected PMUVER (0x%x) on the vCPU with PMUv3", pmuver);
+
+	/* Initialize vPMU */
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &irq_attr);
+	vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &init_attr);
+
+	*vcpup = vcpu;
+	return vm;
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu, uint64_t pmcr_n)
+{
+	struct ucall uc;
+
+	vcpu_args_set(vcpu, 1, pmcr_n);
+	vcpu_run(vcpu);
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT_2(uc, "values:%#lx %#lx");
+		break;
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		break;
+	}
+}
+
+/*
+ * Create a guest with one vCPU, set the PMCR_EL1.N for the vCPU to @pmcr_n,
+ * and run the test.
+ */
+static void run_test(uint64_t pmcr_n)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+	uint64_t sp, pmcr, pmcr_orig;
+	struct kvm_vcpu_init init;
+
+	pr_debug("Test with pmcr_n %lu\n", pmcr_n);
+	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
+
+	/* Save the initial sp to restore them later to run the guest again */
+	vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
+
+	/* Update the PMCR_EL1.N with @pmcr_n */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr = pmcr_orig & ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr |= (pmcr_n & ARMV8_PMU_PMCR_N_MASK) << ARMV8_PMU_PMCR_N_SHIFT;
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	/*
+	 * Reset and re-initialize the vCPU, and run the guest code again to
+	 * check if PMCR_EL1.N is preserved.
+	 */
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
+/*
+ * Create a guest with one vCPU, and attempt to set the PMCR_EL1.N for
+ * the vCPU to @pmcr_n, which is larger than the host value.
+ * The attempt should fail as @pmcr_n is too big to set for the vCPU.
+ */
+static void run_error_test(uint64_t pmcr_n)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd, ret;
+	uint64_t pmcr, pmcr_orig;
+
+	pr_debug("Error test with pmcr_n %lu (larger than the host)\n", pmcr_n);
+	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
+
+	/* Update the PMCR_EL1.N with @pmcr_n */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr = pmcr_orig & ~(ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr |= (pmcr_n & ARMV8_PMU_PMCR_N_MASK) << ARMV8_PMU_PMCR_N_SHIFT;
+
+	/* This should fail as @pmcr_n is too big to set for the vCPU */
+	ret = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+	TEST_ASSERT(ret, "Setting PMCR to 0x%lx (orig PMCR 0x%lx) didn't fail",
+		    pmcr, pmcr_orig);
+
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
+/*
+ * Return the default number of implemented PMU event counters excluding
+ * the cycle counter (i.e. PMCR_EL1.N value) for the guest.
+ */
+static uint64_t get_pmcr_n_limit(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	int gic_fd;
+	uint64_t pmcr;
+
+	vm = create_vpmu_vm(guest_code, &vcpu, &gic_fd);
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
+	close(gic_fd);
+	kvm_vm_free(vm);
+	return pmcr_extract_n(pmcr);
+}
+
+int main(void)
+{
+	uint64_t i, pmcr_n;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PMU_V3));
+
+	pmcr_n = get_pmcr_n_limit();
+	for (i = 0; i <= pmcr_n; i++)
+		run_test(i);
+
+	for (i = pmcr_n + 1; i < ARMV8_PMU_PMCR_N_MASK; i++)
+		run_error_test(i);
+
+	return 0;
+}
-- 
2.39.0.314.g84b9a713c41-goog

