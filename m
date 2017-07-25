From: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC PATCH v2 02/19] arm64: Use the physical counter when
 available for read_cycles
Date: Tue, 25 Jul 2017 10:43:08 +0100
Message-ID: <20170725094308.GC23359@arm.com>
References: <20170717142718.13853-1-cdall@linaro.org>
 <20170717142718.13853-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170717142718.13853-3-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On Mon, Jul 17, 2017 at 04:27:01PM +0200, Christoffer Dall wrote:
> Currently get_cycles() is hardwired to arch_counter_get_cntvct() on
> arm64, but as we move to using the physical timer for the in-kernel
> time-keeping, we need to make that more flexible.
> 
> First, we need to make sure the physical counter can be read on equal
> terms to the virtual counter, which includes adding physical counter
> read functions for timers that require errata.
> 
> Second, we need to make a choice between reading the physical vs virtual
> counter, depending on which timer is used for time keeping in the kernel
> otherwise.  We can do this using a static key to avoid a performance
> penalty during runtime when reading the counter.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  arch/arm64/include/asm/arch_timer.h  | 18 ++++++++++++------
>  arch/arm64/include/asm/timex.h       |  2 +-
>  drivers/clocksource/arm_arch_timer.c | 32 ++++++++++++++++++++++++++++++--
>  3 files changed, 43 insertions(+), 9 deletions(-)

[...]

> @@ -886,10 +912,12 @@ static void __init arch_counter_register(unsigned type)
>  
>  	/* Register the CP15 based counter if we have one */
>  	if (type & ARCH_TIMER_TYPE_CP15) {
> -		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI)
> +		if (arch_timer_uses_ppi == ARCH_TIMER_VIRT_PPI) {
>  			arch_timer_read_counter = arch_counter_get_cntvct;
> -		else
> +		} else {
>  			arch_timer_read_counter = arch_counter_get_cntpct;
> +			static_branch_enable(&arch_timer_phys_counter_available);
> +		}

I'm a bit worried about this change, although I can't put my finger on
exactly the problematic scenario. My concern is that if we have a system
where the host kernel is entered at NS-EL1 (because, e.g. EL2 is used for
something else or the bootloader just didn't load us there) then the booting
protocol doesn't mandate a zero-initialised CNTVOFF value. If we can
subsequently end up using the physical counter in the kernel and the virtual
counter in userspace, the vDSO will get confused because the datapage values
will not correspond to the values it actually ends up reading. There's also
the likelihood that existing EL2 init code simply isn't setting up
CNTHCTL_EL2 and CNTVOFF correctly, so we probably need a way to force
virtual counter on the cmdline.

In practice it looks like we always end up with ARCH_TIMER_VIRT_PPI out of
arch_timer_select_ppi, but that's not guaranteed and I haven't thought at
all about the 32-bit case, which has other quirks/complexities.

Will
