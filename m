Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C886E285056
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773223991; cv=pass; b=H9hohkt0oXgmV2E3K/rPqCXkOvwsT40/fLSEaj49U7o2u13L+qggNp9DQrziuc7lnpALoKrmlUB987WE0zEGWw7OsdL2ZdmOaD93Nn4sg1q4NrY2T0FO/7ea/VvahwMm9FLC6JhMzlIRckxVj4FLE9FltUVRO9zGncRBkgQj8Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773223991; c=relaxed/simple;
	bh=tHXTVmPjfb8SwpaBCgniIIPSIuJscopMM/vhQ4tMBcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bjXVZGjwFtsZzs9130HmtFfv0+vbOaRI7F3qtmEXu70zmr6dD/33+MxzPi0iGZBEa8Zf1K0gC/GChRVA6Mk2pavAzEn+X4uWLZd/sNDe2jwplZHJAmKFqYJgR6OzYD/iCWeIMh7ZNE6MD8zuHJqJted4wx3tWUdUwfkfbPvYddA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0hcX400g; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0hcX400g"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509062d829dso409051cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:13:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773223989; cv=none;
        d=google.com; s=arc-20240605;
        b=KrAQJe7dE1siKaGbufBEy+oAcuVVmb7sN6bzKxmdelgqYZTo7kR7ZmGwYcFXSmZG9k
         ZRDq266fbBjNvjt+R8DW/JmukMGKVxCgueod1eC17RdInodr0cej+6FlMY/CxAFjXqo4
         gqzLaX/QtgEt64BEfhT9vAPwLU9R5U1bfcqaQAkgzjEfZWyeIpON0f6VqjoTa8RCZc6B
         OZkWG1dDZrqZ6KG332kxzHpgFhlQqIpv6PSkuSoo7NVGbT508WoFLmrIa+wtzxQUBM4x
         6K+mKgZbQGGAyIZCC5m5OgINuDXiBdnVfbbUMZLIFO19n1ypTbHPnTpeLU77g2it47ox
         hfkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=9TkgZeRelUotLX6uWoOokmh+4cw4NVRqqCq/SOcEowE=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=VDQNK+Q7Ag/bV1MVy8SFmJpYJ8WKj9gemLuGCjMQwoF/qf++ruCuO1wVUA9RgFUqqj
         eIoMmRNB+BtpSPGPDa9zT0QBdLZMA2Gg/1GC4s+KEBcf7t8nXwH8HzJIjIWl2IYvwzvF
         Px6mPMWZqexIzpD9zYDCzYp7tkJ5vGDezVzUWAOml9IlcnucWyTF03sB745w0lkdwptH
         px1tK4qX4t2EaXIicuiLbNbJvPuYxh8mZpye7CFamEcEbzmBVdkv5nYRLQZRuhQeQ0YP
         kynt8OsokG5U/bKE8NCeAiwrwB0J2TasAhheVjlslowJqQ79MzBi1xH3uy0WA7kBOy5V
         YBGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773223989; x=1773828789; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9TkgZeRelUotLX6uWoOokmh+4cw4NVRqqCq/SOcEowE=;
        b=0hcX400gOi/h8Gs/niw8vUxJ8MPUqXtj1n6FMM46mwSe7VuzI/d1KVJqNKPw721GhO
         4YXviEEd92Mg/+/p5rmPokz8+/sMfZSS2lBbeijzOZRnJjodTrAkbVcBvRppiU+XjdIJ
         Xf5/deu1h/5tj0rIqwi0uA+z2cYFVO4VbGEoUOe3EyMIfwzP2aKRYhHKH3NRq2GhgvP5
         hntiYLIV1SLi4L5pIaE64CUx9w4IO1g8f8GGi29YiXbcwKWnd7wEotamYP3hhzCOVYVi
         Vw7ZBZyNex5jqHcp8qIOiN0Z7aoQb3R/QjDcOXGoGyAVSPprkGhqsT7iqoJm8gZOr4dK
         mAxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773223989; x=1773828789;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TkgZeRelUotLX6uWoOokmh+4cw4NVRqqCq/SOcEowE=;
        b=tyo8O3op0m9lLL8VfrgpfvE0kkF0iMeELypdY6ZTBq/Ff58F/JccDl4ZTKqti3fD+O
         PU3/KjspY3HPt84jGherieX2E0zlud7otKMIyvS1mrUme6N71rXXK9W6v1drqvnR5jN7
         sxRSVzpW+8y8MafQDbnLfuDsVHXBvCcLDp77KO1R7iJJA1N7LSvZ6q0ISCQv7HlufFWc
         W0eaLg1VcpXj1oRoG0RyghTf+08ncUv2p8dAyqim86w/120jlk/2qZtkp/gTL1qXZxqS
         YHa5MgHuoiSoenwpJha4xcl1MxbMg3nPYZRBnAAIB4asFZQbmudRF51dXR7HZGyXvXZr
         j7gg==
X-Gm-Message-State: AOJu0YzuvcAZ/UjM9lcbaTBMMmfRFzAvf5p8GfOo3wFRuucvrXDgGRQS
	VfilmNWdyaPUgEZNyVvZkZc9AFSrRqDZei8/y4FK/cgIxsQtkpWZ1x5vi64JnnaXsHstCsdj6rC
	eYdL5fSwWUgBX85e8li2OsIJT2bQsBYn1qODuzBu4
