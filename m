Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A21418368
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 11:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164376; cv=none; b=Jfsm407qCPeQgLQVn+u/kgHmVdaFcythIFbndIqCr00SDM27yp3Y2j4WGFHAgUZNP0sSPi15PXlBOMAHyohTE+cD+432Ni4tMluIjaA1wxYBJriUhiRVXkEaGTDkFT/daeewTCWCgfjn0vrXDcfq2lFeZLEnr9UdwghdVHS+4Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164376; c=relaxed/simple;
	bh=lUYHJQmmmPLnvw+qXr+B62c88jlc853lezQ2xlWJuQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9VK7J/ZYWlAiYJ76IVhOcp7ty3YKjHgYW0OUAyBhfo1Z6i9AeE7NyCr69JL2b2uMMPqe/mfODF5bIDulre1GOojAZTbsLluFqugWGXqif7URf/Rnpn9OAh4aPuy84r0SQd8xZs4Gdi9jGdNnV90uaTxIoADPcib02mivMBdzO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pkohuc92; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pkohuc92"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49e65a8f70eso34175e9.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 04:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790164361; x=1790769161; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fAdFq/HquCPEOwe3O39yGHp6X7TbyFjfrWxFg5C9wy0=;
        b=pkohuc92fK2cIBVTefoxrDq2T+H+auxCFqoCDkQa2B7xmzN7B1YtRxnEvHKF/Bu7+y
         vkKxMEYWOvXEPVX6ShgkSmriHcKrpLYnQLNyH5/OxF3NcwtnOPTaTrERRo+HTZOEAE4I
         2FaeJLll2mofCOSN0bhUlo6VWy0LN4J2t9PvN3zkdy/shHfP9Opis305pMPiAA0HKByY
         wTa27ERaCUZ7vqRtKe+AlfyBfxXyf/315klD05mkYQiXOa8VJKJOYM1VXZOuapEniMvm
         mXnGpVSYKdP0sq7zXw+VLO2DMxXYGCXQsL4n95VoQVxYPTl/1WlzUff2BY21Xz/rqi9l
         pWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790164361; x=1790769161;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fAdFq/HquCPEOwe3O39yGHp6X7TbyFjfrWxFg5C9wy0=;
        b=UqsLMDKDHr8KcMjBqsNa7yxvXkNFy5LWVhNPAOqryrIgRY95avET9yPuZ+2Xwx7+P0
         9vOHGAzef/djys04fhi4ATSCcI9A8icQh0SRdPo8tSoBhQLtErh9DApzOT3ojHvA6Cmf
         gWwpW6iS22VEmdXR8MK1Ac/W1DytOIQvoXghscwPWx+JoqAZvYWckasbBlWHlJP5BCL6
         x5Cqh+Q76bFewP1fMCAJtNA+ud3g6YmGPOUVRtr/FwpkUHpPMEjYM57HxB7QcYeFdMNN
         gK5owWc0FOnXBmFOKtt/97f8PeNhuZqVBiS500Z5W7LS8VBQIT4mPqT/eWreajgpHSP1
         H9Pw==
X-Forwarded-Encrypted: i=1; AKwUvBzGvXkwwKu77m/cUkhD92uFuHCn4dphYrTfdHTp01lBb5qLYV9nAGJwrj7SRfFUDGf/40u/Fds=@lists.linux.dev
X-Gm-Message-State: AFuF++kYYa32Dq4AOV4HZJBJ4Vf7C4BEltGR53DzDAxOPY+BO5kwF8Xq
	B1MtvBeygrygNJb35BmC15HkAkkNOMUwQbF2bb1KGbiwliAOTeH1oRoQX8gDNCgo1A==
X-Gm-Gg: AYBFou1wGKql+JZDsWga8Sxtk/VdfhtmIc9N2kJ6/XDuukBZRJTtOnlOj17wMuJtoRN
	hPishVyvapUrpMBVXrbHmG1C6tz/yQnq6LuKoSwMuaw5Glc915CaRHdct0gb0LltDqx9f1zco7V
	DSr/0VDeCfbLizt68nZSDB+NEoWjujAIvKn75rcNxRcA6OR/eIJbX5Qei2JuRvbtibKqM5UtkBc
	WwStQHfEG6WdQ/ig8tFV8jvvM2RjlAu1OZBZrjWrCNx76camNAbi8eVtl+YaZOVgcsjC3FbkLfd
	k0jVCKSENr+t+U30hth9WRouEwFXJMU5P9RFhm0F6OQvjxkf+wa1ndAhKgsS+I6VXUCejOshJEk
	e2DdJG/jSw4EeCq5ilk1l4LFJHOpB+n2zC2OSuROwrgHNbNkNDXwx10/0qVHZouf5ZyR6rGF3Uk
	5EeH20azC4vYZSRhaMJy685lbXHmvrn+hyBC7w2c6Zfa1YnZ3gcb4dngJU9Wkuz8NcRoUp5Kiu7
	QuZt9TTEoNbtlVPDzwQ23fRv/+iAtiZMnKtvLmEpOvGRm7c8dk=
