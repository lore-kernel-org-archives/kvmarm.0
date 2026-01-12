Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B1B3570D1
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 12:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768219203; cv=pass; b=N1ro3fJ4XcFNBILzMAfyEPNwh1OuyeWgvpU654bU9T5Y/ksIFonFbNYwgP490FhJau7xT49meaOAEbwCzcUCXSC5kuCYY7kKxa19GAhWuNPHX9nMamp3FvBLfNL8y0/tTtoJoAEtAX8GLZB+MarfsloeN1AHWBP+JE2kU/JqtZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768219203; c=relaxed/simple;
	bh=M1jG2cxx4p2/zCe7hGXotN8Edhf4Ww+MYu2JyhVnpu4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oRPxka7fOVqnWX4tvvtPAptYreY/fEYSwQcZpM2ldsXVBOfOFXgiwotj96wwgseyWVMcx4yymQd+tsF2QMCKpShns7JvVFstVeezG3Q6fWFP7KRtHyQfNo9BZ8WwvRPxWpx1wo0NOns2bBRb3WPJ48bY/duUaaIly3JjcKyuQsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zoig/PzS; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zoig/PzS"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee147baf7bso799301cf.1
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 04:00:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768219200; cv=none;
        d=google.com; s=arc-20240605;
        b=Y5Ug6OIT2evF0yFWfr06gWUvWlprNwvJBkKEQW7kpWaKS/5cuK6ZfyHmgKdPqsBiUY
         zWWGzPQzrNTzb2ijzh5Ix8Md/7K3Ndes61nIjCzH2gl4gKvv24wvWc75bEQD//3+5Azh
         lqbVarMFgJI2lq8gz1m8ef/zzpZ6TlyIdQOVvVBPb5gDvrITS2mKhQY80ehm4lL6CaGy
         gwjLAR/uGAkl7YKyjlPAUozXSc66FkoKSoZZnFIpX/f61irXhZig+7ABXmWuJ7FU4xI7
         6MWffSJO79Qy1gvHQe3ECQRLzVMAJC+VnMl+cQ8cscv+V9ng0l1EpDGqt7sre8AO0BsG
         emsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EhverceljAAUxMEU3GTIMI93Myxn5CKaFJOdFr79HIY=;
        fh=VPICPU5BQ26bLUB2liIyXvMmwrej7cNDrevuvMa+Y3E=;
        b=I9JSw1fLqQPiQJj3FIBRYBv4GVCVpSNcS1enMHyEYsABJ+ZLNQKDeg2sM+a53R/YcJ
         vNXpzBAPMFqG90udjeenARGG6urcfsAn/+qlsMDArCSkG/8MC/tpsEwWao1RhVGnT3p6
         GysWgpch/ynLPNER/YAMQ3gBCjgFP4QunxMZbpQ1AyxQLJouW/FTSsIC+kof1dpBnWpF
         dDVrP3ebq7lexQjRMKqF3yK8yvhIzTNXCsU677nkIXDQ0gUGxMkIE5A6Jk+LoGigJ5qN
         MBL8oVa3/e7jViclyafif7V3Japul26VDH+bi0wJXHfKq3shV2hMhOYSPgLXpt5FhXIe
         gAEw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768219200; x=1768824000; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EhverceljAAUxMEU3GTIMI93Myxn5CKaFJOdFr79HIY=;
        b=zoig/PzSVpZrlXlUEHUsUUVB3n6Vi06wFlFz8JaNg31ZjcsRMSKC1CjRWv9WrghOOw
         ksgICbtWn/d73fQ5zadT0/KTeMDoczs4d2u8TEqN0pRWVoXGLIFhjHKTamZUiRPeMARW
         BpUyZ4CxZCgryHfXMuA5PQRzkn7IRk/fS4PXL+UYbsfn1g45QX/r+72em0wQLNjOufHo
         lQi1tRoqyYF9ItbWvy3kG6K2Bh03ly4pO6ZYazfba7s7Mj2ppP+gG5n2csUlNmzwKJkW
         3JDmIChVXZe5w5LFXuhgxaNuLG8/ysW4QcHOi5xcK4ORY21Kc86KfS28zyl/nLctS76v
         VPGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768219200; x=1768824000;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EhverceljAAUxMEU3GTIMI93Myxn5CKaFJOdFr79HIY=;
        b=qlZ5SH7+4WHWR4I38jMfL9Y3BY8yWGEuxwym+RSjyW3GDDUrku6t3s1EIGbHY4C2cj
         PWW77fR8vWeuaI49SQi4FoapaZHhr9LOP/8s4bb6rycw5MWvXATH2RYvYIjZAzD3MxOa
         7cyTPNpb4EJzoL3z7BPh23qzSDo9NqXRGVzHyBY6USVLs6kwrY4tC/Dkdf1Kwffs8uIi
         Ng9OrvvpDg+8XptgYLHvdrQMik2KiHctVPGdTJY48n3bBz2+Z+3om8PJaJOxOWyeKg92
         TcCJZeqA2uNGMr/CfIPZFKV3ul/8nQ5Lk/SeXMiCrHpeTzoMBgamtWepK/Pmbr0h+Zqd
         e55w==
