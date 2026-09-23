Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EB0488D95
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 10:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790159422; cv=none; b=BETTfKxbNbX8ALE6tbzW/P+3ucPVd0f8DtPDe63/U9snp7zY3/jsXwhqKp3kvTkHqQQ4LUJmIJz6Hua4SAifH4rTHE2HxrTWeYO1nlhyO2XO3VoRVmd62cRoZR9MezslwOpPuA+USiipHIJ2mpKtaq+n67kfmDJX3CBJVyEK3V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790159422; c=relaxed/simple;
	bh=RH724JkT1TH0BVBbfq0vo+soCwQoN0cmU8izeXTd2vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjaW5URiJweUfgoYanNCEggdFRKhZ/3MlyKEBF5+cWyryCGH6Epqbwlb5F6X2wHsHlLkAgKsx5vSjzsKjH24zSG0qSw4gBgx+CqUkkuGetO0j2U7khO50BfsbUGueYgBoOfsGl67oUYfzaWAcqXXfAt3or55vnswOgw9rtgGQb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CqVVvPNF; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CqVVvPNF"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49ccf12bed0so33535e9.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 03:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790159410; x=1790764210; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ovOwY8bLaV9a90WmLe0SJbMjYqolqHUHY1GzJaJp6yo=;
        b=CqVVvPNFKmkIkc1XPcBvsz/sNGZu/egCVHwZo7pz/mGo5xQGXT0SrIg+A0+FD075+H
         eCXxZ2XKN5zA3GHhj5LmM8hKKct/k3di4o9C+WYRoZI8J2mAIJtLMJte6ucqeltOf42B
         NhYB2O+i1anVt4P6sEikqNlovUgbsOVX9BHJjyyud+DLlf2WCFhmV7mnVQFcax3cNDVa
         +Dj+4H6YHqw3sentgmT145OSwkMa53/ozrJKnu4HSsMzIfXO4uQo3lqh1Y93oUpRk5bv
         QKSJH6T7fl+AUv+alKVkv9c2o/bZc9hqD+0SWXL6N2zu1K76wN3g/C5U0UXe8VRwatln
         WgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790159410; x=1790764210;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ovOwY8bLaV9a90WmLe0SJbMjYqolqHUHY1GzJaJp6yo=;
        b=BKFh5+8rhKSjSx2Y8yXBGIA/rITHvv2kKAwOYnJGPGpXE3rW8hFwTD7yLueFUBWB6q
         WalcUmJhrlZ1sjqB1C8r8yXpyfDLJGvEXDqjeFtsPzKjj9WN3lpRct3EKe2bzQKozixA
         AYVTc20RmQVUIJguFXWtNuY91fQH6XS13rxlTWuW4xibRsiSqQphCNJui/mICw2sOG3I
         hd93HvfacvD7Tt4Ce8Jf0Gplc99/iiA+9QiJHUH6zGsVxVfsZ/ciuthMDXJX2mp+3SGa
         /Y006/9XDB1kP/D1mg8BM6OfQfBV+c8K8e9rpjL3Qmes6J04KUqpy458t+nxNLK5i9f6
         6lIw==
X-Forwarded-Encrypted: i=1; AKwUvBzUu9eiRLhtFWc0DH52zF6UcTm1ykmuSqswqMxyLhsv4i7fTFoEGASn9+cJsrcxAdwW52T2xkM=@lists.linux.dev
X-Gm-Message-State: AFuF++lnTcObVnX0l8IHU+wFNLJRZtC5UBw6V6RESRSPjE4TB1+Z5K49
	V/l9Jz6uOmmfu7DGnnLIMPcTd3LepnlNLJg5MMTCFl4uKHBCLW5L0PbJyE0phkuOJg==
X-Gm-Gg: AYBFou3Q7LjayJ4OACzId6KjEPsdCXIatO4ztpmV0YyFKzblXyN8R0Uq1vggXyfUXHo
	su7rn/fjllWfD0F0PcIJbg38ZVjPMuNMS01A9FQDWmbPREzWFPkXugfYiHFYx742/JgWNjXStMv
	WtNqZR8jTfJJGifJe3BwxQ8w80ddxZGEn3zf+tsYev9nySCrmrokJFHAXkIH632eRtcHx3s5kDX
	BtAbjkaUQKl1pRGKoP8fzSk8/SRSF23j2MgEuh7ZYIy0tuaeklWQtTGxM3CavIcwBgLllN90ROL
	Lep/+E+m70HwFqodM3QRuruOdYtf9CY5PtoHNRI8KpB9Z+QX9zbVJzmUxpsyyJ7cSy01uytiExK
	+T+Lb/92+/SPdcryHq9J6KDQ4g+oUdQgAM3QujNKrGKtkk1PTlh+dDpI/4uz+w4Dc0hzPJkIpme
	89IZXNT12cxp5jsAG/28wtPPZcXJCgVW2b3YCUkEBh+9+Ae1zSeya48d0Z/qEGbRauyT69Zy0aA
	p4nh0l5/65bkWGFnqvcFjSdfv45Xt8Epz3nElbO
