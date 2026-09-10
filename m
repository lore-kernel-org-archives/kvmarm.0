Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C53A3806D6
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 04:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012824; cv=none; b=YdrEL4zi9rX/o5uCZKydZVgbWJ1wuHqjke+Tp2X+V7ATGVijaVNra64zz3v7PuHSSJfwOFpdXf10UB24M/C+GtiKnAGdtSEOyycC/PQGbkiX8BBM2iFerj8Dzl4Aj8hSCYiqMB+LVTP4hUWI3ICZ6yO7E/G3eB+84UiTgyKqvJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012824; c=relaxed/simple;
	bh=pBqbGbHdUjToyCWJUAd59537eBPwlH2Z0Zl7h1xavv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nqAg+3u1S1etbX5f52AtQYwVRK11VAdYsajh+YkNtBRaNCiOnWYu36N01gE99gPiDHiNRhWMcOMaCRxisS+XhF1RiqUjrHmuqTPzEzAJaOLxNT+VhzZ65/s+htcQmThkF+LcDmo45nOb+tpWPM2pej3YXAuHrBbSp7urk7qczhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HHeQhTIk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HHeQhTIk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789012822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MZLtSduN3n4DstPQZClxNsj5BwxMrrkDzTkcMmPEOA=;
	b=HHeQhTIkmuESr+NZ+XPjh4G34hLdj1MTWpnRxq32YTmByWxGJWnwC7pcMXspxadyExJIj9
	s+VX0lwKbg2DIBZQp6GztmQ9+NRu/nAuMGi2RZwYWqyO/LmqChsIo2YOEfDhcq5FHZ8V4r
	5zN2I4m98SRAD9ClaZm6xgzsP59zakM=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-Z9EClkmdOTePWO1PPHp7RA-1; Thu, 10 Sep 2026 00:00:20 -0400
X-MC-Unique: Z9EClkmdOTePWO1PPHp7RA-1
X-Mimecast-MFC-AGG-ID: Z9EClkmdOTePWO1PPHp7RA_1789012819
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d9336581a2so110077335ad.3
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 21:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789012819; x=1789617619;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4MZLtSduN3n4DstPQZClxNsj5BwxMrrkDzTkcMmPEOA=;
        b=hfD1SA+1u99SZQ6W65ASTFo5Kj/QyQLyExvFdgMqgEWwSafgR2V4TRdQ3V86s1pSDr
         DdhowDxgv961XRIG8Pi+gtoH/8Z43m/CisYgB6qfwzIVeR+8U4hDPyYx8II2ABJuiD3C
         kXiKE12kd/dzak9p9pWfQN4DT9kwT7giCxxrI6KquQOy/ji8sbcOJCt7/ur5/KSgs5+h
         JrVWV1S8tKm5T7hPGjQPfKA64eglf740BV/XOaVmXT8hsODdJEoZZB91tQEtWWCMVu7P
         jMsL4b4c91ePaU2sZ4MYrHWyxnkrx7DeTh8JeDvbgBN1m5Bm6X8/f2R3z/N1MteyafG4
         mVoQ==
X-Forwarded-Encrypted: i=1; AKwUvBxHe/M16vFtTP44JMEdmn4R0+yciGc6HID6r5ODRJdyMSBKQti3msY1yDZjP6R6gn11JmAjTnk=@lists.linux.dev
X-Gm-Message-State: AFuF++lSDpakDARqelwh7AX0dl+9ZBzwuKSe3Ur6x+bshl+NHYQQ6VTT
	D2kJo4F8CQdIV83t13OEeXncWNxgvkueo0NFeeolNDXAA4Cuvb7PNDJbnO2bErBH1bGdiMYPjr6
	u51ls31tNwT3RFz0c+GGBQuHvwBAsAAI82p2DgS4I7DpBt2S17lQEdMNbAw==
X-Gm-Gg: AYBFou1KEKASdbzU8oqJlZRpDiFk/YU93d/ggr7HP9I/QnuPoKSLEDSvpMA0aKMfkby
	PEVDkZwdM5eiUlFeHWHFYS77Z4yZ4ZtpdrPq53gUJJsHlFrq64RyQ40ATpyDGli0CO+2aYTZH5p
	q7N87SKrRX3AMJwIEQgdIfHidYECyvKcYewJFR3GwpPGRfXybDLgv265CmgQSG8cJSWxwWYKg3P
	RkOM5ySX1ok/ik8gsX3/qcgwitKpqy7g+5abQNmcEb9T0/dzkUuh6+7lLN8Fo92SnAegkHMnGR9
	fg1sNs1rzqCyLVMjcwohrTr+3bKtwFSZcmsFlyi/vqXMwE5DeBy8Tr7j34299uZLy2PIS7Uy1su
	HL7SrfJBWCM+qLu0rto7JhrxpeTJaZuni2Z35O0g39w==
