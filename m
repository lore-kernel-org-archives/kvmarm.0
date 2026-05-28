Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026692EA172
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 04:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941264; cv=none; b=NoCSrHxsQu+Y4hEA+MCB5daiAvtBerkmn1nTp5w467N73rTYoCgo64I46+9gHUBivCwFy5WjnJyH4yNzgSjuOKnLczR6slpNNImWGp2JXWwXite5ke1+xHdeWSkby8vRwZ1muKqEewe6zdUrzgYRwEOSVxVoQ6m+9oG3yjo6a+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941264; c=relaxed/simple;
	bh=cU9MrMDCM5kbfai4cHhsGBkpS8gyY3/6wYuHRs6bx2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uzZY1bgLluUYPjo0cSUhoCWA5AF5sP13QXyFGgacTL5A7ePAHsKFGlORIRZOByYl0R5E+Tdxijhms+Ge2/uJ8vh3XYeBBoQ8lw4xRe6EWXkJQGhvjjQGZBprf1CBdp9ySQkdAAqFCxrOD/muA7wim6I6YzburLYL/TIQVwPc1rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISMa+96Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISMa+96Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779941262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1I8KzNpXq63WE4CP85HoO7zZcc0AvIs01nVPYeq3DW0=;
	b=ISMa+96ZeHZUdBNli90Ih7fKFQCb4SszJ8p6hebdcQ42XBqfiaY6gR2TfUBOqgIL8cCZAT
	XBNuE4mMYKEDPFJNirGqmpuVbi8t+YFPjveB1uczM1drhjwbgFOY/b1vEzBe82aw/0cPF6
	F3r6lKPzkM0FUFrbi7OdsYioh432xTM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-rajOeMrxNOCMnOyCfvXruQ-1; Thu, 28 May 2026 00:07:40 -0400
X-MC-Unique: rajOeMrxNOCMnOyCfvXruQ-1
X-Mimecast-MFC-AGG-ID: rajOeMrxNOCMnOyCfvXruQ_1779941259
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c8294d8c48eso7991057a12.0
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 21:07:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779941259; x=1780546059;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1I8KzNpXq63WE4CP85HoO7zZcc0AvIs01nVPYeq3DW0=;
        b=o9MW0jMCP0pYDhho0SYEY5Lf7ZsKDwE64EsxwImKzDjyyzj+nDuTyZGygJqeohIXfh
         LLR2jmE4Ed1M0VFNPnnSm4lVD/M2jkXG+ys81tnNVskxHX6UetvsZ6UvSEky4r9WMJHy
         E5p7oStT3WrmnbdLoAKZYwfXWNDhvvuRX/YOVE3Kl7TRFOQAvhzZZdHEKm4LsDDeIuCq
         ikbKS7hi4BI8yik19fcByyRaqk5+vEF3Hi5ix5IhLyB65gXlnabAp+HnF5a/kTn1yUQC
         TviK9+vNZblfxHvmNreJjZQJCWRj/9gfPest/S0LHqR4QGVqmrlSffvyhKD5vHfA+QV9
         P8hg==
X-Forwarded-Encrypted: i=1; AFNElJ+b6hLdvDvViAKR/wP8RKqNXRmmF4uHztH/jnxhiD17LxdcuglSEzKRBbFseT9TdB+ba8I18LY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSL2rCKAG5Xn9oIq49ZIWWZm231TObf3gdp4/Qulhz7hbQRV6P
	2b6hv+KhV42U8R64hw8OJQxOCBvQGnjIXnMTy+8nV8GvN0RYto3ANs+ajh2J8VuEm55hk5++zWU
	7+BeYHfuve4nKN9q1DwENGXh6QhgzIs6rqf7WxFNEg+K43Pds+/yxYdJpRw==
X-Gm-Gg: Acq92OGf3GDY240rg5iz77OV122nk5hDM7U3jazO4XpBmP+K7ziKgEBA6S/vMDEXtIq
	JjSajD1uD1CeW2/NTgmVEQM7tOy/Nuur5ilDYbwjIjxpPWkCCY9VK+mowiRYEKvCFlO0cwL4MfW
	Jvgagr+iUfkj/P+nK/INNPCzD3mVjMpvuoxqgx4CaHY1Qr+yn6n6ApTWOnPKlzCrXWKnth9mMJy
	D9h9d8NJfo1K0jO/rTEOqGT/NjxBr9kptzuqx+7NWToN8u8+FiNFDkWqEiiFXmlPdJCvLbb0PEj
	6/St0VHg32WjZiyp3XV074k5QvRnRF23hLZjr1JEShRrEqcGj0iCuNMVqmVA2DWSiPQ/8DONc1E
	akIK0gm8e7jbjoXHhVTWkxypUHfHHu300WBNuHfpBUGOPXcsjLfkCe6vfrN7mrjLYmHu9Im04cm
	k=
