From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 10/20] KVM: arm/arm64: Use separate timer for phys timer emulation
Date: Wed, 25 Oct 2017 14:59:13 +0100
Message-ID: <867evjcor2.fsf@arm.com>
References: <20171020114939.12554-1-christoffer.dall@linaro.org>
        <20171020114939.12554-11-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171020114939.12554-11-christoffer.dall@linaro.org>
        (Christoffer Dall's message of "Fri, 20 Oct 2017 13:49:29 +0200")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 20 2017 at  1:49:29 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> From: Christoffer Dall <cdall@linaro.org>
>
> We were using the same hrtimer for emulating the physical timer and for
> making sure a blocking VCPU thread would be eventually woken up.  That
> worked fine in the previous arch timer design, but as we are about to
> actually use the soft timer expire function for the physical timer
> emulation, change the logic to use a dedicated hrtimer.
>
> This has the added benefit of not having to cancel any work in the sync
> path, which in turn allows us to run the flush and sync with IRQs
> disabled.
>
> Note that the hrtimer used to program the host kernel's timer to
> generate an exit from the guest when the emulated physical timer fires
> never has to inject any work, and to share the soft_timer_cancel()
> function with the bg_timer, we change the function to only cancel any
> pending work if the pointer to the work struct is not null.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
