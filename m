Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E683939A2
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318072; cv=none; b=Tv0+lQe+af+bujKvazTvLs1TO9K73N+KDHq7y9vUs+MIXSWL1FsOndMZPJk2cjWQ84jtFTcQIEPTBkKQFon8RJ9+UUyEuONZYUae/nUw8mzkImiUaJKiXYYf/3bDZ17eneWWI9mbNCDlfqh89Wst40hmTmk2MyncUpMZPokn7YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318072; c=relaxed/simple;
	bh=ebP5zQyBtlokNk0ZIVz50RLP5yx+YrveFGACbcsByhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BH3suuu4icR7rkZgTsWwVIPK2ZIdg8yrodo+sEV3qvjATag4CAR9Q7LojlShzSaA3uZBOz7NzqqWYRJm18JNURlJL4cmHvhgTyQxfQagtjnJ38VHX4turYpnOO8ZsXjtSsPQ0eEPoyJrtzjautIkoCGJAZ9slUPG5BMHEPB48mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQ+3+CEK; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQ+3+CEK"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47d1d8a49f5so49114135e9.3
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 07:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768318061; x=1768922861; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5PQLoPw0PMek/LS9vJnQnbwHDO3lcL/jK5ZbU7CCws=;
        b=YQ+3+CEKq0e8KLmKvLx1Zxgae6V805CYyjL4Sgx4IZAVY52fYOjzWpun4OWkH58Q+i
         LVFXBpBYsRX0Y9b+VUQzTurkirTC7jnUss1qM5nGhf2tr/7VXIvEFvcGoHP5q3epqnPH
         js5uMoY698+nq90vW3bjdwiePXMQpnVi7p0KnNe6V+9vzc+j5UYKHVxEAsNWuXXTSufY
         sD6iIVV5ZnUD/VgAwlbPyfO8/EnopUY78O6fn1yakBJfs3IoT1mXdt0CdGrhyUx3egRJ
         Mb0B1W+ia+DK28If7ipsE9jYL80WcsRUT6/iWR3AI4lZm0mambTjtrIJjal4OUyKq0En
         sn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768318061; x=1768922861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x5PQLoPw0PMek/LS9vJnQnbwHDO3lcL/jK5ZbU7CCws=;
        b=tHLO+HDU53vrqKdO9yqiuOFrciqAZQS22VD1yCLZxlMOxhVumJmEbHFiCP2rt7av5Z
         kf1/ae8NgAjTK5K22JvUJe1d9ZHb6uwNmkREV59Wacp2ABlzPN/CSd6BlzjtNAVem5aM
         FYVGKNiiGgxeXSz4EotzqhTGIJZQrJ/IKy0YKztg7z+f9Rr/BgX8xWje3nzl8jwIaXHX
         Oe2z5RGbC4nYPmnM+4Bh3+F+8uUA+/Fx44CRvR7sraP101Cqli8KZt6eyPMqefvX1v75
         cQPc2uLGwjt9FCjCcYsYDhDQosGvTyp8jNaC4qaSEiwc779/fd03G5x8gjBIDxsqQ3ei
         5IDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBcPnOCEwXh/bZj5qf26h99TXRd307/24gmzaQ75cn9k4WUUQc4l9UrSk/Z+ZlhJ+8IsxC55Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBYygWolr5QmLVrk8MK7M7PuXnpm+1D0q5XclgORdsBMLbNgfJ
	oLypEpx7iVVAFqP0aPlZmuIIrbwl3vlIMkLF59k7UdRnJqDqQMfqH9AI
