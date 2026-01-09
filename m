Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61F9329E79
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976286; cv=pass; b=oNRYYai8VAgvc+raeYXfnKbzPIsKcq7fQzGdTI8rwUZQsMqC6rraHkoL6w+Dvand0ZlXnhT510jMBl+uucErdxqmg0QO9pateg5Pv8eC/vqZD6a4mCnxOU/idM7soM6D6ZuuSgha87/Krs4zLvGr9kjRogrRD9z54FkrLAr7aBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976286; c=relaxed/simple;
	bh=TvYZA4dBSlsSpGSZUaKtQ+jUGYaXayrnDE16b2gj2N0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XTgXuwMlqRxmVRW+ONg75+j2mXX9/GSUOKmCmUPp8dZdKp2Ioo37fhCs+R0Deehj/ydxC5wxOKKESHKuILSkUJqT0aSa7gw3eN89MWE6cBXqDm5RIdgZoyhSkyr3iuHUXn7HGDbOee4IlcVdp7AF46Nevj92+1PJJDUvhYjgmS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LQZKFD5G; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LQZKFD5G"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4edb8d6e98aso600001cf.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 08:31:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767976284; cv=none;
        d=google.com; s=arc-20240605;
        b=X9FdLxnNDNFnf5JP1Vg/UOBeO6PmJujTNd2WeU2PdFEHRUfH30j/gvAM36mAmtGiC4
         A27fohPFHwcQV8iuxDOlOWd5sLI2nIOLm6dQ6e5y+e656EB82ctKMXz+WVNOQBW3+s4h
         ZUeor/Hf+8cQy7cO1txEPJbvQxEQgrprV1ffBnIDnRc7taDFH7SJqoRxGrWsBsDRpP/T
         UMmjGqQbOv4yPs8j1CWTjOS6Z31DaEcf5YPxs4SC+SqamF+NC3E41z89ot3Sbu0MJ9XO
         ZDqUAXAG6xL1hvSYY8953xEN5UHhczj5JSsXR8KjJD2oalf61Vh4FrSXv2gvsRobkzLw
         vKBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bOqelCfA+niHr585Q7gjhs1CWJtFJzsgDt10/9RfHhM=;
        fh=dyzUIx/UCED874XZ6ZJwKvltUSPYKzcy3HaeOnoHN3k=;
        b=fZFf3VqfmqzRKjCdLc/UvvTaZEQxHZQV/EVB/LgzsLBMURlaNbv7sMzqMvcw7G2tjJ
         dwfP8tCJxrPMynDnreJ8oQ1o1USGkv+7b/3p8Y9dduTb16u8fjEOIPTE4jQGOjcA7iWM
         ICL9ICZ/VXSV1ztWdDgY68X01fqt8TZ/q1nA0NHjkUkSQzkFayZJOYdk5YrH8GrbD+G2
         GJbBfSUb+uEzClbb/l2tZdAxdAzNeRr5l/i59t0XLJA96gP0QXka7M6eEglSxZNi5Ak8
         69KNZX8gJXbyhIFyzAmf8nWWGtzkSi8jXLKzHIgv0yE2spq+uryMoDO/+NdDr/C/WsB5
         fwZw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767976284; x=1768581084; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bOqelCfA+niHr585Q7gjhs1CWJtFJzsgDt10/9RfHhM=;
        b=LQZKFD5GLQGtW/b9lUYAufF95OsRu4zGIEGBTGO+6XNUQ3eqY8XBVSyuY80Lwbedu/
         s32yPDIpvaqQKV0WbPeZu2fp988ogxGJcQ70sSg6i/dEkeP6MT35HvMiJnC/I+0mtAJu
         QUjFiICCHX/xBDWCw2mgSoqWMvU6ES49E8l64yQBZ44WIDHS11vjlzMDNKh8SKJskK7G
         HMgdbllFLof14bTv+XyNUnpon15zKapyrRYwxH3BC7k09h9alLRYqS27RyiY5xFytiSA
         IjpSsVWqAnUqbPMQs5veFwZj1WbM2tLp9DTWNcXyPKRW2RKHPYhR0XqCP8KTcshnPb2s
         VnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976284; x=1768581084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOqelCfA+niHr585Q7gjhs1CWJtFJzsgDt10/9RfHhM=;
        b=YhRJtPG9xMrajs9XCXuTL9LuryEYjVT7qB1SRkjOxJxIccjDGgxP8PnLj5MxGhvp1x
         HHlWd0I2mWwJrJ+MFd7w3TMog/c/EyD6g2Q3HTCOaNN8oduC14YqoyhYkWZ530W1g7nG
         LSwPJoHGKf7LQigixp0VrV01orb4ClgSHOoCItX038Y/TaKODRcH2oh85BOf9dQsFkoX
         bkl3m54pCi+kSt+7wnMfHBbdED4pMVbZaNCi+m2OxDmdDuM6Q7Js90xgMyAu1q7qozuQ
         SyUMnuRq9cC7Ywhciwgbv//kKRt9f6+ILI8YqwkJWqEHA1b+nlHsRagTLXfz3tZKkzPK
         Zg0w==
