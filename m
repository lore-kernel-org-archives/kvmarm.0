Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916F173475
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 10:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716979039; cv=none; b=CiyreJef3C2jZ/NP6fmWb+JyAzExn3DOLVIiE94nFtJzgUwRuasRc0TOnpZRjVpKH+kwT6Vsf5K+128PGrqEEuRTYhsKPtk3SowrMiKeIQ3o+MPx9fXi0Fp05Lt71+oaq03KlohOtIzVf/YNQDH+vZkODDlkvDBkK6DbPRtcSIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716979039; c=relaxed/simple;
	bh=G9uzJP0+BNyAfuTtqcPbs7l5tUhV7jwdCvIKvRovtQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XdxMnp8uHn1Ax1rEb8SQRlpCBbuRifdY7pQu+9jlVNeKimvSBObT25SAhjok9pvTq6n9BkBassqXlcTsDTpXpy3js09GJeamKQB+11UuVAHM0S5IlqgSKLhwCyd2d0UMQrknzUyPvZLsFtcUzXojqkUA7eoa310CIqxtUWq7sVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K/uYNjMa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K/uYNjMa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716979036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gM9wng/1sMXgGbMzP4INZ6olAst1tcVj0Y6oUxN7AxM=;
	b=K/uYNjMaf4Sh4lkpU4P1CoEeAxetu2MUbx2NjgBlnTW6rRG768cvIVAbQ4hphbSyICiydC
	PSHIjrArNJ2vS0DhS+6cc1mHH5n4zr+TJNCMC7jKYVhiw+F0bs7mJkfnKN7WkTLOtOmHM8
	8DUh+hj4Tu2m6tU4y9IEMlvyoeqy348=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-HioMomDUNoa7m-7gjF_H8g-1; Wed, 29 May 2024 06:37:15 -0400
X-MC-Unique: HioMomDUNoa7m-7gjF_H8g-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52b02740594so414803e87.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 03:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716979033; x=1717583833;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gM9wng/1sMXgGbMzP4INZ6olAst1tcVj0Y6oUxN7AxM=;
        b=ukOvTowo1JrhXRtsYQ/A76VxdxhGI/V1roqDbPA8JdzeRrijAQf1nNkZc1RvTBBxmg
         XshkSrUs8BWT1yfSgoRNJ+0EmPgrEfN5Q9zRProrW3hBMtrLgbBJd8ItWq0RnrAIG/Jk
         Q+j64Q5aXKxZ5fB24a6pkZdR74lAB9PDbifHRVtKCLMibjWFh6Xvsrnp3+ELf9fEMnaC
         JMTymzQ2+ALQ7ZvCnT3LqXScqDWm/q47HqRVRerT3oRCrHaodZPpn5iUfwULKuYgsQMX
         hXZo7SeD+mY4dwvFgFt847DwwoPL7BCbgT7R+2sJMRdopsSsBhJT0uguOpGiznzUhO4F
         1OvA==
X-Forwarded-Encrypted: i=1; AJvYcCXsk67WmGZwpBTm/JWczlzkqE1Ly1GdNKFBu9G4Vdj7r2ibGt5gm8u6zmSZ2r171iJVECsZIc2NmNji4tZbwEcf6FrtOiSr
X-Gm-Message-State: AOJu0YxlHvG0UW3f7r4XgLEIcCGECXzR2oQ7w/3KNViHHnFjqMEsqnSX
	xhEFFlimIjVkcP0mcjRR3mKjRStWIVcGs3ByH9kvte2lMKajATSyhcOKwV4dRe6DJvGvJXoAKK6
	R69d3W2lqhWqjaW61sY6Ncqquxx5ocG2N4e3PWQfcvxztzF+2RCxGQA==
X-Received: by 2002:a19:7717:0:b0:51d:8ff3:d156 with SMTP id 2adb3069b0e04-529645e3335mr8946305e87.19.1716979033595;
        Wed, 29 May 2024 03:37:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0Ppw3rOSaH5DcJRG2imKCS9nShnbeCFbWgHF9/dS1wQ/oFyQU618kFxtdr8FU7t8V05R4Gw==
X-Received: by 2002:a19:7717:0:b0:51d:8ff3:d156 with SMTP id 2adb3069b0e04-529645e3335mr8946283e87.19.1716979033207;
        Wed, 29 May 2024 03:37:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100ee954bsm207676175e9.4.2024.05.29.03.37.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 03:37:12 -0700 (PDT)
