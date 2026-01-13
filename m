Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7094346AFC
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768313253; cv=pass; b=LaFkffjEbmUEIaDExhsva0+sIbfd9dQ/CFUZPASW9+A+HAFmMK/4sdagj9OG4KHGLa2A4C2R437IXLZmznd49Z6TtWNaqAlRvEf3JVYPCPH2PHQA0fq6dCJ0/VYZkx0ZpfqBcGUofb9pUHpcQ0cgOazbwTh+gJHdLnp9OJWUEVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768313253; c=relaxed/simple;
	bh=W1BKHG2W0/GlQ7ZY8QiX4cI5B6CXeKtQHFJwinuKji4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HeMmMoJOPLodIjcj9jbaq0XsSi2YuaYaW/fZesZLBDWyI4R1Vz2XNvphshXfzbnKfBg4b2ieMZNF6OXU8gcoxtNk/ZAxM6uHIr8YVVfT3AbZVbWQF8tPj9X1DhvVqL+sDs4rU50cqFuoOZZLD08WbizjqJkIYBj7+50Rmp/7WNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eH9++EIY; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eH9++EIY"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee147baf7bso311191cf.1
        for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 06:07:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768313251; cv=none;
        d=google.com; s=arc-20240605;
        b=ir/O8KAaa0DfAPQC5uZxz8ODVpwtBrNPdYSpl9NffNnAsN/t3pft4YABuTdS8Mi170
         xvzia7gEqRN37H2YGnUR9HQ/YJBbAN2VDY2/rHKSAHJheGhLaiJIxL3xqMCBVE7QAXO3
         ITjFoSjYE/HaZSG188K1yms4mWIvlbE9NbckrHtaG/8LnpB3TVkWpHFbMcQ0vxgkaiLN
         FtbpU5YPzJ3hgJr79nj5viwb5SxjExXadMKJH/rQFU0JMcN5ivSoRSwCvSa0DjArYtWt
         KkdWQHKUUFFEmM7kv/AUQkIx3vOoq1ytHBxWuolDHLISvuBIMP/nyXHnd0+S/3NTp8H0
         lI5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vGNeqZdCFRkUH8pVy9i0xdJ5BW3N5lXnZA/HlFDK8XQ=;
        fh=1T8lrYczzvIZdXZvxCz2ghiv+BhDNmadlaA7SCBIXXs=;
        b=UR3OVxGkcwEmLMp75LnCscJ7nreFJzB81wzPifIghyedR4As/73xfh9x/SlFoIUs6G
         EuT0jabrqjg9ZvDIxW5dGx1X2F3MlHJRTb34d88qVHXRDPD1B3HzHvqS8i3/Hht6FfEw
         MaLoFNN5vkSXeBHyDaDf59ZTyPxIZP2d3Cf8dlUFmsw0AHpenVNvDQ+8phSHLj9ZJJSc
         2bDzFBuXUKUkKi4jdrzOvTr9AFClxE2p5700sqVcIzd9aSkLke8Pu04lYaqPZsVK3vbR
         5pyyBIdVvgFWNSzm/TfG/SFtg1IvmDVYBlHwY4ozfTZJGTJudK8tVp/vrqpd/qNRfPZO
         gzdA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768313251; x=1768918051; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vGNeqZdCFRkUH8pVy9i0xdJ5BW3N5lXnZA/HlFDK8XQ=;
        b=eH9++EIYFvlHoC3v7w6z3eOYmNx9XQpjVA0hFWJOM8kLTbcETPrzqggh7eJBgMR285
         MrqxjMfBXaoNDTmP07bQ+WR0IpOAb7UcLW/+9Hj2e7cRDCBHg2+C5rxGkzFw8ckJt1sG
         P6AU63rc++bPcpwmyJWRY5spqQR8JjctF7UhkQ/TrtOwubI5912K2RALik0gqd2Qk8XP
         06dIzoSVb1wwundBv59ErWrfRMIVITacW/TzL7jZTB40JkuXm9aqRijS0ybCUiQr9+n2
         PcKaTHF2O11sYLLRJVky2jSWV6S5n0w02QL0Dq2CVxESYtQ6fcCZUdk0P+F9z9hPiQVV
         qUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768313251; x=1768918051;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vGNeqZdCFRkUH8pVy9i0xdJ5BW3N5lXnZA/HlFDK8XQ=;
        b=VUlx4SrQZQLKRB1bUBrZpxYfF9kXtdaWADOJuUNqMu6TQJXiTRQA4Ijq7CAgQViWiW
         elrhiO+htRVozamPOhNDfYzFrDY/8JgPhW41/a3014g3TYEvcQyVbR5Pg9H4Zatmgnjt
         rZVjEKd6/gPLlLc/+N3JGp5QvXu7xnD17ZJaMxliq9EpSj7wrlDAznUgFwL7Li6MB+sU
         IL2HxXh7gPL1Mk3JEHnmYXNhl7whK1KHRidNa/QsB1qCRNyBuO2Y7/LsDp4Av7CWyQj/
         YkS+l2oXJ4sjBt4RzDyaNPVrjMhJJaOALxbbjQbRGU8Anw3bItTZXD/Jxnalf2Gtg4v5
         5+bg==
