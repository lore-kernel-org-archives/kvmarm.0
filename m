Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1EE3563F3
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974176; cv=pass; b=ky5l63IwjkwcZ6ywI0WxdtXhPDaRXIKT47eg1SNzMXqw2DlGbVeSfF8Oy5dl4qkNvHmODKcaHK9IDu6ItVos5qwFoNPoJqjL/1tcKLK5wCFYsZQ7q1/mwEl2b0s8C1NMhK2DLh5e6C6GWoWypfTT2yqoLDHVaKfO7XoRmbhN/3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974176; c=relaxed/simple;
	bh=iK5AUYKKnG1GCt/80DpdeQQfwbtmqro71Xoh6GzOc/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cZZzwP/pe8Q/rs2hUNXVWW3pEYvvI5tV/rGyj85uhk4sDNgZZeM3j/Vc0ugmsDmD+6sRnRMM0clfSAq0bRFVCHfYmknngvYKGBB0Si2SbpTqaU/ENJdNIUk4A170oanXsrWXuDCMWq6WFcc0gcVMuFk+ocXrhqVpYTnI21dDM4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HgE/xowY; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HgE/xowY"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee243b98caso353711cf.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 07:56:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767974174; cv=none;
        d=google.com; s=arc-20240605;
        b=k8650laHYPnMMR9UMqLtigkXe3Vo1xnljCDl3cItLPk1zFcKLoVkzQMQzrVBp2BY+S
         4zV4KxST6cvVH6SwTW+VYDkm+1zEEj2j2w9J0xtn/blW/D7eNvxzGQItLBzTBxUwfB9F
         nUDVHuRDq8huXwGGDJ55RsBZW5GnMpz9fVKjQBfha3C7c5rEvCv0/jF8POey33ejX49P
         RCAK3hMPpW3HeXLkJ69xhehzPETBda06V8UQjitZMw5UDc4Y0zQMCVHm9af0bdYhBd29
         YSnmaJdW+oORtyChbsyO5/xd1C+UvOvuriFBLsDhp+WgqBDCoxPCFiKJr6GmIdBd2p4w
         wrCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U8I+9Z/SzReDIbFo3xnWDAd13nvsAbuR5scsRwJQ9D4=;
        fh=BDA3EUaqLwABm5vQm82twiQFsWu6CafkoVClXHoQ48U=;
        b=VtwCp13vDS2Etm1X4cCusBztUKe3gsKbqjoy2m5P1n/SjXRxTjpFWnRdkY+Jh4xP4N
         WL1S4fuElDpkZuDNH3sPIzEI2ToF0S+H2cm7hkw4gXv1+H1nMAdy6n6V6gB9FGHwMdI3
         0+PcKHBmkW6cZTVfY8IjC5LrGNx7WdNx3Rz88+Ap2vJqLLO23bohcydoENh/Nm7RlO4Y
         LIKMEmN2ybtpd8mn/z5FWkHNph3cxEUTVR47M0aWpHYXg5GM1xf4IhUZZPwDPyv8kWZc
         4ucGE5rRRB3z4/vs/yyaOmDgVjpKfxWI8IxSRpqY3+EzE4/VKCbnmlAv+foim9w/2LKN
         oHUw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767974174; x=1768578974; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U8I+9Z/SzReDIbFo3xnWDAd13nvsAbuR5scsRwJQ9D4=;
        b=HgE/xowYgs1WmccmDgueOeL5aOA3ADgYYAP43LElu/seOtA7cZ2aL3DxvYuoSJBf6x
         7cgBdRdhczFFpNWfbp5R1hCQRGP6pF0FeNOTrXwszCufh6h6DAaZYoBXe9chZ9XCBzsK
         muS3Em8+0WUyoq9TR1VvcCf0Aozl0Eoe01Tiuh4V7Nl3v1Gy/w7p9Yc5FqFmBuHDx5+M
         p1EWO++gDIMbjb8hiuNCuNpfxmfMyR/sb3UIWhIhcMdTabhJUDiWmdawOc4AAsY3Mbjw
         w8i64/7xAaxL+3vC/uBaqoQ/suuMM7a9MAthXCIYfP2CbaQOA63fVIzL6L7Pi/tE2JKT
         vv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767974174; x=1768578974;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8I+9Z/SzReDIbFo3xnWDAd13nvsAbuR5scsRwJQ9D4=;
        b=F8Rj+RZYPLm30mNi852K/lR2jdpS1AiAxHndPbF3jRdl5wtCr7f2hiUhJ+ScIQ0wry
         RM02wXsw7K9vTTpo8qWXBosT7dtjGzBxxB/od78KwgbaaiUkb5X7DTZzeNSES8R49bND
         6R715avlTQQKTRAg1RUrWQ0HMlBjzZ7hRsPQhEG7JhA2eyemFjO2zcCOoOxrOjVcMCcA
         UDHECdx5k9HDdAYjIsHerYMfCO6dRXzo4WS+q49MNJTgVAiQE0u2u3tOmr+efiEamErN
         IqXD1xMAN5gNge9xdvKAumB9/0SOWjCjJ053KK24nKyIZwuDd9kcuxGmyT4mK52nE932
         vwjA==
X-Forwarded-Encrypted: i=1; AJvYcCXsYccUFU4022gDxRNYOpGv8T+PlyRJPcVTW/DLmUEs70yyWRFuMQt899l9T2dag2xmFK5Ru80=@lists.linux.dev
X-Gm-Message-State: AOJu0YzY7EoD5rSct5XwSJZ95UbIPJjOGprU8UgjAyfLpQZq29zkQxEn
	sv+Ypp6aYQ81zmyHDlqz5wG7VYkils83tFgCAOR2ZWBi7fGln3TlFFnj2wS7OLhRipGxwgy/y+J
	nViiaDohgwnuDtabyYmQrmNfC1uff/PvaL2ATaiO7
