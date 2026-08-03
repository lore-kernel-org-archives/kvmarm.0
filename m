Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6E31F99B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 22:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785797067; cv=none; b=FRDngh2cHkg4n4nlpCYPnJgVnOVk+VpSBxZ/oZ1Cf+fSlNFnGcgwD5KC8V3HrV3hoOCDkl0k66jG0rZz9jggz2C3zPjF6ZVIt5cb4FJRcXNKJ4tKHKhwJ3AmUcw5sxSUW9eCGJxAvPr8MifoH8/isBYNb3YEtrumflR/i+VHutM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785797067; c=relaxed/simple;
	bh=PCr5cpmPf+veNxrj4rJAa+6GRLpruEL8NgY4HnQJEQA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VZcILw/y9rNe6X7hXSNh1XjFSx3fGglOauCMH+KHMJAOnfN+3BuuguoJV1qy5lBzu9drPrD/pjzahLJ4AVKqqKLpJcJ/SbEtm4J2EEDCaN5iDvvu+I3SrVmdE/aEsWkrg9mzc/Q7KM/LiHmMmFnWCtZBdb4HdGIzf6BYDZKfFk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EI93HF01; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EI93HF01"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f7872abb6so2351245f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 15:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785797062; x=1786401862; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ORq1MMsMB+S5/Yf0ZalUQTXOO2wZn1wi1Z58grOkl1A=;
        b=EI93HF01TBlCJYvrKh31o03G8EoanqOm2YZsH5+yAmz2kwrfbPUoFek7BfcBWMbUnu
         sbejNHVW+Fk70JPNt/uImAbGFmxyUVhk1b79BSAf62F8T9ibGqqg5TiFuK5qJS0TGmFL
         rVTd4ParNbuZWsFKLGyYChwLLDetWOjG9cxBuK+VhDN42mjt56uNeSE8MuEuBwHi/Z69
         VNL0AB73aQHicfyTHd/0qrGm2dbLz2jnyRxRXC8snkAAzcI4tDNeAGF+gWM7zVG9RVwo
         /68r3G36BSbOcvtQZdexjWYe81GKvGUYtVcDj7RNVJA6wiY+HcQ7Xmj/iDr2hQVEzyEb
         LAOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785797062; x=1786401862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ORq1MMsMB+S5/Yf0ZalUQTXOO2wZn1wi1Z58grOkl1A=;
        b=A42Mb4hSNS0n5DLTIAXtYRJKjwbAihnkhC9c/CPCNSCimhyZDkkcriLMQ8OX9iEUC3
         eJOVwb2PNyWBOh8URRRx2VzUGu6erA0DUoyuVBlqXDF87qdrdOjVRd1thnaqS4mfECnO
         EAHFDmtpRHDp8Vb4qCeWsypIRagFGuxzuot0r3F6evZL2oRzD5/3wXyzohoaGBTbVLZA
         cmyCOPzU4asawGiEjd/oGQM4+0w9hzw8nSeMjzmS7f/cV5jzKxffi1SB5MQjDAVjf0bo
         RcJvsgcmztcd5m80bb3EgMSap4OlGFt3pLTugSwciDneZHqDZsVBmQonQ90PZXeMQPzw
         q9DQ==
X-Forwarded-Encrypted: i=1; AHgh+RoG0GV2TQorRuJMvpmVACHBOCwN/bzYFJGVGYTDSQVOoCH3mmy8fxi8ftYK10y0nXKmWGs8BeE=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWtHXxIQzpm3QSYdET9CJK44dtKiTUm4XMmzoLIDp+am16jxlC
	/dApqHT0RRPjgu/6KmnA3gHMMAeGuOcS/aP7sVmojlURQ4hBY0tD6niM
X-Gm-Gg: AR+sD13lv/EXKlKF4gHA5RR3hugWbS4PftipvVSXi/RLbtRBJZ05gVJmwqhP2AE4HnD
	LAqqI/h57s3et4GDmsq760eZgrztIjm/DdTlliGdHxWg3Vip9ni+QHZwNpdvVEUTHzO7NxljSsD
	6xSb3dLwqGJyC+s8KshJdppR3a0MioEd/buryqbCaaWHfUfUVuqRliLoGmxTDZ3WTMn07dxOd6S
	EtTXisV0njWno9/qZqynsPfFSIQmBwiiXEaigBdakbuzdiz+V0g2OfY9RsVQaxmUDo0nZDFbaBg
	r6sjOUyPuUFsbYK3X7bPIsQJwoX3w1T56QAiWvVjNxOq3aUnKpq2jvAdWCXcSjXBgnXN/8c1oyG
	nzTEpuQ02R4ar+dz0+K8ekSsiQj31eXxGC9PrrjKZhZ5nYAoL8zgi7RAOtvjOMFRYdyLvL+jxT1
	bJzqW5uDYjcjvOC0aRDKq6daLrkiTB5ZlpbaSbO7r9xtEqwpipF8ahqbZX1bG3XjaptN6THaBBL
	FKfNssEv3k9lUF1HyvVvYF+kDXlA0eQYXN8tQtMRDAhh8lZhJ8FX/4yRCRMFwcrKJRwJrNN6BMs
	BtNSWvDzGqiTdGdaxioDDGPwhCrp/T9rYQ9S+nq3deMDViEicVJC9ARncmb4pdyCzwcW
