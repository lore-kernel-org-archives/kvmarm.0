Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782178;
	b=Ew0PnfwCCXDFN3NJIcqCrPgwKFscgAHwL8Q6mcQCoX0esP/1WL3NJgfIhDgTxrT1B+KX
	 T/Qr7Gk+0dFo2zb2v4TZ/zBvu6ixgQREejfh+vNlkI60j2jq85pdgaA/2jxANNTzcjJu2
	 QMFBKnWGxJIpVQUzhKKdLlMm6eGv5SMtJZ+yr+hFcMkAnqcFmsxlUzWDS66UJEJcxl4hn
	 4BRr35F8gpFS4+IpGlPUoXnuBdJA1AZWlSO5uDFIV+SzkY5sba1Ojc98fnQ7Sp86TTbk6
	 YCrzjC5Vfjw3zvXPYgQ8tlPTFWthF6D3Kh0IEPX3QO/MEwJ4wLQu9ksiX2SUAztntzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782178;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PtHDYady7phNq27ntokTbSRWYS9Lun+LGBxYvYPNZY8=;
	b=Cz6MCpVstvYA+DraEMeqw3Ytk6V4XTnMmHVOUAOdhyBPVZuY53o0ocWjftGrb5/dxhtL
	 oEApMVbB3oD2Oa6QtkGTaamcSaglU0KLkemmxNHoP1R58SKScgv5UY3MpxARGKZtjJs+x
	 GsexEwkX9zEugG9xeOJqP2/h0mBnmumXTsfbYwbtKwwVxjCPTot8nuTWApphmh4pG+qY8
	 OlRmCtVNurfNX9HqfsBvVCeLUAi2hue1JTlNnMxqmk0dYXND7RJGkn4l8aJViI+b/CXmZ
	 Nl7gGG8T1bKuy9J/2FUayPGNyqG1Mbfo7g7cyKgj9AKmNBOXqxo5J4dT8pLu5j1oUqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=una2nS2+;
	arc=none smtp.remote-ip=91.218.175.30
Received: from mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF50606D830
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 08:49:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADF50606D830
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=una2nS2+
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ovcORW3DsB2JukpcYhWq0sTqhjhRqe8m4MhePuk/qqE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793782176; v=1; x=1794386976;
 b=una2nS2+1gv+3N+rbpbDGbL279Vsom5ZP4Jh5HEjdvr7FsmnhCXSfblytjlUnlfIC9sEY8qT
 yIpCEU6E3EUAF3keJijoSgtWp0XBqd3MBQ72qh0XbjbhEAEyeJXYHzonMVQnR1jxvstjZBAoETu
 nGSNKxR4ZQnGHzaJy8AKufoM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 0db4956640b39e57;
	Wed, 04 Nov 2026 08:49:35 +0000
X-Mizu-Trace-ID: 0db4956640b39e57
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
Subject: [PATCH 09/16] KVM: arm64: selftests: Add pkvm_mem_share hypercall test
Date: Wed,  4 Nov 2026 08:48:35 +0000
Message-ID: <20261104084842.132944-10-fuad.tabba@linux.dev>
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

A protected guest gives the host access to one of its pages with
MEM_SHARE and takes it back with MEM_UNSHARE. The page is a host page,
whose size HYP_MEMINFO returns. At teardown EL2 zeroes every page the
guest hasn't left shared.

Exercise the three calls, the host's access to shared and private pages,
and the zeroing. Also check that KVM_RUN fails with EIO on
hugetlb-backed memory, that sharing an IPA outside every memslot makes
the guest take an external abort, and that faults each requiring new
stage-2 tables succeed.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/pkvm_mem_share.c      | 394 ++++++++++++++++++
 2 files changed, 395 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_mem_share.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index aa256fb66d226..88c1159cb3bf1 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -191,6 +191,7 @@ TEST_GEN_PROGS_arm64 += arm64/external_aborts
 TEST_GEN_PROGS_arm64 += arm64/mmio_sign_ext
 TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
