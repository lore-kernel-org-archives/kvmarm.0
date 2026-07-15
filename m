Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9D941F35C
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107159; cv=none; b=f+ftFpYniw0IKQ9ABpLX1gYFtkk1mICzyTIp7BdE2t2LS77eFhBqoQ4QsGCjOIqJpFGjdOu4g5/PbA+pZYFIu0l7Tx/Zzlcn5aSssYACDbV+DiLhYHEK1mBDYr5AtVtHbI0bSxqTENta08slvpprTRGH9Dw3j4wFOBqwK6NXG44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107159; c=relaxed/simple;
	bh=E4zDmmpmeZaORO/vPb3fiEfTwfrYdFUlhgjCMr17hwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tih+DbMwnXYAqfLc8gjUx3jvGQQtqYMRfhNSWxn9ehQ8QfgC/gjwQwCsVhAXXRxY+Yj16KPDUgZdQ8VYC7UWnfd4cfb9MPfvSGJ1d0cyrDTVuuUl81LKOQSINMaS6d2nx/vYeuWQvuLvX/rQuWokgoInPDmtXuKSr5pZNJIX/x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S/xW8Rhg; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S/xW8Rhg"
X-Forwarded-Encrypted: i=1; AHgh+RqERa7kHBjtczzqLagZuwIbEY1l9C6n7FMLErkBGXpxxOyrmQeDPG11FrG3yYsfufmUoKl32TI=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784107152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rjn1CF6e23GD6w9GNHyPRfdKmhPZEOpgmcfSe8x/Z7Y=;
	b=S/xW8RhgV4XeGrJEE+qYfpMdqNqhRoxu2X/xUUtxI9J0h+U0mB4lLq4e4hAXhIA2NYlw9V
	mWmPIWwfwhiU+p1FLYtkus4FkHTi25Hcx5JtQnFZu2UEW4wy/t0jl0u6wx2Blq9/xr99GP
	cNYNqBu/gYkk2Ih4XohBaaNrpC7gXLs=
X-Gm-Message-State: AOJu0YyibIqlHi/tW+ULqkna22yk+P37JX7Z3WgQEVdv45+N2tcVIh9b
	3lUcMVY4bTBXGPu/PN07vdE+5xBbgKE5X8xHuZApyLogvxoO/T0ZYSz//FYrCrA4FFnmiv47JkS
	dw74c+5lYfaqzSFzcqoprzGbasgMar9ej5x77z+d9
X-Received: by 2002:a05:622a:53cb:b0:51c:ba4f:9d14 with SMTP id
 d75a77b69052e-51d7bd70c65mr25990601cf.17.1784107149447; Wed, 15 Jul 2026
 02:19:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260715081238.1891918-1-fuad.tabba@linux.dev>
 <20260715081238.1891918-7-fuad.tabba@linux.dev> <20260715083708.68D2A1F000E9@smtp.kernel.org>
In-Reply-To: <20260715083708.68D2A1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 10:18:32 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwWUCHfPuiO3cJD4KAqNq_LvPotRiaABqUmfK08EmKOyQ@mail.gmail.com>
X-Gm-Features: AUfX_mxdMLfioSdsNDXgzAuLNv3ySH5AAzK1PAR-zfK_ZUTlW3ycQsl3sgu-zFU
Message-ID: <CA+EHjTwWUCHfPuiO3cJD4KAqNq_LvPotRiaABqUmfK08EmKOyQ@mail.gmail.com>
Subject: Re: [PATCH v6 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Wed, 15 Jul 2026 at 09:37, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] handle___vgic_v3_save_aprs silently overwrites host modification=
s to vgic_vmcr with a stale value.
>
> Pre-existing issues:
> - [Critical] The patch addresses the host-pointer trust vulnerability for=
 GICv3 but leaves the identical vulnerability open for GICv5.

