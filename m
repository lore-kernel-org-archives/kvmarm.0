Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B81E196C8A
	for <kvmarm@lists.linux.dev>; Wed,  5 Jun 2024 12:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717589594; cv=none; b=H0iH8Y31NO2NcWXd8brGTCIhZHv/0MHTyvPlmA2kQnN/Ibi0Id5TZyZ9PemJj4EMaJf27UZTRBgYtvPpuh9DwBAPtEcfYatZCR1viVUuVzxHXyPk2uG/RCI3S6Ie+anp5dK78mFzET9rGAA5b3uHblQ+jecZUd1YFTdlSkTscw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717589594; c=relaxed/simple;
	bh=oNENrc6D4XwwwZI6By/y92Euehfjzy0JVbr//ofqX7Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jFfulq+8LtKMRLndtb0kIOEWJoCsFUPYU+fLI19u96FQy9kIqnFSe+M1447e2IvR5ImemptmgRDdfvkZJoy84E886riR/H4i9SjMdRT77bvk2pL9N4OWdHtIVoK4W+Iy5iP5qupCmsKuNWr4+fo45VDvPT5js3oxOZRU8BIJCdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FsG17NZ3; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FsG17NZ3"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3d20697239aso223691b6e.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Jun 2024 05:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717589591; x=1718194391; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vv6aPAuNaYZlDMSXJn51nV9wTtfWkMjnR+7Ws6E03wA=;
        b=FsG17NZ3KpEGVI6CQqJWsBtlfLDA2al1vuOUh1yFgVBeEytrGhbIAT2M6JiYgOthmF
         mc/8B9CtybIqUDMHk0byYyM1w+mW1Nw+0aqQacxOKhM21NCvImTHbwzvXz54xuxAnymE
         yyPxZuiopFjQpcXdYxpADdObnmqkHxAt+gXr9sc3Lgd/Gf2YvveXtyOJCIIWSQKIGrm/
         HzIWh/F2jIrlIPrJz3nvlMRyxAiF02nGqSCQY80KoLI7KjAfWTqvNyvg6B7kCurO1oP4
         d6j2XUAJM94usEskkypZGksiDdUvBt51wCXdAF8RVGwD0GZciPDtIXvoiNyp9/YzB8BZ
         acJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717589591; x=1718194391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vv6aPAuNaYZlDMSXJn51nV9wTtfWkMjnR+7Ws6E03wA=;
        b=F8vsQZ75brP3NjUdQ4v0FcOoa3BSw6BcAhF7xalcFCdIG2/yj70BhBVmD9f3/p4jT5
         l1daovCa8fGRopH99fdy+SgiR3zdAI2bqO2cooy6oGJPSoPCjVOOb+PWVYo+Ge8atFEI
         en4t0wZJe7jSQtF0G/E60JlveTOhdPYb2FdM/r5cvLLPCwKSCqktt48JpYrlfMzK/+w4
         gWL8Nosx5rkKr+hKgF0A2MWAgM0UduS7Z8BBJXP1CSOVpalVyPjvRdnnHaTzA4H8pBr0
         H7fqohCS0f4SI3V17uXkrGbNlUa9KcpLgAhtAAWDqMWBEnT5bon3D76jNVJvQVPO2Q6r
         7RPg==
X-Forwarded-Encrypted: i=1; AJvYcCVXDZTReW8UIw3pr/m+H6c8yIbm3ScmdaD6Wk4w/qW5Orjer9L4XMy8fFb+J6w6Hys41m0wNIgXkvUiJdEBuW3n/XuoD3b+
X-Gm-Message-State: AOJu0YwrgOfVPGJv2190HlLiaMb5Mry4CW2GVeglclaMhMDS9W00Qh29
	3g5D1ANghLDUZtcv9qky9tRYdwUFgSZZdpaETvOX/b5vOLYjOlMlLn0ghgJYPNuSl3+CFCmMYk7
	ubw7YSlJveglBOR6AIBfNptEwmh0R31iiau1g
