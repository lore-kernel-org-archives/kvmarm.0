Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875941EB5B
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755801837; cv=none; b=Kg14OQpjSwQjM75cFowyGdlUecrKscgISNc1YbjWu2BgM/KgGmRK5emg2PsUCGo1VJ1XzaCXHfzb/gjB+b4btQDA0FY4qX0h9RGjnuh6rAwuub+uStPXKUew4HVXr2CKxSYIz5CZDyvoLfc4fPaLCcrfmUuq3fergEi8Z5mEYpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755801837; c=relaxed/simple;
	bh=Y0+B5xsKPXsCq8dRDNoWcxakWZXi4WhWHBZ1dKMqVQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=he3Zql17bqTlMkcDQX/A95wJcTYXpW/uPhaj5MJshRrgBBoTiDTkp+pcWDw0jUEwTtjgfykvb+TeaZO7nKeBPLIdK/Ox4nvILC8M4sTNK9sKtP9DZblLo1YTzwYQUVMrxu+bFNa1UFo0x0bbtN3Z2d7ZUsb0k8MZLh5vDIciEc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NbD34Ch0; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NbD34Ch0"
Date: Thu, 21 Aug 2025 11:43:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755801832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WqoDM3gCktoZvUcB8/+GpGw1BWyayewk0lnSwJsBs6M=;
	b=NbD34Ch0pST9S7i5dZLDu4SArFzQKOnMq0WvjRWfyr9tp0RZF/v6/+x1NXqNZvYLND3u6v
	kNq1FzUYZyqHeZJpFA4JlOQsWRRo054trzs+jx17LmYACriksk137z46iOHi4SXN2x3X1h
	NpR6LCSA46to4pC7Oc24DuClXzbyTJU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zhou Wang <wangzhou1@hisilicon.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	jiangkunkun <jiangkunkun@huawei.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: vgic-v3: Allow access to GICD_IIDR
 prior to initialization
Message-ID: <aKdo3aIxN6-RKVtA@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-4-oliver.upton@linux.dev>
 <de355a64-01f6-cbc5-7a88-5f57687d5fb8@hisilicon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de355a64-01f6-cbc5-7a88-5f57687d5fb8@hisilicon.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 21, 2025 at 06:55:13PM +0800, Zhou Wang wrote:
> On 2025/7/10 5:14, Oliver Upton wrote:
> > KVM allows userspace to write GICD_IIDR for backwards-compatibility with
> > older kernels, where new implementation revisions have new features.
> > Unfortunately this is allowed to happen at runtime, and ripping features
> > out from underneath a running guest is a terrible idea.
> > 
> > While we can't do anything about the ABI, prepare for more ID-like
> > registers by allowing access to GICD_IIDR prior to VGIC initialization.
> > Subsequent changes will allow the VMM to further provision the GIC
> > feature set, e.g. the presence of nASSGIcap.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/vgic/vgic-init.c       |  9 +--------
> >  arch/arm64/kvm/vgic/vgic-kvm-device.c | 20 +++++++++++++++++++-
> >  2 files changed, 20 insertions(+), 9 deletions(-)
> > 
> [...]
> >  /*
> >   * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
> >   *
> > @@ -552,7 +570,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> >  
> >  	mutex_lock(&dev->kvm->arch.config_lock);
> >  
> > -	if (!vgic_initialized(dev->kvm)) {
> > +	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
> 
> I am confused here, the logic is that:
> 
> 1. For the ID registers, they can not be modified after vGIC init.
> 2. For other registers, the original logic is that they should be modified after
>    vGIC init.
> 
> So code here should be:
> 
> if ((reg_allowed_pre_init(attr) && vgic_initialized(dev->kvm)) ||
>     !vgic_initialized(dev->kvm)) {
>          ret = -EBUSY;
>          goto out;
> }
> 
> Not sure my understanding is right.

This would break ABI which I tried to allude to in the changelog.
GICD_IIDR is _already_ writable post-init, meaning that the only option
we have is to relax that register and allow access pre- and post-init.

The preferred semantics around ID registers is that they're RW prior to
init and RO post-init. GICD_TYPER2 enforces this.

Thanks,
Oliver
