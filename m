Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28DE3C04
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 19:18:10 +0000 (UTC)
Date: Thu, 23 Mar 2023 19:18:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679599088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gq2VTw21n2omjdhvRhnFDBiQfxeSYLTO49OoqEo41EY=;
	b=DZJNKHS+yUGO40Mjt1t7faQDYJUOEMoi2a1+sFNNNPjV7lad0fxqOy63uTqrmCStZzGBIV
	HKfEf6PunGdNMVs20YxidESSVr39qJb7ZMn4fwRO2/85K1IC2Zr/Yce1n8W+Q371cI05QI
	CA7eZXpxvl2Ulr3XnqNtZcOocF100gQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 4/4] KVM: arm64: Use config_lock to protect vgic state
Message-ID: <ZByl7ZB835jySq/x@linux.dev>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
 <20230316211412.2651555-5-oliver.upton@linux.dev>
 <87o7olgfjs.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7olgfjs.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 22, 2023 at 12:02:15PM +0000, Marc Zyngier wrote:
> On Thu, 16 Mar 2023 21:14:12 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -2043,7 +2043,10 @@ static int vgic_its_attr_regs_access(struct kvm_device *dev,
> >  	if (offset & align)
> >  		return -EINVAL;
> >  
> > -	mutex_lock(&dev->kvm->lock);
> > +	if (!lock_all_vcpus(dev->kvm))
> > +		return -EBUSY;
> > +
> > +	mutex_lock(&dev->kvm->arch.config_lock);
> 
> Huh, that's fishy. The whole "lock the VM and the lock the individual
> vcpus" is there to prevent a concurrent creation of a vcpu while we're
> doing stuff that affects them all. Allowing a new vcpu to come online
> while this sequence is happening is ... unexpected.
> 
> Why do we need to drop this initial lock? I'd expect them to be
> completely cumulative.

Urgh.. Yes, you're right. I'll go with kvm->lock -> lock_all_vcpus() ->
kvm->config_lock in the next spin to guard against the vCPU creation
race.

-- 
Thanks,
Oliver
