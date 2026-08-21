Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4103126D6
	for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 13:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787319408; cv=none; b=JYBhPcZh+Q7DqYfoWO8RXNQvI3OtzXxYkSgdU6A7rP2pnclZVlPlP3A5C1UcetTj7uSad/jGRlvIoD17AnURTUiT6dsoZ669vSqHiviLLYay4SYh2Ysmj5fSVf3PWxYRm+xpLh8DZG1PdnnzPPWZnIkLgaZxV5YkASGYOk/AMX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787319408; c=relaxed/simple;
	bh=0+tjLZgWko+cGA5+iylUGBwx8MvJfpCRVeZMdSAGdy0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oS4IL9xsuL4lq7nWIij5t3gNsTgPPF8wByEu1MSaNFDJd4P3Rw2vR/uqpbqhZdQQqUBRT8wcsqS7690DDKtizp0QTqdCV/pvdPFnzFkBkToXkvJXna8imsmc2Ds4nkn7dWSQHdB9s02pRMT7CwygAAPyWN4BHFtg1KTXqmxwVL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hDf+9Fkf; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hDf+9Fkf"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cfca8558d2so14294935ad.2
        for <kvmarm@lists.linux.dev>; Fri, 21 Aug 2026 06:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787319407; x=1787924207; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MQ1L45VXIiRawAeEbWuMowK5c/UG6qrrdrhG+cVrZT4=;
        b=hDf+9FkfKNlSE0/elHP0o0AVdNu+gnn4L/j/IS3x39lml7z/2yXiV7ep3+Jb+U8Kbk
         EiK7HnjFcjv2WFRDgfbK8/OeTUGDY7PeD9tbW4b6m/jMwZbkxY4GcHN5HDOWosz4VZHp
         ZFJnVYfPHAKULsh/tVkyvEfkeo1f4yfrjbusxlTnLWvg0FvzTpJQ3WlERe4iEuUXhIAB
         XUdR7WCng2AN0CAQM/2XZBoVpSGwd/uL/x36VylzJ1vgJxEFs5egUFxaXWhuXQq6TbWm
         NQCZhb3kvrSeAH6hagvsb9igpeICkGLyNlMgjW7EFdzdB7F4ne753kxQi5T6xTl/UJtG
         W62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787319407; x=1787924207;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MQ1L45VXIiRawAeEbWuMowK5c/UG6qrrdrhG+cVrZT4=;
        b=LPZwGzc+DTAVp595sW1i1zx+Vxp/6AJcYOs0Crq+MPzXS4gnNPqkYrnCVG9r4AhXNq
         ELzgt1G0VGzbbabp4dMVkjVUgfpqceHzTgw4z9m+90EYzUrqR9GR2VgGsodyKd9Csl/m
         wyzIsQf8OKKU7XgBgvuNSX7jtCzS0TvNasaLyk35qoE/46N8EszvXYB6up1BQwnaT1nL
         Wumz8IAAq+Yqfd9E+mmHuyLrXyRPrHWiMZFe9dlHPGWWWwjU2xxjnlby6my/RZIGW2R7
         8zQrLi9jQJNPCWpQHy+/jxiKHBfuj9Eit/l1iloCB7iPf4CMuLguTxKXfkMFF+HhuTLA
         p/UA==
X-Forwarded-Encrypted: i=1; AHgh+RqnLFWmIys0a6Wg22ryGn/e/luFMaICtI3vRh8pur2GkHEaUZYJcvlwCiLNbP9QvwdSQqjrWdM=@lists.linux.dev
X-Gm-Message-State: AFuF++lU5X3aYWmrdl/zNQTwSAD4bkFrfDifCVaOa0QEcqv0veyVbapB
	hrmPHn3a0fM8e613NqDryN/2RwK58RIjEf722sDLQmjlexFgCcBKPbxCmQt9GKRMrMb2NLZGAqu
	TguwfFg==
X-Received: from plbmt15.prod.google.com ([2002:a17:903:b0f:b0:2cc:da2c:8085])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1206:b0:2ca:1b97:70c5
 with SMTP id d9443c01a7336-2d64adaff50mr107460885ad.4.1787319406415; Fri, 21
 Aug 2026 06:36:46 -0700 (PDT)
