Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3E82D6624
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135721; cv=none; b=AsHonkyihOjA0pOtzSnXSlbPb6nIIk3pcVNU1FOP+8T8d9RgP3fVirHat/XZWPgHOdVsN1IWuXzrEjGz3dYJ9yB0ojJdyhSpAtAq8mscjsRxddXLNS7uPsxsMZrmSN3jnWe9sdt17ky2CuS+ka88M5VyW106Ynz06Bdhu/Rtmjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135721; c=relaxed/simple;
	bh=91L4txYNNUE5SJojuQZ2nZ3cjzuGzWc5839mOJ9F1/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rTePdJkStwlhMk9lLbyGTut9279QGyGEsI8mEHtUyM61Ijqmx7++crHXBdi1hm3VHLdkxGNxfzHXWS7tJEf5bS44Owli/W2QaIpo/G+AhdN9ZzggzUryghz4dvSmcorghbeIYD4z8r2yPmUoBzrm+he5hNBw0jcVhCyfOxz3WeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QqJ0XaQ0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QqJ0XaQ0"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c314af2d4so9755102a91.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135717; x=1767740517; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yWDCaLTCIbcQO/h6zTAUUdpMSrBY0ICbFLNvpCPkE/c=;
        b=QqJ0XaQ0U72TrsLC6pWGDs0sgPflRx9rVahq2RUPiFKBGvnIZIwFcj43cuSWGzZipR
         dRvLV0dSgbDWGlPAcHDalg9H4WKfzVEgfCTTqROf56uQ7wSf5OoWtyu1gw+EW9S0Py6v
         EOKUe1cwp4l+ZMwBNwdYNZEGGwwx4cTFMnvFzoVgNPkMoyR8qXte+YKLmVhdrD/sUh74
         DcFABHVx3nVHUKYo+/ZkFvlOHsNK2vkmRWXt9mCcvp3P3SLxvq/TdJuSOFzrvw6MMNfy
         EBFBgBDxpBbcEYFJygbTOiCDTlEE4BfbgEkMYEHX2YDPjQ2CLOgexGgNEdGAA31bo2pp
         hm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135717; x=1767740517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWDCaLTCIbcQO/h6zTAUUdpMSrBY0ICbFLNvpCPkE/c=;
        b=DeMze5WGQKoDTCee1vMjGl2msc2R1DlyChlYphvWTkLL+KIZ7lFnAEEjTmEpMsh/iw
         lrmQiI7RGrVYzrJOf0uEEY+qwnaKfe2sylg5eJxaeo3eLF197aDbEUbrP5UJJd4306du
         CT4XzW0ILoUQQXvd48sUo5lLlsoXMt310mOST77onwkLysUoY3LMi3vxv6ECfhUi5VQg
         8NlmQbr/BJz8J0TFvzERoWhjn2eeJI8uQps7virB9/OC6AuMGJd/sEeuOdDXq8qaU8Kg
         Xbq1ACpzY+8bd4nRjP1amQvPsxEIftIok7NoH0hGufXStq7P8KEWoJEYAT5VqZUXqEuv
         jFZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXj1Xx38p1QzTWkbNS4/3TUQj+rjwg47e/xqnA+e1/bpfAou0ygU0wLQKXwqxQ7psiPPvetnS0=@lists.linux.dev
X-Gm-Message-State: AOJu0YysYb3ITP1wiwqYYlVuvhQ9OGRbb9imh2X7XKMW69/5IE8SFz3L
	muqWbNzucOAKxpvIHn/CcWJp3FCuR6hOT5DSW8hh3WSp5qG0catAkeca+ZBQxDG/Kv4codph7FH
	/5xpW0Q==
