Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D6F360EF4;
	Fri,  2 Oct 2026 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790954894; cv=none; b=TzwvmhdhNUkvHIu5wEfn4OuzUl2ks6OTeW/DQ4eA+RAQDO7lDoQxKSh9u7NFxByPyGj6bGg0filR3rAe6Fj8zWcXpgjPjp9wQw+qmW9pVX3CPLfZ+zTnViTTn7oqPbyknoiU2Bp0DmZutRSNSdDkWkiWFQ2byVQyaNagNiDQs6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790954894; c=relaxed/simple;
	bh=jSesLRiSeGml5Tnrjg/pe9P+zipvIwJDessg3nPTnYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0rVs2xP2e3on1M0PBWisNyS5VwAX/ENSds8EL41VPrzh7/AAfUPd6c5tg9qngp1bj7zqo2UEWYZ7XnSQnu57zN1HphgFB1ngimTUfxMsa4uTQMezAFAmSdzUFKb4JPCEV5iAq16IBAgF2fdEsm4vTZD0gfUOl6EqdXjJWmEPf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hAwzBJxk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hAwzBJxk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3E4D1476;
	Fri,  2 Oct 2026 08:28:08 -0700 (PDT)
Received: from [10.57.8.170] (unknown [10.57.8.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD2013F85F;
	Fri,  2 Oct 2026 08:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790954892; bh=jSesLRiSeGml5Tnrjg/pe9P+zipvIwJDessg3nPTnYU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hAwzBJxktNKlnMFxSzOnuLVq2YuNzJ/DaM11nCmTz07uIzhDiXOJ79lEd1F5eCV38
	 mWM79MLDCyjXlTpcX6J6HMTkq9NqYKq1rwVSZVpy6cVbj4X41jX9RDAL1L2gn2q1Tf
	 Lc6ajo6DhJ6lHPA+rh+V5D68sRn9lbM+X8jl8+GE=
Message-ID: <1910861a-1188-4ba9-ace9-be82304c95a5@arm.com>
Date: Fri, 2 Oct 2026 16:28:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 09/10] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-10-suzuki.poulose@arm.com> <ar-QC4vtcULyJ5dW@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ar-QC4vtcULyJ5dW@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2026 12:05, Catalin Marinas wrote:
> On Fri, Oct 02, 2026 at 07:15:05AM +0100, Suzuki K Poulose wrote:
>> +/*
>> + * rmi_smccc_invoke_once: Invoke the RMI call and return the results. Do not
>> + * retry the command. Let the caller deal with RMI_BUSY or RMI_BLOCKED.
>> + *
>> + * @regs: Input parameters filled in. Updated with the ouptput results
>> + * after the call.
>> + */
>> +static __always_inline void rmi_smccc_invoke_once(struct arm_smccc_1_2_regs *regs)
>> +{
>> +	struct arm_smccc_1_2_regs args = *regs;
>> +
>> +	arm_smccc_1_2_smc(&args, regs);
>> +}
> 
> Nit: I mentioned on v21 - is the copy to args still needed? Can we not
> do just:

Sorry, yes, you are right. This is a single call and we are fine to
overwrite the results.

> 
> 	arm_smccc_1_2_smc(regs, regs);
> 
> (no need to respin, I can fix it locally)

Yes please

Suzuki

> 

