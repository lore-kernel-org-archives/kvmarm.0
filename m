Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286FB31D367
	for <kvmarm@lists.linux.dev>; Wed,  7 Jan 2026 10:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767782954; cv=pass; b=g0Wdvt5+Ya07lYnOnhAUIN0Z5TxemwpztEgnHksrsCJjjfDPecfsML/izFx5ISGgtJhnnVAHX9U07NRGhG20NrNvn/qLIP6Vdluf1+mEHn9Q7JpiPEwRAyHmMRuvhxeN8SokCKYLlTeSoXNSrN1p8ZBOmjMmX2Zd0Lxc+kbOrCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767782954; c=relaxed/simple;
	bh=jeAdAqRUsi10JLjqXYI2dUzriqfWukGffIBuJG24uLk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cmsG75NVcN3XgUkrdOq89ZqJtIog/DvleGC/JT05tUhu0WBlvl5R6MzFQodFAyyAARyBolq6wWMXKM8+AAyu2l+SEwkdagX2rMYmLJr4aQNzk15H5fuLDRPYbwoOkXy8lPldtJsyzlqdo4Bt1O/FoPX6yRu22RXrru9qkfpuLOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d1UsEUrV; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d1UsEUrV"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4edb8d6e98aso427601cf.0
        for <kvmarm@lists.linux.dev>; Wed, 07 Jan 2026 02:49:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767782952; cv=none;
        d=google.com; s=arc-20240605;
        b=JszqKxqTPrVWcVevV4EEO7wS5u0eoWEzhj8zeW1OqDLiudDRzjiSBXQTycuEVzzZLA
         lo87eQ6DAOl2ENfn5HVv4e8ALbqI1KW5cQtVVicuL1dZjs3qETqj27vsLf7Qwu14/9+7
         kDULOIcKQ6x3j6l81Di1ZWA4oqR3XQXGgwlkhbZt+2ctSVUy3P7Joy01lDOZJ9m2wczg
         7fY/HRHwFt0adsX78K8I1IVGZ0VI6VieeVCDnD1+YgLOdKrvzYcK38Ws/F5Z6yeHujNs
         +sSD9UmXySOGNK+4ZI0ONUfyN5coCse9X7zOwxAVhNiNngZvvMPEMqHZeAHo0HvrQwbM
         ACbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4igsSMJUm2pHmfSuYxdMWMQVSss89GbaNEs4ZiMiGRI=;
        fh=Fno+E+I80VZy/XRqm2fy8oFwHmy/S05HB7Eo/YSHEcs=;
        b=J6uceUwQHje+G0E3o2X40fr3r5hxGtyIW9aPORTwOlQlJrsRulLrU+KMsbvaPLBdN5
         dKNpNlou+EqCiBUDVZOmDY6NVQCbtaIn+v71i/tjhmxUqhpOVDBufWWxMD7vullpBKoC
         Fkq+/UMHSxjJFvLHBQkSMT7iKSje32SU3ZjG2W6MlPMpGyL+Z6ljB60IFLLhoPAQb084
         cvhNKKnWdXKN66HntNPxDARBbXCEdQ5WCTkp9xkmtAB9pWsqJqSjASRgQ/xVNmBIAGYr
         nS/xJmPbcHst0iAdKGuWzZtMMU38AcQcQukZWIvLlzWD6IZQEm/2qZzYp0yd5dqlQPJv
         UX8Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767782952; x=1768387752; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4igsSMJUm2pHmfSuYxdMWMQVSss89GbaNEs4ZiMiGRI=;
        b=d1UsEUrVLB8LpWxGcBGlOrKxB2NL4Pd3Lk6jFkkJGfQ6yU7av/tc20rwX+O12HkXNx
         xE+mQtqM9suXRzl8NmZRC7jsvSbfrp8o1PvV7Rg8iGL7xN2Fgh5eeXulPC0lXFcpK+31
         zHwMjFWibC6wqyK8BEm00peHrPxmKuGxIe0tx9/VS//SZWYzAXEb5Pdy2MGGfBvLugwq
         HPZxIRIzAW3FlQ9gnT40UEo3CT5txUDcCFSdga4rq2sr9bNxFzrv5PTyV9scxZmSJ+Mw
         XMJMQ6jRbffiG8urdD5ldDF/IfB58N+eSfNNOnjgjzj7VRZu/Co2i+oy6ntsRugETRXE
         D6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767782952; x=1768387752;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4igsSMJUm2pHmfSuYxdMWMQVSss89GbaNEs4ZiMiGRI=;
        b=UjxkD7kXdWlwxl+I7iCFygJtPSRoKnyEWSNio15bllhBXHLSTJil5rD9rHd3G6yaJW
         cpXKRK/TYVMv5sGq1hAf2I7sFpTYdhVnyOPLVDTzl3O6TM3b7pLsCOIUFYzlrpx8P+pd
         FO2X4Ul8J+z3zDhqyK34dHik+Rm3hWGADnw6UDwnkBR74HmPRXPngx507kMNNWfDf30J
         swCZnKKlO3dhzaizVMLnvKlRAwQJzb48uHp443ZypJVhWRTNocjfxwe0wQFzFBnAIT5z
         xruGB1ybqWvKUJvFDSZzGjkf3+fjZkvAJBrlVm7joVsgB8jX2AE87c1eq4/aQdPsJryR
         hWSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJNUFZDB1dHgzGmYyjsGPv4xt9lYsnqlVtBhgeKodiL3UkdZgssNcDSLE+hj6HKufBEJJCutA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxjJmHvsdENTZTosm3jk3gSQgo/BZhLd0I2GNUfhSbhOqj6AK5T
	7KpprGpCfy3CgJn5DIyJDufR5VOEFxSMsU14lUoldkZFOoUd0x4GT3EQRkj2njkzIiL5Eh2n1hI
	RHtiP/ZdMmGhNooNVdxkU6JirVfbe4PVe/gN5CabX
