Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDF74AD7E6
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 16:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367307; cv=none; b=lZoQDjR6wFK7ySYB/MdgFcGYyvCewrOW+mIfAJ5+04JtV9mCZxP6w4mZOXpNguWbg+ZmNJSVfoRrcPz2wO63b1Vm0WdGp3dOKhC4Vgqz3V86/rS5XTDTCSqqNZUPXSR/Ei43TJuEDTE/Id4oY6CwUo7e4YX0uwQZrYx3QyM9Zdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367307; c=relaxed/simple;
	bh=agqcQGpkoOi6P1jQwddX1AvqLJis+COWMzi0MFnoTIE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lo/vFuFe8qZ6T78S801LDT9TSnuTHr8CLCr81lDCXhE2PXY+IQEdvyFaeJEciiBdu+V4hXGjwcdiJSc92hDzCuqKREHmChnzSRMKi45fgOQerfWZq3Di+PuLxYhhGooqePuYi5js4WJD7JjY5H4pG79ZF4QeCSVSJj0yGeMEmQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pamMRsTR; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pamMRsTR"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbee6bb8408so1733311a12.3
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 09:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788367300; x=1788972100; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WnzaMKfYFzpdBR00mBxUkRbzuomQsYg60ItfNS+IF/Y=;
        b=pamMRsTReK7OCfm2gTShLX5E8dx+dh6WQcRFJMxVpzIs/q5M54TfhgYez8vcDXMEpP
         m+TISbLcFUqej3FITy+z0ok1G85Q9Cnoh3xIQI3FB3WC03JJ4QLdD+yPseXpKWd2n0mu
         4lso4m5t4fu2yKGtK5TNKU7hFPE8BI46+F1GrNsGeGBh5CIs60gnAiB5CyuDdrtHwFOR
         n5eZcDK4IkiHCwCAVGmx0OgNt/B+NEzIk+ukG2pp5vX0KdBGyY9pT4ju9vpB+ZICs24n
         UpE1g+R1TuGDqbFGXSgWlb/sFqIBL4kexjGT4PN+rkqw3hww0gVwrATjO6JeRfSOFkoV
         n9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788367300; x=1788972100;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WnzaMKfYFzpdBR00mBxUkRbzuomQsYg60ItfNS+IF/Y=;
        b=FNgmhTBwcAK1xj0R1NHAwdEGv82tdBBzHNgVkl2e4gS9To7P/Q6/QcZgTl+QLs8OnG
         kEe1YhmJnrEZJnts0xQbjR4g87JC6RcJx2zulEklclq2PlXdOjLUUxTCbcHJijavtvvl
         gHOapxrcUsKu5u7XdzdW7RAMeP1CPzJ/w7YxsZkbHCKS76NTzA45u9LNeBIf7cYg3h0/
         z7WCFWgls99dHwzt6M+3wg5LjguC78V7JsZOpV6iyBTm/jR1S6UY8Eb1IwfRvPiZ5ys1
         HAF5npd+TXb/vMCq1fPgeosLWkDgW9M5DOW4Rl+dcWI8BzbLLa12lSV1Rsk72npG/C8w
         mQdw==
X-Forwarded-Encrypted: i=1; AKwUvBzIq/yeLO0FGBWr99P8HKfcNQxlViXoETSpfqC+UWTgQsDgmWaaD7WxBiBYiAXtHMlKGSeqwE0=@lists.linux.dev
X-Gm-Message-State: AFuF++k1Mfdnd5j9qs61dsxLdyyh47G8Jjo3Zqm15DCL3BUu2M+bxGRb
	VLc16qGF4G6V+4uqMgOpv1bxBAqRQJWkNNUDakxf74Cvv2IDQZ3dtLKgWPM40ogBxtSZBykc3q+
	sPwqnZg==
X-Received: from pgwa1.prod.google.com ([2002:a65:6541:0:b0:cc1:c7d5:9661])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:134b:b0:3c4:4272:b400
 with SMTP id adf61e73a8af0-3d9ae8e1ee9mr11072673637.18.1788367299354; Wed, 02
 Sep 2026 09:41:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  2 Sep 2026 09:41:15 -0700
In-Reply-To: <20260902164123.2546762-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260902164123.2546762-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260902164123.2546762-13-seanjc@google.com>
Subject: [PATCH v2 12/20] KVM: selftests: Add APIs to override memory region
 types with custom memslots
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Atish Patra <atish.patra@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add and use APIs to override memory region types instead of open coding the
logic in tests, partly to dedup test code, but mostly to add some amount of
protection against conflicting overrides.  This will allow converting more
tests to override memory regions without taking on too much risk of bugs in
the long term, e.g. due to silently overriding a region multiple times.

Deliberately "unroll" the loops in __vm_create() and the CMMA test's
create_main_memslot() to avoid filling all memslots in anticipation of
adding an "extra" memslot that is for test use and *only* test use, i.e.
shouldn't be configured by core library code.

Converting tests to overriding memory regions will allow taking the region
type instead of the raw memslot in the physical page allocator APIs.

Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/arm64/page_fault_test.c     | 18 +++++------
 .../testing/selftests/kvm/include/kvm_util.h  | 30 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  8 +++--
 tools/testing/selftests/kvm/s390/cmma_test.c  | 19 ++++--------
 4 files changed, 49 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/page_fault_test.c b/tools/testing/selftests/kvm/arm64/page_fault_test.c
index 6bb3d82906b2..b0e3fc8cd76a 100644
--- a/tools/testing/selftests/kvm/arm64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/arm64/page_fault_test.c
@@ -597,18 +597,16 @@ static void setup_memslots(struct kvm_vm *vm, struct test_params *p)
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0,
 				    CODE_AND_DATA_MEMSLOT, code_npages, 0);
