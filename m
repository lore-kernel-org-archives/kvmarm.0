Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D38331A53
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785537; cv=none; b=QIY63brkURVFdkK2ya4BJwnrA7K1mnm6y753aEbcoCmoNCOxaIUWvj3oW3MWfwGJe1KWzPhU0oLwhNBZE454N+70dAQJfeAqvvlZcEfxE8fikI/OWNJDIuceWwONQUR1VVSC6wmmmcIgxZ8/5jt4QXzzr4Bb5RAPif5W3W7VD/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785537; c=relaxed/simple;
	bh=vGtFww1PuxppHfkNm4nZY6ebSxcqiYn2V+uIZxWhPY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WOnz1Satcw3XV1u1Ncu0yLIhTornq2CSs6nYTllasdSuy9mdjoVx73Up2gBdm7cy+4bWEKYkJySHLlHtCYH40cw/wzGTRUclQp/P/5//SGR3tO8vdryS5EA/uztnk9wzYIlRylmVzdANJxsXSjtJabCOGr73dmS3chNYm8XOmfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fqZxpoBX; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fqZxpoBX"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d52734fc41so31225905ad.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785533; x=1788390333; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Qrd3Eszpzuyl+ARXBwnNOR4mn5401Rmq7plszPl1Tnk=;
        b=fqZxpoBXNafjzPxPdOPuOYZPVG3KAKKmF5SQuMHaL+iVcepr5mK9qieEVD2QYQFaFB
         LWwXbF+L9uWjVTlDcDm4jOc0mYPArlfEDRv89l7RgUKPU1S/2wXKLsZ0ilGwknWn4ile
         WtLiZvVo/KBNF6wa/t6FgjVlt+7Mz+eNvWixUKIQtGpougPHzOdeopEdG1/KJ6pYzwA+
         bP7lxRtI70VECioAEf8E7wf1m6XuX4R8Mb79QfS54PwZIA5dHuNpe8d0bqTbFunWC2VW
         LE6UUgvjlWNiVOzViLs/DWme+4xLScUMLwDUpfaj+uhW1GZKeL1qx7pFCqlNqGlDmD9q
         z9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785533; x=1788390333;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qrd3Eszpzuyl+ARXBwnNOR4mn5401Rmq7plszPl1Tnk=;
        b=f/YpjEOanymTLf4bdn2ZmGxFzudGbHeuaxxnQFYQ0xJ/A03mJUVgRLcajSmApG6Kzk
         i0U2Gm/b2dX1sy198IDpjFVKxqKmXkmWBjn2cIPtKi30eQyCJfJLwxnrsN+6EyhSTLs7
         Ctm8sQ8z4Jse0mnioySEqN358aUgDg86B/AduyiqUst5daQR+eDHcGmGK+bWlCptfiWu
         cTcQNEZQPlUXbrQqAvZ0EQdP+Y9Nw6OJZ0CSG1sH0RoMdMyFo7pZT0qPYdRkJHR1ttgM
         Y+71aumSySbL9pwXpUOI88Ofe3kT29gMIyZ4BBX6ip20BmXMtwgTOt5sR0g6qOetYKhs
         maIw==
X-Forwarded-Encrypted: i=1; AHgh+Rq5471WickastbDn1Mrox7lJ14vPNmAtS4BhtiEVbB3qceTAbV7Ly6oqHbaeECWWNhb4TSoQT8=@lists.linux.dev
X-Gm-Message-State: AFuF++kGeJO2iMfL71LtqaUN7ewv91zPIiOKMscHbf4I78743Tv4xfzh
	Z2VNfxAqnTXjxBJYtO0uWkaN1Y0bBhwUjeHQTA1fXYmGvBnLLNBQE55W5yuIDnjGS99lQmJ5Cyg
	UfW2I0g==
