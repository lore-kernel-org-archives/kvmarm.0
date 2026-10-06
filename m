Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7CB3812F6
	for <kvmarm@lists.linux.dev>; Tue,  6 Oct 2026 05:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791265495; cv=none; b=kQops7WN8mdBMkNIPnfcOY7hIKDUSHn7+MrP3aElsE6OVqNmqcqc+SG5c6MoJEeGjW81uOPu/bz0EdaCeVEtiSJLJP2u7NF/Cmmy5jgzz4Cb56P5deH2NiFfpqhhDdNMdcWV5NL56hYKDuBq4x5boeh9rAuv13Mm0akSFyRYhHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791265495; c=relaxed/simple;
	bh=DHoKyepo2fp+kisnl6gLY6MDmj/N/k7KerpVds1Hw9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sWa5WUYZ8EPxZivN+XKfDqFHuHwH29iveR+WgALp5aJ6AEcaprky7rssBreu1cNH/4iIMIZkH39JVg/WzLEBzxWbjKx6n2B7wYygqmwUsYd/1nAmsKVgHaO/NEQqAEuY+t2xA1LWYOx5y813g/3GUuM4O7pPWQEWmhTlNBEgv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvIlKl0z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvIlKl0z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791265492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HlbDdSB3PruPRmOdVrnRuaAfzphnBA/AuglJGG/CjDA=;
	b=DvIlKl0zzZGfdR63WLC8txDyBMDlDDPFmMnQfW5WmqhaUNcAOOXWRNVw7iFgAjPFdsZALD
	KP6C+QNCGLvGITOdYLMzbCrJrlitLdZO+Pg9KK38TKqIgeMjOdYVqnkgTBHqVssiSlvRso
	CNEZh1mLUStmVN3u25n/+jgU2uYQAHs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-YhpqzpO8ORen7P7lVpuOlg-1; Tue, 06 Oct 2026 01:44:51 -0400
X-MC-Unique: YhpqzpO8ORen7P7lVpuOlg-1
X-Mimecast-MFC-AGG-ID: YhpqzpO8ORen7P7lVpuOlg_1791265490
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e2c785aa62so38092765ad.3
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 22:44:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791265490; x=1791870290;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HlbDdSB3PruPRmOdVrnRuaAfzphnBA/AuglJGG/CjDA=;
        b=ARgpbc4yXy0Fsg/bAxWIvQFHKDydA2y/FIlz1MLaD3LFq32jS4KKvQ7MT1isfwJd9J
         MV5fr9LNL/QcSUbZspAJlW2e/CqjDYookGQiBiy4fG53z8djM5wN23eYr9BRszJ5ohps
         AhCIccF4CyKLQ9eJDkIyrIMJiiQG9RRu0sd1W/eGkj0YusYEHG14iFn3agIRL7JA+FJ6
         Pq3IlIq/0ZqJmLHXp+C7KyMkWfHLn4PxWtzZsiFQwoqX3idt7+DJZoIBE3Lpe0KHyJVD
         jc7t24xjLbxzQlpLY9Oj3B7tDEGGn8j6LkfK3BsuBR6Q3ipfgofeoW4UDl/5yCh3VSyP
         +zRg==
X-Forwarded-Encrypted: i=1; AKwUvBwtMdZ5Js+z6GSrWK1ieO4SsJxglHb6hDZIdhR5nmzC/3URfmEJUjdORnNfTQwYJVb9X6Vh1Jc=@lists.linux.dev
X-Gm-Message-State: AFuF++meO6j8gsgAcvInngfyPPpqr/tLrPnQAfsbs6WPqB+ixpwPPxVU
	ru9g4ftrVVD/62d14FhUrA7+wwb5Jjg+LIgnZYdeZY6b4hotMl/JAArLrQT3NuZMI1IaG21RZhO
	uaSblTIrNr6wp1nNNaZWt3vARs/uC1oYZnT8pAZs3oZAlptymmnb/GqmY6w==
