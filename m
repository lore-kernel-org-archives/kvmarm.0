Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85B1BA21
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770922425; cv=pass; b=twbyeZ/Q1WJ5l5CsCWUaopLgn90omKRpUvYKYaofIvWnf/n89KOk8qarL0cKgpWEz52wPbykGpyooK9v9465GxpcZr9CHnRuDbTgWDlyG8u5LrzQIn0q+eh3mijZymwsIC5Ewt6gRqgHit2ZPKS4o0GOMQGBNqoYr3hnQLZv1Rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770922425; c=relaxed/simple;
	bh=XMDd4/Tmzy2G8avag+KjNC0MlH3sj+OcJMh3Za8Ln/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5RVESWDAW7QeQqO/6v9LKsH+l5M22TerTyNDXqX32ZX5XPTeTZ2jJqiGP+ji8AwHa1VHQtUvgraQ6Q77JCQxVCTTa/V3DSfFELooZ68j41aSmDG/bxeIHdMt/031R/4fzH9O+ZpJerXNQJgBQYESyV1txbUW1GYrs2JzAMCJS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wcRgBUmd; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wcRgBUmd"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5069a785ed2so40031cf.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 10:53:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770922423; cv=none;
        d=google.com; s=arc-20240605;
        b=Hc858oj3g2phcmKODrS8C+DGKdc8b+aE/viVY4uFRxb85VdGNVCpoPZS11QcuBZuw1
         bEb0nCDjyJQrWAKcuxqV6ri/pBs0l7h9firx8BGJPPp7il+rleWh3QNmtqehs4W+CYM+
         dL8dc/xoH0BJYSDXGQrEP/bPf/SQVRAEhcFk1EgsmAkSaTkkTYh0hU3WZ1zTnNzCX18J
         u2tTWf/QPjiYXkFVCBW6W+ZCHCHuu/1CvFr4q53PymF6ymqPDbUSIYmS7XNA3oZ4yPOw
         3FJQZSUSL+fXk0M6mbKW0ZIvWy63Sk48mdUod7FdJQ6Al04Ma4r7A5g8LAYbDiSVjWNR
         DEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KxJxh9FSjNvMYBpkVXl2+9DScVhBboCfxSSFZplOIEM=;
        fh=7zorj+YIBCY6dzB8OMNDgQ+5AHjXNI/e21GgU3pv8+8=;
        b=ElYHTBk8zomI91pA7WkqnWFydhEaROVB///rma9CHbmJogl+WEDf6MWxQraGYjU1Uk
         fOaxVTKRo8KesrgyDwwvGq8PeUaOJE1m4t7xs8e4Oq1/jVLtwo9sJICrKzz5aEBjo0q0
         1OrURw6VMb7CQOK3LIqATFDNVgRHZSBKoiHncw+ctBGtCOg5F4KaJHDnZAMk5lqzvtVL
         fLNSGDs6PUws0J5Ur8QrxF9SExnMGMLbZLgUs1bM2+4fcEGHnX6tyMR2tGhWsKgQ80D1
         JFPnPB7rz77z+GSAcMzhrhA/1hL4WAi17q5BuvX1uiNNye6/DW1U9cKHdmy7LFQDZ6HL
         gndw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770922423; x=1771527223; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KxJxh9FSjNvMYBpkVXl2+9DScVhBboCfxSSFZplOIEM=;
        b=wcRgBUmdOCecu63wCKBfhjfwtW3k4HdpoESXlqeN9zY2HeiNO+z4WfhAMHLguuyfpO
         hM+hBzRiVQ295Mj9C7gRF8TIdBcgN6GRvpP19F2+FK4I5uNpSKytFiiyrJrS/99uvrh/
         EttfF48KvNgj4ajrVtJMQkclVeFfza0S3m/TMmogjW4hmFWEo3yCzAzMkcSdVmba/pbb
         9eBtaIhHj+/4riVAPPuY9nOlH82x1zxrMCM6wkGJlPfi7IVKtRgS43+muycWAgV/Ysc/
         xegE/C2rphpgUr/3NxqVRKQuJnLKk6TB57SvrwO3jxeZuJWaoZvLDX0N7dhsIMZy+IeI
         364Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770922423; x=1771527223;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KxJxh9FSjNvMYBpkVXl2+9DScVhBboCfxSSFZplOIEM=;
        b=k5WxCYOCigLuh5F2PmjXSkHsK+tH3jteNx7mgj9Tuj5diPFW2bNT7alfiE3OlKSeQG
         AAdi5hmxRkblUfWmFWbIWapG+kKgkGfE0JBZkRB87JjnUx+NAkbc0jaSeiINFj0odS5F
         kMVouSRSV3SX2CgXrp+IW+yElYcoT4f5Zo36Zy+wLybcHiiFEjWzNJcnbQdL8pSiekmo
         3C2TFxUnd3XwMn1kmcRfSeS65v+JZ7tKg0c59jyAWEaEnunjU09x2oFe06p0ICMs2uC1
         S58SataW+Hiwzmi5ezlfVfW8cLNWNkvge/13jbjMjqKvevkFP5Nt8bPFrf9tfKkubJqE
         F5Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXvOYK6gtrSqQIp/+Lr8Zy2fCTcwIsI2B833ij0q0bcqdgUxy9v5cdA6aOPZlWW75napr4zdRE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPBp/u6qLJ0uy+2t7G9l5cWXdakjW4uVQ7Sk+U1lhJ7ekT4eqP
	6hx+U6zoCMmB1d89Sr2pCFFOYXqZhqTUFSDxDwRq7C70IWKZvqa5angg2jR8hfrxk0NLedpRkjb
	doawaH0ZKC0Mr8jrdn3RWqyvsi3q5sYYTZBpdRNDV
