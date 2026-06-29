Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08153F6C59;
	Mon, 29 Jun 2026 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782751970; cv=none; b=piWGMYGjw9FgRtZvgK+mAkU/EF8b+mMQZQ5gE9FdNFzvISnnmNe8o/3iNZhu7scJ2E5OyGvrGBP2Rbk16IkmNlLemG6dUfVl/+5aVtFfULMdUkTHaVuitWNBjQ0BXqrhcA7rj13TY0n+dL/MQjKp3wvDf630NTuTB3Ku+DObPI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782751970; c=relaxed/simple;
	bh=00vW6xipBiyFR76uBGRTBR0bmLU5JmyMK3KbgqXru44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZUh+a82Gm5kMeegexgXqTC1M7dPIm9rtpkn2n3KB64WzprIlD/MWhHtxiNtGb3iwxpwtuAqorhyDJrtVgYbOuC9xZDLLcus5TkI6MLqlddl5WM0N/HUsdtWROJqWI3kfAMveP9G0UUsUsrgGo1LdgtUmpce45dk8/e9tV3c2El0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bBWwP1cp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bBWwP1cp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB092355A;
	Mon, 29 Jun 2026 09:52:43 -0700 (PDT)
Received: from [10.1.36.193] (e121487-lin.cambridge.arm.com [10.1.36.193])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 66F773F905;
	Mon, 29 Jun 2026 09:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782751968; bh=00vW6xipBiyFR76uBGRTBR0bmLU5JmyMK3KbgqXru44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bBWwP1cpgvjri1QeAlJlcrda+3OT6/gFQLL7wtR30IrQbkifMXtQCzQfFOZ/L/9LG
	 Y4GR+xYmfRV+n6Aoogiv1O+aXdI76mhkbPUlWyqb+zZ2JwJEs0LucW+WM00Tne18J8
	 EdjphcmkK3NP7KTtXQ2V40uYy4MwfaddOtFeujU8=
Message-ID: <b8e90340-ee2a-4024-bc77-a00b139ea7ee@arm.com>
Date: Mon, 29 Jun 2026 17:52:45 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/13] KVM: arm64: Detect (via ACPI) and initialize
 HACDBSIRQ
To: Leonardo Bras <leo.bras@arm.com>, sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>,
 Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-6-leo.bras@arm.com>
 <20260629113242.9142A1F000E9@smtp.kernel.org> <akKSoZkYWDTE07hi@LeoBrasDK>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <akKSoZkYWDTE07hi@LeoBrasDK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 6/29/26 16:43, Leonardo Bras wrote:
>>> +	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
>>> +		/* When size not a power of two >= 4k, exit with reserved TTLW */
>>> +		int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
>> [Severity: Low]
>> Does this variable declaration cause a build failure?
> No
> 
>> Under standard C rules,
>> a label can only be attached to a statement, and a declaration is not a
>> statement.
> That's not a label.

I think Sashiko is right

arch/arm64/kvm/dirty_bit.c: In function 'hacdbsirq_handler':
arch/arm64/kvm/dirty_bit.c:336:3: error: a label can only be part of a statement and a declaration is not a statement
  336 |   int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
      |   ^~~
make[4]: *** [scripts/Makefile.build:289: arch/arm64/kvm/dirty_bit.o] Error 1
make[4]: *** Waiting for unfinished jobs....

Based on other threads you might need GCC<=10.5.0 to hit that.

Obvious fix-up would be to wrap the case into curly braces :)

Cheers
Vladimir
