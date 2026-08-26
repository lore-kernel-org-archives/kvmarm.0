Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD283BB10C
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 23:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787785529; cv=none; b=tTw/Nx0WU/AIdzgSBxZzaH45qLmLLit/V4RzgiPKyjxXW/A9/q9uNGatXNIjW0+QUAqrGzNnfZj/hmWo3HcuUa13EjF+7wPnuMEBZxOX/vq7hNaWrOcTQQBhok8+D87jdhft91syc1xlDU0/QIpkJAV0QebCthbwuZtprEYuaj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787785529; c=relaxed/simple;
	bh=qL5Msc494NJuKcmWE24vsAAjb+vMIGOu61VoiZ5Vfps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sD4wuebBbxkyFu4k0TPtKEY7s5OpIvvlFDG2e8lWvNooWcxo+p3dAvsKyKgqVVkHrP3044aGUZs2uB5Wh7fcAX3uZvcMvWeyR0kow0EXVxTjXbha9WJ2QeB1snLlgSpSYAFl6eyW0V/Sk+f2jYpGzpBxYPLGmCz6LlbUQbdMw/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jfI/hnRY; arc=none smtp.client-ip=209.85.214.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jfI/hnRY"
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2cc6dd43737so21489385ad.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 16:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787785521; x=1788390321; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WTM/WcY6qCCrKYMU/D/LJJQp2BSUWxg1SxXMol0XzNo=;
        b=jfI/hnRYT+0w42yyhWTiBLLIP0o6hFdSVcFLhkWQPuGfpuCtuWE4iwIB24lyg1B1OY
         Cv8TiLWhw8V8HC3ZcRkvsy8Xan5CK1zwk9POWolb4QFjPhZE6VuK1iPzi3GRlLkYQ9SX
         wCVi+ztRrEqdQ3aHqmg17X6ZSO5tZFDXwD4z2QN9fwOETEOFL4Z7uqo6VpUm7wymO/N0
         croXYoppc3ZwhTpGPrXyC1flPjcpfeI7wcELRKfU0lr1NqpwLDgOz5hc27WULut2ee80
         jYNU2VjxmsgOVDac+IodwdbVJ66i/FAub20qJ4ylcTPvOImDBETn2NHLIU8awEqL2Srb
         gxcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787785521; x=1788390321;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WTM/WcY6qCCrKYMU/D/LJJQp2BSUWxg1SxXMol0XzNo=;
        b=c9oYbTkNfHvyM5bFnAObsGC4x5YsEW3m9R+dGz6oJgTSmNs1KGE3g3Zsu2sLAYbTQs
         6hfiuhFY3mD5thWWDTiOzArgd+7KW9ToWw+KBa2phrSbs2OXwpQ4bYgqWsAaFa4/uUPT
         BByb0pifV6fwmJQXdYIBnrSTmNNLqCCJ7KeClX1Y1WJkH7gUx868cl24VF8iUphoycNz
         NJKW+Ufxq3P222zVLRfuo/dm9miplkHlFfz35B27skBOVUZ1WKfBpuloP2CjSwEzltWe
         WnKBxRqnvdLydM5COKs0DNKPcRx499eNQvbNgOzNXse1dMVhvtCmwrtsYSt+9clp9t/w
         +QQg==
X-Forwarded-Encrypted: i=1; AHgh+RqHkAUf5BQSpxc0ziQbbShiegt1+VsoNXoMiOP2JNZ75DTiqWPgFprtbddJanC4tydKx8uiHpE=@lists.linux.dev
X-Gm-Message-State: AFuF++myKsIzt1hz3vZyWdlqqJedhBgnReREMjtpoxSKyWX38gH/8ivN
	oHl925oPqrKTyulcDUXPjMMiTYyoFpqWIP1acIRrd7e/TluoJASdQaZARmLLMI91jRqx+yaL26G
	BDKN59g==
X-Received: from plbkh8.prod.google.com ([2002:a17:903:648:b0:2cc:ed0e:f302])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f64f:b0:2c9:fb11:1bf4
 with SMTP id d9443c01a7336-2d707aca8dcmr198971375ad.7.1787785520801; Wed, 26
 Aug 2026 16:05:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Aug 2026 16:04:55 -0700
