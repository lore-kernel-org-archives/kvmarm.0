Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913192E5403
	for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 10:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753267662; cv=none; b=cAHrIomnRMv4FrFI+msVlKtTWkJswlPklh+qdfz9Dclv6Lan/4vtEHD4hXyQst3+YUOhA/sX8Dt6DoQ1Gm5G029gepJyR8uh+iqmVQGHtWpjtYbzUp4Tg8mHf9jicM9ogbphDp1A8s9HqgWOkxyPAJab3RV5VZA2X/S7ep4ghdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753267662; c=relaxed/simple;
	bh=Kq6PmXNVPVNZTGvw1rZ4Un1GI+UwNCa7BO9103toUi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iK+Y1kAplpT6AA+QXcVj++tOL97v8tdm70M8w287LrRaLOhM3fFYr21xbV8n8hwFpQQ6zSPp4ATHxBTBEDw7Q0A5Wdds/vt9eHvpOf+wSy9rQdVwdSec7lNJur52vvEEXaF8qBNBY4BnQXYEJlKZW1oK7zCqRYCGkyM3+F67K7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tKX8Ka+t; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tKX8Ka+t"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4560a30a793so26731955e9.3
        for <kvmarm@lists.linux.dev>; Wed, 23 Jul 2025 03:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267659; x=1753872459; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d5hGo3nn+2nj2a3HbRALDwA7qk9YZQrlMbSjM7BcAIQ=;
        b=tKX8Ka+tre82+mqHmBGU+Pg4wygKAy6Wal3e/iMcmSMRzEDIQE6tUzPjRhwnX64aSw
         27pT4NkWvy36L/xuqrB0wDD47T9cn4gzB9e/7HlhNNwcFmSiJBe4LUGD9W9xDp1QNDcZ
         jLVBfw+Knjo4Wzi6fH/ZbnpJq/RuFh6dND5yTJ6lUSDpCNaoJ4CYfQ6Uo8JoiMIyBDTC
         g6AsE4mTE9NPaNCjhT+IIUYbwK2pwnacdGRgoMldewCOeTVN4LbK1Gc4moqiT1WeXSqR
         gG9iAu09hPBNLDodd5s6k9TS5RP0/KM3k00Mz+jHc0Ps7tAFL11W0HjvQAtrHlCkkieo
         yhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267659; x=1753872459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5hGo3nn+2nj2a3HbRALDwA7qk9YZQrlMbSjM7BcAIQ=;
        b=CkSC+P70LqgMbEUqrZMXVSFXlT2n7AgeOm488Xdm42WqaroJ81AkAW0vYpRZMZQmMD
         aIocsyjoKX/a2batShB9NNT2SKB6a4my5t0esfJnoo1dw2VHLRwUiHE6nqOQkJHyOXSN
         VknEXhITn7Gp/0mYJloc7F1A4DxdmacMG8bKOJi8h3fNbFY2hXCmoe1c3bFD941iZX7Q
         csoziXNWja9umMePF7mEaY/xUtc48PHnZikegUCHQ7cXgOA++UrDSzwCLg777ZouCGh4
         j+i2BzSGv8sqvEfSr+UoUW9r7k4SKzqPcZypVCesbXUehyO5n1EmfTZ3LZaSkz2y7Sje
         FECw==
X-Forwarded-Encrypted: i=1; AJvYcCXCpQ+hm8JeXkenVK8lW2FUYYiwxuy13M867pcWsx/NGttjP7dINnmpn1QLFVSCpU+hIGUkEiI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKTfjajDugUk591+nvU1arj8xg9a9EooPHaTE5cMpF3AcRvxwD
	yucmQv+qw6B6m2bGE+Fxa4HdNteV0bjh3w/SU8f6I7XjKPYBRc31gzYpV60WcMOeMCzacmWmyPO
	+CQ==
X-Google-Smtp-Source: AGHT+IEN2ng1iBiQj/hOpJ7Jz7J3gbvaCwPkqEq6kCkN7K7pfMdbdTtgVfhLQcA0SIIMDYrrycOWegtIzA==
X-Received: from wmbeq10.prod.google.com ([2002:a05:600c:848a:b0:456:257a:e323])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b2e:b0:43e:bdf7:7975
 with SMTP id 5b1f17b1804b1-45868d53277mr19005515e9.32.1753267658788; Wed, 23
 Jul 2025 03:47:38 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:14 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-23-tabba@google.com>
Subject: [PATCH v16 22/22] KVM: selftests: guest_memfd mmap() test when mmap
 is supported
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Expand the guest_memfd selftests to comprehensively test host userspace
mmap functionality for guest_memfd-backed memory when supported by the
VM type.

Introduce new test cases to verify the following:

* Successful mmap operations: Ensure that MAP_SHARED mappings succeed
  when guest_memfd mmap is enabled.

* Data integrity: Validate that data written to the mmap'd region is
  correctly persistent and readable.

* fallocate interaction: Test that fallocate(FALLOC_FL_PUNCH_HOLE)
  correctly zeros out mapped pages.

* Out-of-bounds access: Verify that accessing memory beyond the
  guest_memfd's size correctly triggers a SIGBUS signal.

