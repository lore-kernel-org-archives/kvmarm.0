Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD00D36A608
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 22:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692337; cv=none; b=SNgDIfnj1WMgE9yFnPhzfS9iFdouaBZyA9qp37mlmJZHZ+F0nJuqMUJEKtnXuB6L06DuK35AqOeBb6ksBpLKGTcSqUTmW9Ed9po84xA5+0fGeoIaIeikt1GDCrzuv7WV+jlZ1s3U1bzx0OTJe5wdHARmLGHcYixj7dL1Bv7r2PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692337; c=relaxed/simple;
	bh=9LfQM2hIUlxZZG/asJrlAoGIB42sfh2arlqfx9NqS1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=PnyNuuo/R+bCeEVYZkED02lezms7zjKrXZ6UFhWXewbbEq6QjOzhgDh7HnabP/3tPPofFMbzcDZtbeMxpHPEdMBSi8oF/jq46e3vvm9IOPhL7TILqPCEzoP3ne3BlR3jWq282ofLsP7ThQFRP96q2UVPyZEqyGgK+BChYPaQwcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OU0v7iVA; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OU0v7iVA"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-26983c4d708so49624715ad.3
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 15:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761692335; x=1762297135; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LsN+TIOejwkRxcFvSTLIziuR7qVC+NSwlbaa713vCGw=;
        b=OU0v7iVAaK0IoxpBo2Huu1lWyyG1fbq1HV1kzpzea2S1r5XL1//uDGuvoy5P5pWIB8
         fW3JDLqjgRW1RsHNLmHub9kZwV1t4HjCj3Dm6wVB9wqyOzGV9SFNBGunziiJMDBnAaDJ
         KyFahIc/gcGPRvk8JCweCxU5MPN5f196qTZKwA7cN9Yh8oed3q66e4bWilyOVdOcWnqt
         WsP7j3/AW7oZYUXTQoGyTUWEi4q8jNQyMMHgUFyh4uoUEhoRS4Yu35xevYvkAh+fKiuH
         l7VKrm5fsNh8H+bdWfMApqXheaYon4NTBHVtH4LTZP/8LIe5iNe9sAen0EBAcT2gBmNA
         aYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761692335; x=1762297135;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LsN+TIOejwkRxcFvSTLIziuR7qVC+NSwlbaa713vCGw=;
        b=xLpKWQoqi9Ggz98ns7HCle8wQD4UF4wguy9IzAwL54+7GuwzO4MRxSXK8W5JroA8Jg
         WS7eXzPXvOF7CJzUMoBWC7mFv9UCcTfVYXl8ZJnvotllnQNqsjzv+pCFYoFND8gXRcRh
         vIw/+9fYcrbEgqi3OSpd8XOMNDZaEwtIQCvS5U2CrQWTiLSQayj59Y3wE5iIYwTgN04h
         i5oztWANMELjMj6qKdJdUFqrQqvjG7QzbntnGwDiI3G8WQEatSRLt/uiu8UzNmUh32mk
         JHWWtgWBCdjBxh3Sen/qBMNOdHr2ymrhLWV1lhz+8Ogrkg3Ud372yRfnJZpq1/EnnuP6
         3eJg==
X-Forwarded-Encrypted: i=1; AJvYcCUnlJ93K/cxCXl0SlncIBimwzG0LU9+Dhu/j6E6RRr/HG1oZQpuxswhaKa6pmDQ+4A1bqezXOY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfRvvpBxAG1eo9ks4rPr9ls5IczWBwSitsVlFOic4tqnfK0ER9
	h7eJ6IlxNnDCwylfEzRJhA6aVZm4hJuoa0CwCCs+1JzJHgJhltETX15tQt6+Bl7q6McSvaiVsW2
	MhhU4MybtTfce1Q==
X-Google-Smtp-Source: AGHT+IEMVSuG9lR7nieExZvnnc5AQBFrpxM2bdWmWvBi3SSEzKa00dcCH/wBtXjIXiNue0RQB/h1x65fEm/mgQ==
X-Received: from pjvv11.prod.google.com ([2002:a17:90b:588b:b0:33e:3612:2208])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2a86:b0:290:dd1f:3d60 with SMTP id d9443c01a7336-294def5a88amr8429735ad.51.1761692335281;
 Tue, 28 Oct 2025 15:58:55 -0700 (PDT)
Date: Tue, 28 Oct 2025 15:30:40 -0700
In-Reply-To: <20251028225827.2269128-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251028225827.2269128-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028225827.2269128-3-jmattson@google.com>
Subject: [PATCH v2 2/4] KVM: selftests: Use a loop to walk guest page tables
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Bibo Mao <maobibo@loongson.cn>, Jim Mattson <jmattson@google.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Walk the guest page tables via a loop when searching for a PTE,
instead of using unique variables for each level of the page tables.

This simplifies the code and makes it easier to support 5-level paging
in the future.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 .../testing/selftests/kvm/lib/x86/processor.c | 23 ++++++++-----------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 738f2a44083f..720c678187b5 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -307,7 +307,8 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 				    int *level)
 {
-	uint64_t *pml4e, *pdpe, *pde;
+	uint64_t *pte = &vm->pgd;
+	int current_level;
 
 	TEST_ASSERT(!vm->arch.is_pt_protected,
 		    "Walking page tables of protected guests is impossible");
@@ -328,19 +329,15 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 	TEST_ASSERT(vaddr == (((int64_t)vaddr << 16) >> 16),
 		"Canonical check failed.  The virtual address is invalid.");
 
-	pml4e = virt_get_pte(vm, &vm->pgd, vaddr, PG_LEVEL_512G);
-	if (vm_is_target_pte(pml4e, level, PG_LEVEL_512G))
-		return pml4e;
-
-	pdpe = virt_get_pte(vm, pml4e, vaddr, PG_LEVEL_1G);
-	if (vm_is_target_pte(pdpe, level, PG_LEVEL_1G))
-		return pdpe;
-
-	pde = virt_get_pte(vm, pdpe, vaddr, PG_LEVEL_2M);
-	if (vm_is_target_pte(pde, level, PG_LEVEL_2M))
-		return pde;
+	for (current_level = vm->pgtable_levels;
+	     current_level > PG_LEVEL_4K;
+	     current_level--) {
+		pte = virt_get_pte(vm, pte, vaddr, current_level);
+		if (vm_is_target_pte(pte, level, current_level))
+			return pte;
+	}
 
-	return virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
+	return virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
 }
 
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
-- 
2.51.1.851.g4ebd6896fd-goog

