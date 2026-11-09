Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.38
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794214196;
	b=PT6Awox49mRoc6rFKdiCLtqow8VoeAFUucy66HCb3yjtSB0sAbBdKiWiBydgggKmkMAk
	 PPD87vV1R0bng3WNK+rOfv4YtTRHvVjifT1iiCTxGAUNDGhMbT93f/G5uP56tO9z6+ugS
	 FeJf7B0o7mK8uyvGRqMxLg42QGLd10Z3r28PKKQH8LBmYSkVND7fmIgxu8ycG9D/Aayes
	 Jdd+U2iBtYfylq2Cf4sN7Yw6XUf/DZKsk7XgX2Fi2OYgRuPUJh4Emda0XCpFpxcxZMHwi
	 pudiUfYcIPtwDK62AtoD7VIT8H2SxCc4NTMpJcKdhmqVXRoSI8ijRSTl8BkzmwmgSrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794214196;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/IWC4Ezrv13mnRLgYAS+OGpQRhiZxP+CWXUuP5MxY5k=;
	b=0O1vky3aHPGmr1preP9qWQKFyDHjtq9uPdgZNyrYd/qY7gg+6IsLufUjzBDCmcK2KPe1
	 4Uy46vvGZ1MiJXbKsFUd0cuQFlKBb7IZatYRDmSZILPGj/aJ6Wg013iJFzMfHFaa/MgVE
	 xhsZaKwCvDJTXlzUs8oC8Xf/ImTADwDZnLwYmcem2r18mzIkeTgHpOhB6fqQMENEHLPXN
	 qfGe3EYjt9+b8DEWXi0naZ5eNS37LMv8C5mQPqSCSbglf/v6kbeauI5S3ztGlXscN9WnY
	 dm8ngWTmAreZh/fBcmsNv5wQgWnnRDioUxSfoz8pl9Go6JqzL/fGmz1aVTqBfMXBsNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p2blvFPa;
	arc=none smtp.remote-ip=95.215.58.38
Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF105606EEB5
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF105606EEB5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p2blvFPa
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=skF3Q2kCAVK6QTvon75TdZ0hQ5efPIx2rz2Mq7wxPjQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794214193; v=1; x=1794818993;
 b=p2blvFPas2dHVup8gOoWIvdycqKygalVMSGl9x3nfg60jvl38GtLQo+TqjklTn8BDJgnJuIq
 3V0a3/4tRARL3wVhhaBETVeTWZqJ1siU7d0WtIsi8hmOqg5H2wS+rt+3PrpTSkdn1uBAXJHP6vt
 wyjFqHmZPjn9d4s/T6YKLzXA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3788735acdf328b4;
	Mon, 09 Nov 2026 08:49:53 +0000
X-Mizu-Trace-ID: 3788735acdf328b4
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
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
Subject: [PATCH v2 15/19] KVM: arm64: selftests: Add pkvm_isolation host-access test
Date: Mon,  9 Nov 2026 08:48:50 +0000
Message-ID: <20261109084854.840576-16-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109084854.840576-1-fuad.tabba@linux.dev>
References: <20261109084854.840576-1-fuad.tabba@linux.dev>
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

The host keeps its userspace mapping of a protected guest's memory, but
can't reach the data through it. The host kernel's copy_to_user() and
copy_from_user() on that mapping fail. If the host kernel pins a page
and accesses it through its own mapping, as process_vm_readv() does,
EL2 zeroes and reclaims the page, and the guest loses it.

Test each of these, that MADV_DONTNEED and munmap() leave the guest's
pages pinned and accounted, and that a normal VM's fault on them fails.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/pkvm_isolation.c      | 225 ++++++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/pkvm_isolation.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 13998964facd5..68bdd01f62270 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -193,6 +193,7 @@ TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/pkvm_host_abi
 TEST_GEN_PROGS_arm64 += arm64/pkvm_id_regs
 TEST_GEN_PROGS_arm64 += arm64/pkvm_irq
