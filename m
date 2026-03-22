Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A988B363C5E
	for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 15:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774193875; cv=pass; b=JuGG/ziXFE/27TLs4Gkk0MQnseG33BDh1SxLs15uAntXwoP1DkUC5KAJGzZEGWtECVHRTKvtJ65FrR/zfY4aI7weaLh18uMIlJ9u4UnVJZoLSZEs5GdxIB/F6XhymlgxzArtNlYySZ/UyjaDd+0GL+G6GwTuJgon9PO/LNwwGSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774193875; c=relaxed/simple;
	bh=+LNE+MzMocq6UV5snjgoPgnWIGGRUa/ms921P2bHFvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VENJKMusD/JLYfCQt4AnRPKXqDbTwNYc2f3UOhkUFQSqLL+t6+dWa31DA69nR0dGNBeHnCC80ua3vq544bBFBADMbM2OB/7Nl8mlURLq9jPjY4F1vaEIyevhbBM5ENPMqhB4RiCEwmUh2HT8ATYnqIk5jsD3dCeBuTVtyQpQ8qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cyNLQsAW; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cyNLQsAW"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-509062d829dso779451cf.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Mar 2026 08:37:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774193871; cv=none;
        d=google.com; s=arc-20240605;
        b=f6nD8Rk+7WrVlIuHOuTVax/DWxjuOIZrmRLf2LR04qKirMX8PivKLCJPpEfOCC4xiE
         hKLiM19hN0wUHAgW/0jOkY7mztCsPNVuetl7Rk6yYwPHxlBeUQXnDt58JIMj3jIPSE5S
         HX9fuJFDZEGHqEmKVsw8qiDoSOc0obO78Lje1gDt9BB1sJee/kCRZ6w1mG8dZ++K0rXv
         KPCvcMBWfuJ6HDzJOSjW5AtunRoILEYLatGgYjP+vGDivKCBFFRlksERr8lIQW5LtTr7
         qNT/X5Qwa76eVv/p0/VZa8Tp4b6HVukDYXoY5FDO8kpa9CFKg9uquUD+Tyw2TEyA7pWP
         +XnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fuR+54+tQE6XrGnnBxOq8qWtA7CinZ4OjktX2EB6ezY=;
        fh=br/O7ad/Dpl82iqHQ050DMUcdTbv2XuF8/c9+X0NSgk=;
        b=dAYintQgVjCXWnfP4bqiVkL2UKfzcRHCy6Zrn/PjfItlY8q02VrB0PeSuPhviX4MLq
         Sb5xp+2KeqUXuIQ7jPH2lLiLKWPWYvIdfcwefHqJPwEmblPg0Sl28B9k0erSvP31Cdlk
         cR7wOTz8gZWK9ELVtBLoGllzGdEeHnlpVtouMVW6OBdyNOo8762t5SwJJaRAovqHl9Az
         f3gBJWZN5cO1PW/WOV70+f45GpIhZHCueSH5MAI7Y9J6ET0QldKPaQDeQvnychukF03P
         UMJYLGaguWGJnVg1xR2pCAmYma4OW/seuf7xyl/bnQGVaiVpwOaQiwGtdFx1XgM5AWbx
         qbKQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774193871; x=1774798671; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fuR+54+tQE6XrGnnBxOq8qWtA7CinZ4OjktX2EB6ezY=;
        b=cyNLQsAWdev0ViHS60t2miQ2NIJilkN8QhgOCRRirlO22+wG7d0Pi9eXELGvN6gz3s
         2nNiijGmfG+QZp43JUJLUZkfGim11J4Q4OfKF9rEIT0tGXpuJl84xI+Z1dkdhbdgFDfW
         2xS9KmKZTOL68L/t1NCzyeH2KSrgU6C9+SsLTEsmg6CIekj/1QhnV2LoBltcC+uDjUAo
         Gl5/KUsD2kp+Gq7QfRAGBxYgFDdCbNReZp6P38/dUs3YW2lXSzg1Gf464wOac5uzFJOJ
         noGsGm9iscXZ1ffQJTDLFtI3lt7xkxmdDC4q3gtEIdvSw54Hw9agaQLYkxSIIMR8f/JP
         1iGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774193871; x=1774798671;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuR+54+tQE6XrGnnBxOq8qWtA7CinZ4OjktX2EB6ezY=;
        b=BngYWypqc/kfCmXmIrCq/0BqUmiov60ZoEH7PblZd6OtnAeylvkBepjjv3aEu6Cs/L
         MSOIQXy4KIgi193LSZpcq8N4MRFQoA68BMP8xZlT4cUG2UMMnDJkmuFbRZdPLiqP/VOE
         RWsTtq+Bph5roGwH+t/Nx/zrlMt9GLuwQsft4mbfAMRUaxTYMhkmbCuXPLa7DOmiMqCL
         k6ZwHM+otAHwAP7me7gfCUyuzR1N79CQp0yrQ1iOMO9L9Osve0MWGFGmxC9nZGNdxhtf
         xtPunUKhE1U+I7GZ/UJe3wloIAZhBh5yb615qVcwcZoKgWu9AZ4kkjd9KGfYIalheh+k
         s0wQ==
