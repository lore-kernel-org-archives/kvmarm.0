From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v5 21/20] arm/arm64: KVM: Load the timer state when enabling the timer
Date: Sun, 29 Oct 2017 02:07:38 +0000
Message-ID: <86she2905x.fsf@arm.com>
References: <1509093281-15225-1-git-send-email-cdall@linaro.org>
        <1509241736-99913-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1509241736-99913-1-git-send-email-christoffer.dall@linaro.org>
        (Christoffer Dall's message of "Sun, 29 Oct 2017 02:48:56 +0100")
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, Oct 29 2017 at  2:48:56 am GMT, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> After being lazy with saving/restoring the timer state, we defer that
> work to vcpu_load and vcpu_put, which ensure that the timer state is
> loaded on the hardware timers whenever the VCPU runs.
>
> Unfortunately, we are failing to do that the first time vcpu_load()
> runs, because the timer has not yet been enabled at that time.  As long
> as the initialized timer state matches what happens to be in the
> hardware (a disabled timer, because we never leave the timer screaming),
> this does not show up as a problem, but is nevertheless incorrect.
>
> The solution is simple; disable preemption while setting the timer to be
> enabled, and call the timer load function when first enabling the timer.
>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
