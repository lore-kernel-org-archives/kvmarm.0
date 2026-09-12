Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7FB35F602;
	Sat, 12 Sep 2026 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203851; cv=none; b=Rij/LfPZ1o1VnEQLwtuR4ipeFtR5hMg3wkk1/GQ04ST+vMWRskVB8jIEJrYhaa8OKZipxUmwWrDSwOJgW5E/DGGe4xcAq/ciN3pLaZkBeZ66I2KK2SUjX3nJDXjHOYD6fKHFuJ/RdrQ6so9V/2Agy/Wadc72rxHR5pWcPLABGoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203851; c=relaxed/simple;
	bh=xD8JxPHjaxpnElNEZUSN/58hUhREedKqk8QVI12u0wI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vhk2uv6XL8Ug5TcZwWL3zA+5ZhG+O7FcqTytjvQsdMJVmYdcODgKmfdKzc8i9NghETzQtQlguM5Yhic6i7hJ920Us+TGhVHEruQ0aJBeBj2YnTEq04KuD6J2dBfX0D2O8a0ppOhSLWuXydp0GFZYW+3HUEHGbR/XmjcT8DrwlpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=acWvDJE1; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="acWvDJE1"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBC041713;
	Sat, 12 Sep 2026 02:03:59 -0700 (PDT)
Received: from [10.57.10.2] (unknown [10.57.10.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 707EA3F7D8;
	Sat, 12 Sep 2026 02:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789203843; bh=xD8JxPHjaxpnElNEZUSN/58hUhREedKqk8QVI12u0wI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=acWvDJE1P4c7LpHpXJeu4VfOKgzzxw9uroFrn2jkgYpCuXwxs0uC67ManQRSFsXjS
	 VlKJXNjzEqcrLHygX2oJ9oZ/qkE0EtmF4/vLYp9nnFPYmjZrr8dvvVXKYe5UeHnUMF
	 MFDAZ1pir4u0iqMXw4nI/WuEvyCsUr3jlqugY76o=
Message-ID: <a50e377b-4ba0-4d08-8176-e5003d44223c@arm.com>
Date: Sat, 12 Sep 2026 10:04:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Oliver Upton <oupton@kernel.org>,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-2-suzuki.poulose@arm.com>
 <20260912084556.2B68E1F00893@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260912084556.2B68E1F00893@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/09/2026 09:45, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] Usage of GENMASK and BIT macros for 64-bit masks causes Undefined Behavior on 32-bit architectures

RMM is only supported for ARM64. But, given this is a header file, I 
could fix them to ULL

Cheers
Suzuki

> --
> 
> commit cfdd0e3f2fb70671ab2dbb64f06ca56946732456
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add SMC definitions for calling the RMM
> 
> This commit introduces SMC definitions for calling the Realm Management Monitor
> (RMM) from the host. The definitions are based on the ARM RMM specification
> version 2.0-bet3.
> 
> Link: https://developer.arm.com/documentation/den0137/2-0bet3/
> 
>> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
>> new file mode 100644
>> index 0000000000000..214d6228dfc22
>> --- /dev/null
>> +++ b/include/linux/arm-smccc-rmi.h
> 
> [ ... ]
> 
>> +#define RMI_ADDR_TYPE_NONE		0
>> +#define RMI_ADDR_TYPE_SINGLE		1
>> +#define RMI_ADDR_TYPE_LIST		2
>> +
>> +#define RMI_ADDR_RANGE_STATE_MASK	GENMASK(63, 62)
>> +#define RMI_ADDR_RANGE_ADDR_MASK	GENMASK(51, PAGE_SHIFT)
> 
> [Severity: Low]
> Can the use of GENMASK for bit positions >= 32 cause undefined behavior on
> 32-bit architectures?
> 
> The GENMASK macro evaluates to unsigned long, which is 32 bits wide on 32-bit
> architectures. Shifting by 32 or more results in truncation or an
> out-of-bounds shift.
> 
> Would it be better to use GENMASK_ULL here for these 64-bit masks?
> 
>> +#define RMI_ADDR_RANGE_COUNT_MASK	GENMASK(PAGE_SHIFT - 1, 2)
>> +#define RMI_ADDR_RANGE_BLOCK_SIZE_MASK	GENMASK(1, 0)
> 
> [ ... ]
> 
>> +enum rmi_ripas {
>> +	RMI_EMPTY = 0,
>> +	RMI_RAM = 1,
>> +	RMI_DESTROYED = 2,
>> +	RMI_DEV = 3,
>> +};
>> +
>> +#define RMI_NO_MEASURE_CONTENT	0
>> +#define RMI_MEASURE_CONTENT	1
>> +
>> +#define RMI_FEATURE_REGISTER_0_S2OASZ			GENMASK(40, 33)
>> +#define RMI_FEATURE_REGISTER_0_L0GPT_BLOCK_DELEGATE	BIT(32)
> 
> [Severity: Low]
> Similarly, will this GENMASK and BIT usage trigger the same undefined behavior
> when evaluated as unsigned long? Using GENMASK_ULL and BIT_ULL might avoid this.
> 
>> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS		GENMASK(31, 27)
>> +#define RMI_FEATURE_REGISTER_0_PMU			BIT(26)
> 
> [ ... ]
> 
>> +#define RMI_FEATURE_REGISTER_3_RTT_S2AP_INDIRECT	BIT(6)
>> +#define RMI_FEATURE_REGISTER_3_RTT_PLANE		GENMASK(5, 4)
>> +#define RMI_FEATURE_REGISTER_3_MAX_NUM_AUX_PLANES	GENMASK(3, 0)
>> +
>> +#define RMI_FEATURE_REGISTER_4_MEC_COUNT		GENMASK(63, 0)
> 
> [Severity: Low]
> Could GENMASK_ULL(63, 0) be used here as well?
> 
>> +
>> +#define RMI_MEM_CATEGORY_CONVENTIONAL		0
>> +#define RMI_MEM_CATEGORY_DEV_NCOH		1
> 

