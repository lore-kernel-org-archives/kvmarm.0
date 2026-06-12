Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22573D8103
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 09:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781257926; cv=pass; b=LO3pNrCp5/zBFGjgkiqZBnXWK+X0ouOOTkQEGfEx8/hJrzJFPGK8f2cqfcWmIMbPeCL9mS8fKeOq3zqjh3hNZwV5yKgLkATl/kLXfG7+260VpfR1uwPJG0QNm9zLunct7PiIZhqtDXg87nye27mTQRPvbSyxaGml1YpuvXJrGkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781257926; c=relaxed/simple;
	bh=yaNMuV9UdaBji84hWn7pBPFUiDauO11i4mtg1wVBcdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GY5VeI79Yj0vlE76IRsRzToxYRoy5Q906tRWSdMVZ+6i9mzjJXsAGSNT3bVZnZI+9mO0D3ZS7QTRfAUsFqz5UZdi/KDY4hg62K2GPnh3lvDft/pNZj+O1S3Wcpg0TDaY74TzYqFw5jNDXGK/DDUVp/BQli1ZBWaLAtm2dU2s2nU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bMlhcaMW; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bMlhcaMW"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765531803so467351cf.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 02:52:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781257921; cv=none;
        d=google.com; s=arc-20240605;
        b=QGkJO869H1AXX2fSM+4BDSfOXsQQYNM+RH6vPCDB8ecwT+aZddwX69zR49QikFNCJ8
         +ejylYtAOrdWBH+puiSFLYDpybTIvlGYT/ZZ1n7Oy5OXjfApfEAVPzUNu9Kcdswm75/X
         HoCOEijlGR1HYac2cjHWa5p5Zs9QZCOGrMb4wMgvmYhqzODPsPTfbl9sAzVbsfZNcGIP
         wY8kPAkebAjSrwlvidDSxtqwlLNf0gbANO1Qy4dvt3h638zIV0qcxj96R+yBMcRNvGk8
         jFfSKzIuTaIrsSzUwWky6OfT7zN70ZrJTLnki2d5MF//FnpyWE8tm7QIIhK2sHEZOxkS
         +a5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s4SpZQpjEPljxy/WgjoqC1DpMQWlgwRuaSSFW97SwTk=;
        fh=NgYvy1kDsW4wf8pyPsB8sBTIaLWXPgov/QeAIJv8NPU=;
        b=JLOwC0LzPfvY6rVtsSq179/jy7VusyThyImtZN46b9ttWq8b20p+H65e2Vg9BS5Me+
         hx8kkKWIwyJmtWI+FSPVpxASNeDQn/m+8gyZdqrKkXD36u+qYkdr63hA6KhXvHIHWj7y
         3yL6j7tzcyRkrxSnBPm9FdW1B8HdudBtmx3W7jZkh7tBMHQ0JFqHT3NxAlq44Hh1Q4gF
         HKNEXtpb0o91XWfElmTw8RePzsi53Lo9iqIIKJjlLY9ShlJxdxlYEbGnrqZsIAFiN36M
         rj0qSszeipNRMDYYpf6aVamo06CoRUI+SErJEn5PnKPOFx8yWQerJOBPNP1wsnLTQ3uk
         3+Tw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781257921; x=1781862721; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s4SpZQpjEPljxy/WgjoqC1DpMQWlgwRuaSSFW97SwTk=;
        b=bMlhcaMWJ44a4OWzXPNw1rBUOi/6EFF9SxW4NF4jfDLDdj7s/1SExVZGIlNLZ70och
         TjHff3UGFLPfARCGyvsaMwhEGjavOEtVOtE2BTCC6kKq5tLmb5lfLb+iqTzTF77dMR4W
         SbybwUo4uMuTnSuATXC7OYplsdXP+BJ4/pd3mJHwEZXSLMrSXOyXxp1YvAzvXnuDmFI2
         Bz+G+i/jKj7WN12WV2aaIhMMATGL0Y/nfedqxpL8KnJxakvOVflO5pjjuqQO5weJ6kuf
         JCcXwwdSJMyh8XwgCDBzQXTxH9Uy27oHpigtZAsATzsF/ZU+os8HuCt0bYgYy+5QYgOl
         AZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781257921; x=1781862721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s4SpZQpjEPljxy/WgjoqC1DpMQWlgwRuaSSFW97SwTk=;
        b=CQpzE1EjiNd72jWHK2FwP+RkebniJ91yyH6UrWloXY92y0ewgioDvvlKV2y5Xe9+3f
         +LG8SHO8PlQ/bLLrxSkPbluR+7B3QEtq5TV4aj27xNlaELvYXBOVfui4GfAJpDptjK24
         poykh9vjFZG/UI6t1Idb7XrccgIIG1tZZ9sZpgeCICSB/5S+pF+b/WEmqmFhOxULdvgO
         pW3/OnNZ52/BUB5SAuWovBHj/tZNr9dSV4tQl0XMj+PBTOMiX6H23FRD49oAHFXF2GlP
         icUcGZoNbHZ6CGyThbKlppNA8/isIo1GW4BOqstZcwq2hiormBf/kyunnm4ITRpNXkbY
         GVgA==
