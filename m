Received: from out-18.mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A0011C90
	for <kvmarm@lists.linux.dev>; Mon, 26 Jun 2023 16:26:02 +0000 (UTC)
Date: Mon, 26 Jun 2023 16:25:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687796761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eLeARv/zdgqI/M8JKD19OZu39oBgBzWE1uETfjvTyjo=;
	b=b4tHWi3OEhGdoqDqeXycqKmXhKiyaBaXIsXCdXPi3UaQPNac2qV9QHy2BBCo7XBUxmxSVH
	LNO1QsMLAQPiHE/G4W9uG5BvEk5OMiubZ+pRYXT5WS7oaYmoFH+NzSDA5IOO9h5cXTnZb6
	5I1nKQqsk1gS5s8v+xEeI7RtRfjjpHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH] KVM: arm64: Reject attempts to set invalid debug arch
 version
Message-ID: <ZJm8FX4GhJE4FLQ+@linux.dev>
References: <20230623205232.2837077-1-oliver.upton@linux.dev>
 <86jzvqbmr7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86jzvqbmr7.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 26, 2023 at 10:23:24AM +0100, Marc Zyngier wrote:
> On Fri, 23 Jun 2023 21:52:32 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > The debug architecture is mandatory in ARMv8, so KVM should not allow
> > userspace to configure a vCPU with less than that. Of course, this isn't
> > handled elegantly by the generic ID register plumbing, as the respective
> > ID register fields have a nonzero starting value.
> > 
> > Add an explicit check for debug versions less than v8 of the
> > architecture.
> > 
> > Fixes: c118cead07a7 ("KVM: arm64: Use generic sanitisation for ID_(AA64)DFR0_EL1")
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 1a13bab1a06c..5b25053a8e04 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1482,6 +1482,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >  			       const struct sys_reg_desc *rd,
> >  			       u64 val)
> >  {
> > +	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
> >  	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
> >  
> >  	/*
> > @@ -1501,6 +1502,13 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >  	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
> >  		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
> >  
> > +	/*
> > +	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
> > +	 * nonzero minimum safe value.
> > +	 */
> > +	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
> > +		return -EINVAL;
> > +
> 
> Why isn't that caught by the check at the end of arm64_check_features
> which says that for RO fields, the only safe value is the sanitised
> version?

You're right, I was mistaken in thinking the field was already writable.
Now, having said that, it _is_ an issue with Jing's series to make DFR0
fully writable.

https://lore.kernel.org/kvmarm/20230607194554.87359-2-jingzhangos@google.com/

-- 
Thanks,
Oliver