Both already covered:
https://lore.kernel.org/all/CA+EHjTyGULmVCgyoya3bXG4gRj0OYFE1gnJLhNE6kvCrZF=
tXyQ@mail.gmail.com/

/fuad



> --
>
> --- Patch [6]: [PATCH v6 6/8] KVM: arm64: Minimise EL2's exposure of host=
 VGIC state during world switch ---
> commit d47381d6be1828e59e8906a9d69d3c104d673dc3
> Author: Marc Zyngier <maz@kernel.org>
>
> KVM: arm64: Minimise EL2's exposure of host VGIC state during world switc=
h
>
> This commit modifies the world switch to stop EL2 from dereferencing the =
host's
> vgic_v3_cpu_if pointer wholesale. It copies only vgic_vmcr and active pri=
ority
> registers to the hyp-side state.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 45d717889f6ea..f3233ee343a39 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -508,16 +520,63 @@ static void handle___vgic_v3_init_lrs(struct kvm_=
cpu_context *host_ctxt)
> >
> >  static void handle___vgic_v3_save_aprs(struct kvm_cpu_context *host_ct=
xt)
> >  {
> > -     DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> > +     struct pkvm_hyp_vcpu *hyp_vcpu;
> > +     struct kvm_vcpu *host_vcpu;
> >
> > -     __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> > +     host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1=
,
> > +                                                        &hyp_vcpu);
> > +     if (!host_vcpu)
> > +             return;
> > +
> > +     if (unlikely(hyp_vcpu)) {
> > +             struct vgic_v3_cpu_if *hyp_cpu_if, *host_cpu_if;
> > +             int i;
> > +
> > +             hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> > +             __vgic_v3_save_aprs(hyp_cpu_if);
> > +
> > +             host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> > +             host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;
>
> [Severity: High]
> Does this assignment overwrite host modifications to vgic_vmcr with a sta=
le
> value?
>
> When userspace modifies a VMCR field (like SYS_ICC_PMR_EL1) via
> KVM_SET_ONE_REG, the execution flow modifies the host state:
>
> kvm_vcpu_ioctl()
>   vcpu_load()
>     handle___vgic_v3_restore_vmcr_aprs()
>   // ioctl modifies host_cpu_if->vgic_vmcr
>   vcpu_put()
>     handle___vgic_v3_save_aprs()
>
> Since __vgic_v3_save_aprs() does not read ICH_VMCR_EL2 from the hardware,
> hyp_cpu_if->vgic_vmcr contains the old value. Does copying it back to
> host_cpu_if->vgic_vmcr here cause the userspace changes to be lost?
>
> > +             for (i =3D 0; i < ARRAY_SIZE(host_cpu_if->vgic_ap0r); i++=
) {
> > +                     host_cpu_if->vgic_ap0r[i] =3D hyp_cpu_if->vgic_ap=
0r[i];
> > +                     host_cpu_if->vgic_ap1r[i] =3D hyp_cpu_if->vgic_ap=
1r[i];
> > +             }
> > +     } else {
> > +             __vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> > +     }
> >  }
> [ ... ]
>
> [Severity: Critical]
> This is a pre-existing issue and was not introduced by the patch under re=
view,
> but does the same pattern remain open for GICv5?
>
> Looking at handle___vgic_v5_save_apr():
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_save_apr() {
>         DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
>         __vgic_v5_save_apr(kern_hyp_va(cpu_if));
> }
>
> And similarly in handle___vgic_v5_restore_vmcr_apr():
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v5_restore_vmcr_apr() {
>         DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
>         __vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
> }
>
> Since these handlers apply kern_hyp_va() to an untrusted host pointer wit=
hout
> validation, and kern_hyp_va() is idempotent for already-hyp-tagged pointe=
rs,
> could a malicious host provide a pointer to EL2 private metadata?
>
> Could this allow the host to arbitrarily read or write EL2 memory?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715081238.18=
91918-1-fuad.tabba@linux.dev?part=3D6
