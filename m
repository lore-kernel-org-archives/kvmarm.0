Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20CEC37C10F
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 07:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774597240; cv=none; b=h1IVZK90EUUc276uSwFUHgDr/+aVpPW9qXhdfMTOVXSTnhNLllz6GFkgY2tIP8b3D9o+61yfLmclOdEo+a3vKZ6pvV51LuvaX8HdQHe5IvH19kxXxtT/1JqSWg6Vo/VUdzWndInqV593VIwHhLlACbZIZQre1p3XDH5HQTvseMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774597240; c=relaxed/simple;
	bh=/L6AmJg74azI6rrEuQ5w93kRN5/h8LtEgS9vkE6amJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kChGGE00UfUTM0Vh1ivsjD3rbstQw5sLqLg33mRCn5Jp94SUqoKKfy5D3JsxKdaa/Ms9i6TGr9R8Hl3VCkGlYWGmIXcUWNgy9+coaBQd1FfNgpAnTagr5HjqTr29bwt5/9whK21zVqi/JoRme/HoP5Rg482rlDWeZ7Z273KwQgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=YlJSh+sD; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="YlJSh+sD"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=m/TnutpGNNQMeOJaVLkcKsGuB+WWTz76WYqB2NYpJI0=;
	b=YlJSh+sD9R73qfN4YoYK35Z5sLwd4T4rTya15zQ6nnbzaxs1AM8MqCvdiBt5Khson6g0EaUdS
	ukF/jBaQHn3UL2erIrEMyYxbMs5l59TdRtynYSuI1mZAASkQUc+dOOZK2Kov2SPPWOnDJ91pSTC
	+6YM29BkZYu04sndbmuTu8g=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fhsqY1NG8z12Ljr;
	Fri, 27 Mar 2026 15:35:05 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 695A140561;
	Fri, 27 Mar 2026 15:40:31 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 27 Mar 2026 15:40:30 +0800
Message-ID: <6cce203f-89d9-4e9d-8b28-9629eb53b180@huawei.com>
Date: Fri, 27 Mar 2026 15:40:30 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64/kvm: Enable eager hugepage splitting if HDBSS is
 available
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <liuyonglong@huawei.com>,
	<Jonathan.Cameron@huawei.com>, <yezhenyu2@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
 <20260225040421.2683931-5-zhengtian10@huawei.com>
 <acQj5grOdZT8LUGp@devkitleo> <acQna2hLwdr1juTN@devkitleo>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <acQna2hLwdr1juTN@devkitleo>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 3/26/2026 2:20 AM, Leonardo Bras wrote:
> FEAT_HDBSS speeds up guest memory dirty tracking by avoiding a page fault
> and saving the entry in a tracking structure.
>
> That may be a problem when we have guest memory backed by hugepages or
> transparent huge pages, as it's not possible to do on-demand hugepage
> splitting, relying only on eager hugepage splitting.
>
> So, at stage2 initialization, enable eager hugepage splitting with
> chunk = PAGE_SIZE if the system supports HDBSS.
>
> Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> ---
>   arch/arm64/kvm/mmu.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 070a01e53fcb..bdfa72b7c073 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -993,22 +993,26 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   
>   	mmu->last_vcpu_ran = alloc_percpu(typeof(*mmu->last_vcpu_ran));
>   	if (!mmu->last_vcpu_ran) {
>   		err = -ENOMEM;
>   		goto out_destroy_pgtable;
>   	}
>   
>   	for_each_possible_cpu(cpu)
>   		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
>   
> -	 /* The eager page splitting is disabled by default */
> -	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +	 /* The eager page splitting is disabled by default if system has no HDBSS */
> +	if (system_supports_hacdbs())
> +		mmu->split_page_chunk_size = PAGE_SIZE;
> +	else
> +		mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
> +
>   	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	mmu->pgd_phys = __pa(pgt->pgd);
>   
>   	if (kvm_is_nested_s2_mmu(kvm, mmu))
>   		kvm_init_nested_s2_mmu(mmu);
>   
>   	return 0;
>   
>   out_destroy_pgtable:


Thanks again for sending this patch. I'll integrate it into the next 
version and run some tests.


