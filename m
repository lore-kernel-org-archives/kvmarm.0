From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v6 01/13] arm64: cpufeature: __this_cpu_has_cap()
 shouldn't stop early
Date: Tue, 16 Jan 2018 15:09:20 +0000
Message-ID: <c7f9ff6c-252f-17fc-7642-e32181181487@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
 <20180115193906.30053-2-james.morse@arm.com>
 <20180116150430.rlbw6qxb7v465gcv@armageddon.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0658949DDF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 10:04:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yI+AxeH+PIk1 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jan 2018 10:04:26 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA86749DDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jan 2018 10:04:26 -0500 (EST)
In-Reply-To: <20180116150430.rlbw6qxb7v465gcv@armageddon.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/01/18 15:04, Catalin Marinas wrote:
> On Mon, Jan 15, 2018 at 07:38:54PM +0000, James Morse wrote:
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 9ef84d0def9a..d88cd0e88606 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -1303,8 +1303,8 @@ static bool __this_cpu_has_cap(const struct arm64_cpu_capabilities *cap_array,
>>   	if (WARN_ON(preemptible()))
>>   		return false;
>>   
>> -	for (caps = cap_array; caps->desc; caps++)
>> -		if (caps->capability == cap && caps->matches)
>> +	for (caps = cap_array; caps->matches; caps++)
>> +		if (caps->capability == cap)
>>   			return caps->matches(caps, SCOPE_LOCAL_CPU);
>>   
>>   	return false;
> 
> Just to make sure I applied this correctly on top of for-next/core:
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a11311397430..630a40ec1332 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1149,9 +1149,8 @@ static bool __this_cpu_has_cap(const struct arm64_cpu_capabilities *cap_array,
>   	if (WARN_ON(preemptible()))
>   		return false;
>   
> -	for (caps = cap_array; caps->desc; caps++)
> +	for (caps = cap_array; caps->matches; caps++)
>   		if (caps->capability == cap &&
> -		    caps->matches &&
>   		    caps->matches(caps, SCOPE_LOCAL_CPU))
>   			return true;
>   	return false;
> 

Looks correct to me.

Thanks
Suzuki
