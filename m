Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3B0410D2D
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784034567; cv=none; b=rpM7Dm5QihXHtjWXFHUUas/a+M+PSO3Ly59n8tRIN2FnViteWeslO6NAHtA432eLtRo62l0NM3LXKkPQNDC/bm1BZymXulimzH+6q7MzPhPMcZ8G1YMnVt02sjM/Gm5Mfo+DP+FctvPhM+iK9S+1UJ27GXZPbl5Q516oGlX6Na8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784034567; c=relaxed/simple;
	bh=pMbffV8+WnlzgGXlItzjUetsYGrV+g/M1yZ5DCe2lXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kM/3drRYLyd82VEKrG/T2DxRuJ2/Bd9Ha//tlSEcEXa+uCtdk6kT3AZo44njzD3UBBPdEUWT1447JlrHO0ejavA5cCg5/gdn+j7rh0XFHche7++XSmU6hxNm5cUIxbKIzPIWX9fOZk/G+XUOdlc6++wzS9p1OIC3wp/Vi6HucD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M8hZZz7f; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M8hZZz7f"
X-Forwarded-Encrypted: i=1; AHgh+RrnDchHeiuxnlADafLmCsc+kU54FUxK62LTaLvFhrdYSe8EUcdAxPFJqaFIsF0ceQrhIvLbhC4=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784034563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NibVBK91s7x7Qg0aXzMK41qTwtyj1jEWlalOlyQqBec=;
	b=M8hZZz7fBLIxhJDI5NRVB3NW17z+iwjOA+A/lTYCglavfur0X2P+thbrqyMW9t7zaMV6gv
	k0fqCzvox36EvObJQnR5D2eeEvFGL1f6bwS5TTiLR7AIxBdRxQ0hJaoGrEp+RZFxbcVY7L
	L8YGPpmVpQ9NT3pI94khNbG4fjZm7/g=
X-Gm-Message-State: AOJu0YwvxiHuYaeW2X4VP8tn50ZGrj68goLOeoGlIHWWdc83gZKCg0dH
	f/EkIo2E4qwstNbrEg64Fq9t4YL0E2gO8JL3eHtl4EuPH8HJ3FIVwQfAtPmJmP/RkJOhlXqCOuF
	do6FBcc1zK6PXkqlyAy5nzp10zRSZzyyuog+AufZ0
X-Received: by 2002:ac8:588f:0:b0:51c:d16:b48e with SMTP id
 d75a77b69052e-51d8373f2b1mr14137651cf.22.1784034559960; Tue, 14 Jul 2026
 06:09:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260714101601.4142645-1-fuad.tabba@linux.dev>
 <20260714101601.4142645-9-fuad.tabba@linux.dev> <20260714123355.631A51F00A3A@smtp.kernel.org>
In-Reply-To: <20260714123355.631A51F00A3A@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 14 Jul 2026 14:08:43 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxiyUSJqRcadSCOmR+tELSsBiGaTYH9xxXh-g-xyuHZdA@mail.gmail.com>
X-Gm-Features: AUfX_mzRmIoBD2J-UhkrzdHpoIgylipp9U_oqH7zaMC4epcst4SI-SOiQiuQsyU
Message-ID: <CA+EHjTxiyUSJqRcadSCOmR+tELSsBiGaTYH9xxXh-g-xyuHZdA@mail.gmail.com>
Subject: Re: [PATCH v5 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Tue, 14 Jul 2026 at 13:33, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Removal of `hcr_el2` synchronization back to the host prevents c=
learance of `HCR_VSE`, causing infinite virtual SError storms in the guest.
sync_hyp_vcpu  does sync VSE back ( hyp-main.c:712-713 ), host copy is clea=
red.

> - [High] Lazy state sync skips synchronization and clears `PKVM_HOST_STAT=
E_DIRTY` on IRQ and IL exits, silently discarding host-side context modific=
ations.
the only in-loop ctxt writer is  KVM_REQ_VCPU_RESET  (PSCI CPU_ON
target, not the running vCPU, DIRTY still set); injection state rides
iflags , copied unconditionally. Nothing dropped.

>
> Pre-existing issues:
> - [Critical] Protected guest register state is unconditionally leaked to =
and overwritten by untrusted host memory (`host_vcpu->arch.ctxt`) on every =
world switch.

pre-existing upstream placeholder; per-field marshalling for protected
VMs is the next series.

/fuad


> --
>
> --- Patch [8]: [PATCH v5 8/8] KVM: arm64: Implement lazy vCPU state sync =
for non-protected guests ---
> commit e68e83fa70438b2538d1ea836d971c6d52ffb760
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Implement lazy vCPU state sync for non-protected guests
>
> pKVM copies a non-protected guest's register context between the host
> and the hypervisor on every world switch, even when the host never
> inspects it. Defer the copy: on entry, flush the host context into the
> hyp vCPU only when the host marked it dirty; on exit, leave it in the
> hyp vCPU and copy it back only when the host needs it.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int excepti=
on_index)
>
> [ ... ]
>
> > +static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exceptio=
n_index)
> > +{
>
> [ ... ]
>
> > +     if (exception_code =3D=3D ARM_EXCEPTION_TRAP ||
> > +         exception_code =3D=3D ARM_EXCEPTION_EL1_SERROR ||
> > +         ARM_SERROR_PENDING(exception_index)) {
> > +             kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
> > +             vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +     } else {
> > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +     }
> > +}
>
> [Severity: High]
> If a non-protected guest exits due to an IRQ (such as a PMU overflow), th=
is
> clears PKVM_HOST_STATE_DIRTY. If the host kernel then handles the IRQ and
> modifies the guest context (for example, setting PMOVSSET_EL0 for the
> overflow or applying a reset like KVM_REQ_SUSPEND), these updates appear =
to
> be lost.
>
> On the next entry, flush_hyp_vcpu() will skip copying the host state beca=
use
> the dirty flag is clear. Then, on a subsequent exit or vcpu_put,
> handle___pkvm_vcpu_put() will reverse-sync the stale hyp state back over =
the
> host state. Does this clear flag path silently discard host-side context
> modifications?
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
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
> > +     }
>
> [Severity: Critical]
> This is a pre-existing issue, but doesn't this unconditionally overwrite =
the
> protected guest's private EL2 registers with the values from the untruste=
d
> host memory? By copying host_vcpu->arch.ctxt into the hyp_vcpu on entry,
> could the host arbitrarily modify a protected VM's state before execution=
?
>
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
> This is also a pre-existing issue, but leaking the protected guest's
> register state into the untrusted host memory seems to violate pKVM's
> confidentiality guarantees. The untrusted host EL1 can read all private E=
L2
> registers via its mapped kvm_vcpu structure. Should this copy be avoided =
for
> protected VMs?
>
> [Severity: High]
> By removing the assignment that copies hcr_el2 back to the host, do we br=
eak
> virtual SError injection?
>
> When the guest takes a virtual SError, the hardware clears the VSE bit in
> the hyp vCPU's hcr_el2. Because we no longer sync this back in
> sync_hyp_vcpu(), the host's copy remains set. On the next entry,
> flush_hyp_vcpu() will read the stale host HCR_VSE bit and set it again,
> which seems like it would trap the guest in an infinite virtual SError
> storm.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714101601.41=
42645-1-fuad.tabba@linux.dev?part=3D8
