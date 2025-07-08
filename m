Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3FB25C810
	for <kvmarm@lists.linux.dev>; Tue,  8 Jul 2025 09:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751967732; cv=none; b=P1oCxwuKevIsNd5qgTHorqs3TA2RyXslSLCHvPp4VHE15lefvHbn2mkSq5Nct9Q5ueY2YXOOiTaQMmDd9yXrbVsFbSyJaxucHaV1wx1rWDEQ4rjO7SNWjO1PrJKGEFrCIGwTIAtj2e7tk8rvF2i5vGEy7O5rBCerFvkdMrU6whU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751967732; c=relaxed/simple;
	bh=se5x0yYrCUL+63fhhT38J9iOQc4ZRvtcA/JM8IxxtjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUgeiZET0vjeVCtlcHX8AaReBKvdIwBYkd003qpoVAS7EHr2sxD2TxZW+dUmlwvFb3TuKpbkYfRgtKUJeFkioirBEy7Lr1TF2YmJM59Fm77D4Ky2L7vTyiikDLABhSZZdtp3BcxQ6fhsUvJsNqQxIKPIkmccoLay1+61cjY6l/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59DDF153B;
	Tue,  8 Jul 2025 02:41:57 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB3413F77D;
	Tue,  8 Jul 2025 02:42:07 -0700 (PDT)
Message-ID: <03a76e9a-86ac-4791-9f0a-494b28c07fcc@arm.com>
Date: Tue, 8 Jul 2025 10:42:06 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bitfield: Ensure the return value of
 type##_replace_bits() is checked
To: Yury Norov <yury.norov@gmail.com>
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux@rasmusvillemoes.dk,
 linux-kernel@vger.kernel.org, james.morse@arm.com
References: <20250703135729.1807517-1-ben.horgan@arm.com>
 <20250703135729.1807517-3-ben.horgan@arm.com> <aGv2WoAtxnEgqV4y@yury>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <aGv2WoAtxnEgqV4y@yury>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yury,

On 7/7/25 17:31, Yury Norov wrote:
> Hi Ben,
> 
> On Thu, Jul 03, 2025 at 02:57:29PM +0100, Ben Horgan wrote:
>> As type##_replace_bits() has no side effects it is only useful if its
>> return value is checked. Add __must_check to enforce this usage. To have
>> the bits replaced in-place typep##_replace_bits() can be used instead.
>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>   include/linux/bitfield.h | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
>> index 6d9a53db54b6..39333b80d22b 100644
>> --- a/include/linux/bitfield.h
>> +++ b/include/linux/bitfield.h
>> @@ -195,8 +195,8 @@ static __always_inline __##type type##_encode_bits(base v, base field)	\
>>   		__field_overflow();					\
>>   	return to((v & field_mask(field)) * field_multiplier(field));	\
>>   }									\
>> -static __always_inline __##type type##_replace_bits(__##type old,	\
>> -					base val, base field)		\
>> +static __always_inline __##type __must_check type##_replace_bits(__##type old,	\
>> +							base val, base field)	\
>>   {									\
>>   	return (old & ~to(field)) | type##_encode_bits(val, field);	\
>>   }									\
> 
> So, would it make sense to mark _encode_bits() and _get_bits() as
> __must_check as well? At least from the point of unification, it
> would.
Could do. It seems less important as there are no obvious foot-guns that 
these would guards against. Would you like me to add this in a v2?
> 
> How would we move this - with my bitmap-for next or with arm branch?

I'm not familiar with the branch machinery so can't comment on this.
> 
> Thanks,
> Yury
> 

Thanks,

Ben

