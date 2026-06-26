Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993693DEAF6
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782458450; cv=none; b=RwSXM+YproIfyI07va651U2uW+h5bmMEKE9HNHCf7eP66spSijR2jnPLrHJSHVWsqBJi9bn66Gy5Uzblv4X+XmR1mGip1BJqZ1sEcit31IsNpDTwSrIB4TiPuv8zJU/z2jgKOMPj2nGKLE8ewwSi4zByBWUFpQxV0Spi1ZnHXZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782458450; c=relaxed/simple;
	bh=BAFolVFMNSJJ1WhL7ay+SwoCFLJHn/caCrt8d5Xh0n8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BRTddjgKmov4DHv2rzrhk64Tf2qOv8TAOqQW07pqdt+n9nI822x3NqHLRaZwxhPtYs08naDX/eBUY/cjqFIaznOvzDVJ/+x4pM6r2NQHAM65l2q5WdeRik28dt/kR1akGlMZummmaSi5tDGoaejgiVOXSYolI9Rl2IzLVj99N3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O5dQMPI0; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O5dQMPI0"
X-Gm-Message-State: AOJu0Yz1Slr9TNqAZ4gFog0kobG7LX4eoXN/EPHbEeDC/nuxylY1nOnP
	y+VhlinQ/ezQkpeJNjDBuQH4rk6Xyyz6lYRjhVUMY7m82wIJtiZEbefqW/MpEgzP0E15Ae80KJm
	0/EXwF3Ox47QpJSmxIjPQson0ojJVnY6hBl4LV7Tf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782458446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qwwwL0HrcXVcn+htSRSdhtA7hZBA+Y61bxFLzkhaoWU=;
	b=O5dQMPI0viP73fwJpbjeZs0uH/48dJZpFdaqRpWBpVeKOclfQihT3YWs2PnOXLRSgTnMBL
	1SmJK+Onu7jRqFysWRm/nKnNbLS+xC6Ak6qUymGzItow/C7mMZm1PsPo84qOkicP0lBZRO
	20LwGNrnngmkFv6udj3xhNPxUKOfNQ8=
X-Received: by 2002:a05:622a:2516:b0:517:99ea:ab7e with SMTP id
 d75a77b69052e-51a7d830b45mr7217711cf.24.1782458437067; Fri, 26 Jun 2026
 00:20:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com> <20260619070508.802802-5-tabba@google.com>
 <20260619071601.A5E641F000E9@smtp.kernel.org> <CA+EHjTwpB2fmoYGfkP5RVZcB4sgbVPQ0=QR5dyUJnpQ_VQa+pA@mail.gmail.com>
In-Reply-To: <CA+EHjTwpB2fmoYGfkP5RVZcB4sgbVPQ0=QR5dyUJnpQ_VQa+pA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 26 Jun 2026 08:19:59 +0100
X-Gmail-Original-Message-ID: <CA+EHjTy2MyMzv8oq-x87LZJLf7y-SHxO1jwWXA3x0M_HUKSGSw@mail.gmail.com>
X-Gm-Features: AVVi8Ce8dyIuWx8tJVPE2blGqNzxnjcwkrzuo6Dzb1kt0PXRRI5yESCQ1UTFP9Q
Message-ID: <CA+EHjTy2MyMzv8oq-x87LZJLf7y-SHxO1jwWXA3x0M_HUKSGSw@mail.gmail.com>
Subject: Re: [PATCH 4/8] KVM: arm64: Move PSCI helper functions to a shared header
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, 19 Jun 2026 at 08:24, Fuad Tabba <tabba@google.com> wrote:
>
> On Fri, 19 Jun 2026 at 08:16, <sashiko-bot@kernel.org> wrote:
> >
> > Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s) to consider:
> > - [Low] The header `include/kvm/arm_psci.h` is not self-contained due t=
o missing includes for dependencies used in the newly added inline function=
s.
>
> The header was already not self-contained before this commit: the
> pre-existing kvm_psci_version() uses vcpu_has_feature() from
> asm/kvm_emulate.h without including it. Every .c file that includes
> arm_psci.h already includes kvm_emulate.h. The other dependencies
> (lower_32_bits, MPIDR_HWID_BITMASK) are transitively available through
> linux/kvm_host.h.

We've been throught this before my friend [1]

The header was already not self-contained before this commit: the
pre-existing kvm_psci_version() uses vcpu_has_feature() from
asm/kvm_emulate.h without including it. Every .c file that includes
arm_psci.h already includes kvm_emulate.h. The other dependencies
(lower_32_bits, MPIDR_HWID_BITMASK) are transitively available through
linux/kvm_host.h.

Cheers,
/fuad

[1] https://lore.kernel.org/all/CA+EHjTwpB2fmoYGfkP5RVZcB4sgbVPQ0=3DQR5dyUJ=
npQ_VQa+pA@mail.gmail.com/

>
> Cheers,
> /fuad
>
> > --
> >
> > commit 5533f45659b895d2266b9d4cfb6fd00ea1dc5f92
> > Author: Fuad Tabba <tabba@google.com>
> >
> > KVM: arm64: Move PSCI helper functions to a shared header
> >
> > This commit moves several PSCI helper functions out of psci.c and into =
the
> > shared include/kvm/arm_psci.h header. This includes kvm_psci_valid_affi=
nity()
> > and kvm_psci_narrow_to_32bit(), along with renaming psci_affinity_mask(=
).
> >
> > [ ... ]
> >
> > > diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> > > index cbaec804eb839..f86a006d67136 100644
> > > --- a/include/kvm/arm_psci.h
> > > +++ b/include/kvm/arm_psci.h
> > > @@ -38,6 +38,33 @@ static inline int kvm_psci_version(struct kvm_vcpu=
 *vcpu)
> > >       return KVM_ARM_PSCI_0_1;
> > >  }
> > >
> > > +/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
> > > +static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> > > +{
> > > +     int i;
> > > +
> > > +     /*
> > > +      * Zero the input registers' upper 32 bits. They will be fully
> > > +      * zeroed on exit, so we're fine changing them in place.
> > > +      */
> > > +     for (i =3D 1; i < 4; i++)
> > > +             vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, =
i)));
> >
> > [Severity: Low]
> > Does this change leave arm_psci.h relying on implicit includes?
> >
> > The moved inline function kvm_psci_narrow_to_32bit() relies on vcpu_set=
_reg()
> > and vcpu_get_reg() which are defined in asm/kvm_emulate.h, as well as
> > lower_32_bits() which comes from linux/wordpart.h.
> >
> > Should this header explicitly include those files to ensure it remains
> > self-contained, so that future users don't encounter build errors if th=
ey
> > include this file first?
> >
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619070508.=
802802-1-tabba@google.com?part=3D4
