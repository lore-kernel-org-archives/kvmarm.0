Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0907E3ED5C9
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 09:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649931; cv=none; b=HX5YNGrfjO9YEIlDLOOHvFKKUMalMee/9aFTP+WucV0fyX/qvYr82NCzqkAXo0RLetf1uZbb5VALXpkGeklNPyTGxZTFR0LYL1XK42r+ubrlHFPWPZ41icqD2FHQ7SB2a0HcX7BtR+fLP+lIDV7yIkq6nDQgIz0mweB0hPDXG3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649931; c=relaxed/simple;
	bh=Me0T5+G6GU+yqK+pfWnftzQNd1qwsvqsRERpiPzCgCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N4FCYdTTieSGV+2+bAi+vC7anmfoE7RmucPRlcf1PMy7Y6fkt3bsm6fsGktzpSzFGQhen9g3QR8wNewRm9OF+nE/qyUktxpPLE54mDl2Pu3CboVwyGhsbw8INw44Og2fnDB5rhQ4t/kBSbn3u3neW4U65aI+iZy2ENJEfZJDG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g2X8Vm5S; arc=none smtp.client-ip=91.218.175.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g2X8Vm5S"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Me0T5+G6GU+yqK+pfWnftzQNd1qwsvqsRERpiPzCgCs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787649926; v=1; x=1788254726;
 b=g2X8Vm5S/s+oY5jmdjJ+t0z/kNVLF6BpmR1Sr2bdVQlTfUNJfE/pvwCR1m01RipsihuQX+Oc
 T9OOJa5PyAhxrNYwmwiGkCHlVjUwv9k7iq58aJ7x5zpDEpVQt6OEmnU9Pozw83TawKMkMBALwGf
 swjhUA1NhEewwhUTPbsXn3B0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f53.google.com (209.85.167.53)
	by smtp.migadu.com with ESMTPS id 9b2543b749726899;
	Tue, 25 Aug 2026 09:25:26 +0000
X-Mizu-Trace-ID: 9b2543b749726899
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b2a8173142so969e87.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 02:25:26 -0700 (PDT)
X-Gm-Message-State: AFuF++manJX4uTNVRtF3toeR5KxYP0NO63F+sFfzUhOuLWooFyOLfJr3
	VetLsrcW24lbaG1TWqdJUtfHR4VObqssv8boHg7K7f8xILenSPwRWylz0pLR9m2J4Rsj8x4Hxnj
	kBHj4tfE3plQyhwTicJskCRdgWi7qTe2hLPhhpadg
X-Received: by 2002:a05:6512:3ca1:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b49ddd8905mr67230e87.0.1787649925547; Tue, 25 Aug 2026
 02:25:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260825085948.1674721-1-fuad.tabba@linux.dev>
 <20260825085948.1674721-3-fuad.tabba@linux.dev> <20260825091816.F361E1F00A3A@smtp.kernel.org>
In-Reply-To: <20260825091816.F361E1F00A3A@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 25 Aug 2026 10:24:49 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw8wN-MgXXsYr0GtOUWJZ5=25GofefuDjqKfF3b5P4uaQ@mail.gmail.com>
X-Gm-Features: AcwNN1Xjr3NXNfeX6K1obDu2zEHXIEui6hZzl_xWAkvM-wr4YjqGEMNUSRhqSAY
Message-ID: <CA+EHjTw8wN-MgXXsYr0GtOUWJZ5=25GofefuDjqKfF3b5P4uaQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: arm64: Do not clear VM-wide SVE feature on vCPU
 init failure
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Aug 2026 at 10:18, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Hypervisor DoS via WARN_ON() upon page table allocation failure

Nope [1]

[1] https://lore.kernel.org/all/CA+EHjTyPxcObTOwi25QTUDbLwAYaKnWY0QJVB_aMso=
2=3D38PJUg@mail.gmail.com/

> --
>
> --- Patch [2]: [PATCH 2/4] KVM: arm64: Do not clear VM-wide SVE feature o=
n vCPU init failure ---
> commit 1188c411e2a65143d7371d1038c2752c0f2de6c0
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
>
> pkvm_vcpu_init_sve() clears KVM_ARM_VCPU_SVE in kvm->arch.vcpu_features
> when it fails, but vcpu_has_sve() tests KVM_ARCH_FLAG_GUEST_HAS_SVE,
> which is left set. Later vCPUs on that VM then skip the SVE setup and
> register with a NULL sve_state, which the guest's first FP access hands
> to sve_load_state().
>
> Return the error without touching vcpu_features.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index c31b9d46b8b60..4340b13ee295b 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
>
> [ ... ]
>
> > @@ -462,24 +462,19 @@ static int pkvm_vcpu_init_sve(struct pkvm_hyp_vcp=
u *hyp_vcpu, struct kvm_vcpu *h
> >       sve_max_vl =3D min(READ_ONCE(host_vcpu->arch.sve_max_vl), kvm_hos=
t_sve_max_vl);
> >       sve_state =3D kern_hyp_va(READ_ONCE(host_vcpu->arch.sve_state));
> >
> > -     if (!sve_vl_valid(sve_max_vl) || !sve_state) {
> > -             ret =3D -EINVAL;
> > -             goto err;
> > -     }
> > +     if (!sve_vl_valid(sve_max_vl) || !sve_state)
> > +             return -EINVAL;
> >
> >       sve_state_size =3D sve_state_size_from_vl(sve_max_vl);
> >
> >       ret =3D hyp_pin_shared_mem(sve_state, sve_state + sve_state_size)=
;
> >       if (ret)
> > -             goto err;
> > +             return ret;
>
> [Severity: High]
> This is a pre-existing issue, but can the call to hyp_pin_shared_mem()
> trigger a hypervisor panic if EL2 memory is exhausted?
>
> Looking at hyp_pin_shared_mem() in arch/arm64/kvm/hyp/nvhe/mem_protect.c,
> it wraps the mapping allocation in a WARN_ON:
>
>         if (p->refcount =3D=3D 1)
>                 WARN_ON(pkvm_create_mappings_locked((void *)cur,
>                                                     (void *)cur + PAGE_SI=
ZE,
>                                                     PAGE_HYP));
>
> At EL2 under nVHE/pKVM, WARN_ON() expands to a BRK instruction which pani=
cs
> the hypervisor and brings down the host.
>
> Since host userspace can repeatedly invoke KVM ioctls to create VMs or vC=
PUs
> and exhaust the bounded EL2 memory pool, pkvm_create_mappings_locked()
> might eventually fail and return -ENOMEM.
>
> Does this allow an unprivileged host process to hit the WARN_ON and crash
> the host system?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825085948.16=
74721-1-fuad.tabba@linux.dev?part=3D2
