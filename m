Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FC837F8CB
	for <kvmarm@lists.linux.dev>; Sun,  2 Aug 2026 11:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785670026; cv=none; b=MJlBiE1geJESrSwiftp9CvlZCMY1arVpTsbNyJfp7yNOjupzAv+kdTgc2BhCuyx0f75r4jT/JwJWuiv8Jvg2NP+THcaq9wrOvhCs8MVxpNh4m6hSfHhH3GyPeawtgTQDWXSMIGg9IMc9SlnDPc7PgRV2uufO2FG/l1LYQDnczKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785670026; c=relaxed/simple;
	bh=nF7coVV2kHVyCGtcpiZP2E1d/ovYal2Im5xsbDTZzxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lnj3e25es7ds1KImc9kbChyoEJ4MYQiMDIA9lArAvcj1BQxt+E9NDNzullCvkm7s40EVBou+5pinwwYYmsea3kLRdSukVbNDRy8eUHjSxlTz0rnu55Awc0H8eUuxoDqLIKxz95MgBKan/Kq19DohBz/Dxsxjtdh3MFuXPVGmkPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qUCD4pA6; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qUCD4pA6"
X-Forwarded-Encrypted: i=1; AHgh+Rq2UjM2cNWOwQWb+2qMwFFf9djxH0lxUI9d0rW/CnTUa+WkEX00Mn5vCqiWzCnMpLcOM0RZZOI=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785670021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8+9qFQ09vt18LEHf6NmsyCgwHmScAV6wHk8xYDd+6c=;
	b=qUCD4pA6a34sbaS+dohJ3cRuytOSqbwoqhCDJ9pojWTXzasQQOwbEeVWsguVFnkEWMLlTK
	QIY+20aMJz6KFSnr8gT4IVMrRcsV3dI4Nbd9cwMMnVCIcDGXPJYK4pbglAkgiK1AJ5/zE3
	GA2Pwos/SvCj2pyckJS7vlGhHb2gC90=
X-Gm-Message-State: AOJu0Yx3Gs3A4CkE5/jAhwqv06cNfgBDl++jEoCLoG1xON7bOq+xfgsk
	1S9fQ7Zpv4hQbKYYY16T/sLOFTRhPKoeDnoxzz6ubik/T3mUaSuQ2VTnhnbCKjCHMyMxeDioP3A
	gA98DhDXHTi1YqkD8k4aZgGmeE8mr07qKZZojEiil
X-Received: by 2002:ac8:5f95:0:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-52b5b095101mr19009831cf.7.1785670017506; Sun, 02 Aug 2026
 04:26:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731182231.1277064-1-vdonnefort@google.com> <20260731183852.5817F1F00ACA@smtp.kernel.org>
In-Reply-To: <20260731183852.5817F1F00ACA@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Sun, 2 Aug 2026 12:26:20 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyTjhXLaAA217h9RFXk1HdLPTaAOmQvsij1hyU8Ehigvw@mail.gmail.com>
X-Gm-Features: AUfX_mws5aimaFrj6-svB_5aXuUUDzOjsp4VZrEhfA9Zo7Vb8CZNTXEiHRApe_s
Message-ID: <CA+EHjTyTjhXLaAA217h9RFXk1HdLPTaAOmQvsij1hyU8Ehigvw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
To: sashiko-reviews@lists.linux.dev
Cc: Vincent Donnefort <vdonnefort@google.com>, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, 31 Jul 2026 at 19:39, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] The patch fixes a stage-2 fault deadlock in `print_nvhe_hyp_pani=
c()` by removing the `%pB` modifier, but misses `kvm_nvhe_dump_backtrace_en=
try()` and `dump_kernel_instr()` which both access lazily-mapped host memor=
y later in the exact same panic path, causing the same deadlock.

I don't think either deadlocks. dump_kernel_instr() reads hyp .text,
which is kept RO-mapped in the host stage-2 for panic inspection
(fix_host_ownership_walker(), PAGE_HYP_EXEC ->
host_stage2_idmap_locked(..., PROT_R)), so no fault.
kvm_nvhe_dump_backtrace_entry()'s %pB runs only under
CONFIG_PKVM_STACKTRACE, which depends on PKVM_DISABLE_STAGE2_ON_PANIC,
and that path disables the host stage-2 on panic anyway; otherwise
it's the stub, and non-protected has no host stage-2. kallsyms was the
only lazily-mapped access, so I think this is complete.

/fuad

> --
>
> --- Patch [1]: [PATCH] KVM: arm64: Drop %pB on nVHE panic when stage-2 is=
 active ---
> commit cbd94a7b340a7dc4be01336a040cb8c3d9690ab4
> Author: Vincent Donnefort <vdonnefort@google.com>
>
> KVM: arm64: Drop %pB on nVHE panic when stage-2 is active
>
> This commit removes the %pB format specifier from print_nvhe_hyp_panic()
> when running in protected KVM mode without stage-2 panic disabling. This
> prevents a deadlock caused by a stage-2 fault when accessing unmapped
> kallsyms memory while the host stage-2 lock is held.
>
> > diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.=
c
> > index 54aedf93c78b6..2e1951c215ae8 100644
> > --- a/arch/arm64/kvm/handle_exit.c
> > +++ b/arch/arm64/kvm/handle_exit.c
> > @@ -509,8 +509,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int =
exception_index)
> >
> >  static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
> >  {
> > -     kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
> > -             (void *)(panic_addr + kaslr_offset()));
> > +     /* Kallsyms might not be mapped in the host stage-2 */
> > +     if (is_protected_kvm_enabled() && !IS_ENABLED(CONFIG_PKVM_DISABLE=
_STAGE2_ON_PANIC))
> > +             kvm_err("nVHE hyp %s at: %016llx!\n", name, panic_addr);
> > +     else
> > +             kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic=
_addr,
> > +                     (void *)(panic_addr + kaslr_offset()));
> >  }
>
> [Severity: High]
> This is a pre-existing issue, but does this same deadlock still trigger
> later in the panic path?
>
> While this fixes the memory access in print_nvhe_hyp_panic(), the handler
> nvhe_hyp_panic_handler() subsequently calls kvm_nvhe_dump_backtrace() and
> dump_kernel_instr().
>
> In arch/arm64/kvm/stacktrace.c:kvm_nvhe_dump_backtrace_entry(), there is
> another use of %pB:
>
>         kvm_err(" [<%016lx>] %pB\n", where, (void *)(where + kaslr_offset=
()));
>
> Additionally, nvhe_hyp_panic_handler() calls dump_kernel_instr() which al=
so
> reads the faulting instruction directly from memory in
> arch/arm64/kernel/traps.c:
>
>         bad =3D aarch64_insn_read(&((u32 *)kaddr)[i], &val);
>
> Will both of these also access lazily-mapped host stage-2 memory, trigger
> a stage-2 data abort, and deadlock when trying to re-acquire host_mmu.loc=
k?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731182231.12=
77064-1-vdonnefort@google.com?part=3D1
>
