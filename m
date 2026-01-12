Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE23126C2
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 19:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768244964; cv=pass; b=a4MASksDd/X2beRwuUuDqczG3GdBq9PnK9WyaAToN6R0zRpzI858aYc+XAqLyjntCNbfzfLT/DeXV61Sx9J8CNSdW4t6QbAut1xA0B0rTAAe8oUBR5Aj/VuTJ7BM0CRgY2XmLVYBaupL1hvWvhc/G5LBEXGeC7zeijJn7eWrVTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768244964; c=relaxed/simple;
	bh=xheA9QOjQXvJoAbTTZVMmFI6y8wl+wMqp+t7iExkGCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hDj+IK8n6aQmG61lbkYBEpmTQELfYnOVbnnpp8wfwNDs9MWVyb4E+6CU+4UBQdXWrK0odauddwP/AfgaUaiOTzb9oKrX4rjPy8q4ojvowjj0mqs3AWgo0NgxWNZ7ngqfl2nyTFVEAZVdciboQ1VW5w/cKipaKX61qV3hFuFcS0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kvowFPsE; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kvowFPsE"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ffbaaafac4so43671cf.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 11:09:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768244962; cv=none;
        d=google.com; s=arc-20240605;
        b=fMSnWBz94c/rglB3pbO6+q8LyTIFpYDhmO9SMbohJeVIcrFN9/mTTFxO8pzUp0/IkC
         4naKA1m4F+OvEhJuEhDlNX/Fhy6gtk6Mcd9TAQpmel5G2/1BWuas0/zTvnW0T5jwzDJw
         v+M3VAtcznq5Hz3bQ5S2noKKicmAKZkd/lHPVQ1p9h5RE9FkY1Dk1Qib+lfZ0tgIZCwB
         V6fqrto3QvFh3oVe8EWz1uYZ3adRIT26FteUunmlLNVUzk2GIZaF/ffXdUYjVQfwHqYj
         +7GGgZqUkvEPh9ovQ8dgKgCh9jgXB11e+tOtJdcObGjEXC0q2THg2Uf/ejLFhJXt8c5A
         ekgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=CI3Qkkbb89cv5bbaE9HcvbYXyBW2GfCAOd3nwRVqS/M=;
        fh=Uq7wUOoZZT2wwkdWjKwo4QElOctyeUYDKhS1DMcWv9Y=;
        b=T2ijS6fgoSlOMw/GhzG0jBkK3rsJwT81E2mCl2IzYOKNVNeOLHNggJL34bkAB7KMQ/
         cft55AZXkt2KS3i0FgHvvHm8pQyBdIuv1Zm8TxnXwLRJjD8Yp7Lr4jEMoyU8DsBPPY28
         QH0Di3Fq+azm9f2afNqkXhSRaUFdeegs78U4nb7L6Pf26pBcMcQTYEa8+85oTCt39qzR
         KKnYF/nEgA1wvqE+0yCWhU/gV9WAj+jFgBfW2BXUUHYN74mN6oohvBgvQO93+CXN773+
         3uMXbF3XnjVW0LPTHDEzXxDlgRbtvedn1Qj5QxhZHB1VCiOoLmCwVjnt1RxVMIaLDJmX
         3nhw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768244962; x=1768849762; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CI3Qkkbb89cv5bbaE9HcvbYXyBW2GfCAOd3nwRVqS/M=;
        b=kvowFPsELGf/epF5fb8K1pk+3558FLh+X5KUJ0d1tjmCjLngQxEFguTh3WyiR9FCpV
         7zvHItZIhb8+2Ozxh6RnIT6OGbuPXWcH4lnivEeJmj+q8M2V1fmrRuAm3m6Eed+pLVBp
         TXnFY/G8dIOGHhCYId5PJExZvni3vaXz1C/P8bGVHWClVsLHTWPJEv704qQsromMhFuw
         AaAMP/nIzkKjlhnTebRC6N9M6J0j6kg8DQLfp1Az0rneKZ0WU9W4/1XKD69pGcPCO56Q
         p4x1Sv7Vu2FM37a/gyv/Z8IoIEsp/yAT0BAqMqLJ9FE1NjE01LgClzf5eZ06y7qVCsYn
         NANw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768244962; x=1768849762;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CI3Qkkbb89cv5bbaE9HcvbYXyBW2GfCAOd3nwRVqS/M=;
        b=Q/6tm7WXAxaqxkdUlmHFOrE4eyIygWFLrrJZhUyU73kVB+Mm10GTbOliqzHtuzcFuD
         18gx9cTVU34Z076z3IjWozsWA5HVilI+DJ4GKddCGfPPtwuoGyuKYYRRo+U3lutuYD3O
         kNVutqUAcnYHrIkLJyKar3A0Sgx5o4F4BcbFKWBDaJNCzLlfP3JoRLpOxoyglRIDvquc
         GB1sTJcpJv3J7BdzbBZCGL2+EDAPULFo8uEIy4wKN6pmeytijggG0NL9Kv3yzSthOLfe
         wLUUH//2OAms6gFXX63fUbDN0JZQV3xEWeNzJN8p3tegIXQhL6ORpdfZnOMRBKx/E1kX
         MBzw==