X-Gm-Gg: AY/fxX6vbgO+xqR5wi7d95xPjYO0uYpFlql9fdXoJ2GnbEG1xvRnvgsL3DFcKak2O69
	0b8J01Bv3jgwNx4bVBHv851DOJE6/vCs6E5FYGnPDX2EXNKYFHsoHCIitiWmhw9y9wQImkpLCQL
	1qmKJxlupgbO+GW3c0bsQIJBKHN6wriwTkDHcR2m6cE2SqhRZv3BSR1ZoWTYwlUrOKn33SYgt02
	WBeprxYb8URNhulsdMMloMZfwZuzGUtvQY9hTQYCGw5mMRvc3pUIEG94sfFBJHt18CPbkZCrmUt
	6lZMx5sWXhCHHm5g24CIPVaY0lxp5O5G9dEUL717YVnEe924n44rDCTbKO17ri2OMI7bF/bhjsd
	UTJu+A4BOJ6vejy6UatjUXK5FxG9JZZpS7j2FdbM30HziRtLPf3pjlsSqk3RhvywZEtGdvcCbfB
	Z9P0m5Ih+SZyVzV0CtiE/h0VcvAatZ2O5Wf1iNTNNL+h9CLMYetaGuyjg=
X-Google-Smtp-Source: AGHT+IExCZWJcb/0GZ31JqPekHZy2maoMNKm5K54c/5lKFA3EuWdAV8whKhI88HtcWnW30x8c/SNBQ==
X-Received: by 2002:a05:600c:a04:b0:47d:5dae:73b1 with SMTP id 5b1f17b1804b1-47d84b3b668mr281127875e9.23.1768318060510;
        Tue, 13 Jan 2026 07:27:40 -0800 (PST)
Received: from f4d4888f22f2.ant.amazon.com.com ([15.248.2.27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f68f4ddsm421025325e9.2.2026.01.13.07.27.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 07:27:40 -0800 (PST)
From: Jack Thomson <jackabt.amazon@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	shuah@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	isaku.yamahata@intel.com,
	xmarcalx@amazon.co.uk,
	kalyazin@amazon.co.uk,
	jackabt@amazon.com
Subject: [PATCH v4 2/3] KVM: selftests: Enable pre_fault_memory_test for arm64
Date: Tue, 13 Jan 2026 15:26:41 +0000
Message-ID: <20260113152643.18858-3-jackabt.amazon@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152643.18858-1-jackabt.amazon@gmail.com>
References: <20260113152643.18858-1-jackabt.amazon@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Thomson <jackabt@amazon.com>

Enable the pre_fault_memory_test to run on arm64 by making it work with
different guest page sizes and testing multiple guest configurations.

Update the test_assert to compare against the UCALL_EXIT_REASON, for
portability, as arm64 exits with KVM_EXIT_MMIO while x86 uses
KVM_EXIT_IO.

Signed-off-by: Jack Thomson <jackabt@amazon.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/pre_fault_memory_test.c     | 85 ++++++++++++++-----
 2 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..6d6a74ddad30 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -187,6 +187,7 @@ TEST_GEN_PROGS_arm64 += memslot_perf_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
 TEST_GEN_PROGS_arm64 += rseq_test
 TEST_GEN_PROGS_arm64 += steal_time
+TEST_GEN_PROGS_arm64 += pre_fault_memory_test
 
 TEST_GEN_PROGS_s390 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_s390 += s390/memop
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 93e603d91311..be1a84a6c137 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -11,19 +11,29 @@
 #include <kvm_util.h>
 #include <processor.h>
 #include <pthread.h>
+#include <guest_modes.h>
 
 /* Arbitrarily chosen values */
-#define TEST_SIZE		(SZ_2M + PAGE_SIZE)
-#define TEST_NPAGES		(TEST_SIZE / PAGE_SIZE)
+#define TEST_BASE_SIZE		SZ_2M
 #define TEST_SLOT		10
 
-static void guest_code(uint64_t base_gva)
+/* Storage of test info to share with guest code */
+struct test_config {
+	uint64_t page_size;
+	uint64_t test_size;
+	uint64_t test_num_pages;
+};
+
+static struct test_config test_config;
+
+static void guest_code(uint64_t base_gpa)
 {
 	volatile uint64_t val __used;
+	struct test_config *config = &test_config;
 	int i;
 
-	for (i = 0; i < TEST_NPAGES; i++) {
-		uint64_t *src = (uint64_t *)(base_gva + i * PAGE_SIZE);
+	for (i = 0; i < config->test_num_pages; i++) {
+		uint64_t *src = (uint64_t *)(base_gpa + i * config->page_size);
 
 		val = *src;
 	}
@@ -56,7 +66,7 @@ static void *delete_slot_worker(void *__data)
 		cpu_relax();
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, data->gpa,
-				    TEST_SLOT, TEST_NPAGES, data->flags);
+				    TEST_SLOT, test_config.test_num_pages, data->flags);
 
 	return NULL;
 }
@@ -159,22 +169,35 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
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
 	uint64_t gpa, gva, alignment, guest_page_size;
+	struct test_params *p = arg;
 	const struct vm_shape shape = {
-		.mode = VM_MODE_DEFAULT,
-		.type = vm_type,
+		.mode = guest_mode,
+		.type = p->vm_type,
 	};
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
 	struct ucall uc;
 
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(guest_mode));
+
 	vm = vm_create_shape_with_one_vcpu(shape, &vcpu, guest_code);
 
