Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F5E5576B
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 22:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709073817; cv=none; b=Jy1vbOYrSc3hQOBgxH/7tD4ABeBRkdseTh1f2v89m74O3Uv8p6vzfaaZwEhJX8uBnFp2Gc/Ogp82BEhnEbhZkd6Pt9A3vZWzrP8JDhRD8uIV2dnALfWMbegMpNNrYCOk26LAHm7JoUIvw4PwoZPtO/+U4/QkriAuRGnuPPYjyXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709073817; c=relaxed/simple;
	bh=NhWRmonRuBVJIZxUaNLNrS2RE13UEHgSRO92UYrLLSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHG4XIRaAxun/TiemIPbBC1P4DHOr/yMMfA/R6/QWJZ68YCWXfby56yC7S8rYei0IQaxQkzmB353cnX7RMo0sgwkiE4mjub+G0aB0PqbzReWHcstH2OYV+1LGrvBYgPo5/MtvcP0tKNpfghpjdXk+fA0Wk1KIpxShn6+tjFwK6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ioyHq4/1; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ioyHq4/1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709073814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XkiMeBFOVjGqF8RscxA/xNY9dvkc24IpZ5he4t3rNwc=;
	b=ioyHq4/1EXnZF7eU1O/QOQLG++2Xm77/UWSq2xlsli+Vs5zaNgVnYJ9wqpy0Bp6dtTKpgc
	gvdOaNEfJHxm8z2QSzXfFxL1lOljvOAkbHU/hMr+8KxXH3InhYRTbzNZXPpYpwiYVD5/+G
	3Ub8jIOtJa5Al+45jcJBDzQNr9elzws=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 19/20] KVM: selftests: Hack in support for aligned page allocations
Date: Tue, 27 Feb 2024 22:42:48 +0000
Message-ID: <20240227224249.2209194-20-oliver.upton@linux.dev>
In-Reply-To: <20240227224249.2209194-1-oliver.upton@linux.dev>
References: <20240227224249.2209194-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Many of the memory allocations handed off to a GIC ITS require 64K
alignment. One would think that requesting 64K of pages would follow
natural alignment in selftests (much like alloc_pages() in the kernel),
however that is unfortunately not the case.

Add a new helper to allow a caller to decide if they want
naturally-aligned page allocations. Deliberately avoid making this the
default in case this subtly breaks assumptions or memory overheads in
other selftests.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/kvm_util_base.h     |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 27 ++++++++++++++++---
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 9e5afc472c14..750638cfa849 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -830,6 +830,8 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+vm_paddr_t vm_phy_pages_alloc_aligned(struct kvm_vm *vm, size_t num,
+				      vm_paddr_t paddr_min, uint32_t memslot);
 
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e066d584c656..60948a004012 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1984,8 +1984,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+static vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				       vm_paddr_t paddr_min, uint32_t memslot,
+				       bool aligned)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -1997,14 +1998,20 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		"  paddr_min: 0x%lx page_size: 0x%x",
 		paddr_min, vm->page_size);
 
+	TEST_ASSERT(!aligned || (paddr_min % vm->page_size * num) == 0,
+		    "Min physical address isn't naturally aligned.\n"
+		    "  paddr_min: 0x%lx page_size: 0x%x num: %lu",
+		    paddr_min, vm->page_size, num);
+
 	region = memslot2region(vm, memslot);
 	base = pg = paddr_min >> vm->page_shift;
 
 	do {
 		for (; pg < base + num; ++pg) {
 			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
-				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
-				break;
+				do {
+					base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
+				} while (aligned && ((pg % num) != 0));
 			}
 		}
 	} while (pg && pg != base + num);
@@ -2024,6 +2031,12 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return base * vm->page_size;
 }
 
+vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+			      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot, false);
+}
+
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot)
 {
@@ -2036,6 +2049,12 @@ vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 				 vm->memslots[MEM_REGION_PT]);
 }
 
+vm_paddr_t vm_phy_pages_alloc_aligned(struct kvm_vm *vm, size_t num,
+				      vm_paddr_t paddr_min, uint32_t memslot)
+{
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot, true);
+}
+
 /*
  * Address Guest Virtual to Host Virtual
  *
-- 
2.44.0.rc1.240.g4c46232300-goog