X-Gm-Message-State: AOJu0Yx0M9O9R3H3DQ1XdWgFEO2WtrCTPyKd/ual3RejMSfdAZYHfd2H
	k1BdD0hZDxiTHX+pgpFdzen9xvrYV7Rfh1NV3E7h03eDhicSdRkZUOjATgrzRLBGqMxZOGdFcGP
	ZwVMBSN71ukebTeOsjBYyy06EjUTLMgI8/jv8jBnJ
X-Gm-Gg: ATEYQzxQ+O2HZdmkB6rK/FOf+b6uWFd9QIZiF7TKYLgy0N0Vi+EcJK2gRw3xtQNsXa3
	fTSa9Lb66lzEgXNuoEgYQO5P5CJ2AKUHk3a36GB2/pRHL/t0+Wf+hRGI9Y7RGrvuUPOyO8PlxWB
	7XoxW8PgK6UdhBJAImMX6RqPutjytsW6UhCDRDGMTCN/l/hxfOM45ofUyvp6d+eiDxmg2RltREH
	ienen/NABhHhqW2S1aWEzUTAHIUAf5jfMqzPhQFkkNfIWQcqnRC+D0Mo1ZaH2DVdaI6jbRDyhMj
	pF5pMpWv
X-Received: by 2002:a05:622a:2d1:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-50b48062695mr17650241cf.3.1774193871175; Sun, 22 Mar 2026
 08:37:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260321212419.2803972-1-maz@kernel.org> <20260321212419.2803972-3-maz@kernel.org>
In-Reply-To: <20260321212419.2803972-3-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Mar 2026 15:37:14 +0000
X-Gm-Features: AQROBzCYF63bg2F-Z9cPsy4KXnsrkxV-B-1xhNDq36LfpfgZNex4zdlpfFtoy30
Message-ID: <CA+EHjTwfVkT4B87jn1Jhko=kf2us-1S4kCzj+stEOAm6ugFeAw@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: arm64: pkvm: Simplify BTI handling on CPU boot
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Mostafa Saleh <smostafa@google.com>, Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Mar 2026 at 21:24, Marc Zyngier <maz@kernel.org> wrote:
>
> In order to perform an indirect branch to kvm_host_psci_cpu_entry()
> on a BTI-aware system, we first branch to a 'BTI j' landing pad,
> and from there branch again to the target.
>
> While this works, this is really not required:
>
> - BLR works with 'BTI c' and 'PACIASP' as the landing pad
>
> - Even if LR gets clobbered by BLR, we are going to restore the
>   host's registers, so it is pointless to try and avoid touching
>   LR
>
> Given the above, drop the veneer and directly call into C code.
> If we were to come back from it, we'd directly enter the error
> handler.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/kvm/hyp/nvhe/host.S     | 10 ----------
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S |  9 +++++----
>  2 files changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index eef15b374abb0..465f6f1dd6414 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -291,13 +291,3 @@ SYM_CODE_START(__kvm_hyp_host_forward_smc)
>
>         ret
>  SYM_CODE_END(__kvm_hyp_host_forward_smc)
> -
> -/*
> - * kvm_host_psci_cpu_entry is called through br instruction, which requires
> - * bti j instruction as compilers (gcc and llvm) doesn't insert bti j for external
> - * functions, but bti c instead.
> - */
> -SYM_CODE_START(kvm_host_psci_cpu_entry)
> -       bti j
> -       b __kvm_host_psci_cpu_entry
> -SYM_CODE_END(kvm_host_psci_cpu_entry)
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 5d00bde092010..55e0dce65dc56 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -213,12 +213,13 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
>         mov     x0, x28
>         bl      ___kvm_hyp_init                 // Clobbers x0..x2
>
> -       /* Leave idmap. */
> +       /* Leave idmap -- using BLR is OK, LR is restored from host context */
>         mov     x0, x29
> -       ldr     x1, =kvm_host_psci_cpu_entry
> -       br      x1
> +       ldr     x1, =__kvm_host_psci_cpu_entry
> +       blr     x1
>
> -       // The core booted in EL1. KVM cannot be initialized on it.
> +       // The core booted in EL1, or the C code unexpectedly returned.
> +       // Either way, KVM cannot be initialized on it.
>  1:     wfe
>         wfi
>         b       1b
> --
> 2.47.3
>
