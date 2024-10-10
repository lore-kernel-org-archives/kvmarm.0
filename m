Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2950920822D
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584814; cv=none; b=Fjt6MAMyt+6SwE+Y+J9G5ARsRoUkYGC8EoGhDRzKLlKifHNAmrHejuVE3vxHOqb1RxwDnEXAUk5Fc3K+NSUP4WgJfFDpUa9jc1+6RV8acjixvSeueUh/cE4LXQUkrvPCoVBozqgCTRe6Djo5fReb4joVc5YpkFdwAq8f6wJoVyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584814; c=relaxed/simple;
	bh=XrFS4rtFa/FgrThsq3EMvRUnjE+/w+4Wbq1cV5vxoHg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pssAHLKH5Gvd/aex1xoaB9ao0Y4QTy3KX7Gzl+3Xi2QeH3lPuLzSSVa7wQF1HhD8l8wNq0oAHIhWo/wdpWPloJ9cgjx3XN85ZKe/Rour6g7wX9dQC5nseFJqKQOrsv8FkXuvJKhXe00cXkDCgD02w+BQpD1QecYz4bS60NLXdKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o5OiZa5e; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o5OiZa5e"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2c3338a9dso1524944a91.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584812; x=1729189612; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6S7ecEpHeP2pNYK74CcyfNjVxKIOVPI1u0giMU3AdU=;
        b=o5OiZa5eVWRGTA8uldB25lZmgFUeY/1HksW9ri0DtEXPlzE/64i8y8rEQKARQ5ZdBO
         KgZzViX4UnlsIO5oyYPEjH4K5OynddawyOWxEvPH7WxYfQnNKc7nWzULuhTizCse11vk
         VxYeGSloo4z1ehoET3Go8Um6N16TIq30iMTDRML/ztGLLA68/+zKnuX/zrSW/Jf8Qm9y
         8eFWBSmQkR5WUakyvfdNPatVPzfmmc55VKhFwiSz3ukl3BD05Ld0m6SxwdVI7YOPm6cD
         d1LMe1JnUsKDFBR0OX/pLVKzF4/YIWKWSZU2J6nR2M+5SBuKI5gCm+7CjL5HX4H5bGaO
         6NSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584812; x=1729189612;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=L6S7ecEpHeP2pNYK74CcyfNjVxKIOVPI1u0giMU3AdU=;
        b=GoStK89bTFlakV3U8aHIy7iZHRlYa/zvD63WG39bBksaqHeqPhB43n+lDPsE8lHLRj
         vuyz/SUllwFGdofVU37pECV0c2Gp6nH/kW2eaWlcwN1Zt9xM+zywvAV+EJLS4l+XjgW4
         fesj2ZNarMXMiSKFlvJj94eh/JhkHtlsUgphvR7BGKpXAOxnC+yylVklwHPsNwTaLg0X
         r8iG9LYUPCF9TCWctf8UoeU13DMkbkfrRe1Lj4ICRf1FapwUzZLE+zlGJWgO4FUq5i3+
         aRqoB3MygkKe74p+jwmFNuBlAvU9oRlJ5sjgUBEO2Cy+qfCNTd0S9fL1SJUSsxAOVh6c
         wE+g==
X-Forwarded-Encrypted: i=1; AJvYcCVYhY9M96Wrh9g0AbR60De5dZn0lOs6AqkdV3AI4KldfoT5vKj5jZ3PSWKHnK4R4z5AQKpO8fc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGrXafexMY9lH8ziAIKxlP4b4TqYQSeSrpSqL7pnu8AlRJwRyt
	srnhjP3XGoWpJvW5rj9kA0FxUEEjZ+ywz3yPyGaBKJyWEHZIN2X83Xds+NTImkqh8lazLMcS2ux
	itg==
X-Google-Smtp-Source: AGHT+IFNqFi+zU38KeaNCnXXdZA3xW66mqPsBP1LkkibZO//JxtU2HWKMaWXgt9tHH1pSDOFY+ZWY6Gk4GE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4f4b:b0:2d8:bf47:947c with SMTP id
 98e67ed59e1d1-2e2f0c456f8mr35a91.3.1728584812033; Thu, 10 Oct 2024 11:26:52
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:58 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-57-seanjc@google.com>
Subject: [PATCH v13 56/85] KVM: arm64: Use __kvm_faultin_pfn() to handle
 memory aborts
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
Content-Transfer-Encoding: quoted-printable

Convert arm64 to use __kvm_faultin_pfn()+kvm_release_faultin_page().
Three down, six to go.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ecc6c2b56c43..4054356c9712 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1439,6 +1439,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
+	struct page *page;
=20
 	if (fault_is_perm)
 		fault_granule =3D kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1560,7 +1561,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
=20
 	/*
 	 * Read mmu_invalidate_seq so that KVM can detect if the results of
-	 * vma_lookup() or __gfn_to_pfn_memslot() become stale prior to
+	 * vma_lookup() or __kvm_faultin_pfn() become stale prior to
 	 * acquiring kvm->mmu_lock.
 	 *
 	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
@@ -1569,8 +1570,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 	mmu_seq =3D vcpu->kvm->mmu_invalidate_seq;
 	mmap_read_unlock(current->mm);
=20
-	pfn =3D __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-				   write_fault, &writable);
+	pfn =3D __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
+				&writable, &page);
 	if (pfn =3D=3D KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
@@ -1583,7 +1584,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys=
_addr_t fault_ipa,
 		 * If the page was identified as device early by looking at
 		 * the VMA flags, vma_pagesize is already representing the
 		 * largest quantity we can map.  If instead it was mapped
-		 * via gfn_to_pfn_prot(), vma_pagesize is set to PAGE_SIZE
+		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
 		 * and must not be upgraded.
 		 *
 		 * In both cases, we don't let transparent_hugepage_adjust()
@@ -1692,11 +1693,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phy=
s_addr_t fault_ipa,
 	}
=20
 out_unlock:
-	if (writable && !ret)
-		kvm_release_pfn_dirty(pfn);
-	else
-		kvm_release_pfn_clean(pfn);
-
+	kvm_release_faultin_page(kvm, page, !!ret, writable);
 	read_unlock(&kvm->mmu_lock);
=20
 	/* Mark the page dirty only if the fault is handled successfully */
--=20
2.47.0.rc1.288.g06298d1525-goog

