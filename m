Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC8D3D45D4;
	Mon, 31 Aug 2026 08:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788166547; cv=none; b=tg/3lok3meul3JmPE1goEb8SK7EptJHi89ChIGGBQu8Huor+98ZoKkBc8H04C6tWxZSyg1M2VURElEdzCjVAKEFiB/kqmqTHXzLcWmOG1AClfSwyHGRXN06jNP3rnsZub1D9MdtucOmvOoTotzQ/IKyDfxHpLI1z0wSDJ+8CBsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788166547; c=relaxed/simple;
	bh=iJOkSbmAAfKOmDq/IJzHkC2WcreS61heTeFz5ABxmUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KfHEM0MwAV3EzU+Z0jHCdzFQRESohVfdjJZFK95GYTYUN+OrGKiqikBVBX3ne1wGrUdlC2iGt/ywVwilQ+CJVdphHFH97LGvI+VYgIkKLRHGS3kljsRzZh+RiNCmL+XuPkk5Mir9/oHRg5TcDtJmbUAxaaqbVdrR1oN8zYkPFKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=32YMnCy5; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="32YMnCy5"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bmZ1l/CjeA8Rq7DC7M8mfj8WJ7KyjHcRrdbqAbk1+4M=;
	b=32YMnCy5/L3hl92k0mypYFLYuKQHnFZDeo69D6FgGDKQ145Kl/g57Ds7tGhrXR9JPScpGRMV+
	ltoh6i3xTS5GhAPHWoSNCcYBv1xdJpS1cQzgks7D0FT4s6++X3KLdLEFAVmq8c2W/7sLjMCMLK+
	LNaBCQDybTN5eNZpbCh3dNo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hYMxc5RmbzRhQt;
	Mon, 31 Aug 2026 16:44:52 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 720094058C;
	Mon, 31 Aug 2026 16:55:39 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 16:55:38 +0800
Message-ID: <44276eb2-bac8-4996-86c8-9275ece425da@huawei.com>
Date: Mon, 31 Aug 2026 16:55:38 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] KVM: arm64: Add support for FEAT_HDBSS
To: <sashiko-reviews@lists.linux.dev>
CC: <kvm@vger.kernel.org>, Oliver Upton <oupton@kernel.org>, Marc Zyngier
	<maz@kernel.org>, <kvmarm@lists.linux.dev>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-3-zhengtian10@huawei.com>
 <20260709110002.D21C51F00A3A@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260709110002.D21C51F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 7/9/2026 7:00 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] The parameter name `cope` in `has_vhe_hdbss()` is a typo for `scope`.
> --
> 
> --- Patch [2]: [PATCH v4 2/6] KVM: arm64: Add support for FEAT_HDBSS ---
> commit fc8e5042a6724701835a3f111b45e733575a4a2e
> Author: Tian Zheng <zhengtian10@huawei.com>
> 
> KVM: arm64: Add support for FEAT_HDBSS
> 
> This commit adds CPU capability detection for the Hardware Dirty Bit State
> Structure (HDBSS) feature introduced in Armv9.5. It provides a helper
> function to check for hardware support, requiring VHE mode.
> 
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 9a22df0c5120f..aa327eebaf1ca 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
> [ ... ]
>> @@ -2131,6 +2131,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
>>   	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>>   }
>>   
>> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
>                                                                               ^^^^
> 
> [Severity: Low]
> This isn't a bug, but is the parameter name "cope" a typo for "scope"?
> 
>> +{
>> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
>> +}
>> +
>>   bool cpu_supports_bbml2_noabort(void)
>>   {
> 

This has already been fixed in v5, where the parameter is correctly
named scope.

Thanks!
Tian
