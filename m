Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94AA309F13
	for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 11:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761651852; cv=none; b=LfFMvIuP9P796VSpc52ApC8+NT10nRoAlKvKlFLNayxYN3GBeJ4VPHqmNrJDl3vvX05VrFHxsm7qFO6sOcj7H89R4n5dCBNkDQ6+PhR38Otm6DXG9yWb8cfGhL13CsMknUjcyPVoL8AHdAs/IYqfFarkn/Sc1Kpq67xpDmRImHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761651852; c=relaxed/simple;
	bh=poij8wlwwOv2xQkmm5yAYpdmtg97F2oQvtny01XIVT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=spQ5YI6as9wQJ/j2JhubcWpxBpSvGL1yHV/ihgEat/zvhjjBjlmt4dj2EQXsxSxVVysH7C1HbFujTTMYkuaueXO8gFp5bBNY4Tknin8JQB4AcDuhK+orz29WNLWfupY1ol4iiuVahJP63b0AgBUJJOrotQvhaIK2IJuIsTUpTKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/tJquwi; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/tJquwi"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee130237a8so3826142f8f.0
        for <kvmarm@lists.linux.dev>; Tue, 28 Oct 2025 04:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761651848; x=1762256648; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PWcMpUbr5EvoYwg6OCCvCq3zKJMQIWwwgnasyRi2T/U=;
        b=F/tJquwi1Y3FoXPpq57UAI4Q5E8K+5lAxtzNXLibRTVdhS9ud4WwnjUAfxWhoiq4gz
         bOqSVpLHOeBOZUYEK3pLroq4/S7juSD2SUEeKes8b38ZTHFRzB0FgTR2NBVRFcssWdWk
         LY0QooL1XQvnr3Fr+HczZFYeB37zlJSwlh0EeCJX4rTrsXfks5fANoq4IncnpnWulxOS
         xxNGPiuFva3S/uYCVT+nZWx2A64QvmA2tDsnmYziQX6+vzL2fMug13PFtrKSJEwV39TC
         GN5MDnzNUOKfOvXfDUjsmeDq1KMDZrgTph5ZUNgJC15KARDR7JBjLPGwya7wR68rSHoW
         QSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761651848; x=1762256648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWcMpUbr5EvoYwg6OCCvCq3zKJMQIWwwgnasyRi2T/U=;
        b=bqbfUGYO8pxJS+MXIwXLVndbm46EcL+GmN1PosGNtwPArsyQuhj2fT7wqoGqk6N6SX
         Un2IAT/zu3ERz2YHImgTHZOuHuT2p6KnFdLplsAWy1KYQCmJ4JuGrKt09xD5TU6P2kJO
         c4ySLsDsk0EjWWE/lIhR5KxiM9+CsBuSPjz4Xhtzuiq1BR6sglAmz5A0t0qLkHXtI9b/
         r0XDG5DqnGb3Yb2CxlVejFGQrigEO2SS2stTO1RjZ6iEe31cC1Rcpq5VTx/l/4Vhbp7g
         WIxRTAmjexddXCC2y/zpDBVCoHRjWnNhwTo6okguq8JCu/i/J0vPUaCD0dwNNIDvf/ul
         YTyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDFaayAW3CdwMr3y4W/3195zOOiMdUvSrmcr9qKfUjwrIzZMeXKaYGYxp2EeymjfrTtd1PqEc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXgzJodH1gp9g3XHZRxxoP5uvCIQkHBIY0dBeo1F8J7SfOg3c3
	0qKnr1FO8iJxa3ON2rO0yi0Dy6NmBapGymH/n6tZrIcVXXsPUnjGXZnJ
X-Gm-Gg: ASbGncsMdlCv86wbjr2Ha3ZzAYiQYj/Md8TaRtWXZmixAFN9wd0+Bo65RAaOo9KCqYF
	ITZXxyMZHwRQ92fX1oJG9JVNyqief3X/drMgwdp14pE+BfE55BNyhYdRh9G7FCZmzyUeow26f4z
	1/eW5c/y3juz3/aQyctIZfEXQkGICbp5/mvQNdbn65895Y5T9UmquEkvd2mKyo39+AjxNYxey2C
	Gz2XocX90QdTGclIbhFRrMyU5gNpCJsz6W50Scxf19KEMKPtkp3LyRofU38tqSTSOxgfB/7kDln
	qPJxPsjGktDz+pwd/lViAbUXYDNzjgluBHtd7FvvAwaCI1n9dGEajY1lXhkFTMMfAFx83Zs3X1B
	zcZUS7SNUxFRqzWo0tpBRUv29afWlgl3ZtOfJvPfMeIMSoL11Y9zWgZs2DaOwdlx9NG2dDp7COP
	v/RAe4JcEpL4qgkJjlyUeX
