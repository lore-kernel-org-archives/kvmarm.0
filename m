Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B880463CB
	for <kvmarm@lists.linux.dev>; Mon, 22 Dec 2025 21:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766438134; cv=none; b=fvs3tbaUp7UGF8iLXDEeFXU8G9A18aiKEwQp0k9YHmsi7LV89YJc7NK0mphuUQsmg0/q0YCh1hwIK5LFi1dn82rUswAZKT417RdvnxJnspGut/VyL1yCXEcBvEuB4DQ3bY6V2ciBSPUMacD2e5bgumbVUit868tkHDNL1ybeOoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766438134; c=relaxed/simple;
	bh=gt2+gbr0Rr3/ZKVX/mRSE7VaDu/eLWRrAsUon5ebFjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orMSjQIuMtAmul1qTMh09sLjq87m+x+0tzj91PZBg0zlW6KEkffnIPuXaSpaZHAmvb6Ofa1n/Bd4SWxiyvFG3ed2PZKh7z3WHxqQj9cLwUdnEGXWQVBm+FMgTzDgniUib8MI8xgJozd1dDhhenO5lznWCbOT+J0Uzsw4aJ7HW0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7s68lCn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7s68lCn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766438131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hGgqNnCcIlK6O6UZtBY/uqPnbx31kFCOOSmL+KY7Kb8=;
	b=Z7s68lCnXxebRpUfaoT5N1yccPB6mUw0/7CfQpayaIUhPa5miLblhIwzK5fn2JrEp3CsYk
	7+9zclE5SrshCe3uGzn9fV0qkSHeYo4J23I8BDtMsZMeGoJ3FiOC+UuNI1wbld5aNJYJh4
	/8wPGB0Bg4LcKngxuCXgYeniUMhCDys=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-2hqaVmu3Nj6rp4hcyOH1Ew-1; Mon, 22 Dec 2025 16:15:29 -0500
X-MC-Unique: 2hqaVmu3Nj6rp4hcyOH1Ew-1
X-Mimecast-MFC-AGG-ID: 2hqaVmu3Nj6rp4hcyOH1Ew_1766438129
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f5dcd4d3so2470194f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 22 Dec 2025 13:15:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766438128; x=1767042928;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGgqNnCcIlK6O6UZtBY/uqPnbx31kFCOOSmL+KY7Kb8=;
        b=J8lLcYbH8LXrJR8Mlma6iPRAehA5sRRawl73JMcEFg/yZZfJ7lkotDtS5zddH3RVv1
         pJAvZ5kWS/omVTQDJ904ANyN37dAVqE1c9SjPfxmYtKkZLdQqz50Hj9XTmnFYufw3cmi
         wNM8koFsdccRixZiNHRbK2dyRkGpdDbVoru0WwlgHvjI6y2zWiIVrxpF7X9rUMJQVpvf
         gTjNBVaXw9wcHeCCbSeqM+w0LCTkpL5vYjqqUZgr2Pzg7A0wQn+Lq9IwynDHNwDPX2i/
         nRssSy5ZPZADL4a54vTK3ZYbzhxilIgH6eiJn4Ys/gPlnzP2GuOzl61DIm9akXTmDvvH
         RTTA==
X-Forwarded-Encrypted: i=1; AJvYcCXrQBGNiC1rlMoeJZ4xf09Yvzd6XjmHHSjwKxLOqRDWmU39yoLVB6jtOTJIHyB4qwkejMVHRec=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmPahTT4YeqFbYoCeK7evCptL92EPSi7Pk3Xz1j2l0p0mOTamg
	ojPpd+rmlfKRP6tUdnCcKCOnE8iPLzQhNuTYJDBe3+jRldoUZIy3dGZpJqw8LW9IMrLTUtOBvK9
	8STUSBv6xhgl8tjbIatHhYPVbe9OwOJQdwuXv+2dbtkqMd1xxbDHsMcLV6g==