X-Gm-Gg: ATEYQzyIMDCZtlWsGWmKBWmNBttzddGNSairJX5Bh2l5JclXJxU/YAUQvvvaawRKewt
	BCx6uCMgWisfP98kr+Rh+66+XUxw9sE7CXAkjkME+AP82MNI1+g726NWWJEP522siCfKVYT8sDC
	f/f62lWO1ghJmMo7JybrS0AvTS7ENr91v19A4LJVl7iWXTobwmo5jyAQkCkdNpxizG8C57mQdun
	gjdJjvI2n76dSOjviZABQ7UQ++z3nsIcmV2XuKivksuHnELPACrbNUCvwi6KSPAeoLYZ4xeX61T
	Qb23v1Gu7H132bFYE6siNN1WiIQ1yx/5amuuVA==
X-Received: by 2002:ac8:598f:0:b0:506:9852:75ec with SMTP id
 d75a77b69052e-50939a0b6d8mr9160861cf.9.1773223988258; Wed, 11 Mar 2026
 03:13:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-17-will@kernel.org>
In-Reply-To: <20260305144351.17071-17-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:12:31 +0000
X-Gm-Features: AaiRm51aS31a_T0ouebXqMpmAi9skAmUrSnNLq5fU1cJFuBu21k0UjxGpqvwTDw
Message-ID: <CA+EHjTxwfCDoRmV+17iYkyaY4bxVLK-ikiuvwPP=vLyttOUGBw@mail.gmail.com>
Subject: Re: [PATCH v3 16/36] KVM: arm64: Factor out pKVM host exception
 injection logic
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:45, Will Deacon <will@kernel.org> wrote:
>
> inject_undef64() open-codes the logic to inject an exception into the
> pKVM host. In preparation for reusing this logic to inject a data abort
> on an unhandled stage-2 fault from the host, factor out the meat and
> potatoes of the function into a new inject_host_exception() function
> which takes the ESR as a parameter.
>
> Cc: Fuad Tabba <tabba@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 49 ++++++++++++++----------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 7294c94f9296..adfc0bc15398 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -705,43 +705,40 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
>         kvm_skip_host_instr();
>  }
>
> -/*
> - * Inject an Undefined Instruction exception into the host.
> - *
> - * This is open-coded to allow control over PSTATE construction without
> - * complicating the generic exception entry helpers.
> - */
> -static void inject_undef64(void)
> +static void inject_host_exception(u64 esr)
>  {
> -       u64 spsr_mask, vbar, sctlr, old_spsr, new_spsr, esr, offset;
> +       u64 sctlr, spsr_el1, spsr_el2, exc_offset = except_type_sync;
> +       const u64 spsr_mask = PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT |
> +                             PSR_V_BIT | PSR_DIT_BIT | PSR_PAN_BIT;
>
> -       spsr_mask = PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT | PSR_DIT_BIT | PSR_PAN_BIT;
> +       exc_offset += CURRENT_EL_SP_ELx_VECTOR;
> +
> +       spsr_el1 = spsr_el2 = read_sysreg_el2(SYS_SPSR);
> +       spsr_el2 &= spsr_mask;
> +       spsr_el2 |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> +                   PSR_MODE_EL1h;
>
> -       vbar = read_sysreg_el1(SYS_VBAR);
>         sctlr = read_sysreg_el1(SYS_SCTLR);
> -       old_spsr = read_sysreg_el2(SYS_SPSR);
> -
> -       new_spsr = old_spsr & spsr_mask;
> -       new_spsr |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT;
> -       new_spsr |= PSR_MODE_EL1h;
> -
>         if (!(sctlr & SCTLR_EL1_SPAN))
> -               new_spsr |= PSR_PAN_BIT;
> +               spsr_el2 |= PSR_PAN_BIT;
>
>         if (sctlr & SCTLR_ELx_DSSBS)
> -               new_spsr |= PSR_SSBS_BIT;
> +               spsr_el2 |= PSR_SSBS_BIT;
>
>         if (system_supports_mte())
> -               new_spsr |= PSR_TCO_BIT;
> -
> -       esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
> -       offset = CURRENT_EL_SP_ELx_VECTOR + except_type_sync;
> +               spsr_el2 |= PSR_TCO_BIT;
>
>         write_sysreg_el1(esr, SYS_ESR);
>         write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> -       write_sysreg_el1(old_spsr, SYS_SPSR);
> -       write_sysreg_el2(vbar + offset, SYS_ELR);
> -       write_sysreg_el2(new_spsr, SYS_SPSR);
> +       write_sysreg_el1(spsr_el1, SYS_SPSR);
> +       write_sysreg_el2(read_sysreg_el1(SYS_VBAR) + exc_offset, SYS_ELR);
> +       write_sysreg_el2(spsr_el2, SYS_SPSR);
> +}
> +
> +static void inject_host_undef64(void)
> +{
> +       inject_host_exception((ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) |
> +                              ESR_ELx_IL);
>  }
>
>  static bool handle_host_mte(u64 esr)
> @@ -764,7 +761,7 @@ static bool handle_host_mte(u64 esr)
>                 return false;
>         }
>
> -       inject_undef64();
> +       inject_host_undef64();
>         return true;
>  }
>
> --
> 2.53.0.473.g4a7958ca14-goog
>
