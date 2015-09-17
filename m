From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/3] arm64: KVM: Disable virtual timer even if the guest
 is not using it
Date: Thu, 17 Sep 2015 13:11:24 +0100
Message-ID: <55FAADEC.2020803@arm.com>
References: <1442419087-24648-1-git-send-email-marc.zyngier@arm.com> <1442419087-24648-3-git-send-email-marc.zyngier@arm.com> <20150917111735.GA19365@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150917111735.GA19365@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Pavel Fedin <p.fedin@samsung.com>, =?windows-1252?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/09/15 12:17, Christoffer Dall wrote:
> On Wed, Sep 16, 2015 at 04:58:06PM +0100, Marc Zyngier wrote:
>> When running a guest with the architected timer disabled (with QEMU and
>> the kernel_irqchip=off option, for example), it is important to make
>> sure the timer gets turned off. Otherwise, the guest may try to
>> enable it anyway, leading to a screaming HW interrupt.
>>
>> The fix is to unconditionally turn off the virtual timer on guest
>> exit.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/kvm/hyp.S | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
>> index 6addf97..38f5434 100644
>> --- a/arch/arm64/kvm/hyp.S
>> +++ b/arch/arm64/kvm/hyp.S
>> @@ -570,8 +570,6 @@ alternative_endif
> 
> The context confuses me; did you happen to base this on your VHE
> patches?

No, that's on top of 4.3-rc1, which happens to have this:

[...]
alternative_if_not ARM64_HAS_SYSREG_GIC_CPUIF
	bl	__restore_vgic_v2_state
alternative_else
	bl	__restore_vgic_v3_state
alternative_endif
.endm

.macro save_timer_state
[...]

and for some reason git doesn't use save_timer_state as the context anchor.

>>  	mrs	x3, cntv_ctl_el0
>>  	and	x3, x3, #3
>>  	str	w3, [x0, #VCPU_TIMER_CNTV_CTL]
>> -	bic	x3, x3, #1		// Clear Enable
>> -	msr	cntv_ctl_el0, x3
>>  
>>  	isb
>>  
>> @@ -579,6 +577,8 @@ alternative_endif
>>  	str	x3, [x0, #VCPU_TIMER_CNTV_CVAL]
>>  
>>  1:
>> +	msr	cntv_ctl_el0, xzr
>> +
> 
> We could have a comment here, but ok.

I'll add something.

>>  	// Allow physical timer/counter access for the host
>>  	mrs	x2, cnthctl_el2
>>  	orr	x2, x2, #3
>> -- 
>> 2.1.4
>>
> 
> Otherwise:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> 

Thanks!

	M.
-- 
Jazz is not dead. It just smells funny...