X-Received: by 2002:a05:600c:8588:b0:48a:623c:8859 with SMTP id 5b1f17b1804b1-49fe1a55d46mr425265e9.7.1790159409353;
        Wed, 23 Sep 2026 03:30:09 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fde185329sm68031695e9.1.2026.09.23.03.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:30:08 -0700 (PDT)
Date: Wed, 23 Sep 2026 10:30:05 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH v8 10/25] iommu/arm-smmu-v3-kvm: Add SMMUv3 driver
Message-ID: <arOqLQTOsofAzCmg@google.com>
References: <20260922131259.2975334-1-smostafa@google.com>
 <20260922131259.2975334-11-smostafa@google.com>
 <arMDiPHiMvHVHsBr@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arMDiPHiMvHVHsBr@nvidia.com>

On Tue, Sep 22, 2026 at 03:39:04PM -0700, Nicolin Chen wrote:
> On Tue, Sep 22, 2026 at 01:12:43PM +0000, Mostafa Saleh wrote:
> > From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > 
> > Add the skeleton for an Arm SMMUv3 driver at EL2.
> > 
> > The driver rely on an array of SMMUv3s on the system, where at
> 
> s/rely/relies

Will do.

> 
> > +++ b/drivers/iommu/arm/Kconfig
> > @@ -141,3 +141,15 @@ config QCOM_IOMMU
> >  	select ARM_DMA_USE_IOMMU
> >  	help
> >  	  Support for IOMMU on certain Qualcomm SoCs.
> > +
> > +config ARM_SMMU_V3_PKVM
> > +	bool "ARM SMMUv3 support for protected Virtual Machines"
> > +	depends on KVM && ARM_SMMU_V3=y
> 
> Should it depend on OF?

Makes sense, I will add it.

> 
> > +	help
> > +	  Enable a SMMUv3 driver in the KVM hypervisor, to protect VMs against
> 
> s/a SMMUv3/an SMMUv3

Will do.

> 
> > +++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
> > @@ -0,0 +1,31 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef __KVM_ARM_SMMU_V3_HYP_H
> > +#define __KVM_ARM_SMMU_V3_HYP_H
> > +
> > +#include <asm/kvm_asm.h>
> > +
> > +/*
> > + * Parameters from the trusted host:
> > + * @mmio_addr		base address of the SMMU registers
> > + * @mmio_size		size of the registers resource
> 
> Are these still in the host's physical address space or guest's?
> 
> If it's still "host" (though trusted), what's different from the
> ioaddr in the main driver?

This is the physical address of the SMMUv3 as read from the device
tree.

The "base" pointer is for the hypervisor virtual address which is
created in the private mapping range (similar to ioremap())

The hypervisor doesn't keep the host VA anywhere. Also note that
there is no guest support at the moment, only the host.

> 
> > +size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
> > +struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
> 
> Should kvm_hyp_arm_smmu_v3_smmus be __ro_after_init as well?

That won't work at the moment as the hypervisor writes this pointer
after __ro_after_init to convert the kernel VA to hypervisor VA
unlike the count which is set once at boot.
It might be possible to make the kernel do this conversion early, I
will need to double check.

It's worth noting that __ro_after_init is just for the hypervisor
hardening and not for protection as those are protected by stage-2
MMU.

> 
> > +
> > +#define for_each_smmu(smmu) \
> > +	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
> > +	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
> > +	     (smmu)++)
> 
> "smmu" sounds too generic. Maybe for_each_pkvm_smmu?

This macro is private to this driver, so I guess that's enough, also
smmu is used everywhere else, but no strong opinion.

> 
> > +/* Called while is the host is still trusted. */
> > +static int smmu_init(void)
> 
> s/while is/while

Will do.

> 
> > +/* Shared with the kernel driver in EL1 */
> > +struct pkvm_iommu_ops smmu_ops = {
> > +	.init				= smmu_init,
> > +	.host_stage2_idmap		= smmu_host_stage2_idmap,
> 
> Can we add a "pvkm_arm_smmu_" prefix for the ops and functions here?

Similar to above, these symbols are private to this file and the
hypervisor symbols gets prefixed with "__kvm_nvhe_" anyway, so they
never clash with the kernel. But no strong opinon.

Thanks,
Mostafa

> 
> Nicolin
