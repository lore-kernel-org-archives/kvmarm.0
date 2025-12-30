Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1EB30F524
	for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 23:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135747; cv=none; b=V+4H/P7hmeOSDNNmUJEPOMsouyiuldLztouKh4TCEJcs0wVOLmozJQFbFCBCUHSCULD7EWBy6GoYud2gNeKYw3x/mRsrE4rYZg/9m+t7jHKs7Nou1gG/5pHwWZ+TduITHqQyaPozu8xnKoh21ON33b0/I+Q3QNFSrp5KRpsBFDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135747; c=relaxed/simple;
	bh=YGA8CA4s7Z2CWClwBVpAk8yl9E1CB5xxazIcYOSG0No=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YTVlsXup3sEmh73ti6ch2khlNIoroLMLqWOF9vvJsxIlEiYwguGkxf7R1bHOXmdfxfT3yGSduWXaKQgXoeOczi55kSBWsasUqeDaA4y5bO7RJlRrSnUQiuoMdmzfWJvVSqa530kpvG4zqKweBHBRG3LZVcDH08j2ZZ60TwDDR0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p/mKZRXf; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p/mKZRXf"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0c495fc7aso149037715ad.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Dec 2025 15:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135742; x=1767740542; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FMYWTnD6Tv1L5yY9MguuNjhNHloVV4vNjkLbvD2vfOU=;
        b=p/mKZRXf8ND2m1eGoOVjXf+CNTs8j7i8L15+5hWkUjEccbgvP9KTcCSscDucVlw83k
         I58FepsEHp3XW45BJ+Vlt3hAA5QmvufT7aq5DMcnlbUBbNP3jO1JzKC93SmDgzw4ACrw
         dappZirFMzfyRoR3T3EyQlPTtmrOtuEA8ZRXDJUrHo6d+MUVHl/G4HcEkv87ChbqptXF
         KG2DBYKW/AiiznNA+2fA84gx7ikedjm2Z4RAuDAbwLjLYlTKa6EgsAm++e8cn15dn+hm
         0AUsUSU4RG9hdLx6ILI/KVZyjFAjW1KX5If87E/VRaNcg+bfFElqZ2nwLfv8dUP/ffWu
         w88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135742; x=1767740542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FMYWTnD6Tv1L5yY9MguuNjhNHloVV4vNjkLbvD2vfOU=;
        b=PkUIxanDMV4SVsIglq1CQFqSG+gKtDsPVn8PkhoVKJeDu2m3CwR88v5h1RBVmfxXuM
         zWcjYZIDxLPz2DztpoXWmY7rNWvuQXkulLlxA+6oRBi7rCstTYlHVU42ZW/9TrF8y6G9
         mbOY9uw9g+z3ggNjgECaaeTuVetI0MIr+rtt0QUBku5Dpyo+BuDxAuI3BkChZ7EAjJjj
         zJxc0FaOg3X4LU6JTH2+zitUWNsiFuQmkinyCEudT+vED+qD9qHDVfWt5jf7Rzq5iHCN
         FK3WFVFOlOUYj2t3zDuYXqs/NvAruOahA81YUGnt/ShdDx0yLkR2rH/hzkBTDSEBZCea
         0Uug==
X-Forwarded-Encrypted: i=1; AJvYcCVy82Zfn9O5jI4gpkFghgaCeLk2ruWhTNeDZsGKjJmee7rb4xrhHyWi2HfEuku6ipn1tdRPofY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyNddn0BO3NhxLv6DtOgI4blcxSvUIkg45BAlDE/PYLgpHp4Dd9
	/GU9u5w6wya0lH8SLHC69w6PneG6qHoz+d/py/gohsD4Hzj/TiLTl/ozPtreYAmWN5xBS2jAwg8
	EmNDV3g==
X-Google-Smtp-Source: AGHT+IEPzwhGxGkpTdzvCyQe6ViV9J79G7ardG1q/yA1uYuatCDGiLbmMWR1E1eqCq7xQW2f9AolN3qf2J8=
X-Received: from plzv12.prod.google.com ([2002:a17:902:b7cc:b0:298:1f9e:c334])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e5c7:b0:2a0:be5d:d53d
 with SMTP id d9443c01a7336-2a2f2a361c2mr352279255ad.53.1767135742297; Tue, 30
 Dec 2025 15:02:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:46 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-18-seanjc@google.com>
Subject: [PATCH v4 17/21] KVM: selftests: Set the user bit on nested NPT PTEs
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

According to the APM, NPT walks are treated as user accesses. In
preparation for supporting NPT mappings, set the 'user' bit on NPTs by
adding a mask of bits to always be set on PTEs in kvm_mmu.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/kvm_util_arch.h | 2 ++
 tools/testing/selftests/kvm/include/x86/processor.h     | 1 +
 tools/testing/selftests/kvm/lib/x86/processor.c         | 5 +++--
 tools/testing/selftests/kvm/lib/x86/svm.c               | 3 +++
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 1cf84b8212c6..be35d26bb320 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -22,6 +22,8 @@ struct pte_masks {
 	uint64_t nx;
 	uint64_t c;
 	uint64_t s;
+
+	uint64_t always_set;
 };
 
 struct kvm_mmu_arch {
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index deb471fb9b51..7b7d962244d6 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1450,6 +1450,7 @@ enum pg_level {
 #define PTE_NX_MASK(mmu)		((mmu)->arch.pte_masks.nx)
 #define PTE_C_BIT_MASK(mmu)		((mmu)->arch.pte_masks.c)
 #define PTE_S_BIT_MASK(mmu)		((mmu)->arch.pte_masks.s)
+#define PTE_ALWAYS_SET_MASK(mmu)	((mmu)->arch.pte_masks.always_set)
 
 /*
  * For PTEs without a PRESENT bit (i.e. EPT entries), treat the PTE as present
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index a3a4c9a4cbcb..5a3385d48902 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -231,7 +231,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 
 	if (!is_present_pte(mmu, pte)) {
 		*pte = PTE_PRESENT_MASK(mmu) | PTE_READABLE_MASK(mmu) |
-		       PTE_WRITABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu);
+		       PTE_WRITABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu) |
+		       PTE_ALWAYS_SET_MASK(mmu);
 		if (current_level == target_level)
 			*pte |= PTE_HUGE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 		else
@@ -299,7 +300,7 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK(mmu) | PTE_READABLE_MASK(mmu) |
 	       PTE_WRITABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu) |
-	       (paddr & PHYSICAL_PAGE_MASK);
+	       PTE_ALWAYS_SET_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
 	 * Neither SEV nor TDX supports shared page tables, so only the final
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index 8e4795225595..18e9e9089643 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -72,6 +72,9 @@ void vm_enable_npt(struct kvm_vm *vm)
 	pte_masks = vm->mmu.arch.pte_masks;
 	pte_masks.c = 0;
 
+	/* NPT walks are treated as user accesses, so set the 'user' bit. */
+	pte_masks.always_set = pte_masks.user;
+
 	tdp_mmu_init(vm, vm->mmu.pgtable_levels, &pte_masks);
 }
 
-- 
2.52.0.351.gbe84eed79e-goog

