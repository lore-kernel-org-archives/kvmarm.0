From: Tomasz Nowicki <tn@semihalf.com>
Subject: Re: [PATCH] KVM: arm/arm64: Handle forward time correction gracefully
Date: Mon, 11 Apr 2016 14:09:22 +0200
Message-ID: <570B93F2.7000905@semihalf.com>
References: <1459931842-29465-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 709DD40402
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 08:08:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oa+5WtMMUYjm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 08:08:07 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 060584011D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 08:08:06 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id u206so101343176wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 05:09:41 -0700 (PDT)
In-Reply-To: <1459931842-29465-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 06.04.2016 10:37, Marc Zyngier wrote:
> On a host that runs NTP, corrections can have a direct impact on
> the background timer that we program on the behalf of a vcpu.
>
> In particular, NTP performing a forward correction will result in
> a timer expiring sooner than expected from a guest point of view.
> Not a big deal, we kick the vcpu anyway.
>
> But on wake-up, the vcpu thread is going to perform a check to
> find out whether or not it should block. And at that point, the
> timer check is going to say "timer has not expired yet, go back
> to sleep". This results in the timer event being lost forever.
>
> There are multiple ways to handle this. One would be record that
> the timer has expired and let kvm_cpu_has_pending_timer return
> true in that case, but that would be fairly invasive. Another is
> to check for the "short sleep" condition in the hrtimer callback,
> and restart the timer for the remaining time when the condition
> is detected.
>
> This patch implements the latter, with a bit of refactoring in
> order to avoid too much code duplication.
>
> Reported-by: Alexander Graf <agraf@suse.de>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   virt/kvm/arm/arch_timer.c | 47 +++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 37 insertions(+), 10 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index a9ad4fe..4d0e77a 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -98,10 +98,46 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>   	kvm_vcpu_kick(vcpu);
>   }
>
> +static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
> +{
> +	cycle_t cval, now;
> +
> +	cval = vcpu->arch.timer_cpu.cntv_cval;
> +	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
> +
> +	if (now < cval) {
> +		u64 ns;
> +
> +		ns = cyclecounter_cyc2ns(timecounter->cc,
> +					 cval - now,
> +					 timecounter->mask,
> +					 &timecounter->frac);
> +		return ns;
> +	}
> +
> +	return 0;
> +}
> +
>   static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
>   {
>   	struct arch_timer_cpu *timer;
> +	struct kvm_vcpu *vcpu;
> +	u64 ns;
> +
>   	timer = container_of(hrt, struct arch_timer_cpu, timer);
> +	vcpu = container_of(timer, struct kvm_vcpu, arch.timer_cpu);
> +
> +	/*
> +	 * Check that the timer has really expired from the guest's
> +	 * PoV (NTP on the host may have forced it to expire
> +	 * early). If we should have slept longer, restart it.
> +	 */
> +	ns = kvm_timer_compute_delta(vcpu);
> +	if (unlikely(ns)) {
> +		hrtimer_forward_now(hrt, ns_to_ktime(ns));
> +		return HRTIMER_RESTART;
> +	}
> +
>   	queue_work(wqueue, &timer->expired);
>   	return HRTIMER_NORESTART;
>   }
> @@ -176,8 +212,6 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
>   void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>   {
>   	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
> -	u64 ns;
> -	cycle_t cval, now;
>
>   	BUG_ON(timer_is_armed(timer));
>
> @@ -197,14 +231,7 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
>   		return;
>
>   	/*  The timer has not yet expired, schedule a background timer */
> -	cval = timer->cntv_cval;
> -	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
> -
> -	ns = cyclecounter_cyc2ns(timecounter->cc,
> -				 cval - now,
> -				 timecounter->mask,
> -				 &timecounter->frac);
> -	timer_arm(timer, ns);
> +	timer_arm(timer, kvm_timer_compute_delta(vcpu));
>   }
>
>   void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
>

Works for me, thanks Marc!

Tested-by: Tomasz Nowicki <tn@semihalf.com>

Tomasz