X-Gm-Gg: AZuq6aIAiIRFOIflK/16OLVUCvWSCbauE/tXENLcrMGXEfmyZs+lRSxbPNFB+k0XR0m
	cVP/TPnJ6Rd52xOTgITkDPmhs4O2vrAG0AKRBPQt+F0I9JbO1+yG+1pztBzE4eMnEJUJ5FHIo1l
	A8IiZPZ2BiMfS3aY3Eo1gKmcIvxjIU3EAYyKZpqxmu3vvAJBkptzlLn8YA1XxVTC4YEXLapeeY4
	kx66ACCdfvsCbdh2d/gcKI3WqtHB+tGR0e4duB96g08nE2p1ntDMldEjBptL6je8VIKx981OaIk
	o1tvw9xZpcuGpSUXWSM=
X-Received: by 2002:ac8:5ace:0:b0:503:2e98:7842 with SMTP id
 d75a77b69052e-506a5089fd7mr798601cf.4.1770922422056; Thu, 12 Feb 2026
 10:53:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com> <20260212090252.158689-2-tabba@google.com>
 <86jywib98e.wl-maz@kernel.org> <CA+EHjTz-JU2gDfziCY2SguK9=6gGSCL5TN_U_C7FiZ5i0JTZqQ@mail.gmail.com>
 <86ikc2asa8.wl-maz@kernel.org>
In-Reply-To: <86ikc2asa8.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Feb 2026 18:53:05 +0000
X-Gm-Features: AZwV_QgjHAKlb2oJ6cTtVmiD8glUdVPUVPAc_uYr3UsDjUESaoBBPSZwwkWqYwc
Message-ID: <CA+EHjTwLcxB1e_FZsw_Semoj8tjMBUKZFM8+Vbo+64+=T4GN-Q@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Hide S1POE from guests when not
 supported by the host
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

/fuad