X-Received: by 2002:a05:6a00:194f:b0:837:acd7:a78 with SMTP id d2e1a72fcca58-8415f329ac5mr24016488b3a.16.1779941259205;
        Wed, 27 May 2026 21:07:39 -0700 (PDT)
X-Received: by 2002:a05:6a00:194f:b0:837:acd7:a78 with SMTP id d2e1a72fcca58-8415f329ac5mr24016447b3a.16.1779941258714;
        Wed, 27 May 2026 21:07:38 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d7300ea4sm3790751b3a.56.2026.05.27.21.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 21:07:37 -0700 (PDT)
Message-ID: <5ea74b6a-a51a-415e-b53f-5ece9829dee8@redhat.com>
Date: Thu, 28 May 2026 14:07:27 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 20/44] arm64: RMI: Support for the VGIC in realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>, Vishal Annapurve
 <vannapurve@google.com>, WeiLin.Chang@arm.com, Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-21-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-21-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y0ypO3YOS4pQtoK2j3wLCtc5gqi6HiMmxFsIBeF3SuM_1779941259
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 5/13/26 11:17 PM, Steven Price wrote:
> The RMM provides emulation of a VGIC to the realm guest. With RMM v2.0
> the registers are passed in the system registers so this works similar
> to a normal guest, but kvm_arch_vcpu_put() need reordering to early out,
> and realm guests don't support GICv2 even if the host does.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v12:
>   * GIC registers are now passed in the system registers rather than via
>     rec_entry/rec_exit which removes most of the changes.
> Changes from v11:
>   * Minor changes to align with the previous patches. Note that the VGIC
>     handling will change with RMM v2.0.
> Changes from v10:
>   * Make sure we sync the VGIC v4 state, and only populate valid lrs from
>     the list.
> Changes from v9:
>   * Copy gicv3_vmcr from the RMM at the same time as gicv3_hcr rather
>     than having to handle that as a special case.
> Changes from v8:
>   * Propagate gicv3_hcr to from the RMM.
> Changes from v5:
>   * Handle RMM providing fewer GIC LRs than the hardware supports.
> ---
>   arch/arm64/kvm/arm.c            | 11 ++++++++---
>   arch/arm64/kvm/vgic/vgic-init.c |  2 +-
>   2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 93d34762db91..21d9dfdb1ea0 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -786,19 +786,24 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
>   	}
>   
> +	kvm_timer_vcpu_put(vcpu);
> +	kvm_vgic_put(vcpu);
> +
> +	vcpu->cpu = -1;
> +
> +	if (vcpu_is_rec(vcpu))
> +		return;
> +

For a REC, kvm_vcpu_{load, put}_debug() becomes unbalanced in kvm_arch_vcpu_{load, put}().
kvm_vcpu_load_debug() is called in kvm_arch_vcpu_load(), but kvm_vcpu_put_debug() won't
be called in kvm_arch_vcpu_put() after this whole series is applied.

>   	kvm_vcpu_put_debug(vcpu);
>   	kvm_arch_vcpu_put_fp(vcpu);
>   	if (has_vhe())
>   		kvm_vcpu_put_vhe(vcpu);
> -	kvm_timer_vcpu_put(vcpu);
> -	kvm_vgic_put(vcpu);
>   	kvm_vcpu_pmu_restore_host(vcpu);
>   	if (vcpu_has_nv(vcpu))
>   		kvm_vcpu_put_hw_mmu(vcpu);
>   	kvm_arm_vmid_clear_active();
>   
>   	vcpu_clear_on_unsupported_cpu(vcpu);
> -	vcpu->cpu = -1;
>   }
>   
>   static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 933983bb2005..a9db963dfd23 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -81,7 +81,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>   	 * the proper checks already.
>   	 */
>   	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 &&
> -		!kvm_vgic_global_state.can_emulate_gicv2)
> +	    (!kvm_vgic_global_state.can_emulate_gicv2 || kvm_is_realm(kvm)))
>   		return -ENODEV;
>   
>   	/*

Thanks,
Gavin

