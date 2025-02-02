Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5467B1FECC7
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 23:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738538803; cv=none; b=Q4RP539mBfo8vSBa9hgbKmpYF8dbC1t7KTRU0oMD49VBtko8C20uCgMmdQFJfUEE257C1uAYg4mraKrxymJlxSu2mW/P5IhiKcmv6LtlWx3ePfTrLmKjmr+CyXvQPT8co73AS7R6YA/ARkC0F4JaxY2ezV0dBGQYs9blN0mKn2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738538803; c=relaxed/simple;
	bh=z7NwxIJMtLT2Cr/NLoKbJYIk4kldTFHXswm3cyHYX/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RmdDNvlPgpyx+tFNh6wQ8JRUuEzQbsuGbFURHx+MtaarkvDHR8ahTE+3vEjmaAAyK4dtH7lETfo2r34mHQ8+5ZyGbHP2dHH+wNfxc3K5EWhxVvQoxdpkxojS6rSKuDGqqj/NTlvbrwlPjL9HchYxsYHYY+3CZRsSUn7eb7TmLoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RZY2n8Tj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RZY2n8Tj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738538800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kEorSgFKgFJuDrUUhtFm3PBvl23oSWqfsEHani8D+OI=;
	b=RZY2n8TjMUIScnxBCZpiZcHESS79uoFdQYoQ0racPq7ebIhcp20DfzQ3HcsQd3H3nCct0M
	3TSkPX3hF1OElarSTEtJbCRU2N6FyfJE21Hlvucr8e84QsdGcveSXvVB+pfScz7teKYlmD
	niRruhCGdQPt1miFwznJLOE7RykY274=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-o3e19wVyODuzPDNHEDbcyg-1; Sun, 02 Feb 2025 18:26:39 -0500
X-MC-Unique: o3e19wVyODuzPDNHEDbcyg-1
X-Mimecast-MFC-AGG-ID: o3e19wVyODuzPDNHEDbcyg
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2166a1a5cc4so76343795ad.3
        for <kvmarm@lists.linux.dev>; Sun, 02 Feb 2025 15:26:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738538798; x=1739143598;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kEorSgFKgFJuDrUUhtFm3PBvl23oSWqfsEHani8D+OI=;
        b=MrfoOymQIokMNWHgnptEopnKu2fNROmXNXZPfQpqPQH8eAWiOQFU4X0gZEsK3O1A4r
         EIReIzfbWFsVutqy6SVEgN8AyTp6qAR+wkEXHcsnzlsPEvTEtD18VlBRTBiLkmbnHTWa
         d+O2j3yY/4RnRbTzQeL9xnk3YfMu6MGNwjuX1NmduslWB6aIDGfdXrOCuAMajxmNgss9
         IFFlWGSD+ScVPbhthGTJkC90hn8/Hwal2lWOAW23SdhrNuEsimiZsVsQtEgaxd3knyv/
         p0UZMZa9AplAdKtUo8pQ/zymjZ+oisTYd/qM7y2YeT/ZwMx5x1yDO/htEj8rGlM7BMFf
         hn1g==
X-Forwarded-Encrypted: i=1; AJvYcCUSHfsM1o1DyaLkxr+aoN8HI3MwX4WGN3zV+dUvt9Y/1lrpnSmXpTLXTS6tmBDD3bo5Qx3Jh+A=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoETVuhdHPxh5QZIItrqFnLpSMILYiKRXnbT0rxNhGf6z987cg
	OcGByDupsr2l6M+FzuobWWcDdSblwsbMqbIOpwEGSwP56DasQ5SwpbUNiSrzm+gbsfDpWXFr7lq
	9EhpufOmX12pV6IBgLZAtZyQh4/l4BSoOIl/jbll2WD79RYoYmn+kcA==
X-Gm-Gg: ASbGncuuzrNT9KRjV4WWlGptaZZAJ04eCwhyDUrcCk4v3TUdsmAA2ClYda7/eoaqrVi
	tsGcuwaLgUvpyXk9vOf7ZoCV9DqLTWkXb5EzsqAkE7q88cfFyCuGjBZKkpUisjyBGLc0+YMfQ04
	NIKYb+Ebi2njHh98Dc6UFKJ77etuv4VsVSVJ6/DxKIcTG+xNygCb1WKqc88/9oId8nh4sg77TED
	AjlucnngjckE3B4X+tzaUHit/Nota26WnC3dW07K11JIhEgy1NbfwcNRX7miLs4wXnI2L0PGp3W
	ZCqXJg==
