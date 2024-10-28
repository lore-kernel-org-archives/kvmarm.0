Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C061DC74A
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730123024; cv=none; b=KyrjQlIXphI+pYYlv21K6RTO1G8Va345VMg5VSntDudjpQLwntEmxvaT+Wwm58UtDLrTkPzAbOB0F+zxBXVOHHI98yEELHtOsb9pYBfoxrnbzyEIta0W7qZGjsBiqxeWLAqZAunS0s0ClRBiPqmZPobu5/c0O7pSzaR8WjiKpLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730123024; c=relaxed/simple;
	bh=uMi/PJfX0ne0yB7ZpkaQrwY7lz0yJr3IHebiWoYUnbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHPqLllFfiBZxOb5HjKCdOKy9qTCD1cVcmGwwoRQvQ1IK3XRN2nRvZ6p7+YhImFvsH9QWdY3Sd0pa8VQ+T053nHbgsA2XVDw9yogzqBOcddiq/9MY+o6IQqB4ADv0WeS7OXv8RAghpXWwbrEy1IjGMVdsnlQdukp9AP5tmPXUgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02037497;
	Mon, 28 Oct 2024 06:44:11 -0700 (PDT)
Received: from [10.163.42.200] (unknown [10.163.42.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C4103F66E;
	Mon, 28 Oct 2024 06:43:36 -0700 (PDT)
Message-ID: <92124be9-ffa5-4cf9-bec4-e7d3afb91a96@arm.com>
Date: Mon, 28 Oct 2024 19:13:33 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
 linux-doc@vger.kernel.org
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-3-anshuman.khandual@arm.com>
 <ZxfOeqyb3RvsdYbU@J2N7QTR9R3> <72700154-cbf4-4a0a-b6e2-6f0709dec0ce@arm.com>
 <Zx-E_8SFV74s6xN8@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Zx-E_8SFV74s6xN8@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/28/24 18:05, Mark Rutland wrote:
> On Wed, Oct 23, 2024 at 11:42:37AM +0530, Anshuman Khandual wrote:
>>
>>
>> On 10/22/24 21:40, Mark Rutland wrote:
>>> On Tue, Oct 01, 2024 at 10:06:01AM +0530, Anshuman Khandual wrote:
>>>> Fine grained trap control for MDSELR_EL1 register needs to be configured in
>>>> HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
>>>> is also present. This adds a new helper __init_el2_fgt2() initializing this
>>>> new FEAT_FGT2 based fine grained registers.
>>>>
>>>> MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
>>>> watchpoint exceptions when kernel enters at EL1, but EL2 is also present.
>>>> This updates __init_el2_debug() as required for FEAT_Debugv8p9.
>>>>
>>>> While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.
>>>
>>> [...]
>>>
>>>> +  For CPUs with FEAT_Debugv8p9 extension present:
>>>> +
>>>> +  - If the kernel is entered at EL1 and EL2 is present:
>>>> +
>>>> +    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
>>>> +    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
>>>> +    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
>>>> +
>>>> +  - If EL3 is present:
>>>> +
>>>> +    - MDCR_EL3.TDA (bit 9) must be initialized to 0b0
>>>
>>> AFAICT we need TDA==0 this regardless of FEAT_Debugv8p9 (and e.g. we need
>>
>> That's because MDCR_EL3.TDA=0, enables access to many other debug registers
>> beside FEAT_Debugv8p9, which are currently used and hence this MDCR_EL3.TDA
>> =0 requirement is a not a new one but rather a missing one instead ?
> 
> Yes, that's why I said we need it regardless; it's an existing
> requirement that wasn't documented.

Alright, got it.

> 
>>
>>> MDCR_EL3.TPM==0 where FEAT_PMUv3 is implemented), so we should probably
>>> check if there's anything else we haven't yet documented in MDCR_EL3.
>>
>> Will scan through MDCR_EL3 register and match it with existing documentation
>> i.e Documentation/arch/arm64/booting.rst. If there are some missing MDCR_EL3
>> fields which should be mentioned, will add them via a separate pre-requisite
>> patch ?
> 
> Yes please.
> 
> Mark.

Sure, will separate those changes in a pre-requisite patch as suggested.
