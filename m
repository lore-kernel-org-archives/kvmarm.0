Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C522222CA
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 08:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764320055; cv=none; b=bdhQOpVgEBYC6GXYNDSHLGZ+RUpKnCv5+UWaGihExDdOW0YYcyk6ceCNOFc3tKhFRuyPizG2jYyht4xIEc82s1UD5OzIWl/3T5W9kqJAjjgeiKYGJRKIJENoKj6wcnrvQS4OeWF7DbbQ0BSjn7GNeZkXcko35D5pJFz5ZEqijB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764320055; c=relaxed/simple;
	bh=ffXDpp7oOT54nIPuLQmb6+kwxqxbXOmIeNNxHRk5Fik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uyRXJH0wApRdsLvKLg5Wjp2tqcB7+Jld4peGArLMg7KEDR4tT6t/WtuC4U0xZPkhDLp6vps8st77a45GmPELCBgju+bH9dAoGUOV+CzTDXJL6rX9AlINixIG+7KFWipvZLq5YQFghe+xS3oBDWuDS9OG77bvWvrNUlcbV2903VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nSAx73Z3; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nSAx73Z3"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edb8d6e98aso635961cf.0
        for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 00:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764320051; x=1764924851; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rDvZWMaEJ7qiFYzf5QHvGpUfV6X47c66PVJLPnZe19E=;
        b=nSAx73Z3lkAX6CoQLoMY336u910vpiEykm7HuJi21gsi+//DST3OrxFVSd4da2jY5k
         vFN4Q9QOVwVpKM6hyJCCARUkkaV3icr1JOsPywyOZBBztkTMBTRKznHNswmpZ38Hcr6s
         UgvDSNya0JlhuuX9U/cjAn3nEocW000SogTJyM6NOZDakDWdHfV5C4OAZixWboyzWW7v
         YYtISCCp8oE902NWRg5IJV0NrhtDw9eNN2LXyQRX3ZP2QVt1lsg48M6c2MZWbqA8Mcse
         0gCpDRZeTQeASjbDIKBDmNeG8c3hcpyp0KgPTy6EIg1LD3pcTNw7xACz53T7f0owb9PQ
         61GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764320051; x=1764924851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDvZWMaEJ7qiFYzf5QHvGpUfV6X47c66PVJLPnZe19E=;
        b=Ve2iWHD2/aKr2R6J55uYs95YjOA2Z/qdU03UW1TwWBhw6o46FfFFfXwPpiKTePnkPH
         awGIeLrvvM73ElvCKj8k164sSCeeNXcuUpfF5mN9y54PNsWwu1HZrQ+CmNN9f9UnONoD
         UMmJAt1+wsTlyEsQWLN7yhht/hp1q4jRXgG01Oo71q2E2bxyP4JDSleQzPlShoXr/rpe
         PozzfYZ3h9EG/HYYztTVUw+pXnSKNkeBBoadlZHrsELV673sLOB1jwQDgj0CZ/qelef+
         pchbTeWAxLikqyJNdw5534OMs13By9BSsztbMnnXTxg4UlfBjEOXVhzbWbRxnSy7TIFq
         PWPQ==
X-Gm-Message-State: AOJu0Ywjtu3xY9SGqV2op5lT4TvWucCiEKLTwv2+4iMI0eSk7/ICnwnM
	l596nCaaxIGodXhG614xj1WsihghvgD9tFhsofHfU0GGvSQqKQx2RM49/XTggCnV5JLUh39+ELG
	zvEP0Q8WaNe2MuIdLEqSsONPeQCD4voFuhxTImen6
X-Gm-Gg: ASbGncsiLLile1YerXJ4P5r3vHJ52wRjP17L8QhlrYh2sPZcIguBa8CpXRvfljNTl2o
	9MBJ/0kpltRMxrqzOsPJ/G0gWC4jG3m1L6iE/Miuk+wlla4C9xd94XqbbqTtcS4tEE4TifcuAAM
	HlUa+f1dH9uJuCPiJeQFgJdMO6kOUNyBbMFxgym7hI7JOPoJ/EJDc2kgWbsrt2iVm5czJF/Y0aJ
	WPWhSe3RVpar8+TQNpzKEE52THvQ26Fadkxyy8X3arSuY8mQw0GZJ4brIQ9l9o2+Qee448KT6O4
	v5xEaQ==
X-Google-Smtp-Source: AGHT+IHPym1ODtpAi9CMgE0hTp4o0fYMzlmczHF3vLdk+9RNCcByYNv22XLMdnl+3/yYSpI5Pmaxpz+/OUvckY3j+Sk=
X-Received: by 2002:a05:622a:198e:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4efd0c63439mr8008681cf.2.1764320050941; Fri, 28 Nov 2025
 00:54:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127122210.4111702-1-tabba@google.com> <20251127122210.4111702-5-tabba@google.com>
 <86345zr24c.wl-maz@kernel.org> <CA+EHjTz9fJ2892TNn-hy3aiQA6Cxj6xuFUBKQhpDOnsHkDtdwQ@mail.gmail.com>
 <86wm3apmxu.wl-maz@kernel.org>
