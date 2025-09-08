Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B984A2FAC0B
	for <kvmarm@lists.linux.dev>; Mon,  8 Sep 2025 12:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757333395; cv=none; b=adANWQ09AQMy2DJRe3YTNVVJAX+y+XZ6y/pSo+egwMzUOb13yKAlhk5JNCEDE7pBEVhUTo9c4J6wsL9DnxSr5kzudEH5iiGzFHKZUP+oYYzRKRNkMMb3j/2n9pQa06Lah90uCnCgOUWn7aFWkhFtxsiZiA1h98SO1lM95axRWTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757333395; c=relaxed/simple;
	bh=b5Gw+Yi0J2pXc+Jjdg/dkFcnW+6Ebe/HNfFKuRWdnzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UMrQIYj7nan+sznIhLWW9NKrzJyiazDZgfLw20RwfCBD4OHH2RXm5v0hsORQVQzKYa/HND3TsC7XYszZ1LeaPhju4ZBBzZC8V3xjXSsaFVln67dPN67MBab6ala2JieNqS2uOy2SAH01YjIBt9fsjKy8Zu0j/dU2dnKt4Wy/mNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77A921692;
	Mon,  8 Sep 2025 05:09:44 -0700 (PDT)
Received: from [10.1.36.149] (e121487-lin.cambridge.arm.com [10.1.36.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3C0D23F694;
	Mon,  8 Sep 2025 05:09:52 -0700 (PDT)
Message-ID: <cd2b9f93-d8c0-4b40-a5fe-f3ef80e70198@arm.com>
Date: Mon, 8 Sep 2025 13:09:50 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] arm64: mte: Fix MTE granule mask
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, andrew.jones@linux.dev
References: <20250905124129.32435-1-vladimir.murzin@arm.com>
 <aL7CrQdvNy2V7VwA@e140010.arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <aL7CrQdvNy2V7VwA@e140010.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 9/8/25 12:49, Alexandru Elisei wrote:
> Hi Vladimir,
> 
> On Fri, Sep 05, 2025 at 01:41:29PM +0100, Vladimir Murzin wrote:
>> So it generates correct mask when used together with MTE_TAG_SHIFT
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> ---
>>  arm/mte.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arm/mte.c b/arm/mte.c
>> index 95d58aaa..a1bed8a7 100644
>> --- a/arm/mte.c
>> +++ b/arm/mte.c
>> @@ -26,7 +26,7 @@
>>  #define MTE_TCF_ASYMM	0b11
>>  
>>  #define MTE_GRANULE_SIZE        UL(16)
>> -#define MTE_GRANULE_MASK        (~(MTE_GRANULE_SIZE - 1))
>> +#define MTE_GRANULE_MASK        (MTE_GRANULE_SIZE - 1)
> And this is how it's used:
> 
> #define untagged(p)									\
> ({											\
> 	unsigned long __in = (unsigned long)(p);					\
> 	typeof(p) __out = (typeof(p))(__in & ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT));	\
> 
> I'm going to walk through how MTE_GRANULE_MASK is used, just to make sure I got
> things right this time.
> 
> Without this change:
> 
> MTE_GRANULE_MASK = ~(0..01..1) = 1..10..0 -> LSB 4 bits are zero
> ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT) = ~(1..10..0) = 0..01..1 -> bits 63:60 are
> zero, and what is masked is actually the PAC field, not the logical tag.
> 
> With this patch:
> 
> MTE_GRANULE_MASK = 0..01..1 -> LSB 4 bits are 1
> ~(MTE_GRANULE_MASK << MTE_TAG_SHIFT) = ~(0..01..10..0) = 1..10..01..1 -> bits
> 59:56 are 0, and the logical tag is masked, which is what we want, so:
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 

All correct, before the change we generate mask 0x0fff_ffff_ffff_ffff yet after
the change it becomes 0xf0ff_ffff_ffff_ffff

> Also curious, I remember running the tests and I didn't see an error, how did
> you catch this?

By eyes :D

Thanks
Vladimir

> 
> Thanks,
> Alex
> 
>>  #define MTE_TAG_SHIFT           56
>>  
>>  #define untagged(p)									\
>> -- 
>> 2.34.1
>>

