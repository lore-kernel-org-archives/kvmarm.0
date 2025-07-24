Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0423BCFF
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 22:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753395363; cv=none; b=Xt5WwgFaBKLRwlbwZU7b6fznJSPhloy/qkhqCSqNmUL1QFaE0QMGEyhzL3FZku8cvTixXfL9Doo+8fP4oiu0jvdbENO9nj95rU0o7J/tEk9c2dQL0Jq6dI+LrCIwppiQvrlp+r34Zs7k8WaVUZ+avYNqj8HXiiKwsA8QCfAxYlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753395363; c=relaxed/simple;
	bh=rhlzzh5Pxg/8rpa17ACmhR9kCZrHB5sxxSMWO+tsigc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nbsFOyQJkI04K2UGauJE+DlK68OkQxgOH+wYIGEzTSfxNhZLGDyjSu6URDLhu0omorssMl6+lMZhqs6ucq7Sff9mn/hH0pJY6sdt2wKaw07DwqyengjCHLoifG74FsGHZOcUn8/pvRe6cFmj80x0EkXq9Fo2or0dEQeyd639maM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jqe/sI2U; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jqe/sI2U"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235f6b829cfso12081905ad.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 15:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753395361; x=1754000161; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CSsPv5ePcijvg/eJ9YOOoohsMAUUeLc/JQK+ad+OE5I=;
        b=Jqe/sI2UfgmdH2T6b7dUQ7iFPjxYW5A5IDekK90dNaq92G3pN7K0jmu3Cs+LK10f6n
         O7wBUwxUpi+gPUAgm3duln3+RNCjUozL7eEkcuB/nvsh6fZm2Gvn/aUwQXOlaKW1CP+u
         uSM1Pd8XjeLJ9Ph1Pu7eRorXIJDd0x6SAv23sAkjU2qvCC/meMWE9+4Lu5Hjq34R+KkF
         VvH5i46TqKmujqTFNoghpEN5yRxvqxqJnv8myVn5uYektyTEHVLdb+dwVY+Ic530X6t1
         BCHeVJ0tiUBspbHtBD3+lFY7JkKh2QWMIQyY3aENb3gxlrwLq3R/MDXOjh+0Ee7WhxgF
         qLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753395361; x=1754000161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSsPv5ePcijvg/eJ9YOOoohsMAUUeLc/JQK+ad+OE5I=;
        b=uxEGYSVIZp/JGnHJvopZ8glqGFHyuJXaHKQT5FvuJy9neLXTO0fKVr7BRiYWlDvuYD
         Sxr9otktKCqJs6J8p33450YUEgVh380Z/H7TeihdEZVOfEA0LukBIewq08MRLxKzt+0y
         7xVytg2lLNLmyicar5bKiKLSqVT873MRXMlEE9QasZ3DkdkQzQ0RPLbEzuV9hCs0WRcF
         KbFBfRWbTFGjHulCc1CwyxJs3F3Uda5xF6IjhIWn36mnrxfPAWargp41/Yk3eIYIDdK/
         45FHYx/1DKrdx9m9L1s+eskCQ7tPA+IVdte/QZ/BCodY+5QL6FIeB157zXpyu8dIg/LG
         YXfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVr5ks0/yHoHZQoxUArAn6ZBcD9gk/Fr2/eUe1EYgJwEFm9W6kl58hDsRDxQ0BrWk2CDxgb06k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKFM94JwoUCpG7KkMmvd1fy6xa84QpElyDmRfMJ1hQiM+ssAxj
	MhKcSspVEVYDZX7Z9qds9cESQboeDLmjcRwOoMO0fiSdhp9s1NlqulEMhwC3QVRE2LmWNESsPMB
	OOftCrg==
X-Google-Smtp-Source: AGHT+IH888MaNXPIrGBfFP1YYkrT5keudUQ/WtNaJQtp7BAWAULutMntUODLGK7xo8IWfYkqv91HA01aGjk=
X-Received: from pjyp3.prod.google.com ([2002:a17:90a:e703:b0:312:4b0b:a94])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f682:b0:237:d25b:8f07
 with SMTP id d9443c01a7336-23f9823ce8dmr106882785ad.44.1753395360506; Thu, 24
 Jul 2025 15:16:00 -0700 (PDT)
