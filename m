Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1D82594
	for <kvmarm@lists.linux.dev>; Sun,  2 Feb 2025 02:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738462019; cv=none; b=Sc9TmdpPpDWAZMvJJiEkeK0wE2patXXWkMzpNZyYan9lJSURE63swUzWyO3ql85EUeFoBfd64AU3N+1nnYCs6bUm8VMPy8E4BgIrCYaqb7XvpeHFSRndmDIHcRLdXo+/mG3u+DvKyOW+ffXvDNNvBRG/mJ9Rqd8ybNPXoFaKbJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738462019; c=relaxed/simple;
	bh=Cv+rYeVYUucgFkd9j+IahXxjPtJ2f4F7GoUBqwxuulM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O+QcAGCmOp/bvo1gb03AXLjk7QQZcVFcvVm4JoQIs/OIrq1C38euv5mgZ3kpavv22nLOepqI1MfBPcUobjJyIXeUXyBrLpGPL1L6z2g9kF7C25+r9RBMN+OWasdzaYdwUN7/NCvmw6QD65HIBcXxVzGybVMrRX2VebRupvkcYGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Svt9dxlB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Svt9dxlB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738462016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sSlKml/+kejUBtq+rKq08KSBVq8nnU94jjP3M+wY8SY=;
	b=Svt9dxlB1OTozFWZn6cwH9d2ra/FbtLYpwIgjJCv3Lie7ZGkOv98Ku77Yf6UMrrD8Eu2dj
	QTeK1JnsFDD8Igii5zKdHM16Nz506pbiU7TYeURMDDh31G5VsN9ig7WdtChwSs6iWJmeCG
	Ox3HeGp9Rn2c1n9f4/wj3GktwuTeByQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-V_Yd5CLDOayLzUUvk_p0RA-1; Sat, 01 Feb 2025 21:06:55 -0500
X-MC-Unique: V_Yd5CLDOayLzUUvk_p0RA-1
X-Mimecast-MFC-AGG-ID: V_Yd5CLDOayLzUUvk_p0RA
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-216266cc0acso72916505ad.0
        for <kvmarm@lists.linux.dev>; Sat, 01 Feb 2025 18:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738462014; x=1739066814;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sSlKml/+kejUBtq+rKq08KSBVq8nnU94jjP3M+wY8SY=;
        b=DdKiSHvB4/+L2H2O+5diLoNbEAyR7YOURJFFRBaM9hc8vQ2EU655ftM5Wo/7MLjlP/
         iYf5ao3D/kLypAk4rMJGIKrA63skGYTzN6agcd4Fr1Gpfe9RQMijxRM11VwPzcgYqK55
         v/zVZAkbQCxX7lROhmoPbPKtWwQ6rPgJA8ofYH3aCjrszPYYJXHAXSeIZKpOCl3SXIQA
         rWAOsS0GXGaTkjWXOTl9wwf/h8x3+e+ypsXzMqXwjQrzPj5dgq7b27080Os6mle7oz30
         YVF/zs+HOIDlwsb8GRTZdLkDJmiyTRTuVsGG7kdcq/MG1wtuLulxwWwb0s6F8+TBMKFK
         Dz3w==
X-Forwarded-Encrypted: i=1; AJvYcCWeFUsH/okRrtDdgTXFVAF1qltaX3CsaDNGgTPCst1UADSjzywSFlhD/pz/JEhcn0Y6db9Bw2M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwNZxI5p1ltDaiGT6tIf+LRpXi3IWLmvOdAwMdbCh0O8mhU1an
	H09O3nIcQx56g2X5kU94Ry7nVYnDUHMghUP5Ml/YA6RVgxfF62FvZg5AOgqPtLkMguigRrLCJJf
	GC6ea3TdnAG34PtlhntNhAcQCqPFk6whzUNCV4prywSiqzJdP2fxLUA==
X-Gm-Gg: ASbGncvHJ5m6hQ59iXLEOVBIkgiG3wgggn9JzCcBq49ut9XoDEhpk/hHIuClF5P6Fhd
	PQ3f2AKB8bcjMCNGFIEEvK2J7cAGaqFKMSGFVGf2F8tXkoOdxhvX91GaBMDK/CWxfRS+x/PhpYL
	JwEr4E/9dwPHXm/OSn2/trDk+LJ8lI0titUcDy4ZHB7/qOU4QhJCfeo5fCSCmtTEVf7VMgHbpAv
	Sr4/fXZeyLNb1GygffId5NAmBPQJUWk9t8ELUHSJwRRrVB/APQYxCIO8cu9uDDKSJgBRNBEz1nP
	0pqc5A==
X-Received: by 2002:a05:6300:7111:b0:1ed:a4b1:9124 with SMTP id adf61e73a8af0-1eda4b195bcmr6482946637.8.1738462014134;
        Sat, 01 Feb 2025 18:06:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuAmakbdVZEYfdxlzFY/5lw1yKumpAmcjFfn5o/6n2SOgtQbAy8hTNJJ7loIVoDWvimSAuIQ==
X-Received: by 2002:a05:6300:7111:b0:1ed:a4b1:9124 with SMTP id adf61e73a8af0-1eda4b195bcmr6482907637.8.1738462013708;
        Sat, 01 Feb 2025 18:06:53 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe631bf29sm5625326b3a.20.2025.02.01.18.06.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 18:06:53 -0800 (PST)
