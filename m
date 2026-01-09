Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C178311949
	for <kvmarm@lists.linux.dev>; Fri,  9 Jan 2026 16:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976182; cv=none; b=DyZ1W/5KnlluyeJil4FATZnGxVkxwR/EBpcgQMCsAj2SRFtm69+VW+yI/DI5V4Pv039mu4LmZa1dgBsXbEWahS6Hjl8XKeHbytfy4DQ7Crf0KSjrolq/w6S0k2Q8P3txg4aS9Fl2fE37R2yTVX9AA7VwCQ+9MmaAD3kjB/x3LKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976182; c=relaxed/simple;
	bh=v8qIYmR4iEhmIiuuMJH2tKPP2xdFZeAFkV6M1sYI7KU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ny75YLRugIbgHSd3APZx2YqX0R44TJIuHzjGV/9ekpBTTOPi0wTcH035E1WC2SGD+HP4PEHnQp33SQPyOAdt4pRB0Tel7ero9SoE/AHtlZ6toa1U3VIOnIys/px3/WNc3d2X7Wb/qejKoJ4D1Bdrj927oGZTOz+raGfwcJ/hUpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FNkZulPJ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FNkZulPJ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso36342205e9.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jan 2026 08:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767976179; x=1768580979; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Av9QrHeVLN0xEzdviPuqhkrVJd267kJMrNhHLNRrzA=;
        b=FNkZulPJ6pKG5T/zh85k+h04GohW4eqbTxMwBEaOuVZrOrHkLKrpolI44gLV9SDabd
         PRHg40cxr3YRKqajp6qpN/PV/L1dwzh76FGr2vKyOElVmlUWm5BtsGcznlZFO3f4HXCF
         qYDzuRz+LUz4e0BVdODTXOsyu9BXYDp7nMZIHdOMZ0w6hyKYq+CYqqxTGckWCzJbudj5
         ph7JKd7BCmz87KjjZpXUAqMXJf9IlTC1DiB3N2XVMHixOPJ4oW1BOCgqY/QV59qDLio7
         McIC/rC+NCuLdwgfViBoqBPnypLR7dnXRWGbgg7Svu/itBvEnGr2DNSMkaqK8hcZV8Cj
         rTDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767976179; x=1768580979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Av9QrHeVLN0xEzdviPuqhkrVJd267kJMrNhHLNRrzA=;
        b=Iktm/1Us+sh9rtbnMcXXqWLKEkknFCQZB8tn8pZfJ14pTgBQkFEM8WVbTbG1JUcPHv
         qg+9Ezwz0oF4y5TTIe3rG0v+E/zftfb8IpuOm40rUj7UDdlyaMpJOF916yD3Olix5sbH
         et8agBCT6Y6NeOipEsTeO7nR5c/nKM28u2E5VG6VCmSp+twnwwLSY+LFnwBFf0vo2IFu
         30adMedVBDnTbXbN/rT/mgkzD5/f2bZHzp5hvRNiwxkEl0DaPz9ZSVTFgMPf/ZSxCJYH
         lCXMlEeLPivWh28FBTZ4nhymZd7j+hgzqkrxud2TPPiunQFcU/fHSawQmbVGmFtFIlt7
         PExA==
X-Forwarded-Encrypted: i=1; AJvYcCUYOL00kGbykHTl0ve8oFVG4A56X1BaSpZxNRU1EcgA3eUPa150YZUBHTq1o8CYiqPhtijpYhg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyW0wyQgW3leL0U04HK3rqjehtap5rtFOfuogDuCXxxZ2jM5G2f
	mlqu4rsx392L0rtSYwUK+d8U62BkZF60iBEt8E2aWc7V6524p4fBHrsiR8YCwu6aRic=
X-Gm-Gg: AY/fxX7MhtKkaOe/1TNNhJtAe9EbrPrF52ouyLROb7nTAY4heULdGX+q58L5y8gADTP
	SsstBymi9xlQzdkO3TTdm24mDScek652XFC+Qr8ppHaNShxd33cP7RZxfBEghUv9IfM2Mbsty0e
	23yf2T2C+bM0VpkwpoFiGp43dr6b8l0U0Db9wiomaBFmC9vBbtrVOZwZeFydBjuBPP8xKd3Bpp2
	V9iIuVbIhadw9TIDpnecCKGfT3U7ceMF+/kcJvoLUXTEn2VOhSJbIka5p+21o0sR1/+E2wndt3J
	F2CotPwnGeaJqFME8FHVPnZmZDfOP+A76PvlBkaQu7fHAKkQHCgOPhGjRmyyVvJ+oPEnTaG50/W
	KEuNkYGYp1JAWXy3CU27tm6I6i2S5CVowe1jyEqs5ZthurH+DvPVB3b/6afAxbD/oVTW8+HpZ7R
	NuBFzCS4DKoFDEVAHC
