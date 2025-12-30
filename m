Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D67832F762
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135752; cv=none; b=ZMYYu+WZUr8ArfRw5/YUyCicunUpmxCYFHPSFNrLPD8rjDYAiU4vH4D/osBpaz9t3hNaXYera8Jk1jH/R79BaZlWugGPfXU+Syf6VQsbMdahoFiVuO9AMROUoacgBLc9H585OgF3hI29XYTW/I7XzBaEhSOZgcm20Lw5ImJXgII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135752; c=relaxed/simple;
	bh=p2Pgz/yRJSbUlMESZ6664VqIIQNLSRXLMLize367QyE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s8bAVEMsHXbXk134RUZhf2+QDHLrAjVJ01knoi4mY77s76OXCQ7C+IYSOXE8jvo0Ce9kdxRvt9YQS8PbqN4qR8K/TRq6cJgfojMawcw2C9TQ1WZwwyq/H49+zHkIXt+uvDrX3pgdSjGabfHunxCAaKjHZxGi3B/3i23swOsjUto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=luEPf+cx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="luEPf+cx"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34aa1d06456so23431735a91.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135749; x=1767740549; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ykxeCu2rd9E7NdPIA3m898BLFxasNeM9KWtJ/FC5NbY=;
        b=luEPf+cx4jsEaGMwcBVJm7U7nurqxNgwKmSvMLIpfhXWol9IOOSM1lBUZbyTVoTl3R
         NhMADOGzGBQaV9Wf4o+i1QY32JrKy4oR+MBH4ZBQFhkefdelRFV/XmDWnWUh0myB4wG8
         a2s5MpDN+cosdoQrB4+k4Cihsj4i1Q473kLfgdItzsr13a8gqbw6l7E63QUuOzgm4+nT
         pE07uvQDyOYucct3glHtcThphGd9pLL3EAAy3FwJDPaChC4mZiUP/q6tqUgNu+USgiL2
         gIAJDVm0/7nUPUMrTPNEehf6ow2Mgxtf4mGjbOmn6F+1d5z8lmd7p2Ih7nsyrGFshwx7
         V6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135749; x=1767740549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykxeCu2rd9E7NdPIA3m898BLFxasNeM9KWtJ/FC5NbY=;
        b=jDuzSOW98k7F58IPJ7I/XV/r86JwDdnYUJdhuYDO/+tdWMWiyHUIwPFRB1Thkt7KM4
         hX7ED8AVeWr2LIta3IsQibXv4fWd9z0ghQhKuUwAr2dGVctlve5e81ifJNN+zEDztYpb
         gDEWjJhWRcvJDFg4fhzTjrPoFIEWEW0k4zMYsZ9FrRG7G50Uwl15dh24+JnoaL1ZDmOZ
         gs2QkT0Mk/SuyD66kO9CRW8qP0t+QwpcU/bm9UyVjhkERmUFIrQTa4hRWY6dTJI/6Dj7
         TBQOEb6E24d7ORocl9WhJBwd2P77oGYmpVA/5bJx4Y07z369EXZ++LPc/S2NdBf6XNAf
         zADQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJdR5q8cP3GHqX+v2+17nimWGW5noyj7WWgv6CciLJuovF9PrDHma6UVsNWh2PVkZeF3ib8cM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNF/LMJxi/MFAbySMzMmKcEHc4+6SbvoPUc69zZWj35ZA7qoP7
	m5GJ/YN3BOx2FLsuAGzNFpvYKOD5GSVWTujZ5goqgj+cuhqjdZimzTzrB7OJYy29Am1RD0EifcA
	f4LRYkw==
X-Google-Smtp-Source: AGHT+IEpuChkB0izCaZM7wAnBEmg/NFDOHvlk8mvLyNibHqxg0YqGOIPaICPmBipc+pvYA8R48I/lk77pf0=
X-Received: from pjbqe11.prod.google.com ([2002:a17:90b:4f8b:b0:34a:9e02:ffa0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfc6:b0:340:d1a1:af8e
 with SMTP id 98e67ed59e1d1-34e921e60d9mr30599932a91.37.1767135748870; Tue, 30
 Dec 2025 15:02:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:49 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-21-seanjc@google.com>
Subject: [PATCH v4 20/21] KVM: selftests: Rename vm_get_page_table_entry() to vm_get_pte()
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

Shorten the API to get a PTE as the "PTE" acronym is ubiquitous, and the
"page table entry" makes it unnecessarily difficult to quickly understand
what callers are doing.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/processor.h           | 2 +-
 tools/testing/selftests/kvm/lib/x86/processor.c               | 2 +-
 tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c            | 2 +-
 .../selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c     | 4 +---
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 7b7d962244d6..ab29b1c7ed2d 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1357,7 +1357,7 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
+uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 5a3385d48902..ab869a98bbdc 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -390,7 +390,7 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
 	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 }
 
-uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
+uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
 {
 	int level = PG_LEVEL_4K;
 
diff --git a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
index a3b7ce155981..c542cc4762b1 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_tlb_flush.c
@@ -619,7 +619,7 @@ int main(int argc, char *argv[])
 	 */
 	gva = vm_vaddr_unused_gap(vm, NTEST_PAGES * PAGE_SIZE, KVM_UTIL_MIN_VADDR);
 	for (i = 0; i < NTEST_PAGES; i++) {
-		pte = vm_get_page_table_entry(vm, data->test_pages + i * PAGE_SIZE);
+		pte = vm_get_pte(vm, data->test_pages + i * PAGE_SIZE);
 		gpa = addr_hva2gpa(vm, pte);
 		virt_pg_map(vm, gva + PAGE_SIZE * i, gpa & PAGE_MASK);
 		data->test_pages_pte[i] = gva + (gpa & ~PAGE_MASK);
diff --git a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
index fabeeaddfb3a..0e8aec568010 100644
--- a/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86/smaller_maxphyaddr_emulation_test.c
@@ -47,7 +47,6 @@ int main(int argc, char *argv[])
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
-	uint64_t *pte;
 	uint64_t *hva;
 	uint64_t gpa;
 	int rc;
@@ -73,8 +72,7 @@ int main(int argc, char *argv[])
 	hva = addr_gpa2hva(vm, MEM_REGION_GPA);
 	memset(hva, 0, PAGE_SIZE);
 
-	pte = vm_get_page_table_entry(vm, MEM_REGION_GVA);
-	*pte |= BIT_ULL(MAXPHYADDR);
+	*vm_get_pte(vm, MEM_REGION_GVA) |= BIT_ULL(MAXPHYADDR);
 
 	vcpu_run(vcpu);
 
-- 
2.52.0.351.gbe84eed79e-goog

