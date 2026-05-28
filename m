Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F863002AB
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 04:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779941519; cv=none; b=rI7Katka2mjP8eCM5P4SJyA6w4dkSNqWkzGeac0VFjkN8Sc4VQQARbHIR90QD7SCfHVC6ne06Z0wIBCDP+aw1muigvsRFmNrpuOKkWbWO1vgfI9ViNBCa+z1OgDzvmUZOPrKBLkgPWYDF3mUnNDXc8BbCAE2eCh+srtg7nZ7fjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779941519; c=relaxed/simple;
	bh=K00yvi/euk36FRL6ZdE/ZZDPD8NHeifXqBgHUNucZmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kIVBq+DMKyCe4OEvGTAOJrrIiNv9Igb6iSsZWXusWt37jlsvKsa8BYjhHDb1uvfSnge4AaORfPBTF9F+KyHdS5AwK+xQu40B90VzQA7Q0nN+OqHmQJCb+8vAnuBPooT2YQClr15X8iaWhNPESpvND+QRxLqv5iYlLL0qZMU6MJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BLXVqWWr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BLXVqWWr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779941516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aWEMGPujLx2YkwfTu/wiSD5CRnNiDpNAFuXhLG9oPIs=;
	b=BLXVqWWr/UOeJdWNCfgAo7X3+eeJdsp/GQpXxCeR4dfc2/YPQsAFftl5/XW0PdAYJLl1LJ
	GRxZXmcHERYvwt36zLc9N6krN+tXPMfj37cT87hVXmt1Fq1FOwJtiV4hlKrVGILTXROBh4
	NlW29QbVITEmv3CgW9Fg9bm9+jHYi8s=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-iEX_DOWWME-02p3B_r3Bxg-1; Thu, 28 May 2026 00:11:54 -0400
X-MC-Unique: iEX_DOWWME-02p3B_r3Bxg-1
X-Mimecast-MFC-AGG-ID: iEX_DOWWME-02p3B_r3Bxg_1779941514
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-368b68a33adso17397486a91.1
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 21:11:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779941514; x=1780546314;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aWEMGPujLx2YkwfTu/wiSD5CRnNiDpNAFuXhLG9oPIs=;
        b=mjFCAjFAS6sqquvjeB9DJqdRhBFNZpciOM20dEyRs8uuDJmaOP04q8RI8pcm2eldA8
         7MPrmaR+gcSEHu0z6wqm0Ze1F4Y++dDNytXFoOolo8pQj2t4Wmak0Oa7jiDQLw+SbYrC
         nHXM1PM8MGViLyyYLjU51FtxFrCHz80h9ANJsnScD4vfsUyAMUg099J4e4YHxavF4N0q
         KyEsQauY+wtxvSJM0b1I1f3un/1kcmlYtOA0ysjefn8UeGFCLuaYZnMFwqxWezVCkXFb
         3wmy1V5YePyEflS1i/7ffWaE2xCWx/q30HEModzf4EQGghwfGuHhN4EW0mvLNsp0Ihjg
         QIYw==
X-Forwarded-Encrypted: i=1; AFNElJ8HxWararh99lPxWeNTkHfr7MlivPXtvvCPOC6FjJAroDck0D2hKWbsaRq7hrBsZKIGO2suKQA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+8Df2o0styCSnuFY0E1igdgSw8dPKFJJaRDleXXyk3HzX5bj1
	37dXEpnygXdEdxNbJsqUzDFy4JB1qqciEOW3YSnF1F9m5DnitN+rFDnUWDOXU9zgbHLO55Cl8cP
	sa4zgtLN45q2Pa3pJn4T5CfwD6c+OpcECHCrq5ePxjE/xbvRR3w+XYBOvcw==
X-Gm-Gg: Acq92OGPOEJJQ/ssEbSmxQ87TeE0dsGk35W+22KeXf9GrULy4bxvDVQqRSjRC8UnTFl
	3kNOPKbQXXiSo1ZH7VC7hWPqOMIsbyx8fdsqsx6sMdtJaOvVm2aiDexE7IGn+RYX5K+lYVahnQS
	QSuumeO5kdoCAXnGCDB24xEAbajwisNBkY202/xQifbO39VgwDxSsNfR5wLeFXoBf/7T1w9KCGQ
	iY4TKGODfyepn+dMTVBYyh8ZBAkioJr6plbP2zF7NU9XRl80rCpANIfbZBipcsFUtqtl7iEpdQI
	H/vk0z9ioH8EO2m4wnXSrA0NIISOTl3bc31X1hnudJrg0VEqQ1261k6p0DhVmgbpb2mrfr6FEeg
	daPWsXtcMRxwYqEeX1cjXxrJSXQlLBDkLkPTuYMCU6+BXROdImwUtPpWrpcmsinmrUJsMnkyNLy
	o=