Message-ID: <edbe3039-ed42-432e-8309-5a0a46cc2d5c@redhat.com>
Date: Wed, 29 May 2024 12:37:12 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] KVM: arm64: maintain per VM value for CTR_EL0
To: Sebastian Ott <sebott@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
References: <20240514072252.5657-1-sebott@redhat.com>
 <20240514072252.5657-3-sebott@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20240514072252.5657-3-sebott@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebastian,

On 5/14/24 09:22, Sebastian Ott wrote:
> In preparation for CTR_EL0 emulation maintain a per VM for this
s/a per VM for this register/a per VM shadow register for this latter?
> register and use it where appropriate.
> 
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/sys_regs.c         | 21 ++++++++++++++-------
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 212ae77eefaf..1259be5e2f3e 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -331,6 +331,8 @@ struct kvm_arch {
>  #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
>  	u64 id_regs[KVM_ARM_ID_REG_NUM];
>  
> +	u64 ctr_el0;
> +
>  	/* Masks for VNCR-baked sysregs */
>  	struct kvm_sysreg_masks	*sysreg_masks;
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 41741bf4d2b2..0213c96f73f2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -219,9 +219,9 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
>   * Returns the minimum line size for the selected cache, expressed as
>   * Log2(bytes).
>   */
> -static u8 get_min_cache_line_size(bool icache)
> +static u8 get_min_cache_line_size(struct kvm *kvm, bool icache)
>  {
> -	u64 ctr = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	u64 ctr = kvm->arch.ctr_el0;
>  	u8 field;
>  
>  	if (icache)
> @@ -248,7 +248,7 @@ static u32 get_ccsidr(struct kvm_vcpu *vcpu, u32 csselr)
>  	if (vcpu->arch.ccsidr)
>  		return vcpu->arch.ccsidr[csselr];
>  
> -	line_size = get_min_cache_line_size(csselr & CSSELR_EL1_InD);
> +	line_size = get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD);
>  
>  	/*
>  	 * Fabricate a CCSIDR value as the overriding value does not exist.
> @@ -283,7 +283,7 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 csselr, u32 val)
>  	u32 i;
>  
>  	if ((val & CCSIDR_EL1_RES0) ||
> -	    line_size < get_min_cache_line_size(csselr & CSSELR_EL1_InD))
> +	    line_size < get_min_cache_line_size(vcpu->kvm, csselr & CSSELR_EL1_InD))
>  		return -EINVAL;
>  
>  	if (!ccsidr) {
> @@ -1886,7 +1886,7 @@ static bool access_ctr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	if (p->is_write)
>  		return write_to_read_only(vcpu, p, r);
>  
> -	p->regval = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	p->regval = vcpu->kvm->arch.ctr_el0;
>  	return true;
>  }
>  
> @@ -1906,7 +1906,7 @@ static bool access_clidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>   */
>  static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
> -	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
>  	u64 clidr;
>  	u8 loc;
>  
> @@ -1959,8 +1959,8 @@ static u64 reset_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  static int set_clidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  		      u64 val)
>  {
> -	u64 ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
>  	u64 idc = !CLIDR_LOC(val) || (!CLIDR_LOUIS(val) && !CLIDR_LOUU(val));
> +	u64 ctr_el0 = vcpu->kvm->arch.ctr_el0;
>  
>  	if ((val & CLIDR_EL1_RES0) || (!(ctr_el0 & CTR_EL0_IDC) && idc))
>  		return -EINVAL;
nit: you may update the function doc comment which the extra handling of
CTR_EL0.
> @@ -3557,6 +3557,13 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
>  	struct kvm *kvm = vcpu->kvm;
>  	unsigned long i;
>  
> +	if (!kvm_vcpu_initialized(vcpu))
at this stage of the reading, why is the above check needed?
> +		/*
> +		 * Make sure CTR_EL0 is initialized before registers
> +		 * that depend on it are reset.
> +		 */
nit: the above comment explains why you need to set the shadow ctr_el0
reg  before resetting other id_regs and is not associated to the case
where (!kvm_vcpu_initialized(vcpu)) is true - at least that's my
understanding -. So I would put the comment before the check and while
at it also explain why the check is needed.
> +		kvm->arch.ctr_el0 = read_sanitised_ftr_reg(SYS_CTR_EL0);
> +
>  	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
>  		const struct sys_reg_desc *r = &sys_reg_descs[i];
>  

Thanks

Eric

