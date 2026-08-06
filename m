Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54051465B4
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012165; cv=none; b=euQn68Fic6R0h4lM3WWq2WOuJxJuibdqrPNg2dzvoToMDUMYFHIMQ9uJ/gNfJejLaCoAAifSs2MeL5j2UaOmZLiTt+3TA80av5aLGxwwwsywBn4m7pmyLv2tBVXzt7q05sLGSFC+WBgz05IUTiGvqKWz6NU7WgK6EQFl34y4l9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012165; c=relaxed/simple;
	bh=NvBICakGyQH9sHFyfR7Q9JnnLoE+3m+jSLiUuDst1rU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RkHRBtKUx6aPfSLL8BhNRwiK66LOyt0PKk7RTKhtzqHyjN1Sf7djWfgxkxT2OtUUuENQDQ4Z4zbD7WLU/yYm36cORI7/YDYpN6UOlMMMnpzDaFogP7h3uwrg6DDp2weVXosR59v9cZvJ3+J3O5BE7gZUiccayKZXj6uvgWwFYsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sa7UUMFI; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sa7UUMFI"
X-Gm-Message-State: AOJu0YwTe/pjckVxaO5BfYxB9i6r0u5QocqEl9ziN+oFmbjYN62G98ki
	2XK4nPaAMEQ7g44U3W6OGPg2+C38KSJQ1nzEnvcDzmqw+bTuikpWw3kNkSa527rmOXD34dhCPcH
	YOCXFzrrpI4lXfvmAuBHBB5jy9yvKuZmp88e7H06f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gyHIAEcc7EYTchvF4v8OZJwBj28xxsDIlJxCAeS0PE=;
	b=Sa7UUMFIOTkKW+in+m3hRHB8nAcqiT53+wjZh2dwHjmBNcTsjcjHiUSrOfdJk+iL4olHnv
	MWWv2QV/REDFQ9G0uLoqWRTDbLOpwAif+dLSexTHZTJNLl6yy8ssWQvxpS+wg21pAOXpwq
	1C+RJYegJr5sR7gm1YL+POr0j1SvJrE=
X-Received: by 2002:ac8:7d51:0:b0:50e:5eba:cadd with SMTP id
 d75a77b69052e-52cfbdba534mr16532461cf.2.1786012140284; Thu, 06 Aug 2026
 03:29:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260806100256.371164-1-fuad.tabba@linux.dev> <20260806100256.371164-4-fuad.tabba@linux.dev>
 <20260806101600.207261F000E9@smtp.kernel.org>
In-Reply-To: <20260806101600.207261F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 6 Aug 2026 11:28:23 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxNyzw_t++nF66zocB2de5ZKwtAN4M9jj69VU457OEMFA@mail.gmail.com>
X-Gm-Features: AUfX_myF3cUgFTKnFOFo1bCqRsxQ978TfYpZmRtSvsYce4mJ1A2qgiTqTisJreM
Message-ID: <CA+EHjTxNyzw_t++nF66zocB2de5ZKwtAN4M9jj69VU457OEMFA@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] KVM: arm64: vgic: Do not access the GICv5 CPU
 interface from EL1
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Thu, 6 Aug 2026 at 11:16, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Missing Context Synchronization Event (CSE) after writing to SYS=
_ICC_ICSR_EL1.

This runs on the guest-entry path, and the ERET into the guest is a
context synchronization event.

I really thought we've covered this in the review-prompts, I'll look
into this later...
/fuad

> --
>
> --- Patch [3]: [PATCH v1 3/4] KVM: arm64: vgic: Do not access the GICv5 C=
PU interface from EL1 ---
> commit 5b0cdbb37754741e9006b6abdf408b239ed6b887
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: vgic: Do not access the GICv5 CPU interface from EL1
>
> This commit fixes an issue where the GICv5 CPU interface was incorrectly
> accessed from EL1 on systems without FEAT_GCIE_LEGACY. It restricts GICv5
> access to VHE, similar to the existing GICv3 handling.
>
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > index 74bace10a22ed..df58c0042ed63 100644
> > --- a/arch/arm64/kvm/vgic/vgic.c
> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -1042,11 +1042,15 @@ static void vgic_flush_lr_state(struct kvm_vcpu=
 *vcpu)
> >  static inline bool can_access_vgic_from_kernel(void)
> >  {
> >       /*
> > -      * GICv2 can always be accessed from the kernel because it is
> > -      * memory-mapped, and VHE systems can access GICv3 EL2 system
> > -      * registers.
> > +      * GICv3 and GICv5 drive the CPU interface through EL2 system
> > +      * registers, so only VHE reaches them from the kernel. GICv2 is
> > +      * memory-mapped and always reachable.
> >        */
> > -     return !static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif=
) || has_vhe();
> > +     if (kvm_vgic_global_state.type =3D=3D VGIC_V5 ||
> > +         static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
> > +             return has_vhe();
> > +
> > +     return true;
> >  }
>
> While reviewing the GICv5 access paths related to this change, I noticed =
a
> related issue in the GICv5 context restore path:
>
> arch/arm64/kvm/hyp/vgic-v5-sr.c:__vgic_v5_restore_state() {
>     write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
> }
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does this write to
> SYS_ICC_ICSR_EL1 require a subsequent isb() instruction?
>
> According to the ARM64 KVM architectural rules, any write to an ICC_*_EL1
> register (excluding ICC_PMR_EL1) must be immediately followed by an isb()
> as the very next instruction.
>
> Because __vgic_v5_restore_state() writes to SYS_ICC_ICSR_EL1 and then
> returns, the caller will execute subsequent instructions without a Contex=
t
> Synchronization Event. Could this leave the CPU operating with an
> architecturally undefined pipeline state during the vCPU switch?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806100256.37=
1164-1-fuad.tabba@linux.dev?part=3D3