X-Received: by 2002:a17:90b:5447:b0:36b:71e6:3de8 with SMTP id 98e67ed59e1d1-36b71e64033mr3269532a91.24.1779941513635;
        Wed, 27 May 2026 21:11:53 -0700 (PDT)
X-Received: by 2002:a17:90b:5447:b0:36b:71e6:3de8 with SMTP id 98e67ed59e1d1-36b71e64033mr3269490a91.24.1779941513150;
        Wed, 27 May 2026 21:11:53 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36b908e15acsm409862a91.2.2026.05.27.21.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 21:11:52 -0700 (PDT)
Message-ID: <58143176-8311-4eb8-85ef-625c5249fd0f@redhat.com>
Date: Thu, 28 May 2026 14:11:41 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 21/44] KVM: arm64: Support timers in realm RECs
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
 <20260513131757.116630-22-steven.price@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20260513131757.116630-22-steven.price@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -bRvv_XLVWPVC6iG5ITkIJdYsG3rb_wYe8mOYu3AJAA_1779941514
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve,

On 5/13/26 11:17 PM, Steven Price wrote:
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> A later patch adds the support for propagating the timer values from the
> exit data structure and calling kvm_realm_timers_update().
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v12:
>   * Adapt to upstream changes.
> Changes since v11:
>   * Drop the kvm_is_realm() check from timer_set_offset(). We already
>     ensure that the offset is 0 when calling the function.
> Changes since v10:
>   * KVM_CAP_COUNTER_OFFSET is now already hidden by a previous patch.
> Changes since v9:
>   * No need to move the call to kvm_timer_unblocking() in
>     kvm_timer_vcpu_load().
> Changes since v7:
>   * Hide KVM_CAP_COUNTER_OFFSET for realm guests.
> ---
>   arch/arm64/kvm/arch_timer.c  | 28 +++++++++++++++++++++++++---
>   include/kvm/arm_arch_timer.h |  2 ++
>   2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index cbea4d9ee955..88ed01edc136 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -470,6 +470,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>   			    timer_ctx);
>   }
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu)
> +{
> +	struct arch_timer_cpu *arch_timer = &vcpu->arch.timer_cpu;
> +	int i;
> +
> +	for (i = 0; i < NR_KVM_EL0_TIMERS; i++) {
> +		struct arch_timer_context *timer = &arch_timer->timers[i];
> +		bool status = timer_get_ctl(timer) & ARCH_TIMER_CTRL_IT_STAT;
> +		bool level = kvm_timer_irq_can_fire(timer) && status;
> +
> +		if (level != timer->irq.level)
> +			kvm_timer_update_irq(vcpu, level, timer);
> +	}
> +}
> +
>   /* Only called for a fully emulated timer */
>   static void timer_emulate(struct arch_timer_context *ctx)
>   {
> @@ -1079,7 +1094,7 @@ static void timer_context_init(struct kvm_vcpu *vcpu, int timerid)
>   
>   	ctxt->timer_id = timerid;
>   
> -	if (!kvm_vm_is_protected(vcpu->kvm)) {
> +	if (!kvm_vm_is_protected(vcpu->kvm) && !kvm_is_realm(vcpu->kvm)) {
>   		if (timerid == TIMER_VTIMER)
>   			ctxt->offset.vm_offset = &kvm->arch.timer_data.voffset;
>   		else

s/!kvm_is_realm(vcpu->kvm)/!vcpu_is_rec(vcpu)

> @@ -1110,7 +1125,7 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
>   		timer_context_init(vcpu, i);
>   
>   	/* Synchronize offsets across timers of a VM if not already provided */
> -	if (!vcpu_is_protected(vcpu) &&
> +	if (!vcpu_is_protected(vcpu) && !kvm_is_realm(vcpu->kvm) &&
>   	    !test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags)) {
>   		timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read());
>   		timer_set_offset(vcpu_ptimer(vcpu), 0);

Same as above.

> @@ -1611,6 +1626,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   		return -EINVAL;
>   	}
>   
> +	/*
> +	 * We don't use mapped IRQs for Realms because the RMI doesn't allow
> +	 * us setting the LR.HW bit in the VGIC.
> +	 */
> +	if (vcpu_is_rec(vcpu))
> +		return 0;
> +
>   	get_timer_map(vcpu, &map);
>   
>   	ops = vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
> @@ -1740,7 +1762,7 @@ int kvm_vm_ioctl_set_counter_offset(struct kvm *kvm,
>   	if (offset->reserved)
>   		return -EINVAL;
>   
> -	if (kvm_vm_is_protected(kvm))
> +	if (kvm_vm_is_protected(kvm) || kvm_is_realm(kvm))
>   		return -EINVAL;
>   
>   	mutex_lock(&kvm->lock);
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index bf8cc9589bd0..ffdb90dcad58 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -113,6 +113,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>   
> +void kvm_realm_timers_update(struct kvm_vcpu *vcpu);
> +
>   u64 kvm_phys_timer_read(void);
>   
>   void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);

Thanks,
Gavin

