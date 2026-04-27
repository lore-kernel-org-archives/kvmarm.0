Received: from out199-18.us.a.mail.aliyun.com (out199-18.us.a.mail.aliyun.com [47.90.199.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F7C35F5F8
	for <kvmarm@lists.linux.dev>; Mon, 27 Apr 2026 06:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.199.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777271552; cv=none; b=M/99Ob6rmQfOuj9cCEVATLP+xFByy50IX+tQOTs566Mng/Fe1gKotV35QhoshDfiwuDFgvNv+Tu0FZcF1YJlDMB60YY6nfICtmYnHvf5m/kr5HMhgWljyKXi8Z2YtQbzuH1Ac3x1vZwmiy+tVzUsyRswaW9eJHratCPpd9hkiUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777271552; c=relaxed/simple;
	bh=lvXqGJ4qnETui8FjJAA/vDD4sFCtdPp3cmr4bpb3PuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/DrQ/kotHRgCQEYNG+VnzL4qQ1win8FsS9oq/NvS7VxxcEkUvR0T6HGclyaGi1TGx99pAu83bqY+aXwwthqPWaj+kGrdQlDP++CKk+iUhrZDz3S78m5gkAv5KUo88TTqmIJNoSBmPPJbHba9IGIg7P0daswtUAKndPvRMejpx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VzWEU3mk; arc=none smtp.client-ip=47.90.199.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VzWEU3mk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777271533; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=DcwYOBMc+yK36LdyPYEOFx9D/UsqSBJDiqZK+/FoA3c=;
	b=VzWEU3mkYn4VP2VEkQ3+Y/8aMQ6uPR/p9CqjUSkCkNf4g5uCwdXQUxi7pgysQ7jyH89yC08KtXStNJtz8P9dTon1TY2GogWVyMFBskev/uhLBaF1fBNXx/ND8QzS5N+gBZiQdZ+ROox/8jJqb9ZGDh/rjlIdvB+kYVLxeMU5DE4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X1jDD2S_1777267863;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X1jDD2S_1777267863 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Apr 2026 13:31:03 +0800
Date: Mon, 27 Apr 2026 13:31:02 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Wake-up from WFI when iqrchip is in userspace
Message-ID: <gd2ju4harg3bpt4kfbenyblfhg4di2vsu6q26e5rsg2whibq4w@rl7sippqm3sj>
References: <20260423163607.486345-1-maz@kernel.org>
 <uhqgyol622go4lm5btbk4jyieb3swhskpkyel4mnksfeki2mo2@ecnjvxwiqcfw>
 <87jytwbz2d.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jytwbz2d.wl-maz@kernel.org>

On Fri, Apr 24, 2026 at 08:24:42AM +0800, Marc Zyngier wrote:
> On Fri, 24 Apr 2026 07:33:02 +0100,
> Yao Yuan <yaoyuan@linux.alibaba.com> wrote:
> >
> > On Thu, Apr 23, 2026 at 05:36:07PM +0800, Marc Zyngier wrote:
> > > It appears that there is nothing in the wake-up path that
> > > evaluates whether the in-kernel interrupts are pending unless
> > > we have a vgic.
> > >
> > > This means that the userspace irqchip support has been broken for
> > > about four years, and nobody noticed. It was also broken before
> > > as we wouldn't wake-up on a PMU interrupt, but hey, who cares...
> > >
> > > It is probably time to remove the feature altogether, because it
> > > was a terrible idea 10 years ago, and it still is.
> > >
> > > Fixes: b57de4ffd7c6d ("KVM: arm64: Simplify kvm_cpu_has_pending_timer()")
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/arm.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 176cbe8baad30..8bb2c7422cc8b 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -824,6 +824,10 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
> > >  {
> > >  	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF | HCR_VSE);
> > >
> >
> > Hi Marc,
> >
> > > +	irq_lines |= (!irqchip_in_kernel(v->kvm) &&
> > > +		      (kvm_timer_should_notify_user(v) ||
> > > +		       kvm_pmu_should_notify_user(v)));
> >
> > How about a new helper like 'kvm_should_notify_us_irqchip()' ?
> > We can replace the same part at beginning of kvm_vcpu_exit_request() and
> > here w/ unlikely().
>
> I'd rather not introduce a helper, for two reasons:
>
> - this needs to be backported all the way to 5.19, because that's how
>   far it has been broken. So keeping it small and localised is far
>   better than introducing a helper that will make the backport less
>   obvious.

Agree on this point very much!

>
> - I have patches to remove the other calls to kvm_*_notify_user() as a
>   simplification of this utterly stupid feature.

OK.

>
> Finally, and while I agree that this could take an unlikely()
> qualifier, a much better course of action would be to have a separate
> patch that moves the qualifier to the predicate itself.

I got it, thanks for your such detail explanation!

>
> Thanks,
>
> 	M.
>
> --
> Jazz isn't dead. It just smells funny.