X-Google-Smtp-Source: AGHT+IHV3rTLFIW3Ya/WfGECQ4NGCUq3VWcqeP/2rJnzAJYZRKybcHRTVRGE5PryLt5G6ChfGloqjW0LJ10=
X-Received: from pjbin23.prod.google.com ([2002:a17:90b:4397:b0:34c:f8b8:349b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f83:b0:340:bb56:79de
 with SMTP id 98e67ed59e1d1-34e921ee80bmr29589802a91.30.1767135717583; Tue, 30
 Dec 2025 15:01:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:32 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-4-seanjc@google.com>
Subject: [PATCH v4 03/21] KVM: selftests: Rename nested TDP mapping functions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Rename the functions from nested_* to tdp_* to make their purpose
clearer.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/vmx.h | 16 +++---
 .../testing/selftests/kvm/lib/x86/memstress.c |  4 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 50 +++++++++----------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  6 +--
 4 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 91916b8aa94b..04b8231d032a 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -559,14 +559,14 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr);
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_identity_map_default_memslots(struct vmx_pages *vmx,
-					  struct kvm_vm *vm);
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size);
+void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
+		uint64_t paddr);
+void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
+	     uint64_t paddr, uint64_t size);
+void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
+				       struct kvm_vm *vm);
+void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+			 uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 0b1f288ad556..1928b00bde51 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -70,11 +70,11 @@ void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 	 * KVM can shadow the EPT12 with the maximum huge page size supported
 	 * by the backing source.
 	 */
-	nested_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
+	tdp_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
 
 	start = align_down(memstress_args.gpa, PG_SIZE_1G);
 	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
-	nested_identity_map_1g(vmx, vm, start, end - start);
+	tdp_identity_map_1g(vmx, vm, start, end - start);
 }
 
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index eec33ec63811..1954ccdfc353 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -362,12 +362,12 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-static void nested_create_pte(struct kvm_vm *vm,
-			      struct eptPageTableEntry *pte,
-			      uint64_t nested_paddr,
-			      uint64_t paddr,
-			      int current_level,
-			      int target_level)
+static void tdp_create_pte(struct kvm_vm *vm,
+			   struct eptPageTableEntry *pte,
+			   uint64_t nested_paddr,
+			   uint64_t paddr,
+			   int current_level,
+			   int target_level)
 {
 	if (!pte->readable) {
 		pte->writable = true;
@@ -394,8 +394,8 @@ static void nested_create_pte(struct kvm_vm *vm,
 }
 
 
-void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		     uint64_t nested_paddr, uint64_t paddr, int target_level)
+void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		  uint64_t nested_paddr, uint64_t paddr, int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
 	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
@@ -428,7 +428,7 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		index = (nested_paddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 		pte = &pt[index];
 
-		nested_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
+		tdp_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
 
 		if (pte->page_size)
 			break;
@@ -445,10 +445,10 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 
 }
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr)
+void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+		uint64_t nested_paddr, uint64_t paddr)
 {
-	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
+	__tdp_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
 }
 
 /*
@@ -468,8 +468,8 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * Within the VM given by vm, creates a nested guest translation for the
  * page range starting at nested_paddr to the page range starting at paddr.
  */
-void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint64_t nested_paddr, uint64_t paddr, uint64_t size,
+void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+	       uint64_t nested_paddr, uint64_t paddr, uint64_t size,
 		  int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
@@ -479,23 +479,23 @@ void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__nested_pg_map(vmx, vm, nested_paddr, paddr, level);
+		__tdp_pg_map(vmx, vm, nested_paddr, paddr, level);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
 }
 
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+	     uint64_t nested_paddr, uint64_t paddr, uint64_t size)
 {
-	__nested_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+	__tdp_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_identity_map_default_memslots(struct vmx_pages *vmx,
-					  struct kvm_vm *vm)
+void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
+				       struct kvm_vm *vm)
 {
 	uint32_t s, memslot = 0;
 	sparsebit_idx_t i, last;
@@ -512,18 +512,16 @@ void nested_identity_map_default_memslots(struct vmx_pages *vmx,
 		if (i > last)
 			break;
 
-		nested_map(vmx, vm,
-			   (uint64_t)i << vm->page_shift,
-			   (uint64_t)i << vm->page_shift,
-			   1 << vm->page_shift);
+		tdp_map(vmx, vm, (uint64_t)i << vm->page_shift,
+			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
 	}
 }
 
 /* Identity map a region with 1GiB Pages. */
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size)
 {
-	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
+	__tdp_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
 }
 
 bool kvm_cpu_has_ept(void)
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index aab7333aaef0..e7d0c08ba29d 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,9 +121,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm);
-		nested_identity_map_default_memslots(vmx, vm);
-		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_identity_map_default_memslots(vmx, vm);
+		tdp_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-- 
2.52.0.351.gbe84eed79e-goog

