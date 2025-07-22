Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7096D6F06B
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220579; cv=none; b=ivT20tqw89nwyd9jKXbpSKIy1GqOmCVcs6Athk2esK4IuVNutgbqSAICXzWeAEywMXyTq9MAkU39TyzCmO3quxYGxkuCjXuwHeoyzm3qqk/bVLz3N39HRJ/8dYeV+hAFJxjdlWEPFqcl0QWQvcP9aksBPaLyHfF0JVKC3hbNrQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220579; c=relaxed/simple;
	bh=Z9JXQzUAHveRkO9iUbPGQndtuDfXipSIiVrT95HocNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bnKxYH0r1M4UWMlhSB5W3SwWL+RW9BwGvPhHLAH3MBx7UOz6ol8NvSJatEJx6Ftj2CS5UJm+TkbqC6u6ihT1kweOHu8totGQpsEkyQDRyi2P3UJAr6fWdhATSmoMY8QjmNgmxN7fbdutfgdcpSI4oXRhtIBZOZ6IXv6QCcYqrV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b9rWgfvd; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b9rWgfvd"
Date: Tue, 22 Jul 2025 14:42:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753220575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QK8wV1XYziSthp+DI6Acrbf80c7vSVUfZhGuNStSa7Y=;
	b=b9rWgfvdgU8yUWNWesfAo9mRkBwFU0WUauQXWH/7ZQ5xZHX0JWBtMCvNm8/w7xtB1TEMy9
	Vh7nGzqLzHZSLxEa9pOaSb3csGed4zFBTZ1ATbJPKs7BWbUbdgJnByXY1ZerJpYJUyHPEr
	eUDJq/1Conr5wNHKu/3mGJtVboSByP8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Eric Auger <eauger@redhat.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: vgic-v3: Consolidate MAINT_IRQ
 handling
Message-ID: <aIAF1X7EL7ILbLvH@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-3-oliver.upton@linux.dev>
 <3ec89328-57e9-4527-8597-a1567f3ffe10@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ec89328-57e9-4527-8597-a1567f3ffe10@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 14, 2025 at 02:52:37PM +0200, Eric Auger wrote:
> On 7/9/25 11:14 PM, Oliver Upton wrote:
> > @@ -630,8 +608,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
> >  	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
> >  	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
> >  	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
> > -	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
> >  		return vgic_v3_attr_regs_access(dev, attr, true);
> > +	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
> > +		u32 __user *uaddr = (u32 __user *)attr->addr;
> > +		u32 val;
> > +
> > +		if (get_user(val, uaddr))
> > +			return -EFAULT;
> > +
> > +		guard(mutex)(&dev->kvm->arch.config_lock);
> Previously we had a more elaborate lock sequence in
> vgic_v3_attr_regs_access() including
> kvm_trylock_all_vcpus(dev->kvm) and mutex_lock(&dev->kvm->arch.config_lock);
> Maybe worth to document in the commit msg why it is safe to remove that?
> 

Can do, just adding FTR here that kvm_vgic_vcpu_nv_init() only takes the
config_lock so the rest is unneeded.

> 
> > +		if (vgic_initialized(dev->kvm))
> > +			return -EBUSY;
> > +
> > +		if ((val < VGIC_NR_SGIS) || (val >= VGIC_NR_PRIVATE_IRQS))
> nit: !irq_is_ppi()?

Much nicer.

Thanks,
Oliver