X-Forwarded-Encrypted: i=1; AJvYcCVf0zTRQ3wNO0p+edXyO2sv/qOJv+m/9YyRWzQqT6X1c46bGuZMJ6CxkwaCzwYLxsE4MqXSZWU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRnSSLGTu2/uBCo3ZhryHWC/7hhUFgKyMScFnPfvgMf7WPuLmi
	7lD9sNiKCJ51Etbxpd46cFjqZ1NeFeXOitEhS4VWstL7lbLTb6xbWbyM5G0LAvd+FLAwT/m170/
	lmaVRjhBvT6OnI0Xf9rOtRh7pbiTGQO1ZnZaTu2NL
X-Gm-Gg: AY/fxX4jqTprxdZowKyhAc+Wfm1jl3ip2y210zepD6WP8hKI7M4dt8GtlEa9ZPudJ3X
	5vOJq93+dHqjEnc5DP/FlcfnRD3eQ+04Oq8FwsGJPjY8VZQYJ6i6Q6eeYxrViavhu306Jy0JPi9
	LBchVXkYXfBZt9P67pjag0QazjbDfmu9fgpWdjv1hGMFLDFT1QHXjqk1FIGEzl8+UzJtCe8N3OZ
	s1xARWXCieoLCqmtalAdurDXhr/Mc/YEt+xcFxuIzw0/xC9Ec2/YTTKGBSKKUbXdh/T7gywB9uO
	WiemolW6wTgkr3MHRCnH3ewUJA==
X-Received: by 2002:ac8:7fc1:0:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-5013af6a711mr9755261cf.1.1768313250350; Tue, 13 Jan 2026
 06:07:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-22-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-22-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 13 Jan 2026 14:06:53 +0000