In-Reply-To: <86wm3apmxu.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 28 Nov 2025 08:53:34 +0000
X-Gm-Features: AWmQ_bkR-70oLk2BukczwycCfDcP-ZO9JBqbtZx5xbkCA_MuBEHdD2g3hg0iJ9g
Message-ID: <CA+EHjTzg=BQNKDDgbGjSOQ7GuRW1JAoyXNygHTYPba5g7_0Fgw@mail.gmail.com>
Subject: Re: [PATCH v1 4/5] arm64: Inject UNDEF when accessing MTE sysregs
 with MTE disabled
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 28 Nov 2025 at 08:43, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 27 Nov 2025 14:41:24 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Thu, 27 Nov 2025 at 14:17, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Thu, 27 Nov 2025 12:22:09 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > When MTE hardware is present but disabled via software (arm64.nomte or
> > > > CONFIG_ARM64_MTE=n), HCR_EL2.ATA is cleared to prevent use of MTE
> > > > instructions. However, this alone doesn't fully emulate hardware that
> > > > lacks MTE support.
> > > >
> > > > With HCR_EL2.ATA cleared, accesses to certain MTE system registers trap
> > > > to EL2 with exception class ESR_ELx_EC_SYS64. To faithfully emulate
> > > > hardware without MTE (where such accesses would cause an Undefined
> > > > Instruction exception), inject UNDEF into the host.
> > > >
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 44 ++++++++++++++++++++++++++++++
> > > >  1 file changed, 44 insertions(+)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > index 29430c031095..f542e4c17156 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > @@ -686,6 +686,46 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
> > > >       kvm_skip_host_instr();
> > > >  }
> > > >
> > > > +static void inject_undef64(void)
> > > > +{
> > > > +     unsigned long sctlr, vbar, old, new;
> > > > +     u64 offset, esr;
> > > > +
> > > > +     vbar = read_sysreg_el1(SYS_VBAR);
> > > > +     sctlr = read_sysreg_el1(SYS_SCTLR);
> > > > +     old = read_sysreg_el2(SYS_SPSR);
> > > > +     new = get_except64_cpsr(old, system_supports_mte(), sctlr, PSR_MODE_EL1h);
> > > > +     offset = get_except64_offset(old, PSR_MODE_EL1h, except_type_sync);
> > > > +     esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
> > > > +
> > > > +     write_sysreg_el1(esr, SYS_ESR);
> > > > +     write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> > > > +     write_sysreg_el1(old, SYS_SPSR);
> > > > +     write_sysreg_el2(vbar + offset, SYS_ELR);
> > > > +     write_sysreg_el2(new, SYS_SPSR);
> > > > +}
> > > > +
> > > > +static bool handle_host_mte(u64 esr)
> > > > +{
> > > > +     /* If we're here for any reason other than MTE, then it's a bug. */
> > > > +
> > > > +     if (read_sysreg(HCR_EL2) & HCR_ATA)
> > > > +             return false;
> > > > +
> > > > +     switch (esr_sys64_to_sysreg(esr)) {
> > > > +     case SYS_RGSR_EL1:
> > > > +     case SYS_GCR_EL1:
> > > > +     case SYS_TFSR_EL1:
> > > > +     case SYS_TFSRE0_EL1:
> > >
> > > How about other things, such as DC GVA? Don't you need to trap and
> > > UNDEF it (which has the side effect of also trapping DC ZVA)?
> > >
> > > Same question for all the DC {C,I,CI}GVA{C,P} instructions.
> >
> > As far as I could tell, none of these are trapped by ATA. The spec
> > says that in the absence of MTE, their behavior is undefined --- which
> > is the same for the ones I'm actually handling here...
> >
> > The reasons I've only handled these is that, when booting a system
> > with a misadvertised MTE, the kernel accesses these registers, and
> > injecting an UNDEF resulted in a nicer failure mode.
>
> But it all comes down to *why* is MTE disabled. Is it because the user
> cannot be arsed with MTE's abysmal^Wstellar performance? Or because
> this is a memory corruption vector on a misconfigured platform?
>
> > What do you suggest, drop this patch (and the one before it), since
> > trying to access MTE is UNDEF, and the kernel that does it is just
> > shooting itself in the foot (no security implications)? Or edit the
> > commit message to make it clear that this is best effort, based on
> > what ATA traps?
>
> No, what I am simply pointing out that that there is more to MTE than
> what gets trapped by ATA, and my hunch is that when MTE is disabled on
> machine that actually has it, it is because something is deeply broken
> with tag management (I have one such machine).
>
> So depending which side of the problem you're on, this could be either
> perfectly valid, or just missing the point.

I see your point. Of course, my main concern is security and
protecting the guest and the hypervisor from a malicious host (and of
course the other way around, but that's the case in non-protected mode
as well). When MTE is disabled, I think most (if not all) MTE-related
instructions are UNDEFINED.

As far as I know, for the devices I've run into, the reason to disable
MTE has been either performance or lack of support. So for that case,
I think that this solution is enough. On the other hand, if the
hardware is broken, then we can try to mitigate as much as possible,
but I think that at the end there is so much we can do.

So for now, I would think that this is enough. If we encounter cases
that require more hardening, we could add that later.

What do you think?
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