X-Received: by 2002:a05:600c:17ca:b0:49f:e12d:1a60 with SMTP id 5b1f17b1804b1-49fe12d2109mr449435e9.4.1790164360990;
        Wed, 23 Sep 2026 04:52:40 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488682673bdsm6433690f8f.2.2026.09.23.04.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 04:52:40 -0700 (PDT)
Date: Wed, 23 Sep 2026 11:52:36 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v8 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <arO9hGmEx7c9mZAj@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-12-smostafa@google.com>
 <arMbxX+sqTS3gByB@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arMbxX+sqTS3gByB@nvidia.com>

On Tue, Sep 22, 2026 at 05:22:29PM -0700, Nicolin Chen wrote:
> On Tue, Sep 22, 2026 at 01:12:44PM +0000, Mostafa Saleh wrote:
> > When KVM runs in protected mode, and CONFIG_ARM_SMMU_V3_PKVM
> > is enabled, it will manage the SMMUv3 HW using trap and emulate
> > and present emulated SMMUs to the host kernel.
> > 
> > In that case, those SMMUs will be on the aux bus, so make it
> > possible to the driver to probe those devices.
> > 
> > Otherwise, everything else is the same, as the KVM emulation
> > complies with the architecture,so the driver doesn't need
> 
> Missing space before "so".

Will do.

> 
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> > @@ -0,0 +1,187 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * pKVM host driver for the Arm SMMUv3
> 
> I am a bit confused by pkvm/arm-smmu-v3.c and arm-smmu-v3-kvm.c
> 
> It would be nicer to have a design doc or diagram here and the
> other place to show their relationships (with host and KVM too).

I can add more info in the cover letter about the code split. Mainly:
- arm-smmu-v3-kvm.c: Is the kernel driver for KVM SMMUv3 (this runs in
  EL1 and can use all the kernel functions).
  The main job of this driver is for discovery, it doesn't do anything
  else in the runtime.

- pkvm/arm-smmu-v3.c: Is the hypervisor driver (this runs in EL2), this
  is the driver that does the trap and emulate and is considered
  trusted. It can not access the kernel functions (all the code split
  is added for this file)

- After arm-smmu-v3-kvm.c creates the AUX devices, the upstream kernel
  driver (arm-smmu-v3.c) runs normally and the emulation code in
  pkvm/arm-smmu-v3.c should be transparent.


> 
> Naming-wise, could it be arm-smmu-v3-pkvm? I also wonder if we
> could move it into the pkvm folder:
>   pkvm/arm-smmu-v3-hyp.c
>   pkvm/arm-smmu-v3.c
> 

Anything under pkvm/ runs in EL2, so arm-smmu-v3-kvm.c should stay
outside. I am happy renaming both files (arm-smmu-v3-hyp.c,
arm-smmu-v3-pkvm works)

> > + *
> > + * Copyright (C) 2022 Linaro Ltd.
> > + */
> > +#include <asm/kvm_mmu.h>
> > +#include <asm/kvm_pkvm.h>
> > +
> > +#include <linux/auxiliary_bus.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include "arm-smmu-v3.h"
> > +#include "pkvm/arm-smmu-v3-hyp.h"
> > +
> > +extern struct pkvm_iommu_ops kvm_nvhe_sym(smmu_ops);
> > +
> > +static size_t				kvm_arm_smmu_count;
> > +static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
> > +static size_t				kvm_arm_smmu_cur;
> 
> That spaces/tabs in those two lines look a bit odd..
> 

These are tabs to indent the variables, similar cases exist in the
SMMUv3 driver, check arm_smmu_cmdq and friends for example.

