Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755E24AC381
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 14:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767881430; cv=pass; b=I4FbuBaVvUXebzlOsbRzLvzKnFKvLhN3sdXG0a5vC3Q2yI8ApSl2zqh1g5cChmH/txHjjN/cfISrBWou2zgVs1xaKz/lOF0Qt9xNB7NRlxXHvGsgqWWc1O+OkPWZ3ra/fyQYp7NYrzGzt1tT60czvR98G7HnLNwHNjiAOltmD+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767881430; c=relaxed/simple;
	bh=6s+1Fa+lgma2W6VO//e9W/EKZ99EnAtWNWD0KjYryo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A3ciWbqh15rNN13VHpeMQQLub0ntbmVFQB/4q6qnTDW7ikmhdV1rFRMZ0IdrXuBPwfcvplNp274OCVCCQqpUoPp8td6vD3cHrQF1o3+lXDqeP1OSza1lXLh3Q3p7E4eWoIfnAYBFL4K+8pvlKzHdk/K4vQGMgCqOd8Fo5juhdw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ffZivEz5; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ffZivEz5"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee243b98caso845961cf.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Jan 2026 06:10:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767881427; cv=none;
        d=google.com; s=arc-20240605;
        b=XdiSC3DwuZLD5OqJoz2ZRPnRIE6NYdCam4MYu4O2XiKyHa5yow4TB7p7Qi+xZVgyFh
         k8qfUJMiM93OOby+BTee8yOdV3t5h7DIEsVSGgEvWsSaOQjzQAF9zsksN5AJkT/BdE3i
         TyxZiE0bFAfvvCDSNlv2pzx0re8dBCY3RuddranQEGtKLiqym+TUQsyTjGn9yrd17/eM
         wMXGFCJ6CzZnSsqsi1tv1RuokxD2CIHo4PoHcIvUXhiE2qKIzQMTAb9ZZGQ5YfjGkpAo
         SlCfwLFqnvdIdn0zVRAlL2Hjzsp4JGqKmQ9lEz2f8uj+GAyc73eFRXfDpzl9qmoRaSSa
         D4Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UkFBVVF2FUVuKrFgmcHW8CUldvJtVwVqevSTZGxcxL0=;
        fh=q8qlfcpHELgdov4nQULUMaaPUs2h7mhGKE8p6Kp1fcw=;
        b=i+O46uEvimMSEJfYDVNDtIHu3OjwlXIoTqzjH4FWjsow260yI3eqc6kWfQ+Jy1zqNT
         ncd2kfXPcgQWpHKZ4+SwV1PBA43gCG2OThpB0aVjyFuWPD+pM5cFGxF5d3+IqicK7TmJ
         0PfY8JWbGdJSQPUDcwAfFRib1T2lbk2rmAaL7jPfuWe/QA9cHFr8S3q+BlyA6N0DsYv7
         IVVtfMdWWsyPbPDA9wb1gwVmW8Lfc0KFeI4YNB5PtgVgK1+SXvcTzm6fWbuHM5M3UNX8
         Xi39uDYQDG5/Z64TcMnbrCLGfAcCzk0grskK5xXFAnzhAOLChR6vt3AjHkVtV+dpC+1m
         8YwQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767881427; x=1768486227; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UkFBVVF2FUVuKrFgmcHW8CUldvJtVwVqevSTZGxcxL0=;
        b=ffZivEz5Drup04XTIRki97TTQPrvRyLwBt1oQxoNoyQU2SGswnx4g/oUFDmZd2Cm5Y
         eCNhWtKCb8l2zn+s1Q1F/Iqm9UREUieRP1vVRGHdEQDTQzk/uInftWRK6VRGcoYi52B4
         g3rnuZQa0wR8dDOzFIYrUB99vJg3NdL8ji0BC7YKo/bjeiA2vqJW+H8uYiP4yojEL/z0
         uBiISPlCCWvyToFK7nal3MhgP/acO3OHUkJM/vMkmG671/bM4BlFUFNuGmVwnv68j/iE
         +sqHyEwUSd/gULtbZJxPvquBUkLVBGQdOTrNJwdfLbnc+EV0GrQYDdZGKdenMHFu33yn
         L7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767881427; x=1768486227;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkFBVVF2FUVuKrFgmcHW8CUldvJtVwVqevSTZGxcxL0=;
        b=pBErrLdUjNM/kdEdq0RHZBXYQErdkl/4FntGcjkBjqAchcxADruYLq/eDSTYs5Tj+N
         yanb3SxmnKwqiZKGNc1YCX2PhgiamLBNLavA/A80oA8bkwbKACi2FuPfww5EDM6uAMmi
         9jbEB1kYBZnG0S/pINS9fqxn3JBXTaSIn8JA572xnsZbbOSU244lYCMg9026ujxsQxLc
         K6lV05LwYcbtGXhSmJUdu2jC1gGmcHEIg+SWXsPrTZKXC+9w03DD2A9HdzfSHq1VuWxD
         p8+O9aZuH/PRf3MqlgsrHTSqbx6O6CQV/l8CAEvBSFwWGvbQsnOU25GP608u02QKMvxu
         TyxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEGIh6uHwNMkfeI+QHJdObJLBIXAsPja7U8PD1upzYHUTwYIl28LxcQbxHOpwN3TwhTnEPbqA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6p+zH0idbCb5crFJUldspWN4BlaiLn7GKGCK+HOSF4mg+uS0K
	2V0y67j87lNR2+v4GAA+dpHoCg5xaYn0uHEyvX8T1BaSS2HKc6jrxiSSh98aWBoPKOtsACjGE2W
	KDIBcO+SkO05845v5+CQQG1p2aLtbWyxbRfu7JJ5s