X-Forwarded-Encrypted: i=1; AJvYcCX+649g8kcVflTgFiAvwNj3WBUuK0BCVqaITxTD14LyfHhTtDljR+8VQWHzeK8WrXdrsK553cs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy81eq5+ZGlIv5q3loNSUSjIwD8GPYw5WOe80tvuyy1uSJstZUY
	bvZBdQU27SWdGI4NquJVOXSMuOEAlt8Q3kbO+O1vGlMbla8uE8idxgVw0y9QftYOHG3R6RjZ/+g
	kaJQ97jF+aAbnnZ7Ln7JhLwNQ//6rJHrRU4tChO9t
X-Gm-Gg: AY/fxX7L8RXgN5Gfen4aKLn94u9Gl2yXS/8O5fIXK6mLvGzaaNSKJpeeEF4HOAuA85r
	1CoGIULvmRV6+wN5KWktxmtUsnHrITu8crJ04bsrqaoyOIMtaouCjv/zbC4lvDD8mYx1TtYWQsw
	pti12rAJe9YsW82gAvxLH6DcREb4J3tgHVSf7FxkYeWOTHxZtg4g1IRvOvNc3FPG7WeCf8FkiCc
	tgd+tnfHgLVVe7H4u5gLXH9n7gC8m0K/O5o5qvW51Buw+C61znAxpkDCv8alQ1o+8gKVz9F
X-Received: by 2002:ac8:5891:0:b0:4ff:bfdd:3f46 with SMTP id
 d75a77b69052e-5011979b086mr17248321cf.15.1768219199451; Mon, 12 Jan 2026
 03:59:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-18-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-18-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 11:59:22 +0000
X-Gm-Features: AZwV_QjlL10TIxuJSo-17cIhu7wpBka538OyBuaIYcHbCwZvW100GJwAVVv1kGY
Message-ID: <CA+EHjTwxc=+1TodVR7X96fnKu-mykivdFxMbB5nUrw_h4MGKHg@mail.gmail.com>
Subject: Re: [PATCH v9 18/30] KVM: arm64: Support SME priority registers
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

Hi Mark,

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> SME has optional support for configuring the relative priorities of PEs
> in systems where they share a single SME hardware block, known as a
> SMCU. Currently we do not have any support for this in Linux and will
> also hide it from KVM guests, pending experience with practical
> implementations. The interface for configuring priority support is via
> two new system registers, these registers are always defined when SME is
> available.
>
> The register SMPRI_EL1 allows control of SME execution priorities. Since
> we disable SME priority support for guests this register is RES0, define
> it as such and enable fine grained traps for SMPRI_EL1 to ensure that
> guests can't write to it even if the hardware supports priorites.  Since

nit: priorites -> priorities

> the register should be readable with fixed contents we only trap writes,
> not reads. Since there is no host support for using priorities the
> register currently left with a value of 0 by the host so we do not need
> to update the value for guests.
>
> There is also an EL2 register SMPRIMAP_EL2 for virtualisation of
> priorities, this is RES0 when priority configuration is not supported
> but has no specific traps available.  When saving state from a nested
> guest we overwite any value the guest stored.

nit: overwite -> overwrite