> > +static unsigned int smmu_hyp_pgt_pages(void)
> > +{
> > +	struct device_node *np = of_find_compatible_node(NULL, NULL, "arm,smmu-v3");
> > +
> > +	/*
> > +	 * SMMUv3 uses the same format as the CPU stage-2 and hence have the same memory
> > +	 * requirements, we add extra 500 pages for L2 STEs.
> > +	 * Only one set of memory is allocated as the page table is shared between all
> > +	 * the SMMUs.
> 
> Mind briefly elaborate the 500 pages in this notes? Why pick 500?
> 
> Also, there is no hard requirement, but the main driver still wraps
> inline comments at 80 cols. So, it would be nicer for this driver to
> follow that.
> 

TBH, this is a bit of a hack. The hypervisor can not allocate memory
at the runtime. All of the hypervisor memory comes from a carveout
allocated at boot (see kvm_hyp_reserve())

So we allocate the worst case for memory mapping with leaf granule. But
the hypervisor also need to allocate L2 pointers and the SID space can
be massive making the upper limit for this too large.

However, smmu_hyp_pgt_pages() defines the minimum pages required,
actual allocation comes from the command line, so it is possible to
tune the system without re-compiling the kernel.

Thinking about it now, we can just drop the 500 as this is the lower
bound, earlier versions of this series would allocate the carveout
based on this size, but it is not needed anymore.

> > +	 */
> > +	if (np) {
> > +		of_node_put(np);
> > +		return host_s2_pgtable_pages() + 500;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver smmuv3_nesting_driver;
> > +static int smmuv3_nesting_probe(struct platform_device *pdev)
> > +{
> > +	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
> > +	struct device *dev = &pdev->dev;
> > +	struct resource *res;
> > +
> > +	/* Only device tree, ACPI not supported. */
> > +	if (!dev->of_node)
> > +		return -EINVAL;
> 
> Sashiko reported a critical finding, which sounds plausible to me:
> "
> Can an adversary bypass pKVM stage-2 memory protections here?
> If an SMMU fails to bind to the hypervisor due to early returns in this
> probe function (like missing a device tree node or hitting the cavium
> erratum below), it is excluded from kvm_arm_smmu_array and the hypervisor
> does not trap its MMIO.
> When the native host arm_smmu_driver registers at device_initcall, it can
> successfully bind to this unbound SMMU. Does this allow an adversary host
> kernel at EL1 to natively program this untrapped SMMU to perform arbitrary
> DMA into hypervisor or guest memory?
> "
> 
> Would you please justify?

Yes, Sashiko replied to this mail with it and I replied:
https://lore.kernel.org/all/20260922132814.D398D1F000FF@smtp.kernel.org/

Basically, yes that is possible. Some SMMUs might not be in the device
tree or might not be compatiable or the system might have an SMMUv2 or
a completely different arch or no IOMMU at all.

pKVM can not defend against bad FW or missing HW, and if something i
missing there is nothing to do about (and it won't even know)

There are some extra notes in the last patch that includes the
documentation I can add more.

But this is also similar to how pKVM monitors SMC (TZ channels), by
inspecting FFA traffic, if some system decided that TZ will accept
other side channels for sharing physical addresses, pKVM can not do
anything about it and the system is not secure by design.

> 
> > +	if (kvm_arm_smmu_cur >= kvm_arm_smmu_count)
> > +		return -ENOSPC;
> 
> Both counts and probe() are coming from Device Tree. So, it doesn't
> seem possible unless a kernel bug. Should it WARN_ON?

I will add a WARN_OON()

> 
> > +	smmu->mmio_addr = res->start;
> > +	smmu->mmio_size = resource_size(res);
> > +	if (smmu->mmio_size < SZ_128K) {
> > +		dev_err(dev, "MMIO region too small(%pr)\n", res);
> > +		return -EINVAL;
> > +	}
> 
> Should it reject !PAGE_ALIGNED(addr|size) like the other driver?
> 

That check is in the hypervisor part but can be added here instead to
save a trip. Although that should never happen.

> > +static int __init kvm_arm_smmu_v3_register(void)
> > +{
> [...]
> > +out_err:
> > +	kvm_arm_smmu_count = 0;
> > +	kvm_arm_smmu_array = NULL;
> > +	return ret;
> > +};
> 
> No ';' after '}'.

Oops, will fix it.

> 
> > +static int kvm_arm_smmu_v3_post_init(void)
> 
> __init?
> 

That should be possible, I will add it.

> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -5203,6 +5204,72 @@ static struct platform_driver arm_smmu_driver = {
> >  module_driver(arm_smmu_driver, platform_driver_register,
> >  	      arm_smmu_driver_unregister);
> >  
> > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > +/*
> > + * Now we have 2 devices, the aux device bound to this driver, and pdev
> > + * which is the physical platform device bound to the KVM driver but not used.
> > + * However, this driver keeps using the platform device for 2 reasons:
> > + * 1) Simplicity: Avoiding changing big parts of the code assuming
> > + *    the underlying device is a platform device.
> > + * 2) Dealing with DMA-API, irqs(MSIs), RPM... requires the physical device.
> > + *
> > + * That means arm_smmu_device_probe() allocates its devm resources on the
> > + * platform device, where they are not freed when the aux device unbinds.
> > + * The devres group bounds them to the lifetime of this binding instead.
> 
> There is an "unbinds", so I assume it should be:
> 
> s/bounds/binds
> 
> ?

I think "is bound", I am not sure if bounds/unbounds is correct.

Thanks,
Mostafa

> 
> Nicolin
