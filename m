Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3D334041D;
	Tue, 25 Aug 2026 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673710; cv=none; b=LRrJIpn5yBnv/xEV0ZzrJl5TBJxATpL3C9e5pTHisDv324zQgF+lQe9CDWqnpWxtLu1j1vvntyx8hzvklEdsyDEIwKoNBnIAhsYWRbglQRoC/LaQGDdsJO6+assTfJ7M1UXuwwC11NkQz/wIrZqEFzmpxoRfT45OtjhfX2c+/yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673710; c=relaxed/simple;
	bh=IZ/Xs5TvGOQD7uw0TKqgAfrUBwPUr+hKALeLx177jmU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ankVbQWc1t0oqfpomebgems2jjJ4/e+BCaIgjQyx3Zm+Qu5Ki+puMfp0mxotrvxOUbCAjlq8z8BBW5ggqRlT8mYqnK2zrUUs5MOltsNEPZGEgIHrvO11wxKimrbVA+dDHr6garkwy+PD915AiEtUUymQCtiaKp9XojX/yOXqflI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNyhkK1J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNyhkK1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BCA1F000E9;
	Tue, 25 Aug 2026 16:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673709;
	bh=2QmTKWBAQNYmpr1gvX/qlAg50jxayUk+Ya6iK3WkxcY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gNyhkK1JMWcr3YP3IzLLN1sB2uxkEZtANLng+EY+H6V7Xqt8FiWpTP2E8Ik9tgwOW
	 B7MGAL5rUBqJYwftpVXaaVy/RUqwkc5DIKfmrz6goizPmWdVZhEDV5NfNx1AQwHuZh
	 MZikVf/oza+X3vU8UyG46+eQ4+JjjjJPuMac3dGR8xgByEwLOnBxJKLgcx8Jp0sps3
	 j+iIQobJw0xeRel5/cEfcyW7Q1/b+yH7EY71Gu45mGAnFuFCUrqCCIV8F4iQbrnyY7
	 alhP8mVwGENMRw1IPCTIKaZgSi52pf9OTc7RfXv+U5hSdp57MUOFtTSrts+H0WoVNo
	 EKFkQyazOhEMg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 25 Aug 2026 17:00:40 +0100
Subject: [PATCH 6/8] KVM: selftests: Enable pre_fault_memory_test for arm64
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-kvm-arm-prefault-v1-6-befe8947702e@kernel.org>
References: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
In-Reply-To: <20260825-kvm-arm-prefault-v1-0-befe8947702e@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
 Jack Thomson <jackabt.amazon@gmail.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>, 
 Vincent Donnefort <vdonnefort@google.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Leo Soares Passos <Leo.Bras@arm.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7536; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ipOghwD1cyVJpKN91gzBqnU0uoGWRVuwEpkouBW6IVo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJ69zgf6zhyxHjJ/4qU1g06p5L3SETIs23uyje1l6rRd
 Mw922DfUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIkkJjH8szd46tllFfT2zZNJ
 gqu/qFu4RW+w2Rqlx+2/qvXGj20FRgz/807J+zcXZ2+a/dXveVRjnszH/Ncz/mWuiJnD8WnOUeV
 z7AA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

From: Jack Thomson <jackabt@amazon.com>

Enable the pre_fault_memory_test to run on arm64 by making it work with
different guest page sizes and testing multiple guest configurations.

Update the test_assert to compare against the UCALL_EXIT_REASON, for
portability, as arm64 exits with KVM_EXIT_MMIO while x86 uses
KVM_EXIT_IO.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
[ljs: merge conflict resolution with commit c847704619da]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../testing/selftests/kvm/pre_fault_memory_test.c  | 117 +++++++++++++++++----
 2 files changed, 96 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 5f8d17ee5f67..66a9a4e62888 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -199,6 +199,7 @@ TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
 TEST_GEN_PROGS_arm64 += rseq_test
 TEST_GEN_PROGS_arm64 += steal_time
+TEST_GEN_PROGS_arm64 += pre_fault_memory_test
 
 TEST_GEN_PROGS_s390 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_s390 += s390/memop
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index a0fcae3cb7a8..ee77c51cc566 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -12,19 +12,29 @@
 #include <processor.h>
 #include <pthread.h>
 #include <ucall_common.h>
+#include <guest_modes.h>
 
 /* Arbitrarily chosen values */
-#define TEST_SIZE		(SZ_2M + PAGE_SIZE)
-#define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
+#define TEST_BASE_SIZE		SZ_2M
 #define TEST_SLOT		10
 
+/* Storage of test info to share with guest code */
+struct test_config {
+	u64 page_size;
+	u64 test_size;
+	u64 test_num_pages;
+};
+
+static struct test_config test_config;
+
 static void guest_code(u64 base_gva)
 {
 	volatile u64 val __used;
+	struct test_config *config = &test_config;
 	int i;
 
-	for (i = 0; i < TEST_NPAGES; i++) {
-		u64 *src = (u64 *)(base_gva + i * PAGE_SIZE);
+	for (i = 0; i < config->test_num_pages; i++) {
+		u64 *src = (u64 *)(base_gva + i * config->page_size);
 
 		val = *src;
 	}
@@ -57,7 +67,7 @@ static void *delete_slot_worker(void *__data)
 		cpu_relax();
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, data->gpa,
-				    TEST_SLOT, TEST_NPAGES, data->flags);
+				    TEST_SLOT, test_config.test_num_pages, data->flags);
 
 	return NULL;
 }