X-Gm-Gg: AY/fxX48UdfDHUm1TuPGKelPcujDSXK1b+yhIVNG7ZAiKZd5ThOGxETOkehGbkzeqoh
	z9oO8SZTKCK+v6gy0vpUP9fD9BCoeCI/TfUbqaLmPjR6+zIugqI3ubdUTe9Z3cWtD2BhxGS00if
	PGxPoOzp1OLEYs6vtGgSPyBAha+sNgvYbnWa0NVwyPt+gITJCwyZ83AIAtI2XnwMbCEmknOWuQw
	AUpm+WT+ZK3skC+XlZIrK6YTNRzpLgTqdSjF6QykskDVd3jB/nWjcRtfU4jEVU8m+H2bCjp
X-Received: by 2002:a05:622a:206:b0:4ff:a96a:90fc with SMTP id
 d75a77b69052e-4ffca10c9e7mr11956941cf.0.1767974173794; Fri, 09 Jan 2026
 07:56:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-11-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-11-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Jan 2026 15:55:36 +0000
X-Gm-Features: AZwV_Qjl7-V6jtqPJiWFE-pNSysqHN43mjzymjYZ55x2bRwN0FRgaHUdOP2UPAs
Message-ID: <CA+EHjTznZj94NFVQGG8Bi0=kkQUMYA0omdGS++83jwLj-CDRNQ@mail.gmail.com>
Subject: Re: [PATCH v9 11/30] KVM: arm64: Define internal features for SME
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
> In order to simplify interdependencies in the rest of the series define
> the feature detection for SME and it's subfeatures.  Due to the need for

nit: it's -> its

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> vector length configuration we define a flag for SME like for SVE.  We
> also have two subfeatures which add architectural state, FA64 and SME2,
> which are configured via the normal ID register scheme.
>
> Also provide helpers which check if the vCPU is in streaming mode or has
> ZA enabled.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>


> ---
>  arch/arm64/include/asm/kvm_host.h | 35 ++++++++++++++++++++++++++++++++++-
>  arch/arm64/kvm/sys_regs.c         |  2 +-
>  2 files changed, 35 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 0f3d26467bf0..0816180dc551 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -353,6 +353,8 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS             10
>         /* Unhandled SEAs are taken to userspace */
>  #define KVM_ARCH_FLAG_EXIT_SEA                         11
> +       /* SME exposed to guest */
> +#define KVM_ARCH_FLAG_GUEST_HAS_SME                    12
>         unsigned long flags;
>
>         /* VM-wide vCPU feature set */
> @@ -1062,7 +1064,16 @@ struct kvm_vcpu_arch {
>  #define vcpu_has_sve(vcpu)     kvm_has_sve((vcpu)->kvm)
>  #endif
>
> -#define vcpu_has_vec(vcpu) vcpu_has_sve(vcpu)
> +#define kvm_has_sme(kvm)       (system_supports_sme() &&               \
> +                                test_bit(KVM_ARCH_FLAG_GUEST_HAS_SME, &(kvm)->arch.flags))
> +
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define vcpu_has_sme(vcpu)     kvm_has_sme(kern_hyp_va((vcpu)->kvm))
> +#else
> +#define vcpu_has_sme(vcpu)     kvm_has_sme((vcpu)->kvm)
> +#endif
> +
> +#define vcpu_has_vec(vcpu) (vcpu_has_sve(vcpu) || vcpu_has_sme(vcpu))
>
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)                                         \
> @@ -1602,6 +1613,28 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  #define kvm_has_sctlr2(k)                              \
>         (kvm_has_feat((k), ID_AA64MMFR3_EL1, SCTLRX, IMP))
>
> +#define kvm_has_fa64(k)                                        \
> +       (system_supports_fa64() &&                      \
> +        kvm_has_feat((k), ID_AA64SMFR0_EL1, FA64, IMP))
> +
> +#define kvm_has_sme2(k)                                        \
> +       (system_supports_sme2() &&                      \
> +        kvm_has_feat((k), ID_AA64PFR1_EL1, SME, SME2))
> +
> +#ifdef __KVM_NVHE_HYPERVISOR__
> +#define vcpu_has_sme2(vcpu)    kvm_has_sme2(kern_hyp_va((vcpu)->kvm))
> +#define vcpu_has_fa64(vcpu)    kvm_has_fa64(kern_hyp_va((vcpu)->kvm))
> +#else
> +#define vcpu_has_sme2(vcpu)    kvm_has_sme2((vcpu)->kvm)
> +#define vcpu_has_fa64(vcpu)    kvm_has_fa64((vcpu)->kvm)
> +#endif
> +
> +#define vcpu_in_streaming_mode(vcpu) \
> +       (__vcpu_sys_reg(vcpu, SVCR) & SVCR_SM_MASK)
> +
> +#define vcpu_za_enabled(vcpu) \
> +       (__vcpu_sys_reg(vcpu, SVCR) & SVCR_ZA_MASK)
> +
>  static inline bool kvm_arch_has_irq_bypass(void)
>  {
>         return true;
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c8fd7c6a12a1..3576e69468db 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1945,7 +1945,7 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
>                                    const struct sys_reg_desc *rd)
>  {
> -       if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, IMP))
> +       if (vcpu_has_sme(vcpu))
>                 return 0;
>
>         return REG_HIDDEN;
>
> --
> 2.47.3
>
