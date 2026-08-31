Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D53D45DF;
	Mon, 31 Aug 2026 08:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788166371; cv=none; b=qfETndUj8nwkQGKdBTvkW6qL2Aet1LpsGilYBLYnBT7Ywl5p+D5dJzmuzUs7u0sNWVh+jJoT3A3lb4X+r8n2rBQdcJkPgIXwb6CdyNa3JqY6kvVOGi1tastQOYuLX7f8bUwEfG7uvcrHiSYKYffqal5t4PnSMcOMrs2rM9EalEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788166371; c=relaxed/simple;
	bh=DILvzi0ZIyssodPNfYDLi/EcM7ED/xZz4i72XZcumpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cnxqbA46m/go8HK0MLPSljcpJoF6qubdTBWw+plTlna7ZLpsNUMT4JCWU9ZkLtBjHpfrUxXfEfwxCFvodNvQr8uGkMvb9fBoDhKvH/Pf7jTDAw4gCNsF+nvXr1nrAvhntUONcKGgbM+bBh/KkrCOGm7/oIau846fBG3p4J5h6IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PvBPJ/vr; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PvBPJ/vr"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=j913auZOQM8vCxWPwi3DTJtC16eIgjjvv2jrOeFm6G4=;
	b=PvBPJ/vrrzuEuTjEom9riXvAVkbzJuQYeaaUfOxFaI210qy6nlOvACtpVTNdugeR5Ytx9+QbV
	kq/f8Ltj6qjjJbG5Zpq2FUFfOJ9fqo0qBxkARsKNvBeDFaFzagVHPipofgF77qFUXUoC6cVgIde
	3C2T8yaH43v2ryHUw0OP+N0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hYMt60HJtz1K96b;
	Mon, 31 Aug 2026 16:41:50 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id E5E50402AB;
	Mon, 31 Aug 2026 16:52:38 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 16:52:38 +0800
Message-ID: <87c231f4-c281-48be-881a-1ed544f4b35a@huawei.com>
Date: Mon, 31 Aug 2026 16:52:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] KVM: arm64: Enable eager hugepage splitting if
 HDBSS is available
To: <sashiko-reviews@lists.linux.dev>
CC: <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
	<kvmarm@lists.linux.dev>, Oliver Upton <oupton@kernel.org>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-2-zhengtian10@huawei.com>
 <20260709110349.4590F1F00A3A@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260709110349.4590F1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 7/9/2026 7:03 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The default eager page splitting chunk size evaluates to an architecturally invalid block size on 16KB and 64KB page systems and suffers from integer truncation in KVM_CHECK_EXTENSION.
> - [Medium] The global capability query for eager page splitting chunk size incorrectly reports the default as 0 (disabled) when HDBSS is present.
> --
> 
> --- Patch [1]: [PATCH v4 1/6] KVM: arm64: Enable eager hugepage splitting if HDBSS is available ---
> commit 382048a591b4a06f749e61447083eb8630f1bad5
> Author: Leonardo Bras <leo.bras@arm.com>
> Subject: KVM: arm64: Enable eager hugepage splitting if HDBSS is available
> 
> This commit enables eager hugepage splitting by default at stage2
> initialization when the system supports HDBSS. It sets the chunk size
> to 256K * PAGE_SIZE.
> 
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 6c941aaa10c63..e086c01a9325e 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1027,8 +1027,12 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>>   	for_each_possible_cpu(cpu)
>>   		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
>>   
>> -	 /* The eager page splitting is disabled by default */
>> -	mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
>> +	 /* The eager page splitting is disabled by default if system has no HDBSS */
>> +	if (system_supports_hdbss())
>> +		mmu->split_page_chunk_size = 256 * 1024 * PAGE_SIZE;
> 
> [Severity: High]
> Does this chunk size assignment create architecturally invalid block sizes
> on 16KB and 64KB page systems?
> 
> On 16KB and 64KB systems, 256 * 1024 * PAGE_SIZE evaluates to 4GB and
> 16GB respectively. Since level 1 blocks are not supported for these
> page sizes on ARM64, this exceeds the valid maximums (32MB and 512MB).
> If a VMM attempts to restore this configuration, kvm_vm_ioctl_enable_cap()
> in arch/arm64/kvm/arm.c will reject it via kvm_is_block_size_supported(),
> which breaks live migration.
> 
> Additionally, can this cause integer truncation during capability queries?
> 
> In arch/arm64/kvm/arm.c:kvm_vm_ioctl_check_extension(), the 64-bit chunk
> size is assigned to a 32-bit signed integer. The values 4GB (0x100000000)
> and 16GB (0x400000000) will truncate to 0. A VMM querying this capability
> would read 0 and restore 0 on the destination, silently disabling the
> feature.
> 
> [Severity: Medium]
> Does this new dynamic default desync with the global capability query?
> 
> When userspace queries /dev/kvm via KVM_CHECK_EXTENSION for
> KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE without a VM instance,
> arch/arm64/kvm/arm.c:kvm_vm_ioctl_check_extension() unconditionally returns
> KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT (0).
> 
> Since this patch changes the default dynamically for new VMs based on
> system_supports_hdbss(), the global API query now misleads userspace about
> the default capability.
> 
>> +	else
>> +		mmu->split_page_chunk_size = KVM_ARM_EAGER_SPLIT_CHUNK_SIZE_DEFAULT;
>> +
>>   	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
>>   
>>   	mmu->pgd_phys = __pa(pgt->pgd);
> 

In v5 we no longer force-enable eager splitting for HDBSS VMs. So this
patch is no longer useful.

Thanks!
Tian

