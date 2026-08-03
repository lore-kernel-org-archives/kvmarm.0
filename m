Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAA3411A0B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785765048; cv=none; b=PtaAuK114mRXbapWa3gO5mpcjFavc1v053S/EBn1JTX9czG8N8e2DNpfSxhfDlLa46azgdTV8PWdF1tqPgHPR1hf3dlN/cACnmKjF6HF3UZi+OvI2EWaUH4VZceYma5sSfo5tNYaHlr6yaHfD4W312GW3EdZASkVBySQm0kD+1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785765048; c=relaxed/simple;
	bh=eeyNGjfZmFT6himFoPn/uBeknNXznxZmPMBnMoac77c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HR56tyG0wvHrg1D9gj00wAmv9BEQq+NNFlhdpS+zA4K85k1SZetzXR+ODBy2JWb4zjFdsyjw/i/tUb7q1oO2AVQo5khSQxAeq5gDlKh+QGnFfaD6MTJWjr0s5L/BAPw34Q5ovVfMxvfjckw291YDP2NSpMrXfeCY+zmLFFB2Yxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TR06aOG4; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TR06aOG4"
X-Gm-Message-State: AOJu0Yyt+gu4kYfxpmZnGY8F9zYoSJGnXuj19KXnZPh8bR05hYi6DrhO
	PKj77BHTR4x/AdCU67CJAdnNafpMUJUygGBn+pc+52nBFaYGSvGTnSlyo6GIzBokNM9bSve9mZ4
	CuRQJ7N/fB4kmrYCkBVOT9T4G33RiSC6/0cfCKDvl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785765044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lQ3YAL64eDLa+Bt4JFnAVMdVoc1NiuK6FmvC+qq10nM=;
	b=TR06aOG4DI+2MRiBh0qvbOx3pLWKHesyq/jJ3csHRz2HqgNH+VWkcj2RkmyPokMIw3NBuo
	1we1C61Pvw2CEbeQNROBLwXGiJJ2AGSfL6RxUFA7TKrlRoIY1O+iQQLJyY0GghlAeLKak2
	060Bfc/8UafF78Vgxi921LLWx01mlig=
X-Received: by 2002:a05:622a:9013:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-52b598d1fbdmr40702881cf.4.1785764998662; Mon, 03 Aug 2026
 06:49:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803124220.332248-1-fuad.tabba@linux.dev> <20260803124220.332248-12-fuad.tabba@linux.dev>
 <20260803134435.D34A41F00A3F@smtp.kernel.org>
In-Reply-To: <20260803134435.D34A41F00A3F@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 3 Aug 2026 14:49:21 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyH9BcXvROasUDSfyFGSmrBGWpnyPvJMKiGjD0ot7WS8A@mail.gmail.com>
X-Gm-Features: AUfX_mxBVB5d1YvkxHkIg762z8HSKKUu8UldwpTLFdna3vOAnstg2ZtBZSwrf5I
Message-ID: <CA+EHjTyH9BcXvROasUDSfyFGSmrBGWpnyPvJMKiGjD0ot7WS8A@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] KVM: arm64: Tag host-VA hypercall parameters __kern
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 3 Aug 2026 at 14:44, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Medium] The `kern_hyp_va_host()` macro strips the `__kern` tag using `=
(__force void *)` and returns a plain pointer, undermining the static analy=
sis guarantees for both misapplied unwraps and subsequent TOCTOU bugs.

https://lore.kernel.org/all/20260720175513.8D4DF1F00A3A@smtp.kernel.org/

>
> Pre-existing issues:
> - [Critical] Always-on hypercalls (e.g., `__vgic_v3_save_aprs`, `__kvm_ad=
just_pc`) accept host VAs, translate them via `kern_hyp_va_host()`, and rea=
d/write to them without validating physical page ownership, enabling a Conf=
used Deputy arbitrary memory corruption attack.

We're working on that, coming soon!

/fuad

> --
>
> --- Patch [11]: [PATCH v2 11/11] KVM: arm64: Tag host-VA hypercall parame=
ters __kern ---
> commit 0acf480afb506d5122464f1024574511fad649b3
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Tag host-VA hypercall parameters __kern
>
> The nVHE hypervisor takes host virtual addresses as hypercall arguments
> and translates each with kern_hyp_va() before use. This patch adds a __ke=
rn
> sparse address space for EL2 code to tag host-VA parameters and introduce=
s
> kern_hyp_va_host() to unwrap them.
>
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/=
kvm_mmu.h
> > index 6eae7e7e2a684..57f65257bb56d 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> [ ... ]
> > @@ -140,6 +142,14 @@ static __always_inline unsigned long __kern_hyp_va=
(unsigned long v)
> >
> >  #define kern_hyp_va(v)       ((typeof(v))(__kern_hyp_va((unsigned long=
)(v))))
> >
> > +/*
> > + * Translate a __kern-tagged host VA, dropping the tag: the only sanct=
ioned
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
> Since the __force void * cast unconditionally strips all sparse address s=
pace
> information, does this suppress warnings if the macro is accidentally app=
lied
> to an untagged EL2 private-VA-range pointer?
>
> Additionally, because the returned pointer has no address space tag, does=
n't
> this prevent sparse from warning if a developer directly double-fetches o=
r acts
> on the translated untrusted host memory instead of copying it first?
>
> For example, in __pkvm_init_vm(), host_kvm is passed as a plain pointer a=
nd
> loses its sparse static analysis protection despite still aliasing untrus=
ted
> memory.
>
> [ ... ]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 6986ce55fd9ef..f8ea1661b3166 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -500,15 +500,15 @@ DEFINE_KVM_HOST_HCALL0_VOID(__vgic_v3_init_lrs)
> >  }
> >
> >  DEFINE_KVM_HOST_HCALL_VOID(__vgic_v3_save_aprs,
> > -     struct vgic_v3_cpu_if *, cpu_if)
> > +     struct vgic_v3_cpu_if __kern *, cpu_if)
> >  {
> > -     __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> > +     __vgic_v3_save_aprs(kern_hyp_va_host(cpu_if));
> >  }
>
> [Severity: Critical]
> This is a pre-existing issue, but by retaining the lack of bounds validat=
ion
> through kern_hyp_va_host(), can the host EL1 trigger an arbitrary memory
> corruption in the hypervisor?
>
> Since kern_hyp_va_host() explicitly performs no ownership or bounds valid=
ation,
> it appears the host kernel could provide a forged pointer that translates=
 to a
> physical page owned by EL2.
>
> The hypervisor then passes this pointer directly to __vgic_v3_save_aprs()
> after unvalidated translation:
>
> arch/arm64/kvm/hyp/vgic-v3-sr.c:__vgic_v3_save_aprs() {
>     ...
>     cpu_if->vgic_ap0r[3] =3D __vgic_v3_read_ap0rn(3);
>     ...
> }
>
> which directly writes to the untrusted pointer, potentially allowing the =
host
> to corrupt EL2 private memory and bypass isolation.
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803124220.33=
2248-1-fuad.tabba@linux.dev?part=3D11
