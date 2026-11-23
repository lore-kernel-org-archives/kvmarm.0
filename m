Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430114;
	b=PZq4jVPGkd5jx6LhdgyXMcdbI/JpBbhH2meWaWrzTeHaofhgWyzVB2pi5lhYKmsNS22B
	 gYtCcECok+ZWitCP12ib6ghd8dRPxRsQluhM5LF85sHCIrx6qbVdJGyk+A6CQ4N3kemFd
	 74QUsbtAiT2B3AdreoUHaHaFYMiCrWzHb9g8vm5F5frphy8/MYJCbkn0962tXUIGNYDrO
	 Z/S/yAsU+vcjAe2tMrgo7/EQjo4VT3dIamZFgq8B7aVC3SwhihlFN+3erdRezlBmBjNdD
	 anozvDzZ82TF8M2uKly2Vtwz79u1MgsQl0LIjLKZnM5zeLnnQbL4dNSLfGBW1/rj2Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430114;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lWio/ZaYW+Ez8es1JnqyfDCIZ2Tx6iwXiB9k3U+N5Zs=;
	b=gooZTZAKGG9CgrNUco1BJuaP6fczSKjpvyXA3PAE2/cDMOOYqnpqkulBbf62ZJc5nlu7
	 3VMQTuotzK/wQcsFg+ys5Iryqc5i1DDGKJiH0i6CWwDhFNx0JimcbTLN1iErgTwx4bFYH
	 70yg/vXgfjkRxgmL7g2pYFobZ2ZYZVr658i1ZAkMTRRde3qUJQT+K+MX3NjFtEjz+/LtQ
	 Bt6QjLP/bJ162CFMSRxTludjWrBtiL/LRjZK5m37fwVMkdu7oMZ1SJchJFqHO7N2qvLR1
	 Eg6+4d1KF8UaZWnVwmntBmrLl1KBjzC92aIshlIN38M5lAolftyvvzLclWoZNuqfXCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FZmSMvmV;
	arc=none smtp.remote-ip=95.215.58.84
Received: from mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC34C606A33F
	for <kvmarm@lists.linux.dev>; Mon, 23 Nov 2026 10:35:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC34C606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FZmSMvmV
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=IDG8FN6cGRh+zZL5h3B/Xnl0MXwN5GMGINSU+pdwgF8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795430111; v=1; x=1796034911;
 b=FZmSMvmVeeH6UEw2Wp+Ddu8t5rKXzxQ0iHUHyd0CGSdPqH7QtxGHoh2fDMpyL0SCI0dGU1Id
 7MU50K3LTxtoMYhcqRrE86K0QQh2TeiAeo22DvldbJAFA3fhmmARZUJnJfirLu20Xq5wRJLjxbf
 ZAkfKzsfQFytxLLkVEfv1wPo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 82def4b9cf94a7df;
	Mon, 23 Nov 2026 10:35:10 +0000
X-Mizu-Trace-ID: 82def4b9cf94a7df
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 2/2] KVM: arm64: selftests: Test a THP whose first fault is on a tail page
Date: Mon, 23 Nov 2026 10:35:05 +0000
Message-ID: <20261123103505.1006067-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123103505.1006067-1-fuad.tabba@linux.dev>
References: <20261123103505.1006067-1-fuad.tabba@linux.dev>
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

On a host whose PMD level is folded, KVM mapped host memory past a THP
when the guest first touched the THP at a page other than its first.

Add a scenario for that case. The guest writes to the second host page
of a memslot backed by one THP, then reads the first address past the
memslot. The test checks that the write landed in that page, and that
the read exits to userspace as MMIO. On a host whose PMD level isn't
folded, the scenario passes with or without the fix. It doesn't use
hugetlb pages, so it runs before the probe that skips the rest of the
test when they aren't reserved.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../kvm/arm64/stage2_block_transitions.c      | 56 ++++++++++++++++++-
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
index 5fd47f4ada1f3..000e8ec7ce8cc 100644
--- a/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
+++ b/tools/testing/selftests/kvm/arm64/stage2_block_transitions.c
@@ -3,10 +3,10 @@
  * Copyright (c) 2026 Google LLC
  * Author: Fuad Tabba <fuad.tabba@linux.dev>
  *
- * stage2_block_transitions - Exercise stage-2 block/page granularity changes
- * that dirty logging forces at fault time, and assert the guest completes.
+ * stage2_block_transitions - Exercise stage-2 block/page granularity at fault
+ * time: the changes dirty logging forces, and how far a THP block reaches.
  *
- * Both scenarios need the fault handler to allocate at fault time (a fresh
+ * Scenarios 1 and 2 need the fault handler to allocate at fault time (a fresh
  * mapping and/or page-table pages while holding mmu_lock), so a fault path
  * that fails to stage that memory manifests as a KVM_RUN error or, worse, a
  * host crash. The asserted property is host-agnostic: the guest runs the
@@ -27,6 +27,11 @@
  *   fault that must split the block into pages during logging, draining
  *   page-table pages. Skipped on CTR_EL0.DIC hardware, where mappings are
  *   made executable eagerly and the execute fault never occurs.
+ *
+ * Scenario 3 - THP whose first fault is on a tail page:
+ *   The guest writes to the second host page of a memslot backed by one
+ *   THP, then reads the first address past it. If KVM mapped the THP and
+ *   nothing past it, the write lands in the memslot and the read exits as MMIO.
  */
 #include <linux/bitfield.h>
 #include <linux/bitmap.h>
@@ -198,6 +203,49 @@ static void test_exec_split_drain(void)
 	kvm_vm_free(vm);
 }
 
+static void thp_guest_code(u64 touch_gva, u64 past_gva)
+{
+	WRITE_ONCE(*(u64 *)touch_gva, 0x1);
+	READ_ONCE(*(u64 *)past_gva);
+	GUEST_DONE();
+}
+
+static void test_thp_tail_first_touch(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	size_t npages;
+	u64 thp_size;
+	u64 gpa;
+
+	if (!thp_configured()) {
+		ksft_print_msg("SKIP THP tail first touch: THP not configured\n");
+		return;
+	}
+	thp_size = get_trans_hugepagesz();
+
+	vm = vm_create_with_one_vcpu(&vcpu, thp_guest_code);
+	npages = thp_size / vm->page_size;
+
+	gpa = (vm_compute_max_gfn(vm) * vm->page_size) - 2 * thp_size;
+	gpa = align_down(gpa, thp_size);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_THP, gpa, DATA_SLOT, npages, 0);
+	virt_pg_map(vm, TEST_GVA + getpagesize(), gpa + getpagesize());
+	virt_pg_map(vm, TEST_GVA + thp_size, gpa + thp_size);
+	vcpu_args_set(vcpu, 2, TEST_GVA + getpagesize(), TEST_GVA + thp_size);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT(get_ucall(vcpu, &uc) != UCALL_DONE,
+		    "Read past the memslot completed without an exit");
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
+	TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, gpa + thp_size);
+	TEST_ASSERT_EQ(*(u64 *)addr_gpa2hva(vm, gpa + getpagesize()), 0x1);
+
+	kvm_vm_free(vm);
+}
+
 /*
  * The explicit-size hugetlb backing hard-fails region creation if the pages
  * are not already reserved, so probe here and skip rather than abort. The
@@ -216,6 +264,8 @@ static void require_hugepages(size_t bytes)
 
 int main(void)
 {
+	test_thp_tail_first_touch();
+
 	require_hugepages(NR_BLOCKS * BLOCK_SIZE);
 
 	test_block_collapse();
-- 
2.47.3

