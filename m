Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7727127935D
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 23:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741131965; cv=none; b=FOskL7WqobWoEEbmAqznO+z/1UeAMsgEqsXZpYEgNVBWcz6Z3jw1KFK9nZf2SeMOaCfc3mGkBRusgXOcfZocqZJkDPmVwwO85IvKM4c+B8cRWTzq1ITjWJgqLSXbeWFWcwKBba6uGo0vxCmHFQETl1GXv3xxFAK6SMCxIDn9VPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741131965; c=relaxed/simple;
	bh=Lef0MQKtiaqOzXYjRH2Nm9Cp4sRXRppVWKK2dDGvm/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F/MwK+NjhDqsa69b2FiJAW/Ynpsgpuak2UadSYATPRuwM6hC/Vn0OBVpb4j1UVqaOeRgA8y3rvrNP1eBXa/ofCN1Dsgz9vEMYknlcy3LszoJfz6qAkzXrtPi31JjakbDEV1fxDimPy+A9HVyjSPC7ZtV9qHaQ/KrsbDmlYw1cyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c9hoRGbH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c9hoRGbH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741131962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OP9ovaiE8W931ELBVF5NuIIs9fylqFyNkVXudwtC3tg=;
	b=c9hoRGbHyWCI2aKhWoG0Jycx1GdR1JQyLxoxkJsdua5dtmbqGxxrX0sDoaOw0vHwQF2aDv
	LW0rgLwflUfYOLLAUZqZgql0d5tfdF82s48/PnqkgpxokpsyTSBckl16lpuwFReFfU0euy
	b4YNiyJU5dhFvDOLqqVDyGFBw00azrc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-pP6LvVXZOkSNGVdY57s5Pw-1; Tue, 04 Mar 2025 18:45:51 -0500
X-MC-Unique: pP6LvVXZOkSNGVdY57s5Pw-1
X-Mimecast-MFC-AGG-ID: pP6LvVXZOkSNGVdY57s5Pw_1741131950
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2234c09240fso107299725ad.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Mar 2025 15:45:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741131950; x=1741736750;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OP9ovaiE8W931ELBVF5NuIIs9fylqFyNkVXudwtC3tg=;
        b=jnfjbVQdz0RYxy+Daj7tnFE0d8bpn4NFubkReZhE5IVLMI62qP68gk7dzgGIaosD/N
         snrVS17yniZ6BNf5CHQ19JvIqmydGdHikC5VVAbdAi2ZKso/tAU0V5DKJFB7QqzXAdbo
         ktBWGtlFIaqcVUH4kh3EGn6yaNogJvkgJHGPIfZBRLVOqRyuu1+DznvkgeBftUgvAgUm
         L1DlJEMJnLBh5NFB1qIBziUwnefZ2/gdk3kiYv0RTH7dH4z+Wa4s8gs6jA5vsmrKnYr3
         Zt3DMbJOsWg7i3Y+RjGnlTXCtyxA9bmqf4B/fkEXqY8CacH0PEP/0VY/TK4SAMlJdCSm
         5Yhw==
X-Forwarded-Encrypted: i=1; AJvYcCVZ54xmcWS9Tm9H1W9/6GUg631G/xiJqeqPEq5Kinlp4tdjEH0gQ4KgvWZtqSkNd1YrlL7YeIE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZtDpYFC3iJFlzpBPTEGwpRNShKkEdEVHZxfCGOMsKoPlR1glB
	wJ5XE/KkWEdpfl6k8C5pRrcRrfemrJN4CXrb6RsKrpc72qO2ca+PsxIbcJAoE+zC2VwP/HIc9t+
	hrzM1rIgXz1hrJa2c5wdLr8fWxuI2D8nBZci6YvgTmW5xtwamwqzFrw==
X-Gm-Gg: ASbGncvibYZyWdkzcD2CZmKiloG/KnRPLn5ax+yFCR8TYhItG8viJJ6XamXHdWCxGE2
	GFI376iwfTusHa7ZTuN3NJqYexqXC2gmi6z4zCTxYDi8OuXOXyokl1Lg9u593JvBn3osoS6IHA0
	pCdsYAWi9DxBeR5RAG1qLRJzK9QnCQJcwapQ9PkbbFu99Tcb/kQkOQP6uoH3BF/jls8qvT9E+HI
	IbrYkbGYMtb201c943dnG39nFPTs5PDOaAD1TrLGifZ2YURTkX1Xjbxa6hhdX4a5AHB/StuIPhU
	BZN4dICDBcgWVkg=
X-Received: by 2002:a05:6a20:7345:b0:1ee:d6a7:e341 with SMTP id adf61e73a8af0-1f34952e7f5mr2027008637.30.1741131950429;
        Tue, 04 Mar 2025 15:45:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6SHWUDr/wxtrgl8ODJO2LORkYE1xgQa8DpVJblqhw13356llhbnfpOxuEBTenhhAi0XuOnQ==
X-Received: by 2002:a05:6a20:7345:b0:1ee:d6a7:e341 with SMTP id adf61e73a8af0-1f34952e7f5mr2026963637.30.1741131950083;
        Tue, 04 Mar 2025 15:45:50 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7de37fedsm9080597a12.42.2025.03.04.15.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 15:45:49 -0800 (PST)
Message-ID: <c8af8a7f-5ee4-460b-aec4-959f688db628@redhat.com>
Date: Wed, 5 Mar 2025 09:45:41 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 35/45] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-36-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-36-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Zd8_Qz5j2AZKztCcPFccsvNv6ef_F2jOGKFOdMqnTzo_1741131950
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> The RMM describes the maximum number of BPs/WPs available to the guest
> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
> which is visible to userspace. A VMM needs this information in order to
> set up realm parameters.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>   arch/arm64/kvm/sys_regs.c        |  2 +-
>   3 files changed, 25 insertions(+), 1 deletion(-)
> 

With the following one nitpick addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index d684b30493f5..67ee38541a82 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>   u32 kvm_realm_ipa_limit(void);
>   u32 kvm_realm_vgic_nr_lr(void);
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
> +
>   bool kvm_rme_supports_sve(void);
>   
>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f83f34358832..8c426f575728 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -87,6 +87,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>   	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>   }
>   
> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
> +{
> +	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
> +	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
> +	u32 ctx_cmps;
> +
> +	if (!kvm_is_realm(vcpu->kvm))
> +		return val;
> +
> +	/* Ensure CTX_CMPs is still valid */
> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
> +	ctx_cmps = min(bps, ctx_cmps);
> +
> +	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
> +		 ID_AA64DFR0_EL1_CTX_CMPs);
> +	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
> +	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
> +
> +	return val;
> +}
> +

The chunk of code can be squeezed to sys_reg.c::sanitise_id_aa64dfr0_el1() since
sys_reg.c has been plumbed for realm, no reason to keep a separate helper in rme.c
because it's only called by sys_reg.c::sanitise_id_aa64dfr0_el1()

>   static int get_start_level(struct realm *realm)
>   {
>   	return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ed881725eb64..5618eff33155 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1820,7 +1820,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>   	/* Hide BRBE from guests */
>   	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>   
> -	return val;
> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>   }
>   
>   static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,

Thanks,
Gavin

