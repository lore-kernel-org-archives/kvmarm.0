Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24EED36921C
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768830027; cv=none; b=AfYOdYPLeF183LDebjWTjqdSmdzSod6Pt+Zx5l/nuYoAEsGa3fS4rT2DL64KSSX9KjCnrYXQEv71PfQWkvOUMaD8aXbXcTVpsRL4GH0x3pL9RfkdagTwQ17sTsXR71TcumT2rnNeU3Wt6VMtxkGLclNtn38azWuildodo+M0MXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768830027; c=relaxed/simple;
	bh=Lw7ptkqPCKbztdKBU76UrwiSmjTj3K7fe5ahuHCLeDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NNrTxYg7aVH8/jJS0IUBUNJMsy2o3ehAe/Z19qUHqIqmRH1I9Yrn0BEIwn9ltStKhXSYHVFh2RlUFY1sjNocJEoMPd3aqc7b4StzfWY57NIx1LNA/NPrICMGQHZ7pjY7+mKyFjCeQZpR9NZg+ovASsKrpZe7Yzi1VEB78nQZ0Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D454B497;
	Mon, 19 Jan 2026 05:40:17 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A07073F694;
	Mon, 19 Jan 2026 05:40:19 -0800 (PST)
Message-ID: <d673a478-0f8f-4122-b49a-cd30213f1b5f@arm.com>
Date: Mon, 19 Jan 2026 13:40:18 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/47] arm64: mpam: Initialise and context switch the
 MPAMSM_EL1 register
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, james.morse@arm.com,
 jonathan.cameron@huawei.com, kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, will@kernel.org,
 corbet@lwn.net, maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.linux.dev
References: <20260112165914.4086692-1-ben.horgan@arm.com>
 <20260112165914.4086692-11-ben.horgan@arm.com> <aWk7Pyai4AcoQc_J@arm.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <aWk7Pyai4AcoQc_J@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Catalin,

On 1/15/26 19:08, Catalin Marinas wrote:
> On Mon, Jan 12, 2026 at 04:58:37PM +0000, Ben Horgan wrote:
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 0cdfb3728f43..2ede543b3eeb 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2491,6 +2491,8 @@ cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
>>  		regval = READ_ONCE(per_cpu(arm64_mpam_current, cpu));
>>  
>>  	write_sysreg_s(regval, SYS_MPAM1_EL1);
>> +	if (system_supports_sme())
>> +		write_sysreg_s(regval & (MPAMSM_EL1_PARTID_D | MPAMSM_EL1_PMG_D), SYS_MPAMSM_EL1);
>>  	isb();
> 
> Do we know for sure that system_supports_sme() returns true at this
> point (if SME supported)? Digging into the code, system_supports_sme()
> uses alternative_has_cap_unlikely() which relies on instruction
> patching. setup_system_capabilities(), IIUC, patches the alternatives
> after enable_cpu_capabilities(). I think you better use cpus_have_cap().
> 

I'll switch to cpus_have_cap().

Thanks,

Ben

