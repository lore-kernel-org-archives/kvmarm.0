Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FC8212557
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 09:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761818075; cv=none; b=f/RTrH+WqbjMFjDCUpCXH5/DjcUYPiUfXdUt7k3oNzURKCWBmBFoc9GPp4V+GPQObypgat4n5bZu8e8htPBv7gglJfwSrHocChFlTFwITQzMVSj4NRotJE1QIUx7KgOU9Yp+uV5GG6rPyXvkh4I9F+EMZZgU73JbVchUDyZ5xGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761818075; c=relaxed/simple;
	bh=F3i/pQTYs/nAoz6XPoViiYXmTs7HA8r4tvalfaSCPsA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fZZ1mQdRESk/HjcjlqMcsHuGh8Vyj0mQSDtVE70syVfLgfz9HKE4KXGCDL/R2UaOKioAekJqKlDcYWYPD5tFYCC03bz2N0cfVdErK5oMWVuNjReXpcOIDDO7S9ZNB9vyoVVWLzfPKVnzdH/LjrQBzd+5D+oWQAZNRI1u4KO0Nk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jFYF+aLy; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jFYF+aLy"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4eccff716f4so223161cf.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 02:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761818073; x=1762422873; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Oq8GXPRA+dEqjyDtGrzVHCvlZcTXdwdp55ZinwRmgnQ=;
        b=jFYF+aLyDuINp8UfKLH/xNzF9GY0+AetLOHUCZlOdB9YkT1V2L1GbzgRXs5InhBjwj
         6if+fT1jWY3kplPAI5RMunv2fgeqW7IGvZyp0iMrwL1DF/Wqx5W5y4qEGr7BlnskYpRG
         tTI3bphf1Vrg3xSx+bUOHNJg8CDIWVW9bf2rgMXuCHKxhekoebF7Q5V4eOG1dTtWdYbq
         76UtQn4d2qXOt3y5jSHGPrVfN7wvvpeMBn8hYICwnWQAHOAguZqhAUgBVGvwruhUTnh9
         a2e+QGW8gk2MpyLG2MhltHBA8HfhfJQUuzT5W9JZwjsWIXm7kO8vKzXUUJ8SYvKest/x
         Bepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761818073; x=1762422873;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oq8GXPRA+dEqjyDtGrzVHCvlZcTXdwdp55ZinwRmgnQ=;
        b=WXimStVJoZ5gQ0fTmAMJAWlgTK5kvmVP4J5xu2dzEanlXt1qx1mIVO35jJXGinawVZ
         gpENIX59FHsbxDkLCYGKfaJIhMyxlJxQ6QhStlszbma3fG9DtHQ8TcPll5P7+YShWYMB
         9bou29CVgZcaLHH5LXa1D/njbhZpYYIDVXj+APXVO2XwdkwYDQCEhUlwFQX7+Uujnbzj
         aCItwSJLIpCQTfJ/WTUVTkWcNpFY5eOlJXFWnU52ashOZ6n+/dKzSufAv8m7L2KaTWu4
         jsBv08PimIxV3M3NNen2HmO3XjUjOrfAyff8ZqZfwFCOs3OZOZ8AgvgqqLslHTr/IMDi
         qAyA==
X-Gm-Message-State: AOJu0YwuXNLH+Al6NZoh/kawu5f6Y9ONhe3mDNSgdSB1tkYdYFV4CTvi
	ABwC35X8GpPeXQQn0YZJvb9dYHQG6xoc+5M9/f2kzpz7NKxe3B2FsjtMMJhb1vN6q8baDCf6WBg
	juvqTtQggKkQCgPP/o/YlKuzbZc6iVLyKQSKQn1y5
X-Gm-Gg: ASbGncspTCAcCiDS8wYqDd/YA0SslptTp77gUkDnhxV76B3g+7Shd+0XNGDEtAHe8Rr
	D7/wyWuShbE2OdV7wRb/A2WLTlQw2RwtE+CpFqndR9ZBpqofL6G+rzCvz/idDgG8A1Imu1GYVLj
	IWb25sZJ1h/d++mCE3AGzpeQ4wU3q9dUYmQJ6AML7mPHw3JdlNC0brpWSOQLt9dz2WST9Y0WgN0
	j3bgEeXfyfp2xd01uL2BbOq58Jwodn/2Lc6Zyn+5IabAUrExcnwY9mjkk0ng3vJJsqVdbov
X-Google-Smtp-Source: AGHT+IGNBhWthLDGQkNUmSDOtBZ6kPG380sDdFzTHRFPTBU3OvIpr+UNhFx9wIKHGCPYeU5eyCPxKOS8Oaq+t58Wi9s=
X-Received: by 2002:a05:622a:cf:b0:4b0:f1f3:db94 with SMTP id
 d75a77b69052e-4ed23befb4dmr3689571cf.5.1761818072639; Thu, 30 Oct 2025
 02:54:32 -0700 (PDT)
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
Date: Thu, 30 Oct 2025 09:53:55 +0000
X-Gm-Features: AWmQ_bmH6jCHbddd_06rLNhhFptxL-9eDGPvY4LD17aGK3N1aXlsCzh0O39IRrs
Message-ID: <CA+EHjTwscWNSdzCem+3kr+cQWaA61qRn2aUb8BNBDRieKpsT8w@mail.gmail.com>
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

I thought about this some more, after our conversation yesterday, and
I still don't see how I can do it without having to change most
callsites _and_ getting strong type checking. This is of course
assuming I understood you correctly :D

For example, the most common parameter for __vcpu_assign_sys_reg() is
an `enum vcpu_sysreg`, e.g., __vcpu_assign_sys_reg(vcpu, PAR_EL1,
val);

If we wrap it as follows (after renaming __vcpu_assign_sys_reg to
___vcpu_assign_sys_reg), it still doesn't add any type checking:

define __vcpu_assign_sys_reg(vcpu, reg, val) \
do { \
   const struct vcpu_sys_reg vcpu_sys_reg ## reg = { reg }; \
    ___vcpu_assign_sys_reg(vcpu, vcpu_sys_reg, val); \
} while (0)

I can't think of a way to do it other than making sure that SCTLR_EL1
is from the beginning a `struct vcpu_sys_reg` type rather than an
`enum vcpu_sysreg` type, which means either doing a __pte(x)-like
thing at all call sites .

An alternative would be to construct a list of `static const struct
vcpu_sys_reg` for all enums, which is what you might have been
referring to above. If that's the case, what is the best way to do it?
XMacros, that would be tricky especially with the VNCR() within the
enum. Or pregenerate with a script, which seems to be too much effort
for this.

Like I mentioned, even though it's not foolproof, in practice, something like

BUILD_BUG_ON(!__builtin_types_compatible_p(typeof(reg), enum
vcpu_sysreg) && !__builtin_types_compatible_p(typeof(reg), int));

If I understand the C standard correctly, enumeration constants
regardless of the size of the enum itself are always an int.
Therefore, this check is correct, even if the enum expands beyond u32
(which is very unlikely anyway), but might miss some cases if we
happen to transpose a `val` that is int with `reg` . That said, I
think that in practice it catches all the transposition cases we've
encountered.

What do you think?

Thanks,
/fuad





>
> In a way, this is similar to what we are doing for page table
> manipulation, where pte_t is a structure wrapping a u64.
>
> If we move to such construct, it becomes impossible to swap value and
> register, and we can stop worrying about that.
>
> Thoughts?
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
