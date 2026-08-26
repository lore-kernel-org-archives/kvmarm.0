Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8A63D75D7
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785544; cv=none; b=D9lxtATHoFOW2UEU6RVR9a/0XLZXnXC5b+A1f3rOZ+vWBxsMy4Y2p0OD7VbxLXBo68p8QrBmRVdstn/4QpSvmYu+FEjIK8JPibhqBzxRhumHgnz5lGtjQFZsC5AiqaVV2Sz2MSxpZBisfd/zl1RNg4L5WytxZwuHoD+jMuKsuC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785544; c=relaxed/simple;
	bh=4+xGS+gQ8QGQJN0G+dANZ7pjBY5FQBwjcWjyiAvNeBE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qV6tSNZyFyqTO4x21VsLeAl35+7Qy8Yb0rEl2N/3UCaLjkavV4Cz/lotGCB9vtXf6+VFbIhAYgJ5Sqmg97sPJHdFnVjzwKr4hoOsH4iWWMsrbXeAG5YFnT2cUesrghlJaqF59Y1E18jaU0sxOqxcGwIrwSIOD0Im79c8jMxFg2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vde6XuVg; arc=none smtp.client-ip=209.85.215.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vde6XuVg"
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cbe77d6864dso2078555a12.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785537; x=1788390337; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QW8eYqOPxy2zOGKaQa10ibF4yoX+KMS8dMg107sn6cY=;
        b=Vde6XuVg6jy/PSTqx1C+GRQvk28kcAhrYuZoq2zlwM9vE8cIBks66BCLWbXOq1bhDT
         ZWT0dMoRMjuL1rEw1HQxIOoAA6Auyrjs8+700tSTQLM5t0WO4HCECuSJ00z+kUlG94kp
         FBXt75DNPLSDfG0aMG/PALfNQP4QpqCGFduyPN5VniuQkV11JSeCHxJwQzEOX970Pt6y
         UiLjTLoJ7L1esSILtuKfRtdpkx5meKLd6m560Np2h5otD5aSX1tlLV+i2sEpPrXIZCWk
         6gAvILY7IximU2GZQSy3H1CxCBz+Cz9lQnm1MHhUIceaMxroUFpkYfNzBFZKfy+rd2hj
         0qOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785537; x=1788390337;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QW8eYqOPxy2zOGKaQa10ibF4yoX+KMS8dMg107sn6cY=;
        b=WF2rmEJkM5Vr4RDfN0rU6k8y5vJFuWoFNpIWPgTYvo/PFUFwPIuEwPCCloMmgHuFsp
         zOE2vOzcS7LLpORPTropH+WbWtWIol0wM/6odFQlvcW1Zp7JtWISIPkSEj3VYeF7s+PC
         3/9RzajR2KClB2/R5Jj5WwQcULPC89VTr6tTxcOfaeVOLHGAyljk3hZdCvaOSnRbHvtF
         ZpJG69mGJIRmG6/t8HAMGhxFvi8HjC0tm8IotSh7bBz76qlRJv9ITqSOK8BkS9TUfCfJ
         R2+ZKtH9+UUVVwsFDPAVnHUN81p6jE4dcv7ViqNm6IZLCXIPo1cuQHsD2xadeOwSCNxM
         x8dw==
X-Forwarded-Encrypted: i=1; AHgh+Rr5kgvGZWHwKbXViKemfalB2u4/Ph6MYekxuh1Xi9O6a1OCHmSuj8ipzCpZ04rGxtoY144h9p0=@lists.linux.dev
X-Gm-Message-State: AFuF++kkZ/pwCkiXYUORFVJlmdBYxn7UahIsUirEgn3E0aZ0QKceyn2j
	pq4Ek01QVXxY4ovVz9p1N5z+sx/TqDLO5UWqoqV+japAOBfnoV4aC6SejcyXZJ4XcRZjIgFtfkL
	bTyA6jA==
X-Received: from pgbs63.prod.google.com ([2002:a63:5e42:0:b0:cbe:947d:d145])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:680d:b0:3c4:396d:4a6c
 with SMTP id adf61e73a8af0-3cf75e8b237mr24763274637.5.1787785537082; Wed, 26
 Aug 2026 16:05:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:08 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-18-seanjc@google.com>
Subject: [PATCH 17/20] KVM: selftests: Take the memory region type, not
 memslot, in page allocators
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

