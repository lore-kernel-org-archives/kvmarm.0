Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EEA3D75AA
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 10:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048511; cv=none; b=bs/CV550lPQvQZOfGO6ihmf1yTnaVl7wdB5sVpUkPIrchpjbn3kV75CJXiwc85nNmNYwjkFVCq34fzcWRbwMSjp6hth9nYRjg0DoUoLPOROUqZIvPNOTuJHGS2OUgyOv4PCNUAyzWp6eCZDGl5R/0LnY2HMn0g/bHZUPVL8A36Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048511; c=relaxed/simple;
	bh=sEINk0SuzGmZfx49ENHguHS9kV8Gt5ZTS5C85FRtTzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WeiQ6EHm7x0H4jXrlyaeucPv6O2SWcSSQKVUf6WkixEi9AdrnxyIrosHXpRifpM1Y+oUQ72wYwJl33nKfPvIZzVaIy3khIEIVods9vIKCzSAfTqBPeb5WbODh/gE3rWqhVH3cwla1YIZsFcKZY9hUuq7M1kdbKoxpFOnArsPork=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XQ1H2adw; arc=none smtp.client-ip=95.215.58.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XQ1H2adw"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sEINk0SuzGmZfx49ENHguHS9kV8Gt5ZTS5C85FRtTzQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787048506; v=1; x=1787653306;
 b=XQ1H2adwcTHtv1NCAZhgeiKoyGBAWuvcyL1ERtC0gAqTo+Uo1/aq6J6qOcNXHAwS6wntfZkK
 Bu4kIyX70PoTFbOPmQ/L7mUTqlEFaR0VvGDuDXiu14ftAS32Z5UbWFwd6xkp+VEGfF7/L5V0k5k
 Uoj8YbjtJMTJGqOp3oaOW+kQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f42.google.com (209.85.167.42)
	by smtp.migadu.com with ESMTPS id 2fe7ebacf3917a64;
	Tue, 18 Aug 2026 10:21:46 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so5310e87.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 03:21:45 -0700 (PDT)
X-Gm-Message-State: AOJu0YwCnO33wSQ0TJuWIu5tzYpNWc7SDYX6W+hfh7o+1NAJPRSzu88g
	axv8aFBho22xYnl1rqdXHiz6u0gBSbto01AB95ym01Y15imZXWjOM86W7ZUwze199gi325517tF
	gPVV2v4eYp2qS5MkjBX5LmXo3EdtHLzX+5ZjN+Jfy
X-Received: by 2002:a05:6512:a84:b0:5b4:4c8a:abef with SMTP id
 2adb3069b0e04-5b471fcde42mr199081e87.10.1787048504871; Tue, 18 Aug 2026
 03:21:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260818093117.2379344-1-fuad.tabba@linux.dev> <20260818094305.828891F000E9@smtp.kernel.org>
In-Reply-To: <20260818094305.828891F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 11:21:00 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyPxcObTOwi25QTUDbLwAYaKnWY0QJVB_aMso2=38PJUg@mail.gmail.com>
X-Gm-Features: AcwNN1XBa4lu--DTS7FPE7UTplgkK7PvCaW-8GJz5zkY8XlBihkyJFzXTyTS3qg
Message-ID: <CA+EHjTyPxcObTOwi25QTUDbLwAYaKnWY0QJVB_aMso2=38PJUg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Aug 2026 at 10:43, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] A fallible memory allocation failure inside `hyp_pin_shared_=
mem()` triggers a `WARN_ON()`, which results in a fatal hypervisor panic.

It can't fail. hyp_s1_pgtable_pages() provisions the hyp stage-1 page
tables at init to cover all of memory at page granularity, so hpool
can always map any host page into the hyp linear map.

/fuad

> --
>
> --- Patch [1]: [PATCH] KVM: arm64: Validate the SVE vector length in pkvm=
_vcpu_init_sve() ---
> commit f011c5300d433db59b3f2b97e822b9e148c39b84
> Author: Fuad Tabba <fuad.tabba@linux.dev>
> KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
>
> This commit updates pkvm_vcpu_init_sve() to validate the host-provided
> SVE vector length before deriving its state size. This prevents an invali=
d
> length from reaching the sve_state_size_from_vl() macro and triggering a
> fatal EL2 WARN_ON().
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> [ ... ]
> > @@ -460,14 +460,15 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcp=
u *hyp_vcpu, struct kvm_vcpu *h
> [ ... ]
> > +     sve_state_size =3D sve_state_size_from_vl(sve_max_vl);
> > +
> >       ret =3D hyp_pin_shared_mem(sve_state, sve_state + sve_state_size)=
;
>
> [Severity: Critical]
> This is a pre-existing issue, but looking at hyp_pin_shared_mem(), could =
a
> memory allocation failure here trigger a fatal hypervisor panic?
>
> If host userspace repeatedly creates VMs and vCPUs to exhaust the
> hypervisor's memory pool, pkvm_create_mappings_locked() can return
> -ENOMEM.
>
> Because hyp_pin_shared_mem() wraps this fallible call in a WARN_ON():
>
> arch/arm64/kvm/hyp/nvhe/mem_protect.c:hyp_pin_shared_mem() {
>     ...
>     for (cur =3D start; cur < end; cur +=3D PAGE_SIZE) {
>         p =3D hyp_virt_to_page(cur);
>         hyp_page_ref_inc(p);
>         if (p->refcount =3D=3D 1)
>             WARN_ON(pkvm_create_mappings_locked((void *)cur,
>                                                 (void *)cur + PAGE_SIZE,
>                                                 PAGE_HYP));
>     }
>     ...
> }
>
> And since WARN_ON() is fatal at EL2, does this allow unprivileged host
> userspace to intentionally crash the host system if the allocation fails?
>
> >       if (ret)
> >               goto err;
> >
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818093117.23=
79344-1-fuad.tabba@linux.dev?part=3D1
