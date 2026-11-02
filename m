Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649434;
	b=GltXn/luwC8kBCvJS17UqhUMXPBw8q5K6ep5kHYLcyyakzUidX9PrAe0YiO6c32Hce/j
	 uRubVJmp1T4pNaYcVKerkneAITqaf3UO0RTPnb8twv52j5ap0roiqdEaXl7e3gIB1WrhX
	 KbM3VOlE2QvMx9U0YDMvvENfpCPOrDUF/98w5Q4qdfav7iN6C7/SZ62kE0gfzVgf69+Yw
	 kmJtBbDePMTiUNqVXElSoRPqSTXiYEm9pGeNsAY0CRwALOoke8wRHcR+tQ1ZKbeCTkEVJ
	 52Vj9dIaVKPgzMonmMH31dXw0exb2uTp1cTux6+srH7B98JowUHYfuz5qn0DDE4mdFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649434;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=p4yj8PcXfsjHAFRFhKlGVG3Xq4JUEc513sVF+fQ1Es4=;
	b=bqVvFVpMRAxijH9q1EY7Pccar4vkBNi3lzX8JM3QilWnccXqV1BfODgPqUE6FABHub+G
	 +bXsikpi8156QJiBFy2j24Htzn8EilK73PhbltBYbuJsXaRhQnF8rlaaAUTw305nPq9ig
	 5su3CUuLsVS58FrNU+E/qzEgV+h9duBMSEsVcOJFgKe/v+c+bw3IDJXphJLWq81MsbEfa
	 ER7Q8YnInVqWwwgZuqPHFo4FG9f4jBW25GrtOXAaspKPtBiNPMWi6dv6bRzF/AZ1/z6Gn
	 qfzFzybKcWRkgSqEf7nMRnHzlb6B390twKlhxvZAQyUnmoOgM8yozv5t9GyrM/jwSOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DwmzQVqA;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1570606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1570606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DwmzQVqA
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB6401576;
	Mon,  2 Nov 2026 11:57:09 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EBED3F673;
	Mon,  2 Nov 2026 11:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793649432; bh=vV/O81PZN4pQjMeQAbiKa8PkUhpnpkooTMsVegOhArA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DwmzQVqA0Wk8ulH8phnO4LM/x4GLhReH4K/IdoptqzI7M+J76sNjPSsHX1HYh1i9i
	 4QEAk3zuFTMWrTdDeyjdzveF1lUBN+3o31Ox2BBfYL3qHuizgbN9zzwlBObHLgZLQg
	 6bC0jIcFDvKZRkB+59OjrqhDI7Jv2VyJV3JoRwY4=
Message-ID: <8271073d-aa2a-45f4-b284-b9624c52fcf0@arm.com>
Date: Mon, 2 Nov 2026 19:57:10 +0000
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
Subject: Re: [PATCH kvmtool v3 03/21] arm64: Sync KVM UAPI headers for GICv5
 IRS
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-4-sascha.bischoff@arm.com>
 <c3df7c89-1376-4fc9-88c0-083029c836bb@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <c3df7c89-1376-4fc9-88c0-083029c836bb@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/10/2026 18:37, Vladimir Murzin wrote:
> On 10/16/26 16:39, Sascha Bischoff wrote:
>> Copy the GICv5 IRS address type and size, the IRS register attribute
>> group, and the IST attribute and descriptor from the Linux headers.
>>
>> Keep the ITS UAPI out of this sync so the base GICv5 support uses
>> only the IRS definitions already present in Linux.
>>
>> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>> ---
>>   arm64/include/asm/kvm.h | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
>> index 1c13bfa2..9998252e 100644
>> --- a/arm64/include/asm/kvm.h
>> +++ b/arm64/include/asm/kvm.h
>> @@ -97,6 +97,11 @@ struct kvm_regs {
>>   #define KVM_VGIC_V3_REDIST_SIZE		(2 * SZ_64K)
>>   #define KVM_VGIC_V3_ITS_SIZE		(2 * SZ_64K)
>>   
>> +/* Supported VGICv5 address types  */
>> +#define KVM_VGIC_V5_ADDR_TYPE_IRS	6
>> +
>> +#define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
>> +
>>   #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
>>   #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>>   #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>> @@ -417,6 +422,16 @@ enum {
>>   #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
>>   #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
>>   #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
>> +#define KVM_DEV_ARM_VGIC_GRP_IRS_REGS	10
>> +#define KVM_DEV_ARM_VGIC_GRP_IST	11
>> +
>> +struct kvm_vgic_v5_ist {
>> +	__u64	spi_ist_addr;
>> +	__u64	spi_ist_size;
>> +	__u64	lpi_ist_addr;
>> +	__u64	lpi_ist_size;
>> +};
>> +
>>   #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
>>   #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
>>   			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
>> -- 2.34.1
>>
> 

Hi Vladimir,

I've not added your tag here. For the new posting I'm replacing this 
commit with one that explicitly syncs the v7.4-rc1 headers (now that the 
GICv5 IRS support is in there) rather then just cherry-picking the GICv5 
changes.

The ITS changes are kept separate, as before.

> That matches to what we expect in 7.4-rc1, so FWIW
> 
> Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

Thanks,
Sascha