@@ -150,8 +160,8 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 	/*
 	 * Assert success if prefaulting the entire range should succeed, i.e.
 	 * complete with no bytes remaining.  Otherwise prefaulting should have
-	 * failed due to ENOENT (due to RET_PF_EMULATE for emulated MMIO when
-	 * no memslot exists).
+	 * failed due to ENOENT (no memslot exists for the GPA; on x86 this
+	 * surfaces via RET_PF_EMULATE).
 	 */
 	if (!expected_left)
 		TEST_ASSERT_VM_VCPU_IOCTL(!ret, KVM_PRE_FAULT_MEMORY, ret, vcpu->vm);
@@ -160,39 +170,72 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
 					  KVM_PRE_FAULT_MEMORY, ret, vcpu->vm);
 }
 
-static void __test_pre_fault_memory(unsigned long vm_type, bool private)
+struct test_params {
+	unsigned long vm_type;
+	bool private;
+};
+
+static void __test_pre_fault_memory(enum vm_guest_mode guest_mode, void *arg)
 {
-	gpa_t gpa, gva, alignment, guest_page_size;
+	gpa_t gpa, gva, alignment, guest_page_size, host_page_size;
+	struct test_params *p = arg;
 	const struct vm_shape shape = {
-		.mode = VM_MODE_DEFAULT,
-		.type = vm_type,
+		.mode = guest_mode,
+		.type = p->vm_type,
 	};
 	struct kvm_vcpu *vcpu;
+	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
 
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(guest_mode));
+
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
-	alignment = guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
-	gpa = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
+	guest_page_size = vm_guest_mode_params[guest_mode].page_size;
+	host_page_size = getpagesize();
+
+	test_config.page_size = guest_page_size;
+	test_config.test_size = align_up(TEST_BASE_SIZE + test_config.page_size,
+					 host_page_size);
+	test_config.test_num_pages = vm_calc_num_guest_pages(vm->mode, test_config.test_size);
+
+	gpa = (vm->max_gfn - test_config.test_num_pages) * test_config.page_size;
 	alignment = SZ_2M;
+	alignment = max(alignment, host_page_size);
 	gpa = align_down(gpa, alignment);
 	gva = gpa & ((1ULL << (vm->va_bits - 1)) - 1);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, TEST_SLOT,
-				    TEST_NPAGES, private ? KVM_MEM_GUEST_MEMFD : 0);
-	virt_map(vm, gva, gpa, TEST_NPAGES);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    gpa, TEST_SLOT, test_config.test_num_pages,
+				    p->private ? KVM_MEM_GUEST_MEMFD : 0);
+	virt_map(vm, gva, gpa, test_config.test_num_pages);
 
-	if (private)
-		vm_mem_set_private(vm, gpa, TEST_SIZE);
+	if (p->private)
+		vm_mem_set_private(vm, gpa, test_config.test_size);
 
-	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
-	pre_fault_memory(vcpu, gpa, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
-	pre_fault_memory(vcpu, gpa, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
+	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0, p->private);
+	/* Retry the same range after the first prefault attempt. */
+	pre_fault_memory(vcpu, gpa, 0, test_config.test_size, 0, p->private);
+	pre_fault_memory(vcpu, gpa,
+			 test_config.test_size - host_page_size,
+			 host_page_size * 2, host_page_size, p->private);
+	pre_fault_memory(vcpu, gpa, test_config.test_size,
+			 host_page_size, host_page_size, p->private);
 
 	vcpu_args_set(vcpu, 1, gva);
+
+	/* Export the shared variables to the guest. */
+	sync_global_to_guest(vm, test_config);
+
 	vcpu_run(vcpu);
 
+	run = vcpu->run;
+	TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
+		    "Wanted %s, got exit reason: %u (%s)",
+		    exit_reason_str(UCALL_EXIT_REASON),
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
 		REPORT_GUEST_ASSERT(uc);
@@ -209,16 +252,46 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 
 static void test_pre_fault_memory(unsigned long vm_type, bool private)
 {
+	struct test_params p = {
+		.vm_type = vm_type,
+		.private = private,
+	};
+
 	if (vm_type && !(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type))) {
 		pr_info("Skipping tests for vm_type 0x%lx\n", vm_type);
 		return;
 	}
 
-	__test_pre_fault_memory(vm_type, private);
+	for_each_guest_mode(__test_pre_fault_memory, &p);
+}
+
+static void help(char *name)
+{
+	puts("");
+	printf("usage: %s [-h] [-m mode]\n", name);
+	puts("");
+	guest_modes_help();
+	puts("");
 }
 
 int main(int argc, char *argv[])
 {
+	int opt;
+
+	guest_modes_append_default();
+
+	while ((opt = getopt(argc, argv, "hm:")) != -1) {
+		switch (opt) {
+		case 'm':
+			guest_modes_cmdline(optarg);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			exit(0);
+		}
+	}
+
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
 
 	test_pre_fault_memory(0, false);

-- 
2.55.0

