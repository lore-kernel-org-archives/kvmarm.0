Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5AE142E011
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 16:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898434; cv=none; b=EDtpt6CQXsixCBNB2wD3Zbzv097HwsWUdwOErHcgsFrh4fpNsLP/mpuCaLZkLcePZ1oDZIHX+7p2md72E4BX0UpJiQPBoxKFyNv2yYUDMjVoe/eiz/1sF0A176i9HpLci71HA6r2sUNFsHjwIeTp0VGz02KP0NEDpkd5E5JEbCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898434; c=relaxed/simple;
	bh=gUye9Grka3ECEK41ZIpIsjGn/j1fZ7FW/nQvY+4jS+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hdlh18vPwrRXbo5i/KsIj4n83FLISHELxDcxOxy4sFe7elKzIAgtm5BhrX/yGxjeS2lnnlkbLi8WyhsYFXXkp0i94SJ+kwA9RLCLhYMb/Jt9xUfpWKAvvwy9chstPXT9M9DW6C7MCMEMLMEIvsJvG1ApsfaTpqpvyR1iiuEY5bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Qrn1fhCI; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Qrn1fhCI"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91F6335BF;
	Wed, 27 May 2026 09:13:43 -0700 (PDT)
Received: from [10.1.38.169] (e121487-lin.cambridge.arm.com [10.1.38.169])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 816A93F905;
	Wed, 27 May 2026 09:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779898428; bh=gUye9Grka3ECEK41ZIpIsjGn/j1fZ7FW/nQvY+4jS+0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qrn1fhCIhiS+r0p3Rq7KFOQiLwbSmb11xIlWxhOL4iedcV8fbohZD/08yRLAJ87em
	 mFvqQedFp5S2LhFzaHIwu9ZRz6SS1tYI5yTf3uIP0/OICrl8nZLratQo91TJrM383N
	 ZYlBeLiOrvlKKHx6xkjAxigyu6/aYj5B96BH1/Tg=
Message-ID: <9b7bf255-bf37-4372-9908-d595e20648e9@arm.com>
Date: Wed, 27 May 2026 17:13:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/18] arm64: fpsimd: Move fpsimd save/restore inline
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-13-mark.rutland@arm.com>
 <c5ba3af9-08b2-4be2-b9f5-58a925f0b050@arm.com>
 <ahcPITrHKBgAHGkP@J2N7QTR9R3.cambridge.arm.com>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <ahcPITrHKBgAHGkP@J2N7QTR9R3.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/27/26 16:34, Mark Rutland wrote:
