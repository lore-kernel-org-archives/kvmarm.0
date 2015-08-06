From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 1/2] arm64: KVM: Optimize arm64 skip 30-50% vfp/simd
 save/restore on exits
Date: Thu, 06 Aug 2015 13:46:31 +0100
Message-ID: <55C35727.6060208@arm.com>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
 <1437082178-11039-2-git-send-email-m.smarduch@samsung.com>
 <55C235B9.3000800@arm.com> <20150806115436.GC4657@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6FFE5A268
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 08:33:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4NudYoVtP+L for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Aug 2015 08:33:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41CF75A264
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Aug 2015 08:33:44 -0400 (EDT)
In-Reply-To: <20150806115436.GC4657@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 06/08/15 12:54, Christoffer Dall wrote:
> On Wed, Aug 05, 2015 at 05:11:37PM +0100, Marc Zyngier wrote:
>> On 16/07/15 22:29, Mario Smarduch wrote:
>>> This patch only saves and restores FP/SIMD registers on Guest access. To do
>>> this cptr_el2 FP/SIMD trap is set on Guest entry and later checked on exit.
>>> lmbench, hackbench show significant improvements, for 30-50% exits FP/SIMD
>>> context is not saved/restored
>>>
>>> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
>>
>> So this patch seems to break 32bit guests on arm64.  I've had a look,
>> squashed a few bugs that I dangerously overlooked during the review, but
>> it still doesn't work (it doesn't crash anymore, but I get random
>> illegal VFP instructions in 32bit guests).
>>
>> I'd be glad if someone could eyeball the following patch and tell me
>> what's going wrong. If we don't find the root cause quickly enough, I'll
>> have to drop the series from -next, and that'd be a real shame.
>>
>> Thanks,
>>
>> 	M.
>>
>> commit 5777dc55fbc170426a85e00c26002dd5a795cfa5
>> Author: Marc Zyngier <marc.zyngier@arm.com>
>> Date:   Wed Aug 5 16:53:01 2015 +0100
>>
>>     KVM: arm64: NOTAFIX: Prevent crash when 32bit guest uses VFP
>>
>>     Since we switch FPSIMD in a lazy way, access to FPEXC32_EL2
>>     must be guarded by skip_fpsimd_state. Otherwise, all hell
>>     break loose.
>>
>>     Also, FPEXC32_EL2 must be restored when we trap to EL2 to
>>     enable floating point.
>>
>>     Note that while it prevents the host from catching fire, the
>>     guest still doesn't work properly, and I don't understand why just
>>     yet.
>>
>>     Not-really-signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>
>> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
>> index c8e0c70..b53ec5d 100644
>> --- a/arch/arm64/kvm/hyp.S
>> +++ b/arch/arm64/kvm/hyp.S
>> @@ -431,10 +431,12 @@
>>  	add	x3, x2, #CPU_SYSREG_OFFSET(DACR32_EL2)
>>  	mrs	x4, dacr32_el2
>>  	mrs	x5, ifsr32_el2
>> -	mrs	x6, fpexc32_el2
>>  	stp	x4, x5, [x3]
>> -	str	x6, [x3, #16]
>>
>> +	skip_fpsimd_state x8, 3f
>> +	mrs	x6, fpexc32_el2
>> +	str	x6, [x3, #16]
>> +3:
>>  	skip_debug_state x8, 2f
>>  	mrs	x7, dbgvcr32_el2
>>  	str	x7, [x3, #24]
>> @@ -461,10 +463,8 @@
>>
>>  	add	x3, x2, #CPU_SYSREG_OFFSET(DACR32_EL2)
>>  	ldp	x4, x5, [x3]
>> -	ldr	x6, [x3, #16]
>>  	msr	dacr32_el2, x4
>>  	msr	ifsr32_el2, x5
>> -	msr	fpexc32_el2, x6
>>
>>  	skip_debug_state x8, 2f
>>  	ldr	x7, [x3, #24]
>> @@ -669,12 +669,14 @@ __restore_debug:
>>  	ret
>>
>>  __save_fpsimd:
>> +	skip_fpsimd_state x3, 1f
>>  	save_fpsimd
>> -	ret
>> +1:	ret
>>
>>  __restore_fpsimd:
>> +	skip_fpsimd_state x3, 1f
>>  	restore_fpsimd
>> -	ret
>> +1:	ret
>>
>>  switch_to_guest_fpsimd:
>>  	push	x4, lr
>> @@ -682,6 +684,7 @@ switch_to_guest_fpsimd:
>>  	mrs	x2, cptr_el2
>>  	bic	x2, x2, #CPTR_EL2_TFP
>>  	msr	cptr_el2, x2
>> +	isb
> 
> ah, EL2 accesses themselves trap too, ouch.

Yeah, the FP architecture has all kind of nasty tricks like this.

>>
>>  	mrs	x0, tpidr_el2
>>
>> @@ -692,6 +695,10 @@ switch_to_guest_fpsimd:
>>  	add	x2, x0, #VCPU_CONTEXT
>>  	bl __restore_fpsimd
>>
>> +	skip_32bit_state x3, 1f
>> +	ldr	x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
>> +	msr	fpexc32_el2, x4
>> +1:
> 
> wait, it looks like you're missing a store of the host fpsimd state in
> the switch_to_guest_fpsimd situation.

A store of FPEXC32_EL2 for the host? No, this register has no
significance whatsoever for a 64bit host. Its sole purpose is to
accommodate a 32bit guest (see D7.2.31). Or are you thinking of
something else?

> It think this would be easier to follow if the aarch32 FP registers were
> handled as part of the __save_fpsimd  and __restore_fpsimd routines
> instead.

Maybe. This code needs some rework...

> Does this help anything?

Not really, sorry... :-(

> Otherwise, I assume you've tested thoroughly between something like
> v4.2-rc2 and this patch, so that you're sure we didn't have the 32-bit
> processed crash before?

Without the lazy switching, we seem to be rock solid. With lazy
switching, I get these illegal instructions, always on VFP ops. My
current thinking is that it has something to do with CPACR_EL1, and the
fact that the 32bit kernel turns it VFP on/off all the time.

/me puzzled...

	M.
-- 
Jazz is not dead. It just smells funny...