X-Received: by 2002:a17:902:cec3:b0:216:7ee9:2227 with SMTP id d9443c01a7336-21dd7dd88e6mr310304605ad.36.1738538798023;
        Sun, 02 Feb 2025 15:26:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGfTk8xGUBI61+sXaogs4siFVAtjNe8wBT4NdlyuKENiA8v7HLfkeSD7O9+S9Z2x6jnkLdTWg==
X-Received: by 2002:a17:902:cec3:b0:216:7ee9:2227 with SMTP id d9443c01a7336-21dd7dd88e6mr310304415ad.36.1738538797668;
        Sun, 02 Feb 2025 15:26:37 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de3303472sm63313735ad.195.2025.02.02.15.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2025 15:26:36 -0800 (PST)
Message-ID: <b8b5501b-f5fd-44da-8445-53516cad8a3e@redhat.com>
Date: Mon, 3 Feb 2025 09:26:28 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 38/43] arm64: RME: Configure max SVE vector length for
 a Realm
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
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-39-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-39-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -fep1R_j-MPjuyHL21E17Td6aScciWABcJ3YFtGo__4_1738538798
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:56 AM, Steven Price wrote:
> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> 
> Obtain the max vector length configured by userspace on the vCPUs, and
> write it into the Realm parameters. By default the vCPU is configured
> with the max vector length reported by RMM, and userspace can reduce it
> with a write to KVM_REG_ARM64_SVE_VLS.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/guest.c |  3 ++-
>   arch/arm64/kvm/rme.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 429c8f10b76a..5562029368c5 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -363,7 +363,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	if (!vcpu_has_sve(vcpu))
>   		return -ENOENT;
>   
> -	if (kvm_arm_vcpu_sve_finalized(vcpu))
> +	if (kvm_arm_vcpu_sve_finalized(vcpu) || kvm_realm_is_created(vcpu->kvm))
>   		return -EPERM; /* too late! */
>   
>   	if (WARN_ON(vcpu->arch.sve_state))
> @@ -825,6 +825,7 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
>   		switch (reg->id) {
>   		case KVM_REG_ARM_PMCR_EL0:
>   		case KVM_REG_ARM_ID_AA64DFR0_EL1:
> +		case KVM_REG_ARM64_SVE_VLS:
>   			return true;
>   		}
>   	}
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 39dbc19e4a42..3116ecee37a8 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -297,6 +297,44 @@ static void realm_unmap_shared_range(struct kvm *kvm,
>   	}
>   }
>   
> +static int realm_init_sve_param(struct kvm *kvm, struct realm_params *params)
> +{
> +	int ret = 0;
> +	unsigned long i;
> +	struct kvm_vcpu *vcpu;
> +	int max_vl, realm_max_vl = -1;
> +

I would suggest to rename 'max_vl' and 'realm_max_vl' to 'vl' and 'last_vl'
since we're not looking for the maximal VLs. Instead, we're making sure the
VLs on all vCPUs are equal.

> +	/*
> +	 * Get the preferred SVE configuration, set by userspace with the
> +	 * KVM_ARM_VCPU_SVE feature and KVM_REG_ARM64_SVE_VLS pseudo-register.
> +	 */
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		mutex_lock(&vcpu->mutex);
> +		if (vcpu_has_sve(vcpu)) {
> +			if (!kvm_arm_vcpu_sve_finalized(vcpu))
> +				ret = -EINVAL;
> +			max_vl = vcpu->arch.sve_max_vl;
> +		} else {
> +			max_vl = 0;
> +		}
> +		mutex_unlock(&vcpu->mutex);
> +		if (ret)
> +			return ret;
> +
> +		/* We need all vCPUs to have the same SVE config */
> +		if (realm_max_vl >= 0 && realm_max_vl != max_vl)
> +			return -EINVAL;
> +
> +		realm_max_vl = max_vl;
> +	}
> +
> +	if (realm_max_vl > 0) {
> +		params->sve_vl = sve_vq_from_vl(realm_max_vl) - 1;
> +		params->flags |= RMI_REALM_PARAM_FLAG_SVE;
> +	}
> +	return 0;
> +}
> +
>   static int realm_create_rd(struct kvm *kvm)
>   {
>   	struct realm *realm = &kvm->arch.realm;
> @@ -344,6 +382,10 @@ static int realm_create_rd(struct kvm *kvm)
>   		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
>   	}
>   
> +	r = realm_init_sve_param(kvm, params);
> +	if (r)
> +		goto out_undelegate_tables;
> +
>   	params_phys = virt_to_phys(params);
>   
>   	if (rmi_realm_create(rd_phys, params_phys)) {

Thanks,
Gavin