Take the memory region type instead of the memslot in all page allocator
APIs, except for the innermost quad-underscores function.  This will allow
automatically selecting the minimum GPA based on the allocation type, which
can't be done using the memslot due to all regions sharing a single memslot
by default.  PowerPC support will also leverage the type to ensure that
page table allocations are naturally aligned.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c | 12 ++++++------
 tools/testing/selftests/kvm/include/kvm_util.h      | 13 +++++++------
 tools/testing/selftests/kvm/lib/kvm_util.c          | 10 +++++++---
 tools/testing/selftests/kvm/lib/x86/processor.c     |  2 +-
 .../testing/selftests/kvm/set_memory_region_test.c  |  2 +-
 .../kvm/x86/smaller_maxphyaddr_emulation_test.c     |  2 +-
 6 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 9865b204fdeb..a45c0849a47a 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -192,27 +192,27 @@ static void setup_test_data(void)
 
 	test_data.device_table = vm_phy_pages_alloc(vm, pages_per_64k,
 						    gpa_base,
-						    TEST_MEMSLOT_INDEX);
+						    MEM_REGION_TEST_EXTRA);
 
 	test_data.collection_table = vm_phy_pages_alloc(vm, pages_per_64k,
 							gpa_base,
-							TEST_MEMSLOT_INDEX);
+							MEM_REGION_TEST_EXTRA);
 
 	cmdq_base = vm_phy_pages_alloc(vm, pages_per_64k, gpa_base,
-				       TEST_MEMSLOT_INDEX);
+				       MEM_REGION_TEST_EXTRA);
 	virt_map(vm, cmdq_base, cmdq_base, pages_per_64k);
 	test_data.cmdq_base = cmdq_base;
 	test_data.cmdq_base_va = (void *)cmdq_base;
 
 	test_data.itt_tables = vm_phy_pages_alloc(vm, pages_per_64k * nr_devices,
-						  gpa_base, TEST_MEMSLOT_INDEX);
+						  gpa_base, MEM_REGION_TEST_EXTRA);
 
 	test_data.lpi_prop_table = vm_phy_pages_alloc(vm, pages_per_64k,
-						      gpa_base, TEST_MEMSLOT_INDEX);
+						      gpa_base, MEM_REGION_TEST_EXTRA);
 	configure_lpis();
 
 	test_data.lpi_pend_tables = vm_phy_pages_alloc(vm, pages_per_64k * nr_cpus,
-						       gpa_base, TEST_MEMSLOT_INDEX);
+						       gpa_base, MEM_REGION_TEST_EXTRA);
 
 	sync_global_to_guest(vm, test_data);
 }
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index f4f4f360a10b..783f060faf9e 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1052,30 +1052,31 @@ const char *exit_reason_str(unsigned int exit_reason);
 gpa_t ____vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 			     u32 memslot, bool protected, bool naturally_aligned);
 gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
-			   u32 memslot, bool protected);
+			   enum kvm_mem_region_type type, bool protected);
 
 static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages,
-				       gpa_t min_gpa, u32 memslot)
+				       gpa_t min_gpa,
+				       enum kvm_mem_region_type type)
 {
 	/*
 	 * By default, allocate memory as protected for VMs that support
 	 * protected memory, as the majority of memory for such VMs is
 	 * protected, i.e. using shared memory is effectively opt-in.
 	 */
-	return __vm_phy_pages_alloc(vm, nr_pages, min_gpa, memslot,
+	return __vm_phy_pages_alloc(vm, nr_pages, min_gpa, type,
 				    vm_arch_has_protected_memory(vm));
 }
 
 static inline gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa,
-				      u32 memslot)
+				      enum kvm_mem_region_type type)
 {
-	return vm_phy_pages_alloc(vm, 1, min_gpa, memslot);
+	return vm_phy_pages_alloc(vm, 1, min_gpa, type);
 }
 
 static inline gpa_t vm_alloc_page_table_pages(struct kvm_vm *vm, size_t nr_pages)
 {
 	return vm_phy_pages_alloc(vm, nr_pages, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				  vm->memslots[MEM_REGION_PT]);
+				  MEM_REGION_PT);
 }
 
 static inline gpa_t vm_alloc_page_table(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 781af2928d04..e500d1799151 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1475,7 +1475,7 @@ static gva_t ____vm_alloc(struct kvm_vm *vm, size_t sz, gva_t min_gva,
 	virt_pgd_alloc(vm);
 	gpa_t gpa = __vm_phy_pages_alloc(vm, pages,
 					   KVM_UTIL_MIN_PFN * vm->page_size,
-					   vm->memslots[type], protected);
+					   type, protected);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -2088,9 +2088,13 @@ gpa_t ____vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 }
 
 gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
-			   u32 memslot, bool protected)
+			   enum kvm_mem_region_type type, bool protected)
 {
-	return ____vm_phy_pages_alloc(vm, nr_pages, min_gpa, memslot, protected, false);
+	TEST_ASSERT(type < NR_MEM_REGIONS,
+		    "Invalid memory region type '%u'", type);
+
+	return ____vm_phy_pages_alloc(vm, nr_pages, min_gpa, vm->memslots[type],
+				      protected, false);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index b988eea373ad..39d9ca6ceb1d 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1475,7 +1475,7 @@ void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, gpa_t smram_gpa,
 			       smram_gpa, SMRAM_MEMSLOT, SMRAM_PAGES);
 
 	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, smram_gpa,
-				       SMRAM_MEMSLOT) == smram_gpa,
+				       MEM_REGION_TEST_EXTRA) == smram_gpa,
 		    "Could not allocate guest physical addresses for SMRAM");
 
 	memset(addr_gpa2hva(vm, smram_gpa), 0x0, SMRAM_SIZE);
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 9d21594e2f81..160bbe3d7203 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -124,7 +124,7 @@ static struct kvm_vm *spawn_vm(struct kvm_vcpu **vcpu, pthread_t *vcpu_thread,
 	 * Allocate and map two pages so that the GPA accessed by guest_code()
 	 * stays valid across the memslot move.
 	 */
-	gpa = vm_phy_pages_alloc(vm, 2, MEM_REGION_GPA, MEM_REGION_SLOT);
+	gpa = vm_phy_pages_alloc(vm, 2, MEM_REGION_GPA, MEM_REGION_TEST_EXTRA);
 	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
 
 	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 2);
diff --git a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
index b21798a385ca..4e125eb5e0cf 100644
--- a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
@@ -67,7 +67,7 @@ int main(int argc, char *argv[])
 			       MEM_REGION_SIZE / PAGE_SIZE);
 
 	gpa = vm_phy_pages_alloc(vm, MEM_REGION_SIZE / PAGE_SIZE,
-				 MEM_REGION_GPA, MEM_REGION_SLOT);
+				 MEM_REGION_GPA, MEM_REGION_TEST_EXTRA);
 	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc");
 	virt_map(vm, MEM_REGION_GVA, MEM_REGION_GPA, 1);
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
-- 
2.55.0.887.g758fc8c411-goog

