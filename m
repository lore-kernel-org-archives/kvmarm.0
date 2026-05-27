Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EA22FFFA4
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898291; cv=none; b=jwZJY7WLnrtWZobg2edfS1U3oGnzsr+xHqWa2aF6CH3m3yg6IVTXebdXQO6tHqnSxcUUvE5V3j0otNnJQ2tZREUph2c2VWTeEBwCJsTHu7dK9KHZulQDXY2t/KaCtqbOgg9ZE5VfhPwjlvnpapCPJl9NVV9D/y5fP/pbyBEKlRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898291; c=relaxed/simple;
	bh=a/fVeno9Ozv19QNSha+ePKwWADScCuTg8j3BI1F5TYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jmft8+qUffnRqS1nKHMGpYbNmce8WH6KmD2InHA3jTKl2UbKV8RrnefUxx73rkI9GfpTyYb1m09Kc6FhJvV6vWWhHpr0gNLf9KBpaarwXlnBbhl50Xbmo0Ni0Qsb5SAOJB9oH9ogM/30F1i94J5biD1yyDFMWEZH2RaBKqNml8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WN03JOHq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WN03JOHq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3EDD35B9;
	Wed, 27 May 2026 09:11:24 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D62393F905;
	Wed, 27 May 2026 09:11:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779898289; bh=a/fVeno9Ozv19QNSha+ePKwWADScCuTg8j3BI1F5TYM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WN03JOHqQrCwthcqRapVvzSX4NcN9IVw4NVxioLtjw316tB8yry+eN7m7jd7Dn2xB
	 82d3gXzeAVS31swIaww2cIn2z4q4SjoLlLM2/f6GfU4GPiPFGnu3wiDQFkEewtZ9W1
	 3QbFV8ZDkuPPqC/J2twXWgpOeE/DprJ/BL5VILUA=
Message-ID: <4e15c17e-06c0-414f-ae9d-210c70d1757f@arm.com>
Date: Wed, 27 May 2026 17:11:26 +0100
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
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <ahcVsVGPtOmF0nIC@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/27/26 17:02, Mark Rutland wrote:
> On Wed, May 27, 2026 at 12:58:47PM +0100, Vladimir Murzin wrote:
>> On 5/21/26 14:25, Mark Rutland wrote:
>>> -struct cpu_sve_state {
>>> -	__u64 zcr_el1;
>>> -
>>> -	/*
>>> -	 * Ordering is important since __sve_save_state/__sve_restore_state
>>> -	 * relies on it.
>>> -	 */
>>> -	__u32 fpsr;
>>> -	__u32 fpcr;
>>> -
>>> -	/* Must be SVE_VQ_BYTES (128 bit) aligned. */
>>> -	__u8 sve_regs[];
>>
>> It seems that the requirement (driven by SVE ldr/str) is
>> satisfied with the new sve_regs pointing to the start of the
>> page.
>>
>> I'm not sure whether we want to keep the comment (or perhaps
>> enforce this with explicit checks) so that future refactoring
>> doesn't lead to time spent debugging alignment faults...
> AFAICT alignment has never been functionally necessary. The LDR (vector)
> and STR (vector) instructions only mandate alignment when the relevant
> SCTLR_ELx has SCTLR_ELx.A==1. For kernel and hyp code we configure
> SCTLR_ELx.A==0, so there's no alignment requirement.
> 
> Per ARM DDI 0487 M.b, section C8.2.437 "LDR (vector)":
> 
>   The load is performed as contiguous byte accesses, with no endian
>   conversion and no guarantee of single-copy atomicity larger than a
>   byte. However, *if alignment is checked*, then the base register must be
>   aligned to 16 bytes.
> 
> Per ARM DDI 0487 M.b, section C8.2.777 "STR (vector)":
> 
>   The store is performed as contiguous byte accesses, with no endian
>   conversion and no guarantee of single-copy atomicity larger than a
>   byte. However, *if alignment is checked*, then the base register must be
>   aligned to 16 bytes.
> 
> ... and in both cases the pseudocode shows that AlignmentEnforced()
> depends on the value of SCTLR_ELx.A.
> 
> Given that, I don't think we need the comment.
> 

Thanks for explanation! Maybe worth mentioning in commit message that it never was
a requirement? 

> [...]
> 
>> FWIW,
>>
>> Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
> Thanks!
> 

You are welcome :)

Vladimir


> Mark.
> 

