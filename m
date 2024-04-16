Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ACC12882C
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 13:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713273052; cv=none; b=GKeB5WbaaxUD6uRPJwG6eT/1epCOcSsjJ1QKddL0Kcidmkig8DbNQ7rO5lKpm7Hdn3SLQON6tkq7wLhZuvKCie3ZKAUSfSamLIruDdLeAmIAsFiod6Qg85xeZEqDmZmxH9HF2cCslZxHKdzDwtTc2y8ArXhr1IwiXQkzzzsW1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713273052; c=relaxed/simple;
	bh=6M1TALLEsKbuo3KvOC+g+YnPnr5DsUh17rXR08l16bQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JK46YoL0ObaBRxr3DV2YhIm9NWHCh+DCNRLOD9viZRGWMKOlGcvR7F9d7t8bjU6WNyvsJOVWbZiA6t3RU6R0+CVdqURrwmikE/OqVwPXatCy83RmzP/Auig8MBwEreDUHtNQSB30Y+2PB51qX2LR4y1Slr94W3iGJnbKLlIo3F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H20ll64G; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H20ll64G"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5acb90b2a82so1165507eaf.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 06:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713273049; x=1713877849; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qhhTkQAPd3xbrVsKWbGU0r0hTAz7SJQw81vjpXotfQ=;
        b=H20ll64G6lTAB36Jv9QsgnRKrg13WLDZQVERC6cS1QDXFumyzqdJ9VBI4KJRzGuG1+
         VUS1MOlwK9A/rMJ0jGbar3EuExgdGy3++mWfpdITroB241jqGNeiyiSqn5RXU1QiSC1b
         QGU/TfaVXGIMjRyoxwj+1yCBi1w1tT5Do9j8Hhco93zq4JvpIGpCMpNIVXIbKWC1o5gK
         jUq1lkMOukWnJuO1iBtGg6lSdfIYHQ47EIZyZxSMIueNNWSriN4U7qer2xKV9AX5Imt1
         w/sZ7Gt/vpEsMm9NMNb/gfAm3MN59lW4u0C8v0Zo2Kd1JcKz5FeAG61RahmPZ2MvQziy
         CMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713273049; x=1713877849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/qhhTkQAPd3xbrVsKWbGU0r0hTAz7SJQw81vjpXotfQ=;
        b=L7OqB7skGDFzELuxyKtOhlvz0tshRtzajNz5o87TgTUYjxOhA6/7hg8IBkNKUC7Wqh
         K/Uahj3u7RtsuAVIxW8Fa48yAIaotsEpvgCIDLZebEsUKgLU7fxBIdlJWbU1r7zSnzPD
         xuwyqZBgg3KUc1mcLHGZVZ4Vw+IwRSEQKxe2cjCLFKHXYws16fqEdUR5/LZmKg3UdHev
         GylADSbyW1uAHrGHXVawLuCwQBfQPzgWXBBrkuHCb4epVTjcv8qHVy7cZbcKEhdgcIVN
         AvsPyl79gHt3frb1MlhcPm7R71dozAJHsCXuJ5NsrIQK1IB5OPZWSqJ/1deuDC2TPcHl
         XtAQ==
X-Gm-Message-State: AOJu0YzXkgfAVpw7hpko4+/MYIWqR1ZfKyLIGf7inA6qBFZcBOmyTwKU
	aKrQsEZsN6jhNfBl1vSPza9F2qxP8F8I74zhaMsnnrW7nfc5bydibS7nMGb/UmRHd1h3xExnPoZ
	bv0VmlynIGAnIEehIp2IcxBu2a2TgUjddVXrp
X-Google-Smtp-Source: AGHT+IEajhdH7g3gMJfuMKmwRlhn/Z1Czl3NMulOldVD2dvhyTobjnDNxrZLJnCFOQnFZ9ECHnefH/UNHCgaEJS5SMQ=
X-Received: by 2002:a05:6358:690d:b0:183:86c4:75d0 with SMTP id
 d13-20020a056358690d00b0018386c475d0mr15026367rwh.8.1713273049408; Tue, 16
 Apr 2024 06:10:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com> <20240416095638.3620345-2-tabba@google.com>
 <861q75sc13.wl-maz@kernel.org> <86zfttqwu0.wl-maz@kernel.org>
