Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B01033436A
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254524; cv=none; b=QJGYx7FZ89V8kXmud1YR0hghnxP/FLnlOD+Ew8iUiG4/8rg355O8j8fJyee83OZjsr6z3/KO9jYTRAqeTJV9qaQ7tL+/gsDJqISfHrdHcQ8Y3bKOJhn5UJhz+sM3w14FxXne6JOiMtMeBLOa5P0gBo9PxEFhi5PG2jwCqJfRbLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254524; c=relaxed/simple;
	bh=1IlaOxFWU3rpeiIHBvRb1uHRvj5oCzpB41EXx0yBvF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rBXNHaPFUir50JGseNqY+x2SNy26Rz4sgVQiV5sZ6CiTIlJ6z7bRUtV81A4mKj0mg1gQLA+NxN5tHhTvuecx5g2eD3U+NYxHQ2jDid8J3C+2edES2B9aBmIkh6dKfHtnm0vFW0/5yw/JHcIDdgjp+hqpxPb/Lj0xZd5tFH9V5P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qng84tqf; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qng84tqf"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4edb8d6e98aso387501cf.0
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 06:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764254521; x=1764859321; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CPCyrID5c/tHs4/7/55sixEXvWOHWzu46qNqSyPa2CE=;
        b=qng84tqfJ2gtLsD59FWNQFLlXHIAERCKlY5CaBIw9MBKXgeHAatAy1PC83ZQbInzd8
         6hPAun1z7pbJCbqdhK2hQ6z+1fQFk5LPtNzrsUqw67dFCjPZ8FcAhVSTL5XVtOIY6pGx
         itf55iVTVS0FS0LWjk+zbYQEB+4gpgCqLrucF1XPsZBfkKX0ZhDbhime5XV6rQTPgZrn
         isMRYQbVJWLvJIsi0AUUZe5ukbMkrofv9S0F0uPo8DfZUjWQU/XAwsHtdNrUzU0PuZxT
         apAw2/zIBN4qupvlvQMynfgXznwo5Ym2jQjMPp8TZfBpW/ysCzj+pn87xv8OIzBuieNu
         Jevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764254521; x=1764859321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPCyrID5c/tHs4/7/55sixEXvWOHWzu46qNqSyPa2CE=;
        b=WusKaWFGj3Vu+XcGQXm9mmuzW/FvSmyRGm07DzlWqfrEXp0LzdDfFbjeFGc5pvqCLG
         xggKxPfvNZbApJNkRRBc+aGNWk5eyJC30lno46muBxvvmKzWVyrHqiOHP1FulLc6yDf6
         7JuFl1Uf1I+CDmkrbrwkF/JQeA0yxFqpdg7VSkRK9iDardT20mjH2GOBlUlQm0672X4K
         H4khUjH+6H7PV1i6+swtWcEiQDGKrdAY0dIKX0RbZHMcOshRUqWOuERM552VZhXU+qb8
         wfR0zyoosfx0zQcLFra0e6yD6yQHDqIgmpoVipm6SreX+wbJNRJI/+qHm+o7HfFipqWo
         f41g==
X-Gm-Message-State: AOJu0YwQrhtj4uA+2BwsPkLK5ql5CRVs4T/8ABlCs+hSwjIE/F8NHtXE
	jGkY99zPmJonyPbjA5cCKI+I6yEa5LxKBKsHS6Zn0WeYyvJuB6QrWELLhRunJCI7JxDaJZBLx8A
	xLZLWNNyB6Kfkejgtd6y3jsDqoFVU54yyZkKslfWu
X-Gm-Gg: ASbGncsy2HqWFZl8Y2ON8np9vvEXtY5RlUWGyLkWk6OGVJ3xJmx5CnDvTS7nOKxwrjx
	9RuWHTIhJcev6CugBj+B0aULgRjRnd1fHRH8Aj9jkQB+n0oWIQ+sjO0MCdcNIIkH9+PFJjx02D+
	Tc4f+w6NH1AskQETWcphGFFlU9iXAbtO1QG16A3XlgcAYiQzrz+KXIbXBQ80lb6qJ+mDcQPU3w/
	Kiea899zRCMwOLW8zB8LCH2fHZqYCMxZ0bzHm0SBW5aa/R4N6Za4lJ5TCmG5tRoqgYwvME=
