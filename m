From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Fix occasional warning from the timer
 work function
Date: Fri, 13 Jan 2017 11:12:16 +0000
Message-ID: <daadc615-b9b8-7510-7978-b6854a5184b1@arm.com>
References: <20170109111856.8439-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170109111856.8439-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, mbrugger@suse.com
List-Id: kvmarm@lists.cs.columbia.edu

On 09/01/17 11:18, Christoffer Dall wrote:
> When a VCPU blocks (WFI) and has programmed the vtimer, we program a
> soft timer to expire in the future to wake up the vcpu thread when
> appropriate.  Because such as wake up involves a vcpu kick, and the
> timer expire function can get called from interrupt context, and the
> kick may sleep, we have to schedule the kick in the work function.
> 
> The work function currently has a warning that gets raised if it turns
> out that the timer shouldn't fire when it's run, which was added because
> the idea was that in that case the work should never have been cancelled.
> 
> However, it turns out that this whole thing is racy and we can get
> spurious warnings.  The problem is that we clear the armed flag in the
> work function, which may run in parallel with the
> kvm_timer_unschedule->timer_disarm() call.  This results in a possible
> situation where the timer_disarm() call does not call
> cancel_work_sync(), which effectively synchronizes the completion of the
> work function with running the VCPU.  As a result, the VCPU thread
> proceeds before the work function completees, causing changes to the
> timer state such that kvm_timer_should_fire(vcpu) returns false in the
> work function.
> 
> All we do in the work function is to kick the VCPU, and an occasional
> rare extra kick never harmed anyone.  Since the race above is extremely
> rare, we don't bother checking if the race happens but simply remove the
> check and the clearing of the armed flag from the work function.
> 
> Reported-by: Matthias Brugger <mbrugger@suse.com>
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
