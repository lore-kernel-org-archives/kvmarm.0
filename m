Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC363B994A
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785547; cv=none; b=cIvX2hjfmNKohfnB6awgzklLoYNuPrFBbKIP7e1fm7AArnMuOIBBqEW9o41YmzwewlZpZu/9iNzOD83sKAnaIZUHkdnMlcc3bST9uv1b3frNknKAiPpZ4r1eZlIlUpF0CUImxueywtZotDeEBjyQ9RrQcQj0L2syLDhapdGZU1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785547; c=relaxed/simple;
	bh=WOxm4BnKroJLVHQEy0jUAuIZbI6CudiTCoeDUy54eEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EqUnbnXA1WHq2CnFB1wvkfm1FPb4pPsrFT77nJdWA8qngm26Iw9CBkeK11c73oH2LKSwyjzwRaxeIgZXkX8aQAbZqYZm4uBGGWR3PwevhFLcRpR6QvSQBj6IQIhAoxpRL4FojsF5P5nwTtssif3DTcTP9H38JEpxU2LcPjBF7uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QorBYXyd; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QorBYXyd"
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so2704760a91.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785539; x=1788390339; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yj/O7Wk77mjZvk8cJgP4GcT6ON8eMhR5OMU86FoPEAo=;
        b=QorBYXyddqRhpIry3BCBEz95E8Y35a45idtLyG0L5Z565T6yB1Mqa+FUGD305U/Ru0
         vkmL4wBrCKdnZJzBHMIG636nOQGTgba+AmJDprumfSLu9AAhRHlTU3vJw4E7d7h2/W0K
         VnQSjfOPQgU6QUgsCw7DZlI1ButI8M9UAOknOjaKxChXOvccoaoMBhVfS9XrNZhgUWMz
         HzTx8TqoVkSynGvkS/0x4hq+09PBEjBwuCUiFHH4N9ZEb4sSMMX/eRNqP4xGcZIVo7DG
         vAPVXXcKtz/tcHPfo7eGjPHTO5by0uua78sdtHhD7gFmMqz8INjfzIItWuY7SaEf8kTe
         US6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785539; x=1788390339;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yj/O7Wk77mjZvk8cJgP4GcT6ON8eMhR5OMU86FoPEAo=;
        b=ZPFO/VOKSUeiTUr1dIA3XdFb6R7pESXXtp6yTYqhBko4EI7D01Y82VuexaTV6AIPgX
         ApzacHbnm+agS6Ko+glQdWB9cuBQViEF4DAOFu9WohxOL1JNV24eqkd6guJuy2pw3lQY
         liu82/g30hF2CFkQ0aUx1IQp0wCMiGvfghE7BpWnjcRlJgr/UN1QgOefGI+54L7m4hgM
         MLt+BIAf0xf5+Da1nI/Fw+jYCBCv1hx/3JcdyWxKQILOcIczO0lT0h9PgylXqGHKvTSx
         emnuV5FvxLxfWs/6E5aOJm7L/JXbBq48Zm1uexeAYFVkBTj0wdxh0TAX+9UO4E3wEkcX
         v8LA==
X-Forwarded-Encrypted: i=1; AHgh+RpXomqk6fYDCQLgfBrUMQSImgKvgPSRa1qAyFWeHhat2qXcGQLA2qS2t0oln1EMFfkTAE5Tk/c=@lists.linux.dev
X-Gm-Message-State: AFuF++n2JBMtjMO6e3gCrugOf/DX8btD0OVYzQtqzv62GuLu0NlkZY7k
	nofjeRnIy4ipbtGcqPMczsJAkPxBwuV1KCkrQUb5bzD9n1pHCIkHRxZ0HNdjeNtyC96WoOdDjLL
	6iTyw0w==
X-Received: from pgak6.prod.google.com ([2002:a05:6a02:6746:b0:cbe:9e80:c394])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:6cce:20b0:3d1:39e9:b267
 with SMTP id adf61e73a8af0-3d139e9b38amr1071680637.3.1787785539181; Wed, 26
 Aug 2026 16:05:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:10 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-20-seanjc@google.com>