X-Google-Smtp-Source: AGHT+IEvOReB+QeleLtSN0F2f5YKf6WqFvgp/w6xqbY/X02DfIQnSyuKWL8wM7Xf0Dv/gF9wW71/cQ4fRe46i351NDg=
X-Received: by 2002:a05:622a:54b:b0:4ee:40fb:d2e7 with SMTP id
 d75a77b69052e-4efd0cc5434mr4659811cf.20.1764254521051; Thu, 27 Nov 2025
 06:42:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127122210.4111702-1-tabba@google.com> <20251127122210.4111702-5-tabba@google.com>
 <86345zr24c.wl-maz@kernel.org>
In-Reply-To: <86345zr24c.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 27 Nov 2025 14:41:24 +0000
X-Gm-Features: AWmQ_bmXs4f0B9KhCjDSmGn5zPBptXNndJQXBS9Qk5J98RtBGlIoKV9rr83Hjg4
Message-ID: <CA+EHjTz9fJ2892TNn-hy3aiQA6Cxj6xuFUBKQhpDOnsHkDtdwQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/5] arm64: Inject UNDEF when accessing MTE sysregs
 with MTE disabled
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 27 Nov 2025 at 14:17, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 27 Nov 2025 12:22:09 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > When MTE hardware is present but disabled via software (arm64.nomte or
> > CONFIG_ARM64_MTE=n), HCR_EL2.ATA is cleared to prevent use of MTE
> > instructions. However, this alone doesn't fully emulate hardware that
> > lacks MTE support.
> >
> > With HCR_EL2.ATA cleared, accesses to certain MTE system registers trap
> > to EL2 with exception class ESR_ELx_EC_SYS64. To faithfully emulate
> > hardware without MTE (where such accesses would cause an Undefined
> > Instruction exception), inject UNDEF into the host.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 44 ++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 29430c031095..f542e4c17156 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -686,6 +686,46 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
> >       kvm_skip_host_instr();
> >  }
> >
> > +static void inject_undef64(void)
> > +{
> > +     unsigned long sctlr, vbar, old, new;
> > +     u64 offset, esr;
> > +
> > +     vbar = read_sysreg_el1(SYS_VBAR);
> > +     sctlr = read_sysreg_el1(SYS_SCTLR);
> > +     old = read_sysreg_el2(SYS_SPSR);
> > +     new = get_except64_cpsr(old, system_supports_mte(), sctlr, PSR_MODE_EL1h);
> > +     offset = get_except64_offset(old, PSR_MODE_EL1h, except_type_sync);
> > +     esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
> > +
> > +     write_sysreg_el1(esr, SYS_ESR);
> > +     write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> > +     write_sysreg_el1(old, SYS_SPSR);
> > +     write_sysreg_el2(vbar + offset, SYS_ELR);
> > +     write_sysreg_el2(new, SYS_SPSR);
> > +}
> > +
> > +static bool handle_host_mte(u64 esr)
> > +{
> > +     /* If we're here for any reason other than MTE, then it's a bug. */
> > +
> > +     if (read_sysreg(HCR_EL2) & HCR_ATA)
> > +             return false;
> > +
> > +     switch (esr_sys64_to_sysreg(esr)) {
> > +     case SYS_RGSR_EL1:
> > +     case SYS_GCR_EL1:
> > +     case SYS_TFSR_EL1:
> > +     case SYS_TFSRE0_EL1:
>
> How about other things, such as DC GVA? Don't you need to trap and
> UNDEF it (which has the side effect of also trapping DC ZVA)?
>
> Same question for all the DC {C,I,CI}GVA{C,P} instructions.

As far as I could tell, none of these are trapped by ATA. The spec
says that in the absence of MTE, their behavior is undefined --- which
is the same for the ones I'm actually handling here...

The reasons I've only handled these is that, when booting a system
with a misadvertised MTE, the kernel accesses these registers, and
injecting an UNDEF resulted in a nicer failure mode.

What do you suggest, drop this patch (and the one before it), since
trying to access MTE is UNDEF, and the kernel that does it is just
shooting itself in the foot (no security implications)? Or edit the
commit message to make it clear that this is best effort, based on
what ATA traps?

Cheers,
/fuad

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
