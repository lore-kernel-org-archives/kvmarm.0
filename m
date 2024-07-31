Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97E8156F30
	for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 20:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458189; cv=none; b=XUJ0Uv5u8puAvLLVJ5p6bdU4mNqGnXZwH3QSSiWiQsUiilVWrsHNPsiZ5F9YIZQ2D2ZNxYd8eTYUgES9Z7cqir5SpYhheUhSt2CAsH96w6ea8JXc1JMjHmKFBHRQJZXsf5JJoz9vp0JHoF/ae7Op35HzOLLWxjr4gEy0XnzP6BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458189; c=relaxed/simple;
	bh=z1aLVeNoBym3Qjn/r9ThqGkDG4AOjTwKh0lTuQS/B+0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gkj/4Res8kV9+mxm2wSw1qV4uMG41ANRZXNErHgkrIo/kyGqyeUkSYOGCYbfYF3XNs3NiF8T08lRWcDFsvazg7c+PDuf7Fv+R11dj0RdzTWgfezx7t4DeBBes1NbdHQAhZvVruaHDbc02PNpENN5jZuLthIergDvj9r2NC1YS/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JvNGKR2N; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JvNGKR2N"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-664aa55c690so124095597b3.2
        for <kvmarm@lists.linux.dev>; Wed, 31 Jul 2024 13:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722458186; x=1723062986; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kd/mYHbPzOSIwsUM5m5UMPqJkKyWoklOLcVSOqbILGs=;
        b=JvNGKR2NUA8x0vJnM8G6j2bHRRiqpfozh6wYAfncdDQ4QTSDVvGLNfz46piz+hA9y6
         MBAqiucOeN+laHZiQLoDIlY7y3d46Lb46GCY7fMcAen35Mdj+KB3r6OaJHeaIggHPPn7
         ElIFr9Q6BxWN2Dj1A4yUUogPjqvUAmhdmJbG/U+Nchdta/rUrdk1fG3SRkRR48Fc8gRi
         s0l7Z/bsVWumh2cZocEHISx8fvpqtdDjCrntoQEmhnR86dWaruufEhf6Unq+lVK5IUhV
         q1Y6aXPtMg+RNVj8bZ/wSBcw2nK9xjyRQPcJvwNY+/h5NFaN3W6fPzf2Jw916jdZFRgj
         WSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722458186; x=1723062986;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Kd/mYHbPzOSIwsUM5m5UMPqJkKyWoklOLcVSOqbILGs=;
        b=bC5SarqrPrZjtIO6MVQk3flPRL3Wpnuy1uBFawwTCKHeQuGnPCVxgrKTt+uihYwA4a
         0SWmY+b/IpTXxFYaIxxarMiQID12uEd0jGva5wM3huZCep29tCAo/OLMlj66gVjPYTeg
         frw9bmMInHm+QBTo+k05yzard9Stjl+1SLYR2VRIg3+Cshr5bHu3RI4NupcAoMV7cIgU
         4S3Hpo5ToItAMdKxD8PSqNU2eQWQu7cKDtbUmJrxU4G7DTE/LOUUZ05Cfz0PBSGZLj3z
         Kvbpu+UoIouEDZqjr4fEpp8UHNQqjtjAfGeSvyAKU92FjJqqP3mMf2SkhOsZAMgIEN70
         /xzA==
X-Forwarded-Encrypted: i=1; AJvYcCUP61z3Z0WN+wvHFj38zEbT3IVW1ij1kOwCfZXWTDpXjaEcyDwJcEBjqQcbp5K6L2jgi43tsn9N1Qmi5HPxgLm82gL1O64I
X-Gm-Message-State: AOJu0YzLTl0bK0qTXe6NO/jUaGmn6XZMUxW8+IyLjD9f5almEEvuqaRJ
	d2xDFPYK19OkZ4kRz9PdxQ7XLbx6GYLCWRC0eA1IPRSGLqg89KrvY/37q7SbDxLsa82TdPPpiTm
	yNA==
X-Google-Smtp-Source: AGHT+IH0DRpeCdEjd5+EVXte2iiNPB7q7dTvECq86U0Z8nMo4fguKYduL9RXt42ZsXAM2SH8mq6gA4JZJ0k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:18d2:b0:e0b:bf20:4ff8 with SMTP id
 3f1490d57ef6-e0bccf7b434mr932276.0.1722458186501; Wed, 31 Jul 2024 13:36:26
 -0700 (PDT)
Date: Wed, 31 Jul 2024 13:36:25 -0700
In-Reply-To: <87a5hxfs3d.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-2-seanjc@google.com>
 <87a5hxfs3d.fsf@draig.linaro.org>
Message-ID: <ZqqgSW1Z07aBGwQh@google.com>
Subject: Re: [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if
 copying MTE tags hits ZONE_DEVICE
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > Put the page reference acquired by gfn_to_pfn_prot() if
> > kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
> > than-stellar heuristics for dealing with pfn-mapped memory means that K=
VM
> > can get a page reference to ZONE_DEVICE memory.
> >
> > Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a gu=
est")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/arm64/kvm/guest.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 11098eb7eb44..e1f0ff08836a 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -1059,6 +1059,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
> >  		page =3D pfn_to_online_page(pfn);
> >  		if (!page) {
> >  			/* Reject ZONE_DEVICE memory */
> > +			kvm_release_pfn_clean(pfn);
>=20
> I guess this gets renamed later in the series.
>=20
> However my main comment is does lack of page always mean a ZONE_DEVICE?

Nope.

> Looking at pfn_to_online_page() I see a bunch of other checks first. Why
> isn't it that functions responsibility to clean up after itself if its
> returning NULLs?

pfn_to_online_page() is more strict than gfn_to_pfn_prot().  At least in th=
eory,
gfn_to_pfn_prot() could return a pfn that has an associated "struct page", =
with
a reference held to said page.  But for that same pfn, pfn_to_online_page()=
 could
return NULL, in which case KVM needs to put the reference it acquired via
gfn_to_pfn_prot().