X-Received: by 2002:a17:902:ef44:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2db1259d1f8mr542225285ad.14.1789012819326;
        Wed, 09 Sep 2026 21:00:19 -0700 (PDT)
X-Received: by 2002:a17:902:ef44:b0:2cc:6018:f030 with SMTP id d9443c01a7336-2db1259d1f8mr542224465ad.14.1789012818867;
        Wed, 09 Sep 2026 21:00:18 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149ccf2esm82468805ad.73.2026.09.09.21.00.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 21:00:18 -0700 (PDT)
Message-ID: <a0c5c373-b5c2-4ad2-9e53-ede58c392972@redhat.com>
Date: Thu, 10 Sep 2026 14:00:06 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 04/20] KVM: arm64: Refactor the vcpu_load to allow for
 VM specific callbacks
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-5-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260908162223.1683432-5-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s7b-8cxlmmNqzlzN2eH1p2duWosj-IkltmnVVnm7ooM_1789012819
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Suzuki,

On 9/9/26 2:22 AM, Suzuki K Poulose wrote:
> Based on a work by Marc Zyngier
> 
> To keep the VCPU load/put handling cleaner with the different kinds of VM types,
> we are about to introduce VM specific callbacks to do just the right thing.
> In preparation for that, make some refactoring to add the change easier.
> 
> No functional changes intended.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 46 +++++++++++++++++++++++++++-----------------
>   1 file changed, 28 insertions(+), 18 deletions(-)
> 

Nitpicks below, none of them are introduced by this patch itself. In either way:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 67f1ff9bc4fbe..51fc651267157 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -683,14 +683,11 @@ static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
>   	return single_task_running();
>   }
>   
> -void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +static void vcpu_prepare_mmu(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_s2_mmu *mmu;
>   	int *last_ran;
>   
> -	if (is_protected_kvm_enabled())
> -		goto nommu;
> -
>   	if (vcpu_has_nv(vcpu))
>   		kvm_vcpu_load_hw_mmu(vcpu);
>   
> @@ -720,10 +717,33 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
>   		*last_ran = vcpu->vcpu_idx;
>   	}
> +}
> +
> +static void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_vcpu_should_clear_twe(vcpu))
> +		vcpu->arch.hcr_el2 &= ~HCR_TWE;
> +	else
> +		vcpu->arch.hcr_el2 |= HCR_TWE;
> +
> +	if (kvm_vcpu_should_clear_twi(vcpu))
> +		vcpu->arch.hcr_el2 &= ~HCR_TWI;
> +	else
> +		vcpu->arch.hcr_el2 |= HCR_TWI;
> +}
> +

It seems FIELD_MODIFY() can be applied here if no visible constraints exist:

	FIELD_MODIFY(HCR_TWE, vcpu->arch.hcr_el2, !kvm_vcpu_should_clear_twe(vcpu));
	FIELD_MODIFY(HCR_TWI, vcpu->arch.hcr_el2, !kvm_vcpu_should_clear_twi(vcpu));

> +static void vcpu_load_pvtime(struct kvm_vcpu *vcpu)
> +{
> +	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> +		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> +}
> +
> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	if (!is_protected_kvm_enabled())
> +		vcpu_prepare_mmu(vcpu);
>  

I think we probably try to depend on kvm->arch.vm_flavor instead
of !is_protected_kvm_enabled().

	struct kvm *kvm = vcpu->kvm;

	if (kvm_vm_is_protected(kvm) || kvm_vm_flavor_eq(kvm, VM_PKVM))
		vcpu_prepare_mmu(vcpu);
  
> -nommu:
>   	vcpu->cpu = cpu;
> -
>   	/*
>   	 * The timer must be loaded before the vgic to correctly set up physical
>   	 * interrupt deactivation in nested state (e.g. timer interrupt).
> @@ -736,19 +756,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>   		kvm_vcpu_load_vhe(vcpu);
>   	kvm_arch_vcpu_load_fp(vcpu);
>   	kvm_vcpu_pmu_restore_guest(vcpu);
> -	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
> -		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
> -
> -	if (kvm_vcpu_should_clear_twe(vcpu))
> -		vcpu->arch.hcr_el2 &= ~HCR_TWE;
> -	else
> -		vcpu->arch.hcr_el2 |= HCR_TWE;
> -
> -	if (kvm_vcpu_should_clear_twi(vcpu))
> -		vcpu->arch.hcr_el2 &= ~HCR_TWI;
> -	else
> -		vcpu->arch.hcr_el2 |= HCR_TWI;
>   
> +	vcpu_load_pvtime(vcpu);
> +	vcpu_set_wfx_traps(vcpu);
>   	vcpu_set_pauth_traps(vcpu);
>   
>   	if (is_protected_kvm_enabled()) {

Thanks,
Gavin

