Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867FA431A22
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 10:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788258319; cv=none; b=tSo5HkKiiUhMKCbs70Av3THrkfY9I8sKzshTpsIDx5UE4MDWEn+s24RNCGVE261St1ovFfIxE2foA1eAay0HtqBKk1ThqLPLud7eRGoVZVLGsFUFNLG0kSxNPhsX8AxhzqqCoBX15BcNgxIG/AT/Z7KBl5XB/k8MerUh18jAloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788258319; c=relaxed/simple;
	bh=3b1u60+8U6ha5CqTOcL4z0LRCmKhGOjJcF6XTi/oN8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dYgZj7UDVsH/WsC+qSasuVAPqj3zKT+4EUlEypBoCM7Wg/0XkMuw66dEnJxczP8qzUXEBTWQMzcqztT+jJjHzx4UQuDfIkpX7/Y5W1exbcESyRxJMI8EYQazyYPmLeWEyRl/u4+vYohZCjYmKdDaAuv22gmaXbP7i7w5Y7Oj5OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XJmpEvIQ; arc=none smtp.client-ip=91.218.175.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XJmpEvIQ"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3b1u60+8U6ha5CqTOcL4z0LRCmKhGOjJcF6XTi/oN8I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788258315; v=1; x=1788863115;
 b=XJmpEvIQmDxJZB4Mi8vvkkklqfwleCetaYDWPhk29a2ihsUlyL0d0wWePhZ8i0Lt6XhabOkU
 kI4WumFCpUPWikmckvWMjRtifiq2Iijle7JfLvKo8yNn0NxYGkW0jpVXdPXD1KGZt5HiZGtC2x0
 pRtUJlm9VzuyEKFodKTpufbs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3fcf86b2f9c39f72;
	Tue, 01 Sep 2026 10:25:15 +0000
X-Mizu-Trace-ID: 3fcf86b2f9c39f72
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b2a8173142so4354e87.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 03:25:11 -0700 (PDT)
X-Gm-Message-State: AFuF++nivpSoirvCxxqJkrA7LZS1qZBTHT9XuxDuw44hxdQkcazgcrRL
	iFeBwud89e6nT78/FZnqwlsWTYUNZMYA4JiNCca9gyvjE+9Zcs/KjDoxw7xXaqbIRaIWrQaimD/
	69lFFLrS4Tste6YJM5UqZQ6LJE8OExNufNrLQIVlM
X-Received: by 2002:a05:6512:3b0d:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b5fefc71e5mr148613e87.0.1788258310381; Tue, 01 Sep 2026
 03:25:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-14-fuad.tabba@linux.dev>
 <20260831221539.8DB491F000E9@smtp.kernel.org>
In-Reply-To: <20260831221539.8DB491F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 1 Sep 2026 11:24:34 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwKXcp02nUT2zecXCD6+Hj5Pdq-8GmeZa4PSJYuoptANg@mail.gmail.com>
X-Gm-Features: AcwNN1UO1DB7feZBAuh-nhYjjO2uStTMPjKIaTJNHFs2D4_LYU8462LL1zPlcqM
Message-ID: <CA+EHjTwKXcp02nUT2zecXCD6+Hj5Pdq-8GmeZa4PSJYuoptANg@mail.gmail.com>
Subject: Re: [PATCH 13/17] KVM: arm64: Add per-EC entry/exit state marshalling
 for protected guests
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

And 0/3 here...

On Mon, 31 Aug 2026 at 23:15, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
> - [High] The HVC64 entry handler ignores host-requested PC increments and=
 exception injections, causing an infinite trap loop.
> - [High] Host-injected exceptions and PC advancements are silently ignore=
d for unhandled Exception Classes, causing infinite trap loops.
> - [High] handle_pvm_exit_wfx fails to marshal the WFx timeout register to=
 x0, breaking WFET and WFIT emulation.