X-Gm-Features: AZwV_QhU40Lwhaq_0NHueSMC3WoVnp6Uc6Xt-liPmw7nnlV9MFwsJtQrpboZVDo
Message-ID: <CA+EHjTwMy1crsZLqfy8_Y56NFPJZ7vGyN-egc433GhxB_n=7aA@mail.gmail.com>
Subject: Re: [PATCH v9 22/30] KVM: arm64: Expose SME specific state to userspace
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
> SME introduces two new registers, the ZA matrix register and the ZT0 LUT
> register.  Both of these registers are only accessible when PSTATE.ZA is
> set and ZT0 is only present if SME2 is enabled for the guest. Provide
> support for configuring these from VMMs.
>
> The ZA matrix is a single SVL*SVL register which is available when
> PSTATE.ZA is set. We follow the pattern established by the architecture
> itself and expose this to userspace as a series of horizontal SVE vectors
> with the streaming mode vector length, using the format already established
> for the SVE vectors themselves.
>
> ZT0 is a single register with a refreshingly fixed size 512 bit register
> which is like ZA accessible only when PSTATE.ZA is set. Add support for it
> to the userspace API, as with ZA we allow the register to be read or written
> regardless of the state of PSTATE.ZA in order to simplify userspace usage.
> The value will be reset to 0 whenever PSTATE.ZA changes from 0 to 1,
> userspace can read stale values but these are not observable by the guest
> without manipulation of PSTATE.ZA by userspace.
>
> While there is currently only one ZT register the naming as ZT0 and the
> instruction encoding clearly leave room for future extensions adding more
> ZT registers. This encoding can readily support such an extension if one is
> introduced.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/uapi/asm/kvm.h |  17 ++++++
>  arch/arm64/kvm/guest.c            | 114 +++++++++++++++++++++++++++++++++++++-
>  2 files changed, 129 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 498a49a61487..9a19cc58d227 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -357,6 +357,23 @@ struct kvm_arm_counter_offset {
>  /* SME registers */
>  #define KVM_REG_ARM64_SME              (0x17 << KVM_REG_ARM_COPROC_SHIFT)
>
> +#define KVM_ARM64_SME_VQ_MIN __SVE_VQ_MIN
> +#define KVM_ARM64_SME_VQ_MAX __SVE_VQ_MAX
> +
> +/* ZA and ZTn occupy blocks at the following offsets within this range: */
> +#define KVM_REG_ARM64_SME_ZA_BASE      0
> +#define KVM_REG_ARM64_SME_ZT_BASE      0x600
> +
> +#define KVM_ARM64_SME_MAX_ZAHREG       (__SVE_VQ_BYTES * KVM_ARM64_SME_VQ_MAX)
> +
> +#define KVM_REG_ARM64_SME_ZAHREG(n, i)                                 \
> +       (KVM_REG_ARM64 | KVM_REG_ARM64_SME | KVM_REG_ARM64_SME_ZA_BASE | \
> +        KVM_REG_SIZE_U2048 |                                           \
> +        (((n) & (KVM_ARM64_SME_MAX_ZAHREG - 1)) << 5) |                \
> +        ((i) & (KVM_ARM64_SVE_MAX_SLICES - 1)))
> +
> +#define KVM_REG_ARM64_SME_ZTREG_SIZE   (512 / 8)
> +
>  /* Vector lengths pseudo-register: */
>  #define KVM_REG_ARM64_SME_VLS          (KVM_REG_ARM64 | KVM_REG_ARM64_SME | \
>                                          KVM_REG_SIZE_U512 | 0xfffe)
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 90dcacb35f01..d4e30eb57a9c 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -594,23 +594,133 @@ static int set_sme_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>         return set_vec_vls(ARM64_VEC_SME, vcpu, reg);
>  }
>
> +/*
> + * Validate SVE register ID and get sanitised bounds for user/kernel SVE
> + * register copy
> + */
> +static int sme_reg_to_region(struct vec_state_reg_region *region,
> +                            struct kvm_vcpu *vcpu,
> +                            const struct kvm_one_reg *reg)
> +{
> +       /* reg ID ranges for ZA.H[n] registers */
> +       unsigned int vq = vcpu_sme_max_vq(vcpu) - 1;
> +       const u64 za_h_max = vq * __SVE_VQ_BYTES;
> +       const u64 zah_id_min = KVM_REG_ARM64_SME_ZAHREG(0, 0);
> +       const u64 zah_id_max = KVM_REG_ARM64_SME_ZAHREG(za_h_max - 1,
> +                                                      SVE_NUM_SLICES - 1);
> +       unsigned int reg_num;
> +
> +       unsigned int reqoffset, reqlen; /* User-requested offset and length */
> +       unsigned int maxlen; /* Maximum permitted length */
> +
> +       size_t sme_state_size;
> +
> +       reg_num = (reg->id & SVE_REG_ID_MASK) >> SVE_REG_ID_SHIFT;

You use array_index_nospec() below for koffset, but it might be worth
using it for intermediate values, such as this one.

> +
> +       if (reg->id >= zah_id_min && reg->id <= zah_id_max) {
> +               if (!vcpu_has_sme(vcpu) || (reg->id & SVE_REG_SLICE_MASK) > 0)
> +                       return -ENOENT;
> +
> +               /* ZA is exposed as SVE vectors ZA.H[n] */
> +               reqoffset = ZA_SIG_ZAV_OFFSET(vq, reg_num) -
> +                       ZA_SIG_REGS_OFFSET;
> +               reqlen = KVM_SVE_ZREG_SIZE;
> +               maxlen = SVE_SIG_ZREG_SIZE(vq);
> +       } else if (reg->id == KVM_REG_ARM64_SME_ZT_BASE) {
> +               /* ZA is exposed as SVE vectors ZA.H[n] */
> +               if (!kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, SME2) ||
> +                   (reg->id & SVE_REG_SLICE_MASK) > 0 ||
> +                   reg_num > 0)
> +                       return -ENOENT;
> +
> +               /* ZT0 is stored after ZA */
> +               reqlen = KVM_REG_ARM64_SME_ZTREG_SIZE;
> +               maxlen = KVM_REG_ARM64_SME_ZTREG_SIZE;
> +       } else {
> +               return -EINVAL;
> +       }
> +
> +       sme_state_size = vcpu_sme_state_size(vcpu);