> On Wed, May 27, 2026 at 03:49:18PM +0100, Vladimir Murzin wrote:
>> On 5/21/26 14:25, Mark Rutland wrote:
>>> +static inline void fpsimd_save_vregs(struct user_fpsimd_state *state)
>>> +{
>>> +	instrument_write(state->vregs, sizeof(state->vregs));
>>> +	asm volatile(
>>> +	__FPSIMD_PREAMBLE
>>> +	"	stp	q0,  q1,  [%[vregs], #16 * 0]\n"
>>> +	"	stp	q2,  q3,  [%[vregs], #16 * 2]\n"
>>> +	"	stp	q4,  q5,  [%[vregs], #16 * 4]\n"
>>> +	"	stp	q6,  q7,  [%[vregs], #16 * 6]\n"
>>> +	"	stp	q8,  q9,  [%[vregs], #16 * 8]\n"
>>> +	"	stp	q10, q11, [%[vregs], #16 * 10]\n"
>>> +	"	stp	q12, q13, [%[vregs], #16 * 12]\n"
>>> +	"	stp	q14, q15, [%[vregs], #16 * 14]\n"
>>> +	"	stp	q16, q17, [%[vregs], #16 * 16]\n"
>>> +	"	stp	q18, q19, [%[vregs], #16 * 18]\n"
>>> +	"	stp	q20, q21, [%[vregs], #16 * 20]\n"
>>> +	"	stp	q22, q23, [%[vregs], #16 * 22]\n"
>>> +	"	stp	q24, q25, [%[vregs], #16 * 24]\n"
>>> +	"	stp	q26, q27, [%[vregs], #16 * 26]\n"
>>> +	"	stp	q28, q29, [%[vregs], #16 * 28]\n"
>>> +	"	stp	q30, q31, [%[vregs], #16 * 30]\n"
>>> +	: "=Q" (state->vregs)
>>> +	: [vregs] "r" (state->vregs)
>> Missing "memory" clobber here?
> Here the "=Q" constraint is sufficient.
> 
> The "=Q" output constraint describes that the operand is written to but
> the old value is not read. It behaves like an "=m" constraint, but
> places the base address in a single register without any offset (and no
> writeback addressing mode). Here it applies to the entirety of the
> vregs array.
> 
> See https://gcc.gnu.org/onlinedocs/gcc/Machine-Constraints.html :
> 
> |  Q
> |     A memory address which uses a single base register with no offset
> 
> We generally prefer to use "Q" constraints rather than memory clobbers
> where possible, since it gives the compiler more freedom (e.g. due to
> *not* clobbering unrelated memory locations). 
> 
> The "Q" constraint causes the output to be formatted as a memory address
> (e.g. "[x0]"), so to be able to apply an offset we need a separate "r"
> constraint to get the base register. It doesn't matter whether the
> compiler happens to use a different register for that (and in practice
> compilers realise they can use the register allocated for the "Q"
> conrstraint).
> 
> Unfortunately we can't use "Q" for the scalable registers, since the
> size isn't known at compile time, and the simplest option for those is
> to use a memory clobber.
> 

That's quite interesting bit of information, thanks for explanation!

> [...]
> 
>>> +static inline void fpsimd_load_vregs(const struct user_fpsimd_state *state)
>>> +{
>>> +	instrument_read(state->vregs, sizeof(state->vregs));
>>> +	asm volatile(
>>> +	__FPSIMD_PREAMBLE
>>> +	"	ldp	q0,  q1,  [%[vregs], #16 * 0]\n"
>>> +	"	ldp	q2,  q3,  [%[vregs], #16 * 2]\n"
>>> +	"	ldp	q4,  q5,  [%[vregs], #16 * 4]\n"
>>> +	"	ldp	q6,  q7,  [%[vregs], #16 * 6]\n"
>>> +	"	ldp	q8,  q9,  [%[vregs], #16 * 8]\n"
>>> +	"	ldp	q10, q11, [%[vregs], #16 * 10]\n"
>>> +	"	ldp	q12, q13, [%[vregs], #16 * 12]\n"
>>> +	"	ldp	q14, q15, [%[vregs], #16 * 14]\n"
>>> +	"	ldp	q16, q17, [%[vregs], #16 * 16]\n"
>>> +	"	ldp	q18, q19, [%[vregs], #16 * 18]\n"
>>> +	"	ldp	q20, q21, [%[vregs], #16 * 20]\n"
>>> +	"	ldp	q22, q23, [%[vregs], #16 * 22]\n"
>>> +	"	ldp	q24, q25, [%[vregs], #16 * 24]\n"
>>> +	"	ldp	q26, q27, [%[vregs], #16 * 26]\n"
>>> +	"	ldp	q28, q29, [%[vregs], #16 * 28]\n"
>>> +	"	ldp	q30, q31, [%[vregs], #16 * 30]\n"
>>> +	:
>>> +	: "Q" (state->vregs),
>>> +	  [vregs] "r" (state->vregs)
>> Missing "memory" clobber here?
> Same story as for fpsimd_save_vregs() above, except that here the "Q"
> input constraint describes that the entirety of the operand is read from
> but not written to.
> 

I'd be surprised if it was different :)

Cheers
Vladimir


> Mark.
> 

