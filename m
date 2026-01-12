Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3555F37417D
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 18:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768242999; cv=pass; b=lVaBo32ak3Pdl2q+cE38VXV0T4M4Ym5RaV/bh7D1owvt62YZMvBegPD+wvMku14+9WX8IHMNra5O9FvDXTMtRcyCXEY39rw2bVmF6QnQAcG4sn2064Wgjj0NlX2wxaVfq5H2YJTNgfBIqwPIXtUTo9f3dl+qxfJEAjDraYvPbQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768242999; c=relaxed/simple;
	bh=EIrMm4XF6YXDK5QFU6GazWT7Q5wK9ZblkKgC5n9hRM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrFqnXNEmW8m8U7T2dYWzLk6QAiI2NMIWLjFdlcekwHBXYmoM7dpBfLyiUelR36pchCj911wxKsdLyemwRRGsCUT4SsD10JT4qA3Bz1pcffp+oR4qnu1r1W8qwcCkch/8+uS7Z5cIO9uAyi3UAfhAoOsGvdtyJCY7y44aPvl+Fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKTKhq1S; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKTKhq1S"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4edb8d6e98aso26681cf.0
        for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 10:36:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768242997; cv=none;
        d=google.com; s=arc-20240605;
        b=WlXalr/uFDoLTAeiIGIZpdvBWVdf3x2Ngr6n2BzsDFOPYZIQ1SklsMoJnmbQ+IhtOf
         pG4Dcci+Kw8Wy+GYuEvXBetgBBRGd3261DftyQVpXVOW/+y73ep215F7LUHbMLmhDu9Z
         nKqasfqHO2/7NQ25P5tvyOkaERukhB9auQL17f31gPn9R19MhRCufeljPk9O9HkgU7GC
         qxjtcTVxvSwPS9N0a6X3qeUF3Is3zppZdV9WGv+XmeNH6YuT2W1sPy91zvFTU01IZkrP
         StIpEYzVMhoi8sYR6/efx9VhHowCz9jTYbEx4V3PywNvKxNplJueJxVTr8Cy5k/OeLIa
         Sg1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YeVorztV8L2661ciMsTJRNHNSwWuFDTDQ9Xn6dJSHXo=;
        fh=U04n+/VIvuJG93NpEn+KE8cmXCVi+0RjOuzyXVqDFPo=;
        b=RyRVmuuJNge299csc53eSgM9VfXOzRT5BqKTYvo2GiyuZXkf0mDH6HItjaM0PxJ6x9
         ahsIhUc8mIWmQ+hiRCcpoMxQvKDc+v2So7oFbUggURNGeDjkPBg8Nh1Wlw/jpe3TZXph
         x4Xb2V0+rjOOMhIkksVNNS6GilcH/ZaTwPdYJh5wLrLNlnLO7td238c4nySgnHcQ6yB2
         tB1mfRMqCLX+Sg4zezC58ANoFIgksSG2YiF5gq6GYqbJ4UkVfFnAprQA8CS+1KQR/Xa3
         cTZlrXxEsIDJSrO6DJGlTT9zIGfRK4tPfCQr0U29Z3f5Qoi5t8fcQ5h50w3DQHJVM0en
         /TcQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768242997; x=1768847797; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YeVorztV8L2661ciMsTJRNHNSwWuFDTDQ9Xn6dJSHXo=;
        b=sKTKhq1SJZsmDN+bnYz2JFzamdxUAzKlIuX/YKVxFahKYPqnKMlmx0lnCuTvE1cR+d
         4LPYWVvimwemo7IvH5yGUiq4wgapj2/jvCC6rPss/eGrrg0AJ9dK/IN0E2taYI9qmiH+
         7yXq80CeWzXDNOolAcL9AmlU/GYCk4DFhVoam/nUFlYtslemEULAEhlVyRqL6A2IgiIi
         xVmUIfoggOZbvpxBkCSjbxfZ0pVEPsWtgawfh/G++IYzTzngEsCymhYdcFSGD8zTAo6S
         WSbuqOK+ywqwvCLgf0REwamZZbswfQpPTeyeCpswJV/0ule4QlKpP1cYdoM+s5Hj6hF5
         O1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768242997; x=1768847797;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeVorztV8L2661ciMsTJRNHNSwWuFDTDQ9Xn6dJSHXo=;
        b=YK86AcH+Gkr0Bufti533QynFDvKrnVxgu7y2fvBRRc2p405dVZn1uBKjIoRbIc8wJb
         VkPSiYZuSKNB7OeSf7JusVf7/wA/up+4Qcah58pp9Ox5hvD4sYT4xACqTPjZ8Nony0AT
         LG+YvHPN9aBjhWUj+ZDezQBzgKepDn2IUVA+3gtHOjT9Y7j4DFEyBkas4NWWXRf5F90t
         Q6Yc3/YEBr9ou8P7TrYz30pY0BeZr/RHt7ZAVtWliIm65yJQIloRtm7M+C5jxkKT2zit
         006hMPwQnuxqt0+d2cBiCcnvbjkZd1ufdhX1+F1L9nN86O6brgO+gON2L20htF03Wtz7
         fl/A==