Subject: [PATCH 19/20] KVM: selftests: Automatically pick min_gpa for
 allocations based on region type
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
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Automatically choose the minimum GPA for physical page allocations based on
the region type instead of sprinkling the logic over various wrappers and
tests.  All usage falls into three categories: (a) don't care, just use the
bare minimum GPA, (b) page tables, use a slightly higher min to keep low
memory available, (c) custom memslot, use the base of the memslot.  I.e.
there isn't a strong need to allow completely custom minimums.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/arm64/vgic_lpi_stress.c     | 11 ++----
 .../testing/selftests/kvm/include/kvm_util.h  | 12 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 38 ++++++++++++++++---
 .../testing/selftests/kvm/lib/x86/processor.c |  3 +-
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../x86/smaller_maxphyaddr_emulation_test.c   |  2 +-
 6 files changed, 44 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index a45c0849a47a..b4c651ea385d 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -191,28 +191,25 @@ static void setup_test_data(void)
 	gpa_t cmdq_base;
 
 	test_data.device_table = vm_phy_pages_alloc(vm, pages_per_64k,
-						    gpa_base,
 						    MEM_REGION_TEST_EXTRA);
 
 	test_data.collection_table = vm_phy_pages_alloc(vm, pages_per_64k,
-							gpa_base,
 							MEM_REGION_TEST_EXTRA);
 
-	cmdq_base = vm_phy_pages_alloc(vm, pages_per_64k, gpa_base,
-				       MEM_REGION_TEST_EXTRA);
+	cmdq_base = vm_phy_pages_alloc(vm, pages_per_64k, MEM_REGION_TEST_EXTRA);
 	virt_map(vm, cmdq_base, cmdq_base, pages_per_64k);
 	test_data.cmdq_base = cmdq_base;
 	test_data.cmdq_base_va = (void *)cmdq_base;
 
 	test_data.itt_tables = vm_phy_pages_alloc(vm, pages_per_64k * nr_devices,
-						  gpa_base, MEM_REGION_TEST_EXTRA);
+						  MEM_REGION_TEST_EXTRA);
 
 	test_data.lpi_prop_table = vm_phy_pages_alloc(vm, pages_per_64k,
-						      gpa_base, MEM_REGION_TEST_EXTRA);
+						      MEM_REGION_TEST_EXTRA);
 	configure_lpis();
 
 	test_data.lpi_pend_tables = vm_phy_pages_alloc(vm, pages_per_64k * nr_cpus,
-						       gpa_base, MEM_REGION_TEST_EXTRA);
+						       MEM_REGION_TEST_EXTRA);
 
 	sync_global_to_guest(vm, test_data);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a0cd1b6598d4..1264cd1a343a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1052,11 +1052,10 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 gpa_t ____vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 			     u32 memslot, bool protected, bool naturally_aligned);
-gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages,
 			   enum kvm_mem_region_type type, bool protected);
 
 static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages,