+TEST_GEN_PROGS_arm64 += arm64/pkvm_mem_share
 TEST_GEN_PROGS_arm64 += arm64/pkvm_psci
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/sea_to_user
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_mem_share.c b/tools/testing/selftests/kvm/arm64/pkvm_mem_share.c
new file mode 100644
index 0000000000000..9a4e96fc8d046
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_mem_share.c
@@ -0,0 +1,394 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_mem_share - MEM_SHARE, MEM_UNSHARE and HYP_MEMINFO, and EL2 zeroing a
+ * protected VM's private pages at teardown.
+ *
+ * Copyright (C) 2025 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <errno.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <stdio.h>
+
+#include <linux/arm-smccc.h>
+
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+/*
+ * A page here is a host page, the granule EL2 shares in. Set in the guest's
+ * copy by the host before the first run.
+ */
+static u64 granule;
+
+#define GUEST_MEMSLOT	(PKVM_IDMAP_MEMSLOT + 1)
+#define GPA_BASE	BIT_ULL(30)
+#define GVA_BASE	GPA_BASE
+#define GPA_PAGES	16
+#define GPA_SIZE	((size_t)GPA_PAGES * granule)
+
+/* Each case uses its own pages of the guest memslot. */
+#define P_SHARE			0
+#define P_SHARED_AT_TEARDOWN	1
+
+/* Recognizable value the host must still see in a page that isn't zeroed. */
+#define DIRTY_VAL		0x0badf00ddeadbeefUL
+
+/* An aligned IPA outside every memslot. */
+#define OUTSIDE_IPA		BIT_ULL(31)
+
+/* What one last-level stage-2 table maps: 2M on a 4K host. */
+#define BLOCK_SIZE		(granule / 8 * granule)
+
+/* One page in each block of a memslot centered on 512G. */
+#define PRESSURE_MEMSLOT	(GUEST_MEMSLOT + 1)
+#define PRESSURE_PAGES		64
+#define PRESSURE_SIZE		((u64)PRESSURE_PAGES * BLOCK_SIZE)
+#define PRESSURE_GPA		(BIT_ULL(39) - PRESSURE_SIZE / 2)
+#define PRESSURE_GVA		BIT_ULL(32)
+
+/* Commands that act on a page take its index. */
+enum guest_cmd {
+	CMD_HOST_INC_SHARED = 1,
+	CMD_HOST_ACCESS_PRIVATE,
+};
+
+#define HOST_CMD(cmd, idx)	GUEST_SYNC_ARGS(cmd, idx, 0, 0, 0)
+
+static u64 page_ipa(int idx)
+{
+	return GPA_BASE + (u64)idx * granule;
+}
+
+static volatile u64 *page_va(int idx)
+{
+	return (volatile u64 *)(GVA_BASE + (u64)idx * granule);
+}
+
+static unsigned long hvc_share(u64 ipa, u64 arg2, u64 arg3)
+{
+	return pkvm_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID, ipa, arg2, arg3);
+}
+
+static unsigned long hvc_unshare(u64 ipa, u64 arg2, u64 arg3)
+{
+	return pkvm_hvc(ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID, ipa, arg2, arg3);
+}
+
+static void test_meminfo(void)
+{
+	u32 meminfo = ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID;
+
+	GUEST_ASSERT_EQ(pkvm_hvc(meminfo, 0, 0, 0), granule);
+
+	GUEST_ASSERT_EQ(pkvm_hvc(meminfo, 1, 0, 0), SMCCC_RET_INVALID_PARAMETER);
+	GUEST_ASSERT_EQ(pkvm_hvc(meminfo, 0, 1, 0), SMCCC_RET_INVALID_PARAMETER);
+	GUEST_ASSERT_EQ(pkvm_hvc(meminfo, 0, 0, 1), SMCCC_RET_INVALID_PARAMETER);
+}
+
+static void test_arg_validation(void)
+{
+	u64 ipa = page_ipa(P_SHARE);
+
+	/* Non-zero arg2 or arg3, and an unaligned IPA, are rejected before any page walk. */
+	GUEST_ASSERT_EQ(hvc_share(ipa, 1, 0), SMCCC_RET_INVALID_PARAMETER);
+	GUEST_ASSERT_EQ(hvc_share(ipa, 0, 1), SMCCC_RET_INVALID_PARAMETER);
+	GUEST_ASSERT_EQ(hvc_share(ipa + 0x80, 0, 0), SMCCC_RET_INVALID_PARAMETER);
+	GUEST_ASSERT_EQ(hvc_unshare(ipa, 1, 0), SMCCC_RET_INVALID_PARAMETER);
+	GUEST_ASSERT_EQ(hvc_unshare(ipa, 0, 1), SMCCC_RET_INVALID_PARAMETER);
+	GUEST_ASSERT_EQ(hvc_unshare(ipa + 0x80, 0, 0), SMCCC_RET_INVALID_PARAMETER);
+}
+
+static void test_share_unshare(void)
+{
+	volatile u64 *val = page_va(P_SHARE);
+	u64 ipa = page_ipa(P_SHARE);
+
+	*val = 42;
+
+	HOST_CMD(CMD_HOST_ACCESS_PRIVATE, P_SHARE);
+	GUEST_ASSERT_EQ(*val, 42);
+
+	GUEST_ASSERT_EQ(hvc_share(ipa, 0, 0), SMCCC_RET_SUCCESS);
+	GUEST_ASSERT_EQ(hvc_share(ipa, 0, 0), SMCCC_RET_INVALID_PARAMETER);
+
+	HOST_CMD(CMD_HOST_INC_SHARED, P_SHARE);
+	GUEST_ASSERT_EQ(*val, 43);
+
+	GUEST_ASSERT_EQ(hvc_unshare(ipa, 0, 0), SMCCC_RET_SUCCESS);
+	GUEST_ASSERT_EQ(hvc_unshare(ipa, 0, 0), SMCCC_RET_INVALID_PARAMETER);
+
+	HOST_CMD(CMD_HOST_ACCESS_PRIVATE, P_SHARE);
+	GUEST_ASSERT_EQ(*val, 43);
+}
+
+/* Dirty every page, so that a page that reads 0 after teardown is one EL2 zeroed. */
+static void guest_dirty_region(void)
+{
+	volatile u64 *p = (volatile u64 *)GVA_BASE;
+	size_t i;
+
+	for (i = 0; i < GPA_SIZE / sizeof(*p); i++)
+		p[i] = DIRTY_VAL;
+}
+
+static void guest_code(void)
+{
+	pkvm_guest_init();
+
+	test_meminfo();
+	test_arg_validation();
+	test_share_unshare();
+
+	guest_dirty_region();
+
+	/* Teardown doesn't zero a page the guest left shared. */
+	GUEST_ASSERT_EQ(hvc_share(page_ipa(P_SHARED_AT_TEARDOWN), 0, 0), SMCCC_RET_SUCCESS);
+
+	GUEST_DONE();
+}
+
+static void expect_sea_handler(struct ex_regs *regs)
+{
+	u64 esr = read_sysreg(esr_el1);
+
+	GUEST_ASSERT_EQ(ESR_ELx_EC(esr), ESR_ELx_EC_DABT_CUR);
+	GUEST_ASSERT_EQ(esr & ESR_ELx_FSC_TYPE, ESR_ELx_FSC_EXTABT);
+
+	GUEST_DONE();
+}
+
+static void guest_share_outside(void)
+{
+	pkvm_guest_init();
+
+	hvc_share(OUTSIDE_IPA, 0, 0);
+	GUEST_FAIL("MEM_SHARE of an IPA outside every memslot returned to the guest");
+}
+
+/*
+ * Each fault requires a new stage-2 last-level table, and the first one above
+ * 512G a new table at every level below the root.
+ */
+static void guest_memcache_pressure(void)
+{
+	volatile u64 *p = (volatile u64 *)PRESSURE_GVA;
+	int i;
+
+	pkvm_guest_init();
+
+	for (i = 0; i < PRESSURE_PAGES; i++)
+		p[i * granule / sizeof(*p)] = i + 1;
+	for (i = 0; i < PRESSURE_PAGES; i++)
+		GUEST_ASSERT_EQ(p[i * granule / sizeof(*p)], i + 1);
+
+	GUEST_DONE();
+}
+
+static void guest_touch_one_page(void)
+{
+	pkvm_guest_init();
+
+	*page_va(0) = 1;
+
+	GUEST_DONE();
+}
+
+static sigjmp_buf sigsegv_jmpbuf;
+static volatile void *sigsegv_expected;
+
+/* The test maps the guest memslot itself, so it can read the memory after the VM is freed. */
+static u64 *guest_mem;
+
+static u64 *host_page(int idx)
+{
+	return guest_mem + (size_t)idx * granule / sizeof(*guest_mem);
+}
+
+static void sigsegv_handler(int sig, siginfo_t *si, void *ctx)
+{
+	TEST_ASSERT(si->si_addr == sigsegv_expected,
+		    "SIGSEGV at %p, expected %p", si->si_addr, sigsegv_expected);
+	siglongjmp(sigsegv_jmpbuf, 1);
+}
+
+static void host_access_private(int idx)
+{
+	struct sigaction old, sa = {
+		.sa_sigaction	= sigsegv_handler,
+		.sa_flags	= SA_SIGINFO,
+	};
+	volatile u64 *p = host_page(idx);
+	bool faulted = false;
+
+	sigsegv_expected = (void *)p;
+	sigaction(SIGSEGV, &sa, &old);
+	if (sigsetjmp(sigsegv_jmpbuf, 1) == 0)
+		(*p)++;
+	else
+		faulted = true;
+	sigaction(SIGSEGV, &old, NULL);
+
+	TEST_ASSERT(faulted, "Host accessed private guest memory without faulting");
+}
+
+static void on_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	u64 *p = host_page(uc->args[2]);
+
+	switch (uc->args[1]) {
+	case CMD_HOST_INC_SHARED:
+		(*p)++;
+		break;
+	case CMD_HOST_ACCESS_PRIVATE:
+		host_access_private(uc->args[2]);
+		break;
+	default:
+		TEST_FAIL("Unexpected guest command %lu", uc->args[1]);
+	}
+}
+
+static void assert_page(int idx, u64 val)
+{
+	u64 *p = host_page(idx);
+	size_t i;
+
+	for (i = 0; i < granule / sizeof(*p); i++)
+		TEST_ASSERT(p[i] == val, "Guest page %d holds 0x%lx, not 0x%lx, after teardown",
+			    idx, p[i], val);
+}
+
+static void test_run(void)
+{
+	const char *name = "share/unshare, and teardown zeroing";
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int i;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_code);
+	guest_mem = kvm_mmap(GPA_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	vm_set_user_memory_region2(vm, GUEST_MEMSLOT, 0, GPA_BASE, GPA_SIZE, guest_mem, -1, 0);
+	virt_map(vm, GVA_BASE, GPA_BASE, GPA_SIZE / vm->page_size);
+	write_guest_global(vm, granule, granule);
+
+	pkvm_run_loop(vcpu, on_sync);
+	kvm_vm_free(vm);
+
+	for (i = 0; i < GPA_PAGES; i++)
+		assert_page(i, i == P_SHARED_AT_TEARDOWN ? DIRTY_VAL : 0);
+	kvm_munmap(guest_mem, GPA_SIZE);
+
+	ksft_test_result_pass("%s\n", name);
+}
+
+/*
+ * EL2 turns the share into a stage-2 translation fault on the IPA with ISV clear.
+ * The host finds no memslot for the IPA and injects an external abort.
+ */
+static void test_share_outside_memslot(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_share_outside);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT, ESR_ELx_EC_DABT_CUR, expect_sea_handler);
+
+	pkvm_run_loop(vcpu, NULL);
+	kvm_vm_free(vm);
+
+	ksft_test_result_pass("share of an IPA outside every memslot takes an external abort\n");
+}
+
+static void test_memcache_pressure(void)
+{
+	const char *name = "faults that each require new stage-2 tables";
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	void *mem;
+	int i;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_memcache_pressure);
+
+	/* 32G on a 64K host, of which the guest touches one page per block. */
+	mem = kvm_mmap(PRESSURE_SIZE, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1);
+	vm_set_user_memory_region2(vm, PRESSURE_MEMSLOT, 0, PRESSURE_GPA, PRESSURE_SIZE,
+				   mem, -1, 0);
+	for (i = 0; i < PRESSURE_PAGES; i++)
+		virt_pg_map(vm, PRESSURE_GVA + i * granule, PRESSURE_GPA + i * BLOCK_SIZE);
+	write_guest_global(vm, granule, granule);
+
+	pkvm_run_loop(vcpu, NULL);
+	kvm_vm_free(vm);
+	kvm_munmap(mem, PRESSURE_SIZE);
+
+	ksft_test_result_pass("%s\n", name);
+}
+
+static unsigned long hugetlb_free_pages(void)
+{
+	unsigned long nr = 0;
+	char line[64];
+	FILE *f;
+
+	f = fopen("/proc/meminfo", "r");
+	TEST_ASSERT(f, "fopen /proc/meminfo");
+
+	while (fgets(line, sizeof(line), f)) {
+		if (sscanf(line, "HugePages_Free: %lu", &nr) == 1)
+			break;
+	}
+	fclose(f);
+
+	return nr;
+}
+
+/* Hugetlb pages aren't swap-backed, so the first fault on them fails. */
+static void test_hugetlb_refused(const char *name)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	u64 npages;
+	int ret;
+
+	vm = pkvm_vm_create_with_one_vcpu(&vcpu, guest_touch_one_page);
+	npages = get_backing_src_pagesz(VM_MEM_SRC_ANONYMOUS_HUGETLB) / vm->page_size;
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB, GPA_BASE, GUEST_MEMSLOT,
+				    npages, 0);
+	virt_map(vm, GVA_BASE, GPA_BASE, 1);
+
+	ret = _vcpu_run(vcpu);
+	TEST_ASSERT(ret == -1 && errno == EIO,
+		    "hugetlb-backed memslot: KVM_RUN rc %d errno %d", ret, errno);
+
+	kvm_vm_free(vm);
+
+	ksft_test_result_pass("%s\n", name);
+}
+
+int main(void)
+{
+	const char *hugetlb = "hugetlb memory rejected for a protected VM";
+
+	TEST_REQUIRE(pkvm_supported());
+	granule = getpagesize();
+
+	ksft_print_header();
+	ksft_set_plan(4);
+
+	test_run();
+
+	if (hugetlb_free_pages())
+		test_hugetlb_refused(hugetlb);
+	else
+		ksft_test_result_skip("%s: no hugetlb pages free\n", hugetlb);
+
+	test_share_outside_memslot();
+	test_memcache_pressure();
+
+	ksft_finished();
+}
-- 
2.47.3

