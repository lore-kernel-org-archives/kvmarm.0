Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B06422555
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783339225; cv=none; b=of0ZskMlYJgGkapvP9jC3EWPuYL7uAu0U5JlU1tF3vgToTD8VIJ9MFZ3YE4aJncNdPP/YUADxRhWrzdpMC1dbIfm5gws8PSYD4qC/kkKwipS0xOFhJc5Vo7S5BkotFJnQCr3lUy0xzqjvKgsOH3Ghz8eqt1v3+Nn0bovtpK4F7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783339225; c=relaxed/simple;
	bh=U6kB1ASAxdVMsg3tw9qEyKCm14JuyVwKMIb9hQ/96wg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J507+Tds2ABT9vezDWLsQcgtdCrB9YHZaO9FPCeWh92RUHTPvPRE7wvb28+NuoSA1XDA6mOhxvfesOIiGkQA/QUEDQz69EiL1tsmUwhdtZWinAbwLOrBZLIeyUkN8gVgse0muiZA1bMaSqLSkHGyMAS1g0RtzsHIgc067Rr4q+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cAHG4/pZ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cAHG4/pZ"
X-Forwarded-Encrypted: i=1; AHgh+Rp/GLCmpbPNptQA62sm9LO3fqIevXqAcffVHGnBc1fAtBVPE9I7FmS00tqfZGjujfYn+RtgS3Q=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783339221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=76HxWMmhkdI9JrbpQAb+ExNibxcc5C01zdg+a34h5Hc=;
	b=cAHG4/pZMBQboPjCanbKrqZBgW5BIg0vvf9khIzaT5W4de1YALQ7zVteg9CmgZsm7NUKtW
	E4RPpiDq1F6jL7hHg+BXbyzYOniLmFJu19zoQvVRrvDat/FLxndo5PMEaLu0pVelZhXaSg
	gfgTPnHDJGewU7Gvjn1ghQs7rlVIWt4=
X-Gm-Message-State: AOJu0Yw/FlykouxmVQbCaIZh6DsTdJN6Eiqeo2dIR33wmWrP4sLTa4vs
	90El3vc/XnPxZYc131embbBbUS3suGqV+kdd/cyCf/DBXr2sBV879OK/xGJESy8Qgw9vJokM/cx
	FssqyMUkAGbEWsmLh6gcUSfcho3K/5A05vzzNDgnU
X-Received: by 2002:a05:622a:c01:b0:51b:ff0a:2048 with SMTP id
 d75a77b69052e-51c4bf83afcmr16783941cf.3.1783339205460; Mon, 06 Jul 2026
 05:00:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706095927.560795-1-fuad.tabba@linux.dev> <20260706095927.560795-9-fuad.tabba@linux.dev>
 <20260706103651.3D1A41F000E9@smtp.kernel.org>