X-Gm-Gg: AY/fxX7gSYCoywEuRAyFKDHd72Jptqqj0m7hJc7Ikedaf2hmTfE0aetRxU3i6w32BnF
	iUdVdX59VjGl2yB8hlUw6iHS5K8XaccCtEMm3sYLGkEcL6DTKQjn0PwpSnRhnvbOy/fJs4dsQWG
	iQQG+myxNVWGD1soW0mECUzj1tnpyTZj3CVz+vPxg/+nuRhF5OmG/wEVnn0rPHc8/52Qez/h8nS
	zBc4LEKpbA53RbLhaT30c7hYSbzLk1UdiWVef5MKn0zmAykjZ9Ot6Hv2jMO//pdBTIsejnSjXGp
	E9jRMwlNHzfRc2ppT/BQCinN
X-Received: by 2002:a05:622a:48e:b0:4ff:7d4f:85d6 with SMTP id
 d75a77b69052e-4ffb3ca5633mr9973581cf.4.1767782951799; Wed, 07 Jan 2026
 02:49:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260106173707.3292074-1-mark.rutland@arm.com> <20260106173707.3292074-2-mark.rutland@arm.com>
In-Reply-To: <20260106173707.3292074-2-mark.rutland@arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 10:48:35 +0000
X-Gm-Features: AQt7F2o5E_UoBDHB2Y99kOqP1XdD5xVVTTSRk8eYLRdaG-60Me90Qfr9L6BWJlU
Message-ID: <CA+EHjTy9n+eFe4Oxjsw1zO1QxtR7UTnpnb=jjTJU3Qz329PC3Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Fix comment in fpsimd_lazy_switch_to_host()
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	broonie@kernel.org, catalin.marinas@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Tue, 6 Jan 2026 at 17:37, Mark Rutland <mark.rutland@arm.com> wrote:
>
> The comment in fpsimd_lazy_switch_to_host() erroneously says guest traps
> for FPSIMD/SVE/SME are disabled by fpsimd_lazy_switch_to_guest(). In
> reality, the traps are disabled by __activate_cptr_traps(), and
> fpsimd_lazy_switch_to_guest() only manipulates the SVE vector length.
>
> This was mistake; I accidentally copy+pasted the wrong function name in
> commit:
>
>   59419f10045b ("KVM: arm64: Eagerly switch ZCR_EL{1,2}")
>
> Fix the comment.
>
> Fixes: 59419f10045b ("KVM: arm64: Eagerly switch ZCR_EL{1,2}")
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Fuad Tabba <tabba@google.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index c5d5e5b86eaf0..8dce3da85da35 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -495,7 +495,7 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
>         /*
>          * When the guest owns the FP regs, we know that guest+hyp traps for
>          * any FPSIMD/SVE/SME features exposed to the guest have been disabled
> -        * by either fpsimd_lazy_switch_to_guest() or kvm_hyp_handle_fpsimd()
> +        * by either __activate_cptr_traps() or kvm_hyp_handle_fpsimd()
>          * prior to __guest_entry(). As __guest_entry() guarantees a context

nit: Since the new function name is shorter, you could reflow the
paragraph and move the word 'prior' to the line above.

Either way:
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

 Cheers,
/fuad



>          * synchronization event, we don't need an ISB here to avoid taking
>          * traps for anything that was exposed to the guest.
> --
> 2.30.2
>