Date: Thu, 24 Jul 2025 15:15:59 -0700
In-Reply-To: <20250723104714.1674617-23-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-23-tabba@google.com>
Message-ID: <aIKwn0RJdEXlu5g3@google.com>
Subject: Re: [PATCH v16 22/22] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
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
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 23, 2025, Fuad Tabba wrote:
> Reviewed-by: James Houghton <jthoughton@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>

These reviews probably should be dropped given that the test fails...

> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
> +static bool check_vm_type(unsigned long vm_type)
>  {
> -	size_t page_size;
> +	/*
> +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
> +	 * support guest_memfd have that support for the default VM type.
> +	 */
> +	if (vm_type == VM_TYPE_DEFAULT)
> +		return true;
> +
> +	return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
> +}

...

> ++static void test_gmem_flag_validity(void)
> +{
> +	uint64_t non_coco_vm_valid_flags = 0;
> +
> +	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +		non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_MMAP;
> +
> +	test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
> +
> +#ifdef __x86_64__
> +	test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
> +	test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
> +#endif

mmap() support has nothing to do with CoCo, it's all about KVM's lack of support
for VM types that use guest_memfd  for private memory.  This causes failures on 
x86 due to MMAP being supported on everything except SNP_VM and TDX_VM.

All of this code is quite ridiculous.  KVM allows KVM_CHECK_EXTENSION on a VM FD
specifically so that userspace can query whether or not a feature is supported for
a given VM.  Just use that, don't hardcode whether or not the flag is valid.

If we want to validate that a specific VM type does/doesn't support
KVM_CAP_GUEST_MEMFD_MMAP, then we should add a test for _that_ (though IMO it'd
be a waste of time).

> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
> +
> +	test_gmem_flag_validity();
> +
> +	test_with_type(VM_TYPE_DEFAULT, 0);
> +	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +		test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
> +
> +#ifdef __x86_64__
> +	test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
> +#endif

Similarly, don't hardocde the VM types to test, and then bail if the type isn't
supported.  Instead, pull the types from KVM and iterate over them.

Do that, and the test can provide better coverage is fewer lines of code.  Oh,
and it passes too ;-)

---
From: Fuad Tabba <tabba@google.com>
Date: Wed, 23 Jul 2025 11:47:14 +0100
Subject: [PATCH] KVM: selftests: guest_memfd mmap() test when mmap is
 supported

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

Cc: James Houghton <jthoughton@google.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 162 +++++++++++++++---
 1 file changed, 140 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 341ba616cf55..e23fbd59890e 100644
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
@@ -171,30 +237,82 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
-int main(int argc, char *argv[])
+static void test_guest_memfd_flags(struct kvm_vm *vm, uint64_t valid_flags)
 {
-	size_t page_size;
-	size_t total_size;
+	size_t page_size = getpagesize();
+	uint64_t flag;
 	int fd;
+
+	for (flag = BIT(0); flag; flag <<= 1) {
+		fd = __vm_create_guest_memfd(vm, page_size, flag);
+		if (flag & valid_flags) {
+			TEST_ASSERT(fd >= 0,
+				    "guest_memfd() with flag '0x%lx' should succeed",
+				    flag);
+			close(fd);
+		} else {
+			TEST_ASSERT(fd < 0 && errno == EINVAL,
+				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
+				    flag);
+		}
+	}
+}
+
+static void test_guest_memfd(unsigned long vm_type)
+{
+	uint64_t flags = 0;
 	struct kvm_vm *vm;
-
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+	size_t total_size;
+	size_t page_size;
+	int fd;
 
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(vm_type);
+
+	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))
+		flags |= GUEST_MEMFD_FLAG_MMAP;
 
-	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
+	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);
 
-	fd = vm_create_guest_memfd(vm, total_size, 0);
+	fd = vm_create_guest_memfd(vm, total_size, flags);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+
+	if (flags & GUEST_MEMFD_FLAG_MMAP) {
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
 
+	test_guest_memfd_flags(vm, flags);
+
 	close(fd);
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long vm_types, vm_type;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+
+	/*
+	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
+	 * support guest_memfd have that support for the default VM type.
+	 */
+	vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
+	if (!vm_types)
+		vm_types = VM_TYPE_DEFAULT;
+
+	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
+		test_guest_memfd(vm_type);
 }

base-commit: 7f4eb3d4fb58f58b3bbe5ab606c4fec8db3b5a3f
--