X-Gm-Gg: AY/fxX487fxDC3bh9hKzTs0C/VefE81POR15ovEu2aXp+zR+y4cQ0/C1/laW4MrXG0j
	6+Q+wimFsgg6x3IrtAEZ0E4t+G230k9kPn9hVWTAkLbzPWkrDQYhKZDiTePljDgrhltnPdBwa2f
	gOjbErUZzQ8VCuHkcnwkcoq9PPlP77m53ruJUHyoaXYT9/suWuyUT2bFuGq3szNsGPweMmLesFx
	IIVV1++TwTze4e0jlafv+cSQ1bj933gw5afYhZGg7US/hODvNhITNU1yHs4fM+uxlK0//xvekHq
	Zq80iJE=
X-Received: by 2002:a05:622a:54a:b0:4f4:bb86:504f with SMTP id
 d75a77b69052e-4ffc0a70687mr8479691cf.16.1767881426893; Thu, 08 Jan 2026
 06:10:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-8-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-8-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 8 Jan 2026 14:09:50 +0000
X-Gm-Features: AQt7F2q2Xuj85YtjC8aNYrYefXO_WXhklsHw1E8DTYu1HFx1qzlPPDyk9yC5egA
Message-ID: <CA+EHjTx8hu=WEu54Bt82PtcsOdQHaVkw9ivQSSC9=SV7bf1Zvg@mail.gmail.com>
Subject: Re: [PATCH v9 08/30] KVM: arm64: Move SVE state access macros after
 feature test macros
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> In preparation for SME support move the macros used to access SVE state
> after the feature test macros, we will need to test for SME subfeatures to
> determine the size of the SME state.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> ---
>  arch/arm64/include/asm/kvm_host.h | 50 +++++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index ac7f970c7883..e6d25db10a6b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1048,31 +1048,6 @@ struct kvm_vcpu_arch {
>  #define NESTED_SERROR_PENDING  __vcpu_single_flag(sflags, BIT(8))
>
>
> -/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> -#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
> -                            sve_ffr_offset((vcpu)->arch.sve_max_vl))
> -
> -#define vcpu_sve_max_vq(vcpu)  sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> -
> -#define vcpu_sve_zcr_elx(vcpu)                                         \
> -       (unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
> -
> -#define sve_state_size_from_vl(sve_max_vl) ({                          \
> -       size_t __size_ret;                                              \
> -       unsigned int __vq;                                              \
> -                                                                       \
> -       if (WARN_ON(!sve_vl_valid(sve_max_vl))) {                       \
> -               __size_ret = 0;                                         \
> -       } else {                                                        \
> -               __vq = sve_vq_from_vl(sve_max_vl);                      \
> -               __size_ret = SVE_SIG_REGS_SIZE(__vq);                   \
> -       }                                                               \
> -                                                                       \
> -       __size_ret;                                                     \
> -})
> -
> -#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
> -
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>                                  KVM_GUESTDBG_USE_SW_BP | \
>                                  KVM_GUESTDBG_USE_HW | \
> @@ -1108,6 +1083,31 @@ struct kvm_vcpu_arch {
>
>  #define vcpu_gp_regs(v)                (&(v)->arch.ctxt.regs)
>
> +/* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> +#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +     \
> +                            sve_ffr_offset((vcpu)->arch.sve_max_vl))
> +
> +#define vcpu_sve_max_vq(vcpu)  sve_vq_from_vl((vcpu)->arch.sve_max_vl)
> +
> +#define vcpu_sve_zcr_elx(vcpu)                                         \
> +       (unlikely(is_hyp_ctxt(vcpu)) ? ZCR_EL2 : ZCR_EL1)
> +
> +#define sve_state_size_from_vl(sve_max_vl) ({                          \
> +       size_t __size_ret;                                              \
> +       unsigned int __vq;                                              \
> +                                                                       \
> +       if (WARN_ON(!sve_vl_valid(sve_max_vl))) {                       \
> +               __size_ret = 0;                                         \
> +       } else {                                                        \
> +               __vq = sve_vq_from_vl(sve_max_vl);                      \
> +               __size_ret = SVE_SIG_REGS_SIZE(__vq);                   \
> +       }                                                               \
> +                                                                       \
> +       __size_ret;                                                     \
> +})
> +
> +#define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.sve_max_vl)
> +
>  /*
>   * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
>   * memory backed version of a register, and not the one most recently
>
> --
> 2.47.3
>
