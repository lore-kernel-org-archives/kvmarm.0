Received: from out-13.mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF9C17C8
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 18:35:33 +0000 (UTC)
Date: Mon, 10 Jul 2023 18:35:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689014131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AkW9J1BIHh65MFjYLwrjzWLX6YLMXef1qtqAlaYWKE0=;
	b=R/mhatjUsi4CH5x0yNPVe5xxHgYzUamU0Lem5ys0eQ5HanxkzCpsKO+AdnK67B37t7/88R
	kupx3ww7FXOWqeaBqdtUMhlKnEot5s6lThOTE8HQkdLOlAetTzlmL2r//Gn0f1hptDsUxG
	6oYTJsjHaezqbF5Vh1eJbww0waxTsuU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 4/4] KVM: arm64: Always return generic v8 as the
 preferred target
Message-ID: <ZKxPb4/La5SPp3uM@linux.dev>
References: <20230623194258.2648987-1-oliver.upton@linux.dev>
 <20230623194258.2648987-5-oliver.upton@linux.dev>
 <23bdb1d7-4153-594b-75e7-3452385f81a6@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23bdb1d7-4153-594b-75e7-3452385f81a6@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 10, 2023 at 11:13:34PM +0800, Zenghui Yu wrote:
> Hi Oliver,
> 
> On 2023/6/24 3:42, Oliver Upton wrote:
> > Userspace selecting an implementation-specific vCPU target has been
> > completely useless for a very long time. Let's go whole hog and start
> > returning the generic v8 target across all implementations as the
> > preferred target.
> > 
> > Uphold the pre-existing behavior by tolerating either the generic target
> > or an implementation-specific target if the vCPU happens to be running
> > on one of the lucky few parts.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> I love the idea.
> 
> Acked-by: Zenghui Yu <yuzenghui@huawei.com>

Thanks!

> > ---
> >  arch/arm64/kvm/arm.c   | 3 ++-
> >  arch/arm64/kvm/guest.c | 4 +---
> >  2 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3fa63fdbbf34..5a3b8b2e779b 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1250,7 +1250,8 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >  {
> >  	int ret;
> > -	if (init->target != kvm_target_cpu())
> > +	if (init->target != KVM_ARM_TARGET_GENERIC_V8 &&
> > +	    init->target != kvm_target_cpu())
> >  		return -EINVAL;
> 
> I can see that user-space can now select GENERIC_V8 or CORTEX_A53 (for
> example) between two KVM_ARM_VCPU_INIT calls on an A53 host, which was
> forbidden before this change. I don't think it's a big deal though.

Agreed, I thought the slight relaxation on invariance was OK. If needed,
we can always change the rules for a new target value, but I doubt we will
need to do that anytime soon.

-- 
Thanks,
Oliver
