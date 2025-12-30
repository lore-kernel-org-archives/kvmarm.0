Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C662D9EDC
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135718; cv=none; b=nRplm1DtNk2SKfyu4m6xLjm4Mrqm0RmQc9v+oUMDO+6WhlNCNOV4tdZHPrmrz/8h63GQFwRSvfkRkR3AgGX0XxunIhKGnYJy8Czey5nkUr7Vypt84WA09WIKXH9koO/N+Pa2oK2KAUchu3rpZo73Y7J+BuGSNq+WrUYZRrwV2gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135718; c=relaxed/simple;
	bh=eN5uc7pSFzMybyeyIg1wl+tq2Gr7dbaFYRW0/rdIHyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I/2Gu5fyt7MZ3QZCIB3pHIwps5YNoyRd5CnXqFXmVfkpj0FaDeu9PnkZlTagvHB34XHtjNuWefVvGqpVKJWTjQ1rkPgnekM2erQckBDgpnzOQk0f4GponLK1XobcX9DpnlVVYMYGbao7HvGaZjfgd314ezT8Qfxa7YEttsSWPX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZvzOgmH8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZvzOgmH8"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a13be531b2so224307795ad.2
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135716; x=1767740516; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=A1x3Jv4hKAWrGgMmMHZE2moCxnL8NNPpEDvW/jENOxU=;
        b=ZvzOgmH8Dh4V12TTnPISJW2KLkoqYxIuTBPmFvXfJdtJjiQ7t1d/zfDNfJJHsn6ETC
         OvELT4/wzdzbIPtaAlnuFv2BgQMBiRrn1wRGuApdjl5hmcQoz+l1L9NXgwnjpkFdvn0O
         pE6Rxso/BMv0JAmI6VYcoMsZb+8IHrOoZVv/BqIXOA2Vcy0CneBemQAkemn9RrOcjcyQ
         qzIhHPpXvtdpwXC7SYkSfpxbsN3h56LZ4ullPWjoQlN/uRZXzVELjVJrZ4/Wb4us6cPm
         Odv5Wyaqo26WkxOmL8ZoDrIFeHYs9KUTDMOwdJKrQCp/XoNSiBDnjhxjx0O7BCIaeBRf
         iqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135716; x=1767740516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A1x3Jv4hKAWrGgMmMHZE2moCxnL8NNPpEDvW/jENOxU=;
        b=QohBMBMKGPPYVN5FZBkmO0CkiUt62G0dqk36iXFYsSv5GPkJ48Tcb+cvfCgoVyMf69
         DWwY16I7F/V3xO4sr/qS9PiZFxk9Ui71BRkVQMV5O7geU5l2o+hlucauyovncUYW2nRM
         5xp8xij6LElFghyttGWXuN1p+a0rjq6kXA4r63dtjvgXeknxSiO6AQMdU5oVIO5p8Ym8
         4XNVGeeZz6TcZ6JaIGbr9ILUkbb/Go3INeJNuZJBKp7wwQTeqbPlqUqcBkyh61s2LXMS
         NArg467HCXV3OIXwh2Q56dk6OTHGTKO8zHn9QSpR6s/UqH7U8mqbaWrPKDoMUnYsUqXc
         NgbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLeePyw4QlOY9al8BcHef6FBfXvrc5KR0+7nfkSQhbMjcuAD/vL54pEjNtbfNafeKfLhWZNDo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzS5s6Q00BIqM6zEKPiKLUHHLZoTjw2dKyynpvrnLw+WBpZAKOO
	KuU5nmJZ6bLEGDUbNTNsoZjlEO5khTO8Ch0v0XJFzB5AmjqwD1EridLoyfDbHnpkAWnI9p7qr4q
	KaYZW5w==
X-Google-Smtp-Source: AGHT+IEv+GX7evZLjKnG5+SJTBFZGdYgiJ8sh+9jSGp5VMcqldVrrbZx+5CrciujOKyo6Zq9eBa3EV2km6w=
X-Received: from pjbpm1.prod.google.com ([2002:a17:90b:3c41:b0:34c:2ca6:ff3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:32d1:b0:293:e12:1bec
 with SMTP id d9443c01a7336-2a2f2229207mr365100115ad.20.1767135715930; Tue, 30
 Dec 2025 15:01:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:31 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-3-seanjc@google.com>
Subject: [PATCH v4 02/21] KVM: selftests: Stop passing a memslot to nested_map_memslot()
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

On x86, KVM selftests use memslot 0 for all the default regions used by
the test infrastructure. This is an implementation detail.
nested_map_memslot() is currently used to map the default regions by
explicitly passing slot 0, which leaks the library implementation into
the caller.

Rename the function to a very verbose
nested_identity_map_default_memslots() to reflect what it actually does.
Add an assertion that only memslot 0 is being used so that the
implementation does not change from under us.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/vmx.h        |  4 ++--
 tools/testing/selftests/kvm/lib/x86/vmx.c            | 12 ++++++++----
 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 96e2b4c630a9..91916b8aa94b 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -563,8 +563,8 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr);
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot);
+void nested_identity_map_default_memslots(struct vmx_pages *vmx,
+					  struct kvm_vm *vm);
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 29b082a58daa..eec33ec63811 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -494,12 +494,16 @@ void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
-			uint32_t memslot)
+void nested_identity_map_default_memslots(struct vmx_pages *vmx,
+					  struct kvm_vm *vm)
 {
+	uint32_t s, memslot = 0;
 	sparsebit_idx_t i, last;
-	struct userspace_mem_region *region =
-		memslot2region(vm, memslot);
+	struct userspace_mem_region *region = memslot2region(vm, memslot);
+
+	/* Only memslot 0 is mapped here, ensure it's the only one being used */
+	for (s = 0; s < NR_MEM_REGIONS; s++)
+		TEST_ASSERT_EQ(vm->memslots[s], 0);
 
 	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
 	last = i + (region->region.memory_size >> vm->page_shift);
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 98cb6bdab3e6..aab7333aaef0 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,7 +121,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm);
-		nested_map_memslot(vmx, vm, 0);
+		nested_identity_map_default_memslots(vmx, vm);
 		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
 		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
-- 
2.52.0.351.gbe84eed79e-goog

