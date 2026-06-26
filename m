Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3088B3E16A9
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 07:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782459442; cv=none; b=JLpfiD+oZrCwgyyDiGlmb5UaQdzoOTQtJZuwM7PmbwQyzuVprwUebhd9jUpNvPid7ZB5KGZOGriIuq1vLarTl/Cx/0BqFSp7yJ3Vqh8Zhcd+1pj3HvReuoZLCpeqESC50GJ11PwIi7J0Cx4l5eAu6XJYl5VKYIXtJih+D8VNVoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782459442; c=relaxed/simple;
	bh=6iX2dKdY0m+uMbOsy5DnYNj9KBh4GGrnIN2sQhmjxQ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HdIV2wx6aStJTqDEryRslRVqdS5XX5chUF11fpY/qUcH/UyK9SKrdohjFKaOMIygEnXhDtrGr+UKdX81RudRlOV2dM0sbXV0dUs3MHgI1Xutzu269eST1M2XPDgGmHDaezkp3LJ38FHoo2w418tJkUrDd0/Soun41uk2tYExLLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Eli/ytrX; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Eli/ytrX"
X-Forwarded-Encrypted: i=1; AFNElJ//76iycFuDUE5GXBWt8BLS6jhRL890Ij4XwAmF6EXPrA2Tq89o/WCkqKSIYnAEnzUc0Jz+sx4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782459438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fodi8uTRo/4y9pG1AkX7XJnFhhIivlFaVtvdp9FgNfs=;
	b=Eli/ytrX31efMSJ6IwO1JzCdyqdxXniulC+lVFWBbgPqszZQkfZ1DbCouBpZYsFIDcJL3I
	eoFe78PuWMqaTzqXpn8tIOmLRRmv+xPrR62kaV2ZVHFY6VMQ3zR6K/ub3E+Gdh8PjYDM/k
	t7/LpLaGfWX3JlW/CDxJuom3pm9M3M4=
X-Gm-Message-State: AOJu0Ywy36jtYcmFF0xHsxipIZ3FjCvJuDs+yPC6MCV5zHmzkLtOWgYf
	wWjntPnLpHALCDkx818r6HoAi1pM7TYoppA0sJXp65AU/Tl8QTLKKz4ljRSKWj6W6Dk12UlPueV
	rJadvQuwqnfCQNr4EUQtgavw+lBdnmbGp1419ZMKp
X-Received: by 2002:ac8:688e:0:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-51a7d91910amr6019121cf.5.1782459432724; Fri, 26 Jun 2026
 00:37:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260626070408.3420953-1-fuad.tabba@linux.dev>
 <20260626070408.3420953-9-fuad.tabba@linux.dev> <20260626072906.7777C1F000E9@smtp.kernel.org>
In-Reply-To: <20260626072906.7777C1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 26 Jun 2026 08:36:36 +0100
X-Gmail-Original-Message-ID: <CA+EHjTx_sf1n2cakTCt==tp5y9L2ZS0qGMA9KGUCQrwd=aXz_A@mail.gmail.com>
X-Gm-Features: AVVi8Cc7mVXIu6iJeZL7NggpyXCgUGQCzrZ9ABWdthAShiTmP-mYlTEAbD9RfBs
Message-ID: <CA+EHjTx_sf1n2cakTCt==tp5y9L2ZS0qGMA9KGUCQrwd=aXz_A@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, 26 Jun 2026 at 08:29, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Asynchronous host modifications to non-protected guest sysregs (=
e.g., PMU overflows updating PMOVSSET_EL0) are lost because lazy vCPU state=
 sync clears the dirty flag on IRQ exits and later overwrites the host's up=
dates with stale hypervisor state.

No code path modifies vcpu->arch.ctxt.sys_regs[] during host IRQ
handling. Guest PMU state changes go through the trap emulation path
(ARM_EXCEPTION_TRAP), which triggers the sync.

> - [High] The patch removes the synchronization of `hcr_el2` from the hype=
rvisor back to the host on guest exit, breaking the delivery tracking of vi=
rtual SErrors and causing infinite virtual SError loops.

HCR_VSE is synced back explicitly (hyp-main.c, sync_hyp_vcpu):

    host_vcpu->arch.hcr_el2 &=3D ~HCR_VSE;
    host_vcpu->arch.hcr_el2 |=3D hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VSE;

The full hcr_el2 copy was replaced by targeted per-bit sync, not
removed.
>
> Pre-existing issues:
> - [Critical] pKVM completely breaks register confidentiality and integrit=
y for protected VMs by copying the entire execution context (`arch.ctxt`) t=
o and from untrusted host memory on every world switch.

This is the stated scope of the follow-up series, as described in
the cover letter: "The follow-up completes the job for protected
VMs: state isolation, PSCI handling at EL2, and the resulting API
behaviour."

And that's a wrap!
/fuad

> --
>
> commit 44f38b89413b112e6bbd7b360cf03c7937ed43a4
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>
> pKVM copies a non-protected guest's register context between the host
> and the hypervisor on every world switch. This commit defers the copy
> by flushing context on entry only if marked dirty, and syncing back
> on exit only when requested.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > index 54aedf93c78b6..29108e5c0206e 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> [ ... ]
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
> Is it possible for asynchronous host updates to be lost here? If a physic=
al
> IRQ (like a PMU overflow) causes a guest exit, this else branch clears
> PKVM_HOST_STATE_DIRTY.
>
> If the host IRQ handler then updates PMOVSSET_EL0 in the host's
> vcpu->arch.ctxt, the next guest entry in flush_hyp_vcpu() will skip
> copying sys_regs to the hyp vCPU. The guest will see stale state.
>
> If the guest later triggers a TRAP exit, __pkvm_vcpu_sync_state() is
> called, which copies the stale hypervisor sys_regs back to the host,
> permanently erasing the host's asynchronous update.
>
> > +     }
> > +}
> [ ... ]
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 2db56146ec493..4a8445b636e60 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
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
> This is a pre-existing issue, but does trusting arch.ctxt violate the pKV=
M
> threat model? Copying the entire execution context directly from untruste=
d
> host memory into the protected guest context on entry breaks integrity,
> allowing the host to arbitrarily modify a protected guest's registers.
>
> > +     }
> >
> >       /* __hyp_running_vcpu must be NULL in a guest context. */
> >       hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu =3D NULL;
> [ ... ]
> > @@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> >
> > -     host_vcpu->arch.ctxt            =3D hyp_vcpu->vcpu.arch.ctxt;
> > -
> > -     host_vcpu->arch.hcr_el2         =3D hyp_vcpu->vcpu.arch.hcr_el2;
>
> [Severity: High]
> Could removing the hcr_el2 sync result in infinite virtual SError loops?
>
> When the host injects a virtual SError by setting HCR_VSE, flush_hyp_vcpu=
()
> flows this bit to the hyp vCPU. The hardware clears the physical
> HCR_EL2.VSE bit when the guest takes the virtual SError, and KVM clears i=
t
> in the hyp vCPU's hcr_el2.
>
> Without syncing this back to the host here, the host's hcr_el2 retains
> the stale HCR_VSE=3D1. On the next entry, flush_hyp_vcpu() will re-apply =
the
> stale HCR_VSE bit and re-inject the SError continuously.
>
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +             host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
>
> [Severity: Critical]
> This is a pre-existing issue, but can writing arch.ctxt out to the host
> leak sensitive register state? For protected VMs, writing the private gue=
st
> context directly out to the untrusted host on exit breaks confidentiality=
.
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
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626070408.34=
20953-1-fuad.tabba@linux.dev?part=3D8
