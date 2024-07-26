Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C09118FC73
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038112; cv=none; b=QvCywv23fX+6TuYdKgjDkINV9vccl6vgP2uoYQCekgPazWtBd4phxiPdZdr35ytPXvC9EBayLGQ0nqv3yOr3pHs4s9lFN4TFkfWo0bXaqkhLnMXhfk1p5SxLoH3JEhy0wnajMkbOzb3Q9cr3UqjGO8YVy2v8xg2MpzKjFDc8w7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038112; c=relaxed/simple;
	bh=MKtv9E2m62lbMOtLTcz5DheM9a7Qrx2EJNoDq9m1CG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pFFe1L8yWEpFG58hh6GxNc9iBtlzGwIAH9Ms11ipNKDSAUhJJWKYnDo96OG/oq7ssmKV5xy3rHq/H7XLmBP/FRQ3WgQ367RQtMDy4LRz4RNVdVvWOzTuaDZo+c0gH6esinhqKmxpCxNCewkg+hl/dnT3xygNEr65K37GgABxGDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RijEl4FO; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RijEl4FO"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-654d96c2bb5so6827747b3.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038110; x=1722642910; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FGNMZjC6zrq4QPk0aaY9W+lI1TKYWYG7APrsjifVvZM=;
        b=RijEl4FOTNoenMmqtd1HOnOmJvXo79PvseeR5J1DA4Fd+41rgVW781oDI5kF+P2T6p
         +iMJHflHvGYasayzG5fJlKVmay30Bjz15Cc7ZZIF1uL707510AP/+ObkSP8JoUk4S2NB
         cIeDQJu3WyiLALYEfBRwVKI88Se7xucUcDRYkDBkduJjckrZqtXHSTPOrmcmXmKKQ2WQ
         u3JMKC4YXx3GASqbgsXUBn+S05QZs9Ec0Ax7Xhk5kI2HkFDNhg8wUKQ6ci28KhEeWz9v
         6z27Y/KSN9aCzoCgNv8WTp9mkoy9ASEYbPG0FdJ2Kkji5biC33iEGu5uIUzDSBItqBcJ
         bd5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038110; x=1722642910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FGNMZjC6zrq4QPk0aaY9W+lI1TKYWYG7APrsjifVvZM=;
        b=k3xcqAX8vUhGSobT3SnAOprw11oo+KQz5enBeXtsxXiFILE5HErWi37W/BD/XqtyVZ
         hlqNccn9+lzYQ/hcXkiMNlYNgMnd7beMiyo6Xvo1P3tgOyAVyEJ6lL9LmO+50z3yBjPh
         yj3pkv88cGoIFkE495Xd+ygDDiRNs9xToxgFGUO9WJXPgNTu+1Fa2f7ocEKS/IDEonaJ
         AXRV514OqWbCPU7ogPBwKwgIJ51EDWajBB7zMviM7MDjyz1hBxatyv4ONUsAh9eM0Mtg
         2ZmZJE4RRmL6jA2c4t6zbzaUmAqFqYdvltazrJZgNfqkrdRm7ubjRE5r3zVhPdTYvSvI
         /I9g==
X-Forwarded-Encrypted: i=1; AJvYcCXiGcCRgVrlXkfNbQwYdcz7HZg2adK6WZS5KWqCaMNp9WON1H7rPSw6VnJjsNhiVNL9e60pza/r+Jb7jJwgQhqicQoMwg6D
X-Gm-Message-State: AOJu0YxpevEp66Kki6BJvu01Vyk7srH0qz2SmlnCcLW3IdtuiAd3ZwQn
	tl+nq0w8SssAlFUJUo7J+IpDZFvHyAjPGuLXDIglxeSjjsIpaiuk8PAHjU0zBqr8DRpKPWIOhBR
	BeQ==
X-Google-Smtp-Source: AGHT+IFLZWO6XOpdLpjl0c1N0cYikN5d5kXLguU/WRS6HZfMhk4D9x8u+2tsxxP6CN0/8qHX8YjuuRQeC7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:830:b0:61b:e103:804d with SMTP id
 00721157ae682-67a004a2a4amr37877b3.0.1722038109325; Fri, 26 Jul 2024 16:55:09
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:22 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-74-seanjc@google.com>
Subject: [PATCH v12 73/84] KVM: PPC: Use kvm_vcpu_map() to map guest memory to
 patch dcbz instructions
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

Use kvm_vcpu_map() when patching dcbz in guest memory, as a regular GUP
isn't technically sufficient when writing to data in the target pages.
As per Documentation/core-api/pin_user_pages.rst:

      Correct (uses FOLL_PIN calls):
          pin_user_pages()
          write to the data within the pages
          unpin_user_pages()

      INCORRECT (uses FOLL_GET calls):
          get_user_pages()
          write to the data within the pages
          put_page()

As a happy bonus, using kvm_vcpu_{,un}map() takes care of creating a
mapping and marking the page dirty.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index ae4757ac0848..393c18958a5b 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -639,28 +639,27 @@ static void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, u32 pvr)
  */
 static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 {
-	struct page *hpage;
+	struct kvm_host_map map;
 	u64 hpage_offset;
 	u32 *page;
-	int i;
+	int i, r;
 
-	hpage = gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
-	if (!hpage)
+	r = kvm_vcpu_map(vcpu, pte->raddr >> PAGE_SHIFT, &map);
+	if (r)
 		return;
 
 	hpage_offset = pte->raddr & ~PAGE_MASK;
 	hpage_offset &= ~0xFFFULL;
 	hpage_offset /= 4;
 
-	page = kmap_atomic(hpage);
+	page = map.hva;
 
 	/* patch dcbz into reserved instruction, so we trap */
 	for (i=hpage_offset; i < hpage_offset + (HW_PAGE_SIZE / 4); i++)
 		if ((be32_to_cpu(page[i]) & 0xff0007ff) == INS_DCBZ)
 			page[i] &= cpu_to_be32(0xfffffff7);
 
-	kunmap_atomic(page);
-	put_page(hpage);
+	kvm_vcpu_unmap(vcpu, &map);
 }
 
 static bool kvmppc_visible_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
-- 
2.46.0.rc1.232.g9752f9e123-goog