Date: Fri, 21 Aug 2026 06:36:45 -0700
In-Reply-To: <CAEvNRgHX-NebA7z3twusis35E_grJNTrbse7aUZ6+D=qpQn14A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-3-5298f42d49bb@google.com>
 <20260818092717.3F4871F000E9@smtp.kernel.org> <CAEvNRgHEVxO+1Mkoc3-c2+qSrKWnD+BDe04NBvuwGU6BL0amzA@mail.gmail.com>
 <CAEvNRgHX-NebA7z3twusis35E_grJNTrbse7aUZ6+D=qpQn14A@mail.gmail.com>
Message-ID: <aohUbUKcvUaoVFEc@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SEV: Drop page refcount early in VMSA reload
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: sashiko-reviews@lists.linux.dev, Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 21, 2026, Ackerley Tng wrote:
> Ackerley Tng <ackerleytng@google.com> writes:
> >> This is a pre-existing issue, but can this allow a malicious guest to
> >> cause a host kernel panic?
> >>
> >> Looking at sev_gmem_make_shared() in arch/x86/kvm/svm/sev.c:
> >>
> >> arch/x86/kvm/svm/sev.c:sev_gmem_make_shared() {
> >>     ...
> >> 		rc = rmp_make_shared(pfn, use_2m_update ? PG_LEVEL_2M : PG_LEVEL_4K);
> >> 		if (WARN_ONCE(rc, "SEV: Failed to update RMP entry for PFN 0x%llx error %d\n",
> >> 			      pfn, rc))
> >> 			goto next_pfn;
> >>     ...
> >> }
> >>
> >> If an untrusted SEV-SNP guest modifies a guest_memfd page state to VMSA
> >> using RMPADJUST, and the page is subsequently freed, rmp_make_shared()
> >> will architecturally fail on the VMSA page.
> >
> > I need some help with this one.
> >
> > For the initial VMSA page, IIUC snp_safe_alloc_page() gets a
> > non-guest_memfd page. This won't ever go through sev_gmem_make_shared(),
> > so we're good. snp_leak_pages() doesn't actually leak pages, it just
> > tracks leaked pages, but __free_page() is skipped so the page is really
> > leaked.
> >
> >> Because the error is bypassed without calling snp_leak_pages(), the
> >> firmware-owned page is returned to the host page allocator.
> >
> > For guest-provided VMSA pages, those can be guest_memfd pages. The
> > refcount taken is the one guest_memfd holds. Without considering
> > conversions, just considering truncation, sev_gmem_make_shared() is
> > called from kvm_gmem_free_folio(). Sashiko is saying that
> > rmp_make_shared() will fail, and the folio is freed.
> >
> > Sounds like this would be a problem if the folio is used elsewhere...?
> 
> I looked closer, "15.36.12 Running SNP-Active Virtual Machines" in APM
> Vol2 says "After a successful VMRUN, the VMCB page, as well as any AVIC
> Backing Page and VMSA Page are marked as in-use by hardware, and any
> attempt to modify the RMP entries for these pages via instructions like
> RMPUPDATE will result in a FAIL_INUSE response. The in-use marking is
> automatically cleared by hardware after a #VMEXIT event".
> 
> So it's not true that rmp_make_shared() will always fail on a VMSA page,
> it's only true if the guest vCPU is running.

Correct.

> RMPADJUST sets up the VMSA page, and telling the host using
> SVM_VMGEXIT_AP_CREATE is how the VMSA is set up to be usable. Then, the
> other vCPU needs to be started and running, and then:
> 
> If the host truncates the VMSA page or host closes the guest_memfd file
> containing some other vCPU's VMSA page, sev_gmem_make_shared() on the
> VMSA page should fail, but the page is released anyway and we have a
> problem.
> 
> An unsolicited shared->private conversion is fine since the VMSA page is
> already private.
> 
> sev_gmem_make_shared() would fail on an unsolicited private->shared
> conversion. The RMP entry would still indicate private, and guest_memfd
> would track it as shared...? Bad.
> 
> I've been trying to write a mini reproducer like a selftest but I've
> still not gotten it to work yet. If someone knows there's no issue here
> please let me know!

I have a reproducer I created to prove and validate 74bdfb2f6d18 ("KVM: SEV:
Forcefully invalidate SNP VMSA if its backing gmem page is zapped"), I'll make
sure to run it when applying (the final version of) this series.
