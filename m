Received: from out-23.mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F8C959
	for <kvmarm@lists.linux.dev>; Thu, 23 Mar 2023 19:49:18 +0000 (UTC)
Date: Thu, 23 Mar 2023 19:49:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1679600956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=30olvZAapUZx7TEEy9RyCXZ05qesWJ5bkCOLGb++Q4o=;
	b=QKsCmzSM95s6TbJ4fWJsKAqQgFAhsxAeO5PHC6exJn+LD9RC+4tzc3iTp1zmAeU6CE2uhK
	+sEaF+oiWqixzSjXtcUTKn3rD8ZccgoQ6fIllLRxI3Do0Qj/Qx56k4v2fZ48lPvrQisSsQ
	0GDarWu6I2qYitQPyyNVD5YeONEkaFY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvmarm@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Jeremy Linton <jeremy.linton@arm.com>
Subject: Re: [PATCH v2 2/4] KVM: arm64: Avoid lock inversion when setting the
 VM register width
Message-ID: <ZBytOKdPahej9JdN@linux.dev>
References: <20230316211412.2651555-1-oliver.upton@linux.dev>
 <20230316211412.2651555-3-oliver.upton@linux.dev>
 <87lejpgfj3.wl-maz@kernel.org>
 <ZBymjOFNfyyXqWX3@linux.dev>
 <4f18d5264e4213f5a94a26bd8539eb0c@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f18d5264e4213f5a94a26bd8539eb0c@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 23, 2023 at 07:43:04PM +0000, Marc Zyngier wrote:
> On 2023-03-23 19:20, Oliver Upton wrote:
> > On Wed, Mar 22, 2023 at 12:02:40PM +0000, Marc Zyngier wrote:
> > > On Thu, 16 Mar 2023 21:14:10 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > > > +#ifdef CONFIG_LOCKDEP
> > > > +	/* Inform lockdep that the config_lock is acquired after vcpu->mutex */
> > > > +	mutex_lock(&vcpu->mutex);
> > > > +	mutex_lock(&vcpu->kvm->arch.config_lock);
> > > > +	mutex_unlock(&vcpu->kvm->arch.config_lock);
> > > > +	mutex_unlock(&vcpu->mutex);
> > > > +#endif
> > > 
> > > Shouldn't this hunk be moved to the previous patch?
> > 
> > Uh, I don't believe so since this is the patch that actually introduces
> > kvm_arch::config_lock. The last patch was aimed at a separate lock for
> > mp state.
> 
> Nah, you're obviously right. I reviewed this at 4am being jet-lagged.
> Not the brightest comment... :-/ Sorry for the noise.

No problem at all! I wish I had as good of an excuse as you for the times
I gave far worse feedback...

-- 
Thanks,
Oliver