On Thu, 12 Feb 2026 at 15:35, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 12 Feb 2026 09:41:22 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Thu, 12 Feb 2026 at 09:29, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > Hi Fuad,
> > >
> > > On Thu, 12 Feb 2026 09:02:50 +0000,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > When CONFIG_ARM64_POE is disabled, KVM does not save/restore POR_EL1.
> > > > However, ID_AA64MMFR3_EL1 sanitisation currently exposes the feature to
> > > > guests whenever the hardware supports it, ignoring the host kernel
> > > > configuration.
> > >
> > > This is the umpteenth time we get caught by this. PAN was the latest
> > > instance until this one. Maybe an approach would be to have a default
> > > override when a config option is not enabled, so that KVM is
> > > consistent with the rest of the kernel?
> >
> > I spoke to Will about this, and one thing he'll look into is whether
> > this value in `struct arm64_ftr_reg` can be made consistent with the
> > cpu configuration itself (in cpufeature.c itself) . This would avoid
> > the problem altogether if possible. The question is whether the kernel
> > needs to somehow know that a certain feature exists even if it's
> > disabled in the config...
> >
> > If he thinks it's not doable at that level, I'll look into
> > alternatives to make it correct by construction.
>
> What I currently have for that is rather ugly:
>
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 72f39cecce93a..3bde0ad5ea972 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -971,6 +971,7 @@ struct arm64_ftr_reg *get_arm64_ftr_reg(u32 sys_id);
>  extern struct arm64_ftr_override id_aa64mmfr0_override;
>  extern struct arm64_ftr_override id_aa64mmfr1_override;
>  extern struct arm64_ftr_override id_aa64mmfr2_override;
> +extern struct arm64_ftr_override id_aa64mmfr3_override;
>  extern struct arm64_ftr_override id_aa64pfr0_override;
>  extern struct arm64_ftr_override id_aa64pfr1_override;
>  extern struct arm64_ftr_override id_aa64zfr0_override;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 1a7eec542675b..32069da9651bf 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -778,6 +778,7 @@ static const struct arm64_ftr_bits ftr_raz[] = {
>  struct arm64_ftr_override __read_mostly id_aa64mmfr0_override;
>  struct arm64_ftr_override __read_mostly id_aa64mmfr1_override;
>  struct arm64_ftr_override __read_mostly id_aa64mmfr2_override;
> +struct arm64_ftr_override __read_mostly id_aa64mmfr3_override;
>  struct arm64_ftr_override __read_mostly id_aa64pfr0_override;
>  struct arm64_ftr_override __read_mostly id_aa64pfr1_override;
>  struct arm64_ftr_override __read_mostly id_aa64zfr0_override;
> @@ -850,7 +851,8 @@ static const struct __ftr_reg_entry {
>                                &id_aa64mmfr1_override),
>         ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2,
>                                &id_aa64mmfr2_override),
> -       ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
> +       ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3,
> +                              &id_aa64mmfr3_override),
>         ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
>
>         /* Op1 = 0, CRn = 10, CRm = 4 */
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 85bc629270bd9..202e165a4680c 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -51,6 +51,7 @@ PI_EXPORT_SYM(id_aa64isar2_override);
>  PI_EXPORT_SYM(id_aa64mmfr0_override);
>  PI_EXPORT_SYM(id_aa64mmfr1_override);
>  PI_EXPORT_SYM(id_aa64mmfr2_override);
> +PI_EXPORT_SYM(id_aa64mmfr3_override);
>  PI_EXPORT_SYM(id_aa64pfr0_override);
>  PI_EXPORT_SYM(id_aa64pfr1_override);
>  PI_EXPORT_SYM(id_aa64smfr0_override);
> diff --git a/arch/arm64/kernel/pi/idreg-override.c b/arch/arm64/kernel/pi/idreg-override.c
> index e5ea280452c3b..b8dbe02e53171 100644
> --- a/arch/arm64/kernel/pi/idreg-override.c
> +++ b/arch/arm64/kernel/pi/idreg-override.c
> @@ -24,10 +24,12 @@
>  static u64 __boot_status __initdata;
>
>  typedef bool filter_t(u64 val);
> +typedef void cfg_override_t(struct arm64_ftr_override *);
>
>  struct ftr_set_desc {
>         char                            name[FTR_DESC_NAME_LEN];
>         PREL64(struct arm64_ftr_override, override);
> +       PREL64(cfg_override_t,          cfg_override);
>         struct {
>                 char                    name[FTR_DESC_FIELD_LEN];
>                 u8                      shift;
> @@ -106,6 +108,22 @@ static const struct ftr_set_desc mmfr2 __prel64_initconst = {
>         },
>  };
>
> +static void __init cfg_mmfr3_override(struct arm64_ftr_override *override)
> +{
> +#ifndef CONFIG_ARM64_POE
> +       override->mask |= ID_AA64MMFR3_EL1_S1POE_MASK;
> +#endif
> +}
> +
> +static const struct ftr_set_desc mmfr3 __prel64_initconst = {
> +       .name           = "id_aa64mmfr3",
> +       .override       = &id_aa64mmfr3_override,
> +       .cfg_override   = cfg_mmfr3_override,
> +       .fields         = {
> +               {}
> +       },
> +};
> +
>  static bool __init pfr0_sve_filter(u64 val)
>  {
>         /*
> @@ -221,6 +239,7 @@ PREL64(const struct ftr_set_desc, reg) regs[] __prel64_initconst = {
>         { &mmfr0        },
>         { &mmfr1        },
>         { &mmfr2        },
> +       { &mmfr3        },
>         { &pfr0         },
>         { &pfr1         },
>         { &isar1        },
> @@ -398,14 +417,19 @@ void __init init_feature_override(u64 boot_status, const void *fdt,
>  {
>         struct arm64_ftr_override *override;
>         const struct ftr_set_desc *reg;
> +       cfg_override_t *cfg_override;
>         int i;
>
>         for (i = 0; i < ARRAY_SIZE(regs); i++) {
>                 reg = prel64_pointer(regs[i].reg);
>                 override = prel64_pointer(reg->override);
> +               cfg_override = prel64_pointer(reg->cfg_override);
>
>                 override->val  = 0;
>                 override->mask = 0;
> +
> +               if (cfg_override)
> +                       cfg_override(override);
>         }
>
>         __boot_status = boot_status;
>
>
> which works, but is not super friendly.

Ouch! Yeah, no easy solutions here. For now, as a fix to be able to
backport, would you like me to respin this without the change to
kvm_has_s1poe(), or with that change as a separate patch?

Cheers,
/fuad
> Looking at the arm64_ftr_reg structure, this could work if
> FTR_VISIBLE_IF_IS_ENABLED() didn't simply put "HIDDEN" when the
> feature is not present, but forced things to be disabled
> altogether. The problem is that "HIDDEN" means not shown to userspace,
> and that we have plenty of HIDDEN features that must make it into KVM.
>
> I'll have a think.
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
