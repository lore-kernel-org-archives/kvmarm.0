Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782221;
	b=M2BRyJTaL4xz0oge8URNfpXbQyMArN6xASISrjcSJ79Yq9LvJt6MF8g5Yq/YZP25UI3P
	 gVcZfDkJCY1f7iFzhU9iG6LBN5U+3lUrBEtsJqKFYB4OTAdOBcQ7rpvj6xXnhKWqB51mp
	 oJ21IL4SQCizSKKqjvn78Xh311s2EB1mpTdFxHCwDi5w+GByvWbrf3ueoHLzKIFoszF3l
	 qVrUKNZ8wl7XkOI/iSp5Q20oLP6kJzKWOEeIDEBwxydz8SxpNwwJshVrOTq4jDAHLQi9k
	 zuA31Dx7sevj+02SkI+OJnM0VhSzSVkdUReE/BZRP+HEOzIxxnv0p3DpPcHfnrLbGwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782221;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=t+dNl0XBfefdZ7Aqs3DQ8OFFEYE7S1iwmTRbK1dZAOc=;
	b=CND6gWk/Q8DUxCeF0ovR8fTlWvnla2SpICdIPPqje/S0VGi9+m6MtUMcsoBWFUdinIWD
	 mkEapXB6GdTX8MXv8LeoMxRgSa4Dtnogzd8PznjO/+BBfY69X1cGZvH8aGOfquI4PIilo
	 jLsMh/MjQ4cCMEJbc8su5r+iwJkJ7YVuqxzw+brSE1a9X65ALJILWLx79c+UjN35Org44
	 uf+jREybHyrBOsaqu9Sq8wnJjOFLdw7IuPzlNpX9Po8pEw3T9xFx9NAMO5i1NXE3l8j5X
	 UBtMmn5adJoUAbizxMIOkESU1QWdPdWgS5AXnuZuO0m4+vb6qvGiQ8lgkVyhOE+qGog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p35OWFeu;
	arc=none smtp.remote-ip=95.215.58.209
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A563606A31B
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 08:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A563606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=p35OWFeu
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=E2iiyXnW3jbLG37lTxvcZlTYNjiFz2VI30yMsrKtJSk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793782218; v=1; x=1794387018;
 b=p35OWFeu+z6oG74IxKrmP/l/ExYMItsO6UTEVGwsy2/xKdCCZ9kVmAZ8AvLLX+OnvKpa+9Ok
 J9tFWCOIOm4Dsy8y8FymE3SVIu4Xds0klAJCcAMS0sWlFm4C6plWL5XYI+DnYWZIkrDLswY48fb
 Xb90E1QCY2xxmpv+KpVcS4I8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 29e6b45fb9ddb737;
	Wed, 04 Nov 2026 08:50:16 +0000
X-Mizu-Trace-ID: 29e6b45fb9ddb737
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
Subject: [PATCH 14/16] KVM: arm64: selftests: Add pkvm_isolation host-access test
Date: Wed,  4 Nov 2026 08:48:40 +0000
Message-ID: <20261104084842.132944-15-fuad.tabba@linux.dev>
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

When a protected guest faults its memory in, the host donates its
pages through EL2 and keeps its userspace mapping of them. Nothing the
host does through that mapping exposes the guest's data. The host
kernel's copy_to_user() and copy_from_user() on that mapping fail. When
the host kernel pins such a page and accesses it through its own
mapping, as process_vm_readv() does, EL2 reclaims the page instead. EL2
zeroes the page before giving it back, and the guest loses it.

Test that the host kernel's copies to and from that memory fail with
EFAULT, that process_vm_readv() of it reads zeros and KVM_RUN then fails
at the guest's next access to the page, that MADV_DONTNEED and munmap()
leave the guest's pages pinned and accounted, and that a normal VM's
fault on them fails.

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
index 0000000000000..fd59e5c6e473c
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
+	TEST_ASSERT(!madvise(hva, DATA_SIZE, MADV_DONTNEED), "madvise: errno %d", errno);
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
+	TEST_ASSERT(!munmap(hva, DATA_SIZE), "munmap: errno %d", errno);
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

