Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC839126BF1
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 23:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746142899; cv=none; b=ZXxPGZggxtmOU2OhIzR9uJ+TJbq4y8WWXSpsgQafl5ryrXYfHtWmi2jatgsucUDzvoVWYANz/l37gS2CEldAEdLA056vPv20dUU8nDZeXGePo9muWXkkAjMSyBQWN7K56dX+DQ1WW/ffTDKhD5I02n919EgFRA/zqa86P+VvoWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746142899; c=relaxed/simple;
	bh=V3rX/4/xpD9h/udXgGtkaJHl8XY74/C8DHLGx9nM+cQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A4rtttJGPWzSYxbo+Jx1iWRuu3EPTpHbUB+gl6zZtkWUv6IuB09sHibq3RqnbDDWdmv1LrTr8hJufu5HhZKZV6L0HdCtd7HJpLvtwDRY9ZrL0XLd0uvHkUvb1hNpUsECPi/w7EKkewEK34fc49TIuj6kJYe9XouVo+TKPd1Qbvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z3cGKz3U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z3cGKz3U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746142896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CyhZBVISRQ5clAuU8+PvOudE8wxZ8XRmw30nrERw5/M=;
	b=Z3cGKz3Ubuk/xJQhwUaZGCwS8fAfTwBRT09StZCOK+tR8QXrpVqCntG/OulAu4n8YTWxLe
	lf8ohbsVmbzkhT+baexrbefIBh/0kHCykpglxl4YWFCUk2Uq7z9PQ0ly+zNxjWuNW2zgtO
	WbPnaZlaxySJwFawdZaCYcvzjXgEvpM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-uWikhGKfN12oyHiKOWBPJA-1; Thu, 01 May 2025 19:41:35 -0400
X-MC-Unique: uWikhGKfN12oyHiKOWBPJA-1
X-Mimecast-MFC-AGG-ID: uWikhGKfN12oyHiKOWBPJA_1746142894
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b090c7c2c6aso802720a12.0
        for <kvmarm@lists.linux.dev>; Thu, 01 May 2025 16:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746142894; x=1746747694;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CyhZBVISRQ5clAuU8+PvOudE8wxZ8XRmw30nrERw5/M=;
        b=VBlEvZAo6EF1GjqvVGfzWfrZOaTSW8z3w2iWbIwh9GRJ1U3063qisVSbCE2LjCsrYL
         o9+Gi7v3rL2701NclSbUIdENLoVk11DFK55WseJL1ix28Ond5JtgtYBGOR+k+Uzez++9
         u71wNBL+M7bN4LuO9IL/mN5rDSz92EqAq2Oq5kVrPOshFtwQfDqOj7OyGrPs39W5J8Pg
         52Xgg8SzsqV2OUYmUrIxtvRlU+G1Vkp86Z2L//aAp3AsGJnuxPEbBQxApoZ19OYC7OJD
         exlHRMkLrTHqdVnT9KiVzoJSEP0ERZbt05RO1ROYnbHLsHlgAzDwFuuBynyXvR6F35z0
         X9HA==
X-Forwarded-Encrypted: i=1; AJvYcCWPWHWfWHWlc17NyHE6xqMkpU3Xox7ysP0CYK+f+fO2rwM2fS7SkR60C8knWeWY5ZAfHJXhKXk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8ecp5pt6/lfBt0FoZM0DP9vNjonMqMCNvmODuw7AwFMwNdovU
	fk9CLecCdu/Hbnqb0+PQXa1NIb39Wq4v5Eq110zTbcPfXHVsbCa8kUPbDXUPCCqW8hfXQJH1mCy
	7euA8Hj8H2DjQtYMHIkQaWq4cyquO2+NAXnuY0mFM7bn8iXkQALDIAw==
X-Gm-Gg: ASbGncvBx3mIRq24EKjjd8bIw/TChZdVu2gLCu1KynRaK4aj4yGIZbh/fQNE2sjtYTz
	5mFM86ijbus32cxVgeK6pyKKmQcwCIS0R2yuXaMXRz+80uGBiVK3lEGsZgo5UuP+3Mke6PpVgH+
	RyItdTs1Ce3OtIBCbb0mIZf1KtXwegna0aLW2QJf2lH+SzP2Aox9Bt0Y9OpyHGfOeh6mDLGbwe1
	ZPxlRbp9tK6rLMzDtc+98X5L/jL9rGOWdueddgSWoXHyOoH5L8e8adZqtTfFv61TY61rzNSAw64
	JgnG9pd7t65X
X-Received: by 2002:a05:6a21:33a3:b0:1f5:852a:dd81 with SMTP id adf61e73a8af0-20cdfdf1dc5mr1087257637.34.1746142894153;
        Thu, 01 May 2025 16:41:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGq3VtO1vtLmO8E/fnCTC9w5B6F4cawG5lkrIFMIOrYDpU+7Qf+p2E6KFN4AlFzZpxvWi44og==
X-Received: by 2002:a05:6a21:33a3:b0:1f5:852a:dd81 with SMTP id adf61e73a8af0-20cdfdf1dc5mr1087223637.34.1746142893729;
        Thu, 01 May 2025 16:41:33 -0700 (PDT)
Received: from [192.168.68.51] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa8285817sm170886a12.30.2025.05.01.16.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 16:41:33 -0700 (PDT)
Message-ID: <377a678c-16e4-4e85-8831-421e59e9bf6e@redhat.com>
Date: Fri, 2 May 2025 09:41:25 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 40/43] arm64: RME: Provide accurate register list
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-41-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250416134208.383984-41-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2V0XxYV89r9pTG_xUFMXQdukxEbfW7fT2vNcNDTfjmw_1746142894
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 11:42 PM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Userspace can set a few registers with KVM_SET_ONE_REG (9 GP registers
> at runtime, and 3 system registers during initialization). Update the
> register list returned by KVM_GET_REG_LIST.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v7:
>   * Reworked on upstream changes.
> ---
>   arch/arm64/kvm/guest.c      | 19 ++++++++++++++-----
>   arch/arm64/kvm/hypercalls.c |  4 ++--
>   arch/arm64/kvm/sys_regs.c   | 28 ++++++++++++++++++++++------
>   3 files changed, 38 insertions(+), 13 deletions(-)
> 

