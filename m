Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098C53C47B
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 21:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753221030; cv=none; b=VsGby/1Fc4CqroR1og839rYWiwSz6TEICbiopqp9GnRr6kiZbGv44lI9OaBjUml8QmzW2wywzFTJIIatx57aYIPBF5g0o8bPkd4VSrGcgF0DbBOdxxb1hHC3BsLipo/s+v0K0HIUdL0RUXy/sHtSI+KVvXxvt1mc4rGAUgWa/xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753221030; c=relaxed/simple;
	bh=+pDvvOb5+fIvecCoNYI1w1bG+jxhcbh2R44ZsT6y5t0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MD42cFQ8ITpQaScuByXKFZ7/p3yd3bJPvGhO6xGuMfKZ4XsgIoZpbqM/oLJcCx1fZ2FXI7RmzDlZ8Adye38ZfqcjLN8EcE+0jfMRBPaAkBh836UAMrLYQllKhSZty7hEeKjRXV9oJTk+r8DyoxFR06eO2lt4ikHxHLe2d9HM3A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LhzXvBjE; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LhzXvBjE"
Date: Tue, 22 Jul 2025 14:50:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753221025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J6JMJryGlT5p7ttlqok4lur6h8v0Ti9C4BNuK+Nm70g=;
	b=LhzXvBjEmw1H7R4mNQfHHmu91xXNLEvvBFDEsvIFN1/ATGGvlimCHfkaeiCThaCk7ZftaC
	wotx9xApMLy3q4azPGyy2ZuZT3kmNYfiSXBBtXULuKCjv6i4m+vvgOOsUn+RidJlS+InXd
	AZaGPUpsm03pL9Xgdu05y8nfS1mrFZU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Eric Auger <eauger@redhat.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v4 6/6] Documentation: KVM: arm64: Describe VGICv3
 registers writable pre-init
Message-ID: <aIAHnUZiSB3YGqoj@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-7-oliver.upton@linux.dev>
 <2fecf7c9-7eb2-4bda-bf4f-03b4a1a8f871@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fecf7c9-7eb2-4bda-bf4f-03b4a1a8f871@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 14, 2025 at 05:06:10PM +0200, Eric Auger wrote:
> Hi,
> 
> On 7/9/25 11:14 PM, Oliver Upton wrote:
> > KVM allows userspace to control GICD_IIDR.Revision and
> > GICD_TYPER2.nASSGIcap prior to initialization for the sake of
> > provisioning the guest-visible feature set. Document the userspace
> > expectations surrounding accesses to these registers.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  Documentation/virt/kvm/devices/arm-vgic-v3.rst | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> > index e860498b1e35..c7a1cd22d814 100644
> > --- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> > +++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
> > @@ -78,6 +78,8 @@ Groups:
> >      -ENXIO   The group or attribute is unknown/unsupported for this device
> >               or hardware support is missing.
> >      -EFAULT  Invalid user pointer for attr->addr.
> > +    -EBUSY   Attempt to write a register that is read-only after
> > +             initialization
> >      =======  =============================================================
> >  
> >  
> > @@ -120,6 +122,15 @@ Groups:
> >      Note that distributor fields are not banked, but return the same value
> >      regardless of the mpidr used to access the register.
> >  
> > +    Userspace is allowed to write the following register fields prior to
> > +    initialization of the VGIC:
> > +
> > +      =====================
> > +      GICD_IIDR.Revision
> > +      GICD_TYPER2.nASSGIcap
> > +      =====================
> > +
> > +
> >      GICD_IIDR.Revision is updated when the KVM implementation is changed in a
> >      way directly observable by the guest or userspace.  Userspace should read
> >      GICD_IIDR from KVM and write back the read value to confirm its expected
> > @@ -128,6 +139,12 @@ Groups:
> >      behavior.
> >  
> >  
> > +    GICD_TYPER2.nASSGIcap allows userspace to control the support of SGIs
> > +    without an active state. At VGIC creation the field resets to the
> In [PATCH v4 4/6] KVM: arm64: vgic-v3: Allow userspace to write
> GICD_TYPER2.nASSGIcap commit message it was said:
> 
> "For convenience, bundle support for vLPIs and vSGIs behind this
> feature,allowing userspace to control vPE allocation for VMs in
> environments that may be constrained on vPE IDs."
> 
> which, I understand goes beyond the simple support of vSGIs. Maybe worth
> a clarification.

I would like to omit that language from the documentation. Giving
userspace the impression of controlling the host allocation is a bit odd
and nothing stops us from implementing nASSGIcap for software-injected
SGIs.

vPE allocation should be a non-issue for correctly provisioned
implementations.

Thanks,
Oliver
