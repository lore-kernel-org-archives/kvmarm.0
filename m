Received: from out-189.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124493FCB2F
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 12:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786105069; cv=none; b=C5W3QQ4IO5gc/0Ujv16ev/bjMZ5PxYTLQaa7sRvkVAKQhbPWO4ijlTnY+7gFMYu/tSZqRoaBDFj0/LaTLfqrF+UQe8gLSHPCvAX8gNc3vgqup7ExMfSfquY4GiUDpDWXDE85LjOnxSTa4xUBTbxfdfFz5W5ISREmOwxXCQYx+mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786105069; c=relaxed/simple;
	bh=W986ze8G+q6u5g/R2QNTU3PWhFiawzQNSsUAcQG7Z7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FApC2UP3zFYlwayrMV1OOwTdVfhXytHx5IdAnAU58law8oUAjaRpn4SKZuXdLJlZrJm1U7YOCy4jee09R4Tb/tpxa3G7cEpYOI+R8R2oCbxHfQKhMuPXQweoj68RXfY1c/IwQoxK2/O4qTTUcwrKcWRgrjqkFnIvxowI/70Zefg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l3De+M3D; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l3De+M3D"
X-Gm-Message-State: AOJu0YzCh8+dnLx4y+Dp1iBbE69/1kfX+69dkmER7XUnqBdu9Btu28e5
	EzX0VmGqv3wNitWtMw4SN0yKnJA9rYqDmRK+kZEi+GqFX2Ao2ubMH4lsTvamsyQqty4yyjAnzII
	venclpjufPdBhdA7GWAZgFTcmZ5hFS3izPcmcbxfw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786105006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e60HI2csl/FvFgSPedUpviac4vF8aHpWa13WHMfWrMU=;
	b=l3De+M3DWMQ5W/oPlY7rTnwC0Md30gKrroYYDLgJ3OBhhRjNAXkoBtNLB6eBNUiYhKX2tk
	2W7vcl7oRvQzjHrcpoQ7z+i/5VkZU/XiSyui9iYRb4d4LyYIewiXcPP7K32K3IsdNxrxdF
	tTqV2a9v1ylmV4Ehc9zBQdtWxckvdhA=
X-Received: by 2002:a05:622a:9cc:10b0:51c:ad5:93be with SMTP id
 d75a77b69052e-52d1124b22bmr15716631cf.8.1786104988944; Fri, 07 Aug 2026
 05:16:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807104102.2410744-1-fuad.tabba@linux.dev>
 <20260807104102.2410744-3-fuad.tabba@linux.dev> <20260807105558.73D701F000E9@smtp.kernel.org>
In-Reply-To: <20260807105558.73D701F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 7 Aug 2026 13:15:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwVKkAwWUeMrF_m2-35kyhESqAezOKJy-Pj=vA3qE5Bjw@mail.gmail.com>
X-Gm-Features: AUfX_mx1YoX8ZV0-ZLrDmNofrTA9Elr7J11n5Lw6VJFj1kE-_aPeX7Mx5rJG-Yc
Message-ID: <CA+EHjTwVKkAwWUeMrF_m2-35kyhESqAezOKJy-Pj=vA3qE5Bjw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Don't leak the SPI array when
 init is retried
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, 7 Aug 2026 at 11:56, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:

No, thank _you_ Sashiko!

>
> Pre-existing issues:
> - [High] If `vgic_init()` fails after `vgic_v4_init()` succeeds, the VPE =
array is left allocated but `vgic_initialized` remains false. Userspace can=
 then create additional VCPUs and retry `vgic_init()`. The second `vgic_v4_=
init()` returns early because the VPE array is already allocated, leaving t=
he new VCPUs without initialized VPE IRQs.
...
> When a new VCPU runs, `vgic_v4_load()` calls `irq_set_affinity()` with an=
 uninitialized IRQ (0), which fails and triggers a host `WARN_ON`, causing =
a host-side denial of service.

This is a separate fix. But you're right about the state.
kvm_arch_vcpu_precreate() only refuses vCPUs once vgic_initialized()
is true, so the retry admits one the VPE array does not cover.

I don't think a VMM can drive it. kvm_vgic_setup_default_irq_routing()
is the only failure after vgic_v4_init(), and it builds its own
routing entries, so nothing short of a real -ENOMEM fails it.

The fix I have in mind keeps vgic_v4_init() idempotent, as this patch
is: return early only while the vCPU count is unchanged, rebuild when
it grew. That needs its_free_vcpu_irqs() to clear vm->domain and
vm->fwnode first, which it does not today, so its_alloc_vcpu_irqs()
can reach its error path with a domain it has already removed.

Let me think about it some more and I'll send something once others
have had a chance to digest this as well.

Cheers,
/fuad





/fuad

> --
>
> --- Patch [2]: [PATCH v2 2/4] KVM: arm64: vgic: Don't leak the SPI array =
when init is retried ---
> commit 11b9c8f9971b11e30ffc049a56071fafe4c7df73
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: vgic: Don't leak the SPI array when init is retried
>
> This patch fixes a memory leak where up to 960 struct vgic_irq could be l=
eaked
> if kvm_vgic_setup_default_irq_routing() fails and userspace retries
> KVM_DEV_ARM_VGIC_CTRL_INIT. It resolves this by returning early from
> kvm_vgic_dist_init() if dist->spis is already allocated.
>
> > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic=
-init.c
> > index 907057881b26a..d4cf143f3ae6b 100644
> > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > @@ -210,6 +210,9 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsi=
gned int nr_spis)
> >       struct kvm_vcpu *vcpu0 =3D kvm_get_vcpu(kvm, 0);
> >       int i;
> >
> > +     if (dist->spis)
> > +             return 0;
> > +
>
> [Severity: High]
> This is a pre-existing issue, but since the commit message mentions mirro=
ring
> the early return behavior of vgic_v4_init(), does that original function
> have a stale state bug on retry?
>
> If vgic_init() fails after vgic_v4_init() successfully allocates
> dist->its_vm.vpes, vgic_initialized remains false. If userspace then crea=
tes
> an additional vCPU and retries KVM_DEV_ARM_VGIC_CTRL_INIT, vgic_v4_init()
> returns early on the second attempt without allocating a VPE for the newl=
y
> created vCPU.
>
> When the new vCPU runs, vgic_v3_load() unconditionally calls vgic_v4_load=
().
> Because the VPE was never properly initialized for this new vCPU,
> vgic_v4_load() passes an uninitialized vpe->irq (0) to irq_set_affinity()=
:
>
> arch/arm64/kvm/vgic/vgic-v4.c:vgic_v4_load() {
>         ...
>         err =3D irq_set_affinity(vpe->irq, cpumask_of(smp_processor_id())=
);
>         ...
> }
>
> This fails with -EINVAL and triggers a WARN_ON in vgic_v3_load():
>
> arch/arm64/kvm/vgic/vgic-v3.c:vgic_v3_load() {
>         ...
>         WARN_ON(vgic_v4_load(vcpu));
>         ...
> }
>
> Could an unprivileged VMM repeatedly trigger this host WARN_ON by
> deliberately failing the first initialization and adding a vCPU before
> retrying?
>
> Is this something that should be addressed alongside or before this leak =
fix?
>
> >       dist->active_spis =3D (atomic_t)ATOMIC_INIT(0);
> >       dist->spis =3D kzalloc_objs(struct vgic_irq, nr_spis, GFP_KERNEL_=
ACCOUNT);
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807104102.24=
10744-1-fuad.tabba@linux.dev?part=3D2