In-Reply-To: <86zfttqwu0.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 16 Apr 2024 14:10:12 +0100
Message-ID: <CA+EHjTxkqt4gtxgLuQeXUAY6-YvaY+2MrD_wFJJet_BTU7TeWA@mail.gmail.com>
Subject: Re: [PATCH v2 01/47] KVM: arm64: Allocate per-cpu memory for the host
 fpsimd state in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Apr 16, 2024 at 2:08=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Tue, 16 Apr 2024 13:54:48 +0100,
> Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Tue, 16 Apr 2024 10:55:52 +0100,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > Allocate a per-cpu fpsimd_state to store the host's state when in
> > > protected mode. Since the host_fpsimd_state pointer has been
> > > excluded from kvm_vcpu_arch, no memory has been allocated to
> > > store it in protected mode, and its value hasn't been set.
> >
> > Why do we need this? The EL2 already has its own private host state,
> > which has a full FP state already.
> >
> > On non-pKVM, we save the host's view directly into the process
> > state. Obviously, we can't do that with pKVM. But we can absolutely
> > use the host context for that, and we shouldn't need any extra
> > allocation.
> >
> > > Fixes: 51e09b5572d6 ("KVM: arm64: Exclude host_fpsimd_state pointer f=
rom kvm_vcpu_arch")
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
> > >  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 18 ++++++++++++++++++
> > >  arch/arm64/kvm/hyp/nvhe/setup.c        |  1 +
> > >  3 files changed, 20 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/=
hyp/include/nvhe/pkvm.h
> > > index 82b3d62538a6..20c3f6e13b99 100644
> > > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > > @@ -54,6 +54,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_v=
cpu)
> > >  }
> > >
> > >  void pkvm_hyp_vm_table_init(void *tbl);
> > > +void pkvm_host_fpsimd_state_init(void);
> > >
> > >  int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> > >                unsigned long pgd_hva);
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe=
/pkvm.c
> > > index 26dd9a20ad6e..16ccb69e6479 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > @@ -18,6 +18,14 @@ unsigned long __icache_flags;
> > >  /* Used by kvm_get_vttbr(). */
> > >  unsigned int kvm_arm_vmid_bits;
> > >
> > > +/*
> > > + * Host FPSIMD state. Written to when the guest accesses its own FPS=
IMD state,
> > > + * and read when the guest state is live and we need to switch back =
to the host.
> > > + *
> > > + * Only valid when guest_owns_fp_regs() is true.
> > > + */
> > > +DEFINE_PER_CPU(struct user_fpsimd_state, host_fpsimd_state);
> > > +
> > >  /*
> > >   * Set trap register values based on features in ID_AA64PFR0.
> > >   */
> > > @@ -247,6 +255,16 @@ void pkvm_hyp_vm_table_init(void *tbl)
> > >     vm_table =3D tbl;
> > >  }
> > >
> > > +void pkvm_host_fpsimd_state_init(void)
> > > +{
> > > +   unsigned long i;
> > > +
> > > +   for (i =3D 0; i < hyp_nr_cpus; i++) {
> > > +           per_cpu_ptr(&kvm_host_data, i)->fpsimd_state =3D
> > > +                   per_cpu_ptr(&host_fpsimd_state, i);
> > > +   }
> >
> > I'd expect this to be instead:
> >
> >       for (i =3D 0; i < hyp_nr_cpus; i++)
> >               per_cpu_ptr(&kvm_host_data, i)->fpsimd_state =3D &(per_cp=
u_ptr(&host_host_data, i)->fp_regs);
> >
>
> The astute reader will have noticed that this should actually be:
>
>         for (i =3D 0; i < hyp_nr_cpus; i++)
>                 per_cpu_ptr(&kvm_host_data, i)->fpsimd_state =3D &(per_cp=
u_ptr(&host_host_data, i)->host_ctxt.fp_regs);
>
> Everything else still stands for at least another 5 minutes.

:D

Yes, I was about to reply with that. The reason I went with the static
allocation is that I missed it, being hidden behind another level of
indirection.

Either way, you're right. I'll fix this on the respin.

Thanks,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
