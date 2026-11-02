Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793642229;
	b=HbWFIHzr1d1sLOP9RWmesRWK2iCF9fE/jegyqIkbQZMzqb7lqua3kBPt724BNe51hXsN
	 sQrE/23UnRJzpPYQ7dKijzt8kUcWuRr2wvWAO7fxFufG2wVJHcso0GTKZsa0XMUldwuGX
	 12c0O6wRX/oUwzkcwa9UI1/wlhxu0TqjCpRQhRHTriBujN4/QCHjlTSLEIa7Rda9DLtOf
	 XbVwGfsuhznpOveAZ/TP8lYxLxPlJslMxf2iZNtnA/Ww8U6BmgPyrvs6C3+ievH2ZUTID
	 YMVZkVGu88gfrL8Y2KDXNm3TgR6JWq8VB/QS+ZwssI0gVJ7xusaBRwI/9JI7GPPPLzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793642229;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=xjyTXjB2wAHAAsP40xGjOOv4kKPxaKWcHukk2jT9TJs=;
	b=bL63ri9Z/xOUaV6Xq5z/qg+dy7JtlwyITVLLPEOtvNV/lEJAHBPlmhUAewuZSSEEZ7oN
	 qKp8AZjQ+DwXijG1liXkFYcgbw9tRC6KWuMtK5x4xbCM/7IuG882X8xNdro5742WTin9m
	 LTbOYW3j07l9DOseNcaKgrUhLFTNFgnZu/snS8m/qek1cTMD2P1RSqr30ZgP4qSser7XJ
	 9TChv/+7+rNBP6qsfkxTiT565cAak4TbYK7wIFCjDKZxMgidxQe274qXWkM/s1jJE0Fhv
	 LvIuCYsJB1tF9JnPLQ8Jq9JHYWj/Bja8NjwEgJyWYDa5kZVGrlCadq1AAuPzf21Q9Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BKE84h0E;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407FB606D82C;
	Mon,  2 Nov 2026 17:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 407FB606D82C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BKE84h0E
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57C2F1C14;
	Mon,  2 Nov 2026 09:57:04 -0800 (PST)
Received: from [10.0.136.93] (M0PRX50XMG.cambridge.arm.com [10.0.136.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D567A3F59E;
	Mon,  2 Nov 2026 09:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793642227; bh=Bt0frdHKGBbUPamp1w+4GcmozA3dEEooJHfwDzZsC4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BKE84h0EpGmT3Zx5XyqXfCDcKZzHDVUGBKr9tKzGVdesA2PfPUkbRDcVw7q+Eeurl
	 9u9pyG3I24g5JsUrwnzDi9av3uOXHBTtGyVhhvp6SvHJ/QeeTCQmTlqHwB1uCHWic2
	 I/P6IARqEpV08Zc5nFlTrTeHYYZiA3h0fR9hNZig=
Message-ID: <1e3c0416-283d-4768-a0e6-01e036e099b9@arm.com>
Date: Mon, 2 Nov 2026 17:57:05 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/16] irqchip/gic-v5: Enable direct injection in ITS
To: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
 <20261016155741.979985-12-sascha.bischoff@arm.com>
 <sashiko-outbox-174629@kernel.org>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <sashiko-outbox-174629@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16/10/2026 17:22, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] irqchip/gic-v5: Racy ITS MMIO invalidation sequence
> - [High] irqchip/gic-v5: missing event drain in set_vcpu_affinity causes cross-VM interrupt
> --
> 
> commit 4f462ff132c79e74a3a82cf356a72402e7a44799
> Author: Sascha Bischoff <sascha.bischoff@arm.com>
> 
> irqchip/gic-v5: Enable direct injection in ITS
> 
> This commit introduces an irq_chip callback to allow KVM to install and remove
> virtual translations for direct interrupt injection. It replaces a host ITTE
> with a virtual translation and disables lazy masking while the interrupt is
> forwarded.
> 
>> diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v5-its.c
>> index 28e39b065de0e..7de40a7cff403 100644
>> --- a/drivers/irqchip/irq-gic-v5-its.c
>> +++ b/drivers/irqchip/irq-gic-v5-its.c
> [ ... ]
>> @@ -723,6 +765,95 @@ static void gicv5_its_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
>>   	msi_msg_set_addr(irq_data_get_msi_desc(d), msg, addr);
>>   }
>>   
>> +#ifdef CONFIG_KVM
>> +static int gicv5_its_set_vcpu_affinity(struct irq_data *d, void *int_data)
>> +{
> [ ... ]
>> +invalidate:
>> +	/* Make the change ITS-visible */
>> +	dsb(st);
>> +	ret = gicv5_its_itt_cache_inv(its, dev_id, event_id);
> 
> [Severity: High]
> Does this new KVM callback expose the gicv5_its_itt_cache_inv() sequence
> to concurrent execution?
> 
> This callback appears to only be serialized by the per-IRQ lock, but
> gicv5_its_itt_cache_inv() writes to the global shared ITS MMIO registers:
> 
> drivers/irqchip/irq-gic-v5-its.c:gicv5_its_itt_cache_inv() {
>      ...
>      its_writeq_relaxed(its, didr, GICV5_ITS_DIDR);
>      its_writel_relaxed(its, eidr, GICV5_ITS_EIDR);
>      its_writel_relaxed(its, eventr, GICV5_ITS_INV_EVENTR);
> 
>      return gicv5_its_cache_sync(its);
> }
> 
> Without an ITS-wide spinlock, concurrent configuration of different IRQs/vCPUs
> from the same or different guests could freely interleave their MMIO writes on
> the shared physical ITS.
> 
> Could this result in the ITS hardware receiving corrupted invalidation commands
> (e.g. invalidating the wrong device/event while leaving another stale), leading
> to dropped or misrouted interrupts?

This is definitely an issue. I've posted a fix for the host driver to 
address this:

https://lore.kernel.org/all/20261102-host_gicv5_fixes-v1-4-743b61626fc5@arm.com/

> 
> 
> [Severity: High]
> Are in-flight events drained here when direct injection is disabled?
> 
> When disabling direct injection (where data is NULL), the ITTE is updated to
> the host LPI and the ITS cache is invalidated. However, there is no call to
> gicv5_its_syncr() or gicv5_irs_syncr() to drain accepted events before
> returning.
> 
> If KVM subsequently tears down the VM and reuses the VM ID for a new guest,
> could an in-flight event reach the IRS and be injected into the new VM's IST
> using the old translation?
> 
> Disabling forwarding would likely need to drain events before returning to
> safely reuse the resources.

We were missing a called to the IRS_SYNCR, which has now been added. The 
ITS_INV_EVENTR that is already present should be sufficient on the ITS side:

R_ZXXJF: When ITS_STATUSR.IDLE transitions from 0 to 1, any ITS event 
that used information from ITS translation structure entries prior to 
the invalidate have been Accepted by the IRS.

Successful VM teardown removes the translations, so incoming events 
should not be injected into a new guest's IST.

> 
>> +	if (ret) {
>> +		/* Keep a failed restoration distinguishable from a clean host ITTE. */
>> +		if (!data)
>> +			irqd_set_forwarded_to_vcpu(d);
>> +		return ret;
>> +	}
>> +
>> +	if (data)
>> +		irqd_set_forwarded_to_vcpu(d);
>> +	else
>> +		irqd_clr_forwarded_to_vcpu(d);
>> +
>> +	return 0;
>> +}
>> +#endif /* CONFIG_KVM */
> 

Thanks,
Sascha
