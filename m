Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA2D1BD9C9
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 14:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783606021; cv=none; b=UrXjOQs2yS0HcU2xgVEiwqkKXD1VtqYvHxpk2Lpi9A58nyOdviX430UeO2+9RoCIo9YZXFrT8+ZwouEkGsLhp8XA9a9M8zazOkt5d1XbExgcL9dCL0+cJoJGbp4LXPCjLEVLwWQroarntTKX3z8/OydHvfjbGA4OYtG+arMcWvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783606021; c=relaxed/simple;
	bh=pViZnXqb0KK79+fc1RT7BtJbAnFIoRae4s0WiebrD2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cW6IyQc2za9o/8HMZ9lSxz/NT2n+/W/l4fjj3IHUwHSY60UC0OCcHDpirc80I7jRjZ2HrpNjV6gU+D9RjvFwPQazeA2z8c2CX8gOCZl5GWfOxpIITdO4+mBNZ/qCKARMLcnkhQWw7wFWwpbxIhauzv4tPxcHIFcqifb6Fw90WEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uTLDDJyT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uTLDDJyT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 99DCC3592;
	Thu,  9 Jul 2026 07:06:54 -0700 (PDT)
Received: from [10.164.19.51] (unknown [10.164.19.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48AC13F66F;
	Thu,  9 Jul 2026 07:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783606018; bh=pViZnXqb0KK79+fc1RT7BtJbAnFIoRae4s0WiebrD2M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uTLDDJyTau3bLABjLLUAsXZO0NoEZRNeb++v4NI9cdsz68VOrDAXfXOCvz0JxeJP5
	 TdKkVpVoyWtqcO22Fa0UYGdig7M0ZBrMq8ZkE9GEj1QP9QqyUPY2QkekeaLbjGN1dc
	 xmIxx9Au4olfGye1Kv3FMM04Q01FEXdKVODZmmEc=
Message-ID: <9ec6f07f-6019-493b-9781-5a743b820062@arm.com>
Date: Thu, 9 Jul 2026 19:36:52 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] KVM: arm64: Record whether pKVM stage 2 mapping is
 cacheable
To: Marc Zyngier <maz@kernel.org>
Cc: Bradley Morgan <include@grrlz.net>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260701192428.17430-1-include@grrlz.net>
 <a3b2423e-d8bc-4713-90ef-5bfac7079834@arm.com> <87echh6xuh.wl-maz@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <87echh6xuh.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 06/07/26 12:57 am, Marc Zyngier wrote:
> On Sun, 05 Jul 2026 15:08:58 +0100,
> Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 02/07/26 12:54 am, Bradley Morgan wrote:
>>> pKVM keeps its own mapping list for stage 2 operations. Its flush path
>>> uses that list directly, so it lost the PTE attribute check done by the
>>> generic stage 2 walker.
>>>
>>> Record whether a mapping is cacheable and skip cache maintenance for
>>> mappings that are not cacheable.
>>>
>>> Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
>>
>> Is Fixes tag required? If I am reading correctly, Arm ARM says this:
>>
>> "For VA-based cache maintenance instructions, the instruction operates on the
>> caches regardless of the memory type and cacheability attributes marked for
>> the memory address in the VMSA translation table entries. This means that
>> the effects of the cache maintenance instructions can apply regardless of:
>>   Whether the address accessed:
>>     Is Normal memory or Device memory.
>>     Has the Cacheable attribute or the Non-cacheable attribute."
>>
>> So nothing goes wrong if we do dcache clean for non-cacheable
>> memory.
> 
> Two things:
> 
> - having to perform CMOs for something that is not *expected* to be
>   cacheable is both pointless and a contradiction of the intent
> 
> - what you quote is about the nature of the *mapping*, and not the
>   memory that is being mapped. Cleaning a dirty cache line on an
>   unsuspecting MMIO endpoint is never going to end nicely. Just have a
>   try.
> 
> My reading of all this is that a fix indeed is required, and therefore
> a Fixes tag *must* be present.

Thanks for explaining.


> 
> 	M.
> 