Message-ID: <489025af-a0c3-449f-a746-f898b77fc660@redhat.com>
Date: Sun, 2 Feb 2025 12:06:44 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 23/43] KVM: arm64: Handle Realm PSCI requests
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-24-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-24-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w7JnhlhT9pG-kVgWMp8ds9o12jlG-yAzwQe14DREfcU_1738462014
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> The RMM needs to be informed of the target REC when a PSCI call is made
> with an MPIDR argument. Expose an ioctl to the userspace in case the PSCI
> is handled by it.
> 
> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/kvm_rme.h |  3 +++
>   arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
>   arch/arm64/kvm/psci.c            | 29 +++++++++++++++++++++++++++++
>   arch/arm64/kvm/rme.c             | 15 +++++++++++++++
>   4 files changed, 72 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 158f77e24a26..90a4537ad38d 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -113,6 +113,9 @@ int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>   			unsigned long addr, unsigned long end,
>   			unsigned long ripas,
>   			unsigned long *top_ipa);
> +int realm_psci_complete(struct kvm_vcpu *calling,
> +			struct kvm_vcpu *target,
> +			unsigned long status);
>   

The 'calling' may be renamed to 'source', consistent to the names in arch/arm64/kvm/psci.c.
Other nitpicks can be found below.

>   #define RMM_RTT_BLOCK_LEVEL	2
>   #define RMM_RTT_MAX_LEVEL	3
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f588b528c3f9..eff1a4ec892b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1745,6 +1745,22 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>   	return __kvm_arm_vcpu_set_events(vcpu, events);
>   }
>   
> +static int kvm_arm_vcpu_rmm_psci_complete(struct kvm_vcpu *vcpu,
> +					  struct kvm_arm_rmm_psci_complete *arg)
> +{
> +	struct kvm_vcpu *target = kvm_mpidr_to_vcpu(vcpu->kvm, arg->target_mpidr);
> +
> +	if (!target)
> +		return -EINVAL;
> +
> +	/*
> +	 * RMM v1.0 only supports PSCI_RET_SUCCESS or PSCI_RET_DENIED
> +	 * for the status. But, let us leave it to the RMM to filter
> +	 * for making this future proof.
> +	 */
> +	return realm_psci_complete(vcpu, target, arg->psci_status);
> +}
> +
>   long kvm_arch_vcpu_ioctl(struct file *filp,
>   			 unsigned int ioctl, unsigned long arg)
>   {
> @@ -1867,6 +1883,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>   
>   		return kvm_arm_vcpu_finalize(vcpu, what);
>   	}
> +	case KVM_ARM_VCPU_RMM_PSCI_COMPLETE: {
> +		struct kvm_arm_rmm_psci_complete req;
> +
> +		if (!kvm_is_realm(vcpu->kvm))
> +			return -EINVAL;

We probably need to check with vcpu_is_rec(). -EPERM seems more precise
than -EINVAL.

> +		if (copy_from_user(&req, argp, sizeof(req)))
> +			return -EFAULT;
> +		return kvm_arm_vcpu_rmm_psci_complete(vcpu, &req);
> +	}
>   	default:
>   		r = -EINVAL;
>   	}
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 3b5dbe9a0a0e..9dc161abc30c 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -103,6 +103,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>   
>   	reset_state->reset = true;
>   	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
> +	/*
> +	 * Make sure we issue PSCI_COMPLETE before the VCPU can be
> +	 * scheduled.
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		realm_psci_complete(source_vcpu, vcpu, PSCI_RET_SUCCESS);
>   
>   	/*
>   	 * Make sure the reset request is observed if the RUNNABLE mp_state is
> @@ -115,6 +121,10 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>   
>   out_unlock:
>   	spin_unlock(&vcpu->arch.mp_state_lock);
> +	if (vcpu_is_rec(vcpu) && ret != PSCI_RET_SUCCESS)
> +		realm_psci_complete(source_vcpu, vcpu,
> +				    ret == PSCI_RET_ALREADY_ON ?
> +				    PSCI_RET_SUCCESS : PSCI_RET_DENIED);

{} is needed here.

>   	return ret;
>   }
>   
> @@ -142,6 +152,25 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
>   	/* Ignore other bits of target affinity */
>   	target_affinity &= target_affinity_mask;
>   
> +	if (vcpu_is_rec(vcpu)) {
> +		struct kvm_vcpu *target_vcpu;
> +
> +		/* RMM supports only zero affinity level */
> +		if (lowest_affinity_level != 0)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		target_vcpu = kvm_mpidr_to_vcpu(kvm, target_affinity);
> +		if (!target_vcpu)
> +			return PSCI_RET_INVALID_PARAMS;
> +
> +		/*
> +		 * Provide the references of running and target RECs to the RMM
                                              ^^^^^^^
                                              the source
> +		 * so that the RMM can complete the PSCI request.
> +		 */
> +		realm_psci_complete(vcpu, target_vcpu, PSCI_RET_SUCCESS);
> +		return PSCI_RET_SUCCESS;
> +	}
> +
>   	/*
>   	 * If one or more VCPU matching target affinity are running
>   	 * then ON else OFF
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 146ef598a581..5831d379760a 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -118,6 +118,21 @@ static void free_delegated_granule(phys_addr_t phys)
>   	free_page((unsigned long)phys_to_virt(phys));
>   }
>   
> +int realm_psci_complete(struct kvm_vcpu *calling, struct kvm_vcpu *target,
> +			unsigned long status)
> +{
> +	int ret;
> +
> +	ret = rmi_psci_complete(virt_to_phys(calling->arch.rec.rec_page),
> +				virt_to_phys(target->arch.rec.rec_page),
> +				status);
> +
         ^^^^^
Unnecessary blank line.

> +	if (ret)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>   static int realm_rtt_create(struct realm *realm,
>   			    unsigned long addr,
>   			    int level,

Thanks,
Gavin

