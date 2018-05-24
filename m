From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 05/14] arm64: Add 'ssbd' command-line option
Date: Thu, 24 May 2018 12:52:48 +0100
Message-ID: <c5d4566b-d1de-d16b-a21a-d20ff8224620@arm.com>
References: <20180522150648.28297-1-marc.zyngier@arm.com>
 <20180522150648.28297-6-marc.zyngier@arm.com>
 <20180524114031.ehtumruiyuu4z2oo@lakrids.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524114031.ehtumruiyuu4z2oo@lakrids.cambridge.arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 24/05/18 12:40, Mark Rutland wrote:
> On Tue, May 22, 2018 at 04:06:39PM +0100, Marc Zyngier wrote:
>> On a system where the firmware implements ARCH_WORKAROUND_2,
>> it may be useful to either permanently enable or disable the
>> workaround for cases where the user decides that they'd rather
>> not get a trap overhead, and keep the mitigation permanently
>> on or off instead of switching it on exception entry/exit.
>>
>> In any case, default to the mitigation being enabled.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  Documentation/admin-guide/kernel-parameters.txt |  17 ++++
>>  arch/arm64/include/asm/cpufeature.h             |   6 ++
>>  arch/arm64/kernel/cpu_errata.c                  | 102 ++++++++++++++++++++----
>>  3 files changed, 109 insertions(+), 16 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index f2040d46f095..646e112c6f63 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -4092,6 +4092,23 @@
>>  			expediting.  Set to zero to disable automatic
>>  			expediting.
>>  
>> +	ssbd=		[ARM64,HW]
>> +			Speculative Store Bypass Disable control
>> +
>> +			On CPUs that are vulnerable to the Speculative
>> +			Store Bypass vulnerability and offer a
>> +			firmware based mitigation, this parameter
>> +			indicates how the mitigation should be used:
>> +
>> +			force-on:  Unconditionnaly enable mitigation for
>> +				   for both kernel and userspace
>> +			force-off: Unconditionnaly disable mitigation for
>> +				   for both kernel and userspace
>> +			kernel:    Always enable mitigation in the
>> +				   kernel, and offer a prctl interface
>> +				   to allow userspace to register its
>> +				   interest in being mitigated too.
>> +
>>  	stack_guard_gap=	[MM]
>>  			override the default stack gap protection. The value
>>  			is in page units and it defines how many pages prior
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 09b0f2a80c8f..9bc548e22784 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -537,6 +537,12 @@ static inline u64 read_zcr_features(void)
>>  	return zcr;
>>  }
>>  
>> +#define ARM64_SSBD_UNKNOWN		-1
>> +#define ARM64_SSBD_FORCE_DISABLE	0
>> +#define ARM64_SSBD_EL1_ENTRY		1
> 
> The EL1_ENTRY part of the name is a bit misleading, since this doesn't
> apply to EL1->EL1 exceptions (and as with many other bits of the arm64
> code, it's arguably misleading in the VHE case).
> 
> Perhaps ARM64_SSBD_KERNEL, which would align with the parameter name?

I was just waiting for someone to sort out the naming for me, thanks for
falling into that trap! ;-)

I'll update that.

> Not a big deal either way, and otherwise this looks good to me.
> Regardless:
> 
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
