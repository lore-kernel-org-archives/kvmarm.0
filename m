Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446630;
	b=2QYp137P0Tvx/XLv1d6T745bVNyeyOR8N2gIgF0jeBjuHZ3YAcbiryjG61+nYYV/8v/e
	 CqTMUxvWARu5Trdxqm3nKZwN9OlAnsLp93MPlwbQO5oMalSNR3UUfx8fpcpGV1POuksJh
	 Y3NDCbAp6weaIZ9Fx7dpSKftm7436z9w8WYbtc45GBC65WEJzD7p5Vdv3xdx2pRPJ/Kro
	 UMz7Yr8kAvGN75hxX3NP18uccrZe1xRYNxJYNh98KPMu1okZED6FTNaD0rRYSpaGy8z+9
	 500AZCVMrHwcN6rQNxMsxfyx/1F24WGX3uKqIShU5BbcaZpTLjvC5TI4CV/7O03QXxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446630;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QD0nNj4E35Kis9XWNnLNRRy+zAstNQ9se2vTJvGkvqI=;
	b=GVpoiWWxtAJexpSp9MkqlpCVUZrhp7EVUvUcQFwcA/Q7OAEjLNx01BfESiuCOuOKANfP
	 huf5z7wsIaZj0IxhZLb5XgQiOdm5dAi7gC7Mn/sZgmlgxJK3b+HTYC9rYgnYE/2AB2UxC
	 +CCQp5EzxdEIotoJb3jbx5IqRtv2aTjjJAGmfPWtjhs6bCD0J9USoqGCwLcRg4kmaL0Po
	 HQUTMKcq7FN4IRkKn703GjJAJhiV5s+rkrZRuriumQ1PdJ3zbsmYXSdIghsX4STrNh9su
	 uDJoCNZ2lExdm626VuGs5Wxv1Csw+6d+K8JMKYw3/YwT94YBPRVGRFNjdCBhuEzPvrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="OE2u4eg/";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7298A606A31A
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 15:10:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7298A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OE2u4eg/
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25D0A176B;
	Mon, 23 Nov 2026 07:10:26 -0800 (PST)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.233])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D3EAF3F632;
	Mon, 23 Nov 2026 07:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795446629; bh=KAV5zzw6aH2fqGdF4DX2/b+XyZ6zGL5MKFGisav5AaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OE2u4eg/Mu7QwC9WS7aQnXK0x/7kz34F5Q6JK++tfMEDiigrh94zkDz1NQ1W3EsgA
	 BhE0e9WOwq9h1s6bmDGBC5k+kVSGrGE6+7TZTZlLkSUYse36Qe8iQ0IWGt0qn8l+Iz
	 N4A8iPh6zS+hYmtljF0FAOas2lG4UvQksiPU3UdQ=
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH 3/3] KVM: selftests: arm64: Test KVM_PRE_FAULT_MEMORY before first KVM_RUN
Date: Mon, 23 Nov 2026 15:09:17 +0000
Message-Id: <20261123150917.2679600-4-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261123150917.2679600-1-justin.he@arm.com>
References: <20261123150917.2679600-1-justin.he@arm.com>
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

Extend nv_pre_fault_memory_test to exercise KVM_PRE_FAULT_MEMORY before
the first KVM_RUN.

Without EL2, cover immediate_exit on the first KVM_RUN, retrying after a
failed first KVM_RUN, and pre-faulting while the vCPU moves from the
main thread to a worker thread for its first run and back to the main
thread for its second run. The two threads are pinned to different CPUs
when at least two are available.

With EL2, additionally cover an EL2 vCPU with ID_AA64MMFR4_EL1.NV_frac
cleared to 0 and HCR_EL2.NV=1 at EL1h (the NULL vncr_tlb reproducer), an
EL2 vCPU with a vEL1 context and asymmetric HCR_EL2.IMO/FMO staged before
the first run, and the same thread handoff. An unfixed kernel reports
the staged context case only as a WARN in the kernel log; the test
itself still passes.