>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h     |  1 +
>  arch/arm64/include/asm/vncr_mapping.h |  1 +
>  arch/arm64/kvm/config.c               |  3 +++
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c    |  7 +++++++
>  arch/arm64/kvm/sys_regs.c             | 30 +++++++++++++++++++++++++++++-
>  5 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index fead6988f47c..44595a789a97 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -546,6 +546,7 @@ enum vcpu_sysreg {
>         VNCR(CPACR_EL1),/* Coprocessor Access Control */
>         VNCR(ZCR_EL1),  /* SVE Control */
>         VNCR(SMCR_EL1), /* SME Control */
> +       VNCR(SMPRIMAP_EL2),     /* Streaming Mode Priority Mapping Register */
>         VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
>         VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
>         VNCR(TCR_EL1),  /* Translation Control Register */
> diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
> index 44b12565321b..a2a84af6585b 100644
> --- a/arch/arm64/include/asm/vncr_mapping.h
> +++ b/arch/arm64/include/asm/vncr_mapping.h
> @@ -45,6 +45,7 @@
>  #define VNCR_ZCR_EL1            0x1E0
>  #define VNCR_HAFGRTR_EL2       0x1E8
>  #define VNCR_SMCR_EL1          0x1F0
> +#define VNCR_SMPRIMAP_EL2      0x1F0

This should be 0x1F8.

>  #define VNCR_TTBR0_EL1          0x200
>  #define VNCR_TTBR1_EL1          0x210
>  #define VNCR_FAR_EL1            0x220
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 7e26991b2df1..0088635a95bd 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1481,6 +1481,9 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
>
>         if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
>                 *vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
> +
> +       if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, IMP))
> +               *vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_nSMPRI_EL1;

Is the intention to _disable_ the trap in this case? I think you
wanted to enable them.

>  }
>
>  static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> index f28c6cf4fe1b..07aa4378c58a 100644
> --- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
> @@ -80,6 +80,13 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
>
>         if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
>                 __vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
> +
> +       /*
> +        * We block SME priorities so SMPRIMAP_EL2 is RES0, however we
> +        * do not have traps to block access so the guest might have
> +        * updated the state, overwrite anything there.

nit: overwrite -> overwriting

Cheers,
/fuad

> +        */
> +       __vcpu_assign_sys_reg(vcpu, SMPRIMAP_EL2, 0);
>  }
>
>  static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a7ab02822023..51f175bbe8d1 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -691,6 +691,15 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>                 return read_zero(vcpu, p);
>  }
>
> +static int set_res0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +                   u64 val)
> +{
> +       if (val)
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -1979,6 +1988,15 @@ static unsigned int fp8_visibility(const struct kvm_vcpu *vcpu,
>         return REG_HIDDEN;
>  }
>
> +static unsigned int sme_raz_visibility(const struct kvm_vcpu *vcpu,
> +                                      const struct sys_reg_desc *rd)
> +{
> +       if (vcpu_has_sme(vcpu))
> +               return REG_RAZ;
> +
> +       return REG_HIDDEN;
> +}
> +
>  static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>  {
>         if (!vcpu_has_sve(vcpu))
> @@ -3349,7 +3367,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>
>         { SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
>         { SYS_DESC(SYS_TRFCR_EL1), undef_access },
> -       { SYS_DESC(SYS_SMPRI_EL1), undef_access },
> +
> +       /*
> +        * SMPRI_EL1 is UNDEF when SME is disabled, the UNDEF is
> +        * handled via FGU which is handled without consulting this
> +        * table.
> +        */
> +       { SYS_DESC(SYS_SMPRI_EL1), trap_raz_wi, .visibility = sme_raz_visibility },
> +
>         { SYS_DESC(SYS_SMCR_EL1), NULL, reset_val, SMCR_EL1, 0, .visibility = sme_visibility },
>         { SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
>         { SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
> @@ -3719,6 +3744,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>
>         EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
>
> +       { SYS_DESC(SYS_SMPRIMAP_EL2), .reg = SMPRIMAP_EL2,
> +         .access = trap_raz_wi, .set_user = set_res0, .reset = reset_val,
> +         .val = 0, .visibility = sme_el2_visibility },
>         EL2_REG_FILTERED(SMCR_EL2, access_smcr_el2, reset_val, 0,
>                          sme_el2_visibility),
>
>
> --
> 2.47.3
>
