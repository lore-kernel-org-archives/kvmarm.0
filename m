Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD3A3093BF
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671151; cv=none; b=YmiqAmkjw6Zp4d5LX4zNcZva1uCUhbVCWCD6igqZ71FVJWMyThHHhTqvOP9LF4IFiMswoasuFIMq2DGL3X5a6KXCl0wYVQuhZGUWdeYrC7EiA2RY3gYR5Qd3MettyFOh9y+DocW3PecnMs6ReFVlOz2yAFWTdAc8fJI0bDq2ZXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671151; c=relaxed/simple;
	bh=Ik6C9VmXgN1wYI3826C4SzotRnHQhFaMIAbCeEg5KLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r/0BSv5dG7eMgVLGHLCae/PaKlOi/W+G/Dfti9bwK7Mrmdb3re1CIafBeM7CXB2xBwVbnc6gK9EA9W8HzrsVEacp0xm3Kj+NrP58FHGUercKvVULOB0VScvNDAA4xow2SPu92CCLXRCdeWC7xrRMeh9RxRAqCTRvz/YEMInyHPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KmXycYGi; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KmXycYGi"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ea12242d2eso10841cf.1
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 10:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761671147; x=1762275947; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bf2z3SV0EQFH+NyJBVxm2kYHrg6mEHvbE757ZmlP2HM=;
        b=KmXycYGiAx9GX8hIxY6R7KD+qoPEAVDWcfXNcpcH1j8dl2SoDRxovnAgHosad7lwlr
         r1XsFRyf+ImZt71Jd3KjCghTXMcfr89i0LolR0Oq5bzDN+c6OuNaYPWnR+bnootYk17A
         2S2OvihrLpRF3zUFhwr49+zfWtOqpjPluiPwWnQGMCT1uZ2/guvMs3DkuxUBxNrmUWlT
         GwsyBDq7vPDdCy1hzvPW+bTXqL3WKT7pzz1Uhyw9h7th4yllIrQkHsNluOYQ2sCM4vaC
         VMQpPI31e+AJ6hUukNKqhx/2wIHborZtE4auoI5RMoZa/WZmAfZXj+/K73k41ikPZkUD
         ++uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761671147; x=1762275947;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bf2z3SV0EQFH+NyJBVxm2kYHrg6mEHvbE757ZmlP2HM=;
        b=Goj7lyYZNxINM8fARtCApsJa/0AEOy/+YMtlgj/dE9SfkC6vOxRK7bCLqcSVMvVyTL
         pp8iW9ruiskzkEgjOfqROjksrRWX0bOQJOkIziNNrt4R08Kvo0qAWIb2W+mjQjQL5vpQ
         F9s8pB3CEagHuseSbSJU74txIKav08hyr/w12IDdUEHj0qcKgDWkuDArrf/z3lLTiCwN
         vS8qhfkZ/ltBq86BCOvQd+l91q45Bf+gvnYUnOP9Zs0SxaAJ71mqgdM7BoZ9v+3g1r4r
         Od2V2rUTVjAPIRbOxPYHLIMmwqmQ6qoJHXlFjRcgl/V24UHytqtEsZEU1CKdjWcl/w9e
         x87w==
X-Gm-Message-State: AOJu0YwtjPKxLvANsDjeF5tQJUhCzjQXCXBuIKmTpXWzjxcXgxSSpQgA
	0Q7muofuRJ6Tz+RzcWjQxlFZIPGIkq0WgYYXkd/hdbq6xnBkToq+ej38pNzulDr3gKM9gBDW1Cn
	hjYPhORyb1TL1Q/my3rgP1xKkvwoNCQLMyvBLu6FW
X-Gm-Gg: ASbGncu1On9v3PNuza+IEyT1w/xCVsQsGssEFJjlmTyVKvK/s9yGOHf3cYY0lXdiQt9
	9jLTtoQa7HMmZ334+8ZIN+TK2235193Xte9Yydj4lSIApKVGz1ReLuTLHQnlXXsF8JQnbnXFtuv
	eS7ZpgCNgujkq2gxLovMW8xJw4PNjTcrfcVPOZNxV2hksLm1t3CZxSefsh4Tkcyk23rFfTHfqXf
	hvuM2d0fYdVXjD8z2CG1S6cuBqzIl/9+gjskXcg7Iqg2xQLkJ5O8PulrOq5sg==