X-Google-Smtp-Source: AGHT+IGtZqhTfCbUt9zM3f3XIcPwffh8lxbIKMBjvEjq+FRLVr9q1hYV69f7Jkej1TuC5cCI0H3t53Vjep/wzK915pI=
X-Received: by 2002:a05:6808:b35:b0:3c9:7aef:403 with SMTP id
 5614622812f47-3d20439b1bcmr2294917b6e.26.1717589591268; Wed, 05 Jun 2024
 05:13:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-0-680d6b43b4c1@kernel.org> <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-3-680d6b43b4c1@kernel.org>
In-Reply-To: <20240605-kvm-arm64-fix-pkvm-sve-vl-v1-3-680d6b43b4c1@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 5 Jun 2024 13:12:34 +0100
Message-ID: <CA+EHjTxrCOv44T8uq1e2Vvm0SooRKix1zwhFqQF6=GN2H1iB2g@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: arm64: Fix FFR offset calculation for pKVM host
 state save and restore
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Wed, Jun 5, 2024 at 12:50=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> When saving and restoring the SVE state for the host we configure the
> hardware for the maximum VL it supports, but when calculating offsets in
> memory we use the maximum usable VL for the host. Since these two values
> may not be the same this may result in data corruption.  We can just
> read the current VL from the hardware with an instruction so do that
> instead of a saved value.
>
> Fixes: b5b9955617bc ("KVM: arm64: Eagerly restore host fpsimd/sve state i=
n pKVM")
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_hyp.h        | 1 +
>  arch/arm64/kvm/hyp/fpsimd.S             | 5 +++++
>  arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 2 +-
>  4 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kv=
m_hyp.h
> index b05bceca3385..7510383d78a6 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -113,6 +113,7 @@ void __fpsimd_save_state(struct user_fpsimd_state *fp=
_regs);
>  void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>  void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr);
>  void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
> +int __sve_get_vl(void);
>
>  u64 __guest_enter(struct kvm_vcpu *vcpu);
>
> diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
> index e950875e31ce..d272dbf36da8 100644
> --- a/arch/arm64/kvm/hyp/fpsimd.S
> +++ b/arch/arm64/kvm/hyp/fpsimd.S
> @@ -31,3 +31,8 @@ SYM_FUNC_START(__sve_save_state)
>         sve_save 0, x1, x2, 3
>         ret
>  SYM_FUNC_END(__sve_save_state)
> +
> +SYM_FUNC_START(__sve_get_vl)
> +       _sve_rdvl       0, 1
> +       ret
> +SYM_FUNC_END(__sve_get_vl)
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp=
/include/hyp/switch.h
> index 0c4de44534b7..06efcca765cc 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -327,7 +327,7 @@ static inline void __hyp_sve_save_host(void)
>
>         sve_state->zcr_el1 =3D read_sysreg_el1(SYS_ZCR);
>         write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> -       __sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sv=
e_max_vl),
> +       __sve_save_state(sve_state->sve_regs + sve_ffr_offset(__sve_get_v=
l()),
>                          &sve_state->fpsr,
>                          true);
>  }

If my understanding of the spec is correct (which more often than not
it isn't), I don't think we have an issue as long as we use the same
value in the offset on saving/restoring, and that that value
represents the maximum possible value.

On the other hand, if my understanding is wrong, then we might need to
also fix __efi_fpsimd_begin()/__efi_fpsimd_end() in
arch/arm64/kernel/fpsimd.c, as well as vcpu_sve_pffr() in
arch/arm64/include/asm/kvm_host.h

What do you think?
/fuad


> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index f43d845f3c4e..bd8f671e848c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -49,7 +49,7 @@ static void __hyp_sve_restore_host(void)
>          * supported by the system (or limited at EL3).
>          */
>         write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> -       __sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host=
_sve_max_vl),
> +       __sve_restore_state(sve_state->sve_regs + sve_ffr_offset(__sve_ge=
t_vl()),
>                             &sve_state->fpsr,
>                             true);
>         write_sysreg_el1(sve_state->zcr_el1, SYS_ZCR);
>
> --
> 2.39.2
>