X-Gm-Gg: AY/fxX5RYDcJ1S6U92DnhFh2F7HlgkQFonlOfQq+kPQDN2N+Zm8XqyqStFT9PvQpCVz
	P5fWa/KlL2RdJXXxQG6lB51fxKBs/rNbfYKGyL3TMUC4UMCdZEiXke4FZBreNhwsbrMUF0ITf8R
	9daF0n6NINd+J8vsq0X6nBV7qxQsoKRJjWEbNzE1TRbAsZQS1b2iUDMRxxndDJghUqRpiYfDsy3
	nQOoT8lPe+nxd2APJroZRvpq7AZfLLRs1jZzMDto9/ziFN2EETWRdOidKX0+SFsRmpx8I73aBjf
	2gEr0ekxZ9uuNPowxhRuLFE8ORbZZIozSd1n20aowZnI1e0dQBIkkqcPdaPgq8gfv1jZWN8jR/2
	BUtRsezxUrgUM76d6EstDpbbwORDIJbCh4VickpU054FkYVTxe7RyALODQa94SX106+EBmnyBy4
	vJcEzAa8NcI01+4dE=
X-Received: by 2002:a05:6000:2005:b0:430:2773:84d6 with SMTP id ffacd0b85a97d-4324e42eb06mr15161090f8f.24.1766438128532;
        Mon, 22 Dec 2025 13:15:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtKWd3fhFVkAD8rfMCbV/3P0qgteV/laG1yOBcezVtOY09fNJ59Cu8NulVEL/sNj6pv2Y5CA==
X-Received: by 2002:a05:6000:2005:b0:430:2773:84d6 with SMTP id ffacd0b85a97d-4324e42eb06mr15161058f8f.24.1766438127969;
        Mon, 22 Dec 2025 13:15:27 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4325dacae0esm13545669f8f.12.2025.12.22.13.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 13:15:27 -0800 (PST)
Message-ID: <9218dafc-c6ad-4ef3-b869-2d6d4a308181@redhat.com>
Date: Mon, 22 Dec 2025 22:15:24 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: possible deadlock due to irq_set_thread_affinity() calling into
 the scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
To: Sean Christopherson <seanjc@google.com>
Cc: Ankit Soni <Ankit.Soni@amd.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 David Matlack <dmatlack@google.com>, Naveen Rao <Naveen.Rao@amd.com>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
 <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
 <aUmdSb3d7Z5REMLk@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aUmdSb3d7Z5REMLk@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RIp83M3d-rLqNP1Cv_EhQVtdgQA__yD0OFa_cnirCyc_1766438129
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 20:34, Sean Christopherson wrote:
> On Mon, Dec 22, 2025, Paolo Bonzini wrote:
>> On 12/22/25 10:16, Ankit Soni wrote:
>>>     - Is this lockdep warning expected/benign in this code path, or does it
>>>       indicate a real potential deadlock between svm->ir_list_lock and
>>>       irq_desc_lock with AVIC + irq_bypass + VFIO?
>>
>> I'd treat it as a potential (if unlikely) deadlock:
>>
>> (a) irq_set_thread_affinity triggers the scheduler via wake_up_process,
>> while irq_desc->lock is taken
>>
>> (b) the scheduler calls into KVM with rq_lock taken, and KVM uses
>> ir_list_lock within __avic_vcpu_load/__avic_vcpu_put
>>
>> (c) KVM wants to block scheduling for a while and uses ir_list_lock for
>> that purpose, but then irq_set_vcpu_affinity takes irq_desc->lock.
>>
>> I don't think there's an alternative choice of lock for (c); and there's
>> no easy way to pull the irq_desc->lock out of the IRQ subsystem--in fact
>> the stickiness of the situation comes from rq->rq_lock and
>> irq_desc->lock being both internal and not leaf.
>>
>> Of the three, the most sketchy is (a);
> 
> Maybe the most unnecessary, but I think there's a pretty strong argument that
> (d) is the most sketchy:
> 
>    (d) KVM takes svm->ir_list_lock around the call to irq_set_vcpu_affinity()

That's (c). :)

I called irq_set_thread_affinity() sketchy, because it's a core kernel 
subsystem that takes a pretty common lock, and directly calls a function 
that takes another very common lock.  KVM's deadlock scenario seems like 
a relatively natural occurrence, though in this case it can be fixed 
outside kernel/irq as well.