X-Google-Smtp-Source: AGHT+IGnY2q/qW4n//fPnWZOK39ysZoDAJatQaFWpDai28muI3fakRyU9rfMXBXhQMs1gaa0OISkshUNrKoqf5k61r0=
X-Received: by 2002:a05:622a:1b26:b0:4b3:1617:e617 with SMTP id
 d75a77b69052e-4ed09f6156dmr6051941cf.11.1761671146391; Tue, 28 Oct 2025
 10:05:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027113943.1282568-1-tabba@google.com> <20251027113943.1282568-3-tabba@google.com>
 <86y0ovuwn8.wl-maz@kernel.org>
In-Reply-To: <86y0ovuwn8.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 28 Oct 2025 17:05:09 +0000
X-Gm-Features: AWmQ_bncQG7II35IK71jUNPHsUYcvYPp771U9qg-aPTyfjBogXSI_xu2S7Lw39E
Message-ID: <CA+EHjTzQBfqyxtzp+4UHyCFxoEfKG4RXLfLLz==Y6t6omfckfw@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: arm64: Add compile-time type check for
 register in __vcpu_assign_sys_reg()
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Tue, 28 Oct 2025 at 10:51, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 27 Oct 2025 11:39:41 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The 'r' (register) and 'val' (value) parameters in
> > __vcpu_assign_sys_reg() can be easily transposed. The register ID is an
> > enum, whereas the value is a u64. This has led to bugs in the past, and
> > the risk was increased by the historically inconsistent parameter
> > ordering of the vcpu_write_sys_reg() function.
> >
> > To prevent this class of bugs, add a compile-time type compatibility check
> > to prevent the 'r' parameter from having a 'u64' type.
> >
> > This directly catches the erroneous transposition (passing the 'u64'
> > value as 'r') while remaining flexible, as it does not force 'r' to
> > be a specific enum type.
>
> I don't think that's enough. It is too easy to pass a u32 and
> accidentally bypass this check. I really think we should redefine the
> register identifiers to be a fixed value structure, something like
> this:
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7501a2ee4dd44..18f65dbff2379 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -624,6 +624,12 @@ enum vcpu_sysreg {
>         NR_SYS_REGS     /* Nothing after this line! */
>  };
>
> +struct vcpu_sys_reg {
> +       enum vcpu_sysreg reg;
> +};
> +
> +static const struct vcpu_sys_reg vcpu_sys_reg_SCTLR_EL1 = { SCTLR_EL1 };
> +
>  struct kvm_sysreg_masks {
>         struct {
>                 u64     res0;
>
> and then enforce that whatever is interpreted as a system register is
> actually one of these structures (with some creative cpp wrapping to
> make it less awkward).
>
> In a way, this is similar to what we are doing for page table
> manipulation, where pte_t is a structure wrapping a u64.
>
> If we move to such construct, it becomes impossible to swap value and
> register, and we can stop worrying about that.
>
> Thoughts?

I looked into this some more, and the issue is that the number of
callers who refer to members of `enum vcpu_sysreg` is really big, as
well as the functions that access its value (in if or switch
statements). It can be done, but the amount of code churn would be
huge, that in practice I don't think would be practical.

Another check I thought of, which is more robust and would catch all
cases we have encountered in practice is something along the lines of:

BUILD_BUG_ON(!__builtin_types_compatible_p(typeof(reg), enum vcpu_sysreg) &&
    !__builtin_types_compatible_p(typeof(reg), int));

This ensures that you cannot pass anything other than an enum value,
or an int, as a sysreg. U32 and U64 would trigger a build error. I
tested this, no callers needed to be changed and it did catch the bug
I am trying to avoid. It's not as robust as wrapping in a struct, but
it doesn't result in any churn.

What do you think?
/fuad


>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