Signed-off-by: Jia He <justin.he@arm.com>
---
 .../kvm/arm64/nv_pre_fault_memory_test.c      | 335 ++++++++++++++++--
 1 file changed, 298 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
index 09c1db303856..6dbcf3b0ef13 100644
--- a/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/arm64/nv_pre_fault_memory_test.c
@@ -1,15 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * nv_pre_fault_memory_test - Test KVM_PRE_FAULT_MEMORY on a vCPU whose
- * last-run context is nested.
- *
- * The guest enters vEL2, sets up its EL2 translation configuration into the
- * real EL1 registers then ERETs to vEL1 and exits to userspace so its vCPU
- * last-run context is nested backed by a shadow stage 2 MMU.
- *
- * Assert that pre-faulting ignores that and targets the canonical stage-2
- * page tables only.
+ * nv_pre_fault_memory_test - Test KVM_PRE_FAULT_MEMORY on arm64 before the
+ * first KVM_RUN, across vCPU thread changes, and, with nested virtualisation,
+ * from a live nested context.
  */
+#include <pthread.h>
+#include <sched.h>
+
+#include "kvm_syscalls.h"
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
@@ -22,6 +20,18 @@
 #define TEST_MEM_SIZE		SZ_2M
 #define TEST_MEM_GPA		SZ_1G
 
+static void guest_el1_touch_and_done(void)
+{
+	u64 offset;
+
+	GUEST_ASSERT_EQ(get_current_el(), 1);
+
+	for (offset = 0; offset < TEST_MEM_SIZE; offset += SZ_4K)
+		READ_ONCE(*(u64 *)(TEST_MEM_GPA + offset));
+
+	GUEST_DONE();
+}
+
 static void guest_el1_code(void)
 {
 	u64 offset;
@@ -97,22 +107,56 @@ static void pre_fault(struct kvm_vcpu *vcpu, u64 gpa, u64 size)
 	TEST_ASSERT_EQ(range.size, 0);
 }
 
-int main(void)
+static void expect_ucall_sync(struct kvm_vcpu *vcpu, u64 expected)
+{
+	struct ucall uc;
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT_EQ(uc.args[1], expected);
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
+	}
+}
+
+static void expect_ucall_done(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		break;
+	default:
+		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
+	}
+}
+
+static struct kvm_vm *setup_test_vm(bool has_el2, bool has_sve,
+				    void *guest_fn, struct kvm_vcpu **vcpu_out)
 {
 	struct kvm_vcpu_init init;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct ucall uc;
 	u64 npages;
 
-	TEST_REQUIRE(test_supports_el2());
-	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
-
 	vm = vm_create(1);
 
 	kvm_get_default_vcpu_target(vm, &init);
-	init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
-	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+	if (has_el2)
+		init.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
+	else
+		init.features[0] &= ~BIT(KVM_ARM_VCPU_HAS_EL2);
+	if (has_sve)
+		init.features[0] |= BIT(KVM_ARM_VCPU_SVE);
+
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_fn);
 	kvm_arch_vm_finalize_vcpus(vm);
 
 	npages = TEST_MEM_SIZE / vm->page_size;
@@ -120,39 +164,256 @@ int main(void)
 				    TEST_MEM_SLOT, npages, 0);
 	virt_map(vm, TEST_MEM_GPA, TEST_MEM_GPA, npages);
 