In-Reply-To: <20260706103651.3D1A41F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 12:59:28 +0100
X-Gmail-Original-Message-ID: <CA+EHjTz9Qdznk=cPMYLWHkHag_7cc53=ZkYdBfQ7tXb9myqHcQ@mail.gmail.com>
X-Gm-Features: AVVi8CepLtV5kGFJPMfqEIjpyJZJF_Wy1QszVyxax0Tq6BeSIYL3S-Vl10FyPxg
Message-ID: <CA+EHjTz9Qdznk=cPMYLWHkHag_7cc53=ZkYdBfQ7tXb9myqHcQ@mail.gmail.com>
Subject: Re: [PATCH v4 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 11:36, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:

https://lore.kernel.org/all/CA+EHjTyEikgroi9a9vhtv-pixBj_21RC=3D4d4EnsfxFk1=
0WCnwA@mail.gmail.com/
https://lore.kernel.org/all/CA+EHjTx_sf1n2cakTCt=3D=3Dtp5y9L2ZS0qGMA9KGUCQr=
wd=3DaXz_A@mail.gmail.com/

> New issues:
> - [High] The commit silently removes the synchronization of hcr_el2 from =
the hyp vCPU back to the host vCPU on guest exit, breaking host-injected ru=
ntime signals like virtual SErrors.

VSE is synced back selectively.

> - [High] Host-side modifications to a non-protected guest's system regist=
ers via asynchronous KVM requests (e.g. KVM_REQ_PMU) are silently discarded=
 because the dirty flag is cleared on IRQ exits.

Injection flags and HCR_VSE are flushed unconditionally, not gated by
DIRTY. The one real case (SError ESR) was found and fixed.

> Pre-existing issues:
> - [Critical] pKVM completely fails to isolate the register state of prote=
cted guests by unconditionally copying the full execution context between t=
he untrusted host and the hypervisor on every world switch.

Pre-existing upstream placeholder; per-field marshalling is added by
the follow-up series.

Cheers,
/fuad


> --
>
> commit 417bef11bf8b55291221bae4776c5695349c903d
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>
> pKVM copies a non-protected guest's register context between the host
> and the hypervisor on every world switch, even when the host never
> inspects it. Defer the copy: on entry, flush the host context into the
> hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
> exit, leave it in the hyp vCPU and copy it back only when the host needs
> it, via a __pkvm_vcpu_sync_state hypercall or at vcpu put.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > index 54aedf93c78b6..29108e5c0206e 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
>
> [ ... ]
>
> > @@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int excepti=
on_index)
> >       }
> >  }
> >
> > +static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exceptio=
n_index)
> > +{
> > +     int exception_code =3D ARM_EXCEPTION_CODE(exception_index);
> > +
> > +     if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm)=
)
> > +             return;
> > +
> > +     /*
> > +      * Sync the context back when the host will read (trap) or write
> > +      * (SError) it. Preempt-off here, so the loaded hyp vCPU is stabl=
e.
> > +      */
> > +     if (exception_code =3D=3D ARM_EXCEPTION_TRAP ||
> > +         exception_code =3D=3D ARM_EXCEPTION_EL1_SERROR ||
> > +         ARM_SERROR_PENDING(exception_index)) {
> > +             kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > +             vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +     } else {
> > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
>
> [Severity: High]
> Does clearing the dirty flag on other exits (like IRQ) blind the lazy syn=
c to
> subsequent host-side state modifications?
>
> If a non-protected guest exits due to a physical IRQ, the PKVM_HOST_STATE=
_DIRTY
> flag is cleared here. If the host IRQ handler then updates guest state (e=
.g. via
> PMU overflow) and queues an asynchronous KVM request, the next time the g=
uest is
> entered, flush_hyp_vcpu() will skip flush_hyp_vcpu_state() because the di=
rty
> flag is clear.
>
> Will this result in the guest running with stale state, discarding the ho=
st's
> modifications?
>
> > +     }
> > +}
> > +
> >  /* For exit types that need handling before we can be preempted */
> >  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >  {
> > +     handle_exit_pkvm_state(vcpu, exception_index);
> > +
> >       if (ARM_SERROR_PENDING(exception_index)) {
> >               if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
> >                       u64 disr =3D kvm_vcpu_get_disr(vcpu);
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 2db56146ec493..4a8445b636e60 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -172,7 +214,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *h=
yp_vcpu)
> >       fpsimd_sve_flush();
> >       flush_debug_state(hyp_vcpu);
> >
> > -     hyp_vcpu->vcpu.arch.ctxt        =3D host_vcpu->arch.ctxt;
> > +     /*
> > +      * If we deal with a non-protected guest and the state is potenti=
ally
> > +      * dirty (from a host perspective), copy the state back into the =
hyp
> > +      * vcpu.
> > +      */
> > +     if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +             if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
> > +                     flush_hyp_vcpu_state(hyp_vcpu);
> > +     } else {
> > +             hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;
>
> [Severity: Critical]
> This is a pre-existing issue, but pKVM seems to completely fail to isolat=
e the
> register state of protected guests by unconditionally copying the untrust=
ed host
> context into the protected hyp vCPU context here on every world switch.
>
> Can this allow the host kernel, which is treated as an adversary against =
guest
> confidentiality and integrity, to arbitrarily inject state into the prote=
cted VM?
>
> > +     }
> >
> >       /* __hyp_running_vcpu must be NULL in a guest context. */
> >       hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
> > @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> >
> > -     host_vcpu->arch.ctxt            =3D hyp_vcpu->vcpu.arch.ctxt;
> > -
> > -     host_vcpu->arch.hcr_el2         =3D hyp_vcpu->vcpu.arch.hcr_el2;
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +             host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
>
> [Severity: Critical]
> This is a pre-existing issue, but similar to the copy on entry, unconditi=
onally
> copying the protected hyp vCPU context back to the untrusted host context=
 here
> leaks the guest's execution context.
>
> Does this break the core pKVM confidentiality guarantees by allowing the =
host
> to read all guest registers?
>
> > +     } else {
> > +             /* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bi=
t) current. */
> > +             host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt=
.regs.pc;
> > +             host_vcpu->arch.ctxt.regs.pstate =3D hyp_vcpu->vcpu.arch.=
ctxt.regs.pstate;
> > +     }
>
> [Severity: High]
> Does removing the synchronization of hcr_el2 from the hyp vCPU back to th=
e host
> vCPU break host-injected runtime signals like virtual SErrors?
>
> When a virtual SError is injected via HCR_VSE, the guest hardware clears =
the
> bit upon delivery. Previously, this cleared state was synced back to the =
host
> here in sync_hyp_vcpu().
>
> Since the sync is now removed, won't the host's hcr_el2 retain the stale =
HCR_VSE
> bit forever? On every subsequent guest entry, flush_hyp_vcpu() will OR th=
is
> stale bit back into the hyp vCPU's hcr_el2, which seems like it would cau=
se an
> infinite loop of spurious virtual SError injections into the guest.
>
> >
> >       host_vcpu->arch.fault           =3D hyp_vcpu->vcpu.arch.fault;
> >
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706095927.56=
0795-1-fuad.tabba@linux.dev?part=3D8
