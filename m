From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 01/13] arm/arm64: Add new is_kernel_in_hyp_mode predicate
Date: Thu, 09 Jul 2015 11:05:34 +0100
Message-ID: <559E476E.2000306@arm.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com> <1436372356-30410-2-git-send-email-marc.zyngier@arm.com> <20150709094230.GA20105@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150709094230.GA20105@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 09/07/15 10:42, Mark Rutland wrote:
> Hi,
> 
>> +static inline bool is_kernel_in_hyp_mode(void)
>> +{
>> +	u64 el;
>> +
>> +	asm("mrs %0, CurrentEL" : "=r" (el));
>> +	return el == CurrentEL_EL2;
>> +}
> 
> If you can include cputype.h, I think this can be:
> 
> static inline bool is_kernel_in_hyp_mode(void)
> {
> 	return read_cpuid(CurrentEL) == CurrentEL_EL2;
> }

This would indeed work, but CurrentEL is hardly an ID register. I feel
slightly uncomfortable using read_cpuid (which might return a cached
version at some point) for random system registers.

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