X-Forwarded-Encrypted: i=1; AJvYcCWfS4G8H6SumXI2kuSlLM6ggwmgJSB3HtZUUzbAlDMsD4g2EGidLcCFypLWtbtUrE5Yj9on8H4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyoQb40o7Gq+yszE1EuDsVxJqETlcLFbD142fqpV2oYE1JM5TtJ
	eFLfeaiy1vDOXrlEpuBQrf5Cr4mpHX8NeAaBlVtlksL8CbypddjLc0HM2jQtXLlm++xyAr/Ipa/
	egAzNUEbyULtEhJsj/Bkkt19T+48tgGuY0a6xEfJ7
X-Gm-Gg: AY/fxX4kgsNDn3NyXtSQkGuOoDtrrnSaWn6ACFBr0BS/7waG+T2rzYxR/3zNk1FzAbk
	3IP7migPoGPJvoK4nc0SD63KYo5r9TRd2oQmoMl+blbK6Fis/mWA3u629E1UG0tqkKc8THq1Nr7
	22n4MH+wwgAlr/iYDwdN7mzRXqsPM63HX6k82RsDttOFZA09wVE9/rrd7HZDxUeqrXnpIZ/PTbw
	yxJuKCn8mkbbI9Qi2poUIP5opvTg9joJcoWURXFQu8fciPTW3stbDRk/JGjDK3qD0h96k+u
X-Received: by 2002:ac8:5d42:0:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-5013a41792cmr752671cf.17.1768244961509; Mon, 12 Jan 2026
 11:09:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-21-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-21-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 19:08:00 +0000
X-Gm-Features: AZwV_Qjgu-sXQZIHm3TAlOW62aUWk-t7wcra038ZJt2_3BJ_d28PSVA3xv4zVCM
Message-ID: <CA+EHjTz4vDFdhbZMz6mNacdzSJLFfVbQKMGmSo=Vt9bSB4ho0Q@mail.gmail.com>
Subject: Re: [PATCH v9 21/30] KVM: arm64: Flush register state on writes to
 SVCR.SM and SVCR.ZA
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

On Tue, 23 Dec 2025 at 01:23, Mark Brown <broonie@kernel.org> wrote:
>
> Writes to the physical SVCR.SM and SVCR.ZA change the state of PSTATE.SM
> and PSTATE.ZA, causing other floating point state to reset. Emulate this
> behaviour for writes done via the KVM userspace ABI.
>
> Setting PSTATE.ZA to 1 causes ZA and ZT0 to be reset to 0, these are stored
> in sme_state. Setting PSTATE.ZA to 0 causes ZA and ZT0 to become inaccesible
> so no reset is needed.

nit: inaccesible -> inaccessible

