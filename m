Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA961E4928
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584709; cv=none; b=CA3bnzEVF0ZprH0jn7WALdA8IzHxWjW3oTMXm2grcNBIWn6rUFENgDTooqigzcWk/Q0bCdBUXWFt4sACD6mmCNphxMl8h7EvI4cOxbRyhUJ4lvOjDAw8EXbDyUw3Vn2+WuoakRiveBTMtQpBI/WsSYPjI6OCByakJQzz0/b44Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584709; c=relaxed/simple;
	bh=zZ6qnR3p2Ej0Et0EkgjdDF1APVKDfMggaSwqeFMbAB0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s7gTXsV6tlu8MsBR1ho/V/tXfIAMVmQfFzV9/EJen1Pu/MkTFYCdmPkcMxTVVES+8o/F7LfjmQbEbCMF0/o0MkrB0KCjsBrI1pnfT0ls7TqrsZhyjWsXSO/MfZZdRIgwCn926s3JGPyS5fESklqkJgtelb/+riVfiDS4oTYhB4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=15SaAGk+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="15SaAGk+"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2ca403f5dso1037024a91.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584707; x=1729189507; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GZoCfd92gqYHwqsSYOai9KQfQ7K6dxh+JWKccmiJTPU=;
        b=15SaAGk+jGpD1rLPGWbaB/ms0kdDWyTNbthWVDV+VGlHzStd1KWVXRC+aKRzIzmfs7
         fU3qRtHouvMCnMuvhiVWWTsesUmtx1igekSAal84slR8gcxNqrccKInNy3R0tlwDfc8Q
         OJub5L4BIPanoev7Pe6KQFNr5aIY3nYR4JFzVlQygHDSHoRbg7It1GcI3C0m8wsjCvew
         YW2A13lZAC+CtWxpfsggKjZoDxocEjMvfoNnwVdLa9e8E/CDw/krWlRl8O8eNGSFa8Vy
         8e0tkxiT5cd8F9BLxk+wf5pqvj7Yjx1XN+LM9iu9J5wxyAggLjFl7nCNRwDl3eRitx0Z
         SJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584707; x=1729189507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GZoCfd92gqYHwqsSYOai9KQfQ7K6dxh+JWKccmiJTPU=;
        b=lx6o7qXQsQr5777YhoG43hsx0dCbal1XvaRf7Tj7n/arJiWNAIB5RUbwCZAtz8u9iz
         y4EQ0C2rsKsIkF+urpQFAqnS1PZeexeBqdBqHmJ/Jt3vjZwdmMydLhgr8oVAbgA3EDre
         xL7pkHbo8iiSSJqyRmUx3KI0vLCwO1xThTMFullrIxUiN0emogz3/siaq8pj0oQPIRfs
         8WkiKuU7U8flIaenACz8GvQpnXoxRVgCzDB2FvjJ4ZAE/rBsvhW8FtOub7rL3kL4YPoF
         jvdQBe4DPZSk41JYP8c9voF21A5tnCeYtzes53RiGjjgpv+9omiAir4QWu72GViIXiV2
         akEw==
X-Forwarded-Encrypted: i=1; AJvYcCWi/ZTkbbsLSD1ESCG9htsn4sOLix5FtOl+qb19EzpLfgTLjPjShX5YAi38rExJMcAtCeHnF0Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFzlzRf2ZmcomrUKO2RbPwPxRypTQk5XYcYEcwHmR63wHLYXfp
	ZRgp2/GaOWwopPnEiF1EGPRnucqPmVlEzxThxR975uVZdgtoWz/kmnz9yBXpzoO3ung+GzUKCle
	cdQ==
X-Google-Smtp-Source: AGHT+IH8UDk7ruln14ZDsSWqbj1uDcx7028dIle1wpc1As3ec3XNWN4cizl8I1jAsp9rsgJdiTjtCNc1iNw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fa84:b0:2e2:da81:40c6 with SMTP id
 98e67ed59e1d1-2e2f0a524d4mr44a91.2.1728584705592; Thu, 10 Oct 2024 11:25:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:09 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-8-seanjc@google.com>
Subject: [PATCH v13 07/85] KVM: x86/mmu: Mark new SPTE as Accessed when
 synchronizing existing SPTE
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

Set the Accessed bit when making a "new" SPTE during SPTE synchronization,
as _clearing_ the Accessed bit is counter-productive, and even if the
Accessed bit wasn't set in the old SPTE, odds are very good the guest will
access the page in the near future, as the most common case where KVM
synchronizes a shadow-present SPTE is when the guest is making the gPTE
read-only for Copy-on-Write (CoW).

Preserving the Accessed bit will allow dropping the logic that propagates
the Accessed bit to the underlying struct page when overwriting an existing
SPTE, without undue risk of regressing page aging.

Note, KVM's current behavior is very deliberate, as SPTE synchronization
was the only "speculative" access type as of commit 947da5383069 ("KVM:
MMU: Set the accessed bit on non-speculative shadow ptes").

But, much has changed since 2008, and more changes are on the horizon.
Spurious clearing of the Accessed (and Dirty) was mitigated by commit
e6722d9211b2 ("KVM: x86/mmu: Reduce the update to the spte in
FNAME(sync_spte)"), which changed FNAME(sync_spte) to only overwrite SPTEs
if the protections are actually changing.  I.e. KVM is already preserving
Accessed information for SPTEs that aren't dropping protections.

And with the aforementioned future change to NOT mark the page/folio as
accessed, KVM's SPTEs will become the "source of truth" so to speak, in
which case clearing the Accessed bit outside of page aging becomes very
undesirable.

Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 0e47fea1a2d9..618059b30b8b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -178,7 +178,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= SPTE_TDP_AD_WRPROT_ONLY;
 
 	spte |= shadow_present_mask;
-	if (!prefetch)
+	if (!prefetch || synchronizing)
 		spte |= spte_shadow_accessed_mask(spte);
 
 	/*
@@ -259,7 +259,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= spte_shadow_dirty_mask(spte);
 
 out:
-	if (prefetch)
+	if (prefetch && !synchronizing)
 		spte = mark_spte_for_access_track(spte);
 
 	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
-- 
2.47.0.rc1.288.g06298d1525-goog