-				       gpa_t min_gpa,
 				       enum kvm_mem_region_type type)
 {
 	/*
@@ -1064,20 +1063,19 @@ static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages,
 	 * protected memory, as the majority of memory for such VMs is
 	 * protected, i.e. using shared memory is effectively opt-in.
 	 */
-	return __vm_phy_pages_alloc(vm, nr_pages, min_gpa, type,
+	return __vm_phy_pages_alloc(vm, nr_pages, type,
 				    vm_arch_has_protected_memory(vm));
 }
 
-static inline gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa,
+static inline gpa_t vm_phy_page_alloc(struct kvm_vm *vm,
 				      enum kvm_mem_region_type type)
 {
-	return vm_phy_pages_alloc(vm, 1, min_gpa, type);
+	return vm_phy_pages_alloc(vm, 1, type);
 }
 
 static inline gpa_t vm_alloc_page_table_pages(struct kvm_vm *vm, size_t nr_pages)
 {
-	return vm_phy_pages_alloc(vm, nr_pages, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				  MEM_REGION_PT);
+	return vm_phy_pages_alloc(vm, nr_pages, MEM_REGION_PT);
 }
 
 static inline gpa_t vm_alloc_page_table(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e500d1799151..8b5b330a5889 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1473,9 +1473,7 @@ static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 	u64 pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
-	gpa_t gpa = __vm_phy_pages_alloc(vm, pages,
-					   KVM_UTIL_MIN_PFN * vm->page_size,
-					   type, protected);
+	gpa_t gpa = __vm_phy_pages_alloc(vm, pages, type, protected);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -2087,11 +2085,39 @@ gpa_t ____vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 	__builtin_unreachable();
 }
 
-gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages,
 			   enum kvm_mem_region_type type, bool protected)
 {
-	TEST_ASSERT(type < NR_MEM_REGIONS,
-		    "Invalid memory region type '%u'", type);
+	struct userspace_mem_region *region = vm_get_mem_region(vm, type);
+	gpa_t min_gpa;
+
+	TEST_ASSERT(region, "No region for type '%u', memslot '%u'",
+		    type, vm->memslots[type]);
+
+	switch (type) {
+	case MEM_REGION_CODE:
+	case MEM_REGION_DATA:
+	case MEM_REGION_TEST_DATA:
+		/*
+		 * If the region is backed by the default memslot (id=0), use
+		 * selftests' hardcoded minimum PFN, otherwise use the base of
+		 * the custom memory slot that backs the region.
+		 */
+		if (!vm->memslots[type])
+			min_gpa = KVM_UTIL_MIN_PFN * vm->page_size;
+		else
+			min_gpa = region->region.guest_phys_addr;
+		break;
+	case MEM_REGION_PT:
+		min_gpa = KVM_GUEST_PAGE_TABLE_MIN_PADDR;
+		break;
+	case MEM_REGION_TEST_EXTRA:
+		min_gpa = region->region.guest_phys_addr;
+		break;
+	default:
+		TEST_FAIL("Invalid memory region type '%u'", type);
+		break;
+	}
 
 	return ____vm_phy_pages_alloc(vm, nr_pages, min_gpa, vm->memslots[type],
 				      protected, false);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 39d9ca6ceb1d..479e9a481687 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1474,8 +1474,7 @@ void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, gpa_t smram_gpa,
 	vm_override_mem_region(vm, MEM_REGION_TEST_EXTRA, VM_MEM_SRC_ANONYMOUS,
 			       smram_gpa, SMRAM_MEMSLOT, SMRAM_PAGES);
 
-	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, smram_gpa,
-				       MEM_REGION_TEST_EXTRA) == smram_gpa,
+	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, MEM_REGION_TEST_EXTRA) == smram_gpa,
 		    "Could not allocate guest physical addresses for SMRAM");
 
 	memset(addr_gpa2hva(vm, smram_gpa), 0x0, SMRAM_SIZE);
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 160bbe3d7203..bfa5ac8ce029 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -124,7 +124,7 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 	 * Allocate and map two pages so that the GPA accessed by guest_code()
 	 * stays valid across the memslot move.
 	 */
-	gpa = vm_phy_pages_alloc(vm, 2, MEM_REGION_GPA, MEM_REGION_TEST_EXTRA);
+	gpa = vm_phy_pages_alloc(vm, 2, MEM_REGION_TEST_EXTRA);
 	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
 
 	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 2);
diff --git a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
index 4e125eb5e0cf..8d1822717abd 100644
--- a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
@@ -67,7 +67,7 @@ int main(int argc, char *argv[])
 			       MEM_REGION_SIZE / PAGE_SIZE);
 
 	gpa = vm_phy_pages_alloc(vm, MEM_REGION_SIZE / PAGE_SIZE,
-				 MEM_REGION_GPA, MEM_REGION_TEST_EXTRA);
+				 MEM_REGION_TEST_EXTRA);
 	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc");
 	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1);
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
-- 
2.55.0.887.g758fc8c411-goog

