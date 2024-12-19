Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9678654727
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 02:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576531; cv=none; b=TyYlcu9OD7ogNB0a70i21UJQx0hFUjyqzek/g/Znj65oavXjuHXzhVc4JrNDjnrI+mgYcpLGUNnLeKqguWDv2v2LrjHkV1KlDHh+plR5vcFx3pr5xzvOT9idX/T+CvhDBNZJopuMi8dIkMFx/sV6aTk1fJJUSnKWEpTCeuesxCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576531; c=relaxed/simple;
	bh=Hk9nQ6Ca5BfFstU1VhFpwDP2SXWqGqU8o170D2aSf7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iy4vJPc4MNjohaDM18tDsoE2bM8owYEtPYdjEeZy++XPfk93m+rD7QxYIuIbUHun4/CWoir3KdzqH2d5cm+6VhY/lKw1WFs73DTQkWVkpLMJJGpxwOXltHfEqNrTcpZHM66wVGVgXwsaE7H3xsDR9XaeGCch/J5S2jquvc1b4a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC6601480;
	Wed, 18 Dec 2024 18:49:15 -0800 (PST)
Received: from [10.162.16.49] (unknown [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 307223F720;
	Wed, 18 Dec 2024 18:48:43 -0800 (PST)
Message-ID: <8ad1e830-9ac9-4776-a877-c8d37bb03a3c@arm.com>
Date: Thu, 19 Dec 2024 08:18:41 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 04/46] arm64/sysreg: Update register fields for
 TRBIDR_EL1
To: Eric Auger <eauger@redhat.com>, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc: ryan.roberts@arm.com, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
References: <20241210055311.780688-1-anshuman.khandual@arm.com>
 <20241210055311.780688-5-anshuman.khandual@arm.com>
 <36aba488-26d7-4dc9-9ca0-a14e3de028e9@redhat.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <36aba488-26d7-4dc9-9ca0-a14e3de028e9@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/18/24 20:10, Eric Auger wrote:
> Hi Anshuman
> 
> On 12/10/24 06:52, Anshuman Khandual wrote:
>> This adds register fields for TRBIDR_EL1 as per the definitions based
>> on DDI0601 2024-09.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/tools/sysreg | 15 +++++++++++++--
>>  1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 59351931d907..10b1a0998d99 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -3295,13 +3295,24 @@ Field	31:0	TRG
>>  EndSysreg
>>  
>>  Sysreg	TRBIDR_EL1	3	0	9	11	7
>> -Res0	63:12
>> +Res0	63:48
>> +Field	47:32	MaxBuffSize
>> +Res0	31:16
>> +UnsignedEnum	15:12	MPAM
>> +	0b0000	NI
>> +	0b0001	PMG
> Out of curiosity how did you choose the PMG terminology?
> I see "MPAM implemented by the Trace Buffer Unit, using default PARTID
> and PMG values in External mode". Wouldn't be TBU more meaningful?

Right, TBU seems better. Unless Mark thinks otherwise, will change.
