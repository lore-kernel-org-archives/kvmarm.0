Received: from out-21.mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC411FDA
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 12:45:42 +0000 (UTC)
Date: Thu, 15 Jun 2023 12:45:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686833139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OsuKBXNSxqVmg16B7vlIhxgtAhh7lG9zEZU79hMDvk4=;
	b=Kke1Ymd3a/L03cy0cqbVKaxpdlGoxVGVuJgEjVDJMPEmGmQ3Y4GeqXPD3U213Fxx3cVBFD
	13rYEX0JjG7UCV/b3kR6fA8pL2QBzQdjI6JAc1tMZoq90dZAUI2ZKZfxxC/SErPVSzRmbF
	In4aP9V9u3WsgmBksWQVEEsEnpIyz3M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com, Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v12 07/11] KVM: arm64: Use arm64_ftr_bits to sanitise ID
 register writes
Message-ID: <ZIsH7rbS72Cdxmfx@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
 <20230609190054.1542113-8-oliver.upton@linux.dev>
 <878rckrjcl.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rckrjcl.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Thu, Jun 15, 2023 at 01:38:34PM +0100, Marc Zyngier wrote:
> > @@ -1528,11 +1613,31 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  		      u64 val)
> >  {
> > -	/* This is what we mean by invariant: you can't change it. */
> > -	if (val != read_id_reg(vcpu, rd))
> > -		return -EINVAL;
> > +	u32 id = reg_to_encoding(rd);
> > +	int ret;
> >  
> > -	return 0;
> > +	mutex_lock(&vcpu->kvm->arch.config_lock);
> > +
> > +	/*
> > +	 * Once the VM has started the ID registers are immutable. Reject any
> > +	 * write that does not match the final register value.
> > +	 */
> > +	if (kvm_vm_has_ran_once(vcpu->kvm)) {
> > +		if (val != read_id_reg(vcpu, rd))
> > +			ret = -EBUSY;
> > +		else
> > +			ret = 0;
> > +
> > +		mutex_unlock(&vcpu->kvm->arch.config_lock);
> > +		return ret;
> > +	}
> > +
> > +	ret = arm64_check_features(vcpu, rd, val);
> > +	if (!ret)
> > +		IDREG(vcpu->kvm, id) = val;
> > +
> > +	mutex_unlock(&vcpu->kvm->arch.config_lock);
> > +	return ret;
> 
> ... we now end-up with a *new* error code that userspace was never
> able to see so far.
> 
> This may not be a big deal, but I'd rather err on the side of caution
> by keeping the current, slightly less precise error code.

I completely agree, thanks for catching this. There's already enough
deliberate (theorectical) breakage brought about by this series, want to
avoid any unintended fallout :)

I plan on taking this, and I'll apply a fix on top to dumb down the
return.

-- 
Thanks,
Oliver
