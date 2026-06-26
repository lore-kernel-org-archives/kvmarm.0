Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E591A38F9
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459280; cv=none; b=tEV7ugGoH/efIzbZq5qcEp7jffzQmRoxTWSV4fMmVOyM7zhEladZx5Q7MGkd7BWW6KUNH9kfkLJPytfqCVfYDwqANXsJdrrmhRKSSXm9dEfASqctJclOf8oEhcK5XqGxGFxpJKOVYyibks2Bd6A66FmlAskh8CIiozpFNuFaiMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459280; c=relaxed/simple;
	bh=0CYYnK9UULPUJn6SA/G1HLs4yMAtuGBjbxMj/IwEN4Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFZwNKqVvUCC1UwiOy9p6ijIEyJIMiIUwG/g9/teFOzYSgpDW5hxnC1EwjaFyQ2xXxAh7/DsXXonxNQLTJFDQ050TTNfwEWcjaKO0JgwD9NhCPV/uIPNFBN2UD+Y4eF+/La2iIyy8yqQ8t2fSL6c3f3rlOzHIBOPxPibh5YFlpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uBFyF9c4; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uBFyF9c4"
X-Forwarded-Encrypted: i=1; AFNElJ9INp/Imj3V2PXrDBG2Z70sW7SRtUQFr5khcQD2RTF/XJQa93RwF4lYK8umUVu20fFUDdSWUEo=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782459276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D77qozCKYidUlbb7BhEqxsGWQRLWd5U3WtX3EVkcWSg=;
	b=uBFyF9c4owijAQwGV1vC5JMRGfKYzEzemP+07RPMmfnZCrNumKTtFxJkcYE4gxl4dgw21n
	8w4+NM6aNyOznNmd/mu5pL/v8eJQgxCGYC9y/8BYaarweDNnDXjuNONePqL+hg6niAGVbZ
	wsgowoukwYG2Xil0sbuetwSMvqz8CAA=
X-Gm-Message-State: AOJu0Yw8RUpuy8CpxPKU8DO07q/vjgcI4qvVZ1HsimwfAJVhlYEws3lj
	Evs3sagiRINUXrm746KIrgHVGkct7JK0ezoTcI403O9WeSAm7r8Sl6xJtleTk+eNDsdlipSaTC3
	9YqBmAK8OJH7KfQcvamSNrHZzsWn8WsK3QeQ8t6OC
X-Received: by 2002:a05:622a:558a:b0:516:8fad:8fd3 with SMTP id
 d75a77b69052e-51a7d955e70mr7067831cf.11.1782459257771; Fri, 26 Jun 2026
 00:34:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-8-fuad.tabba@linux.dev> <20260626072748.C9D791F000E9@smtp.kernel.org>
In-Reply-To: <20260626072748.C9D791F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 26 Jun 2026 08:33:41 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxc3v3saSGOAjW9F4kSLpMAtAJLiE5D+rUTLJ72-yhcKA@mail.gmail.com>
X-Gm-Features: AVVi8CdNX7HRyOitLtAgZkaNg5PZHPRe4-hMWBxUwMl-3AR4gBtYdLL3lLo7YYo
Message-ID: <CA+EHjTxc3v3saSGOAjW9F4kSLpMAtAJLiE5D+rUTLJ72-yhcKA@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] KVM: arm64: Add primitives to flush/sync the VGIC
 state at EL2
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, 26 Jun 2026 at 08:27, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] Host updates to vgic_vmcr during MMIO emulation are silently dis=
carded and reverted due to missing flush on vCPU entry and unconditional ov=
erwrite on vCPU exit.

VMCR is not part of the per-entry flush/sync; it is handled by the
separate restore_vmcr_aprs/save_aprs cadence at vcpu_load/vcpu_put
time. No code path modifies host_cpu_if->vgic_vmcr between
sync_hyp_vgic_state (exit) and save_aprs (put). GICv2 emulation is
not supported under pKVM.

> - [High] flush_hyp_vgic_state() hardcodes vgic_sre to GICv3 values, perma=
nently breaking GICv2 emulation by preventing ICH_VMCR_EL2 from being writt=
en.

GICv2 is not supported under pKVM (vgic_v2_probe returns -ENXIO when
is_protected_kvm_enabled()). The hardcoded SRE value matches the
GICv3-only configuration.

/fuad

> --
>
> commit 7488e8d4b40f79a0ec0bb726d02c6676c9426897
> Author: Marc Zyngier <maz@kernel.org>
>
> KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
>
> This commit introduces flush_hyp_vgic_state() and sync_hyp_vgic_state() t=
o
> move per-vCPU VGIC state between host and hypervisor vCPU contexts for
> protected VMs. It bounds used_lrs and hardcodes vgic_sre to a fixed value=
,
> replacing the previous direct struct copy.
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
>
> [Severity: High]
> Does this code lose host-side updates to vgic_vmcr?
>
> When a guest triggers a GICv2 MMIO trap, the host KVM run loop processes
> it synchronously and updates host_cpu_if->vgic_vmcr. Because
> flush_hyp_vgic_state() does not copy vgic_vmcr into the hypervisor state,
> the hypervisor retains its stale value.
>
> When the guest exits, sync_hyp_vgic_state() copies the stale hypervisor
> value back, which will permanently overwrite and clobber the host's updat=
e.
> Could this lead to broken GICv2 CPU interface emulation and lost interrup=
ts?
>
> > +     /* Should be a one-off */
> > +     hyp_cpu_if->vgic_sre    =3D (ICC_SRE_EL1_DIB |
> > +                                ICC_SRE_EL1_DFB |
> > +                                ICC_SRE_EL1_SRE);
>
> [Severity: High]
> Can hardcoding vgic_sre to GICv3 values here break GICv2 emulation?
>
> For VMs using GICv2 emulation on GICv3 hardware, the host sets vgic_sre =
=3D 0
> to enable compatibility mode. By unconditionally overriding it to GICv3
> values here, the !cpu_if->vgic_sre check will evaluate to false in
> __vgic_v3_activate_traps(), which prevents the hypervisor from writing to
> ICH_VMCR_EL2.
>
> This appears to leave the hardware with a stale or zeroed VMCR and masks
> guest interrupts. Is this intended?
>
> > +     hyp_cpu_if->used_lrs    =3D used_lrs;
> > +
> > +     for (i =3D 0; i < used_lrs; i++)
> > +             hyp_cpu_if->vgic_lr[i] =3D host_cpu_if->vgic_lr[i];
> > +}
> > +
> > +static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> > +     struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> > +     unsigned int i;
> > +
> > +     host_cpu_if     =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> > +     hyp_cpu_if      =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> > +
> > +     host_cpu_if->vgic_hcr =3D hyp_cpu_if->vgic_hcr;
> > +     host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;
>
> [Severity: High]
> As mentioned above, this unconditionally overwrites the host's vgic_vmcr
> with the hypervisor's copy, which was never flushed from the host on entr=
y.
> Could this cause the host's MMIO emulation updates to be discarded?
>
> > +
> > +     for (i =3D 0; i < hyp_cpu_if->used_lrs; i++)
> > +             host_cpu_if->vgic_lr[i] =3D hyp_cpu_if->vgic_lr[i];
> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626070408.34=
20953-1-fuad.tabba@linux.dev?part=3D7
