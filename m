Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF57315696E
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037973; cv=none; b=dB57KJofgCIvisPAS2iY2Taxl3z1GfdrmeXahFDnlbxkizxpbIuKkJ2ZDHsh6r07WyEmZ8puGyBQTu3fXUEIQcaFppnutx24h9PqTkV8ohahATwrBbtgeb/uHThWb3nD6aRQJvOXkXn7gi2qzqWVY91nTeH/OwOK/d79BTr1qfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037973; c=relaxed/simple;
	bh=W8/UyfsPYwl/cL0QQCHocRUppr1lNXJ7XLufW7qP3ig=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FIwyYyIfoAIAeWo90AlgPyFxm3+xHCf5zwjs5TYUePJYebHWI71rCmfZJR2OuUCgoC8zhwm25jWCoRvcuoYRtZXnf3kaFHBl5qzAj7UCZ6X2J+olhTovUVv1GfgVBqZCtTRGpbNe1YyLDlWTwRM4tHXE5LLYCl/Iop85g8nNKtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OA9ymFs4; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OA9ymFs4"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-66b8faa2a4aso7040117b3.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037970; x=1722642770; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VnEAHRC1zG591I39OowzIjQNXTqQsRDXyh/rUn6sicQ=;
        b=OA9ymFs4VHSMkpIO+Pda4if1XszHz/Aq1/pWPZPaK1fq+36j6HLKzE1qjCCm5qcDwp
         1al5V9EMEw7xUpGBQXakvJLM7K6SpbqKSWIlUPMxF35wjnd24dmgbqkc2jWL5yrULB7t
         DCW2eimqGpLZXvFnURDCY+WhAhcdYm0qJ6bjPjnF4DhehvfuSnrcAU9w6G835pCg5clw
         xkUnkwnIboSprKAn3WxB7DsBrOFs5pzH/2gKjPqeZo69CZBg2MTpM+Z/+WW7nnBH3tZN
         AmDvbDYCXZgD0gOdO1vfDAIdIJHY06u/3JMOMfzambPW/Oz/F4j7tDQjvJ9tKMiipkJ+
         QxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037970; x=1722642770;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VnEAHRC1zG591I39OowzIjQNXTqQsRDXyh/rUn6sicQ=;
        b=LUCNcQ6SxbYJN5vHrRwC8tz9WyC8IJ0/jv+j8bQVufMeQnf2Udms8++fmvl4Usx3KD
         DoqbFqo610c3I20V/T2vBecha8RQRWqldAtKPS2Y2Q2PXCaoSw5N/MPzsm7G8lK1MUel
         fAqk240FtivntZGIe/wg2fj9Ws/7xE7YMY99SrNw56tZfNL4KCanx59C8IR7aSRY6tKj
         VJ45Qe7RYy5Z1v9SSNmVflXiM1S6e5nr1Ts0uFS2wCf9+99AB4DQe2/mUFf339oYL++o
         QFRVBsI12PjmsRJ3AEptrDgNMG08GDFCY8ZEmEl6vnI8qqM8pZIHt4y959IVnUu2Eu+w
         8s5w==
X-Forwarded-Encrypted: i=1; AJvYcCWPXbGfz8xF5F45+GKfce9ZelVG9TAPZYB832KBdBcU/oQj48IP9LFM4xIxkAplLlmJ0cxNwJM9HRBM8zZ2e6Gathj5g+Aj
X-Gm-Message-State: AOJu0Yx8RTLoWBbWVawwNmpX1iAFr2W+JomgrRTH7NStXXTSs1OxuCCQ
	22xFMygI0jkKQeeZ2CMkdGPLw/MhoKRE4NNpfATYVtCtihYiGWoEuUYVyLXQ+FshhwZfVlAeVY8
	PEQ==
X-Google-Smtp-Source: AGHT+IFPOoUYsYyJmRjA25F0UYC9yeYKs61mDA/QqS/vgTcAgpqjjzQfUfGqPl0MU2c7vZElDBuLLOtKUts=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fc9:b0:648:afcb:a7ce with SMTP id
 00721157ae682-67a05a9d90bmr269367b3.3.1722037969718; Fri, 26 Jul 2024
 16:52:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:15 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-7-seanjc@google.com>
Subject: [PATCH v12 06/84] KVM: x86/mmu: Skip the "try unsync" path iff the
 old SPTE was a leaf SPTE
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
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Apply make_spte()'s optimization to skip trying to unsync shadow pages if
and only if the old SPTE was a leaf SPTE, as non-leaf SPTEs in direct MMUs
are always writable, i.e. could trigger a false positive and incorrectly
lead to KVM creating a SPTE without write-protecting or marking shadow
pages unsync.

This bug only affects the TDP MMU, as the shadow MMU only overwrites a
shadow-present SPTE when synchronizing SPTEs (and only 4KiB SPTEs can be
unsync).  Specifically, mmu_set_spte() drops any non-leaf SPTEs *before*
calling make_spte(), whereas the TDP MMU can do a direct replacement of a
page table with the leaf SPTE.

Opportunistically update the comment to explain why skipping the unsync
stuff is safe, as opposed to simply saying "it's someone else's problem".

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d4527965e48c..a3baf0cadbee 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -226,12 +226,20 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= PT_WRITABLE_MASK | shadow_mmu_writable_mask;
 
 		/*
-		 * Optimization: for pte sync, if spte was writable the hash
-		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
-		 * Same reasoning can be applied to dirty page accounting.
+		 * When overwriting an existing leaf SPTE, and the old SPTE was
+		 * writable, skip trying to unsync shadow pages as any relevant
+		 * shadow pages must already be unsync, i.e. the hash lookup is
+		 * unnecessary (and expensive).
+		 *
+		 * The same reasoning applies to dirty page/folio accounting;
+		 * KVM will mark the folio dirty using the old SPTE, thus
+		 * there's no need to immediately mark the new SPTE as dirty.
+		 *
+		 * Note, both cases rely on KVM not changing PFNs without first
+		 * zapping the old SPTE, which is guaranteed by both the shadow
+		 * MMU and the TDP MMU.
 		 */
-		if (is_writable_pte(old_spte))
+		if (is_last_spte(old_spte, level) && is_writable_pte(old_spte))
 			goto out;
 
 		/*
-- 
2.46.0.rc1.232.g9752f9e123-goog

