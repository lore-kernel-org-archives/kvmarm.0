Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540E636A5F0
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 22:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692337; cv=none; b=Q7DnXgN1Pl6sz3m8UTJrqxT06ADasRCjnmz1SIT2PZIoph+pTbJsioApY4y6kgTwlY6xnwjCdEkVmea60jXqPXRDA7ET+m9w4nOqm+Ru0WyOJDwr3osdanJ2UtYP45LlRSgX/pGEOuTWbLVM42gaFU+F/ejGFNT3+0CHcZbu3oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692337; c=relaxed/simple;
	bh=JS15vNThAeh2jui9xeWUCKiqlGy+OUZg2+5NBKAugBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=a39uMK4Z121ERwZmqQqCeNoWaXUMDkQhYwzIVpvFbRdi3yc9uR8Lcb1p+IZaWHu9oeF8Ph5LRHnPlHzK4jXx3fd+gcmBCJyHJFCf3tHGgFdcvfuVqS6T/ASu9VDUQSeFwgd0QATjjfbMiIj7O0WQhwrArxnOwptRd8NpqEtCsYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dTi4/ndb; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dTi4/ndb"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33428befc08so15040523a91.2
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 15:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761692334; x=1762297134; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B288Y6TAy0Oj1t/N3Z1wYBH55x8/0e/DLaA7QkeLdXk=;
        b=dTi4/ndbIiuQlYmSA88yFKusQYs5gHia1IaMcdaNerMg4MQRoOYWvbXsQZZVX8gcAk
         KooG6UaVV2qADtxfsXaUdv4hEcbo6fOvElpvklbUBNc6HH7I2laaw0+wsNbTZbIfW6oT
         KNQ7eQp1eJa0Rao2JXR7sCJdK5Y30gjLsSwFze88nhOo6ft1l8pl65jMm6RZEPKoOclj
         oVZLCNnzVhCP3gozajSbmokF1abEnEJI36RGQlPPKgpmNNr6pUg5ePs1H7oPXJZZ62YI
         TCvMV2HZPb+nGG1TMyHAajWGtWmDej75Av4rzLp80mSIlPzeWb4IO0iM1/ZALFNPc8nW
         V4PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761692334; x=1762297134;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B288Y6TAy0Oj1t/N3Z1wYBH55x8/0e/DLaA7QkeLdXk=;
        b=vGNbcz8XNyUpJUyeKnM0EinAVGsMQ7mEu8CfOX9cuDVYfxbjEP+nRN/0BCFOfHPW+9
         RVJkB3Okk3c57ia6ByuyNViFzrk7R/kTa4jwy9f38DkDAv30SWkg4nuORcJFRXTBJ3Xv
         kzAY4WhWBkk3SEOaRt9ZqjBx5DWfCXP4qkV9BdO7LnwwItU2zL/IeSV7xWf3TudyuB0Y
         WOyaPqUBKECafPiLMtKEOeDQ+Gu2EJJIMiJsbdccp7vui9FLDOfer9p06is6KgiKLi70
         YZQ7omlgtHH5gmcHtM88FIoX+hAVl+vnqPsFrjt5R+L41zfswvNbQjnXqfg6M310peA4
         dOsA==
X-Forwarded-Encrypted: i=1; AJvYcCVExLbVhdL9DxzccrqQatqbwanVG9OMOlJg19XUr5Xl91DQWJZSqdHrncj64ewmj5lfNMItlo4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFUX+UlCDOkZPEb/kIqZRTwRhDm4Z/lkJVIUCiPFFL0Q7lmAPT
	fr2142PkI+DPlOuH4JgQqtAtgwsZ6EZ6Hpg95TchXWI1bB1BOI4mfys5qWOREPxhx1bZjbLp1aJ
	d2I08Fzjcwozvyg==
X-Google-Smtp-Source: AGHT+IHUBNt+yVkmaDzMVABj692uUI0JHObl1P4P9tqPjQ42MTaBcOUyDM9YJNfeKyaxLDAtJvc+QR92G8cTPA==
X-Received: from pjso22.prod.google.com ([2002:a17:90a:c096:b0:33b:b387:9850])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:586c:b0:330:a454:c31a with SMTP id 98e67ed59e1d1-3403a2f2d62mr821811a91.32.1761692333727;
 Tue, 28 Oct 2025 15:58:53 -0700 (PDT)
Date: Tue, 28 Oct 2025 15:30:39 -0700
In-Reply-To: <20251028225827.2269128-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251028225827.2269128-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028225827.2269128-2-jmattson@google.com>
Subject: [PATCH v2 1/4] KVM: selftests: Use a loop to create guest page tables
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

Walk the guest page tables via a loop when creating new mappings,
instead of using unique variables for each level of the page tables.

This simplifies the code and makes it easier to support 5-level paging
in the future.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 .../testing/selftests/kvm/lib/x86/processor.c | 25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index b418502c5ecc..738f2a44083f 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -218,8 +218,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pml4e, *pdpe, *pde;
-	uint64_t *pte;
+	uint64_t *pte = &vm->pgd;
+	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
 		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -243,20 +243,17 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	pml4e = virt_create_upper_pte(vm, &vm->pgd, vaddr, paddr, PG_LEVEL_512G, level);
-	if (*pml4e & PTE_LARGE_MASK)
-		return;
-
-	pdpe = virt_create_upper_pte(vm, pml4e, vaddr, paddr, PG_LEVEL_1G, level);
-	if (*pdpe & PTE_LARGE_MASK)
-		return;
-
-	pde = virt_create_upper_pte(vm, pdpe, vaddr, paddr, PG_LEVEL_2M, level);
-	if (*pde & PTE_LARGE_MASK)
-		return;
+	for (current_level = vm->pgtable_levels;
+	     current_level > PG_LEVEL_4K;
+	     current_level--) {
+		pte = virt_create_upper_pte(vm, pte, vaddr, paddr,
+					    current_level, level);
+		if (*pte & PTE_LARGE_MASK)
+			return;
+	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
+	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
-- 
2.51.1.851.g4ebd6896fd-goog