> --
>
> commit 0b0e245ce37c95597a108d7e1ed3684401ade81b
> Author: Fuad Tabba <fuad.tabba@linux.dev>
> Subject: KVM: arm64: Add per-EC entry/exit state marshalling for protecte=
d guests
>
> This patch moves a protected guest's state between the hyp vCPU and the h=
ost
> per exception class instead of copying the whole context. It adds per-EC
> entry and exit handlers for various traps and routes protected guests
> through them to marshal only the necessary state.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 5925d35abba8c..461e15cab1b92 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > -static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu=
 *hyp_vcpu)
> > +static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     handle_pvm_entry_psci(hyp_vcpu);
> > +}
>
> [Severity: High]
> Does this code omit handling for host-requested PC increments and excepti=
on
> injections?
>
> If the guest executes an HVC instruction, which traps to EL2, and the hos=
t
> handles the call (e.g., standard PSCI fallback) by setting the INCREMENT_=
PC
> or PENDING_EXCEPTION flags, it appears handle_pvm_entry_hvc64() doesn't
> apply them on re-entry. As a result, the guest's PC wouldn't advance and
> it could infinitely retry the same HVC.

An executed HVC has already advanced ELR_EL2, and handle_hvc() does
not call kvm_incr_pc(). Nor is an exception pending:
kvm_smccc_call_handler() only sets the return registers.

>
> [ ... ]
>
> > +static void handle_pvm_exit_wfx(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     hyp_vcpu->host_vcpu->arch.ctxt.regs.pstate =3D
> > +             hyp_vcpu->vcpu.arch.ctxt.regs.pstate & PSR_MODE_MASK;
> > +}
>
> [Severity: High]
> Can this cause the host to read uninitialized or stale data for WFET and
> WFIT timeout values?
>
> When a protected guest traps to EL2 on a WFET/WFIT, pvm_host_esr()
> deliberately masks out the RN field (the register index holding the timeo=
ut)
> from the host's view of the ESR. Because of this, the host's
> kvm_handle_wfx() expects the timeout register value to be marshalled into
> regs[0]. It looks like handle_pvm_exit_wfx() doesn't copy the guest's RN
> register to host_vcpu->arch.ctxt.regs.regs[0] before exiting to the host.

A protected guest's WFIT/WFET takes an UNDEF at EL2:
kvm_handle_pvm_wfx() routes ESR_ELx_WFx_ISS_WFxT to
kvm_handle_pvm_restricted(). It never reaches the host.

>
> [ ... ]
>
> > @@ -418,10 +638,16 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *=
hyp_vcpu)
> >       case ARM_EXCEPTION_IL:
> >               break;
> >       case ARM_EXCEPTION_TRAP:
> > -             esr_ec =3D ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
> > -             ec_handler =3D entry_hyp_vm_handlers[esr_ec];
> > -             if (ec_handler)
> > -                     ec_handler(hyp_vcpu);
> > +             /* Nothing was marshalled for this trap, see sync_hyp_vcp=
u(). */
> > +             if (ARM_SERROR_PENDING(hyp_vcpu->exit_code))
> > +                     break;
> > +
> > +             if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
> > +                     esr_ec =3D ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu-=
>vcpu));
> > +                     ec_handler =3D entry_hyp_pvm_handlers[esr_ec];
> > +                     if (ec_handler)
> > +                             ec_handler(hyp_vcpu);
> > +             }
> >               break;
>
> [Severity: High]
> Does this logic silently ignore host-injected exceptions and PC advanceme=
nts
> for unhandled Exception Classes?
>
> If a protected guest executes an unhandled instruction (like SMC64), it
> traps to EL2. The host cannot emulate the unknown EC and pends an excepti=
on
> via the PENDING_EXCEPTION flag. Because there is no specific entry handle=
r
> for this EC in entry_hyp_pvm_handlers, ec_handler is NULL and the re-entr=
y
> skips entry handling.
>
> Since the generic fallback was removed, the PENDING_EXCEPTION flag is
> ignored, the PC is not advanced, and the guest could hang trying to retry
> the failing instruction infinitely.

Nor does an unhandled EC. pvm_exit_handlers[] defaults to
kvm_handle_pvm_restricted() for every class, SMC64 included, so EL2
injects the UNDEF and returns to the guest.

Thanks for the reviews!
/fuad

>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831163421.27=
2420-1-fuad.tabba@linux.dev?part=3D13
