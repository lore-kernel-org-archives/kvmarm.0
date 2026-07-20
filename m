Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63C6407567
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 18:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784571934; cv=none; b=XbMVh7OmNpfkJe//jHeyc00+DXzsAsjUoe4lRGeQ9YXproNYY2F9x9ugq4Tj8WrxJVG846pp/56RQsr0YEGlhmg60goeci9e17y1iSjxVAzqtCDhlqxI0vDvnJDpDp2NYrZHXdATAzFuXz3XABq7pvG6AqhrjkJv44Is1EruSyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784571934; c=relaxed/simple;
	bh=k+fQpm49l1+4lmdnx1rm8Musxyu597fruggM/xFVb8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqBGg1T061ZQyOuyGRnt1h/DR2l2t+cqW+kZWPehSyrk63p9n7e0xt2kk3G7M14arbV9INPqvRkGCpo87CMsIxSeHhys5uZDJHbWMC18jf49KRV6HBum5KY5EntN/eAxE9h0Tt7io4j/aWpMQO0ZIupLsKa6aBGqwxlwVxM/5pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WfQhYska; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WfQhYska"
X-Forwarded-Encrypted: i=1; AHgh+RqSPxiJj/mSKp9eUTJ+PM62ajEOuopVuzJf0UsbPf5AOtlNubA21aNevDmvLTNIT/PRyDQxASc=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784571929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8Oz31bQMHhvgoNQfGkOKJ8LkWQ7qWzkNqWD5sX8hF6Y=;
	b=WfQhYskatIJYH6v44TtEnvzs47Kjl6O4/MfnO22D2RAMTJokcenxYaJ6X37sm9Edmmd+Yj
	E+aAA1QWmhvbZO0EHIVbnCkLRJqAomnoN1E3N1mipgRISkQy5fOsWURxpPEIGapJOU7QCO
	4x8zvA5rgl+8C+4+llV4SgUFYa7mRH0=
X-Gm-Message-State: AOJu0Yxgj90koUMpnd2r89y7CWjrJhO1F7AVKaHnC5N/FvkLfgjpTshk
	PejNh8ginxj2aZEMpDt3s3ttu//7GEU0/C3p1A4AJ0X+Q1PIApqOXk8eHMXegE+VLAUtMz1clvb
	BS4U6FhE0SyFN2oPhiVr8QfVior+r/RHliW07No2U
X-Received: by 2002:ac8:5a8b:0:b0:51b:fd5e:e81a with SMTP id
 d75a77b69052e-526027c23camr4280141cf.20.1784571920974; Mon, 20 Jul 2026
 11:25:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720161343.1367007-1-fuad.tabba@linux.dev>
 <20260720162412.1401272-1-fuad.tabba@linux.dev> <20260720162412.1401272-2-fuad.tabba@linux.dev>
 <20260720175513.8D4DF1F00A3A@smtp.kernel.org>
