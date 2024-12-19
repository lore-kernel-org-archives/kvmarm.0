Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF3E14AD17
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 03:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734578032; cv=none; b=AcaZk5qz8/1pYFgbMGPWmRzjtUa92ltTGdbA161eMmv+BRQFacCPM3ArpltzkEflzR6DPubLRtdG2TwjjyY0I/SPn/mmApbWWS5RUBDijLxjYs+KaVRDXTO2gg7T/7V8TeZBVGIGEFQZATCkBVrsw/yHX6wIsHZOiOCLTdumasc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734578032; c=relaxed/simple;
	bh=Yd7KWnA9tasUsxrpICQTKPvx6pwIvbAh9dZde/RDFCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pxk6l64gp0S+upJNQx7Z0Qxf72XWKGJ9wK8KqPiAoguA2iLhU7kkjhtr+az9OIQ3fojY9w4Bql1WUJH42NafwHy0dw9DhPjkf0FeCleGrsmVnFztJ0l3KEsi6TUEVK2gufE3c7IWrdHMYEcxf2POuSzHAw1nMerzSIYSFY4SNQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A19731480;
	Wed, 18 Dec 2024 19:14:16 -0800 (PST)
Received: from [10.162.16.49] (unknown [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CF143F528;
	Wed, 18 Dec 2024 19:13:44 -0800 (PST)
Message-ID: <c707ecfd-6f1f-47d2-93ec-116f5dfd419e@arm.com>
Date: Thu, 19 Dec 2024 08:43:42 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 15/46] arm64/sysreg: Add register fields for PFAR_EL1
To: Eric Auger <eauger@redhat.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-16-anshuman.khandual@arm.com>
 <5203176c-2646-425b-b375-edb7931ef54f@redhat.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <5203176c-2646-425b-b375-edb7931ef54f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/18/24 21:12, Eric Auger wrote:
> Hi Anshuman,
> 
> On 12/10/24 06:52, Anshuman Khandual wrote:
>> This adds register fields for PFAR_EL1 as per the definitions based on
>> DDI0601 2024-09.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/tools/sysreg | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 18b814ff2c41..e33edb41721a 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -3533,3 +3533,10 @@ Field	5	F
>>  Field	4	P
>>  Field	3:0	Align
>>  EndSysreg
>> +
>> +Sysreg	PFAR_EL1	3	0	6	0	5
>> +Field	63	NS
>> +Field	62	NSE
>> +Res0	61:56
>> +Field	55:0	PA
> Just wondering: part of the PA definition depends on FEAT_D128 or
> FEAT_LPA and the reset field value is UNKNOWN if the feature is not
> available. Shouldn't introduce separate fields directly?
Generated PFAR_EL1_PA_MASK aka GENMASK_ULL(55, 0) should cover all the
cases for PA i.e 48 bits, LPA, D128 etc. Although individual use cases
will have to trim the mask subsequently as required.

Are you suggesting something like the following instead where the user
will have to concatenate these fields selectively to find the required
PA mask ?

Field	55:52	PA_D128
Field	51:48	PA_LPA
Field	47:0	PA
