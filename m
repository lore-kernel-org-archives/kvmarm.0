Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5048C19F424
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 05:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745905059; cv=none; b=bObkyh54u9H3cyUw/2g8GUnBZ/eHh1XGLDC+8mMj7OkrZ8MGI9CbdItYSdFgDkxpeVJWmPwNfsWOezwvzSwQapmZWroXOk+JaYCFt+Lft6eMq2r/d5Sg3SNJguK7ZctLVXeCZD/qtZM5zwAhyzyqlCB2szzrLABHj9Aoc+R7WCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745905059; c=relaxed/simple;
	bh=KFqzEyNKOFOAeSkTWy5DiiPoP4XGs7Kz86yGcU1/JJw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XxiBhC47EaWhp9+3LQqOPZTwgVysXu7V7SyrI0pNilaXeVnJ2n+st4NubU9UZKFkWy0OnH5kn2jDHmYuH3QjknGy0OSk/ACWL2rZ8yQ84ihtix/QqvxCulih8pTT642p3a3gO8wLjd0EJ1rAM+7lKv4m7cUKNkMG9vkXy1pYoTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E36411515;
	Mon, 28 Apr 2025 22:37:30 -0700 (PDT)
Received: from [10.163.52.122] (unknown [10.163.52.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D23DC3F5A1;
	Mon, 28 Apr 2025 22:37:32 -0700 (PDT)
Message-ID: <06140631-c3cb-4837-bb4c-bdff30863ad2@arm.com>
Date: Tue, 29 Apr 2025 11:07:28 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, robh@kernel.org
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvmarm@lists.linux.dev, stable@vger.kernel.org
References: <20250227035119.2025171-1-anshuman.khandual@arm.com>
 <174171335999.3659520.16613654046629962007.b4-ty@arm.com>
 <ddeb3df1-995b-44f4-ad20-50edfb906a28@arm.com>
Content-Language: en-US
In-Reply-To: <ddeb3df1-995b-44f4-ad20-50edfb906a28@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/12/25 09:16, Anshuman Khandual wrote:
> 
> 
> On 3/11/25 22:47, Catalin Marinas wrote:
>> On Thu, 27 Feb 2025 09:21:19 +0530, Anshuman Khandual wrote:
>>> FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
>>> access from EL1 requires appropriate EL2 fine grained trap configuration
>>> via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
>>> Otherwise such register accesses will result in traps into EL2.
>>>
>>> Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
>>> grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
>>> bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
>>> PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.
>>>
>>> [...]
>>
>> Applied to arm64 (for-next/el2-enable-feat-pmuv3p9), thanks!
>>
>> [1/1] arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9
>>       https://git.kernel.org/arm64/c/858c7bfcb35e
>>
>> I removed Cc: stable since, if it gets backported automatically, it will
>> miss the sysreg updates and break the build. Please send it to stable
>> directly once it lands upstream, together with the dependencies.
> 
> Sure, will do that.
> 

Just FYI,

This patch along with required tools sysreg patches are merged in applicable
stable branches which are now available in v6.12.25 and v6.14.4 respectively.
