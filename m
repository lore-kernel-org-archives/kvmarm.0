Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DA320A5D4
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584826; cv=none; b=qXblQ1ncxw9K8it2ChZMOgFUn7mLE9ICVcSZcUQ/3Iyi4+rif1kqeLlLrug8aL9wOkTWHvXXUf+aoZMeMAebWzcTvZGVeHgJK/wmVo9uqKU4PYHX791NRyEmFti2SqwWOFsk/eS6zX8SVCw6Vu2Awj3XTbCXVz0bmoauSIFm8gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584826; c=relaxed/simple;
	bh=lnamoAhiaB2k3D/cv0luJANVeCRwGvcQfaabdaB/y4g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F78eOT8ujnaCgQzpftYkHkvWlBgzA0Wn3AbiM5C84oRiy5QcI1X8brapsvCavxMuUR4xYdxW/34mmk+CeIa6m3wrX8l0kVhDOUbjxNmdg8pj7zzt8/ueR0K/SEFDkl3naE5mm33zN1wN9Nar5uRwAnkeFDkuCHp6RrBr1Bhg5X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZLEkcwHN; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLEkcwHN"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e1ed58e9bso1479111b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584824; x=1729189624; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8JV5lSZeo1By1ou6uwDGqoH8kmaYenoeIxSHz9El/d0=;
        b=ZLEkcwHNylyS9nigmfhMgxkL5gWlczp21gA2l0n24BeuoP7nHS+SCim6OtGdIEPV6b
         6h2rTW3A5pa29cj4QpBjznrQDEeVexMjmRZUP3DPk3Y1Xt4m5nJpZUjLBLHG+uC5Ur4/
         nA3dWVmixu9bJxzd0A2odgbUM65IEKwVZGQIDGE4YRV8lXImT81Pj9Q1NA16Kox/cJ+8
         IPY+i8N/l9MhsAZ04RxjYb4Y6ArCEzQnRQrYp+d4GkpCjxa6qUSFBfTGy7m4qlCwtAW0
         CG/6MAsDMsXPYKwzOe6WW3ZazeGLb/zGOs7hW9PN5r+Aa68mDHOTTYDWYgLomX0QTi/B
         uvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584824; x=1729189624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8JV5lSZeo1By1ou6uwDGqoH8kmaYenoeIxSHz9El/d0=;
        b=L4frJK5897Y1KZRHyU+ttOXbxJIvR7RwrpHgZPydwazqBGIl3ppEX/cv3hSbLJ4VB9
         HeB9SCFGCHZrick+2Xcb/4NAF7BpB5zgLjNbWVEkLSEqH577hs5NfBlBEH/qRnKMwxu9
         5j+Zl6nq1UJpMhAWx2Bfcvks3zCQuv7k+pjtbPmdSJqznFzgERatkPe5mZ8CgfuoEqn+
         lMXZoKunw5dgVYUhkB9n0C9KmQc9XzL25ljBa5bPY80eYibyA0ysZlfSxIntWydigN/z
         fb6HYLx6/J5uS31/44GO6yavxF1Ur3pDBDoa9G8/YLuq/ne/pTAIKZU2pq6jN4gTU0J8
         mjew==
X-Forwarded-Encrypted: i=1; AJvYcCVfSP5K2b97+PzezCG0QB/2XIhIbcUUU9g05xZBU+OlJ9VG+NNmls+VW+72lwfLwIpvcdeJcXI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPOIwtqC2SKTgPBBVy1hMKf2ZFvs+gNsyjN1FScTDmWc1ZSfsL
	TsLDCdBb97S8Fh0/xpU1e/DaZiCWyD93vJYUMu9492iK4x2yp9swxurrbMECd8Xs62HCFfGajSU
	6Xg==
X-Google-Smtp-Source: AGHT+IFev0i08WnhWXOHYVCiDa8hDSrBgilu3q+XI+BXP7ns5qqyHbYBrSKz+aJVjoCmfpAuiTEXvCWN4KQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2daa:b0:71e:401:6580 with SMTP id
 d2e1a72fcca58-71e1dbf2587mr27202b3a.6.1728584823552; Thu, 10 Oct 2024
 11:27:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:04 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-63-seanjc@google.com>
Subject: [PATCH v13 62/85] KVM: PPC: Drop unused @kvm_ro param from kvmppc_book3s_instantiate_page()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Drop @kvm_ro from kvmppc_book3s_instantiate_page() as it is now only
written, and never read.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_book3s.h  | 2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 6 ++----
 arch/powerpc/kvm/book3s_hv_nested.c    | 4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 10618622d7ef..3d289dbe3982 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -203,7 +203,7 @@ extern bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested,
 extern int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 				unsigned long gpa,
 				struct kvm_memory_slot *memslot,
-				bool writing, bool kvm_ro,
+				bool writing,
 				pte_t *inserted_pte, unsigned int *levelp);
 extern int kvmppc_init_vm_radix(struct kvm *kvm);
 extern void kvmppc_free_radix(struct kvm *kvm);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 14891d0a3b73..b3e6e73d6a08 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -821,7 +821,7 @@ bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested, bool writing,
 int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 				   unsigned long gpa,
 				   struct kvm_memory_slot *memslot,
-				   bool writing, bool kvm_ro,
+				   bool writing,
 				   pte_t *inserted_pte, unsigned int *levelp)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -931,7 +931,6 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 	struct kvm_memory_slot *memslot;
 	long ret;
 	bool writing = !!(dsisr & DSISR_ISSTORE);
-	bool kvm_ro = false;
 
 	/* Check for unusual errors */
 	if (dsisr & DSISR_UNSUPP_MMU) {
@@ -984,7 +983,6 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
-		kvm_ro = true;
 	}
 
 	/* Failed to set the reference/change bits */
@@ -1002,7 +1000,7 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 
 	/* Try to insert a pte */
 	ret = kvmppc_book3s_instantiate_page(vcpu, gpa, memslot, writing,
-					     kvm_ro, NULL, NULL);
+					     NULL, NULL);
 
 	if (ret == 0 || ret == -EAGAIN)
 		ret = RESUME_GUEST;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 05f5220960c6..771173509617 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1527,7 +1527,6 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	unsigned long n_gpa, gpa, gfn, perm = 0UL;
 	unsigned int shift, l1_shift, level;
 	bool writing = !!(dsisr & DSISR_ISSTORE);
-	bool kvm_ro = false;
 	long int ret;
 
 	if (!gp->l1_gr_to_hr) {
@@ -1607,7 +1606,6 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
-		kvm_ro = true;
 	}
 
 	/* 2. Find the host pte for this L1 guest real address */
@@ -1629,7 +1627,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	if (!pte_present(pte) || (writing && !(pte_val(pte) & _PAGE_WRITE))) {
 		/* No suitable pte found -> try to insert a mapping */
 		ret = kvmppc_book3s_instantiate_page(vcpu, gpa, memslot,
-					writing, kvm_ro, &pte, &level);
+					writing, &pte, &level);
 		if (ret == -EAGAIN)
 			return RESUME_GUEST;
 		else if (ret)
-- 
2.47.0.rc1.288.g06298d1525-goog

