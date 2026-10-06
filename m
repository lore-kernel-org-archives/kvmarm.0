Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F8A286417
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 02:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791253483; cv=none; b=D6ypM2OsVuVPuXjXoFu45cno/GsRLMQIcXWVQHPzSza7jlvfeFnvuPyuNEv+Vb1B12FqEDJdqEkq0FWa3+LWW206B8173gB5xYVhX6Oa2LaT08eGB5yU1l+6AQpLB9GreX/YPFEk70cMSSF5VZx2YwUjOeL28TLqMwpJq+W8hrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791253483; c=relaxed/simple;
	bh=QWAFFhzhcemt4JkAXvKSQU+sijmwJ3F9VG6lkevDJYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TYEObC6PHenFnKw5WZGlNQdxmjiOWjfb4R0OHJbgmXgCuGjeKG489UU1yTYBYvzeXGhYyy0CFpQ/0Ae6Eo4jdiNvYlNFkQpD37zaLFhiYDuD/JrWBLNJ4Drid3tbv16E6Rkcc6boF6AHpOpa8e/rZSpLkBEf3gXqsZkXnj0U5EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AkBGYy5z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AkBGYy5z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791253480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ugMxefZ1qIEDU/oRAsn8b/LDZMC+9ePrF31NK37FBF8=;
	b=AkBGYy5zhUpXNv6jCeKlBZIcQYZcDv8nWCqebRuA51PVg/alI0xdUhxTcLTj6hNIG2YBg6
	66DwdziOQOqcO58vFJzzSND4F/zN68Ca7E+OzL7pwGSrn+FDTJ09JeDrcTgvC+McCEPCBy
	boyPgPPTFrEmQovv078x6IGRE03pNVw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-EGcmbeYAPmeCb30Zm2I2rg-1; Mon, 05 Oct 2026 22:24:39 -0400
X-MC-Unique: EGcmbeYAPmeCb30Zm2I2rg-1
X-Mimecast-MFC-AGG-ID: EGcmbeYAPmeCb30Zm2I2rg_1791253478
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3a4e36d5a77so2507150a91.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 19:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791253478; x=1791858278;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ugMxefZ1qIEDU/oRAsn8b/LDZMC+9ePrF31NK37FBF8=;
        b=h9oyX/xWQXIOE93cS12ThDDZ10aSwRbZCly/wZonTLkS+Q0gYFnQcIN6MG52mKNJT6
         qH94D0EyV0iJeFNlbvaLWYRlm04kcuSDJQBzlnxwnPB4XQOV8usKCfb3iMdngFxJAzR4
         imDKVdBrD7dJ5a53k3vexEEkt9OSortJLxD/EhOASZRWJgJVdrOMC+TZcgAQ3kNgD/66
         iDWJ3GwVp2uCJplrQWc0mEUgnkpQ9PU9X4jn09PTe2AAJCM6itbjfFiGo+EvPYlMcGyG
         mELMDtNYUia1+XICq9LRr1nyiNpkwH0O9JkXA9WiYKT2FXZmT/USeJNDDSD5srJC4xt4
         VC8Q==
X-Forwarded-Encrypted: i=1; AKwUvBxjuv2A3KuGMfN0h1ugG+/oQEB+EOE6Gl+X8bNd+LcX+iGTuDxkkmEZvIE4j7eorl/ExMg8ors=@lists.linux.dev
X-Gm-Message-State: AFq9FYKj4eohnWQqz5Baw4CdE8paTcL49WcO3ZrrnK+w5AuDhZF/Mps4
	P60eraHF1iMQIdGubTzPB8SvoxKPM/zRlK8762iMUbD5QBbfIzTW9r2XG6QQiYkFKxMxRT7dxKL
	SLMhmhPz7DJffTfuF3fY8t6ZAPQky40eoUtP08utvpYEPat76wnJ18PaV3g==