* Unsupported mmap: Confirm that mmap attempts fail as expected when
  guest_memfd mmap support is not enabled for the specific guest_memfd
  instance or VM type.

* Flag validity: Introduce test_vm_type_gmem_flag_validity() to
  systematically test that only allowed guest_memfd creation flags are
  accepted for different VM types (e.g., GUEST_MEMFD_FLAG_MMAP for
  default VMs, no flags for CoCo VMs).

The existing tests for guest_memfd creation (multiple instances, invalid
sizes), file read/write, file size, and invalid punch hole operations
are integrated into the new test_with_type() framework to allow testing
across different VM types.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 194 ++++++++++++++++--
 1 file changed, 173 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 341ba616cf55..a0c5db8fd72d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,6 +13,8 @@
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <setjmp.h>
+#include <signal.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
+{
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+
+	memset(mem, val, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			page_size);
+	TEST_ASSERT(!ret, "fallocate the first page should succeed.");
+
+	for (i = 0; i < page_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), 0x00);
+	for (; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	memset(mem, val, page_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+}
+
+static sigjmp_buf jmpbuf;
+void fault_sigbus_handler(int signum)
+{
+	siglongjmp(jmpbuf, 1);
+}
+
+static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
+{
+	struct sigaction sa_old, sa_new = {
+		.sa_handler = fault_sigbus_handler,
+	};
+	size_t map_size = total_size * 4;
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
+
+	mem = mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+
+	sigaction(SIGBUS, &sa_new, &sa_old);
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		memset(mem, 0xaa, map_size);
+		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
+	}
+	sigaction(SIGBUS, &sa_old, NULL);
+
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = munmap(mem, map_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+}
+
+static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
 {
 	char *mem;
 
 	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 	TEST_ASSERT_EQ(mem, MAP_FAILED);
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT_EQ(mem, MAP_FAILED);
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
 	}
 }
 
-static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
+static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
+						  uint64_t guest_memfd_flags,
+						  size_t page_size)
 {
-	size_t page_size = getpagesize();
-	uint64_t flag;
 	size_t size;
 	int fd;
 
 	for (size = 1; size < page_size; size++) {
-		fd = __vm_create_guest_memfd(vm, size, 0);
-		TEST_ASSERT(fd == -1 && errno == EINVAL,
+		fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
+		TEST_ASSERT(fd < 0 && errno == EINVAL,
 			    "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
 			    size);
 	}
-
-	for (flag = BIT(0); flag; flag <<= 1) {
-		fd = __vm_create_guest_memfd(vm, page_size, flag);
-		TEST_ASSERT(fd == -1 && errno == EINVAL,
-			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
-			    flag);
-	}
 }
 
 static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
@@ -171,30 +237,116 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
-int main(int argc, char *argv[])
+static bool check_vm_type(unsigned long vm_type)
 {
-	size_t page_size;
+	/*
+	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
+	 * support guest_memfd have that support for the default VM type.
+	 */
+	if (vm_type == VM_TYPE_DEFAULT)
+		return true;
+
+	return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
+}
+
+static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags)
+{
+	struct kvm_vm *vm;
 	size_t total_size;
+	size_t page_size;
 	int fd;
-	struct kvm_vm *vm;
 
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+	if (!check_vm_type(vm_type))
+		return;
 
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(vm_type);
 
-	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
+	test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
 
-	fd = vm_create_guest_memfd(vm, total_size, 0);
+	fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+
+	if (guest_memfd_flags & GUEST_MEMFD_FLAG_MMAP) {
+		test_mmap_supported(fd, page_size, total_size);
+		test_fault_overflow(fd, page_size, total_size);
+
+	} else {
+		test_mmap_not_supported(fd, page_size, total_size);
+	}
+
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
 	close(fd);
+	kvm_vm_free(vm);
+}
+
+static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
+					    uint64_t expected_valid_flags)
+{
+	size_t page_size = getpagesize();
+	struct kvm_vm *vm;
+	uint64_t flag = 0;
+	int fd;
+
+	if (!check_vm_type(vm_type))
+		return;
+
+	vm = vm_create_barebones_type(vm_type);
+
+	for (flag = BIT(0); flag; flag <<= 1) {
+		fd = __vm_create_guest_memfd(vm, page_size, flag);
+
+		if (flag & expected_valid_flags) {
+			TEST_ASSERT(fd >= 0,
+				    "guest_memfd() with flag '0x%lx' should be valid",
+				    flag);
+			close(fd);
+		} else {
+			TEST_ASSERT(fd < 0 && errno == EINVAL,
+				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
+				    flag);
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void test_gmem_flag_validity(void)
+{
+	uint64_t non_coco_vm_valid_flags = 0;
+
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+		non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_MMAP;
+
+	test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
+
+#ifdef __x86_64__
+	test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
+#endif
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+
+	test_gmem_flag_validity();
+
+	test_with_type(VM_TYPE_DEFAULT, 0);
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+		test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
+
+#ifdef __x86_64__
+	test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
+#endif
 }
-- 
2.50.1.470.g6ba607880d-goog