+	*vcpu_out = vcpu;
+	return vm;
+}
+
+static void test_nested_post_run_pre_fault(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	pr_info("Testing post-run pre-fault from nested vEL1 context\n");
+	vm = setup_test_vm(true, false, guest_code, &vcpu);
+
 	/* Run the guest until it has ERET'd from vEL2 to vEL1. */
 	vcpu_run(vcpu);
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_SYNC:
-		TEST_ASSERT_EQ(uc.args[1], 1);
-		break;
-	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT(uc);
-		break;
-	default:
-		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
-	}
+	expect_ucall_sync(vcpu, 1);
 
 	/*
 	 * The vCPU's last-run context is vEL1, so its hw_mmu is a shadow
-	 * stage-2 MMU.
-	 *
-	 * Pre-faulting must ignore that and populate the canonical stage-2.
+	 * stage-2 MMU. Pre-faulting must ignore that and populate the
+	 * canonical stage-2.
 	 */
 	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE);
 
 	/* Resume at vEL1 and touch the prefaulted range. */
 	vcpu_run(vcpu);
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_DONE:
-		break;
-	case UCALL_ABORT:
-		REPORT_GUEST_ASSERT(uc);
-		break;
-	default:
-		TEST_FAIL("Unhandled ucall: %ld", uc.cmd);
+	expect_ucall_done(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * Pre-fault before the first KVM_RUN with ID_AA64MMFR4_EL1.NV_frac == 0
+ * (no vncr_tlb) and HCR_EL2.NV=1 at EL1h.
+ */
+static void test_pre_first_run_no_nv2(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	u64 val;
+
+	pr_info("Testing pre-first-run pre-fault with NV_frac=0 and HCR_EL2.NV=1\n");
+	vm = setup_test_vm(true, false, guest_el1_touch_and_done, &vcpu);
+
+	/* Copy the EL2 S1 configuration into the EL1 sysregs for vEL1. */
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1),
+		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL2)));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1),
+		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL2)));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1),
+		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TTBR0_EL2)));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MAIR_EL1),
+		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MAIR_EL2)));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3ULL << 20);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VBAR_EL1),
+		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VBAR_EL2)));
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1),
+		     vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SP_EL2)));
+
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR4_EL1));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR4_EL1),
+		     val & ~ID_AA64MMFR4_EL1_NV_frac);
+
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
+		     (val & ~HCR_EL2_TGE) | HCR_EL2_NV | HCR_EL2_RW);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pstate),
+		     PSR_MODE_EL1h | PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT);
+
+	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE);
+
+	vcpu_run(vcpu);
+	expect_ucall_done(vcpu);
+
+	val = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
+	TEST_ASSERT(!(val & HCR_EL2_NV),
+		    "Expected HCR_EL2.NV to be masked RES0, got 0x%lx", val);
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * Stage a vEL1 context with asymmetric HCR_EL2.IMO/FMO before the first
+ * KVM_RUN. If pre-faulting loads this context onto the CPU, the nested vGIC
+ * code hits a WARN in the kernel log. The test itself still passes, so this
+ * case needs a kernel log check.
+ */
+static void test_pre_first_run_nested_ctxt(void)
+{
+	u64 orig_hcr, orig_pstate;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	pr_info("Testing pre-first-run pre-fault with staged vEL1 context\n");
+	vm = setup_test_vm(true, false, guest_code, &vcpu);
+
+	orig_hcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2));
+	orig_pstate = vcpu_get_reg(vcpu, ARM64_CORE_REG(regs.pstate));
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2),
+		     HCR_EL2_E2H | HCR_EL2_RW | HCR_EL2_VM | HCR_EL2_IMO);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pstate),
+		     PSR_MODE_EL1h | PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT);
+
+	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE);
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_HCR_EL2), orig_hcr);
+	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pstate), orig_pstate);
+
+	vcpu_run(vcpu);
+	expect_ucall_sync(vcpu, 1);
+	vcpu_run(vcpu);
+	expect_ucall_done(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+struct handoff_args {
+	struct kvm_vcpu *vcpu;
+	int cpu;
+};
+
+static void maybe_pin_self_to_cpu(int cpu)
+{
+	if (cpu >= 0)
+		pin_self_to_cpu(cpu);
+}
+
+static void *first_run_worker(void *arg)
+{
+	struct handoff_args *h = arg;
+
+	maybe_pin_self_to_cpu(h->cpu);
+	pre_fault(h->vcpu, TEST_MEM_GPA + SZ_1M, TEST_MEM_SIZE - SZ_1M);
+
+	vcpu_run(h->vcpu);
+	expect_ucall_sync(h->vcpu, 1);
+	return NULL;
+}
+
+/*
+ * Pre-fault in the main thread, run the vCPU for the first time in a worker
+ * thread, then pre-fault and run it again in the main thread. This changes
+ * vcpu->pid both before and after the first run. If at least two CPUs are
+ * available, the two threads are pinned to different CPUs.
+ */
+static void test_thread_handoff(bool has_el2)
+{
+	struct handoff_args h = { .cpu = -1 };
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	cpu_set_t allowed;
+	int cpu, cpu0 = -1;
+	pthread_t thr;
+
+	pr_info("Testing pre-fault across a thread handoff (%s vCPU)\n",
+		has_el2 ? "EL2" : "EL1");
+
+	CPU_ZERO(&allowed);
+	kvm_pthread_getaffinity(pthread_self(), &allowed);
+	for (cpu = 0; cpu < CPU_SETSIZE; cpu++) {
+		if (!CPU_ISSET(cpu, &allowed))
+			continue;
+		if (cpu0 < 0) {
+			cpu0 = cpu;
+		} else {
+			h.cpu = cpu;
+			break;
+		}
+	}
+	if (h.cpu < 0)
+		pr_info("Only one CPU available, not testing CPU migration\n");
+
+	maybe_pin_self_to_cpu(cpu0);
+	vm = setup_test_vm(has_el2, false,
+			   has_el2 ? guest_code : guest_el1_code, &vcpu);
+	pre_fault(vcpu, TEST_MEM_GPA, SZ_1M);
+
+	h.vcpu = vcpu;
+	kvm_pthread_create(&thr, NULL, first_run_worker, &h);
+	kvm_pthread_join(thr, NULL);
+
+	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE);
+	vcpu_run(vcpu);
+	expect_ucall_done(vcpu);
+
+	kvm_pthread_setaffinity(pthread_self(), &allowed);
+
+	kvm_vm_free(vm);
+}
+
+static void test_pre_first_run_el1(void)
+{
+	int feature = KVM_ARM_VCPU_SVE;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int ret;
+
+	pr_info("Testing pre-first-run pre-fault with immediate_exit\n");
+	vm = setup_test_vm(false, false, guest_el1_touch_and_done, &vcpu);
+	pre_fault(vcpu, TEST_MEM_GPA, vm->page_size);
+
+	vcpu->run->immediate_exit = 1;
+	ret = __vcpu_run(vcpu);
+	TEST_ASSERT(ret == -1 && errno == EINTR,
+		    "Expected -EINTR on immediate_exit, got ret=%d errno=%d",
+		    ret, errno);
+	vcpu->run->immediate_exit = 0;
+
+	pre_fault(vcpu, TEST_MEM_GPA, TEST_MEM_SIZE);
+	vcpu_run(vcpu);
+	expect_ucall_done(vcpu);
+	kvm_vm_free(vm);
+
+	if (!kvm_check_cap(KVM_CAP_ARM_SVE)) {
+		pr_info("SVE not supported, skipping failed first KVM_RUN test\n");
+		return;
 	}
 
+	pr_info("Testing pre-fault after a failed first KVM_RUN\n");
+	vm = setup_test_vm(false, true, guest_el1_touch_and_done, &vcpu);
+	pre_fault(vcpu, TEST_MEM_GPA, vm->page_size);
+
+	ret = __vcpu_run(vcpu);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "Expected -EPERM before SVE finalisation, got ret=%d errno=%d",
+		    ret, errno);
+
+	pre_fault(vcpu, TEST_MEM_GPA + vm->page_size, vm->page_size);
+	vcpu_ioctl(vcpu, KVM_ARM_VCPU_FINALIZE, &feature);
+	vcpu_run(vcpu);
+	expect_ucall_done(vcpu);
 	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
+
+	test_pre_first_run_el1();
+	test_thread_handoff(false);
+
+	if (!test_supports_el2()) {
+		pr_info("EL2 not supported, skipping nested tests\n");
+		return 0;
+	}
+
+	test_nested_post_run_pre_fault();
+	test_pre_first_run_no_nv2();
+	test_pre_first_run_nested_ctxt();
+	test_thread_handoff(true);
+
 	return 0;
 }
-- 
2.34.1

