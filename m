Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8211177622
	for <kvmarm@lists.linux.dev>; Tue, 20 Feb 2024 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708450991; cv=none; b=St8UpRyrxqUjzMiwmBD84uTYXoOiDyxHGNCjqzV5XezgT41yVgzu6V2T6E2qLWkJthrej4XSMEBx+dTUYdr6I8xv6iwGF1FR2Lv8NAo+cOCa+AvNYxkgXfU+AglVkCKYGA8cfFIhQtTzOHKj4orUW5MKM0Yg8MhybYLGCHaVFJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708450991; c=relaxed/simple;
	bh=dQqVq1NvhO9fM/qzHMx4aJ4MaWXu0/sZ8110Nw6gfMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djenwM8GJIeCJx9JgyTC7asw9CW8yxE93LcchOfj0YtoUGLqNawBHZRPD+/Sxz7SY2tCYPw24311tGEcliBTlJs/Ezg3z6iR97Q1ZDUqTWyCy8V7XH2fDoQGZ1/gvKSZgrDuHP+hJxCQQbPGVTcSKHwydYqS+N3E+DNvlKBOCs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZzUDS+Qz; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZzUDS+Qz"
Date: Tue, 20 Feb 2024 17:43:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708450987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1WiD5PloTx6/1dWd7HZEu/9GcCBJE7Z8BOQ03vbreAk=;
	b=ZzUDS+QzCOyCwwlPADraq8THbsI8iPSn4f3zF1MBFS9PBQsNomJoiBKAlrWjj69VKcLkTM
	91HY5/klQ7YU9/pmjMBehu617QUXTAWkQ5mpPDKkuE45lCqZf1NgnCTFVY4E0AoChJEue4
	VSdQKOK3e6VrmkEq2WC4uTLkvSKcYUo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/10] KVM: arm64: vgic: Store LPIs in an xarray
Message-ID: <ZdTkp3MnffZwJkyf@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
 <20240216184153.2714504-2-oliver.upton@linux.dev>
 <f6a4587c-1db1-d477-5e6c-93dd603a11ec@linux.dev>
 <86wmqz2gm5.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmqz2gm5.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 20, 2024 at 05:24:50PM +0000, Marc Zyngier wrote:
> On Tue, 20 Feb 2024 16:30:24 +0000,
> Zenghui Yu <zenghui.yu@linux.dev> wrote:
> > 
> > On 2024/2/17 02:41, Oliver Upton wrote:
> > > Using a linked-list for LPIs is less than ideal as it of course requires
> > > iterative searches to find a particular entry. An xarray is a better
> > > data structure for this use case, as it provides faster searches and can
> > > still handle a potentially sparse range of INTID allocations.
> > > 
> > > Start by storing LPIs in an xarray, punting usage of the xarray to a
> > > subsequent change.
> > > 
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > 
> > [..]
> > 
> > > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > > index db2a95762b1b..c126014f8395 100644
> > > --- a/arch/arm64/kvm/vgic/vgic.c
> > > +++ b/arch/arm64/kvm/vgic/vgic.c
> > > @@ -131,6 +131,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
> > >  		return;
> > >   	list_del(&irq->lpi_list);
> > > +	xa_erase(&dist->lpi_xa, irq->intid);
> > 
> > We can get here *after* grabbing the vgic_cpu->ap_list_lock (e.g.,
> > vgic_flush_pending_lpis()/vgic_put_irq()).  And as according to vGIC's
> > "Locking order", we should disable interrupts before taking the xa_lock
> > in xa_erase() and we would otherwise see bad things like deadlock..
> > 
> > It's not a problem before patch #10, where we drop the lpi_list_lock and
> > start taking the xa_lock with interrupts enabled.  Consider switching to
> > use xa_erase_irq() instead?
> 
> But does it actually work? xa_erase_irq() uses spin_lock_irq(),
> followed by spin_unlock_irq(). So if we were already in interrupt
> context, we would end-up reenabling interrupts. At least, this should
> be the irqsave version.

This is what I was planning to do, although I may kick it out to patch
10 to avoid churn.

> The question is whether we manipulate LPIs (in the get/put sense) on
> the back of an interrupt handler (like we do for the timer). It isn't
> obvious to me that it is the case, but I haven't spent much time
> staring at this code recently.

I think we can get into here both from contexts w/ interrupts disabled
or enabled. irqfd_wakeup() expects to be called w/ interrupts disabled.

All the more reason to use irqsave() / irqrestore() flavors of all of
this, and a reminder to go check all callsites that implicitly take the
xa_lock.

-- 
Thanks,
Oliver
