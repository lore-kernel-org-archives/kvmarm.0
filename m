From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH -next] KVM: arm/arm64: Remove unused timer variable
Date: Fri, 22 Feb 2019 09:42:24 +0000
Message-ID: <20190222094224.07535ee6@why.wild-wind.fr.eu.org>
References: <1550817269-57405-1-git-send-email-zhangshaokun@hisilicon.com>
 <ea7693de-e800-1279-92ae-9844ff9cbf23@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1340B4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 04:42:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oOTETqM8KeBg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 04:42:30 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC9B4A200
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 04:42:30 -0500 (EST)
In-Reply-To: <ea7693de-e800-1279-92ae-9844ff9cbf23@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: Shaokun Zhang <zhangshaokun@hisilicon.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 22 Feb 2019 08:49:42 +0000
Julien Thierry <julien.thierry@arm.com> wrote:

> Hi Shaokun,
> 
> On 22/02/2019 06:34, Shaokun Zhang wrote:
> > The 'timer' local variable became unused after commit bee038a67487
> > ("KVM: arm/arm64: Rework the timer code to use a timer_map").
> > Remove it to avoid [-Wunused-but-set-variable] warning.
> > 
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > Cc: James Morse <james.morse@arm.com>
> > Cc: Julien Thierry <julien.thierry@arm.com>
> > Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
> > Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> > ---
> >  virt/kvm/arm/arch_timer.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> > index af8f2f1d01cc..3417f2dbc366 100644
> > --- a/virt/kvm/arm/arch_timer.c
> > +++ b/virt/kvm/arm/arch_timer.c
> > @@ -236,14 +236,12 @@ static enum hrtimer_restart kvm_hrtimer_expire(struct hrtimer *hrt)
> >  
> >  static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
> >  {
> > -	struct arch_timer_cpu *timer;
> >  	enum kvm_arch_timers index;
> >  	u64 cval, now;
> >  
> >  	if (!timer_ctx)
> >  		return false;
> >  
> > -	timer = vcpu_timer(timer_ctx->vcpu);
> >  	index = arch_timer_ctx_index(timer_ctx);
> >  
> >  	if (timer_ctx->loaded) {  
> 
> This seems to be a consequence of moving the loaded state from
> arch_timer_cpu to arch_timer_context. Thanks for fixing it.
> 
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>

Applied to -next.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