-	alignment = guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
-	gpa = (vm->max_gfn - TEST_NPAGES) * guest_page_size;
+	guest_page_size = vm_guest_mode_params[guest_mode].page_size;
+
+	test_config.page_size = guest_page_size;
+	test_config.test_size = TEST_BASE_SIZE + test_config.page_size;
+	test_config.test_num_pages = vm_calc_num_guest_pages(vm->mode, test_config.test_size);
+
+	gpa = (vm->max_gfn - test_config.test_num_pages) * test_config.page_size;
 #ifdef __s390x__
 	alignment = max(0x100000UL, guest_page_size);
 #else
@@ -183,23 +206,32 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	gpa = align_down(gpa, alignment);
 	gva = gpa & ((1ULL << (vm->va_bits - 1)) - 1);
 
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa, TEST_SLOT,
-				    TEST_NPAGES, private ? KVM_MEM_GUEST_MEMFD : 0);
-	virt_map(vm, gva, gpa, TEST_NPAGES);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    gpa, TEST_SLOT, test_config.test_num_pages,
+				    p->private ? KVM_MEM_GUEST_MEMFD : 0);
+	virt_map(vm, gva, gpa, test_config.test_num_pages);
+
+	if (p->private)
+		vm_mem_set_private(vm, gpa, test_config.test_size);
+	pre_fault_memory(vcpu, gpa, 0, TEST_BASE_SIZE, 0, p->private);
+	/* Test pre-faulting over an already faulted range */
+	pre_fault_memory(vcpu, gpa, 0, TEST_BASE_SIZE, 0, p->private);
+	pre_fault_memory(vcpu, gpa, TEST_BASE_SIZE,
+			 test_config.page_size * 2, test_config.page_size, p->private);
+	pre_fault_memory(vcpu, gpa, test_config.test_size,
+			 test_config.page_size, test_config.page_size, p->private);
 
-	if (private)
-		vm_mem_set_private(vm, gpa, TEST_SIZE);
+	vcpu_args_set(vcpu, 1, gva);
 
-	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
-	pre_fault_memory(vcpu, gpa, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
-	pre_fault_memory(vcpu, gpa, TEST_SIZE, PAGE_SIZE, PAGE_SIZE, private);
+	/* Export the shared variables to the guest. */
+	sync_global_to_guest(vm, test_config);
 
-	vcpu_args_set(vcpu, 1, gva);
 	vcpu_run(vcpu);
 
 	run = vcpu->run;
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Wanted KVM_EXIT_IO, got exit reason: %u (%s)",
+	TEST_ASSERT(run->exit_reason == UCALL_EXIT_REASON,
+		    "Wanted %s, got exit reason: %u (%s)",
+		    exit_reason_str(UCALL_EXIT_REASON),
 		    run->exit_reason, exit_reason_str(run->exit_reason));
 
 	switch (get_ucall(vcpu, &uc)) {
@@ -218,18 +250,25 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 
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
 }
 
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PRE_FAULT_MEMORY));
 
+	guest_modes_append_default();
+
 	test_pre_fault_memory(0, false);
 #ifdef __x86_64__
 	test_pre_fault_memory(KVM_X86_SW_PROTECTED_VM, false);
-- 
2.43.0