X-Forwarded-Encrypted: i=1; AJvYcCWXEFkLCDLpZxq/OhgtprWmmNSByzy741xDnyJ427sfOqKf1SLNnvCzW5QuC0KmTbstvIM5FaA=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywz91FGoY32KVsCkukLNYi5fVHD08zwNyGWFg/PrwjDkQtzij58
	u6PUcs5Aov1GBVtAX0V+j3fmXefORAKeTcms+HP5Xu6HPOZhhNI3ZBnLM6Xnkt0ly78BxUlEn47
	CEoj5yYddXmLESwitufmKlZPcsg9lSIc9XJqRJl3j
X-Gm-Gg: AY/fxX7sNHYSd+Whp1WJXv+u9jpAXWv+3D4aqnWkFrb+jevnGJUjssCDRvk53LHzt4C
	K4TNpH744/rFMtW9zAyrEydBBjBg8r8Twl106zWVAvmTsLZtVQi5Qu4LQhguRtS6tMwKQoP5Wmv
	AoV9XtEBbuNkAH5cCT3pcXBEOf2g7NqEfDw+o9ULF8FacRSECkw7SctSoZnxMmH5s75QKy1djJq
	WVFjF8L3o/O9mHypDQ5v3QxgyUIDY5LJbcEFB50M/oS7J5Cdxs+wnoJ3+Wv7cKw57EltCdt
X-Received: by 2002:ac8:505a:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5013a3c78b1mr163381cf.1.1768242996667; Mon, 12 Jan 2026
 10:36:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-20-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-20-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 Jan 2026 18:35:00 +0000
