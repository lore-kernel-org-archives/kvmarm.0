Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782172;
	b=vt8/SwGL1ji4kJXnDKo+gk2iZPcPQb/aTZ8jHADApX85YYjcrw8fUx0b8e+ey/Lflvrz
	 3rnrJOO8khdgHW3VUhgT2bT72ksyZP4DI6Slsevg7/y1W0fyg7WuIFyWXiwlMXA8k67he
	 3Cjg739/8yzhfdgka4TRmIFg8SRYTAOQ88ACGNEYN1607VukDyI5c/TigpCPAj0m9ABWS
	 N/Hh5icvefhEudNpVvHOUmuU5HPh+TKqs7/mQzxOYF8wLYBEbv46yOFEh01nOom1KYNXw
	 loktHFMnjUtEfA+AZ77JWd0a2AFpwgfhu69Jq+KHOFO475c0ZrWtxNkNvg5noBATpnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782172;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=fXckVuM7RaL3vAISdFICw8d6jiW10JSmut7/AhMvdqs=;
	b=ZZjjjqnhMY0GQe4B8LNmBGdQr4sbqGdTSTbfwH3cApGMILuBaI0tQZXFzpPCaWy7Wngv
	 5VvMxPSYASc8ARozfLX7rs7zw2/h1m0g5x9s3+IaunWTAv04qCtKmcd3jOB2et2uLp4QR
	 PH9jH5mKQPvO0tlM13dJmLrqjxux7CATK7zQwV8qDobcvZyL2BCbNxlsn8FOVDibS3t0K
	 Wmn+ElNAoLvGzS49xIQPuxlspukzrykYJ7VNNi0wgNEjVAAzvvoLSRLiGi/gHvL66vlk3
	 vOVOQgEajOgRx/5CQlfTf0DUQmQ8F4B21mnUlOlhPr7hMaS0fe46eE1ztjmPcgFSeFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="Bmi5/f6S";
	arc=none smtp.remote-ip=91.218.175.15
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F085B606A330
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 08:49:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F085B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bmi5/f6S
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XtKAON2Tjg7NFUD3TDSRQSXaWa+jqo87MeCRw1tGi3Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793782169; v=1; x=1794386969;
 b=Bmi5/f6SoeNeXr+JJRI4aa7ztoTGGbUUs2aU5aVhYRU+HfullhddUlOgXqO0wIDsuWETH1F9
 zlTmyr7mlD/iQDs0xzWcuoxrt0CIY89BAzPBVzlOvQ6LnFf+SCk03mo7EKx92eL/pXjGwfpieMt
 2s7EXvbKCQ6EKuWe12CNbjAk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 851548b294a71f75;
	Wed, 04 Nov 2026 08:49:29 +0000
X-Mizu-Trace-ID: 851548b294a71f75
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] KVM: arm64: selftests: Add pkvm_host_abi host-interface test
Date: Wed,  4 Nov 2026 08:48:33 +0000
Message-ID: <20261104084842.132944-8-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104084842.132944-1-fuad.tabba@linux.dev>
References: <20261104084842.132944-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The host isn't trusted with a protected guest's state, so once a
protected vCPU has run, KVM rejects the ioctls that would read or change
that state. The host can still inject a virtual SError and read back
whether one is pending. The VM gets only the capabilities and vCPU
features pKVM supports.

Check what the host's KVM interface allows and rejects for a protected
VM, before and after the first run, and that the host accounts the VM's
memory as locked until the VM is freed.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/pkvm_host_abi.c       | 428 ++++++++++++++++++
 2 files changed, 429 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_host_abi.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index e173a9adad3f2..42e530e0e573b 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -190,6 +190,7 @@ TEST_GEN_PROGS_arm64 += arm64/nv_pre_fault_memory_test
 TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
+TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
 TEST_GEN_PROGS_arm64 += arm64/set_id_regs
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_host_abi.c b/tools/testing/selftests/kvm/arm64/pkvm_host_abi.c
new file mode 100644
index 0000000000000..4e048c6c2752d
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_host_abi.c
@@ -0,0 +1,428 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_host_abi - what the host's KVM interface allows a protected VM.
+ *
+ * Copyright (C) 2025 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <errno.h>
+#include <sys/mman.h>
+
+#include <linux/bits.h>
+#include <linux/psci.h>
+
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define TEST_MEMSLOT	(PKVM_IDMAP_MEMSLOT + 1)
+#define TEST_GPA	BIT_ULL(30)
+#define TEST_PAGES	16
+
+/* Every probe sets PSCI_0_2, so that VCPU_INIT fails only on the feature under test. */
+#define PVM_INIT_FEATURES	BIT(KVM_ARM_VCPU_PSCI_0_2)
+
+#define CAP(c)	{ KVM_CAP_##c, "KVM_CAP_" #c }
+
+/* Caps a protected VM has on any pKVM host. */
+static const struct {
+	long cap;
+	const char *name;
+} allowed_caps[] = {
+	CAP(ONE_REG),
+	CAP(ARM_PSCI),
+	CAP(ARM_PSCI_0_2),
+	CAP(NR_VCPUS),
+	CAP(MAX_VCPUS),
+	CAP(MAX_VCPU_ID),
+	CAP(ARM_VM_IPA_SIZE),
+	CAP(MP_STATE),
+	CAP(VCPU_EVENTS),
+	CAP(VCPU_ATTRIBUTES),
+	CAP(IMMEDIATE_EXIT),
+	CAP(IOEVENTFD),
+	CAP(IRQFD_RESAMPLE),
+	CAP(ARM_IRQ_LINE_LAYOUT_2),
+};
+
+/* Set in the guest's copy by the host before the first run. */
+static u64 test_size;
+
+static void guest_finalize(void)
+{
+	pkvm_guest_init();
+	GUEST_DONE();
+}
+
+/* One write per MIN_PAGE_SIZE faults in every page of the test memslot. */
+static void guest_touch_memory(void)
+{
+	volatile u64 *end = (u64 *)(TEST_GPA + test_size);
+	volatile u64 *p;
+
+	pkvm_guest_init();
+
+	for (p = (u64 *)TEST_GPA; p < end; p += MIN_PAGE_SIZE / sizeof(*p))
+		*p = 1;
+
+	GUEST_DONE();
+}
+
+/* A protected VM with one vCPU and no VCPU_INIT yet. */
+static struct kvm_vcpu *create_uninitialized_vcpu(struct kvm_vm **vm_out)
+{
+	struct vm_shape shape = VM_SHAPE_DEFAULT;
+
+	shape.type = KVM_VM_TYPE_ARM_PROTECTED;
+	*vm_out = __vm_create(shape, 1, 0);
+	return __vm_vcpu_add(*vm_out, 0);
+}
+
+/* The errno of KVM_ARM_VCPU_INIT with @features on a protected vCPU, or 0. */
+static int vcpu_init_errno(u32 features)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int err;
+
+	vcpu = create_uninitialized_vcpu(&vm);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= features;
+
+	err = __vcpu_ioctl(vcpu, KVM_ARM_VCPU_INIT, &init) ? errno : 0;
+
+	kvm_vm_free(vm);
+	return err;
+}
+
+static void assert_feature_accepted(u32 feature, const char *name)
+{
+	int err = vcpu_init_errno(PVM_INIT_FEATURES | feature);
+
+	TEST_ASSERT(!err, "%s on a protected vCPU: errno %d", name, err);
+	ksft_test_result_pass("%s accepted at VCPU_INIT\n", name);
+}
+
+static void assert_feature_rejected(u32 feature, const char *name)
+{
+	int err = vcpu_init_errno(PVM_INIT_FEATURES | feature);
+
+	TEST_ASSERT(err == EINVAL, "%s on a protected vCPU: errno %d", name, err);
+	ksft_test_result_pass("%s rejected at VCPU_INIT\n", name);
+}
+
+static void test_vcpu_init_conditional_features(void)
+{
+	int err = vcpu_init_errno(0);
+
+	TEST_ASSERT(err == EINVAL, "no PSCI_0_2 on a protected vCPU: errno %d", err);
+	assert_feature_accepted(BIT(KVM_ARM_VCPU_PSCI_0_2), "PSCI_0_2");
+
+	if (kvm_has_cap(KVM_CAP_ARM_PMU_V3))
+		assert_feature_rejected(BIT(KVM_ARM_VCPU_PMU_V3), "PMU_V3");
+	else
+		ksft_test_result_skip("PMU_V3 rejected at VCPU_INIT: PMUv3 unavailable\n");
+
+	if (kvm_has_cap(KVM_CAP_ARM_SVE))
+		assert_feature_rejected(BIT(KVM_ARM_VCPU_SVE), "SVE");
+	else
+		ksft_test_result_skip("SVE rejected at VCPU_INIT: SVE unavailable\n");
+
+	if (kvm_has_cap(KVM_CAP_ARM_PTRAUTH_ADDRESS) && kvm_has_cap(KVM_CAP_ARM_PTRAUTH_GENERIC))
+		assert_feature_accepted(BIT(KVM_ARM_VCPU_PTRAUTH_ADDRESS) |
+					BIT(KVM_ARM_VCPU_PTRAUTH_GENERIC), "PtrAuth");
+	else
+		ksft_test_result_skip("PtrAuth accepted at VCPU_INIT: PtrAuth unavailable\n");
+}
+
+/* KVM_ARM_VCPU_INIT can be repeated until the vCPU's first run. */
+static void test_vcpu_init_repeated(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vcpu = create_uninitialized_vcpu(&vm);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= PVM_INIT_FEATURES;
+	vcpu_ioctl(vcpu, KVM_ARM_VCPU_INIT, &init);
+	vcpu_ioctl(vcpu, KVM_ARM_VCPU_INIT, &init);
+	kvm_vm_free(vm);
+
+	ksft_test_result_pass("VCPU_INIT repeated before the first run\n");
+}
+
+static void assert_ext(struct kvm_vm *vm, long ext, bool want_nonzero, const char *name)
+{
+	int r = __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)ext);
+
+	if (want_nonzero)
+		TEST_ASSERT(r > 0, "%s: expected nonzero, got %d", name, r);
+	else
+		TEST_ASSERT(r == 0, "%s: expected 0, got %d", name, r);
+}
+
+static void test_caps(void)
+{
+	struct kvm_vm *vm = vm_create_barebones_type(KVM_VM_TYPE_ARM_PROTECTED);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(allowed_caps); i++) {
+		assert_ext(vm, allowed_caps[i].cap, true, allowed_caps[i].name);
+		ksft_test_result_pass("%s allowed\n", allowed_caps[i].name);
+	}
+
+	if (kvm_has_cap(KVM_CAP_ARM_PTRAUTH_ADDRESS) && kvm_has_cap(KVM_CAP_ARM_PTRAUTH_GENERIC)) {
+		assert_ext(vm, KVM_CAP_ARM_PTRAUTH_ADDRESS, true, "KVM_CAP_ARM_PTRAUTH_ADDRESS");
+		assert_ext(vm, KVM_CAP_ARM_PTRAUTH_GENERIC, true, "KVM_CAP_ARM_PTRAUTH_GENERIC");
+		ksft_test_result_pass("KVM_CAP_ARM_PTRAUTH_* allowed\n");
+	} else {
+		ksft_test_result_skip("KVM_CAP_ARM_PTRAUTH_* allowed: PtrAuth unavailable\n");
+	}
+
+	if (kvm_has_cap(KVM_CAP_ARM_SVE)) {
+		assert_ext(vm, KVM_CAP_ARM_SVE, false, "KVM_CAP_ARM_SVE");
+		ksft_test_result_pass("KVM_CAP_ARM_SVE blocked\n");
+	} else {
+		ksft_test_result_skip("KVM_CAP_ARM_SVE blocked: SVE unavailable\n");
+	}
+
+	if (kvm_has_cap(KVM_CAP_ARM_PMU_V3)) {
+		assert_ext(vm, KVM_CAP_ARM_PMU_V3, false, "KVM_CAP_ARM_PMU_V3");
+		ksft_test_result_pass("KVM_CAP_ARM_PMU_V3 blocked\n");
+	} else {
+		ksft_test_result_skip("KVM_CAP_ARM_PMU_V3 blocked: PMUv3 unavailable\n");
+	}
+
+	assert_ext(vm, KVM_CAP_READONLY_MEM, false, "KVM_CAP_READONLY_MEM");
+	ksft_test_result_pass("KVM_CAP_READONLY_MEM blocked\n");
+
+	assert_ext(vm, KVM_CAP_SET_GUEST_DEBUG, false, "KVM_CAP_SET_GUEST_DEBUG");
+	ksft_test_result_pass("KVM_CAP_SET_GUEST_DEBUG blocked\n");
+
+	assert_ext(vm, KVM_CAP_ARM_INJECT_EXT_DABT, false, "KVM_CAP_ARM_INJECT_EXT_DABT");
+	ksft_test_result_pass("KVM_CAP_ARM_INJECT_EXT_DABT blocked\n");
+
+	/* Blocked explicitly, and reads 0 anyway on a host without MTE. */
+	assert_ext(vm, KVM_CAP_ARM_MTE, false, "KVM_CAP_ARM_MTE");
+	ksft_test_result_pass("KVM_CAP_ARM_MTE blocked\n");
+
+	kvm_vm_free(vm);
+}
+
+/* VM ioctls whose capability a protected VM doesn't get fail with EINVAL. */
+static void test_vm_ioctls_rejected(void)
+{
+	struct kvm_vm *vm = vm_create_barebones_type(KVM_VM_TYPE_ARM_PROTECTED);
+	struct kvm_arm_counter_offset offset = {};
+	struct reg_mask_range range = {};
+	int ret;
+
+	ret = __kvm_has_device_attr(vm->fd, KVM_ARM_VM_SMCCC_CTRL, KVM_ARM_VM_SMCCC_FILTER);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "SMCCC_CTRL: rc %d errno %d", ret, errno);
+	ret = __vm_ioctl(vm, KVM_ARM_SET_COUNTER_OFFSET, &offset);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "SET_COUNTER_OFFSET: rc %d errno %d", ret, errno);
+	ret = __vm_ioctl(vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "GET_REG_WRITABLE_MASKS: rc %d errno %d",
+		    ret, errno);
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("VM ioctls without their capability rejected\n");
+}
+
+/* The host allows every ONE_REG until a protected vCPU's first KVM_RUN. */
+static void test_one_reg_gate(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	u64 val;
+	int ret;
+
+	vm = pkvm_vm_create(1, 0, &vcpu);
+
+	/*
+	 * pkvm_vcpu_setup_boot() snapshots regs[0..7] and SCTLR_EL1 for the
+	 * trampoline, so write back SCTLR_EL1 unchanged and probe regs[10].
+	 */
+	ret = __vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &val);
+	TEST_ASSERT_EQ(ret, 0);
+	ret = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), val);
+	TEST_ASSERT_EQ(ret, 0);
+	ret = __vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &val);
+	TEST_ASSERT_EQ(ret, 0);
+	ret = __vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.regs[10]), 0x1234);
+	TEST_ASSERT_EQ(ret, 0);
+
+	pkvm_vcpu_setup_boot(vcpu, guest_finalize);
+	pkvm_run_loop(vcpu, NULL);
+
+	ret = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), 0);
+	TEST_ASSERT(ret == -1 && errno == EPERM, "non-CORE post-run: rc %d errno %d", ret, errno);
+	ret = __vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), &val);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "non-CORE get post-run: rc %d errno %d", ret, errno);
+
+	ret = __vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pc), &val);
+	TEST_ASSERT(ret == -1 && errno == EPERM, "CORE pc post-run: rc %d errno %d", ret, errno);
+	ret = __vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.regs[4]), 0);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "CORE regs[4] post-run: rc %d errno %d", ret, errno);
+	ksft_test_result_pass("ONE_REG gate\n");
+
+	kvm_vm_free(vm);
+}
+
+static void test_vcpu_ioctl_gates(void)
+{
+	struct kvm_guest_debug dbg = { .control = KVM_GUESTDBG_ENABLE };
+	struct kvm_vcpu_events events = {};
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	u64 ipa = TEST_GPA;
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = pkvm_vm_create(1, 0, &vcpu);
+
+	ret = __vcpu_ioctl(vcpu, KVM_SET_GUEST_DEBUG, &dbg);
+	TEST_ASSERT(ret == -1 && errno == EPERM, "pre-run SET_GUEST_DEBUG: rc %d errno %d",
+		    ret, errno);
+	/* EL2 implements PSCI 1.1, so the host can't set an older version. */
+	ret = __vcpu_set_reg(vcpu, KVM_REG_ARM_PSCI_VERSION, PSCI_VERSION(1, 0));
+	TEST_ASSERT(ret == -1 && errno == EINVAL, "PSCI_VERSION 1.0: rc %d errno %d", ret, errno);
+	vcpu_set_reg(vcpu, KVM_REG_ARM_PSCI_VERSION, PSCI_VERSION(1, 1));
+	ksft_test_result_pass("pre-run: SET_GUEST_DEBUG refused, PSCI_VERSION 1.1 at least\n");
+
+	pkvm_vcpu_setup_boot(vcpu, guest_finalize);
+	pkvm_run_loop(vcpu, NULL);
+
+	ret = __vcpu_ioctl(vcpu, KVM_SET_GUEST_DEBUG, &dbg);
+	TEST_ASSERT(ret == -1 && errno == EPERM, "post-run SET_GUEST_DEBUG: rc %d errno %d",
+		    ret, errno);
+	kvm_get_default_vcpu_target(vm, &init);
+	init.features[0] |= PVM_INIT_FEATURES;
+	ret = __vcpu_ioctl(vcpu, KVM_ARM_VCPU_INIT, &init);
+	TEST_ASSERT(ret == -1 && errno == EPERM, "post-run VCPU_INIT: rc %d errno %d", ret, errno);
+
+	events.exception.ext_dabt_pending = 1;
+	ret = __vcpu_ioctl(vcpu, KVM_SET_VCPU_EVENTS, &events);
+	TEST_ASSERT(ret == -1 && errno == EPERM, "ext_dabt_pending: rc %d errno %d", ret, errno);
+	events.exception.ext_dabt_pending = 0;
+	events.exception.serror_pending = 1;
+	vcpu_events_set(vcpu, &events);
+	memset(&events, 0, sizeof(events));
+	vcpu_events_get(vcpu, &events);
+	TEST_ASSERT(events.exception.serror_pending, "post-run SError not read back");
+
+	ret = __vcpu_has_device_attr(vcpu, KVM_ARM_VCPU_PVTIME_CTRL, KVM_ARM_VCPU_PVTIME_IPA);
+	TEST_ASSERT(ret == -1 && errno == ENXIO, "HAS PVTIME_IPA: rc %d errno %d", ret, errno);
+	ret = __vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_PVTIME_CTRL, KVM_ARM_VCPU_PVTIME_IPA, &ipa);
+	TEST_ASSERT(ret == -1 && errno == ENXIO, "GET PVTIME_IPA: rc %d errno %d", ret, errno);
+	ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PVTIME_CTRL, KVM_ARM_VCPU_PVTIME_IPA, &ipa);
+	TEST_ASSERT(ret == -1 && errno == ENXIO, "SET PVTIME_IPA: rc %d errno %d", ret, errno);
+
+	kvm_vm_free(vm);
+	ksft_test_result_pass("post-run: debug, VCPU_INIT, abort injection and PVTIME refused\n");
+}
+
+/* GET_REG_LIST is gated on VCPU_INIT, not on the vCPU having run. */
+static void test_get_reg_list_gate(void)
+{
+	struct kvm_reg_list reg_list = { .n = 0 };
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int ret;
+
+	vcpu = create_uninitialized_vcpu(&vm);
+	ret = __vcpu_ioctl(vcpu, KVM_GET_REG_LIST, &reg_list);
+	TEST_ASSERT(ret == -1 && errno == ENOEXEC, "uninitialized: rc %d errno %d", ret, errno);
+	kvm_vm_free(vm);
+
+	vm = pkvm_vm_create(1, 0, &vcpu);
+	free(vcpu_get_reg_list(vcpu));
+	kvm_vm_free(vm);
+	ksft_test_result_pass("GET_REG_LIST gate\n");
+}
+
+static void test_memslot_flags_rejected(void)
+{
+	size_t size = getpagesize();
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	void *hva;
+	int ret;
+
+	vm = pkvm_vm_create(1, 0, &vcpu);
+
+	hva = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	TEST_ASSERT(hva != MAP_FAILED, "mmap failed: %d", errno);
+
+	ret = __vm_set_user_memory_region2(vm, TEST_MEMSLOT, KVM_MEM_READONLY, TEST_GPA,
+					   size, hva, -1, 0);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "read-only memslot on a protected VM: rc %d errno %d", ret, errno);
+	ksft_test_result_pass("read-only memslot rejected at creation\n");
+
+	ret = __vm_set_user_memory_region2(vm, TEST_MEMSLOT, KVM_MEM_LOG_DIRTY_PAGES, TEST_GPA,
+					   size, hva, -1, 0);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "dirty-logging memslot on a protected VM: rc %d errno %d", ret, errno);
+
+	vm_set_user_memory_region2(vm, TEST_MEMSLOT, 0, TEST_GPA, size, hva, -1, 0);
+	ret = __vm_set_user_memory_region2(vm, TEST_MEMSLOT, KVM_MEM_LOG_DIRTY_PAGES, TEST_GPA,
+					   size, hva, -1, 0);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "dirty logging enabled on a protected VM: rc %d errno %d", ret, errno);
+	ksft_test_result_pass("dirty logging rejected at creation and when enabled\n");
+
+	munmap(hva, size);
+	kvm_vm_free(vm);
+}
+
+/* The host pins and accounts a protected VM's memory until the VM is freed. */
+static void test_memory_locked(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	size_t locked;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_touch_memory);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, TEST_GPA, TEST_MEMSLOT,
+				    TEST_PAGES, 0);
+	virt_map(vm, TEST_GPA, TEST_GPA, TEST_PAGES);
+	write_guest_global(vm, test_size, TEST_PAGES * vm->page_size);
+
+	pkvm_run_loop(vcpu, NULL);
+	locked = pkvm_host_locked_vm();
+	TEST_ASSERT(locked > TEST_PAGES * vm->page_size,
+		    "guest memory not locked while the VM is alive: %zu bytes", locked);
+
+	kvm_vm_free(vm);
+	TEST_ASSERT_EQ(pkvm_host_locked_vm(), 0);
+
+	ksft_test_result_pass("memory locked while running\n");
+}
+
+int main(void)
+{
+	TEST_REQUIRE(pkvm_supported());
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(allowed_caps) + 21);
+
+	assert_feature_rejected(BIT(KVM_ARM_VCPU_EL1_32BIT), "EL1_32BIT");
+	test_vcpu_init_conditional_features();
+	test_vcpu_init_repeated();
+	test_caps();
+	test_vm_ioctls_rejected();
+	test_one_reg_gate();
+	test_vcpu_ioctl_gates();
+	test_get_reg_list_gate();
+	test_memslot_flags_rejected();
+	test_memory_locked();
+
+	ksft_finished();
+}
-- 
2.47.3