-	vm->memslots[MEM_REGION_CODE] = CODE_AND_DATA_MEMSLOT;
-	vm->memslots[MEM_REGION_DATA] = CODE_AND_DATA_MEMSLOT;
+	____vm_override_mem_region(vm, MEM_REGION_CODE, CODE_AND_DATA_MEMSLOT);
+	____vm_override_mem_region(vm, MEM_REGION_DATA, CODE_AND_DATA_MEMSLOT);
 
-	vm_userspace_mem_region_add(vm, p->src_type, data_gpa - pt_size,
-				    PAGE_TABLE_MEMSLOT, pt_size / guest_page_size,
-				    p->test_desc->pt_memslot_flags);
-	vm->memslots[MEM_REGION_PT] = PAGE_TABLE_MEMSLOT;
+	__vm_override_mem_region(vm, MEM_REGION_PT, p->src_type, data_gpa - pt_size,
+				 PAGE_TABLE_MEMSLOT, pt_size / guest_page_size,
+				 p->test_desc->pt_memslot_flags);
 
-	vm_userspace_mem_region_add(vm, p->src_type, data_gpa, TEST_DATA_MEMSLOT,
-				    data_size / guest_page_size,
-				    p->test_desc->data_memslot_flags);
-	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
+	__vm_override_mem_region(vm, MEM_REGION_TEST_DATA, p->src_type, data_gpa,
+				 TEST_DATA_MEMSLOT, data_size / guest_page_size,
+				 p->test_desc->data_memslot_flags);
 }
 
 static void setup_ucall(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 304ef6af3268..c8faa8a02b93 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -704,6 +704,36 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
 		int guest_memfd_fd, u64 guest_memfd_offset);
 
+
+static inline void ____vm_override_mem_region(struct kvm_vm *vm,
+					      enum kvm_mem_region_type type,
+					      u32 slot)
+{
+	TEST_ASSERT(vm->memslots[type] == KVM_INVALID_MEMSLOT,
+		    "Memory region type '%u' was already overridden with slot=%u",
+		    type, vm->memslots[type]);
+
+	vm->memslots[type] = slot;
+}
+
+static inline void __vm_override_mem_region(struct kvm_vm *vm,
+					    enum kvm_mem_region_type type,
+					    enum vm_mem_backing_src_type src_type,
+					    gpa_t gpa, u32 slot, u64 npages,
+					    u32 flags)
+{
+	____vm_override_mem_region(vm, type, slot);
+	vm_userspace_mem_region_add(vm, src_type, gpa, slot, npages, flags);
+}
+
+static inline void vm_override_mem_region(struct kvm_vm *vm,
+					  enum kvm_mem_region_type type,
+					  enum vm_mem_backing_src_type src_type,
+					  gpa_t gpa, u32 slot, u64 npages)
+{
+	__vm_override_mem_region(vm, type, src_type, gpa, slot, npages, 0);
+}
+
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
 {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 56df5b1d9c79..781af2928d04 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -495,7 +495,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 						 nr_extra_pages);
 	struct userspace_mem_region *slot0;
 	struct kvm_vm *vm;
-	int i, flags;
+	int flags;
 
 	kvm_set_files_rlimit(nr_runnable_vcpus);
 
@@ -513,8 +513,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32 nr_runnable_vcpus,
 		flags |= KVM_MEM_GUEST_MEMFD;
 
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, flags);
-	for (i = 0; i < NR_MEM_REGIONS; i++)
-		vm->memslots[i] = 0;
+	____vm_override_mem_region(vm, MEM_REGION_CODE, 0);
+	____vm_override_mem_region(vm, MEM_REGION_PT, 0);
+	____vm_override_mem_region(vm, MEM_REGION_DATA, 0);
+	____vm_override_mem_region(vm, MEM_REGION_TEST_DATA, 0);
 
 	kvm_vm_elf_load(vm, program_invocation_name);
 
diff --git a/tools/testing/selftests/kvm/s390/cmma_test.c b/tools/testing/selftests/kvm/s390/cmma_test.c
index 15d81b2ed7ad..73387cc3bca7 100644
--- a/tools/testing/selftests/kvm/s390/cmma_test.c
+++ b/tools/testing/selftests/kvm/s390/cmma_test.c
@@ -102,24 +102,17 @@ static void guest_dirty_test_data(void)
 
 static void create_main_memslot(struct kvm_vm *vm)
 {
-	int i;
-
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, MAIN_PAGE_COUNT, 0);
-	/* set the array of memslots to zero like __vm_create does */
-	for (i = 0; i < NR_MEM_REGIONS; i++)
-		vm->memslots[i] = 0;
+	____vm_override_mem_region(vm, MEM_REGION_CODE, 0);
+	____vm_override_mem_region(vm, MEM_REGION_PT, 0);
+	____vm_override_mem_region(vm, MEM_REGION_DATA, 0);
 }
 
 static void create_test_memslot(struct kvm_vm *vm)
 {
-	vm_userspace_mem_region_add(vm,
-				    VM_MEM_SRC_ANONYMOUS,
-				    TEST_DATA_START_GFN << vm->page_shift,
-				    TEST_DATA_MEMSLOT,
-				    TEST_DATA_PAGE_COUNT,
-				    0
-				   );
-	vm->memslots[MEM_REGION_TEST_DATA] = TEST_DATA_MEMSLOT;
+	vm_override_mem_region(vm, MEM_REGION_TEST_DATA, VM_MEM_SRC_ANONYMOUS,
+			       TEST_DATA_START_GFN << vm->page_shift,
+			       TEST_DATA_MEMSLOT, TEST_DATA_PAGE_COUNT);
 }
 
 static void create_memslots(struct kvm_vm *vm)
-- 
2.55.0.966.g6673acef38-goog

