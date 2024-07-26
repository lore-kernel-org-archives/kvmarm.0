Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA62187842
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038084; cv=none; b=T56DsTTakmFuZDHlM3zL9sSw30N9jIwquJcKGtYBZvNRG6mZq/6ngCl2WDlnhYwkC9p2Lj4etJ1tzpRuw48/z0S7cS0lSF98npCUkaNM8quDx04ZKAqKDE1fmOkAC+YpKRFXQeWIXcS/RWwGp9wa79aGAJeoIkHAmxWty6duUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038084; c=relaxed/simple;
	bh=WM0+vLgn5P7yqOKEb4OpGV1yF56+IgtBIdrStZDYJ+0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fA8veDAF+YIl0A1G6K+KS0pzzwYgpEn4CxE+gwAOpzPqAp8B3yUZSIyPXcj0/AMXUKHnuRQFpN6kWkFhcqznxaKVksRcAdHA44BLi13MWokQYj5AtCMT4NkBy2AdEjZV+JbN+NxNBRgqeFM9IKRnEcPDBEcMmXq5a3QTQT9KDlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sde/tBQQ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sde/tBQQ"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb639aa911so1508426a91.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038081; x=1722642881; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eM04pE2oItbps9DzmNWUdptdfO1yLAvOtXUsQdNxOmg=;
        b=Sde/tBQQzC9z51ysTQuEixydrBMyy2J2QH1TtHspY2dWrAL4Av/xSARZyGRR47PK5j
         NTJFMF7KWEaJr4qtE7s6WjwTM/VryePNQ8qJ1Mr/F8t4hyOxpurkTDoQtbFbrxdFHuAQ
         OYvsi9MUtRyzYiqK/mo6yYuVSHyatHciV8VcCpPVLtHcPixHUM+u3+N5aLaB0jm3C9de
         7EQQvsv64ca/WYtIRPIsA4tyJmhSVEF3J4OLSviOvk/vCTWtAjBmcNP0faioObOzmm/s
         ciTZYT9F10L6g8ZgV+4pKFd7C7Lqkdnb5By8PJL4B8JMc5b4akfHD1uGkH+VjcPuw4Ka
         o38Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038081; x=1722642881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eM04pE2oItbps9DzmNWUdptdfO1yLAvOtXUsQdNxOmg=;
        b=FdVco6Tq8ybukj5cDgmjlIZd0hCHPaHGwBTI/Ma/VqiM2aefVHmLBy8u5cOf0x+z46
         vFCNqZJGLcIvIyPo7NbiYro1oCSPQqiJiA+ZWyQGDwO6KgmdXxnlVd1rHIega9DHu6Sz
         /N6Rz1F/FRhbxQXV5J7oqsXppQrvQ3CosiMxzkoPVwB+FQ4Ilq5bsTxvI8uqqF4BpdO8
         MvYBI4jUyeyBliHqZf0++8nMT/c891vowowR7N+oe375ndVs5YOOgihEGgdbXm0IjezS
         baelM4lwh0AtJiJrJqDOWyjK8fFShNSnq/HW9O9gjep0QS7XPQO6tkTGJrJ6ePlDtd93
         fy/w==
X-Forwarded-Encrypted: i=1; AJvYcCVTDGVBRp3OgjK4VxOEINDggwjoVk8AyyuGi7SjJE+Am2boYtyiw+lE+mgEylDa/C/rcI6WUQ6BKdzlxZk0Bc925sO4Kp00
X-Gm-Message-State: AOJu0Yx4c3hOTCDnjLDG7K9mmnf5OZolBvRSJwCql+pZAe5zgjvYq/w6
	xkHPj3KFV7WMj1wuCe7GQQ8xPHyUn44vO/2ExTf1jkiGQNPNIkq8VvwH/kPH+0umGaUCHyiLHn9
	EFQ==
X-Google-Smtp-Source: AGHT+IHO8zzuGkjlMSTl8Rqd7iW1pR8+tgiNg2ojfeAF3X7ugPbzXNjRAQyOFKQ91J/aSe/NwOtEVPH7LtU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:db11:b0:1f8:44f4:efd9 with SMTP id
 d9443c01a7336-1ff047d0af0mr1044175ad.2.1722038080667; Fri, 26 Jul 2024
 16:54:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:08 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-60-seanjc@google.com>
Subject: [PATCH v12 59/84] KVM: PPC: Use __kvm_faultin_pfn() to handle page
 faults on Book3s HV
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

Replace Book3s HV's homebrewed fault-in logic with __kvm_faultin_pfn(),
which functionally does pretty much the exact same thing.

Note, when the code was written, KVM indeed didn't do fast GUP without
"!atomic && !async", but that has long since changed (KVM tries fast GUP
for all writable mappings).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 2f1d58984b41..f305395cf26e 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -603,27 +603,10 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	write_ok = writing;
 	hva = gfn_to_hva_memslot(memslot, gfn);
 
-	/*
-	 * Do a fast check first, since __gfn_to_pfn_memslot doesn't
-	 * do it with !atomic && !async, which is how we call it.
-	 * We always ask for write permission since the common case
-	 * is that the page is writable.
-	 */
-	if (get_user_page_fast_only(hva, FOLL_WRITE, &page)) {
-		write_ok = true;
-	} else {
-		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
-					   writing, &write_ok);
-		if (is_error_noslot_pfn(pfn))
-			return -EFAULT;
-		page = NULL;
-		if (pfn_valid(pfn)) {
-			page = pfn_to_page(pfn);
-			if (PageReserved(page))
-				page = NULL;
-		}
-	}
+	pfn = __kvm_faultin_pfn(memslot, gfn, writing ? FOLL_WRITE : 0,
+				&write_ok, &page);
+	if (is_error_noslot_pfn(pfn))
+		return -EFAULT;
 
 	/*
 	 * Read the PTE from the process' radix tree and use that
-- 
2.46.0.rc1.232.g9752f9e123-goog