+TEST_GEN_PROGS_arm64 += arm64/pkvm_isolation
 TEST_GEN_PROGS_arm64 += arm64/pkvm_mem_share
 TEST_GEN_PROGS_arm64 += arm64/pkvm_psci
 TEST_GEN_PROGS_arm64 += arm64/pkvm_smccc
diff --git a/tools/testing/selftests/kvm/arm64/pkvm_isolation.c b/tools/testing/selftests/kvm/arm64/pkvm_isolation.c
new file mode 100644
index 0000000000000..f083d0434238a
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/pkvm_isolation.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pkvm_isolation - what the host can and can't do with a protected VM's memory.
+ *
+ * Copyright (C) 2026 Google LLC
+ * Author: Fuad Tabba <fuad.tabba@linux.dev>
+ */
+
+#include <errno.h>
+#include <sys/mman.h>
+#include <sys/uio.h>
+#include <unistd.h>
+
+#include "kvm_util.h"
+#include "pkvm.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define DATA_MEMSLOT	(PKVM_IDMAP_MEMSLOT + 1)
+#define DATA_GPA	BIT_ULL(30)
+#define DATA_PAGES	16
+#define DATA_SIZE	((size_t)DATA_PAGES * MIN_PAGE_SIZE)
+
+#define GUEST_VAL	0x0badf00ddeadbeefUL
+#define HOST_VAL	0x0123456789abcdefUL
+
+static volatile u64 *page_va(int idx)
+{
+	return (volatile u64 *)(DATA_GPA + (u64)idx * MIN_PAGE_SIZE);
+}
+
+/* The host acts on the guest's memory at the sync, then the guest checks it. */
+static void guest_code(void)
+{
+	int i;
+
+	pkvm_guest_init();
+
+	for (i = 0; i < DATA_PAGES; i++)
+		*page_va(i) = GUEST_VAL + i;
+
+	GUEST_SYNC(0);
+
+	for (i = 0; i < DATA_PAGES; i++)
+		GUEST_ASSERT_EQ(*page_va(i), GUEST_VAL + i);
+
+	GUEST_DONE();
+}
+
+static void guest_np_read(void)
+{
+	*page_va(0);
+	GUEST_DONE();
+}
+
+/* The host kernel's copy to or from private memory faults, and the uaccess fixup fails it. */
+static void host_write_from_private(void *hva)
+{
+	ssize_t ret;
+	int fds[2];
+
+	TEST_ASSERT(!pipe(fds), "pipe: errno %d", errno);
+
+	ret = write(fds[1], hva, MIN_PAGE_SIZE);
+	TEST_ASSERT(ret == -1 && errno == EFAULT,
+		    "write() from private memory: rc %zd errno %d", ret, errno);
+
+	close(fds[0]);
+	close(fds[1]);
+}
+
+static void host_read_into_private(void *hva)
+{
+	u64 val = HOST_VAL;
+	ssize_t ret;
+	int fds[2];
+
+	TEST_ASSERT(!pipe(fds), "pipe: errno %d", errno);
+	TEST_ASSERT_EQ(write(fds[1], &val, sizeof(val)), sizeof(val));
+
+	ret = read(fds[0], hva, sizeof(val));
+	TEST_ASSERT(ret == -1 && errno == EFAULT,
+		    "read() into private memory: rc %zd errno %d", ret, errno);
+
+	close(fds[0]);
+	close(fds[1]);
+}
+
+/* The host's long-term pins keep the guest's pages and their locked-memory accounting. */
+static void host_dontneed(void *hva)
+{
+	size_t locked = pkvm_host_locked_vm();
+
+	kvm_madvise(hva, DATA_SIZE, MADV_DONTNEED);
+	TEST_ASSERT_EQ(pkvm_host_locked_vm(), locked);
+
+	/* The host's mapping now has a new page, which the guest doesn't see. */
+	TEST_ASSERT_EQ(*(u64 *)hva, 0);
+	*(u64 *)hva = HOST_VAL;
+}
+
+static void host_munmap(void *hva)
+{
+	size_t locked = pkvm_host_locked_vm();
+
+	kvm_munmap(hva, DATA_SIZE);
+	TEST_ASSERT_EQ(pkvm_host_locked_vm(), locked);
+}
+
+/* A normal VM's fault on private memory fails, and the protected guest keeps its data. */
+static void host_np_vm_on_private(void *hva)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_np_read);
+	vm_set_user_memory_region(vm, DATA_MEMSLOT, 0, DATA_GPA, getpagesize(), hva);
+	virt_map(vm, DATA_GPA, DATA_GPA, 1);
+
+	ret = _vcpu_run(vcpu);
+	TEST_ASSERT(ret == -1 && errno == EPERM,
+		    "normal VM's fault on private memory: rc %d errno %d", ret, errno);
+
+	kvm_vm_free(vm);
+}
+
+static void (*host_action)(void *hva);
+
+static void on_sync(struct kvm_vcpu *vcpu, struct ucall *uc)
+{
+	host_action(addr_gpa2hva(vcpu->vm, DATA_GPA));
+}
+
+static struct kvm_vm *vm_create_with_data(struct kvm_vcpu **vcpu)
+{
+	struct kvm_vm *vm = pkvm_vm_create_with_one_vcpu(vcpu, guest_code);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, DATA_GPA, DATA_MEMSLOT,
+				    DATA_PAGES, 0);
+	virt_map(vm, DATA_GPA, DATA_GPA, DATA_PAGES);
+	return vm;
+}
+
+static void test_host_access(void (*action)(void *hva), const char *name)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create_with_data(&vcpu);
+
+	host_action = action;
+	pkvm_run_loop(vcpu, on_sync);
+
+	kvm_vm_free(vm);
+	TEST_ASSERT_EQ(pkvm_host_locked_vm(), 0);
+
+	ksft_test_result_pass("%s\n", name);
+}
+
+/*
+ * The host never reads the guest's data: a kernel copy from private memory
+ * reads zeros, and the guest's next access to the page fails.
+ */
+static void test_process_vm_readv(void)
+{
+	u64 buf[2] = { HOST_VAL, HOST_VAL };
+	struct iovec local = { .iov_base = buf, .iov_len = sizeof(buf) };
+	struct kvm_vcpu *vcpu;
+	struct iovec remote;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	ssize_t ret;
+	int i;
+
+	vm = vm_create_with_data(&vcpu);
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+
+	remote = (struct iovec){ .iov_base = addr_gpa2hva(vm, DATA_GPA), .iov_len = sizeof(buf) };
+	ret = process_vm_readv(getpid(), &local, 1, &remote, 1, 0);
+	TEST_ASSERT_EQ(ret, sizeof(buf));
+	for (i = 0; i < ARRAY_SIZE(buf); i++)
+		TEST_ASSERT(!buf[i], "process_vm_readv() of private memory read 0x%lx", buf[i]);
+
+	/* The guest's next access is its read of that page. */
+	ret = _vcpu_run(vcpu);
+	TEST_ASSERT(ret == -1 && errno == EFAULT,
+		    "guest access after process_vm_readv(): rc %zd errno %d", ret, errno);
+
+	kvm_vm_free(vm);
+	TEST_ASSERT_EQ(pkvm_host_locked_vm(), 0);
+
+	ksft_test_result_pass("process_vm_readv() of private memory reads no guest data\n");
+}
+
+static const struct {
+	void (*action)(void *hva);
+	const char *name;
+} host_accesses[] = {
+	{ host_write_from_private, "write() from private memory fails with EFAULT" },
+	{ host_read_into_private, "read() into private memory fails with EFAULT" },
+	{ host_dontneed, "MADV_DONTNEED of private memory leaves the guest's data" },
+	{ host_munmap, "munmap() of private memory leaves the guest's data" },
+};
+
+int main(void)
+{
+	const char *np_vm = "a normal VM's fault on private memory fails with EPERM";
+	int i;
+
+	TEST_REQUIRE(pkvm_supported());
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(host_accesses) + 2);
+
+	for (i = 0; i < ARRAY_SIZE(host_accesses); i++)
+		test_host_access(host_accesses[i].action, host_accesses[i].name);
+
+	test_process_vm_readv();
+
+	test_host_access(host_np_vm_on_private, np_vm);
+
+	ksft_finished();
+}
-- 
2.47.3

