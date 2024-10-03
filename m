Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4557120328
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 03:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727927319; cv=none; b=gNMioWFGPGNBQiEdgbAuqR6r6AtT9naCR+6rvU5Q+gFxO1MITDeKAmVUcocgdRpmXkihAF6+bxHeQJ/5KCHj7/naQfDn6M76kAD/vNdCUjknYjzozrZppu09ZlBVovnrAsSaTzlpG7ZY59meFu2CRDHdO9k58EOuKgT1g4NJ238=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727927319; c=relaxed/simple;
	bh=f1F2H9LvZV6NayIQvLD4dI+iEjEWuuM+Di1uRkwDfk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRXBZ6OHjz06rrHkSymYoI3pe1+pm4/QHcmuryxwdJ7tT9gMBcrNLVVdFnv2DGnCphqIMTqTbSeqpDda5Zdpt9SN6m0issZM0QNl8tB4FgV9PvExG1D/afOfDsjoOIZ7xgHtGDzDZAa6S1+6BSq3ynKpLEmkIwTtYvJZpH81g0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27125339;
	Wed,  2 Oct 2024 20:49:07 -0700 (PDT)
Received: from [10.163.37.202] (unknown [10.163.37.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B13A3F640;
	Wed,  2 Oct 2024 20:48:34 -0700 (PDT)
Message-ID: <dfef3a11-2fdc-4c33-b6ad-ccebaad476f5@arm.com>
Date: Thu, 3 Oct 2024 09:18:33 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/47] arm64/sysreg: Add register fields for
 ID_AA64DFR2_EL1
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20241001024356.1096072-1-anshuman.khandual@arm.com>
 <20241001024356.1096072-5-anshuman.khandual@arm.com>
 <fe8a2d61-4aeb-4f56-b0d0-90bbfe512c74@sirena.org.uk>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <fe8a2d61-4aeb-4f56-b0d0-90bbfe512c74@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/2/24 21:18, Mark Brown wrote:
> On Tue, Oct 01, 2024 at 08:13:13AM +0530, Anshuman Khandual wrote:
> 
>> This adds register fields for ID_AA64DFR2_EL1 as per the definitions based
>> on DDI0601 2024-06.
> 
> DDI0601 2024-09 has now been released...
> 
>> +Sysreg	ID_AA64DFR2_EL1	3	0	0	5	2
>> +Res0	63:8
>> +UnsignedEnum	7:4	BWE
>> +	0b0000	NI
>> +	0b0001	IMP
>> +	0b0010	IMP_WPT
> 
> Could equally name that BWE2 since this is for FEAT_BWE2.  I'm OK either
> way I think, with a slight preference for BWE2 I think.  Either way:

Sure, will change this as s/IMP_WPT/BWE2 instead.

> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