X-Gm-Message-State: AOJu0YzUyOqy0ULKH8VgTpfmRh1R41wWSQPm87clGhKAmO5pZbEaZYJH
	YX2I9aGVITX6OOpf+GalfKtPkY6HOmuQq61FCXLqoBBgV2zy0JawVguRrorm4sWd0ueCTcy7iRD
	YsWu9eTGwwieRT9fbSkfEYRVlRP5b4QNI/GIfSvfA
X-Gm-Gg: Acq92OECz9wPqybK+H92fge0AATlZ/IrAKk0fZ8R/nUj8fKwdKBXcSKEbR94Riub+lA
	hDbRmnvPsuRsG+M2wlbr5Q6kYdpCQzpD9lublT9PWW/cEL7RzLmqg175HU4jL1DZ4fVN2AOwZ0U
	X/FS8gaykIc2zwb89kaK5Oj100M3yyBxLUzN8NXDnqlgTa9OVngcHRiVvxPY4TJA8UKO8QuwnrN
	yC13a0W8527Kj8ZnhRfwyRWbotN9CUKGZjUJvX4nioXfOrCHZmCmxmlWHgz7OvrufI22MYoKWvk
	n3dPsnS6
X-Received: by 2002:a05:622a:4187:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-517fc3bb2fdmr5346851cf.3.1781257920800; Fri, 12 Jun 2026
 02:52:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-12-tabba@google.com> <20260612071924.480E41F000E9@smtp.kernel.org>
In-Reply-To: <20260612071924.480E41F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Jun 2026 10:51:24 +0100
X-Gm-Features: AVVi8CfPcYgp60KT4bL0q7MbY4Iy6KmpKwrk7cw2_AY80hFmnxZbh8EnRgpLpNI
Message-ID: <CA+EHjTxLVo=GwderoFxqsOEFXV+DrD17nQCkPbnKZPA6mRNxhg@mail.gmail.com>
Subject: Re: [PATCH v1 11/11] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You finally got me Sashiko... you finally got me (and on the last patch)...

Will fix in the respin. Details below...

