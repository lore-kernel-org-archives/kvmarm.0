Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6020C2701B6
	for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 11:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764154887; cv=none; b=HbY77203JH1v08LvtvIzlnlzJzB6bh20pz4Ly9XILwZL212mcTiM7iY39L8RowzEFlGQt+pk2KAAeMnGVOGd0TNxc+P/R0MjNML8lTmX0R7fq43E/nUW3tGXh/m2g2+d3HYYNmi3ZAoTyX106q8hlzow0RmzOyagkhtWF6P5kOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764154887; c=relaxed/simple;
	bh=uY9owOb2xofGtrtx5SQr6m/Fe0Au+tMZ4uy08qe82jk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AYqYDUl19iGJhF4/AbaEwIxcneZd0bEzsqXApuRCRfh5GehGw6e0uh3N18F8PQFOAD89xb74mDjXvF8PJQPWqujfOcaZ5EZYmx/j8cE9kpwyFwlD9jfh7SZsyPzr/Yk3DKOXUCsqLWdQDPVbSC8YegM1EjEUEL+J54y5HOYsRKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MXH2K/p; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MXH2K/p"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4edb8d6e98aso326081cf.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Nov 2025 03:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764154884; x=1764759684; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J+3L7npYoMe72LZAqOf/QcGS609azhf8MHMKeVgv2t0=;
        b=4MXH2K/pyzA2RhWNl/o9B2OkEcelJkK6Z2hqzSiojjjLw+9K//Uq9iRlIgzsQgQo41
         EsMv3OfN7+DoRgtGU8s0TwFc5gF0ip8Y8orLgGKg0XuulCAqfaQo9+yPCb4+O4IANthO
         iaR8hwUzH3d7GsaBlhfI9EDeF9Qy7oJ8P0W/I7PVNwflIyjD7Zs5OpPFn0RKzobbTIj+
         ElefTjepQzrMexaxvCKTwNb8XXyuFEfZfLsxfmvp9oX3HTQydde9eevqFMxvXzBDAyDD
         /v30bMZ/kD3JsLRMtlFjYEob+D3gI8fV/EtDKxNbNltDR6sYm2LJ5XAHeRr1P2D/dxMm
         1CBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764154884; x=1764759684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+3L7npYoMe72LZAqOf/QcGS609azhf8MHMKeVgv2t0=;
        b=cdo9TdNGlxsrwXvV6MSb7Ubt5ttyw+UuP5rl85JEn+s5i0sMmcmF32jBjFfiuy/ytO
         FRej1OA8W69nr/7jmGO/GT7LHRpDVIgGO+dnSoEu5HWUH6U7Rh1s38askXGptR49OvWM
         ZFq2/TI6+4+0ZwiUhPNSW/hG5MX+jAXDmt13aDHTowD8IJdSmNshwEycBwmFFE4lwRG4
         MKGa9fwdjG1srdEaCAoXn3u7ZV03oO/Mni3ap43Ph6IUQg9aJ1pSqjQUE2ERQYTC9oQY
         r8Qiic6dhdWTkcMaHsKFHSbsdU1ccMcqK0YvxuTnD5M85DSJ1spsoBAaeBvNH2jXW3y8
         jw/A==
X-Gm-Message-State: AOJu0YxlDvX1u+GmKnSuwt6gHPeBGDyxoYXPvHMTmzb/Kn8R5SrqvR9u
	GxN+W9xI1GeRhZkyUAOHs3TZaK9OStNl2fYrw27szkyKeAtnOQReKdVEELSRbEcSg9A0TUtn5+o
	e0vmGY+1ZvuIEUnPRpdd2QY/nyFUzGRkeIL+GKnoL
X-Gm-Gg: ASbGnct1xfCx0AXw4y0bCYGQpz/fvietJwSQZw26nZMAq6GgoJj/Y/nxIYrmHEf0uk8
	9aXqbcnzNs1roI3RulLmPN/2wvh157uXfmjUiMtcvw5kNzWHHrmXYxMAjCfUXemdsoCsafUlLsz
	WayS6w9nb4lboV8K+/W5tR+Z9u9K3hk6dgz30Bauk20EMgwHyduDu2T6Eet/+yxjkYpzUHJ1GmH
	zWUy/EG9RiYCwIIRwr9y+zlrwlYmKcsLWmypIpbGwfSaNMPka8YJc6EGVlakXLvlzmGxCEegmQJ
	745vt9LX8SuF5F45wrf/An4U