X-Forwarded-Encrypted: i=1; AJvYcCWCjcGRCa0iWfmavC9u3CsM4zZ2lWyuJ+xY2Q3N32kgkFrQmSiMczwgnBrV7pvk8tu20OcvrUA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yze2hUr4RsYuiKrnRkc6/8wYD7/6z6/b0lfRsuDL3V6gXK3Ai2Y
	oYAUC72MVhw85PounYI5lfbCAJNFdkO7oinLeeZantvQ0KdnO8uv1WY/lVHrfLiG2htFCfTlW8l
	TYMM84+6Hieq5a/Ndxk1srrsmMQ3x6syAzMagIYSr
X-Gm-Gg: AY/fxX5YmtNOump+31Rwmr83F5nv7hF7dwY3BcwEeuGYH9Pvp0fP7wN/5vEKdHFi3re
	XoWO9yhoFvjh8SHgWFV5AsjFrH2DmDvq7K2nu+5Dh+zqNsWW20N8Zra7AdZV3mVgU9l+DOVvcWV
	92Eq/18pmNjMTRrQmLNXelvMps44uHhX0p9jM6ZcNWlZI+NSpLajpoXYmECiaMMOKBJkPaDs8Mj
	VXIeKWiofPVudt0oWtmenjLOGmo+DAO4Bnn+YCLMGWOcUJdTZ1IQN2ncWtMksuLgXnx84bd
X-Received: by 2002:ac8:5d8d:0:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-4ffca3899e0mr12373901cf.10.1767976283510; Fri, 09 Jan 2026
 08:31:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-15-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-15-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Jan 2026 16:31:00 +0000