X-Gm-Features: AZwV_Qio1zjivzMeQYMIWVOvizuY7XatkfCAEo9m4hnoTRYK322NCwDdKHaZ9i8
Message-ID: <CA+EHjTyovGEkb6svw-=wR=DF52j-wWTawJ5a19EuvSt4i9Re2Q@mail.gmail.com>
Subject: Re: [PATCH v9 20/30] KVM: arm64: Support userspace access to
 streaming mode Z and P registers
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
> SME introduces a mode called streaming mode where the Z, P and optionally
> FFR registers can be accessed using the SVE instructions but with the SME
> vector length. Reflect this in the ABI for accessing the guest registers by
> making the vector length for the vcpu reflect the vector length that would
> be seen by the guest were it running, using the SME vector length when the
> guest is configured for streaming mode.
>
> Since SME may be present without SVE we also update the existing checks for
> access to the Z, P and V registers to check for either SVE or streaming
> mode. When not in streaming mode the guest floating point state may be
> accessed via the V registers.
>
> Any VMM that supports SME must be aware of the need to configure streaming
> mode prior to writing the floating point registers that this creates.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/guest.c | 38 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 34 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 2a1fdcb0ec49..90dcacb35f01 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -73,6 +73,11 @@ static u64 core_reg_offset_from_id(u64 id)
>         return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
>  }
>
> +static bool vcpu_has_sve_regs(const struct kvm_vcpu *vcpu)
> +{
> +       return vcpu_has_sve(vcpu) || vcpu_in_streaming_mode(vcpu);
> +}
> +
>  static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>  {
>         int size;
> @@ -110,9 +115,10 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
>         /*
>          * The KVM_REG_ARM64_SVE regs must be used instead of
>          * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
> -        * SVE-enabled vcpus:
> +        * SVE-enabled vcpus or when a SME enabled vcpu is in
> +        * streaming mode:
>          */
> -       if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
> +       if (vcpu_has_sve_regs(vcpu) && core_reg_offset_is_vreg(off))
>                 return -EINVAL;
>
>         return size;
> @@ -426,6 +432,24 @@ struct vec_state_reg_region {
>         unsigned int upad;      /* extra trailing padding in user memory */
>  };
>
> +/*
> + * We represent the Z and P registers to userspace using either the
> + * SVE or SME vector length, depending on which features the guest has
> + * and if the guest is in streaming mode.
> + */
> +static unsigned int vcpu_sve_cur_vq(struct kvm_vcpu *vcpu)
> +{
> +       unsigned int vq = 0;
> +
> +       if (vcpu_has_sve(vcpu))
> +               vq = vcpu_sve_max_vq(vcpu);
> +
> +       if (vcpu_in_streaming_mode(vcpu))
> +               vq = vcpu_sme_max_vq(vcpu);
> +
> +       return vq;
> +}
> +
>  /*
>   * Validate SVE register ID and get sanitised bounds for user/kernel SVE
>   * register copy
> @@ -466,7 +490,7 @@ static int sve_reg_to_region(struct vec_state_reg_region *region,
>                 if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)

Should this be vcpu_has_sve_regs()? (zreg range)

>                         return -ENOENT;
>
> -               vq = vcpu_sve_max_vq(vcpu);
> +               vq = vcpu_sve_cur_vq(vcpu);
>
>                 reqoffset = SVE_SIG_ZREG_OFFSET(vq, reg_num) -
>                                 SVE_SIG_REGS_OFFSET;
> @@ -476,7 +500,7 @@ static int sve_reg_to_region(struct vec_state_reg_region *region,
>                 if (!vcpu_has_sve(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)

And should this also be vcpu_has_sve_regs()? (preg range)

Should you also handle FFR here, considering that in streaming mode
it's optional?

Cheers,
/fuad



>                         return -ENOENT;
>
> -               vq = vcpu_sve_max_vq(vcpu);
> +               vq = vcpu_sve_cur_vq(vcpu);
>
>                 reqoffset = SVE_SIG_PREG_OFFSET(vq, reg_num) -
>                                 SVE_SIG_REGS_OFFSET;
> @@ -515,6 +539,9 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         if (!kvm_arm_vcpu_vec_finalized(vcpu))
>                 return -EPERM;
>
> +       if (!vcpu_has_sve_regs(vcpu))
> +               return -EBUSY;
> +
>         if (copy_to_user(uptr, vcpu->arch.sve_state + region.koffset,
>                          region.klen) ||
>             clear_user(uptr + region.klen, region.upad))
> @@ -541,6 +568,9 @@ static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         if (!kvm_arm_vcpu_vec_finalized(vcpu))
>                 return -EPERM;
>
> +       if (!vcpu_has_sve_regs(vcpu))
> +               return -EBUSY;
> +
>         if (copy_from_user(vcpu->arch.sve_state + region.koffset, uptr,
>                            region.klen))
>                 return -EFAULT;
>
> --
> 2.47.3
>
