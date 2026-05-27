Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF31C35E1DA
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 09:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779872444; cv=none; b=qmsI3yFAqRu8jfFq5ToVnQnagy+A7SJvOQJV561BK3zJiwCp7/kJZ3ac7nPcf7Rx1tAfav5X0hs4eXTTyDeUm0bihox2u8DxkFC18K7cwFuiRbg/gdAsiUAG5jNk0s6513r1cM1lI7HBRA+gKi2/4rIO/6krp8gmvUzMmmdMBek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779872444; c=relaxed/simple;
	bh=tRoXISS8LqgyRvm7afnry9qEeeiga3paY5y9AgjongA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ykcuc6PcH+DsdWl85uos1a1b5sIgt2h4zTpnQ1sS0MtSJE1gtZ+bEn+DU3hHZwpOQIm1yzAFFGze0iifkdM2nxnRTMpo67srUeMncPaNtqH5gPU2xhAZJUc+tqVItKVVnVdsyjt65LlKAqpLdJgWe3vbupAn7S3yDswpRkz0q6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rfrcOrtP; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rfrcOrtP"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 037472880;
	Wed, 27 May 2026 02:00:36 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C16D33F7D8;
	Wed, 27 May 2026 02:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779872441; bh=tRoXISS8LqgyRvm7afnry9qEeeiga3paY5y9AgjongA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rfrcOrtP/3cT5qGwxJLVURcm6NBchGq4gfy6U73co9K59/f2xh/rt2XfV6FJr1AHL
	 EOGBjTCbF2vuBx77kiL3qbe+ye3zK7oZSX21o3hKFjqcqYmNXNIvh3IkoD+J7TnoD+
	 ilZv4lAFCL+pngMZqcmtuq4yMygWJBeG4FNEzGyo=
Message-ID: <ff52c7e7-3ff7-46df-a6ea-3be7fe7e8248@arm.com>
Date: Wed, 27 May 2026 10:00:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com> <ahWpST4K3rbMbjWK@J2N7QTR9R3>
 <08e5ce52-be74-4fc5-a0b2-8f405a5eff99@arm.com> <ahW8Eba3SNqfVDdk@J2N7QTR9R3>
 <ahXMkPEpgaZQf_Nk@J2N7QTR9R3>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <ahXMkPEpgaZQf_Nk@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 5/26/26 17:38, Mark Rutland wrote:
> On Tue, May 26, 2026 at 04:28:17PM +0100, Mark Rutland wrote:
>> On Tue, May 26, 2026 at 03:39:56PM +0100, Vladimir Murzin wrote:
>>> Hi Mark,
>>>
>>> On 5/26/26 15:08, Mark Rutland wrote:
>>>> On Thu, May 21, 2026 at 02:25:55PM +0100, Mark Rutland wrote:
>>>>> +static inline void __sme_save_za(struct sme_state *state, unsigned long svl)
>>>>> +{
>>>>> +	/* The <Wv> argument to STR (array vector) can only encode W12-W15 */
>>>>> +	register unsigned long v asm ("12");
>>>> Sorry, I had meant to put "x12" here, but evidently GCC and LLVM accept
>>>> "12" on its own.
>>>>
>>>> For clarity (e.g. to match the comment) I'll change that to "w12" and
>>>> make the type unsigned int. Likewise in __sme_load_za().
>>> I suspect you are intentionally not using "Ucj" constrain to limit register allocator,
>>> if so I'm wondering why?
>> Thanks for the suggestion; that was ignorance rather than intent.
>>
>> I was not aware of "Ucj" as it doesn't appear on the public GCC
>> documentation:
>>
>>   https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html
>>
>> Looking at the machine description file, that's marked with '@internal',
>> so IIUC GCC folk don't seem to expect/want people to use it. That said,
>> LLVM seems to support it.
>>
>> I'll go check that all relevant toolchains support this, and poke GCC
>> folk to see if they're happy to promote that to a public constraint.
> GCC folk seem happy to make this public, which is great! I'll cross-link
> a thread here if/when patches appear.
> 
> In the short term, using "Ucj" would require bumping our minimum
> supported toolchain necessary for SME:
> 
> * GCC gained "Ucj" in 14.1.0, tagged on 7 May 2024.
> 
> * LLVM gained "Ucj" in 18.1.0, tagged on 27 Feb 2024.
> 
> ... so using that would require adding a dependency on a newer
> toolchain, e.g. via a CC_HAS_UCJ_CONSTRAINT to match the existing
> CC_HAS_K_CONSTRAINT.
> 
> Aligned with the rationale on patch 8, v6.16 (tagged 27 July 2025) was
> contemporary with GCC 15.1.0 (tagged 25 April 2025) and LLVM 20.1.0
> (tagged 4 March 2025), both of which supported "Ucj".
> 
>> If that's all good, I'll move over to "Ucj". If not, I'll update the
>> commit message and/or comments to explain why.
> If Will and Catalin are happy to depend on a toolchain as above, I'll go
> add the necessary CC_HAS_UCJ_CONSTRAINT Kconfig logic.
> 
> Otherwise I'll go note the above in a comment, and stick with the
> register variable for now.
> 
> Mark.
> 

Wow, I had no intention for generating this amount of work for
you - thanks for digging into that! FWIW, either way works for me :)

Cheers
Vladimir