X-Google-Smtp-Source: AGHT+IHlxXBTc8kcCppX7neDfDLqk6DNHOUQ5JMaSuR5ew7p0+7D3jKYSaHYHZVPW0MOT9coV8wMow==
X-Received: by 2002:a05:600c:3b28:b0:471:13fa:1b84 with SMTP id 5b1f17b1804b1-47d84b1868amr120818095e9.12.1767976178721;
        Fri, 09 Jan 2026 08:29:38 -0800 (PST)
Received: from [192.168.1.3] ([185.48.77.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f703a8csm213675025e9.13.2026.01.09.08.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 08:29:38 -0800 (PST)
Message-ID: <f7d73dc3-aa4a-4c32-aabb-21a61a2f773f@linaro.org>
Date: Fri, 9 Jan 2026 16:29:37 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 19/35] KVM: arm64: Trap PMBIDR_EL1 and PMSIDR_EL1
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com, james.morse@arm.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
 <20251114160717.163230-20-alexandru.elisei@arm.com>
Content-Language: en-US
From: James Clark <james.clark@linaro.org>
In-Reply-To: <20251114160717.163230-20-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 14/11/2025 4:07 pm, Alexandru Elisei wrote:
> PMBIDR_EL1 and PMSIDR_EL1 are read-only registers that describe the SPE
> implementation. Trap reads to allow KVM to control how SPE is described to
> a virtual machine. In particular, this is needed to:
> 
> - Advertise the maximum buffer size set by userspace in
>    PMBIDR_EL1.MaxBuffSize.
> - Hide in PMSIDR_EL1, if necessary, the presence of FEAT_SPE_FDS and
>    FEAT_SPE_FnE, both of which add new registers which are already
>    trapped via the FGU mechanism.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>   arch/arm64/include/asm/kvm_spe.h |  4 +-
>   arch/arm64/kvm/config.c          | 13 ++++-
>   arch/arm64/kvm/spe.c             | 82 +++++++++++++++++++++++++++++++-
>   arch/arm64/kvm/sys_regs.c        | 13 +++--
>   4 files changed, 103 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 3506d8c4c661..47b94794cc5f 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -40,7 +40,7 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   
>   bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
> -u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
> +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding);
>   #else
>   struct kvm_spe {
>   };
> @@ -78,7 +78,7 @@ static inline bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>   {
>   	return true;
>   }
> -static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
> +static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding)
>   {
>   	return 0;
>   }
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 24bb3f36e9d5..ed6b167b7aa8 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -6,6 +6,7 @@
>   
>   #include <linux/kvm_host.h>
>   #include <asm/kvm_emulate.h>
> +#include <asm/kvm_spe.h>
>   #include <asm/kvm_nested.h>
>   #include <asm/sysreg.h>
>   
> @@ -1489,6 +1490,16 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
>   		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
>   }
>   
> +static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
> +{
> +	__compute_fgt(vcpu, HDFGRTR_EL2);
> +
> +	if (vcpu_has_spe(vcpu)) {
> +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMBIDR_EL1;
> +		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= HDFGRTR_EL2_PMSIDR_EL1;
> +	}
> +}
> +
>   static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
>   {
>   	__compute_fgt(vcpu, HDFGWTR_EL2);
> @@ -1505,7 +1516,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>   	__compute_fgt(vcpu, HFGRTR_EL2);
>   	__compute_hfgwtr(vcpu);
>   	__compute_fgt(vcpu, HFGITR_EL2);
> -	__compute_fgt(vcpu, HDFGRTR_EL2);
> +	__compute_hdfgrtr(vcpu);
>   	__compute_hdfgwtr(vcpu);
>   	__compute_fgt(vcpu, HAFGRTR_EL2);
>   
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 5b3dc622cf82..92eb46276c71 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -22,10 +22,16 @@ struct arm_spu_entry {
>   	struct arm_spe_pmu *arm_spu;
>   };
>   
> +static u64 max_buffer_size_to_pmbidr_el1(u64 size);
> +
>   void kvm_host_spe_init(struct arm_spe_pmu *arm_spu)
>   {
>   	struct arm_spu_entry *entry;
>   
> +	/* PMBIDR_EL1 cannot be trapped without FEAT_FGT. */
> +	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> +		return;
> +

Isn't this only required if you want to report a different PMBIDR value? 
If the value in hardware is already what you want to give to guests then 
it's not strictly required. Maybe it's something we can do as an 
addition later to make it usable in more places.

>   	/* TODO: pKVM and nVHE support */
>   	if (is_protected_kvm_enabled() || !has_vhe())
>   		return;
> @@ -86,9 +92,81 @@ bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>   	return true;
>   }
>   
> -u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
> +static bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
> +{
> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.arm_spu;
> +
> +	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
> +	       FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
> +}
> +
> +static bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
> +{
> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.arm_spu;
> +
> +	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
> +	       FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
> +}
> +
> +static u64 kvm_spe_get_pmsidr_el1(struct kvm_vcpu *vcpu)
>   {
> -	return __vcpu_sys_reg(vcpu, reg);
> +	struct kvm *kvm = vcpu->kvm;
> +	u64 pmsidr = kvm->arch.kvm_spe.arm_spu->pmsidr_el1;
> +
> +	/* Filter out known RES0 bits. */
> +	pmsidr &= ~GENMASK_ULL(63, 33);
> +
> +	if (!kvm_spe_has_feat_spe_fne(kvm))
> +		pmsidr &= ~PMSIDR_EL1_FnE;
> +
> +	if (!kvm_spe_has_feat_spe_fds(kvm))
> +		pmsidr &= ~PMSIDR_EL1_FDS;
> +
> +	return pmsidr;
> +}
> +
> +static u64 kvm_spe_get_pmbidr_el1(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
> +	u64 max_buffer_size = kvm_spe->max_buffer_size;
> +	u64 pmbidr_el1 = kvm_spe->arm_spu->pmbidr_el1;
> +
> +	/* Filter out known RES0 bits. */
> +	pmbidr_el1 &= ~(GENMASK_ULL(63, 48) | GENMASK_ULL(31, 12));
> +
> +	if (!kvm_has_feat(kvm, ID_AA64DFR2_EL1, SPE_nVM, IMP)) {
> +		pmbidr_el1 &= ~PMBIDR_EL1_AddrMode;
> +		pmbidr_el1 |= PMBIDR_EL1_AddrMode_VM_ONLY;
> +	}
> +
> +	pmbidr_el1 &= ~PMBIDR_EL1_MaxBuffSize;
> +	pmbidr_el1 |= max_buffer_size_to_pmbidr_el1(max_buffer_size);
> +
> +	return pmbidr_el1;
> +}
> +
> +u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg, u32 encoding)
> +{
> +	u64 val = 0;
> +
> +	switch (encoding) {
> +	case SYS_PMBIDR_EL1:
> +		val = kvm_spe_get_pmbidr_el1(vcpu);
> +		break;
> +	case SYS_PMSIDR_EL1:
> +		val = kvm_spe_get_pmsidr_el1(vcpu);
> +		break;
> +	case SYS_PMBLIMITR_EL1:
> +	case SYS_PMBPTR_EL1:
> +	case SYS_PMBSR_EL1:
> +		val = __vcpu_sys_reg(vcpu, reg);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +	}
> +
> +	return val;
>   }
>   
>   static u64 max_buffer_size_to_pmbidr_el1(u64 size)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5eeea229b46e..db86d1dcd148 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1386,13 +1386,18 @@ static unsigned int spe_visibility(const struct kvm_vcpu *vcpu,
>   static bool access_spe_reg(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   			   const struct sys_reg_desc *r)
>   {
> +	u32 encoding = reg_to_encoding(r);
>   	u64 val = p->regval;
>   	int reg = r->reg;
>   
> -	if (p->is_write)
> +	if (p->is_write) {
> +		if (WARN_ON_ONCE(encoding == SYS_PMBIDR_EL1 ||
> +				 encoding == SYS_PMSIDR_EL1))
> +			return write_to_read_only(vcpu, p, r);
>   		return kvm_spe_write_sysreg(vcpu, reg, val);
> +	}
>   
> -	p->regval = kvm_spe_read_sysreg(vcpu, reg);
> +	p->regval = kvm_spe_read_sysreg(vcpu, reg, encoding);
>   	return true;
>   }
>   
> @@ -3360,12 +3365,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>   	{ SPE_UNTRAPPED_REG(PMSFCR_EL1) },
>   	{ SPE_UNTRAPPED_REG(PMSEVFR_EL1) },
>   	{ SPE_UNTRAPPED_REG(PMSLATFR_EL1) },
> -	{ SYS_DESC(SYS_PMSIDR_EL1), .access = undef_access },
> +	{ SYS_DESC(SYS_PMSIDR_EL1), .access = access_spe_reg, .visibility = spe_visibility },
>   	{ SPE_TRAPPED_REG(PMBLIMITR_EL1) },
>   	{ SPE_TRAPPED_REG(PMBPTR_EL1) },
>   	{ SPE_TRAPPED_REG(PMBSR_EL1) },
>   	{ SPE_UNTRAPPED_REG(PMSDSFR_EL1) },
> -	{ SYS_DESC(SYS_PMBIDR_EL1), .access = undef_access },
> +	{ SYS_DESC(SYS_PMBIDR_EL1), .access = access_spe_reg, .visibility = spe_visibility },
>   
>   	{ PMU_SYS_REG(PMINTENSET_EL1),
>   	  .access = access_pminten, .reg = PMINTENSET_EL1,