X-Gm-Gg: AYBFou0ChsN0oKkJa8DkCOoFRGARGyNJp8I1O9WfZjLJiF4SsVOfLMQi7fGKytd8/Cu
	U4GNbvPWdYECSF/0KBKzv8HrMuviBk2DPPm1FGs4QbRqbF7YLkDeOaae/TxHxa/rgYRSoRYggGB
	M55RXirNT89A4QIDz3svAY9Fi0RRV7OIhQtHK31i2yHv5GvTR8nVgjr6vIYkcEPz4oORyPrqd+4
	UcgyGDqf57G6XaX3XSiMt/KxiYJQ/OBsJ3TIxaQIgJzfNu702ozXTbs6U1s+bB2Dd6utzego1Hr
	XlTgsSuIl+UnAKQcHD0kvO5dKNoBLqp175Aq7To7mw0Kx5RxIraeivBdFk/v9C/RbyUaHTR2OBO
	wmaxj20T2wG61flAh9uMal5rbVVmsbBre1lyGOTtCnw==
X-Received: by 2002:a17:90b:58e8:b0:3a4:9b8b:2ab9 with SMTP id 98e67ed59e1d1-3a6ce34d7f8mr8521733a91.8.1791253477870;
        Mon, 05 Oct 2026 19:24:37 -0700 (PDT)
X-Received: by 2002:a17:90b:58e8:b0:3a4:9b8b:2ab9 with SMTP id 98e67ed59e1d1-3a6ce34d7f8mr8521712a91.8.1791253477385;
        Mon, 05 Oct 2026 19:24:37 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853cafddesm3352206a91.10.2026.10.05.19.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 19:24:36 -0700 (PDT)
Message-ID: <7f42005b-b840-4a5a-978d-18877bea3481@redhat.com>
Date: Tue, 6 Oct 2026 12:24:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 09/23] KVM: arm64: Prevent unsupported vcpu features
 for VM types
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
 <20261005090754.2140522-10-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-10-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GlCXrvAVfLemfyy2mqHvE6bz9toKZynnrTOxCfdSJDc_1791253478
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> Prevent unsupported VCPU features for the protected VCPUs. Realms and pVMs
> not support 32bit EL1 or NV yet. pKVM doesn't rely on the host vcpu
> features and it clears the unsupported features while hyp_vcpu is
> initialised. Block the features early in the vcpu init if we detect
> incompatible features.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 

One nitpick below. In either way:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f31d31fa27ad9..9c2ef7ca6a961 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1668,11 +1668,12 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>   	return -EINVAL;
>   }
>   
> -static unsigned long system_supported_vcpu_features(void)
> +static unsigned long system_supported_vcpu_features(struct kvm_vcpu *vcpu)
>   {
>   	unsigned long features = KVM_VCPU_VALID_FEATURES;
>   
> -	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
> +	if (vcpu_is_protected(vcpu) ||
> +	    !cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
>   		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
>   
>   	if (!kvm_supports_guest_pmuv3()) {
> @@ -1688,7 +1689,8 @@ static unsigned long system_supported_vcpu_features(void)
>   		clear_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features);
>   	}
>   
> -	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
> +	if (vcpu_is_protected(vcpu) ||
> +	    !cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>   		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
>   
>   	return features;
> @@ -1708,7 +1710,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>   			return -ENOENT;
>   	}
>   
> -	if (features & ~system_supported_vcpu_features())
> +	if (features & ~system_supported_vcpu_features(vcpu))
>   		return -EINVAL;
>  

The following check at the beginning of kvm_vcpu_init_check_features() is redundant to
the check here. We can drop that in this patch or a preparatory patch.

static int kvm_vcpu_init_check_features(...)
{
        /*
         * This check can be dropped since the same check has been done
	* by the followup "if (features & ~system_supported_vcpu_features(vcpu))"
         */
        if (features & ~KVM_VCPU_VALID_FEATURES)
                 return -ENOENT;
}

  
>   	/*

Thanks,
Gavin

