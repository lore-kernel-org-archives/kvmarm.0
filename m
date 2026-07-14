Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6B647B426
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 13:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784034328; cv=none; b=qPxoipAZoYkO1VuGz+C53WIVvAHBUDLtqdgqioIx8iaazoTC30vSRRhTK66CDeIB0bsu/IHUGg//Aobbcokt8DHvCXQ4XGpw1zg+ErY13pBhOraavuJeutxjn+i/y1ISvFvhq1/nPEUXH4jk8VgrBY6IOYOetDIacGRNJakyyR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784034328; c=relaxed/simple;
	bh=Pid4HPHuEVI5BTjms8jEZFNfwUSmNTjG2RzD1N+Dq34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vl0qMMgbG5c7onXfBwg7/88E3W2CKFA2DKJBfCaJAitXGeAet5b729XE693Fc7NbQHbQsbp7fgKRGdxcuYXWiewkh5cEP+7j5rAe6AviAB4rPIukakkth+8MV1VbcStoZj+XB1o/0UsoHYlsiw2e4gTfFiF5nHDOYxfd4uBz2j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V8bhEBVy; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V8bhEBVy"
X-Gm-Message-State: AOJu0YylKsAAQIMZxc3YDw7czSaen+lkZ9WSDyIN2tCAO6Xvy93N8IlY
	1KJ8i/zoNdHtmcUYzSi1lbKYYf6gxI0z10S1xvVx1ruQ28RUr5HmjR8SExcrLe/gxfElAcB8thL
	clMEY8hXttP0xlORk2Uvuap0AhHSHdLrTw5WzIYw6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784034323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2b0nYPQ7iFRKYC7l9DHkU7h83GGC5kCZO6o3BUUeAyI=;
	b=V8bhEBVyKKDqsx23OmLvA+GybpROL/PZABOggIWycbccugXCXQl0NXzQ+y+caDpvs/WdKS
	DWF9zgqblQNVC+ydAH8stmLu28HGc5rfUq29H0Mo6yBDB4vkljjAae0BcUvq6dHFJgxm2G
	9vkrYWPH6mDf6kJ9mZt2LLO8k4fqMmU=
X-Received: by 2002:a05:622a:4010:b0:517:5ac7:332e with SMTP id
 d75a77b69052e-51d7bc5040emr14294221cf.6.1784034290465; Tue, 14 Jul 2026
 06:04:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-8-fuad.tabba@linux.dev> <20260714122015.EDCB71F000E9@smtp.kernel.org>
In-Reply-To: <20260714122015.EDCB71F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 14:04:13 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx11sRDnH4XTMPREsMj6uX61=O7zqKk6=VAa+C4_2SLmw@mail.gmail.com>
X-Gm-Features: AUfX_myjEnFIfozSNQOOGekDYHsfc2WHKHyez5Ug6JOHDXind_qhJP1fx_Z6Rq0
Message-ID: <CA+EHjTx11sRDnH4XTMPREsMj6uX61=O7zqKk6=VAa+C4_2SLmw@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] KVM: arm64: Add primitives to flush/sync the VGIC
 state at EL2
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 13:20, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Missing its_vpe copy in flush_hyp_vgic_state breaks GICv4 virtua=
l LPI injection

pKVM has no vLPI, so  its_vm  is NULL either way; and  En  comes from
the copied  vgic_hcr  anyway.

>
> Pre-existing issues:
> - [High] KVM_SET_ONE_REG updates to GICv3 VMCR are silently dropped under=
 pKVM during vcpu_put()

The uaccess holds  kvm_trylock_all_vcpus , so it can't run between load and=
 put.

/fuad

