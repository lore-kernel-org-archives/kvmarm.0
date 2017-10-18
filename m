From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 03/20] arm64: Use the physical counter when available for read_cycles
Date: Wed, 18 Oct 2017 16:52:26 +0100
Message-ID: <878tg8jvwl.fsf@on-the-bus.cambridge.arm.com>
References: <20170923004207.22356-1-cdall@linaro.org>
        <20170923004207.22356-4-cdall@linaro.org>
        <9b06425f-7c2c-d44a-cd6c-aeaa4b76849c@arm.com>
        <20171018113405.GA8900@cbox>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171018113405.GA8900@cbox> (Christoffer Dall's message of "Wed,
        18 Oct 2017 13:34:05 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 18 2017 at  1:34:05 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> On Mon, Oct 09, 2017 at 05:21:24PM +0100, Marc Zyngier wrote:
>> On 23/09/17 01:41, Christoffer Dall wrote:
>> > Currently get_cycles() is hardwired to arch_counter_get_cntvct() on
>> > arm64, but as we move to using the physical timer for the in-kernel
>> > time-keeping, we need to make that more flexible.
>> > 
>> > First, we need to make sure the physical counter can be read on equal
>> > terms to the virtual counter, which includes adding physical counter
>> > read functions for timers that require errata.
>> > 
>> > Second, we need to make a choice between reading the physical vs virtual
>> > counter, depending on which timer is used for time keeping in the kernel
>> > otherwise.  We can do this using a static key to avoid a performance
>> > penalty during runtime when reading the counter.
>> > 
>> > Cc: Catalin Marinas <catalin.marinas@arm.com>
>> > Cc: Will Deacon <will.deacon@arm.com>
>> > Cc: Mark Rutland <mark.rutland@arm.com>
>> > Cc: Marc Zyngier <marc.zyngier@arm.com>
>> > Signed-off-by: Christoffer Dall <cdall@linaro.org>

[...]

>> In my reply to patch #2, I had the following hunk:
>> 
>> @@ -310,7 +329,7 @@ static void erratum_set_next_event_tval_generic(const int access, unsigned long
>>  						struct clock_event_device *clk)
>>  {
>>  	unsigned long ctrl;
>> -	u64 cval = evt + arch_counter_get_cntvct();
>> +	u64 cval = evt + arch_timer_read_counter();
>>  
>>  	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
>>  	ctrl |= ARCH_TIMER_CTRL_ENABLE;
>> 
>> Once we start using a different timer, this could well have an effect...
>> 
>
> Right, but wouldn't the following be a more correct way to go about it then:
>
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 9a7b359..07f19db 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -329,16 +329,19 @@ static void erratum_set_next_event_tval_generic(const int access, unsigned long
>  						struct clock_event_device *clk)
>  {
>  	unsigned long ctrl;
> -	u64 cval = evt + arch_timer_read_counter();
> +	u64 cval;
>  
>  	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL, clk);
>  	ctrl |= ARCH_TIMER_CTRL_ENABLE;
>  	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
>  
> -	if (access == ARCH_TIMER_PHYS_ACCESS)
> +	if (access == ARCH_TIMER_PHYS_ACCESS) {
> +		cval = evt + arch_counter_get_cntpct();
>  		write_sysreg(cval, cntp_cval_el0);
> -	else
> +	} else {
> +		cval = evt + arch_counter_get_cntvct();
>  		write_sysreg(cval, cntv_cval_el0);
> +	}
>  
>  	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl, clk);
>  }

Yup, that's much better.

Thanks,

	M.
-- 
Jazz is not dead, it just smell funny.