Is it worth caching this value and storing it in arch, since the state
size doesn't change after finalization?

> +       if (WARN_ON(!sme_state_size))
> +               return -EINVAL;
> +
> +       region->koffset = array_index_nospec(reqoffset, sme_state_size);
> +       region->klen = min(maxlen, reqlen);
> +       region->upad = reqlen - region->klen;
> +
> +       return 0;
> +}
> +
> +/*
> + * ZA is exposed as an array of horizontal vectors with the same
> + * format as SVE, mirroring the architecture's LDR ZA[Wv, offs], [Xn]
> + * instruction.
> + */
> +
>  static int get_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> +       int ret;
> +       struct vec_state_reg_region region;
> +       char __user *uptr = (char __user *)reg->addr;
> +
>         /* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
>         if (reg->id == KVM_REG_ARM64_SME_VLS)
>                 return get_sme_vls(vcpu, reg);
>
> -       return -EINVAL;
> +       /* Try to interpret reg ID as an architectural SME register... */
> +       ret = sme_reg_to_region(&region, vcpu, reg);
> +       if (ret)
> +               return ret;
> +
> +       if (!kvm_arm_vcpu_vec_finalized(vcpu))
> +               return -EPERM;
> +
> +       /*
> +        * None of the SME specific registers are accessible unless
> +        * PSTATE.ZA is set.
> +        */
> +       if (!vcpu_za_enabled(vcpu))
> +               return -EINVAL;

I think this should be something other than -EINVAL, since the issue
isn't that the register isn't valid, but that it's inaccessible, as
the comment says. -EACCESS or something?

> +
> +       if (copy_from_user(vcpu->arch.sme_state + region.koffset, uptr,
> +                          region.klen))
> +               return -EFAULT;

This should be copy_to_user()

> +
> +       return 0;
>  }
>
>  static int set_sme_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
> +       int ret;
> +       struct vec_state_reg_region region;
> +       char __user *uptr = (char __user *)reg->addr;
> +
>         /* Handle the KVM_REG_ARM64_SME_VLS pseudo-reg as a special case: */
>         if (reg->id == KVM_REG_ARM64_SME_VLS)
>                 return set_sme_vls(vcpu, reg);
>
> -       return -EINVAL;
> +       /* Try to interpret reg ID as an architectural SME register... */
> +       ret = sme_reg_to_region(&region, vcpu, reg);
> +       if (ret)
> +               return ret;
> +
> +       if (!kvm_arm_vcpu_vec_finalized(vcpu))
> +               return -EPERM;
> +
> +       /*
> +        * None of the SME specific registers are accessible unless
> +        * PSTATE.ZA is set.
> +        */
> +       if (!vcpu_za_enabled(vcpu))
> +               return -EINVAL;

Same as get_sme_reg().

Cheers,
/fuad



> +
> +       if (copy_from_user(vcpu->arch.sme_state + region.koffset, uptr,
> +                          region.klen))
> +               return -EFAULT;
> +
> +       return 0;
>  }
> +
>  int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  {
>         return -EINVAL;
>
> --
> 2.47.3
>