X-Gm-Gg: AYBFou3iNswF4irhEn5DxBtLyM0BakUuthudy0Zp9q9vP4JkY3/ljNf8AktRed5qVoH
	Swh9mZEhdpaapFTQN+xakcaMgw79JOnjzYc3fz+zmQk5Kc1xdwxmW3dr1NrlbjprYYQ3DJ4iNgT
	SwkXwTIyF02utmGns/gzJpEMWIl+o/nR9z7PaIDkSZemLsNowz1NH9OqF5Yub6ugrEY/RcayIJx
	TCzxLgRJZcmF2Wbs+k0FrabR3ZBCuQ/+NSfzh7ND8k5SMeoYrpsMDLCBjA5rOnXh1aCvBcb847w
	vMy2JrFMq6dGnEznwNS9NLaSh7UdD/btks76qSo9rmt8HZc9pZUG/I00lPo3/At0GgY5Xsw/WjT
	2LjGP83WZuXnPr8QdALRtQk/HHwNTO7bMnmBR72gfBQ==
X-Received: by 2002:a17:902:d584:b0:2dd:68a4:16f1 with SMTP id d9443c01a7336-2e5dcd90b05mr3770095ad.11.1791265490002;
        Mon, 05 Oct 2026 22:44:50 -0700 (PDT)
X-Received: by 2002:a17:902:d584:b0:2dd:68a4:16f1 with SMTP id d9443c01a7336-2e5dcd90b05mr3769785ad.11.1791265489595;
        Mon, 05 Oct 2026 22:44:49 -0700 (PDT)
Received: from [192.168.68.52] (n175-34-8-244.mrk21.qld.optusnet.com.au. [175.34.8.244])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e5a5ecbdd3sm17417165ad.48.2026.10.05.22.44.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 22:44:48 -0700 (PDT)
Message-ID: <830e8afc-b208-4972-a45a-32c828c14206@redhat.com>
Date: Tue, 6 Oct 2026 15:44:39 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 21/23] KVM: arm64: CCA: Support timers in realm RECs
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
 <20261005090754.2140522-22-suzuki.poulose@arm.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20261005090754.2140522-22-suzuki.poulose@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qkTDT7HReM0N4PCF3eAkQwyuj5s124l2ZSLcEWTQzR8_1791265490
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/26 7:07 PM, Suzuki K Poulose wrote:
> From: Steven Price <steven.price@arm.com>
> 
> The RMM keeps track of the timer while the realm REC is running, but on
> exit to the normal world KVM is responsible for handling the timers.
> 
> A later patch adds the support for propagating the timer values from the
> exit data structure and making sure the values are in sync for KVM.
> 
> Also, RMM doesn't support injecting virtual interrupts backed by Physical
> interrupts. So, use the existing software resampling mechanims for Realm
                                                        ^^^^^^^^^
typo: mechanism

> timer interrupts.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/kvm/arch_timer.c | 22 ++++++++++++++++++++--
>   1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index a45845f4ae4ea..428709f499205 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -56,11 +56,25 @@ static unsigned long kvm_arch_timer_get_irq_flags(void)
>   	return kvm_vgic_global_state.no_hw_deactivation ? VGIC_IRQ_SW_RESAMPLE : 0;
>   }
>   
> +static unsigned long kvm_realm_timer_get_irq_flags(void)
> +{
> +	/*
> +	 * RMI_REC_ENTER rejects LRs with the HW bit set, so use the existing
> +	 * software resampling mechanism for Realm timer interrupts.
> +	 */
> +	return VGIC_IRQ_SW_RESAMPLE;
> +}
> +
>   static const struct irq_ops arch_timer_irq_ops = {
>   	.get_flags	 = kvm_arch_timer_get_irq_flags,
>   	.get_input_level = kvm_arch_timer_get_input_level,
>   };
>   
> +static const struct irq_ops realm_timer_irq_ops = {
> +	.get_flags	 = kvm_realm_timer_get_irq_flags,
> +	.get_input_level = kvm_arch_timer_get_input_level,
> +};
> +
>   static const struct irq_ops arch_timer_irq_ops_vgic_v5 = {
>   	.get_input_level = kvm_arch_timer_get_input_level,
>   	.queue_irq_unlock = vgic_v5_ppi_queue_irq_unlock,
> @@ -1617,8 +1631,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
>   
>   	get_timer_map(vcpu, &map);
>   
> -	ops = vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
> -				      &arch_timer_irq_ops;
> +	if (vcpu_is_rec(vcpu))
> +		ops = &realm_timer_irq_ops;
> +	else if (vgic_is_v5(vcpu->kvm))
> +		ops = &arch_timer_irq_ops_vgic_v5;
> +	else
> +		ops = &arch_timer_irq_ops;
>   
>   	for (int i = 0; i < nr_timers(vcpu); i++)
>   		kvm_vgic_set_irq_ops(vcpu, timer_irq(vcpu_get_timer(vcpu, i)), ops);

