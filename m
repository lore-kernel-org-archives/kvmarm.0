From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 03/20] arm64: Use physical counter for in-kernel reads when booted in EL2
Date: Wed, 25 Oct 2017 14:43:59 +0100
Message-ID: <86o9ovcpgg.fsf@arm.com>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
        <20171020114939.12554-4-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-4-christoffer.dall@linaro.org> (Christoffer
        Dall's message of "Fri, 20 Oct 2017 13:49:22 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20 2017 at  1:49:22 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Christoffer Dall <cdall@linaro.org>
>
> Using the physical counter allows KVM to retain the offset between the
> virtual and physical counter as long as it is actively running a VCPU.
>
> As soon as a VCPU is released, another thread is scheduled or we start
> running userspace applications, we reset the offset to 0, so that
> userspace accessing the virtual timer can still read the virtual counter
> and get the same view of time as the kernel.
>
> This opens up potential improvements for KVM performance, but we have to
> make a few adjustments to preserve system consistency.
>
> Currently get_cycles() is hardwired to arch_counter_get_cntvct() on
> arm64, but as we move to using the physical timer for the in-kernel
> time-keeping on systems that boot in EL2, we should use the same counter
> for get_cycles() as for other in-kernel timekeeping operations.
>
> Similarly, implementations of arch_timer_set_next_event_phys() is
> modified to use the counter specific to the timer being programmed.
>
> VHE kernels or kernels continuing to use the virtual timer are
> unaffected.
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