X-Google-Smtp-Source: AGHT+IGg8KtTFQs3f5lkDPEQIA1agApY+VFbSfmaMCBg+p4yvM2Tz8ctiRXqArvH+h7g2HfrS6qrMI4+M4gDyc1CPvk=
X-Received: by 2002:a05:622a:1496:b0:4ed:b665:3779 with SMTP id
 d75a77b69052e-4efc6c8b73bmr3738061cf.16.1764154883809; Wed, 26 Nov 2025
 03:01:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251118103807.707500-1-tabba@google.com> <20251118103807.707500-6-tabba@google.com>
 <867bvdqd4m.wl-maz@kernel.org>
In-Reply-To: <867bvdqd4m.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Nov 2025 11:00:47 +0000
X-Gm-Features: AWmQ_bnId5eaZtSND4q_YYjMzwsJNTvFSJeX_rFs9ffPKuakqZ-zcAPUa1IB4is
Message-ID: <CA+EHjTxPxscVZryCoVAZYebgD82waEKiv0Z-CFG6H+CW3dAbXQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/9] KVM: arm64: Include VM type when checking VM
 capabilities in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vladimir.murzin@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 26 Nov 2025 at 10:53, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 18 Nov 2025 10:38:02 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Certian features and capabilities are restricted in protected mode. Most
> > of these features are restricted only for protected VMs, but some
> > are restricted for ALL VMs in protected mode.
> >
> > Extend the pKVM capability check to pass the VM (kvm), and use that when
> > determining supported features. Moreover, extend the check to disallow
> > MTE for all VM types in protected mode.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_pkvm.h | 10 ++++++----
> >  arch/arm64/kvm/arm.c              |  4 ++--
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c    | 10 +++++-----
> >  3 files changed, 13 insertions(+), 11 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
> > index 08be89c95466..7195be508d99 100644
> > --- a/arch/arm64/include/asm/kvm_pkvm.h
> > +++ b/arch/arm64/include/asm/kvm_pkvm.h
> > @@ -23,10 +23,12 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm);
> >  int pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu);
> >
> >  /*
> > - * This functions as an allow-list of protected VM capabilities.
> > - * Features not explicitly allowed by this function are denied.
> > + * Check whether the specific capability is allowed in pKVM.
> > + *
> > + * Certain features are allowed only for non-protected VMs in pKVM, which is why
> > + * this takes the VM (kvm) as a parameter.
> >   */
> > -static inline bool kvm_pvm_ext_allowed(long ext)
> > +static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
> >  {
> >       switch (ext) {
> >       case KVM_CAP_IRQCHIP:
> > @@ -43,7 +45,7 @@ static inline bool kvm_pvm_ext_allowed(long ext)
> >       case KVM_CAP_ARM_PTRAUTH_GENERIC:
> >               return true;
> >       default:
> > -             return false;
> > +             return !kvm || !kvm_vm_is_protected(kvm);
>
> I find this expression a bit unreadable. IMO it would be better if
> written as:
>
>                 return !(kvm && kvm_vm_is_protected(kvm));

Will change.

> which makes it "clear" that you claim to support everything when
> either kvm == NULL or described an unprotected VM.
>
> But it then begs the question:
>
> - in what circumstances is kvm == NULL? Is there any case outside of
>   kvm_vm_check_extension()?

kvm_vm_ioctl_check_extension() could be called without a VM. In which
case, we don't know if the check is for non-protected or protected.
This patch doesn't change the behavior of this part.

> - do you really support everything?

For non-protected, yes ... with the MTE caveat, which later patches fix.

> >       }
> >  }
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 870953b4a8a7..10d853f2722e 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -87,7 +87,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >       if (cap->flags)
> >               return -EINVAL;
> >
> > -     if (kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(cap->cap))
> > +     if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, cap->cap))
> >               return -EINVAL;
> >
> >       switch (cap->cap) {
> > @@ -299,7 +299,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >  {
> >       int r;
> >
> > -     if (kvm && kvm_vm_is_protected(kvm) && !kvm_pvm_ext_allowed(ext))
> > +     if (is_protected_kvm_enabled() && !kvm_pkvm_ext_allowed(kvm, ext))
> >               return 0;
>
> But that's a change in semantics here. Calling this function outside
> of the context of a VM (kvm == NULL) will now report that *ALL*
> extensions are valid, instead of limiting it to the allow-list.
>
> With that, userspace can no longer detect what is available and what
> isn't before creating a VM with the correct VM type.

This patch doesn't change this semantic, since this patch moves the
NULL check into kvm_pkvm_ext_allowed().

> I don't think this is the right way to do this, unless you really want
> to break the existing UAPI (rhetorical question).

I agree, but I don't think this patch changes this behavior. Later on
in this series we expand the check to apply to non-protected VMs to
also restrict features that are not allowed in protected mode in
general -- something that until this series we didn't have.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
