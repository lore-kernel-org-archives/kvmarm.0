Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C90D1C5489
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 19:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748977404; cv=none; b=HAL6b60cOZhWRyGHe7UTJfqWBTLVPhxZnlo8NoH9RTWBej5zOAYGBfjCg7D0XE6jTYybirZhzeceXg1gReqdwnk+SHhKAPzU7NYkE+oobizQ4jkW+7QtQ8YjJiWpDjSQyDiYSgoE/BxMFSDC47vWfISqQeSKcrqFmoizhdtM7pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748977404; c=relaxed/simple;
	bh=myiM0fb1eEEFYd5zdVF2IAUvPitVnXxM4XW4HWHcNDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qn8oUJ0tv/pWdqmzIVxa8vaAA0Bn0cHd6xTqR/brEOzrj3Lj+FpX1p30av6jucrN8qQAk9HWK3c5K9nFhJWclR+3EBAjTXZQ6QwGistHbq8e5y+g5oHb1qG5VDBfVHzT3LuTi/GpB/DtqekaC5kNP+OupHIG1Uu5oJ9Hy70bTmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lt4oyEnK; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lt4oyEnK"
Date: Tue, 3 Jun 2025 12:03:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748977399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wokRz+VIEcUL/B8lSD93v3tkDSKBDCprb9ItHeuexz0=;
	b=Lt4oyEnKj5yqHBHLT6cufF2PmYrrijfuMi/Vs8TG0VVaaT+rRFrmf356kaIAWJOJd2w7IK
	kIvdJTABQm6alVP4GTuheTYU57HWP4SfFgL99Vd2GyrQ0dONJaN6GAOJWoSBQyxNL/3snu
	PVtZkhpsfk20XTctTKP65Kn+vR1wAfY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Ben Horgan <ben.horgan@arm.com>
Subject: Re: [PATCH v2 3/4] KVM: arm64: Introduce attribute to control
 GICD_TYPER2.nASSGIcap
Message-ID: <aD9G6HWChm_GJc5c@linux.dev>
References: <20250531012545.709887-1-oliver.upton@linux.dev>
 <20250531012545.709887-4-oliver.upton@linux.dev>
 <CAJHc60ydf74jG4gtqWVQb40PuMWYFDX8JqVovM1OANudWMuEnw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60ydf74jG4gtqWVQb40PuMWYFDX8JqVovM1OANudWMuEnw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 03, 2025 at 11:33:08AM -0700, Raghavendra Rao Ananta wrote:
> > diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > index b0baad68777c..c9d41ae9fe4f 100644
> > --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> > @@ -626,6 +626,26 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
> >                 dev->kvm->arch.vgic.mi_intid = val;
> >                 return 0;
> >         }
> > +       case KVM_DEV_ARM_VGIC_GRP_FEATURES: {
> > +               u8 __user *uaddr = (u8 __user *)attr->addr;
> > +               u8 val;
> > +
> > +               if (attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap)
> > +                       return -ENXIO;
> > +
> > +               if (get_user(val, uaddr))
> > +                       return -EFAULT;
> > +
> > +               guard(mutex)(&dev->kvm->arch.config_lock);
> > +               if (vgic_initialized(dev->kvm))
> > +                       return -EBUSY;
> > +
> Do we want to return success if userspace isn't trying to change the
> value (similar to sysreg/fw-reg writes)?

I'd rather not. Things that are accessible through KVM_*_ONE_REG get
special treatment since VMMs blindly save/restore the entire list of
system registers. The general expectation there is that the VMM and
always write back what it has read.

Since this is an entirely new UAPI I want to impose as much limitation
as possible on userspace :)

> >  bool vgic_supports_direct_msis(struct kvm *kvm)
> >  {
> > +       /*
> > +        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
> > +        * indirectly allowing userspace to control whether or not vPEs are
> > +        * allocated for the VM.
> > +        */
> > +       if (kvm_vgic_global_state.has_gicv4_1 && !vgic_supports_direct_sgis(kvm))
> > +               return false;
> > +
> Since vgic_supports_direct_sgis() is derived from
> 'kvm_vgic_global_state.has_gicv4_1', do we still need to depend on the
> latter?

Yes, this is a very subtle choice.

GICv4 does not support vSGIs, only vLPIs. If we omit "has_gicv4_1", we
break vLPIs on this hardware.

OTOH, GICv4.1 supports both vSGIs and vLPIs, and the dirty secret here
is we make vLPI support follow userspace's wishes for vSGIs. With that
being said, this should be predicated on both the ITS and the CPUIF
supporting vSGIs.

> Also just to double-check, there are other references that directly
> read 'kvm_vgic_global_state.has_gicv4_1' (vgic_v3_map_resources() for
> instance). Do we not want them to be replaced with
> vgic_supports_direct_sgis()?

There are a few screw ups on my part but most of the remaining checks
are for hardware support (i.e. before fiddling with the GIC), not VM
support.

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..13b561a2c90b 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -404,7 +404,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	 * The above vgic initialized check also ensures that the allocation
 	 * and enabling of the doorbells have already been done.
 	 */
-	if (kvm_vgic_global_state.has_gicv4_1) {
+	if (kvm_vgic_global_state.has_gicv4_1 && vgic_supports_direct_irqs(kvm)) {
 		unmap_all_vpes(kvm);
 		vlpi_avail = true;
 	}
@@ -581,7 +581,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		return -EBUSY;
 	}
 
-	if (kvm_vgic_global_state.has_gicv4_1)
+	if (vgic_supports_direct_sgis(kvm))
 		vgic_v4_configure_vsgis(kvm);
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index a9c772697a43..053d4fe7de8b 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -245,7 +245,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4)
+	if (!vgic_supports_direct_irqs(kvm))
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
