Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790308;
	b=kRWywhQGpOkn3izrVEhP0267SPoMIMb1GA1EE1si/ST9v0VfWbJH+Iw82OhjmwSuJFjC
	 e2kMf214+e8g1YCHK7QDxrh80CTX3bYEmpF7XWIJmc/O3q5FGeCe7kYkO5q9jegcUnroy
	 GqUF785asR1hEd35j2yM6AR6yTIbCQIQ+S52EyQrVllteWRD1LnytRYofD072O/jWzjRE
	 CYp7iq3UliTn+8fwVHojANlxscJMwj4PAKl/xSBNrNVzLBLyTmVllISuwD/4HWOUvT7eZ
	 BR8bRgElDmwwyf3Tk3X8xBgNviNxNoMXaDlkov8rxH0EkJs6FbbcaaUkoXzFUWSsUcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790308;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=tLn9NlBdSVUSz58JdtDu+F9qp+vEUxjH2T7H0cAfX+E=;
	b=vvCuq2sRc9wmhJkx3LVGWxwHTrOkRwXvz4VuT/7CjVQ3ljwPwM/i4Jw/MDCJvANLEXxf
	 iGDvLOkcWf1GPfO3X+yCP+Oi9pOkhdVlM5NEv8b52KnocrdqjQNK0MsAU7ylMkUrNc25z
	 g+nUKcMk80PWCEoDD0MSTHZ1ZQTHtUGkNlVstHF+Y4/EYocaWrwl1yyX7+Ay7y1hWld7F
	 /k3eY7x4P4fTIf0b2/kdaFKOXrrIGLZ8ypa1nUqiXJs7ZcCXJ0VBLDyoaJ0l++7+i21/K
	 lqe3blHw6DMgXxpxPeSz5HBjfsO/8MyRcQDgIQgQjejWUxLdyOkxA4b83wQVtBSL30g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="lW139yi/";
	arc=none smtp.remote-ip=95.215.58.243
Received: from mta1.migadu.com (out-243.mta1.migadu.com [95.215.58.243])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC06606A32A
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 14:38:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BC06606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lW139yi/
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=8AxK7nkx6Q25xccXZzMNTLYsT/LG228EyrVgmqLTQ9U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795790305; v=1; x=1796395105;
 b=lW139yi/SVGyw6xlKY050XNGYJjgtfTAzD56ebhNHSE/TOd8QtAtYnxbfj2qzH7yJ9HXtsum
 04rZa4FBJRtI1Mf4FjVr8KMFrDMTg7HWY9N2FkcpwajaWmrIZmk5823HU0raLFyAu57zaeJdzU3
 Oe0mwkGWgWG6fEQSJVXutI1A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a1f3988772b981e8;
	Fri, 27 Nov 2026 14:38:25 +0000
X-Mizu-Trace-ID: a1f3988772b981e8
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa937018-0454-4dbb-9e32-a65b46fc7635@linux.dev>
Date: Fri, 27 Nov 2026 14:38:24 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Leonardo Bras <leo.bras@arm.com>
Cc: Wei-Lin Chang <weilin.chang@arm.com>, maz@kernel.org, oupton@kernel.org,
 fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com,
 suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com,
 rkeilty@meta.com, atish.patra@linux.dev, dgreid@meta.com
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK> <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK> <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
 <4jxdf2pkuu2f7dftvf6ltpv27jctfuvvrfcrbfxudsgnp3hdfk@taur55wftexq>
 <awhH1Dpu0uIwP6ea@gremlin> <awh5pmXCbNoFP5Ez@LeoBrasDK>
 <awmDZoqzL_t6A7go@gremlin>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <awmDZoqzL_t6A7go@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 27/11/2026 05:29, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 26, 2026 at 06:25:43PM +0000, Leonardo Bras wrote:
>>>>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
>>>>> index 9a126b9e2d7c99..5b61285d317e28 100644
>>>>> --- a/arch/arm64/include/asm/kvm_types.h
>>>>> +++ b/arch/arm64/include/asm/kvm_types.h
>>>>> @@ -2,7 +2,12 @@
>>>>>  #ifndef _ASM_ARM64_KVM_TYPES_H
>>>>>  #define _ASM_ARM64_KVM_TYPES_H
>>>>>
>>>>> -#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
>>>>> +#define KVM_PGTABLE_FIRST_LEVEL		-1
>>>>> +#define KVM_PGTABLE_LAST_LEVEL		3
>>>>> +
>>>
>>> The -1 isn't needed here at all right? So why not just import
>>> KVM_PGTABLE_LAST_LEVEL and do:
>>>
>>> #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE       KVM_PGTABLE_LAST_LEVEL
>>>
>>> ?
>>
>> Well, it kind of is :)
>> The lowest level we have in a PGTABLE is level -1. (See RKSBQV)
>>
>> It could now be mathematically correct, but it could break in the future if
>> we got a level-2, for instance. We could have (LAST - FIRST - 1), if that
>> one page makes any diference.
> 
> Yup it's level -1 but isn't that only something meaningful for stage-1 I believe
> due to concatenation? As per stage2_pgtable_levels() [where ipa is the number of
> bits not the ipa... :)].
> 
> But you make a good point re: future changes!
> 
> Anyway, Marc has made it clear he wants something based on
> kvm_mmu_cache_min_pages() at runtime, so it's all moot anyway, this needs to be
> reworked for that.
> 
> Usama - I assume you are looking at that now?
> 

Yes, sorry I didnt see this discussion until now, I was trying to prototype
something that fit Marc's suggestion [1] and measure potential cost of it.
Hopefully its reasonable.

[1] https://lore.kernel.org/all/d2b6e735-a685-4e79-bb39-2fb75ebecd09@linux.dev/

> --
> Cheers, Lorenzo

