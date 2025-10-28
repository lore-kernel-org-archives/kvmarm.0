Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CAE22D7A5
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 10:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761649149; cv=none; b=KXxU6fV4cCnFCDyD66K0gc9u24spnusGn6E9DrcnV6NGXo/CxgddztMH0WEd7mSy+ktr+YYZY+NtCphLzOvaZUPzK0FZ6jY+HNijvMi4xfVrU2O72X+Lp9265OmDN3GXhcbUJtwExdoH+eeCtYs1xHsbfBYro+ghlP1aMkv0BrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761649149; c=relaxed/simple;
	bh=BfBHnxqj5zicaM7SX7ByJsvCbHGm82i8s5/4YE4lD3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QOAo1rc8/BB8G9StQ6gKI7ia53WCbkf1w0+OFUww7DWnS3iB0KlDt+ah6kXD/FjTYxO6Kd2sY/bj2tbTBfsyU3vX7rKjsNVvbG7o/aJOAtC6uEyMiUxHY8KBu0AcXin2SoCxGz78tSNnPaHU6p/eunaG7sn+d1dGdlYK+zd1I8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h3aaJLxg; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h3aaJLxg"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4eccff716f4so283001cf.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 03:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761649147; x=1762253947; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JEqPjVbdveLZ8o7uW0qH4hEXeMOigT5s38XJXvic7So=;
        b=h3aaJLxg5iedPPmNxG846wE6vqWEWMC15KeEMsblhliB4lLzrtE32J0Pv0BBFZp2Mo
         Hb4tY53avIzY+ZsWV3RUcoGtL0UAgfUzFYJ+kfpFtCsRVrumhohTIhNFfUvvTCKtR36h
         Dp9PGuygLTZdKcHlSvMaJFKHpYKhUEa9fwk+nTdckAyxI6hXbBYHbViBP9Ygk2iN78wP
         ycaMn/c2WFDuwJI4WHbQHMGrat9T9JSf7IQ/RBI52DEW+atQsOq+BIIy4bcNxltlgSsu
         rWyaa4ab0+LEVVVohF1poq4XZ/NG922srs25a1g3DKOeCol8IXjYTvvPUba0GS7l1oGr
         3vBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761649147; x=1762253947;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JEqPjVbdveLZ8o7uW0qH4hEXeMOigT5s38XJXvic7So=;
        b=hWe34YoyfBRLKZt53B1+MmT8krn9f2OYrV6rA0jtU24vBuuHHZO1cLWlxdVtx7w+p3
         tTLRgp5Mv9cdhhm2673aCyO4SPiMZynwQR+NcrPKiwgMJur6BFPJLsrxdrqeUA1jyIHN
         JIgjx/nwuE1hSM7dlhOwUKorMMYf/GyDa2+zJva8/GYJoRS1HTSDuWR4iHbNs8nITG5Z
         6524qPcty2c91CPih9SewLVomuoVk1xFe0H9n+fF3d1qgLtQf0PZWivyerbJnpe1oE6q
         ulFyXWTDVxRJopExpL+YETP/dIKbNK1u1iJ7YO//iC4l0dh4IXib6IH4foVAOaNthcTq
         ydAg==
X-Gm-Message-State: AOJu0YzHywQ6b5Dynq1QI/SwajwBRRR3206Pe2Gho356E1eRHgSpBNiM
	C1x2cep/Rn6Ng1np2MFhkdbDjzaRn8ZzUHyuC49w/FX0rAmQCh67X7vR+rxLi64RU6h0plbX90C
	rVW1qSpratS5jcyINiVA7VHAy/HSdFLKCfVaisIMW
X-Gm-Gg: ASbGncsNXWZwsrXxRWThFoBFQmIKJ0zs5x06/jFrp/rvUURnxOZraIZ73gt8J88eZ1b
	NvFh5mlq7WmG9h+eQ+mvsR5WGe/1Rn3lyLESmSMCuzt7wV2JdE7qkGRiK2edzJT+d/03Wi8PqM9
	slZ7KCBVRAhNAwawpuT6zRFduAIJ6T+eW+390Fh8DD7Zrr0uH6VC6GFtRe74HDX1fF9Bx+jc9cS
	M0go9vTq/NHsMOkwZb3vzwynrfQLqfROZUXfAqBVzyC4onzB4NK7Waw0kZDbgWcizjwia6rZ7T+
	zDxseRUb8kfbfoqlHXbZJOoc
X-Google-Smtp-Source: AGHT+IFHqYCE78TNCCMrXfr6A36S/h3QtPnycbrepNYJr6lpAgID88x9FnBFPz3KCjZjq2mVE1Xb5wC6U7UKqfxuBfk=
X-Received: by 2002:a05:622a:54d:b0:4b7:9617:4b51 with SMTP id
 d75a77b69052e-4ed09f6d3bdmr4540441cf.15.1761649146690; Tue, 28 Oct 2025
 03:59:06 -0700 (PDT)
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
Date: Tue, 28 Oct 2025 10:58:29 +0000
X-Gm-Features: AWmQ_bn-zmvoqhq8rPby2a5mkqXXoPChZUgrdpYa3ieKRdaSKeedfSF9oO-HcTA
Message-ID: <CA+EHjTwOPKbv9ifz8+jvXGwEqHVdrn9+mZwrmP1divVDYSRmrA@mail.gmail.com>
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

I considered that, but then went with the approach I have here to
reduce code churn. I do prefer wrapping it in a struct, so I'll do
that when I respin.

Thanks,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
