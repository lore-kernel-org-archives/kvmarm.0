Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A33D4125
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720045; cv=none; b=S0so2HsdZjS8TN+kmfcYng36bZyP6YV9tLxOzCtTybvLG858R5WLCVRZM3yrxzmXHI9TUZQz4FUHNY70F0qgV8eLeqTw79B/V7k6nIC+wBKkKCe7KPlQDAJQjRygXTQRIL1didVFDeVHBRCoB1DzmSvP637BtZvvu8c+ox9e2gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720045; c=relaxed/simple;
	bh=rGlxiGCoF1z1rV0m6jsQdC2fJYh/1Na3J5FPTRlOY0g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uBZIsjZdT6JO2ovrOl0u/9nMRIZkZenS+sHzL5KsUsZol8vqAqUahqR+ieTXNZZb98sBTBwdBXDfrELtxd/x9XnXAF7vu9efeDcnbhBll9TvWKaVQVea2a0JcGVWweclCQdYz1R2y0CLz/2oIheyBWT6YVS30H0esRt7QeWnv2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HEn+kS1+; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEn+kS1+"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b630753cc38so4428414a12.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720043; x=1777324843; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QEFsBmHczG78buJgokkfE6P9p/Sjtw0NPo8cky9xSS4=;
        b=HEn+kS1+ufjWIedKathiN1Kiuz0WXqLeQW/pD9wa/RhmZcDOOdkfue42OLPFE0eQzM
         LAV28Oa22Rg4UUG7AYzTF0lhHd8coPkKafU+7s3zqQ9U8NTnXdexbXL/Z4hjo/Q0PucN
         Y5jiAaeVNKSadnBX3CTj1y11ZivT/Yfi9AvOSOmeizrZE+nLiXWbamoTCtm+5sDRtWXG
         bRc+MV4IMpAXyWho74MY3kaTEaYyQAQwsjqX60llcpn6mWH4p/kNK7c5sabA4Qm0q35S
         NbW5Z8iOyifIV+WzJs4JnbcyIydwkQibBUNHX2iX/ssk+763moOmESbzvzZK/pXow01C
         qJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720043; x=1777324843;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QEFsBmHczG78buJgokkfE6P9p/Sjtw0NPo8cky9xSS4=;
        b=JcCY4lZNbzXVpDtJNG18Pdkz0XGAG+Z/YMSJUyPSRZMm0loMuNSFYy24JKt/ryFtf1
         nlv/5ZV3UqIaE5gSSdn6qqYaNbGyZbks7u7fxxG/4k3GW8p9uPWKB/azdItYEBxNmPMk
         yk9KzAywIzF9mCBgCMfsWzk7JHL8fmBgNxJLSkFvWyVtnTIjhMwRVclr2XMc56QVKucz
         3VKrB/1VtNbzDqlViyl9BFW0FGrhGsn1vDGZGaaUhFlGjNzaPW45wqvTVJxPIbHVYfub
         jvmLLYNEffq0bEUSY0LdyEkwrRKHAvE0pWWJU090sfaBdXGxdQH3owKukjA8HjJ5Mh7P
         +mcw==
X-Forwarded-Encrypted: i=1; AFNElJ8EM529bU7gtrD7igQzdQ+GbV6cFfqSnvNA6efmfosAJTt9nGTO1+l+CcyP6sY7sNMHQoqUjYk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoY+hpWPgcMLlSZrGb2Bdt8cWIdm9vyZsOl2SOMPPZwDo85IcV
	icR3JlIHYpwEGsL0UTjq2cXrL0oIjBPxG9p6AL6f3CUCxXSw23mEO48opnJcEfCOtzgpvdkhj5d
	tplaylQ==
X-Received: from pgbdp12.prod.google.com ([2002:a05:6a02:f0c:b0:c79:84fb:feac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d82:b0:398:90e5:a9b9
 with SMTP id adf61e73a8af0-3a08d89d0b9mr16041202637.27.1776720042436; Mon, 20
 Apr 2026 14:20:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:20:03 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-19-seanjc@google.com>
Subject: [PATCH v3 18/19] KVM: selftests: Replace "u64 nested_paddr" with
 "gpa_t l2_gpa"
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
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

In x86's nested TDP APIs, use the appropriate gpa_t typedef and rename
variables from nested_paddr to l2_gpa to match KVM x86's nomenclature.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86/processor.h  |  2 +-
 tools/testing/selftests/kvm/lib/x86/processor.c    | 14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index fc7efd722229..97dc887658c3 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1514,7 +1514,7 @@ void virt_map_level(struct kvm_vm *vm, gva_t gva, u64 paddr,
 
 void vm_enable_tdp(struct kvm_vm *vm);
 bool kvm_cpu_has_tdp(void);
-void tdp_map(struct kvm_vm *vm, u64 nested_paddr, u64 paddr, u64 size);
+void tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, u64 paddr, u64 size);
 void tdp_identity_map_default_memslots(struct kvm_vm *vm);
 void tdp_identity_map_1g(struct kvm_vm *vm,  u64 addr, u64 size);
 u64 *tdp_get_pte(struct kvm_vm *vm, u64 l2_gpa);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 3c55980c81b2..892cc517d9f1 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -495,26 +495,24 @@ bool kvm_cpu_has_tdp(void)
 	return kvm_cpu_has_ept() || kvm_cpu_has_npt();
 }
 
-void __tdp_map(struct kvm_vm *vm, u64 nested_paddr, u64 paddr,
-	       u64 size, int level)
+void __tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, u64 paddr, u64 size, int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
 	size_t npages = size / page_size;
 
-	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
+	TEST_ASSERT(l2_gpa + size > l2_gpa, "L2 GPA overflow");
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__virt_pg_map(vm, &vm->stage2_mmu, nested_paddr, paddr, level);
-		nested_paddr += page_size;
+		__virt_pg_map(vm, &vm->stage2_mmu, l2_gpa, paddr, level);
+		l2_gpa += page_size;
 		paddr += page_size;
 	}
 }
 
-void tdp_map(struct kvm_vm *vm, u64 nested_paddr, u64 paddr,
-	     u64 size)
+void tdp_map(struct kvm_vm *vm, gpa_t l2_gpa, u64 paddr, u64 size)
 {
-	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+	__tdp_map(vm, l2_gpa, paddr, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
-- 
2.54.0.rc1.555.g9c883467ad-goog

