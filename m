Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3446D378
	for <kvmarm@lists.linux.dev>; Sat, 24 Jun 2023 00:56:02 +0000 (UTC)
Date: Fri, 23 Jun 2023 17:55:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687568161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SX9o/EErM6iHGhiaBzowKrd4mjeBEKVaVmhsF8GXbNQ=;
	b=GTKWPU0d3gLV9dVB+1oV40wIJv7U4mSWIMUr4IGcJqVjylpDRFuLwr5+OR+jTRwJ6XHJXu
	+z43kTS5JS/U/jFjG+dUHG+NubufttczNI8TZWSX1DxB4Qy+qNJPiKZ6L0HVGSljLIhRmp
	E86DSY1MPqWfnUHNmxK3dIi4kvoaG+o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 4/4] KVM: arm64: Always return generic v8 as the
 preferred target
Message-ID: <ZJY/Hek44VPeEgGm@linux.dev>
References: <20230623194258.2648987-1-oliver.upton@linux.dev>
 <20230623194258.2648987-5-oliver.upton@linux.dev>
 <87pm5lpu14.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pm5lpu14.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 24, 2023 at 01:45:43AM +0100, Marc Zyngier wrote:
> On Fri, 23 Jun 2023 20:42:58 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
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
> >  
> > -	if (init->target != kvm_target_cpu())
> > +	if (init->target != KVM_ARM_TARGET_GENERIC_V8 &&
> > +	    init->target != kvm_target_cpu())
> >  		return -EINVAL;
> >  
> >  	ret = kvm_vcpu_init_check_features(vcpu, init);
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 20280a5233f6..6b099a914fd4 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -886,8 +886,6 @@ u32 __attribute_const__ kvm_target_cpu(void)
> >  
> >  void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
> >  {
> > -	u32 target = kvm_target_cpu();
> > -
> >  	memset(init, 0, sizeof(*init));
> >  
> >  	/*
> > @@ -896,7 +894,7 @@ void kvm_vcpu_preferred_target(struct kvm_vcpu_init *init)
> >  	 * specific features available for the preferred
> >  	 * target type.
> >  	 */
> > -	init->target = (__u32)target;
> > +	init->target = KVM_ARM_TARGET_GENERIC_V8;
> >  }
> 
> Should we take the opportunity to simply get rid of this function
> altogether? Something like the untested hack below.

Yeah, I should've thought about it a little more and done as you
suggest. Thanks for the diff, I'll use it in v2.

--
Thanks,
Oliver