With below nitpicks addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 1288920fc73d..e9bb7647aa65 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -618,8 +618,6 @@ static const u64 timer_reg_list[] = {
>   	KVM_REG_ARM_PTIMER_CVAL,
>   };
>   
> -#define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
> -
>   static bool is_timer_reg(u64 index)
>   {
>   	switch (index) {
> @@ -634,9 +632,14 @@ static bool is_timer_reg(u64 index)
>   	return false;
>   }
>   
> +static unsigned long num_timer_regs(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_is_realm(vcpu->kvm) ? 0 : ARRAY_SIZE(timer_reg_list);
> +}
> +

static inline unsigned long num_timer_regs(struct kvm_vcpu *vcpu)

>   static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   {
> -	for (int i = 0; i < NUM_TIMER_REGS; i++) {
> +	for (int i = 0; i < num_timer_regs(vcpu); i++) {
>   		if (put_user(timer_reg_list[i], uindices))
>   			return -EFAULT;
>   		uindices++;

	for (unsigned long i = 0; ...)

> @@ -674,6 +677,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
>   	if (!vcpu_has_sve(vcpu) || !kvm_arm_vcpu_sve_finalized(vcpu))
>   		return 0;
>   
> +	if (kvm_is_realm(vcpu->kvm))
> +		return 1; /* KVM_REG_ARM64_SVE_VLS */
> +
>   	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
>   		+ 1; /* KVM_REG_ARM64_SVE_VLS */
>   }
> @@ -701,6 +707,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
>   		return -EFAULT;
>   	++num_regs;
>   
> +	if (kvm_is_realm(vcpu->kvm))
> +		return num_regs;
> +
>   	for (i = 0; i < slices; i++) {
>   		for (n = 0; n < SVE_NUM_ZREGS; n++) {
>   			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
> @@ -739,7 +748,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>   	res += num_sve_regs(vcpu);
>   	res += kvm_arm_num_sys_reg_descs(vcpu);
>   	res += kvm_arm_get_fw_num_regs(vcpu);
> -	res += NUM_TIMER_REGS;
> +	res += num_timer_regs(vcpu);
>   
>   	return res;
>   }
> @@ -773,7 +782,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   	ret = copy_timer_indices(vcpu, uindices);
>   	if (ret < 0)
>   		return ret;
> -	uindices += NUM_TIMER_REGS;
> +	uindices += num_timer_regs(vcpu);
>   
>   	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
>   }
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 569941eeb3fe..fb2bba0c7e86 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -412,14 +412,14 @@ void kvm_arm_teardown_hypercalls(struct kvm *kvm)
>   
>   int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>   {
> -	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> +	return kvm_is_realm(vcpu->kvm) ? 0 : ARRAY_SIZE(kvm_arm_fw_reg_ids);
>   }
>   
>   int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   {
>   	int i;
>   
> -	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
> +	for (i = 0; i < kvm_arm_get_fw_num_regs(vcpu); i++) {
>   		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
>   			return -EFAULT;
>   	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a53a06700867..7d384016d1ba 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -4960,18 +4960,18 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>   				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
>   }
>   
> -static unsigned int num_demux_regs(void)
> +static unsigned int num_demux_regs(struct kvm_vcpu *vcpu)
>   {
> -	return CSSELR_MAX;
> +	return kvm_is_realm(vcpu->kvm) ? 0 : CSSELR_MAX;
>   }
>   

static inline unsigned int num_demux_regs(struct kvm_vcpu *vcpu)

> -static int write_demux_regids(u64 __user *uindices)
> +static int write_demux_regids(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   {
>   	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
>   	unsigned int i;
>   
>   	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
> -	for (i = 0; i < CSSELR_MAX; i++) {
> +	for (i = 0; i < num_demux_regs(vcpu); i++) {
>   		if (put_user(val | i, uindices))
>   			return -EFAULT;
>   		uindices++;
> @@ -5002,11 +5002,27 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
>   	return true;
>   }
>   
> +static bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu, u64 reg)
> +{
> +	if (!kvm_is_realm(vcpu->kvm))
> +		return false;
> +
> +	switch (reg) {
> +	case SYS_ID_AA64DFR0_EL1:
> +	case SYS_PMCR_EL0:
> +		return false;
> +	}
> +	return true;
> +}
> +

static inline bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu, u64 reg)

>   static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
>   			    const struct sys_reg_desc *rd,
>   			    u64 __user **uind,
>   			    unsigned int *total)
>   {
> +	if (kvm_realm_sys_reg_hidden_user(vcpu, reg_to_encoding(rd)))
> +		return 0;
> +
>   	/*
>   	 * Ignore registers we trap but don't save,
>   	 * and for which no custom user accessor is provided.
> @@ -5044,7 +5060,7 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>   
>   unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
>   {
> -	return num_demux_regs()
> +	return num_demux_regs(vcpu)
>   		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
>   }
>   
> @@ -5057,7 +5073,7 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>   		return err;
>   	uindices += err;
>   
> -	return write_demux_regids(uindices);
> +	return write_demux_regids(vcpu, uindices);
>   }
>   
>   #define KVM_ARM_FEATURE_ID_RANGE_INDEX(r)			\

Thanks,
Gavin

