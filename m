Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07954ABBC1
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 11:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789732730; cv=none; b=pFCjr//u9yGqtTA+D51QRRQ6rn/LlpAAGpzXUmv3hsGCIYAPlq2XXKnDNzQTL9T6N1kH/7WQW/1yHbe2am60r9k5isPK4UqpZ0WbKrGtnHpLBF4rEJqur3a3Xns/U1TlqptOleHHk6/v66PICtDNW/FVxMbQyj6969v/9t/XQOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789732730; c=relaxed/simple;
	bh=jJUrf9jXfQl8W7ClHiyYcAylL94WCjv4zNsEMMLC51Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VP589N+AuDXl/cEqFc02aAivw27d+S7jj/OvsDuh7bwzYtgoPslQj5qiOJntDwYYZNh/hAFPIysdrUb1BY4h7Oj5OwnzoLLiZO5wq1EXWiKEM2reN4ZPsmLZY7bxxKov241fV9jk8DI4K2g9qRCIr9hHEsw1TyaB+TgUNUahGDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2iI2NGkH; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2iI2NGkH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FTZzu47AOmRxHTR0Eyam8a+mT0R7a/crBOBUb7Y1wmI=;
	b=2iI2NGkHtsj0pKWN/NSlZVoBkpiYmpnYJ1HMqRg97bQbgDGbJXsYzxrE1RSQE50iT3kZnaZ1r
	ugnw7eBaUpx7P+dyZXKWjDZw5E3lp1WnMKCHoysh5eRZFpjB0II66WCYY+kvJVlIN1mP3T5YsE/
	82FZwcek02meXDFkiwiIZGk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmW8D3pYRzKm5t;
	Fri, 18 Sep 2026 19:47:40 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 317A84057A;
	Fri, 18 Sep 2026 19:58:44 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 18 Sep 2026 19:58:43 +0800
Message-ID: <497c6239-a75f-4087-83c8-efface3fe3d7@huawei.com>
Date: Fri, 18 Sep 2026 19:58:43 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on
 migration
To: Leonardo Bras <leo.bras@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com>
 <20260901171558.2674031-6-leo.bras@arm.com>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260901171558.2674031-6-leo.bras@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 9/2/2026 1:15 AM, Leonardo Bras wrote:
> @@ -2570,53 +2571,76 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
>   
>   out_destroy_pgtable:
>   	kvm_pgtable_hyp_destroy(hyp_pgtable);
>   out_free_pgtable:
>   	kfree(hyp_pgtable);
>   	hyp_pgtable = NULL;
>   out:
>   	return err;
>   }
>   
> +static void kvm_set_hafdbs(struct kvm *kvm, bool set)
> +{
> +	/* Check if no action required */
> +	if (!!(kvm->arch.mmu.vtcr & VTCR_EL2_HD) == set)
> +		return;
> +
> +	if (set)
> +		kvm->arch.mmu.vtcr |= VTCR_EL2_HD;
> +	else
> +		kvm->arch.mmu.vtcr &= ~VTCR_EL2_HD;
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
> +}
> +

Hi Leo,

HD alone is architecturally a no-op. According to the Arm spec, the
VTCR_EL2.HD field description reads: "When the Effective value of
VTCR_EL2.HA is 0, this field behaves as 0 for all purposes other than a
direct read of the value of this bit." So patch 5 as it stands never
actually enables stage-2 dirty management.

In the combined series, I'm planning to replace both kvm_set_hafdbs()
and our earlier enable/disable hooks with a single derived mode:

```
/*
  *   logging && HDBSS-capable  ->  HDBSS  (HD|HA|HDBSS)
  *   logging, no HDBSS         ->  off
  *   !logging, HAFDBS-capable  ->  HAFDBS (HD|HA)
  */
void kvm_arch_update_hw_dirty_mode(struct kvm *kvm)
{
	bool logging = atomic_read(&kvm->nr_memslots_dirty_logging) != 0;
	unsigned long target;

	if (logging && kvm_supports_hdbss(kvm))
		target = VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS;
	else if (logging || !kvm_supports_hafdbs(kvm))
		target = 0;
	else
		target = VTCR_EL2_HD | VTCR_EL2_HA;
	...
}
```

HA is always set alongside HD by construction, so the no-op issue goes
away.

I'll fold this into the HDBSS v5 series when I send it out. Let me know
if you'd rather keep it in your v2 instead.

Thanks,
Tian