>
> Any change in PSTATE.SM causes the V, Z, P, FFR and FPMR registers to be
> reset to 0 and FPSR to be reset to 0x800009f.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 24 ++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c         | 29 ++++++++++++++++++++++++++++-
>  2 files changed, 52 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 44595a789a97..bd7a9a4efbc3 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1147,6 +1147,30 @@ struct kvm_vcpu_arch {
>
>  #define vcpu_sve_state_size(vcpu) sve_state_size_from_vl((vcpu)->arch.max_vl[ARM64_VEC_SVE])
>
> +#define vcpu_sme_state(vcpu) (kern_hyp_va((vcpu)->arch.sme_state))
> +
> +#define sme_state_size_from_vl(vl, sme2) ({                            \
> +       size_t __size_ret;                                              \
> +       unsigned int __vq;                                              \
> +                                                                       \
> +       if (WARN_ON(!sve_vl_valid(vl))) {                               \
> +               __size_ret = 0;                                         \
> +       } else {                                                        \
> +               __vq = sve_vq_from_vl(vl);                              \
> +               __size_ret = ZA_SIG_REGS_SIZE(__vq);                    \
> +               if (sme2)                                               \
> +                       __size_ret += ZT_SIG_REG_SIZE;                  \
> +       }                                                               \
> +                                                                       \
> +       __size_ret;                                                     \
> +})
> +
> +#define vcpu_sme_state_size(vcpu) ({                                   \
> +       unsigned long __vl;                                             \
> +       __vl = (vcpu)->arch.max_vl[ARM64_VEC_SME];                      \
> +       sme_state_size_from_vl(__vl, vcpu_has_sme2(vcpu));              \
> +})
> +
>  /*
>   * Only use __vcpu_sys_reg/ctxt_sys_reg if you know you want the
>   * memory backed version of a register, and not the one most recently
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 51f175bbe8d1..4ecfcb0af24c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -927,6 +927,33 @@ static unsigned int hidden_visibility(const struct kvm_vcpu *vcpu,
>         return REG_HIDDEN;
>  }
>
> +static int set_svcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +                   u64 val)
> +{
> +       u64 old = __vcpu_sys_reg(vcpu, rd->reg);
> +
> +       if (val & SVCR_RES0)
> +               return -EINVAL;
> +
> +       if ((val & SVCR_ZA) && !(old & SVCR_ZA) && vcpu->arch.sme_state)
> +               memset(vcpu->arch.sme_state, 0, vcpu_sme_state_size(vcpu));
> +
> +       if ((val & SVCR_SM) != (old & SVCR_SM)) {
> +               memset(vcpu->arch.ctxt.fp_regs.vregs, 0,
> +                      sizeof(vcpu->arch.ctxt.fp_regs.vregs));
> +
> +               if (vcpu->arch.sve_state)
> +                       memset(vcpu->arch.sve_state, 0,
> +                              vcpu_sve_state_size(vcpu));

If sve_state isn't allocated, this means that we've gotten here before
finalization. Is it better to return an error rather than silently
skipping this?

> +
> +               __vcpu_assign_sys_reg(vcpu, FPMR, 0);
> +               vcpu->arch.ctxt.fp_regs.fpsr = 0x800009f;

This matches the Arm Arm, but can we use a define or construct it,
rather than using a magic number?

Cheers,
/fuad


> +       }
> +
> +       __vcpu_assign_sys_reg(vcpu, rd->reg, val);
> +       return 0;
> +}
> +
>  static unsigned int pmu_visibility(const struct kvm_vcpu *vcpu,
>                                    const struct sys_reg_desc *r)
>  {
> @@ -3512,7 +3539,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>                     CTR_EL0_DminLine_MASK |
>                     CTR_EL0_L1Ip_MASK |
>                     CTR_EL0_IminLine_MASK),
> -       { SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
> +       { SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility, .set_user = set_svcr },
>         { SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
>
>         { PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
>
> --
> 2.47.3
>