In-Reply-To: <20260826230511.972824-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826230511.972824-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.887.g758fc8c411-goog
Message-ID: <20260826230511.972824-5-seanjc@google.com>
Subject: [PATCH 04/20] KVM: selftests: Rename "num" param to "nr_pages" for
 physical page allocators
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

Rename the "num" param in the physical page allocator APIs to "nr_pages" to
make the unit and role of the param more obvious.

Opportunistically rework the function comment to drop the superfluous
kerneldoc style, and to very explicitly call out that success is guaranteed.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  6 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 35 ++++++-------------
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 70906a0d1003..b1c5597b1def 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -991,11 +991,11 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
 const char *exit_reason_str(unsigned int exit_reason);
 
 gpa_t vm_phy_page_alloc(struct kvm_vm *vm, gpa_t min_gpa, u32 memslot);
-gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num, gpa_t min_gpa,
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
 			   u32 memslot, bool protected);
 gpa_t vm_alloc_page_table(struct kvm_vm *vm);
 
-static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages,
 				       gpa_t min_gpa, u32 memslot)
 {
 	/*
@@ -1003,7 +1003,7 @@ static inline gpa_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	 * protected memory, as the majority of memory for such VMs is
 	 * protected, i.e. using shared memory is effectively opt-in.
 	 */
-	return __vm_phy_pages_alloc(vm, num, min_gpa, memslot,
+	return __vm_phy_pages_alloc(vm, nr_pages, min_gpa, memslot,
 				    vm_arch_has_protected_memory(vm));
 }
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9ddc047d5c27..b071d77dd301 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2025,33 +2025,20 @@ const char *exit_reason_str(unsigned int exit_reason)
 }
 
 /*
- * Physical Contiguous Page Allocator
+ * Allocate contiguous (guest) physical pages in a given memory region, at or
+ * the minimum specific GPA.  If the memory is protected/private, also add the
+ * allocate pages to the region's set of protected pages, e.g. so that arch
+ * code knows which pages need to be encrypted when launching the VM.
  *
- * Input Args:
- *   vm - Virtual Machine
- *   num - number of pages
- *   min_gpa - Physical address minimum
- *   memslot - Memory region to allocate page from
- *   protected - True if the pages will be used as protected/private memory
- *
- * Output Args: None
- *
- * Return:
- *   Starting physical address
- *
- * Within the VM specified by vm, locates a range of available physical
- * pages at or above min_gpa. If found, the pages are marked as in use
- * and their base address is returned. A TEST_ASSERT failure occurs if
- * not enough pages are available at or above min_gpa.
+ * Note, success is guaranteed!
  */
-gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			   gpa_t min_gpa, u32 memslot,
-			   bool protected)
+gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t nr_pages, gpa_t min_gpa,
+			   u32 memslot, bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
 
-	TEST_ASSERT(num > 0, "Must allocate at least one page");
+	TEST_ASSERT(nr_pages, "Must allocate at least one page");
 
 	TEST_ASSERT((min_gpa % vm->page_size) == 0, "Min physical address "
 		"not divisible by page size.\n"
@@ -2064,13 +2051,13 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 
 	base = pg = min_gpa >> vm->page_shift;
 	do {
-		for (; pg < base + num; ++pg) {
+		for (; pg < base + nr_pages; ++pg) {
 			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
 				base = pg = sparsebit_next_set(region->unused_phy_pages, pg);
 				break;
 			}
 		}
-	} while (pg && pg != base + num);
+	} while (pg && pg != base + nr_pages);
 
 	if (pg == 0) {
 		fprintf(stderr, "No guest physical page available, "
@@ -2081,7 +2068,7 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		abort();
 	}
 
-	for (pg = base; pg < base + num; ++pg) {
+	for (pg = base; pg < base + nr_pages; ++pg) {
 		sparsebit_clear(region->unused_phy_pages, pg);
 		if (protected)
 			sparsebit_set(region->protected_phy_pages, pg);
-- 
2.55.0.887.g758fc8c411-goog

