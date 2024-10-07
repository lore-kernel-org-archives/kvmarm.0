Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1975B13B797
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 19:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728328577; cv=none; b=KObGK+Ix3hNfR+Tk45oZGHoU23rRTGqQ455fLSg6Cg/Su4GjGJM13Z67Gqu1gfc97dpLz3UhNa6Qgz7VMGbB44P+nq61n370gEN84XykDSaZFK8N1+FIEdH3/b+ljzTg6a3wVXz9NZinu1ZffFC619+oMCsEkv56umje1pBZ3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728328577; c=relaxed/simple;
	bh=p+A8MIVu+Y06PZpOle/okexbBujBT8zhceC/xXa0zeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gqseM70oWHOHQkU2ytRz5cwyY09u3mtH75Z4wAPy3da/GB20HZyx22KqJ9UQsylM/km14GJXUAUyXJ+yEGIinihSIs5c8CrTxYSFyEccRPg4KIUh6cpBGbMJm4dzMImIr+ApRt/sEiZz7Jm8mK38RDSCIQgvsoS0kYzHFWk1wGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N9acJIrX; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N9acJIrX"
Date: Mon, 7 Oct 2024 19:16:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728328572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EkoBJzjew6dTyw0hooRTL7VWwLuC92uK/T1R7kTaiEM=;
	b=N9acJIrXXKOQmh2RH0x1WWAtN0/q4CyMjt1bU37bCpo2XtvDcBjdBApn3ZHz4zQtCmiVtq
	EBpX/I3MhBsrGHE71DiIQJ0xCQMveY92QWl/CTI0N7HvkmJL0iLG1X+yh9hFZg9jJSLT9E
	Qtb4yduD9CAVuiyzVOzeUzCc49CQEsc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: nv: Punt stage-2 recycling to a vCPU
 request
Message-ID: <ZwQzdFCYUJDKxrhT@linux.dev>
References: <20241007164256.1795250-1-oliver.upton@linux.dev>
 <20241007164256.1795250-4-oliver.upton@linux.dev>
 <86y12z68cp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y12z68cp.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 07, 2024 at 08:06:30PM +0100, Marc Zyngier wrote:
> On Mon, 07 Oct 2024 17:42:54 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Currently, when a nested MMU is repurposed for some other MMU context,
> > KVM unmaps everything during vcpu_load() while holding the MMU lock for
> > write. This is quite a performance bottleneck for large nested VMs, as
> > all vCPU scheduling will spin until the unmap completes.
> > 
> > Start punting the MMU cleanup to a vCPU request, where it is then
> > possible to periodically release the MMU lock and CPU in the presence of
> > contention.
> > 
> > Ensure that no vCPU winds up using a stale MMU by tracking the pending
> > unmap on the S2 MMU itself and requesting an unmap on every vCPU that
> > finds it.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_host.h   |  3 +++
> >  arch/arm64/include/asm/kvm_nested.h |  2 ++
> >  arch/arm64/kvm/arm.c                |  2 ++
> >  arch/arm64/kvm/nested.c             | 21 +++++++++++++++++++--
> >  4 files changed, 26 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 329619c6fa96..16b4b0003e7d 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -51,6 +51,7 @@
> >  #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
> >  #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
> >  #define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
> > +#define KVM_REQ_NESTED_S2_UNMAP	KVM_ARCH_REQ(8)
> >  
> >  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> >  				     KVM_DIRTY_LOG_INITIALLY_SET)
> > @@ -216,6 +217,8 @@ struct kvm_s2_mmu {
> >  	 * >0: Somebody is actively using this.
> >  	 */
> >  	atomic_t refcnt;
> > +
> > +	bool	pending_unmap;
> 
> Nit: move this up next to nested_stage2_enabled, saving a grand total
> of 4 bytes...

/facepalm I had it that way in some WIP flavor of this series, looks
like I dropped that diff. Will do.

> >  	atomic_inc(&s2_mmu->refcnt);
> > +	if (s2_mmu->pending_unmap)
> > +		kvm_make_request(KVM_REQ_NESTED_S2_UNMAP, vcpu);
> > +
> 
> This bit is awesomely subtle. Any vcpu incrementing the refcount on an
> MMU being laundered gets to partake in the cleaning process. Without
> this, the second guy would get to use the MMU before it has been
> cleaned-up.
> 

How about:

	/*
	 * Set the vCPU request to perform an unmap, even if the pending
	 * unmap originates from another vCPU. This guarantees that the
	 * MMU has been completely unmapped before any vCPU actually
	 * uses it, and allows multiple vCPUs to lend a hand with
	 * completing the unmap.
	 */
	if (s2_mmu->pending_unmap)
		kvm_make_request(KVM_REQ_NESTED_S2_UNMAP, vcpu);

-- 
Thanks,
Oliver
