Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0EF2E7366
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779981748; cv=none; b=JHGOPsNagk4MptsWC0dfn1iI4L35ryDkh+BONwIOgQ7tNsx/niIX57hIlzLXrR36ptRJmShpGGGvoIpbrHWDR18KRaqSXkMMCC1SHhX/f9OceEWDmmgJawZqL2a8lpSOyaTUuopLjwiikLPc0xEJlLlu4JvQNxmedVRq5EBSlvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779981748; c=relaxed/simple;
	bh=8NF5sOfbYqdJ+Oi40pkak1BHMRDOWEn0PDRBCK7Y+3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LFw828nl9/mge2Eh1GLjcxCB3vhY30W8VPjyvknxXNLQuz/VUyALBFyjTKHGIAJf/CXSDeNbmFd8Jr80YIMa1JbODZxq5tyI3SJgfiCiGaE/B+exEzrUeaTQ3fB/MAIt3TJnGKOyGq7+jVChbzeiaV5eBRtN5HstPqZfiKPhTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VoADWMMg; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VoADWMMg"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3DB822EE;
	Thu, 28 May 2026 08:12:11 -0700 (PDT)
Received: from [10.1.28.164] (unknown [10.1.28.164])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C0353F632;
	Thu, 28 May 2026 08:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779981136; bh=8NF5sOfbYqdJ+Oi40pkak1BHMRDOWEn0PDRBCK7Y+3k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VoADWMMgkS3/wOGyrN0GnZr6E1eKpgfDw2zrAb2OVDTfqw0VFyXsxwikDRyFwAS+q
	 tb1PPUuOPsScHjfpRQ1oABnQ0FJxfbOpEHkpkQcEVnC4jwXs7m9yRYkaEg6P9cZhAU
	 WH4N+L9yufWTN0WxbgkVLVIEJL9CXiQWjnnEClrA=
Message-ID: <518b2b2f-53c0-4082-b764-54c0e3bc2b92@arm.com>
Date: Thu, 28 May 2026 16:12:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/18] KVM: arm64: pkvm: Remove struct cpu_sve_state
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-5-mark.rutland@arm.com>
 <9670cf97-b844-4029-b77e-25ade600e024@arm.com>
 <ahcVsVGPtOmF0nIC@J2N7QTR9R3.cambridge.arm.com>
 <4e15c17e-06c0-414f-ae9d-210c70d1757f@arm.com>
 <ahhapwyfE7WrBCby@J2N7QTR9R3.cambridge.arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <ahhapwyfE7WrBCby@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/26 16:09, Mark Rutland wrote:
> On Wed, May 27, 2026 at 05:11:26PM +0100, Vladimir Murzin wrote:
>> On 5/27/26 17:02, Mark Rutland wrote:
>>> On Wed, May 27, 2026 at 12:58:47PM +0100, Vladimir Murzin wrote:
>>>> On 5/21/26 14:25, Mark Rutland wrote:
>>>>> -struct cpu_sve_state {
>>>>> -	__u64 zcr_el1;
>>>>> -
>>>>> -	/*
>>>>> -	 * Ordering is important since __sve_save_state/__sve_restore_state
>>>>> -	 * relies on it.
>>>>> -	 */
>>>>> -	__u32 fpsr;
>>>>> -	__u32 fpcr;
>>>>> -
>>>>> -	/* Must be SVE_VQ_BYTES (128 bit) aligned. */
>>>>> -	__u8 sve_regs[];
>>>> It seems that the requirement (driven by SVE ldr/str) is
>>>> satisfied with the new sve_regs pointing to the start of the
>>>> page.
>>>>
>>>> I'm not sure whether we want to keep the comment (or perhaps
>>>> enforce this with explicit checks) so that future refactoring
>>>> doesn't lead to time spent debugging alignment faults...
>>> AFAICT alignment has never been functionally necessary. The LDR (vector)
>>> and STR (vector) instructions only mandate alignment when the relevant
>>> SCTLR_ELx has SCTLR_ELx.A==1. For kernel and hyp code we configure
>>> SCTLR_ELx.A==0, so there's no alignment requirement.
>>>
>>> Per ARM DDI 0487 M.b, section C8.2.437 "LDR (vector)":
>>>
>>>   The load is performed as contiguous byte accesses, with no endian
>>>   conversion and no guarantee of single-copy atomicity larger than a
>>>   byte. However, *if alignment is checked*, then the base register must be
>>>   aligned to 16 bytes.
>>>
>>> Per ARM DDI 0487 M.b, section C8.2.777 "STR (vector)":
>>>
>>>   The store is performed as contiguous byte accesses, with no endian
>>>   conversion and no guarantee of single-copy atomicity larger than a
>>>   byte. However, *if alignment is checked*, then the base register must be
>>>   aligned to 16 bytes.
>>>
>>> ... and in both cases the pseudocode shows that AlignmentEnforced()
>>> depends on the value of SCTLR_ELx.A.
>>>
>>> Given that, I don't think we need the comment.
>>>
>> Thanks for explanation! Maybe worth mentioning in commit message that it never was
>> a requirement? 
> I've added the following to the commi message:
> 
>   I've dropped the comment regarding buffer alignment as AFAICT this was
>   never necessary. The LDR/STR (vector) instructions only require this
>   alignment when SCTLR_ELx.A==1, which is not the case for the kernel or
>   hyp code. Nothing else depends on the alignment.
> 

Brilliant!

Thanks
Vladimir

> Mark.
> 

