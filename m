Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D614C4167B
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 01:53:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADF5F4BA1A;
	Thu,  8 Dec 2022 20:53:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 06McCaD6D6SG; Thu,  8 Dec 2022 20:53:40 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 407FF4B9FF;
	Thu,  8 Dec 2022 20:53:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72ABB4B9D3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0aQ-SQ05yPcM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Dec 2022 20:53:38 -0500 (EST)
Received: from out-199.mta0.migadu.com (out-199.mta0.migadu.com
 [91.218.175.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03AD44BA2C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Dec 2022 20:53:37 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 4/7] KVM: selftests: Correctly initialize the VA space for
 TTBR0_EL1
Date: Fri,  9 Dec 2022 01:53:03 +0000
Message-Id: <20221209015307.1781352-5-oliver.upton@linux.dev>
In-Reply-To: <20221209015307.1781352-1-oliver.upton@linux.dev>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

An interesting feature of the Arm architecture is that the stage-1 MMU
supports two distinct VA regions, controlled by TTBR{0,1}_EL1. As KVM
selftests on arm64 only uses TTBR0_EL1, the VA space is constrained to
[0, 2^(va_bits)). This is different from other architectures that
allow for addressing low and high regions of the VA space from a single
page table.

KVM selftests' VA space allocator presumes the valid address range is
split between low and high memory based the MSB, which of course is a
poor match for arm64's TTBR0 region.

Add a helper that correctly handles both addressing schemes with a
comment describing each.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 49 ++++++++++++++++---
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6cd86da698b3..b193863d754f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -103,6 +103,7 @@ struct kvm_vm {
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
 	bool pgd_created;
+	bool has_split_va_space;
 	vm_paddr_t ucall_mmio_addr;
 	vm_paddr_t pgd;
 	vm_vaddr_t gdt;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a256ec67aff6..53d15f32f220 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -186,6 +186,43 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
+/*
+ * Initializes vm->vpages_valid to match the canonical VA space of the
+ * architecture.
+ *
+ * Most architectures split the range addressed by a single page table into a
+ * low and high region based on the MSB of the VA. On architectures with this
+ * behavior the VA region spans [0, 2^(va_bits - 1)), [-(2^(va_bits - 1), -1].
+ *
+ * arm64 is a bit different from the rest of the crowd, as the low and high
+ * regions of the VA space are addressed by distinct paging structures
+ * (TTBR{0,1}_EL1). KVM selftests on arm64 only uses TTBR0_EL1, meaning that we
+ * only have a low VA region. As there is no VA split based on the MSB, the VA
+ * region spans [0, 2^va_bits).
+ */
+static void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+{
+	sparsebit_num_t contig_va_bits = vm->va_bits;
+	sparsebit_num_t nr_contig_pages;
+
+	/*
+	 * Depending on the architecture, the MSB of the VA could split between
+	 * low and high regions. When that is the case each region has
+	 * va_bits - 1 of address.
+	 */
+	if (vm->has_split_va_space)
+		contig_va_bits--;
+
+	nr_contig_pages = (1ULL << contig_va_bits) >> vm->page_shift;
+
+	sparsebit_set_num(vm->vpages_valid, 0, nr_contig_pages);
+
+	if (vm->has_split_va_space)
+		sparsebit_set_num(vm->vpages_valid,
+				  -(1ULL << contig_va_bits),
+				  nr_contig_pages);
+}
+
 struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 {
 	struct kvm_vm *vm;
@@ -268,17 +305,17 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 #ifdef __aarch64__
 	if (vm->pa_bits != 40)
 		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
+
+	/* selftests use TTBR0 only, meaning there is a single VA region. */
+	vm->has_split_va_space = false;
+#else
+	vm->has_split_va_space = true;
 #endif
 
 	vm_open(vm);
 
-	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
-	sparsebit_set_num(vm->vpages_valid,
-		0, (1ULL << (vm->va_bits - 1)) >> vm->page_shift);
-	sparsebit_set_num(vm->vpages_valid,
-		(~((1ULL << (vm->va_bits - 1)) - 1)) >> vm->page_shift,
-		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
+	vm_vaddr_populate_bitmap(vm);
 
 	/* Limit physical addresses to PA-bits. */
 	vm->max_gfn = vm_compute_max_gfn(vm);
-- 
2.39.0.rc1.256.g54fd8350bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