On Fri, 12 Jun 2026 at 08:19, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> New issues:
> - [High] Lazy vCPU state sync bypasses vcpu_mode_is_bad_32bit() check on =
non-trap VM exits due to stale CPSR.
> - [High] Exceptions injected by the host and other context modifications =
during the KVM_RUN loop are silently dropped, causing infinite VM exit loop=
s or ignored requests.
>
> Pre-existing issues:
> - [Critical] Protected VM register state is unconditionally copied betwee=
n the hypervisor and untrusted host, violating pKVM confidentiality and int=
egrity guarantees.
> --
>
> commit 96ecd36038c29097f333a40bf0eebd7b62bffc92
> Author: tabba@google.com <tabba@google.com>
> Subject: KVM: arm64: Implement lazy vCPU state sync for non-protected gue=
sts
>
> This commit implements lazy synchronization of vCPU register state for
> non-protected guests running under pKVM. It defers copying the context fr=
om
> the host to the hypervisor until the host marks it dirty, and from the
> hypervisor to the host until the host requires it. The PC is synced on ev=
ery
> exit to maintain accurate tracepoints.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > index 54aedf93c78b6..dccc3786548b0 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> [ ... ]
> > @@ -489,6 +504,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int excepti=
on_index)
> >  /* For exit types that need handling before we can be preempted */
> >  void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
> >  {
> > +     /*
> > +      * We just exited, so the state is clean from a hypervisor
> > +      * perspective.
> > +      */
> > +     if (is_protected_kvm_enabled())
> > +             vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
> > +
>
> [Severity: High]
> When a guest exits (such as for ARM_EXCEPTION_IL or an IRQ), this clears =
the
> PKVM_HOST_STATE_DIRTY flag.
>
> If the host handles the exit or processes pending requests (like
> KVM_REQ_VCPU_RESET or injecting undefined/SErrors), those operations modi=
fy
> the host's copy of the guest register context (vcpu->arch.ctxt).
>
> However, since these paths bypass handle_trap_exceptions(), the
> PKVM_HOST_STATE_DIRTY flag is never set again.
>
> On the next guest entry, flush_hyp_vcpu() at EL2 will see the dirty flag =
is
> clear and skip calling __flush_hyp_vcpu().
>
> Will this cause exceptions injected by the host and other context modific=
ations
> made during the KVM_RUN loop to be silently dropped? For ARM_EXCEPTION_IL=
,
> does this mean the hypervisor will re-enter the guest using the old,
> unmodified register state, causing an instant re-trap?

No loop: PENDING_EXCEPTION rides in iflags (flushed unconditionally),
so EL2 re-derives and
delivers the exception on re-entry. It did surface one real gap:
enter_exception64() doesn't
write ESR, so an unmasked SError's ESR_EL1 syndrome was dropped under
lazy sync. Fixed in the
respin (sync + dirty before host-side SError injection).

>
> >       if (ARM_SERROR_PENDING(exception_index)) {
> >               if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
> >                       u64 disr =3D kvm_vcpu_get_disr(vcpu);
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 23e644c24a03a..02383b372258f 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -168,7 +211,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *h=
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
> > +                     __flush_hyp_vcpu(hyp_vcpu);
> > +     } else {
> > +             hyp_vcpu->vcpu.arch.ctxt =3D host_vcpu->arch.ctxt;
>
> [Severity: Critical]
> This is a pre-existing issue, but I have a question about this copy opera=
tion.
>
> This executes at EL2 and copies the entire vcpu.arch.ctxt from host_vcpu
> (memory accessible to the untrusted host EL1) into the protected VM's
> private state.
>
> Could this violate guest integrity by allowing the host to hijack the VM'=
s
> control flow?

Existing upstream behaviour, unchanged here. The follow-up series
replaces this copy with
per-field marshalling, which is what establishes protected vCPU-state isola=
tion.

>
> > +     }
> >
> >       hyp_vcpu->vcpu.arch.mdcr_el2    =3D host_vcpu->arch.mdcr_el2;
> >       hyp_vcpu->vcpu.arch.hcr_el2 &=3D ~(HCR_TWI | HCR_TWE);
> [ ... ]
> > @@ -191,9 +244,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >       fpsimd_sve_sync(&hyp_vcpu->vcpu);
> >       sync_debug_state(hyp_vcpu);
> >
> > -     host_vcpu->arch.ctxt            =3D hyp_vcpu->vcpu.arch.ctxt;
> > -
> > -     host_vcpu->arch.hcr_el2         =3D hyp_vcpu->vcpu.arch.hcr_el2;
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +             host_vcpu->arch.ctxt =3D hyp_vcpu->vcpu.arch.ctxt;
>
> [Severity: Critical]
> This is a pre-existing issue, but I have a similar question about copying
> the protected guest's register state back to the host here.
>
> Does copying hyp_vcpu->vcpu.arch.ctxt back into the untrusted
> host_vcpu->arch.ctxt violate pKVM confidentiality guarantees by leaking
> the state to the host?

Same as the flush side: unchanged here, established by the follow-up
series' marshalling.

>
> > +     else
> > +             /* Keep the PC current for the kvm_exit tracepoint (lazy =
ctxt sync). */
> > +             host_vcpu->arch.ctxt.regs.pc =3D hyp_vcpu->vcpu.arch.ctxt=
.regs.pc;
>
> [Severity: High]
> Since handle_trap_exceptions() is only called for traps, an exit like
> ARM_EXCEPTION_IRQ won't trigger the __pkvm_vcpu_sync_state hypercall.
>
> Because this code only synchronizes the pc field for non-protected guests=
,
> vcpu->arch.ctxt.regs.pstate (CPSR) remains stale in the host vCPU context=
.
>
> Does this lazy synchronization leave the host with a stale CPSR on non-tr=
ap
> exits?
>
> If the guest transitioned to an illegal 32-bit mode immediately before th=
e
> IRQ was taken, would the KVM_RUN inner loop evaluate vcpu_mode_is_bad_32b=
it()
> using this stale CPSR, bypassing KVM's architectural protection against i=
llegal
> AArch32 execution?

Yes: stale PSTATE on non-trap exits, non-protected only. Fixed in the
respin (PSTATE synced
alongside PC every exit).

Cheers,
/fuad

>
> >
> >       host_vcpu->arch.fault           =3D hyp_vcpu->vcpu.arch.fault;
> >
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.75=
5562-1-tabba@google.com?part=3D11
