Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C463C47B
	for <kvmarm@lists.linux.dev>; Tue, 22 Jul 2025 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220852; cv=none; b=I44vZZyz2TgO7Yikfgbjp2Sn52Lnu50V/w10cRSE3tibl8Y7CLZCTUUUWizwzYGxatz8JXQqFB+UHVs6p2ZyMkgA3s0FkbDlqWL2JiAsca4/fcvuFcTx/20ahtlaYkmbqQC7sU/t7UbutIdo20i2LH4rL30eQvehqG1swQZ1ZX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220852; c=relaxed/simple;
	bh=Jg0pv33wbFikITrBK27iyQWge0OvWyQ31dHcIGjgqzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uq81CnQ9h3Pnz1MQx/wxlEZJJMWnhN2WoBYaWWEn2QTdMtQRKPIOYdRWZzFL0tXR/r+uId3GQoAfA5ylDQ76vsyiWY+dDj5kLLOkfiibm7Zj/rEaSwDBjdYofX9UkK5HbHswnc5BTDDtN5LLK/PHyBx9/3hB/b/aAzI57iG9VrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Sw0Zgbvh; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Sw0Zgbvh"
Date: Tue, 22 Jul 2025 14:47:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753220848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6vbIAZelYdDKJibgPB0CU58fZOd3CWgyntDpi6+7XTE=;
	b=Sw0ZgbvhF5lfwZf9R0tzQTBTb9M+4+f/CRI52CDuHwJxfBr8bA3rJCWVRFk/oxmFeOUyPg
	473gPzt4vs/jgvc2DHUZbORaKF2Q2oGVTsrOl+IIZPXilV0pZks5ux6KHgeCAFWEhH1vCL
	XHQEQL9AJrl9vqKwF5uy4NxNz5/dDFw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Eric Auger <eauger@redhat.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: vgic-v3: Allow access to GICD_IIDR
 prior to initialization
Message-ID: <aIAG60LuRlJjYA5o@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-4-oliver.upton@linux.dev>
 <aeb76627-41b2-4550-9010-de90b679bfd4@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeb76627-41b2-4550-9010-de90b679bfd4@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 14, 2025 at 04:41:45PM +0200, Eric Auger wrote:
> Hi Oliver,
> 
> On 7/9/25 11:14 PM, Oliver Upton wrote:
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
> > diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> > index 5e0e4559004b..487e902b040c 100644
> > --- a/arch/arm64/kvm/vgic/vgic-init.c
> > +++ b/arch/arm64/kvm/vgic/vgic-init.c
> > @@ -157,6 +157,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
> >  
> >  	kvm->arch.vgic.in_kernel = true;
> >  	kvm->arch.vgic.vgic_model = type;
> > +	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
> >  
> >  	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
> >  
> > @@ -409,15 +410,7 @@ int vgic_init(struct kvm *kvm)
> >  		goto out;
> >  
> >  	vgic_debug_init(kvm);
> > -
> > -	/*
> > -	 * If userspace didn't set the GIC implementation revision,
> > -	 * default to the latest and greatest. You know want it.
> > -	 */
> > -	if (!dist->implementation_rev)
> > -		dist->implementation_rev = KVM_VGIC_IMP_REV_LATEST;
> The change related to KVM_VGIC_IMP_REV_LATEST looks unrelated to the
> commit title/msg, isn't it?

It is deliberate here to make IIDR have a similar discovery model to the
CPU feature ID registers where the value after creation represents the
maximum feature set.

> > @@ -552,7 +570,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
> >  
> >  	mutex_lock(&dev->kvm->arch.config_lock);
> >  
> > -	if (!vgic_initialized(dev->kvm)) {
> > +	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
> nit: !vgic_initialized(dev->kvm) && !reg_allowed_pre_init() is easier to
> compute for me
> 
> 
> Besides
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks!

Oliver