X-Received: by 2002:a05:6000:18a7:b0:47f:6981:a043 with SMTP id ffacd0b85a97d-47fd72c3549mr28715538f8f.26.1785797061687;
        Mon, 03 Aug 2026 15:44:21 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b3d4-c101-2c67-9805-4069-c4eb.310.pool.telefonica.de. [2a02:3100:b3d4:c101:2c67:9805:4069:c4eb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd456a6cbsm32690944f8f.23.2026.08.03.15.44.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Aug 2026 15:44:21 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: selftests: Add a nested S2 MMU realloc test
Date: Tue,  4 Aug 2026 00:44:05 +0200
Message-Id: <20260803224405.41468-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260803224405.41468-1-kmehltretter@gmail.com>
References: <20260803224405.41468-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a regression test for a stale vcpu->arch.hw_mmu reference when
initialising a vCPU grows the nested S2 MMU table.

The test drives vCPU0 into L2 through a minimal L1 stage-2 identity map,
pins it to a second pCPU where it spins in L2, and then initialises
vCPU1.  That initialisation grows the nested MMU table while vCPU0 still
holds one of its entries; keeping vCPU0 on a pCPU of its own means the
reference stays live without relying on hw_mmu being retained across a
schedule-out.  vCPU0 is then released and has to run to completion.

Creating vCPU1 up front is what allows the in-kernel VGIC to be used:
kvm_arch_vcpu_precreate() refuses KVM_CREATE_VCPU once the VGIC has been
initialised, which the test does before its first KVM_RUN.  Creation on
its own increments online_vcpus, so deferring vCPU1's KVM_ARM_VCPU_INIT
until vCPU0 is in L2 still grows the table.

With KASAN enabled, an unfixed kernel reports a slab-use-after-free in
kvm_handle_guest_abort(); with the fix it completes cleanly.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---

The test requires nested virtualization and two pCPUs.  Under QEMU TCG
it takes ~233s, exceeding the 120s timeout in
tools/testing/selftests/kvm/settings; psci_test takes ~167s in the same
boot, so emulating the second vCPU is the dominant cost.

 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/arm64/nested_mmu_realloc_test.c       | 278 ++++++++++++++++++
 2 files changed, 279 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/nested_mmu_realloc_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6fc34e9bf8e1..222f37cbeec8 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -175,6 +175,7 @@ TEST_GEN_PROGS_arm64 += arm64/host_sve
 TEST_GEN_PROGS_arm64 += arm64/hypercalls
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
+TEST_GEN_PROGS_arm64 += arm64/nested_mmu_realloc_test
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
diff --git a/tools/testing/selftests/kvm/arm64/nested_mmu_realloc_test.c b/tools/testing/selftests/kvm/arm64/nested_mmu_realloc_test.c
new file mode 100644
index 000000000000..5eaf24106eee
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/nested_mmu_realloc_test.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Regression test for a stale vcpu->arch.hw_mmu pointer when the nested
+ * stage-2 MMU table grows while another vCPU is running in L2.  On affected
+ * kernels, KASAN detects the use-after-free on the first post-resize L2 exit.
+ */
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "ucall.h"
+
+#include <asm/ptrace.h>
+#include <asm/sysreg.h>
+#include <errno.h>
+#include <pthread.h>
+#include <sched.h>
+
+enum {
+	STAGE_L1_STARTED,
+	STAGE_L1_S2_READY,
+	STAGE_L2_ENTERED,
+};
+
+/* A 36-bit IPA and 1GB blocks give L1 a 64-entry stage-2 root table. */
+#define L1_S2_IPA_BITS		36
+#define L1_S2_BLOCK_SHIFT	30
+#define L1_S2_BLOCK_SIZE	BIT_ULL(L1_S2_BLOCK_SHIFT)
+#define L1_S2_ROOT_ENTRIES	BIT(L1_S2_IPA_BITS - L1_S2_BLOCK_SHIFT)
+#define L1_S2_SL0		1
+#define L1_S2_VTCR		(VTCR_EL2_RES1 |					\
+				 FIELD_PREP(VTCR_EL2_T0SZ, 64 - L1_S2_IPA_BITS) |	\
+				 FIELD_PREP(VTCR_EL2_SL0, L1_S2_SL0) |		\
+				 FIELD_PREP(VTCR_EL2_IRGN0, VTCR_EL2_IRGN0_WBWA) |	\
+				 FIELD_PREP(VTCR_EL2_ORGN0, VTCR_EL2_ORGN0_WBWA) |	\
+				 FIELD_PREP(VTCR_EL2_SH0, VTCR_EL2_SH0_INNER) |	\
+				 FIELD_PREP(VTCR_EL2_TG0, VTCR_EL2_TG0_4K) |		\
+				 FIELD_PREP(VTCR_EL2_PS, ID_AA64MMFR0_EL1_PARANGE_36))
+#define L1_S2_MEMATTR_NORMAL	(0xfULL << 2)
+#define L1_S2_S2AP_R		BIT(6)
+#define L1_S2_S2AP_W		BIT(7)
+#define L1_S2_BLOCK_DESC(pa)	(((pa) & GENMASK_ULL(47, L1_S2_BLOCK_SHIFT)) |	\
+				 L1_S2_MEMATTR_NORMAL | L1_S2_S2AP_R |		\
+				 L1_S2_S2AP_W | PTE_SHARED | PTE_AF | PTE_VALID)
+
+struct test_state {
+	u32 running;
+	u32 release;
+	u32 resumed;
+	u32 done;
+};
+
+struct vcpu_thread_args {
+	struct kvm_vcpu *vcpu;
+	int cpu;
+};
+
+#define copy_el2_to_el1(reg)						\
+	write_sysreg_s(read_sysreg_s(SYS_##reg##_EL1), SYS_##reg##_EL12)
+
+static void l2_guest(struct test_state *state)
+{
+	GUEST_ASSERT_EQ(get_current_el(), 1);
+	GUEST_SYNC(STAGE_L2_ENTERED);
+
+	WRITE_ONCE(state->running, 1);
+	while (!READ_ONCE(state->release))
+		cpu_relax();
+
+	WRITE_ONCE(state->resumed, 1);
+	while (!READ_ONCE(state->done))
+		cpu_relax();
+
+	GUEST_DONE();
+}
+
+static void l1_guest(u64 l2_pc, u64 state_gva, u64 s2_root_gpa)
+{
+	u64 sp;
+
+	GUEST_SYNC(STAGE_L1_STARTED);
+
+	copy_el2_to_el1(SCTLR);
+	copy_el2_to_el1(MAIR);
+	copy_el2_to_el1(TCR);
+	copy_el2_to_el1(TTBR0);
+	copy_el2_to_el1(TTBR1);
+
+	asm volatile("mov %0, sp" : "=r" (sp));
+	write_sysreg(sp, sp_el1);
+
+	write_sysreg(l2_pc, elr_el2);
+	write_sysreg(PSR_MODE_EL1h | PSR_D_BIT | PSR_A_BIT |
+		     PSR_I_BIT | PSR_F_BIT, spsr_el2);
+
+	write_sysreg(s2_root_gpa, vttbr_el2);
+	write_sysreg(L1_S2_VTCR, vtcr_el2);
+	isb();
+
+	GUEST_SYNC(STAGE_L1_S2_READY);
+
+	sysreg_clear_set(hcr_el2, HCR_EL2_TGE, HCR_EL2_VM);
+	isb();
+
+	asm volatile("mov x0, %0\n"
+		     "eret\n"
+		     :
+		     : "r" (state_gva)
+		     : "x0", "memory");
+
+	GUEST_ASSERT(0);
+}
+
+/* Sleep to avoid competing with the vCPU; the runner times out stalled tests. */
+static void wait_for_u32(u32 *ptr, u32 val)
+{
+	while (READ_ONCE(*ptr) != val)
+		usleep(1000);
+}
+
+static int pick_two_cpus(int *first_cpu, int *second_cpu)
+{
+	cpu_set_t allowed_mask;
+	int ret;
+
+	ret = sched_getaffinity(0, sizeof(allowed_mask), &allowed_mask);
+	TEST_ASSERT(!ret, "sched_getaffinity() failed, errno=%d", errno);
+
+	*first_cpu = -1;
+	*second_cpu = -1;
+
+	for (int cpu = 0; cpu < CPU_SETSIZE; cpu++) {
+		if (!CPU_ISSET(cpu, &allowed_mask))
+			continue;
+
+		if (*first_cpu < 0)
+			*first_cpu = cpu;
+		else
+			*second_cpu = cpu;
+
+		if (*second_cpu >= 0)
+			return 1;
+	}
+
+	return 0;
+}
+
+/* Mirror KVM's fallback from TGRAN4_2 to TGRAN4. */
+static bool l1_s2_supports_4k(struct kvm_vcpu *vcpu)
+{
+	u64 mmfr0 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR0_EL1));
+	u64 s2 = SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN4_2, mmfr0);
+
+	if (s2 == ID_AA64MMFR0_EL1_TGRAN4_2_TGRAN4)
+		return SYS_FIELD_GET(ID_AA64MMFR0_EL1, TGRAN4, mmfr0) !=
+		       ID_AA64MMFR0_EL1_TGRAN4_NI;
+
+	return s2 != ID_AA64MMFR0_EL1_TGRAN4_2_NI;
+}
+
+static void build_l1_s2_idmap(struct kvm_vm *vm, gpa_t root_gpa)
+{
+	u64 *root = addr_gpa2hva(vm, root_gpa);
+
+	for (int i = 0; i < L1_S2_ROOT_ENTRIES; i++)
+		root[i] = L1_S2_BLOCK_DESC((u64)i * L1_S2_BLOCK_SIZE);
+}
+
+static void run_to_sync_stage(struct kvm_vcpu *vcpu, u64 expected_stage)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT_EQ(uc.args[1], expected_stage);
+		return;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		return;
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+}
+
+static void *vcpu_thread_main(void *data)
+{
+	struct vcpu_thread_args *args = data;
+	struct kvm_vcpu *vcpu = args->vcpu;
+	struct ucall uc;
+
+	pin_self_to_cpu(args->cpu);
+
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		return NULL;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		return NULL;
+	default:
+		TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+	}
+}
+
+int main(void)
+{
+	struct vcpu_thread_args thread_args;
+	struct kvm_vcpu_init init;
+	struct test_state *state;
+	struct kvm_vcpu *vcpu0;
+	struct kvm_vcpu *vcpu1;
+	struct kvm_vm *vm;
+	pthread_t thread;
+	gva_t state_gva;
+	gpa_t s2_root_gpa;
+	int ctrl_cpu, vcpu_cpu, ret;
+
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_EL2));
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE) >= L1_S2_IPA_BITS);
+
+	TEST_REQUIRE(pick_two_cpus(&ctrl_cpu, &vcpu_cpu));
+	pin_self_to_cpu(ctrl_cpu);
+	pr_info("Running control thread on pCPU %d, vCPU thread on pCPU %d\n",
+		ctrl_cpu, vcpu_cpu);
+
+	vm = vm_create(2);
+
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+
+	vcpu0 = aarch64_vcpu_add(vm, 0, &init, l1_guest);
+	TEST_REQUIRE(l1_s2_supports_4k(vcpu0));
+
+	vcpu1 = __vm_vcpu_add(vm, 1);
+	state_gva = vm_alloc_page(vm);
+	state = addr_gva2hva(vm, state_gva);
+	*state = (struct test_state) {};
+	s2_root_gpa = vm_phy_page_alloc(vm, 0, vm->memslots[MEM_REGION_TEST_DATA]);
+	build_l1_s2_idmap(vm, s2_root_gpa);
+
+	vcpu_args_set(vcpu0, 3, (u64)l2_guest, state_gva, s2_root_gpa);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	run_to_sync_stage(vcpu0, STAGE_L1_STARTED);
+	run_to_sync_stage(vcpu0, STAGE_L1_S2_READY);
+	run_to_sync_stage(vcpu0, STAGE_L2_ENTERED);
+
+	thread_args = (struct vcpu_thread_args) {
+		.vcpu = vcpu0,
+		.cpu = vcpu_cpu,
+	};
+	ret = pthread_create(&thread, NULL, vcpu_thread_main, &thread_args);
+	TEST_ASSERT(!ret, "Failed to create vCPU thread, ret=%d", ret);
+
+	wait_for_u32(&state->running, 1);
+	pr_info("vCPU0 is running in L2; initializing vCPU1 to grow the table\n");
+
+	/*
+	 * vCPU0 holds a nested MMU while vCPU1 initialization grows the table.
+	 * vCPU1 was created before VGIC initialization because KVM_CREATE_VCPU is
+	 * refused afterwards.
+	 */
+	aarch64_vcpu_setup(vcpu1, &init);
+
+	pr_info("vCPU1 initialized; releasing vCPU0\n");
+	WRITE_ONCE(state->release, 1);
+	wait_for_u32(&state->resumed, 1);
+	pr_info("vCPU0 resumed after nested MMU resize\n");
+
+	WRITE_ONCE(state->done, 1);
+	ret = pthread_join(thread, NULL);
+	TEST_ASSERT(!ret, "pthread_join() failed, ret=%d", ret);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.39.5 (Apple Git-154)
