Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3171D20CCF2
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584837; cv=none; b=TW6VlgPwv2hlJa6ElO/I8n0D9JZD3v4A5dWBoYL64f0eAHQM47OXYxhfsXHUcZgzbbPHJu0ShGyiP+5GaV12M+rRFJXIpvHxAj6ea8p0JwTYYiZpSqPmJ8runCiaSHJhDD7z3H+mWbZeQe4nbswMAlgcNRMdCLrhyLbSOJBrNMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584837; c=relaxed/simple;
	bh=HhUA1PeKZEb/51LjtENBtdXbtQZ0o3j1vGZCLDD8mMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=snPkYl0m5hrEi84c19blsgBdSI+Bkxckij27J0+ylbUNmF7FiMaR9QCgLIMCu1DO0Cy8OdgtlCEuH2qclNAXy5Z6veOZAUgfM1Bg4B2ddPyxAcBuK8ZCM11jMhUTTtLdCYkiBYGLPmv+Kl3xr6cqiCsXaKKaiGhQp68K1bG2v7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oGPCLHqe; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oGPCLHqe"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e123d3d22so1429548b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584835; x=1729189635; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9LTMkDJZxM2S5Qh4t0DfHllWvhtFq1rJ9EqXHTYHy/A=;
        b=oGPCLHqeGqtT7xHuWCWbqlZqljH6hlnQ5wKarUPVpFI+EdRFiYFSvZ2xWoSDfoiOeJ
         X7HAM8W9HvVa9CdeszEUCjnlsYfKoc7gn1gtrd4+DeSwqCITEqLsaRUAM8owriANH09I
         aoM4YlpaefIhPNh3rj87D/+iSa8YvsSqFOK4GlCHsSzIn+ddPT78BbiCDejrpib1hZD3
         R853VW362dOQR4vLUPwuVU1VnjZSfxNHyD2g5cledSutLDItExvp1zIIq9DTkrxSqBXW
         DWZLKULXgN4tmSnBrGKgaydNEY9rrvSrditDBNItkziy34l5yeustqzo7kx5b2SfAPQt
         D3pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584835; x=1729189635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9LTMkDJZxM2S5Qh4t0DfHllWvhtFq1rJ9EqXHTYHy/A=;
        b=t6lalC2YUnoyVhoBzJgNDqlpNexBoHAQxOdVUjSbNzLrrGmh3heScNxA8D2s3M98Oq
         2uuZOKVjJgB4z2RuRXdnPCxKEbBfXbaTgNHE3C/fln6/T6Th6Ne8htphmTgqWBCuF4Yh
         U+ZxZWRRD5THt7aUSL/kguWjHlGca1XoBTLwObL0TqVWRm4HCedK+h/4rk+esiOSQD8W
         IO/pCAcnvqEp27OdARmJ5FeAen3fg3Ec0oGkLuH+HSE6PwrB2kq4F1QtW/bU3jjIcmlc
         yVhfjQWhKhtXwNIOprs08DPX420SRq0jJqbsHdxDfJ0vyFBj6rcXqtnhLwMmlt4KZyU8
         lwHg==
X-Forwarded-Encrypted: i=1; AJvYcCWua4YROHLYK2BO/+8G4dyuRJXWV3urP5tadAEt8xvtKjWAzwddvGUobjjYqIkaDQoZsFszUNg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYNmLWPH1vwYc3JlZmpOUitr/D1esAxAtzqdpaEPBY52+U1CBN
	pnLLxEX66IAqvdFUqyfzSCz7jCv3Pk6DkG44fa+natfllcpXYzNZm5Th3I7nHtZ1WyMcdGdNGGA
	CBA==
X-Google-Smtp-Source: AGHT+IExt7obORK9hFSNzpsBdJKygVAVx/dPvrUuCl2bsyTFt9B1GPfq0Q1aHG/lNRl/yht5gsZcWFEXy1g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8614:b0:70d:fba:c51c with SMTP id
 d2e1a72fcca58-71e1dbd032amr6898b3a.3.1728584835380; Thu, 10 Oct 2024 11:27:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:10 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-69-seanjc@google.com>
Subject: [PATCH v13 68/85] KVM: LoongArch: Use kvm_faultin_pfn() to map pfns
 into the guest
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

Convert LoongArch to kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 7066cafcce64..4d203294767c 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -780,6 +780,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_memory_slot *memslot;
 	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
+	struct page *page;
 
 	/* Try the fast path to handle old / clean pages */
 	srcu_idx = srcu_read_lock(&kvm->srcu);
@@ -807,7 +808,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	mmu_seq = kvm->mmu_invalidate_seq;
 	/*
 	 * Ensure the read of mmu_invalidate_seq isn't reordered with PTE reads in
-	 * gfn_to_pfn_prot() (which calls get_user_pages()), so that we don't
+	 * kvm_faultin_pfn() (which calls get_user_pages()), so that we don't
 	 * risk the page we get a reference to getting unmapped before we have a
 	 * chance to grab the mmu_lock without mmu_invalidate_retry() noticing.
 	 *
@@ -819,7 +820,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	smp_rmb();
 
 	/* Slow path - ask KVM core whether we can access this GPA */
-	pfn = gfn_to_pfn_prot(kvm, gfn, write, &writeable);
+	pfn = kvm_faultin_pfn(vcpu, gfn, write, &writeable, &page);
 	if (is_error_noslot_pfn(pfn)) {
 		err = -EFAULT;
 		goto out;
@@ -831,10 +832,10 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 		/*
 		 * This can happen when mappings are changed asynchronously, but
 		 * also synchronously if a COW is triggered by
-		 * gfn_to_pfn_prot().
+		 * kvm_faultin_pfn().
 		 */
 		spin_unlock(&kvm->mmu_lock);
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_unused(page);
 		if (retry_no > 100) {
 			retry_no = 0;
 			schedule();
@@ -900,10 +901,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 		++kvm->stat.pages;
 	kvm_set_pte(ptep, new_pte);
 
-	if (writeable)
-		kvm_set_pfn_dirty(pfn);
-	kvm_release_pfn_clean(pfn);
-
+	kvm_release_faultin_page(kvm, page, false, writeable);
 	spin_unlock(&kvm->mmu_lock);
 
 	if (prot_bits & _PAGE_DIRTY)
-- 
2.47.0.rc1.288.g06298d1525-goog

