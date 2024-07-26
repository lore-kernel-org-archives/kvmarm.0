Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0470118EFF9
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038107; cv=none; b=cHGw4mQZOoeRNivgEWAOWitW/dGoQpKxc3NfIuMyGErq8toc8kaGeW5FFB8OEOruvS/OdzyJoV9F0b3l0VjBtVpGUelA55sTTnrM4jmED6pQt9Qu1bPSWUH7d+08MzkHuUhVutoYfJ4oRHeazexa6wCFOomRjw8SFrQ0PSzXH+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038107; c=relaxed/simple;
	bh=lhHYI4ZmXcFxea+okVo57sctSAMSkRMQQrnLBVGt6rM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uorxgQfpJZAQs8J7jJmOtgs+TrbBsrI+97LqXuA5uRpI3tzenm9EDMDR03qwANPbrCkrUrfAkm5cDKEaEAnx8v54vvngtPlh3tQbdqTcvNrOq/x86yqhdEkwBoD34LA4vkWgzeDLImP8pB9LCvsiCDZVpM4pPRckGaB3D2IOBpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ABKi98Ug; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ABKi98Ug"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-76522d1dca5so1518462a12.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038105; x=1722642905; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=M9eYn37tam32k4Zpbs9VqSvLY6wlhZ916YFlgyF6peA=;
        b=ABKi98UgGkIgxkVDLaZ5LOinyusm46vJwKbIm7pW8z1VWFApnc5SIQ/QXlcQ0uawSe
         qCTIgoA1fsOXfHmT6Z5K/Mo/X+w0Bx+IeYqdh24MlJGisNhdDbpqIf0Tdw/7tgkp3BPu
         QrijKvt1LFkgrFBKjgMoM81q/ZifyjjJuSLLD3cHpA5HcWp34wQ9SzW8NKEaqGwJyRhW
         +Oqq11qAtFEXn30G5TnFLo4VUSsfB3neKsC4/M8+/iSDAizU61gqwZfOQT62Cc4OHr3E
         +Yya2+SU4gcV4LqwvyYxn/3tghCod89O+DJGyyOKNSt5AIyeiBKtxBPgK0511tkLB0/8
         X0jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038105; x=1722642905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M9eYn37tam32k4Zpbs9VqSvLY6wlhZ916YFlgyF6peA=;
        b=OpISGvj3mJ5+kaCQoVt7wPxA+kBsAGKTx8fqDOVuhtpLHwVMqZI3/EMLCAAzG2cS5o
         Ox6T+Zujb8KQ8iDA6I4rsMCNZ+X12ANovEugO0DechNR9GZllr0mz9fvcNk57/njMQws
         IJhSA0m2E7muqEFTh6Y8klxwncapn783yABxPob/GzprZn6fnwwOSzP/voEvc4ftmMdD
         kLFq2PcYTUkXjrDjUL6+Y/g9HSxGf7lQHIjYlb22HIDBeVLxFefSGoaTsHNORWMnzgX0
         AgRIXBgzdTWNwd4juL3MjLfqf7BJhZlbJ0tO3C75nXyKAcnlvk1ip7jDZr5bzXCZGtaX
         HP/w==
X-Forwarded-Encrypted: i=1; AJvYcCVXdCVBAv8AedhZ7Zzg7cb+gGuMcAgENXxhoFVFg72FLj/gCMnNwl1DLMumZDruiTnBKgD1y6PhKF7wIwQswQHy3p5studd
X-Gm-Message-State: AOJu0Yyr8e0b5jxgIoU6ww5PeTy6SCwlhvoWoxQ3sp/1uQ4PQeH54PAl
	7htyb+CoZ5FfegvFgUTuuOJWHlxNg157edlP4+kxDAXwN5P94aE4v+YENNK7lUg+TrRum6I0AS7
	QnQ==
X-Google-Smtp-Source: AGHT+IG8TH3qPrjAadwsmfbGVL51l5vDfwJrWL4CCM6knLIepOGyFeiwzAiBROJulbOiIHONd5UuXBO9hTI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:526:b0:6e3:e0bc:a332 with SMTP id
 41be03b00d2f7-7ac8dbc497emr2439a12.2.1722038105187; Fri, 26 Jul 2024 16:55:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:20 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-72-seanjc@google.com>
Subject: [PATCH v12 71/84] KVM: MIPS: Use kvm_faultin_pfn() to map pfns into
 the guest
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

Convert MIPS to kvm_faultin_pfn()+kvm_release_faultin_page(), which
are new APIs to consolidate arch code and provide consistent behavior
across all KVM architectures.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 69463ab24d97..d2c3b6b41f18 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -557,6 +557,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	bool writeable;
 	unsigned long prot_bits;
 	unsigned long mmu_seq;
+	struct page *page;
 
 	/* Try the fast path to handle old / clean pages */
 	srcu_idx = srcu_read_lock(&kvm->srcu);
@@ -578,7 +579,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	mmu_seq = kvm->mmu_invalidate_seq;
 	/*
 	 * Ensure the read of mmu_invalidate_seq isn't reordered with PTE reads
-	 * in gfn_to_pfn_prot() (which calls get_user_pages()), so that we don't
+	 * in kvm_faultin_pfn() (which calls get_user_pages()), so that we don't
 	 * risk the page we get a reference to getting unmapped before we have a
 	 * chance to grab the mmu_lock without mmu_invalidate_retry() noticing.
 	 *
@@ -590,7 +591,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	smp_rmb();
 
 	/* Slow path - ask KVM core whether we can access this GPA */
-	pfn = gfn_to_pfn_prot(kvm, gfn, write_fault, &writeable);
+	pfn = kvm_faultin_pfn(vcpu, gfn, write_fault, &writeable, &page);
 	if (is_error_noslot_pfn(pfn)) {
 		err = -EFAULT;
 		goto out;
@@ -602,10 +603,10 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		/*
 		 * This can happen when mappings are changed asynchronously, but
 		 * also synchronously if a COW is triggered by
-		 * gfn_to_pfn_prot().
+		 * kvm_faultin_pfn().
 		 */
 		spin_unlock(&kvm->mmu_lock);
-		kvm_release_pfn_clean(pfn);
+		kvm_release_page_unused(page);
 		goto retry;
 	}
 
@@ -632,10 +633,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	if (out_buddy)
 		*out_buddy = *ptep_buddy(ptep);
 
-	if (writeable)
-		kvm_set_pfn_dirty(pfn);
-	kvm_release_pfn_clean(pfn);
-
+	kvm_release_faultin_page(kvm, page, false, writeable);
 	spin_unlock(&kvm->mmu_lock);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
-- 
2.46.0.rc1.232.g9752f9e123-goog

