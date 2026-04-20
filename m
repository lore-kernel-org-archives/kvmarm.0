Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2432B3D1701
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 21:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720034; cv=none; b=tD+KIshwz04H9qkBWCjhw9Ad0rm44usLe1FJapmM368GIfuqjLXCWeju57DiDMqQNSy2UzZU26LhFOYavTnOhdzQIsySvYrEP7GCGqj03n/jPasTRIQSBDWjvjlQ6q8j1B7k1WWbwJPurEB7Gqhk5oL1mMbk/qfYOPd59ERSoEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720034; c=relaxed/simple;
	bh=yEgveHaBMKIIsW+doZiDb1nQpM20TwqcCTmsBmJmV/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fdPxxgMV3hl4bbkm24qs0KF0JDTHM7Im3PxrWmQMneDrmVYEERdIaDD6xU/TpfrgSsyqWbGYKL7QFK2HhLr2ELTF85mmDUQB3yASnngTLxFxePD6iZL9u7Rq4o0L/6vMIhak4jYU34IIoI0ttPDznHpBUZwcswGJtIQz3hHoZvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=flfhOydU; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="flfhOydU"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f6a5b4f88so4688988b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 14:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776720031; x=1777324831; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jearMQMOM45vciFPdayTOFGaCCeoL5RElweUFZze4JY=;
        b=flfhOydUnlLFP0eYdcx3Pw2Fgohfmfi6kMoDOmEqXVtXt8g1htlfKgt8t0AyzRUAOR
         oer6aVOQlxFPR6KEsVIkado6bZXOpJSCenXAfAQqMTLytT3HxEdT9QrDVCPIp2b56F5N
         5a8JExKLKt+2QaafqxhQm+dCFDAFRnsBKhWh+T853b6KaSxIto/2CFwC6RWbjfuC0gMh
         XJ98+UFVii4RGs34mVcvhu3UEh9GekUsqwn3sr6tfZSlcpXpJfm7seuRpub2TEgT23UO
         fxfe3HzMYdddyVr70lrhwtjFNsWTlxmbdsdxjbLzA0F+qHQT2fguEEexikGWdMproFIp
         syuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776720031; x=1777324831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jearMQMOM45vciFPdayTOFGaCCeoL5RElweUFZze4JY=;
        b=GMe8wWH9BwXMQyCvnAh+/vrk9Mw4904g6Zu5EHKz1JjqF/WDMpTAAjVfwtqYeFXGm9
         NY0Iov3ZnAVanPZvR5yPsRu0xSK98XDLEQGPiJ83PbXEHqW922WJzzx9EtivMK57FI1S
         Uv9w9xRFJnaYpK7cOuwmNy5xWp2iVNLeYnkNur5o5CBJKwoei70JEL+ocXc2JdHhxhUT
         D8JaLICz1jZERMwA9mH6+2AzX7tNqULiv/ud7MfVLvM0sxo0Hoc6Gz+c8Vul7qa98J6D
         xDfvmkdzPup0puRHFhrjKgmOEz8yqXnn1/OM+nDVNVGTgdP0ByFAXjv1wk3uwSdj61m4
         sj+w==
X-Forwarded-Encrypted: i=1; AFNElJ+wfJxNsehX/6l+LG6caRJIloLiCkhW56WuRFroddN/WFCLPADDlUfs8Q4D3T/Ufp9jg39ujGk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWyANY662NsOy+rjQjXajLKL0zeB+RAUIp0hJ0DR+e+7yfrZBB
	DuMfOZR5fuTDq0POQ9C1APJeC7BGNAk8jHUNoJJp6fP4EYD4OOeKruMWidcbsekIdgL3LLYnSRQ
	betayMw==
X-Received: from pfbhx21.prod.google.com ([2002:a05:6a00:8995:b0:82f:8b22:bc77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:17a1:b0:82c:e83d:a9b0
 with SMTP id d2e1a72fcca58-82f8c850e93mr15532322b3a.21.1776720031083; Mon, 20
 Apr 2026 14:20:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 20 Apr 2026 14:19:58 -0700
In-Reply-To: <20260420212004.3938325-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260420212004.3938325-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260420212004.3938325-14-seanjc@google.com>
Subject: [PATCH v3 13/19] KVM: selftests: Rename vm_vaddr_populate_bitmap() => vm_populate_gva_bitmap()
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

Now that KVM selftests use gva_t instead of vm_vaddr_t, rename the helper
for populating the initial GVA bitmap to drop the defunct terminology and
use "vm" for the scope.

Opportunistically fixup the declaration of the API, which has been broken
since day 1.  The flaw went unnoticed because the sole caller is defined
after the weak version, i.e. can see the prototype without a previous
declaration.

No functional change intended.

Fixes: e8b9a055fa04 ("KVM: arm64: selftests: Align VA space allocator with TTBR0")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h    | 2 +-
 tools/testing/selftests/kvm/lib/arm64/processor.c | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c        | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 0239e89320e5..0fbfb2a28767 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -714,7 +714,7 @@ void vm_mem_region_reload(struct kvm_vm *vm, u32 slot);
 void vm_mem_region_move(struct kvm_vm *vm, u32 slot, u64 new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, u32 slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, u32 vcpu_id);
-void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
+void vm_populate_gva_bitmap(struct kvm_vm *vm);
 gva_t vm_unused_gva_gap(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
 gva_t vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min);
 gva_t __vm_alloc(struct kvm_vm *vm, size_t sz, gva_t vaddr_min,
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index c4f0e37f2907..384b6c80b1e7 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -671,7 +671,7 @@ void kvm_selftest_arch_init(void)
 	guest_modes_append_default();
 }
 
-void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+void vm_populate_gva_bitmap(struct kvm_vm *vm)
 {
 	/*
 	 * arm64 selftests use only TTBR0_EL1, meaning that the valid VA space
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8c82b40a7448..1a1b41021cc7 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -267,7 +267,7 @@ _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params)
  * based on the MSB of the VA. On architectures with this behavior
  * the VA region spans [0, 2^(va_bits - 1)), [-(2^(va_bits - 1), -1].
  */
-__weak void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
+__weak void vm_populate_gva_bitmap(struct kvm_vm *vm)
 {
 	sparsebit_set_num(vm->vpages_valid,
 		0, (1ULL << (vm->va_bits - 1)) >> vm->page_shift);
@@ -385,7 +385,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
 	/* Limit to VA-bit canonical virtual addresses. */
 	vm->vpages_valid = sparsebit_alloc();
-	vm_vaddr_populate_bitmap(vm);
+	vm_populate_gva_bitmap(vm);
 
 	/* Limit physical addresses to PA-bits. */
 	vm->max_gfn = vm_compute_max_gfn(vm);
-- 
2.54.0.rc1.555.g9c883467ad-goog