X-Received: from plfn5.prod.google.com ([2002:a17:902:e545:b0:2cc:fd6e:8ff3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32c9:b0:2c9:df1b:e948
 with SMTP id d9443c01a7336-2d7079eb7e9mr183803125ad.4.1787785532402; Wed, 26
 Aug 2026 16:05:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:05:04 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-14-seanjc@google.com>
Subject: [PATCH 13/20] KVM: selftests: Add TEST_EXTRA memory region type for
 "special" memslots
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

And another memory region type to deal with extra, one-off memory regions,
and use the new type to manage x86's SMRAM memslot, as another step towards
taking the region type instead of the raw memslot in the physical page
allocator APIs.

Alternatively, SMRAM setup could simply use the quad-underscore API to
continue passing in the memslot, but a surprising number of tests use an
"extra" memslot for a variety of reasons.  I.e. allocating memory from one
(and exactly one) extra memslot isn't all that rare, and so should be
treated as normal behavior, not as something extraordinary, as
quad-underscore functions typically suggest.

Opportunistically add comments to document the intended usage of the types,
as the difference between DATA, TEST_DATA, and TEST_EXTRA in particular
isn't exactly obvious.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 37 ++++++++++++++++---
 tools/testing/selftests/kvm/include/x86/smm.h |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  7 ++--
 3 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 14f87c8a00ec..f4f4f360a10b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -82,11 +82,43 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+/*
+ * Memory region types are passed to various page allocators to communicate
+ * various properties and metadata related to the allocation.  Note, the
+ * descriptions below described the primary usage of each type.  Individual
+ * tests may allocate memory for other purposes.
+ *
+ * By default, all regions are mapped to memslot '0'.  Tests can override the
+ * memslot for any or all types, e.g. so that all test data is allocated from a
+ * curated memslot.
+ */
 enum kvm_mem_region_type {
+	/*
+	 * The CODE region is used by lib/elf when loading the test's code into
+	 * guest memory.
+	 */
 	MEM_REGION_CODE,
+	/*
+	 * The DATA region is used to allocate core data structures, e.g. vCPU
+	 * stacks, VM exception tables, x86's TSS, etc.
+	 */
 	MEM_REGION_DATA,
+	/*
+	 * The PT region, a.k.a. Page Table region, is used to allocate page
+	 * table pages.
+	 */
 	MEM_REGION_PT,
+	/*
+	 * The TEST_DATA region is used for allocating test data that is either
+	 * test specific, and/or isn't considered a "core" data structure.
+	 */
 	MEM_REGION_TEST_DATA,
+	/*
+	 * The TEST_EXTRA region is for special snowflakes, where a test wants
+	 * to create and use a one-off memslot, without impacting "normal" test
+	 * data allocations.
+	 */
+	MEM_REGION_TEST_EXTRA,
 	NR_MEM_REGIONS,
 };
 
@@ -129,11 +161,6 @@ struct kvm_vm {
 
 	struct kvm_binary_stats stats;
 
-	/*
-	 * KVM region slots. These are the default memslots used by page
-	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
-	 * memslot.
-	 */
 	u32 memslots[NR_MEM_REGIONS];
 };
 
diff --git a/tools/testing/selftests/kvm/include/x86/smm.h b/tools/testing/selftests/kvm/include/x86/smm.h
index 2d1afa09819b..15faaa060126 100644
--- a/tools/testing/selftests/kvm/include/x86/smm.h
+++ b/tools/testing/selftests/kvm/include/x86/smm.h
@@ -8,7 +8,7 @@
 #define SMRAM_MEMSLOT	((1 << 16) | 1)
 #define SMRAM_PAGES	(SMRAM_SIZE / PAGE_SIZE)
 
-void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, u64 smram_gpa,
+void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, gpa_t smram_gpa,
 		 const void *smi_handler, size_t handler_size);
 
 void inject_smi(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index ea5fa59888af..b988eea373ad 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1468,11 +1468,12 @@ bool kvm_arch_has_default_irqchip(void)
 	return true;
 }
 
-void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, u64 smram_gpa,
+void setup_smram(struct kvm_vm *vm, struct kvm_vcpu *vcpu, gpa_t smram_gpa,
 		 const void *smi_handler, size_t handler_size)
 {
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, smram_gpa,
-				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
+	vm_override_mem_region(vm, MEM_REGION_TEST_EXTRA, VM_MEM_SRC_ANONYMOUS,
+			       smram_gpa, SMRAM_MEMSLOT, SMRAM_PAGES);
+
 	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, smram_gpa,
 				       SMRAM_MEMSLOT) == smram_gpa,
 		    "Could not allocate guest physical addresses for SMRAM");
-- 
2.55.0.887.g758fc8c411-goog

