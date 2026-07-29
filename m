Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8626B48EBE8
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332078; cv=none; b=GtCUKOCtgB+I5E0i8NVci7x4wmNW5eaYH8PTuy11VoM+jK1EDdP9N4EU/zWu2RZ6WFHa4g7fIs6aSYV4EPE+D/u/ohCzSmmcl3QDeKthbsR9XurOVUbFb4oLkwMuScTrpie/DLk5Fso2Gu5LKVnRNwSi9pvEzI0WiDrYyFm+XP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332078; c=relaxed/simple;
	bh=th4hZKzg+ZvNX3vxWSicPLBYvZeuXaCwq1TOAX6BJ/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RDHTERCdgSNfhJM1wrFt+tlpGfzK+4rTGs0nOcqXO1eZvYoYQgIqCuliy1OI0q0uORPpdeZIiiuWnS6r1juSBxD83RpaPtzN/nr3L/H9d89BwK2TPLH+K70/ys9dfU+9BJw4Hhuh66i67H2AeetmVIY3UqNMk2/GfF9/bh+oG18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EfEiL57T; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EfEiL57T"
X-Gm-Message-State: AOJu0YxFzOp+LepYEeSJrff9IVQhOaBuEGqeohoCVn3cPkeKwDnh38VM
	L/3unjwJ+LnAJEyc62j1rsBwQ2qF6flh+JavxfDahLmrkEQb7uxDXccyorczYC4OEZxBKuOGFeL
	zrc+bgU2IM0jV8kUa+2WnfXOcuhvz05ejeD93q/yD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785332069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jNw0oLXC06WVAdDTxys3cThOgITa6WTIg6WIyFuBM4E=;
	b=EfEiL57T//STyi2VtuVLkpbGvgobh4iTlwBD3VxEa6oiIMY3iawYdXJLeT9dPYYcP+8k5g
	fda/jEprF4IVNAj/YElkP+IWBrR6mnTgMyA/7Rv4ov54UZ6/SmivWHIudHivaMHmQ5G9gd
	upJl7hYM/F3D6IbWQMJ03/RmkmolKtA=
X-Received: by 2002:a05:622a:5597:b0:528:3186:5799 with SMTP id
 d75a77b69052e-52b2b3daf85mr11629451cf.10.1785332056716; Wed, 29 Jul 2026
 06:34:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-5-fuad.tabba@linux.dev> <20260729133136.50EFA1F00A3D@smtp.kernel.org>
In-Reply-To: <20260729133136.50EFA1F00A3D@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 14:33:40 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw8zvPuMMefpGCMFnDRNawVkc_+XdW8pDxj40g=AFQ_sg@mail.gmail.com>
X-Gm-Features: AUfX_mxLLmBZkNGVYqvd3CLjf6J6a3kAMI39-B55sRILmCBhxKw48HHM8UmVVDM
Message-ID: <CA+EHjTw8zvPuMMefpGCMFnDRNawVkc_+XdW8pDxj40g=AFQ_sg@mail.gmail.com>
Subject: Re: [PATCH v7 4/8] KVM: arm64: Move PSCI helper functions to a shared header
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Wed, 29 Jul 2026 at 14:31, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Low] Missing header dependencies in include/kvm/arm_psci.h

nope:

https://lore.kernel.org/all/CA+EHjTwpB2fmoYGfkP5RVZcB4sgbVPQ0=3DQR5dyUJnpQ_=
VQa+pA@mail.gmail.com/

/fuad

> --
>
> --- Patch [4]: [PATCH v7 4/8] KVM: arm64: Move PSCI helper functions to a=
 shared header ---
> commit 4d648c3ac7ab8549b7dcf7d52de4756db87e329c
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Move PSCI helper functions to a shared header
>
> This commit moves several PSCI helper functions from psci.c to the shared
> include/kvm/arm_psci.h header. This makes them available for upcoming
> protected-guest PSCI calls at EL2.
>
> > diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> > index cbaec804eb839..f86a006d67136 100644
> > --- a/include/kvm/arm_psci.h
> > +++ b/include/kvm/arm_psci.h
>
> [ ... ]
>
> > +/* Narrow the PSCI register arguments (r1 to r3) to 32 bits. */
> > +static inline void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
> > +{
> > +     int i;
> > +
> > +     /*
> > +      * Zero the input registers' upper 32 bits. They will be fully
> > +      * zeroed on exit, so we're fine changing them in place.
> > +      */
> > +     for (i =3D 1; i < 4; i++)
> > +             vcpu_set_reg(vcpu, i, lower_32_bits(vcpu_get_reg(vcpu, i)=
));
> > +}
>
> [Severity: Low]
> Does this header need to include additional dependencies to remain
> self-contained?
>
> This inline function uses vcpu_set_reg() and vcpu_get_reg(), which are de=
fined
> in <asm/kvm_emulate.h>, as well as lower_32_bits() from <linux/wordpart.h=
>.
> If a new C file includes <kvm/arm_psci.h> without first including those
> dependencies, it looks like it could trigger a build failure.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.20=
21516-1-fuad.tabba@linux.dev?part=3D4