> --
>
> --- Patch [7]: [PATCH v5 7/8] KVM: arm64: Add primitives to flush/sync th=
e VGIC state at EL2 ---
> commit 5a3c12abf480537e61537f1e45492ee3e349846c
> Author: Marc Zyngier <maz@kernel.org>
>
> KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
>
> pKVM performs its own world switch for protected VMs but has no primitive=
s
> to move the per-vCPU VGIC state between the host and hypervisor vCPU
> contexts. Add flush_hyp_vgic_state() and sync_hyp_vgic_state().
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index f3233ee343a39..2db56146ec493 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -104,6 +104,45 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
> >       *host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
> >  }
> >
> > +static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> > +     struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> > +     unsigned int used_lrs, i;
> > +
> > +     host_cpu_if     =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> > +     hyp_cpu_if      =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> > +
> > +     used_lrs        =3D host_cpu_if->used_lrs;
> > +     used_lrs        =3D min(used_lrs, hyp_gicv3_nr_lr);
> > +
> > +     hyp_cpu_if->vgic_hcr    =3D host_cpu_if->vgic_hcr;
> > +     /* Should be a one-off */
> > +     hyp_cpu_if->vgic_sre    =3D (ICC_SRE_EL1_DIB |
> > +                                ICC_SRE_EL1_DFB |
> > +                                ICC_SRE_EL1_SRE);
> > +     hyp_cpu_if->used_lrs    =3D used_lrs;
> > +
> > +     for (i =3D 0; i < used_lrs; i++)
> > +             hyp_cpu_if->vgic_lr[i] =3D host_cpu_if->vgic_lr[i];
> > +}
>
> [Severity: High]
> Does this code miss copying the its_vpe struct?
>
> Previously, this was a full struct assignment. By explicitly copying fiel=
ds
> instead, its_vpe is omitted, leaving its_vpe.its_vm as NULL in the
> hypervisor vCPU state.
>
> When the guest runs, __vgic_v3_activate_traps() executes at EL2 and relie=
s
> on this field:
>
> arch/arm64/kvm/hyp/vgic-v3-sr.c:__vgic_v3_activate_traps() {
>     if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
>         cpu_if->its_vpe.its_vm || !cpu_if->vgic_sre)
>         write_gicreg(vgic_ich_hcr_trap_bits() | ICH_HCR_EL2_En, ICH_HCR_E=
L2);
>     ...
> }
>
> Since its_vm is NULL, ICH_HCR_EL2_En is not set. Could this break GICv4
> direct virtual LPI injection for non-protected guests?
>
> [ ... ]
>
> > @@ -166,9 +199,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >  static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  {
> >       struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> > -     struct vgic_v3_cpu_if *hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_c=
pu.vgic_v3;
> > -     struct vgic_v3_cpu_if *host_cpu_if =3D &host_vcpu->arch.vgic_cpu.=
vgic_v3;
> > -     unsigned int i;
> >
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> > @@ -181,10 +211,7 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >
> >       host_vcpu->arch.iflags          =3D hyp_vcpu->vcpu.arch.iflags;
> >
> > -     host_cpu_if->vgic_hcr           =3D hyp_cpu_if->vgic_hcr;
> > -     host_cpu_if->vgic_vmcr          =3D hyp_cpu_if->vgic_vmcr;
> > -     for (i =3D 0; i < hyp_cpu_if->used_lrs; ++i)
> > -             host_cpu_if->vgic_lr[i] =3D hyp_cpu_if->vgic_lr[i];
> > +     sync_hyp_vgic_state(hyp_vcpu);
> >  }
>
> [Severity: High]
> This is a pre-existing issue, but does handle___vgic_v3_save_aprs()
> silently drop userspace modifications to the GICv3 VMCR?
>
> When userspace sets the VMCR register, vcpu_load() first calls
> handle___vgic_v3_restore_vmcr_aprs(), which copies host_cpu_if->vgic_vmcr
> to the hyp vCPU. KVM_SET_ONE_REG then updates the host copy of the regist=
er.
>
> Finally, vcpu_put() calls handle___vgic_v3_save_aprs():
>
> arch/arm64/kvm/hyp/nvhe/hyp-main.c:handle___vgic_v3_save_aprs() {
>     ...
>     hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
>     ...
>     host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
>     host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;
> }
>
> Doesn't this unconditionally overwrite the new host value (set by
> KVM_SET_ONE_REG) with the old value stored in the hyp vCPU at load time,
> potentially breaking VM migration and state restoration?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.41=
42645-1-fuad.tabba@linux.dev?part=3D7
