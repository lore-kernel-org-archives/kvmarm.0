Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599F03F9F5E
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779806403; cv=none; b=uToGdq6x1c4em+QMnc2+ugq5/cq65XKAA5ejV/1ub6MAYEDyv6RpWKyzwLnplLyZ+AqKHePbrPv7Mz6p4MmGB1NlB5QunK3mc6VrvKFhzcytyz59WQxALZppYv6NyGgzR5FBQd1tEw3lSgiulBUTXCvyz+8qE1eztrmE+MqtkvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779806403; c=relaxed/simple;
	bh=p7gk+48RJ/Z79SLhtzHY7ExJpNDDW/usV23U+2Aa+dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tidG2IgG7DNmKu59GsAYGYHVAeoFugDdg6JRw5RYT3+p2YOXNgf1KsE8vMOgz7dEtmmBtN+ViaxSn/9fSRLCywKz7Ook3VtwBE+Z+WDi2Jz/JJzlNsRQ7DaCuTExOp4H0G1t3NXCm5LZkOYBWmej0YSQn2v+wRNZY62AhPsvAus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nqCL7Isx; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nqCL7Isx"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70FEF169C;
	Tue, 26 May 2026 07:39:55 -0700 (PDT)
Received: from [10.1.28.159] (e121487-lin.cambridge.arm.com [10.1.28.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42B243F7B4;
	Tue, 26 May 2026 07:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779806400; bh=p7gk+48RJ/Z79SLhtzHY7ExJpNDDW/usV23U+2Aa+dQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nqCL7IsxGs6FfsKo0qlSawSTMgP5kkErUj55gqxE2mkt/7tGLdfGMRr7BqdFAQFPg
	 T0drloG4tAv0/CdJmboRwwAeGIBmVI7jbAHq/NZ26ejCAONsuXv6XCKhVUOveESasm
	 LMcKbe34Mux6uirICmZSI0E5cleJq12LaRqrcJ78=
Message-ID: <08e5ce52-be74-4fc5-a0b2-8f405a5eff99@arm.com>
Date: Tue, 26 May 2026 15:39:56 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/18] arm64: fpsimd: Move SME save/restore inline
To: Mark Rutland <mark.rutland@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
 maz@kernel.org, oupton@kernel.org, tabba@google.com, will@kernel.org
References: <20260521132556.584676-1-mark.rutland@arm.com>
 <20260521132556.584676-18-mark.rutland@arm.com> <ahWpST4K3rbMbjWK@J2N7QTR9R3>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <ahWpST4K3rbMbjWK@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Mark,

On 5/26/26 15:08, Mark Rutland wrote:
> On Thu, May 21, 2026 at 02:25:55PM +0100, Mark Rutland wrote:
>> +static inline void __sme_save_za(struct sme_state *state, unsigned long svl)
>> +{
>> +	/* The <Wv> argument to STR (array vector) can only encode W12-W15 */
>> +	register unsigned long v asm ("12");
> Sorry, I had meant to put "x12" here, but evidently GCC and LLVM accept
> "12" on its own.
> 
> For clarity (e.g. to match the comment) I'll change that to "w12" and
> make the type unsigned int. Likewise in __sme_load_za().
> 

I suspect you are intentionally not using "Ucj" constrain to limit register allocator,
if so I'm wondering why?

Cheers
Vladimir


> Mark.
> 