X-Google-Smtp-Source: AGHT+IGWKlgpP2z1QhsSUQHXl7C4b+OW6D0eUSaDQiNKqIYxyLK5t9gJfLBx15l4AM6BkXPesoBDGw==
X-Received: by 2002:a05:6000:3103:b0:429:8cda:dd4e with SMTP id ffacd0b85a97d-429a7e732bdmr2556153f8f.32.1761651847905;
        Tue, 28 Oct 2025 04:44:07 -0700 (PDT)
Received: from [10.24.67.204] ([15.248.3.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b7b43sm20301815f8f.6.2025.10.28.04.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 04:44:07 -0700 (PDT)
Message-ID: <c52db7bf-494f-49a8-9829-3805db6dda7c@gmail.com>
Date: Tue, 28 Oct 2025 11:44:06 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] KVM: selftests: Fix unaligned mmap allocations
Content-Language: en-GB
To: Sean Christopherson <seanjc@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, pbonzini@redhat.com,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 isaku.yamahata@intel.com, roypat@amazon.co.uk, kalyazin@amazon.co.uk,
 jackabt@amazon.com
References: <20251013151502.6679-1-jackabt.amazon@gmail.com>
 <20251013151502.6679-3-jackabt.amazon@gmail.com>
 <aPpi1c-8EpWuo87B@google.com>
From: "Thomson, Jack" <jackabt.amazon@gmail.com>
In-Reply-To: <aPpi1c-8EpWuo87B@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 23/10/2025 6:16 pm, Sean Christopherson wrote:
> On Mon, Oct 13, 2025, Jack Thomson wrote:
>> From: Jack Thomson <jackabt@amazon.com>
>>
>> When creating a VM using mmap with huge pages, and the memory amount does
>> not align with the underlying page size. The stored mmap_size value does
>> not account for the fact that mmap will automatically align the length
>> to a multiple of the underlying page size. During the teardown of the
>> test, munmap is used. However, munmap requires the length to be a
>> multiple of the underlying page size.
> 
> What happens when selftests use the wrong map_size?  E.g. is munmap() silently
> failing?  If so, then I should probably take this particular patch through
> kvm-x86/gmem, otherwise it means we'll start getting asserts due to:
> 
>    3223560c93eb ("KVM: selftests: Define wrappers for common syscalls to assert success")
> 
> If munmap() isn't failing, then that begs the question of what this patch is
> actually doing :-)
> 

Hi Sean, sorry I completely missed your reply.

Yeah currently with a misaligned map_size it causes munmap() to fail, I
noticed when tested with different backings.

>> Update the vm_mem_add method to ensure the mmap_size is aligned to the
>> underlying page size.
>>
>> Signed-off-by: Jack Thomson <jackabt@amazon.com>
>> ---
>>   tools/testing/selftests/kvm/lib/kvm_util.c | 12 +++++-------
>>   1 file changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
>> index c3f5142b0a54..b106fbed999c 100644
>> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
>> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
>> @@ -1051,7 +1051,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>>   	/* Allocate and initialize new mem region structure. */
>>   	region = calloc(1, sizeof(*region));
>>   	TEST_ASSERT(region != NULL, "Insufficient Memory");
>> -	region->mmap_size = mem_size;
>>   
>>   #ifdef __s390x__
>>   	/* On s390x, the host address must be aligned to 1M (due to PGSTEs) */
>> @@ -1060,6 +1059,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>>   	alignment = 1;
>>   #endif
>>   
>> +	alignment = max(backing_src_pagesz, alignment);
>> +	region->mmap_size = align_up(mem_size, alignment);
>> +
>> +	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
>> +
>>   	/*
>>   	 * When using THP mmap is not guaranteed to returned a hugepage aligned
>>   	 * address so we have to pad the mmap. Padding is not needed for HugeTLB
>> @@ -1067,12 +1071,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>>   	 * page size.
>>   	 */
>>   	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
>> -		alignment = max(backing_src_pagesz, alignment);
>> -
>> -	TEST_ASSERT_EQ(guest_paddr, align_up(guest_paddr, backing_src_pagesz));
>> -
>> -	/* Add enough memory to align up if necessary */
>> -	if (alignment > 1)
>>   		region->mmap_size += alignment;
>>   
>>   	region->fd = -1;
>> -- 
>> 2.43.0
>>

-- 
Thanks,
Jack
