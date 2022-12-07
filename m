Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE19C63708
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 21:48:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C97164B835;
	Wed,  7 Dec 2022 16:48:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q4QfOWeDKLM8; Wed,  7 Dec 2022 16:48:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 768B24B83B;
	Wed,  7 Dec 2022 16:48:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB5284B845
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q+sPgtVG65Dr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 16:48:32 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 638B34B84A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 16:48:32 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670449711;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JjcLqG29a+AOOV8U9ftW4rJBJFHTcmpsMspP2V/5Cq4=;
 b=LZ2KqSYJ3rzGKHTpVsL9UIqkvKv36BEDlqIYvZDdPVueuSXGNNtYFARu7DRvMcGEQeTTPm
 Ri9shjCfD4g/EIdtKic5HUphwv697OSWoj1wK85DQrabSHnkQ04NZnQdxOm2YczZ/8fm79
 jG3qTkJ0rfmc8fLyhtF/6DxUvimTBDo=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/4] KVM: arm64: selftests: Align VA space allocator with TTBR0
Date: Wed,  7 Dec 2022 21:48:07 +0000
Message-Id: <20221207214809.489070-4-oliver.upton@linux.dev>
In-Reply-To: <20221207214809.489070-1-oliver.upton@linux.dev>
References: <20221207214809.489070-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
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
[0, 2^(va_bits-1)). This is different from other architectures that
allow for addressing low and high regions of the VA space from a single
page table.

KVM selftests' VA space allocator presumes the valid address range is
split between low and high memory based the MSB, which of course is a
poor match for arm64's TTBR0 region.

Allow architectures to override the default VA space layout. Make use of
the override to align vpages_valid with the behavior of TTBR0 on arm64.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/include/kvm_util_base.h |  1 +
 .../testing/selftests/kvm/lib/aarch64/processor.c | 10 ++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c        | 15 ++++++++++-----
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6cd86da698b3..fbc2a79369b8 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -420,6 +420,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
+void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
 vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 316de70db91d..5972a23b2765 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -541,3 +541,13 @@ void kvm_selftest_arch_init(void)
 	 */
 	guest_modes_append_default();
 }
+
+void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+{
+	/*
+	 * arm64 selftests use only TTBR0_EL1, meaning that the valid VA space
+	 * is [0, 2^(64 - TCR_EL1.T0SZ)).
+	 */
+	sparsebit_set_num(vm->vpages_valid, 0,
+			  (1ULL << vm->va_bits) >> vm->page_shift);
+}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e9607eb089be..c88c3ace16d2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -186,6 +186,15 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
 
+__weak void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+{
+	sparsebit_set_num(vm->vpages_valid,
+		0, (1ULL << (vm->va_bits - 1)) >> vm->page_shift);
+	sparsebit_set_num(vm->vpages_valid,
+		(~((1ULL << (vm->va_bits - 1)) - 1)) >> vm->page_shift,
+		(1ULL << (vm->va_bits - 1)) >> vm->page_shift);
+}
+
 struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 {
 	struct kvm_vm *vm;
@@ -274,11 +283,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode)
 
 	/* Limit to VA-bit canonical virtual addresses. */
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
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
