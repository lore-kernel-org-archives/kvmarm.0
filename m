Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F1A23
	for <kvmarm@lists.linux.dev>; Sat, 11 Feb 2023 03:16:55 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id i17-20020a25be91000000b0082663f3eecbso6730172ybk.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Feb 2023 19:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1bRGCc7MsFaprXLfNHznGO5xVN7EZGAeKRB9FEt/wUQ=;
        b=r+Ek3hX5HBksVBYFXuT5LKRg8dSNAkGwYyYAp8KSlY0acF6zFiKZwoav9KeTkHV4o4
         p76qqJOVqItOR7W2SAPQIjc0ooBZNB0YNwcAVg5dXOGUTOaGM2Jztoq+2CS9lrhvoQzE
         dTfyRhNW7k8ti20TdZUYr9B7mOLpnccCGHmvKH4Mh9Q5fhjRTBi35o+actS9KUwVub7s
         EeCTdZTHQCde0WD9YMGfsqLY9WUsQp7T4RJnGhu3lbE/FHtDAoSR9bKjUxGvAmbzsvVT
         HtfrQasnLImte4XbphwEjipOcXymDZ9+AhQOkU43kXtLVOeAUqN7MEq4pO/FGiY/DacX
         aK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1bRGCc7MsFaprXLfNHznGO5xVN7EZGAeKRB9FEt/wUQ=;
        b=LtE0x+PTA3BVYV6PcyDDW0PRH49sVWZetiONEXZh58uPDV5WBP3kEDi6brfJ20Kq9O
         6F6klTJU1iwSKil3YBqQKkRZdL7ayu0QY9kd/d+iLII1n0F+vMHnDjq22rfJNLzz6TL9
         9EwdqGx78m2/6IMUc889rBvzapRlXFPxTuS3LnV3EBuXdxyDryn2e8S2TdyvWy4WeLq9
         FJ/kMC3XMPuGbclob+LzzFr3BZxAqKh0njcDK0I28J4/tWM61QLAAd8SJ9eF+3oKW6YR
         iWs5C5OjCKo9uCaVG50t4ozpaCTin8ngCtDNUQEJVvdrG8MEqqDBtpsWo/N89wVtLfxU
         nEgw==
X-Gm-Message-State: AO0yUKWYhtspptVcH4xcjfYZsg9U1Nob2JmQDlNGNJbO7p2w7H2PWFgu
	6lxoWKPM9/AypzxuhAhQTuJbNImU+JI=
X-Google-Smtp-Source: AK7set+3Dwf8ejvqUtrOGkBbqBbZmxC5JOSriu1PcqoRmSqOpks8B6IZauKSpnW2M+D407ZkXS+0ly2VO2s=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a5b:44d:0:b0:8ff:7d68:226f with SMTP id
 s13-20020a5b044d000000b008ff7d68226fmr183894ybp.575.1676085414690; Fri, 10
 Feb 2023 19:16:54 -0800 (PST)
Date: Fri, 10 Feb 2023 19:15:04 -0800
In-Reply-To: <20230211031506.4159098-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230211031506.4159098-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211031506.4159098-13-reijiw@google.com>
Subject: [PATCH v4 12/14] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce vpmu_counter_access test for arm64 platforms.
The test configures PMUv3 for a vCPU, sets PMCR_EL0.N for the vCPU,
and check if the guest can consistently see the same number of the
PMU event counters (PMCR_EL0.N) that userspace sets.
This test case is done with each of the PMCR_EL0.N values from
0 to 31 (With the PMCR_EL0.N values greater than the host value,
the test expects KVM_SET_ONE_REG for the PMCR_EL0 to fail).

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/aarch64/vpmu_counter_access.c         | 207 ++++++++++++++++++
 2 files changed, 208 insertions(+)
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
index 000000000000..7a4333f64dae
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vpmu_counter_access - Test vPMU event counter access
+ *
+ * Copyright (c) 2022 Google LLC.
+ *
+ * This test checks if the guest can see the same number of the PMU event
+ * counters (PMCR_EL0.N) that userspace sets.
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
+	pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
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
+ * Create a guest with one vCPU, set the PMCR_EL0.N for the vCPU to @pmcr_n,
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
+	/* Update the PMCR_EL0.N with @pmcr_n */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr = pmcr_orig & ~ARMV8_PMU_PMCR_N;
+	pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
+
+	run_vcpu(vcpu, pmcr_n);
+
+	/*
+	 * Reset and re-initialize the vCPU, and run the guest code again to
+	 * check if PMCR_EL0.N is preserved.
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
+ * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
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
+	/* Update the PMCR_EL0.N with @pmcr_n */
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr_orig);
+	pmcr = pmcr_orig & ~ARMV8_PMU_PMCR_N;
+	pmcr |= (pmcr_n << ARMV8_PMU_PMCR_N_SHIFT);
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
+ * the cycle counter (i.e. PMCR_EL0.N value) for the guest.
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
+	return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
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
+	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)
+		run_error_test(i);
+
+	return 0;
+}
-- 
2.39.1.581.gbfd45094c4-goog

