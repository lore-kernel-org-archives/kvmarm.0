Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C28718C355
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038096; cv=none; b=OEL9ozCLs8qivktJiYoDbIOs+hKu71vGMUn+8MZPRzWKRt2xrpJ49qi6ZOTca38brB6H4U8u6bQJIXNhbaTRV9isDNOw3G1Zbn0VrFrygFKdGxd48UK6TQg5mZ1Cmtb3CGqRusiE2ExSOzzvrm6N8tVIO/adlB7fudyluTkB7iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038096; c=relaxed/simple;
	bh=p4k5vgBtys8Iq9l8Spp/J/Js17wYLPMbdqXjO7cF1ww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fWy5cg2BJ7/mE/nC+yiS2N6o7h9VVELbhJsfInkXCa/mk/51PFiY1w+6+GbrhIQULyoZbMgC5ns+IMbQIqAhSCe/U1qQjnrIILYm7X4+BhccIHnBmYu+70DNt9UCMMj4nhYqtsKTgcmHtcUUS/AdI/ysfZ4pcIJJ7A1qxNFTWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=36mxGVfy; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="36mxGVfy"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-654d96c2bb5so6822287b3.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038094; x=1722642894; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=r/0kdPmZ+ClWir3sWShoQK9y6l+vrSl7wHPcCrpa8dU=;
        b=36mxGVfy0sV1u2HR9cgzzixn3CBstbS7WuL2eJ+XP6QCW1UW1i2afPqysLgDJ9u9Ls
         ihZ/iRxTndLN5Hg+cmpqUR6Ya/04w6BIQY59MDSbBXo2TckkuBsbpHfs4jbDmG0nRn2p
         EaB2Z6dLJ8hFb3LmwnTEXKU2t20XYIaxEAOZx0392rxno1NLNkL1pf/6U1fkDC5wIft5
         2IHT36ii7JhaHTaYencHGyGvW+kmxDJ2GxgikRA1tsRYj7gfmdbf9VpwbCr+Dwh3A70b
         ufpRV/ZH6l9bVaYICr7u66G2DKXuedtFDCeQDJxATJefIZv8IZaRozCNfdZr9xLQDZHq
         tEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038094; x=1722642894;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r/0kdPmZ+ClWir3sWShoQK9y6l+vrSl7wHPcCrpa8dU=;
        b=X77uf3zYfe6jGv7tcKqmiZu105jhkdkuBNIU1uc3o7jkwiCbgcXWaXdEQgIvGu+O5q
         /fWAg5HLS9Xaw3ggH9zem/vFKDT9KMQtrBZkWBUkLPgUPlm1gXfkRPSmjYf/TeIHG+yM
         TbIEEBfuVV+PtKJVVsBh8VwoH2q9NOvbcwkAbNblpv7NL5I517NqT3qwzv/TJiTYH3Dx
         pgI4uueueGwUdboh8Ko39WwwxPvGtFZVCzgvAv+b6tQa+1/eGJFlW0qXTehKiGGd9ra/
         wsOSKRhtwQjE1XaWWL0lrjWyFdQ6IC4D7q++MVDGmkbw2oMAIzb9Fl6YpepNHX/2KTB3
         ge6g==
X-Forwarded-Encrypted: i=1; AJvYcCVUB8FI7lbo6A7lWLK0qxp8svZGvT4VytV+DxYbwj8GuVmNt2trkd/TXxebxIIIak6oRufyi+PCcpvTdcqef+nRD+S8FBdq
X-Gm-Message-State: AOJu0YypSI4iw3hYvD/YGmmT09F4RkplBjpi0ysWCVdwl1uAHByuIHKm
	jCLIVoBXzupigHicW3FokA7GY1jBSmtlUshKSetSY4NZp7LnCP2nAP83FkjXuTEfg/o1m96i/TT
	lag==
X-Google-Smtp-Source: AGHT+IFfaCc2nH86ghdgf4dpmC6KBZ4LBEB5Lf4TmkgG+fOYVVXJfjBbiJJRrvW3lQJXVsfLzyeGSOH6WxY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:830:b0:61b:e103:804d with SMTP id
 00721157ae682-67a004a2a4amr37847b3.0.1722038094439; Fri, 26 Jul 2024 16:54:54
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:15 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-67-seanjc@google.com>
Subject: [PATCH v12 66/84] KVM: LoongArch: Mark "struct page" pfn accessed
 before dropping mmu_lock
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

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that LoongArch can convert to kvm_release_faultin_page() without
tripping its lockdep assertion on mmu_lock being held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 52b5c16cf250..230cafa178d7 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -902,13 +902,13 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 
 	if (writeable)
 		kvm_set_pfn_dirty(pfn);
+	kvm_release_pfn_clean(pfn);
 
 	spin_unlock(&kvm->mmu_lock);
 
 	if (prot_bits & _PAGE_DIRTY)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
-	kvm_release_pfn_clean(pfn);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return err;
-- 
2.46.0.rc1.232.g9752f9e123-goog