X-Gm-Features: AZwV_Qg_Mx3Uve2Ajz9vtAn4ZY1Okl_E_qqP5nAl07n9Fwy2xIITsZXnkaSndwU
Message-ID: <CA+EHjTzP9roJNcHhVrcGm9RMAn0E+RGPkJ57w44OL4fy3EW-wA@mail.gmail.com>
Subject: Re: [PATCH v9 15/30] KVM: arm64: Support SME control registers
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
> SME is configured by the system registers SMCR_EL1 and SMCR_EL2, add
> definitions and userspace access for them.  These control the SME vector
> length in a manner similar to that for SVE and also have feature enable
> bits for SME2 and FA64.  A subsequent patch will add management of them
> for guests as part of the general floating point context switch, as is
> done for the equivalent SVE registers.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h     |  2 ++
>  arch/arm64/include/asm/vncr_mapping.h |  1 +
>  arch/arm64/kvm/sys_regs.c             | 36 ++++++++++++++++++++++++++++++++++-
>  3 files changed, 38 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index b41700df3ce9..f24441244a68 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -504,6 +504,7 @@ enum vcpu_sysreg {
>         CPTR_EL2,       /* Architectural Feature Trap Register (EL2) */
>         HACR_EL2,       /* Hypervisor Auxiliary Control Register */
>         ZCR_EL2,        /* SVE Control Register (EL2) */
> +       SMCR_EL2,       /* SME Control Register (EL2) */
>         TTBR0_EL2,      /* Translation Table Base Register 0 (EL2) */
>         TTBR1_EL2,      /* Translation Table Base Register 1 (EL2) */
>         TCR_EL2,        /* Translation Control Register (EL2) */
> @@ -542,6 +543,7 @@ enum vcpu_sysreg {
>         VNCR(ACTLR_EL1),/* Auxiliary Control Register */
>         VNCR(CPACR_EL1),/* Coprocessor Access Control */
>         VNCR(ZCR_EL1),  /* SVE Control */
> +       VNCR(SMCR_EL1), /* SME Control */
>         VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
>         VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
>         VNCR(TCR_EL1),  /* Translation Control Register */
> diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
> index c2485a862e69..44b12565321b 100644
> --- a/arch/arm64/include/asm/vncr_mapping.h
> +++ b/arch/arm64/include/asm/vncr_mapping.h
> @@ -44,6 +44,7 @@
>  #define VNCR_HDFGWTR_EL2       0x1D8
>  #define VNCR_ZCR_EL1            0x1E0
>  #define VNCR_HAFGRTR_EL2       0x1E8
> +#define VNCR_SMCR_EL1          0x1F0
>  #define VNCR_TTBR0_EL1          0x200
>  #define VNCR_TTBR1_EL1          0x210
>  #define VNCR_FAR_EL1            0x220
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3576e69468db..5c912139d264 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2827,6 +2827,37 @@ static bool access_gic_elrsr(struct kvm_vcpu *vcpu,
>         return true;
>  }
>
> +static unsigned int sme_el2_visibility(const struct kvm_vcpu *vcpu,
> +                                      const struct sys_reg_desc *rd)
> +{
> +       return __el2_visibility(vcpu, rd, sme_visibility);
> +}
> +
> +static bool access_smcr_el2(struct kvm_vcpu *vcpu,
> +                           struct sys_reg_params *p,
> +                           const struct sys_reg_desc *r)
> +{
> +       unsigned int vq;
> +       u64 smcr;
> +
> +       if (guest_hyp_sve_traps_enabled(vcpu)) {

Should this be guest_hyp_sme_traps_enabled() ?

> +               kvm_inject_nested_sve_trap(vcpu);

And by the same token, should this be kvm_inject_nested_sme_trap()?
That function doesn't exist, but would inject ESR_ELx_EC_SME instead
of ESR_ELx_EC_SVE.

> +               return false;
> +       }
> +
> +       if (!p->is_write) {
> +               p->regval = __vcpu_sys_reg(vcpu, SMCR_EL2);
> +               return true;
> +       }
> +
> +       smcr = p->regval;
> +       vq = SYS_FIELD_GET(SMCR_ELx, LEN, smcr) + 1;
> +       vq = min(vq, vcpu_sme_max_vq(vcpu));
> +       __vcpu_assign_sys_reg(vcpu, SMCR_EL2, SYS_FIELD_PREP(SMCR_ELx, LEN,
> +                                                            vq - 1));

I think this might be wrong. This code only writes the LEN, discarding
other fields in SMCR_EL2. The analogous SVE code in access_zcr_el2()
is only concerned with the length, and doesn't need to worry about
other bits to preserve.

Should this be something along the lines of the below instead?

+       smcr = p->regval;
+       vq = SYS_FIELD_GET(SMCR_ELx, LEN, smcr) + 1;
+       vq = min(vq, vcpu_sme_max_vq(vcpu));
+       smcr &= ~SMCR_ELx_LEN_MASK;
+       smcr |= SYS_FIELD_PREP(SMCR_ELx, LEN, vq - 1);
+       __vcpu_assign_sys_reg(vcpu, SMCR_EL2, smcr);

Cheers,
/fuad




> +       return true;
> +}
> +
>  static unsigned int s1poe_visibility(const struct kvm_vcpu *vcpu,
>                                      const struct sys_reg_desc *rd)
>  {
> @@ -3291,7 +3322,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>         { SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
>         { SYS_DESC(SYS_TRFCR_EL1), undef_access },
>         { SYS_DESC(SYS_SMPRI_EL1), undef_access },
> -       { SYS_DESC(SYS_SMCR_EL1), undef_access },
> +       { SYS_DESC(SYS_SMCR_EL1), NULL, reset_val, SMCR_EL1, 0, .visibility = sme_visibility },
>         { SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
>         { SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
>         { SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
> @@ -3655,6 +3686,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>
>         EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
>
> +       EL2_REG_FILTERED(SMCR_EL2, access_smcr_el2, reset_val, 0,
> +                        sme_el2_visibility),
> +
>         EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
>         EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
>         EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
>
> --
> 2.47.3
>
