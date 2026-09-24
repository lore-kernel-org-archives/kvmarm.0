Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B73D3ED5C3;
	Thu, 24 Sep 2026 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790238615; cv=none; b=r7mP66fIDKcUkT1GDdy8ZFAuaKxFk5J87V6D6XWbXYd+0pJlYoc2YcDPbjZhHfqVE+XzP8o4mwF6fUMgHptg4LNB7tiLpDpaU7AnwWZwh+xWSwlt02uvsvIpeDyNyhWkoUz/lcK1xqD929OJBUdOVZjWLfZOpC2uBWaVgacCh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790238615; c=relaxed/simple;
	bh=+Fmxs1VxO4v21VbTg/4NsPWKXYijbNKsTM1NdF20K/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3ncxShLxPD6I1WsvnGG7ylrFCMZ26yIPDjskGlUJJXYLi/fGzcnB2ZPjBpsqF0Jvsa+etK6+Qp+WDBeOEoB581165dGx4PkWtXeqinqsdD+wpShs+00GmUVlo5jBp2qqC27UXtPJMQcc1Kx/RpFAnjlyRNMnmT/yEvxEAhW6zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XE3JpDcy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XE3JpDcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6A41F000FF;
	Thu, 24 Sep 2026 08:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790238612;
	bh=Q2zQUJ23idUHk5KbjgrSsNpQFZ6X6k1nsitKWBxEjOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XE3JpDcyKgv66BxukYFgGmEjQwDrMczbTevv4ZcszBIlpl8KJY3CacKcNQQPtgbbZ
	 VmD4CdC6Q2YiM6/r9a0oRFxSnsgIzzRR5Sa/KOQTNZQBBzJOwakExAzw2GIHUCo0vf
	 GRlUGdYaeL5qehGKK4tDTQ0G8nY3SHbyK+WJfRpgY2vkENDWqDBVwxpcUUpNQeQP/2
	 Co3gEwVstJd8QF3cZCS8ORpdJZk4RCc+jck4Z8q1lOC8/ojDRQPzr9erFh1rCr9fpm
	 HWLOsgoEut2jtJs/3HN7cTEiUJQILcDTvFz1Y3aUlw+PcxvpBXHq5XAKUvxsmgUdxP
	 +I90F8jJItjUQ==
Date: Thu, 24 Sep 2026 09:30:06 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
	oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	steven.price@arm.com, qperret@google.com
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
Message-ID: <arTfjgvZIhmXLrw1@willie-the-truck>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-11-fuad.tabba@linux.dev>
 <arK1tHUEJsCQEKzn@google.com>
 <CA+EHjTx+foVF4CRU5D8bQv8bAqDphMN12UrV+_doUryn2ow6bg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTx+foVF4CRU5D8bQv8bAqDphMN12UrV+_doUryn2ow6bg@mail.gmail.com>

On Wed, Sep 23, 2026 at 10:51:34AM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> > > +/*
> > > + * Returns true when handled at EL2, false when the host must stop scheduling
> > > + * the vCPU.
> > > + */
> > > +static bool pvm_psci_vcpu_off(struct pkvm_hyp_vcpu *hyp_vcpu)
> > > +{
> > > +        /* No other writer runs while this vCPU is ON and executing. */
> > > +        WARN_ON(READ_ONCE(hyp_vcpu->power_state) != PSCI_0_2_AFFINITY_LEVEL_ON);
> > > +
> > > +        /*
> > > +         * Orders pkvm_reset_vcpu()'s clear of reset_state.reset before OFF, so
> > > +         * a CPU_ON that wins on OFF republishes after it. Pairs with the
> > > +         * cmpxchg in pvm_psci_vcpu_on().
> > > +         */
> > > +        smp_store_release(&hyp_vcpu->power_state, PSCI_0_2_AFFINITY_LEVEL_OFF);
> >
> > Is there an issue either with the comment or with pvm_psci_vcpu_on()? the
> > cmpxchg is relaxed. I would have expected cmpxchg_acquire().
> 
> It's the comment. The ordering it describes holds with the relaxed
> cmpxchg. The release of OFF orders the clear before OFF. The winner's
> smp_store_release(&reset_state->reset, true) orders its cmpxchg before
> that store. So the clear can't land after the republish. The comment
> should name that store-release as the pair, not the cmpxchg.

Sorry, but I'm really confused by this and it appears to be different to
what we've got in Android as well. Why do we need release semantics for
the store to 'hyp_vcpu->power_state' in pvm_psci_vcpu_off()? What is it
that we are publishing here? The comment talks about pkvm_reset_vcpu(),
but how is that relevant to the vCPU _off_ path? You say the comment is
wrong, but what _should_ it say?

I'm a bit baffled!

Will