In-Reply-To: <20260720175513.8D4DF1F00A3A@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 20 Jul 2026 19:24:44 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz4gsfbr04gqFwAu1DXvrC97wSor5DnDGG17qaWbMiRaA@mail.gmail.com>
X-Gm-Features: AUfX_mxH03Vw1Gcio4Cr31tILBRNuZ8GhAs6QvKGRHwHuKt0nwU5F641beYYmc0
Message-ID: <CA+EHjTz4gsfbr04gqFwAu1DXvrC97wSor5DnDGG17qaWbMiRaA@mail.gmail.com>
Subject: Re: [PATCH v1 11/11] KVM: arm64: Tag host-VA hypercall parameters __hostva
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 20 Jul 2026 at 18:55, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Medium] `kern_hyp_va_host()` macro fails to strip the `__hostva` addre=
ss space tag for Sparse.
>
> Pre-existing issues:
> - [Critical] Missing host pointer ownership validation in always-on hyper=
calls allows a malicious host to corrupt EL2-private memory (Confused Deput=
y).
> --
>
> --- Patch [11]: [PATCH v1 11/11] KVM: arm64: Tag host-VA hypercall parame=
ters __hostva ---
> commit 4acf0dff6116caffddce5517211ac9136d9b0ee1
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Tag host-VA hypercall parameters __hostva
>
> This commit introduces the __hostva sparse address space to tag host virt=
ual
> addresses passed as hypercall arguments in the nVHE hypervisor. It adds
> kern_hyp_va_host() to explicitly unwrap and translate these tagged pointe=
rs,
> ensuring that untranslated host VAs are caught by sparse checks.
>
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/=
kvm_mmu.h
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
>
> [ ... ]
>
> > @@ -140,6 +142,14 @@ static __always_inline unsigned long __kern_hyp_va=
(unsigned long v)
> >
> >  #define kern_hyp_va(v)       ((typeof(v))(__kern_hyp_va((unsigned long=
)(v))))
> >
> > +/*
> > + * Translate a __hostva-tagged host VA, dropping the tag: the only san=
ctioned
> > + * unwrap. Translation only, no ownership or bounds validation; the re=
sult
> > + * carries the pointee type stripped of the tag and of any cv-qualifie=
rs.
> > + */
> > +#define kern_hyp_va_host(v)                                          \
> > +     ((TYPEOF_UNQUAL(*(v)) *)__kern_hyp_va((unsigned long)(__force voi=
d *)(v)))
>
> [Severity: Medium]
> Does TYPEOF_UNQUAL() actually strip the address space tag in Sparse?
>
> Sparse treats address spaces as type qualifiers that typeof_unqual (and
> by extension TYPEOF_UNQUAL) does not remove, unlike const or volatile.
> Consequently, this cast evaluates to a pointer that still carries the
> __hostva tag.
>
> When assigned to a regular kernel pointer, this will trigger incorrect ty=
pe
> in assignment (different address spaces) false positive warnings across t=
he
> codebase when running make C=3D2.
>
> Should this use an explicit cast to __kernel (address_space(0)) to
> correctly strip the tag, similar to how per_cpu_ptr handles __percpu?

The __hostva tag is stripped, so these warnings don't occur. Under
sparse TYPEOF_UNQUAL() is __typeof_unqual__(), which in sparse >=3D
v0.6.5-rc1 removes the address_space qualifier, so kern_hyp_va_host()
returns a plain kernel pointer. Verified: C=3D2 over the nvhe objects is
warning-free, while a control doing an implicit __hostva -> plain
conversion does warn. Older sparse lacks __typeof_unqual__, so
scripts/checker-valid.sh disables checking with a warning rather than
emitting false positives.

>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -421,9 +421,9 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_gues=
t, 1,
> >  }
> >
> >  DEFINE_KVM_HOST_HCALL_VOID(__kvm_adjust_pc, 1,
> > -     struct kvm_vcpu *, vcpu)
> > +     struct kvm_vcpu __hostva *, vcpu)
> >  {
> > -     __kvm_adjust_pc(kern_hyp_va(vcpu));
> > +     __kvm_adjust_pc(kern_hyp_va_host(vcpu));
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but does this lack of ownership validation
> allow the host to corrupt EL2-private memory?

Working on it :) Different series group [1].

/fuad

[1] https://lore.kernel.org/all/20260715081238.1891918-1-fuad.tabba@linux.d=
ev/

>
> Under pKVM, the host is treated as an adversary. If the host provides a
> TTBR1 virtual address that maps to an EL2-private physical address,
> kern_hyp_va_host() will translate it into a valid EL2 linear map pointer
> without verifying ownership.
>
> The hypervisor will then write into EL2-private memory when modifying
> flags in __kvm_adjust_pc() or hardware register state in
> __vgic_v3_save_aprs(), corrupting its own state or the state of
> protected guests.
>
> Should there be an explicit ownership check before dereferencing
> pointers from these always-on hypercalls?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720162412.14=
01272-1-fuad.tabba@linux.dev?part=3D11