>> notably, __setup_irq() calls wake_up_process outside desc->lock.  Therefore
>> I'd like so much to treat it as a kernel/irq/ bug; and the simplest (perhaps
>> too simple...) fix is to drop the wake_up_process().  The only cost is extra
>> latency on the next interrupt after an affinity change.
> 
> Alternatively, what if we rework the KVM<=>IOMMU exchange to decouple updating
> the IRTE from binding the metadata to the vCPU?  KVM already has the necessary
> exports to do "out-of-band" updates due to the AVIC architecture requiring IRTE
> updates on scheduling changes.

In fact this was actually my first idea, exactly because it makes
svm->ir_list_lock a leaf lock!

I threw it away because it makes amd_ir_set_vcpu_affinity() weird, 
passing back the ir_data but not really doing anything else.  Basically 
its role becomes little more than violate abstractions, which seemed 
wrong.  On the other hand, drivers/iommu is already very much tied to 
the KVM vendor modules (in particular avic.c already calls 
amd_iommu_{,de}activate_guest_mode), so who am I to judge what the IOMMU 
driver does.

Paolo

> It's a bit wonky (and not yet tested), but I like the idea of making
> svm->ir_list_lock a leaf lock so that we don't end up with a game of whack-a-mole,
> e.g. if something in the IRQ subsystem changes in the future.
> 
> ---
>   arch/x86/include/asm/irq_remapping.h |  3 --
>   arch/x86/kvm/svm/avic.c              | 78 ++++++++++++++++++----------
>   drivers/iommu/amd/iommu.c            | 24 +++------
>   3 files changed, 57 insertions(+), 48 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
> index 4e55d1755846..1426ecd09943 100644
> --- a/arch/x86/include/asm/irq_remapping.h
> +++ b/arch/x86/include/asm/irq_remapping.h
> @@ -35,9 +35,6 @@ struct amd_iommu_pi_data {
>   	u64 vapic_addr;		/* Physical address of the vCPU's vAPIC. */
>   	u32 ga_tag;
>   	u32 vector;		/* Guest vector of the interrupt */
> -	int cpu;
> -	bool ga_log_intr;
> -	bool is_guest_mode;
>   	void *ir_data;
>   };
>   
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6b77b2033208..0f4f353c7db6 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -868,6 +868,51 @@ static void svm_ir_list_del(struct kvm_kernel_irqfd *irqfd)
>   	raw_spin_unlock_irqrestore(&to_svm(vcpu)->ir_list_lock, flags);
>   }
>   
> +static int avic_pi_add_irte(struct kvm_kernel_irqfd *irqfd, void *ir_data,
> +			    struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	int r;
> +
> +	/*
> +	 * Prevent the vCPU from being scheduled out or migrated until the IRTE
> +	 * is updated and its metadata has been added to the list of IRQs being
> +	 * posted to the vCPU, to ensure the IRTE isn't programmed with stale
> +	 * pCPU/IsRunning information.
> +	 */
> +	guard(raw_spinlock_irqsave)(&svm->ir_list_lock);
> +
> +	if (kvm_vcpu_apicv_active(vcpu)) {
> +		u64 entry = svm->avic_physical_id_entry;
> +		bool ga_log_intr;
> +		int cpu;
> +
> +		/*
> +		 * Update the target pCPU for IOMMU doorbells if the vCPU is
> +		 * running.  If the vCPU is NOT running, i.e. is blocking or
> +		 * scheduled out, KVM will update the pCPU info when the vCPU
> +		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
> +		 */
> +		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK) {
> +			cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
> +			ga_log_intr = false;
> +		} else {
> +			cpu = -1;
> +			ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
> +		}
> +		r = amd_iommu_activate_guest_mode(ir_data, cpu, ga_log_intr);
> +	} else {
> +		r = amd_iommu_deactivate_guest_mode(ir_data);
> +	}
> +
> +	if (r)
> +		return r;
> +
> +	irqfd->irq_bypass_data = ir_data;
> +	list_add(&irqfd->vcpu_list, &svm->ir_list);
> +	return 0;
> +}
> +
>   int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			unsigned int host_irq, uint32_t guest_irq,
>   			struct kvm_vcpu *vcpu, u32 vector)
> @@ -888,36 +933,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   		struct amd_iommu_pi_data pi_data = {
>   			.ga_tag = AVIC_GATAG(to_kvm_svm(kvm)->avic_vm_id,
>   					     vcpu->vcpu_idx),
> -			.is_guest_mode = kvm_vcpu_apicv_active(vcpu),
>   			.vapic_addr = avic_get_backing_page_address(to_svm(vcpu)),
>   			.vector = vector,
>   		};
> -		struct vcpu_svm *svm = to_svm(vcpu);
> -		u64 entry;
>   		int ret;
>   
> -		/*
> -		 * Prevent the vCPU from being scheduled out or migrated until
> -		 * the IRTE is updated and its metadata has been added to the
> -		 * list of IRQs being posted to the vCPU, to ensure the IRTE
> -		 * isn't programmed with stale pCPU/IsRunning information.
> -		 */
> -		guard(raw_spinlock_irqsave)(&svm->ir_list_lock);
> -
> -		/*
> -		 * Update the target pCPU for IOMMU doorbells if the vCPU is
> -		 * running.  If the vCPU is NOT running, i.e. is blocking or
> -		 * scheduled out, KVM will update the pCPU info when the vCPU
> -		 * is awakened and/or scheduled in.  See also avic_vcpu_load().
> -		 */
> -		entry = svm->avic_physical_id_entry;
> -		if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK) {
> -			pi_data.cpu = entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
> -		} else {
> -			pi_data.cpu = -1;
> -			pi_data.ga_log_intr = entry & AVIC_PHYSICAL_ID_ENTRY_GA_LOG_INTR;
> -		}
> -
>   		ret = irq_set_vcpu_affinity(host_irq, &pi_data);
>   		if (ret)
>   			return ret;
> @@ -932,9 +952,11 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   			return -EIO;
>   		}
>   
> -		irqfd->irq_bypass_data = pi_data.ir_data;
> -		list_add(&irqfd->vcpu_list, &svm->ir_list);
> -		return 0;
> +		ret = avic_pi_add_irte(irqfd, pi_data.ir_data, vcpu);
> +		if (WARN_ON_ONCE(ret))
> +			irq_set_vcpu_affinity(host_irq, NULL);
> +
> +		return ret;
>   	}
>   	return irq_set_vcpu_affinity(host_irq, NULL);
>   }
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 5d45795c367a..855c6309900c 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3970,7 +3970,6 @@ EXPORT_SYMBOL(amd_iommu_deactivate_guest_mode);
>   
>   static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
>   {
> -	int ret;
>   	struct amd_iommu_pi_data *pi_data = info;
>   	struct amd_ir_data *ir_data = data->chip_data;
>   	struct irq_2_irte *irte_info = &ir_data->irq_2_irte;
> @@ -3993,25 +3992,16 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *info)
>   
>   	ir_data->cfg = irqd_cfg(data);
>   
> -	if (pi_data) {
> -		pi_data->ir_data = ir_data;
> +	if (!pi_data)
> +		return amd_iommu_deactivate_guest_mode(ir_data);
>   
> -		ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
> -		ir_data->ga_vector = pi_data->vector;
> -		ir_data->ga_tag = pi_data->ga_tag;
> -		if (pi_data->is_guest_mode)
> -			ret = amd_iommu_activate_guest_mode(ir_data, pi_data->cpu,
> -							    pi_data->ga_log_intr);
> -		else
> -			ret = amd_iommu_deactivate_guest_mode(ir_data);
> -	} else {
> -		ret = amd_iommu_deactivate_guest_mode(ir_data);
> -	}
> -
> -	return ret;
> +	pi_data->ir_data = ir_data;
> +	ir_data->ga_root_ptr = (pi_data->vapic_addr >> 12);
> +	ir_data->ga_vector = pi_data->vector;
> +	ir_data->ga_tag = pi_data->ga_tag;
> +	return 0;
>   }
>   
> -
>   static void amd_ir_update_irte(struct irq_data *irqd, struct amd_iommu *iommu,
>   			       struct amd_ir_data *ir_data,
>   			       struct irq_2_irte *irte_info,
> 
> base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
> --
> 

