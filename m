Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB94288A7
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 11:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707479921; cv=none; b=ISeKP98bWBtB87xzLhLa+hrZsK4Ci2kHE3UJYtGBfPjTBoNvj/+Q2C4DZfdZKw1+1mf77S/8o2E6IgBmyXlKo77A5Jtv9hu9ZQpPh+60Omn8c3kX58X/9HJ/DLN0+zfe5fordHxqx19kb7zwG/8oy3XmWtO4H44ldNCZxOMWpz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707479921; c=relaxed/simple;
	bh=pqufWlUw7wGcrbbby3U3Lel/p1k1uW7o6OSMwX/CjhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqrQP6QU6VtgodAj6lPs+ldky5lEY3B1eW7nTCGx57P0YBA1sD1+gd1SwY0txdO4L9J9TztYW2ryOR/RmxO7+xWjr/aS5D1S89Rn42ZyMHRptoDSiKCR6VR4rVLXOaiN5BolPYQRruISuSeniychDo0MXfLb51PL2RqYmK3DblA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BTqCEMBQ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BTqCEMBQ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4106ccf0effso3460415e9.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Feb 2024 03:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707479913; x=1708084713; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRwaXllpUiiGZN6hHGF+KZe1kKd23K1mjfQaoa29eGc=;
        b=BTqCEMBQ0WhFKS5rzWg8y9bXSnbOf+ZcQsdiJ7quxP5RE8TtTYyTTRzQzojgspuTPp
         p+peWM7qFtz3l+W5fnsUAYhLnHF6nEEgRynHKl9euE5xpi7P75LRQ25hJqyHMABXQhT/
         anwzq8ZEkeZl3Z3PWWgOX8Cvlj+iQ54CoCyLo9AUdZk4KmoChcMl6uSsGoS8bMatSCPG
         f+NkFRrCpukntZX+tzFAy7RoM2SHBIrrRHReKfeO0DB5whA60l/lXTj7tiKbeszgOCRl
         liNW1jbnSP0JtOEzIMkffJDvU189Wn/3RQ5k+sIJbIltC4MySyRd1cNmwazEUTzoFH50
         CccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707479913; x=1708084713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZRwaXllpUiiGZN6hHGF+KZe1kKd23K1mjfQaoa29eGc=;
        b=VQx9OuFn2NIxR+V7+GfSDBfAzPNOtGqlqlyTkaTSZLf1OcS+2EIAj+xx52F/2ZxJdu
         t70xpm1bhEd9BglMtmHmIwSbyI55kqz5C1EFfB7IzwokhY1jOXoU/p8eJRnn/qMrgTai
         6jDX8AiLvwU4HHBmAB9eoAt2JodU8h+Doo2jcvYUwuzmGJGZzEkQEpt5RITEukzXbl4t
         RG7aJttzRjFoSC8NXWw7LVQ9CouondAhs1XxiTZhFVrconHv4XQ3IGahV53SEHUDmIQq
         lhLQTA1Ya4UGedVPC2pHTGfkhX6hEtuTtS0YCZjcpT9VfCthpe61MPviu5KO6iAqE1QL
         mUWw==
X-Gm-Message-State: AOJu0Yy7WihC3tH54t6bqzgWSxVH79Bx11kRbw2ykC1HTKFwLTSXaTjE
	uA18KWho6M8+6BG5fcGv6ouFW49iwr7Af9w7p8QzNdZ9cSF+psL8jRlLln2JPPY=
X-Google-Smtp-Source: AGHT+IGvouDyT1S/q9yBMPyy37QzOHgMuxyrYD38phGx8Dc9ItCNIuOOaFGDMsnXDKAJsNkPQgu+mA==
X-Received: by 2002:adf:e80b:0:b0:33b:49f6:cf89 with SMTP id o11-20020adfe80b000000b0033b49f6cf89mr1004637wrm.51.1707479912855;
        Fri, 09 Feb 2024 03:58:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWfJPbY1ZXOjDhGDVDTfIfsNKg0YgtUMR/KFHggANeTQqZEgEdSQ8JUr+gOAaWCsU8tV/5X8V9HYdIjiYHgzVXDUQ5WC7s7hYFHWVh4Orn0lFB7dFzjYEYwhX4H/6nTr3n4ok8ZI2jGlDCDlnkXeJPG6H5jpYFnVeJvkFWfYzbR0808nIQNlFN5rN7NAlwNs1PnGTr7IBca4BK6Dq5EIoE/VNjIwFZ4JaYPl06dhVrHikaNnYp7IvOEicAqT8Sq6teH8vlQr6en/VAAKbfE/iHCwXa3cStqlEtGR5Hrw06oPEdz0YFENE6cTjy4a1Q6cUWPwqxUBLsusATY+3hnyUpN/htkTo6wLY9cGe6ySAWWzvUYSIPdPZJh31uCcr5IJ9NfOwlA9kI/I80WL3A=
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id i4-20020a5d55c4000000b0033aedaea1b2sm1636931wrw.30.2024.02.09.03.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 03:58:32 -0800 (PST)
Date: Fri, 9 Feb 2024 11:58:24 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, jgg@ziepe.ca, alex.williamson@redhat.com,
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	robin.murphy@arm.com, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for
 stage 2
Message-ID: <20240209115824.GA2922446@myrica>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>

Hi Shameer,

On Thu, Feb 08, 2024 at 03:18:30PM +0000, Shameer Kolothum wrote:
> Hi,
> 
> On an ARM64 system with a SMMUv3 implementation that fully supports
> Broadcast TLB Maintenance(BTM) feature as part of the Distributed
> Virtual Memory(DVM) protocol, the CPU TLB invalidate instructions are
> received by SMMUv3. This is very useful when the SMMUv3 shares the
> page tables with the CPU(eg: Guest SVA use case). For this to work,
> the SMMUv3 must use the same VMID that is allocated by KVM to configure
> the nested stage 2(S2) translations.

The series makes sense to me. Maybe a little more detail to help the KVM
maintainers understand why we need something like this even though the s2
page tables aren't shared between CPU and SMMU:

* When enabling BTM in the SMMU, all TLB invalidations to the
  inner-shareable domain issued by the CPU are taken into account by the
  SMMU. That includes for example the TLBI IPAS2E1IS from
  __kvm_tlb_flush_vmid_range().

* BTM is enabled globally in the SMMU CR2 register. If we enable BTM for
  host SVA, then it also affects KVM.

* Stage-1 TLB entries in the SMMU have a bit (ASET) saying "this entry
  is private and does not participate in BTM", which we set for private
  SMMU address spaces.

  Annoyingly, the stage-2 TLB entries do not have it. With BTM all VMIDs
  are shared between CPU and SMMU.

* So, if the SMMU driver allocates VMID privately and we enable BTM, then
  CPU invalidations will remove unrelated SMMU TLB entries. Instead, the
  SMMU driver needs to coordinate with KVM on VMID allocation.

* Private stage-2 address spaces in the SMMU would need to allocate VMIDs
  that aren't used by KVM, but that's not a use-case at the moment:

  - For assigning devices to a host process or to a VM, we use private
    stage-1 mappings. stage-2 will be used to enable nesting translation,
    and will typically mirror the KVM stage-2 since it pins the guest
    address space.

  - If the SMMU doesn't support stage-1, the driver falls back to stage-2
    for private address spaces. For such an implementation we disable BTM.

  - The old VFIO_TYPE1_NESTING_IOMMU lets userspace allocate a private
    stage-2, and has only been used for testing as far as I know. I don't
    think I ever found a program that used it in the wild, but haven't
    checked recently.

    The effects of using it with BTM enabled is performance degradation:
    TLB entries of that VFIO container get invalidated by unrelated KVM
    activity, and maybe that can be used in a side-channel attack. 
 
    It needs to be deprecated over a few releases (starting with a
    warning maybe?), and the replacement API shouldn't allow creating a
    stage-2 without a KVM context.

Thanks,
Jean


> 
> An earlier proposal sent out[1] a while back resulted in changing the
> ARM64/KVM VMID allocator similar to the ASID allocator to make it
> better suited for this.
> 
> This RFC adds,
>  -Support for pinned KVM VMID.
>  -Support associating KVM pointer and iommufd ctx.
>  -Changes to domain_alloc_user() to receive a kvm pointer.
>  -Configure SMMUV3 S2 using KVM VMID
>  -Finally enable BTM only if SMMUV3 supports S1 translation. This
>   is to make sure that PAGING domains always use S1 and S2 is only
>   used for nested domains with a valid KVM. The idea is to make sure
>   when BTM is enabled in Guest, we use KVM VMID for S2.
> 
> Not sure I miss any explicit TLB invalidations with any use case
> that may configure a S2 with a private VMID that matches a KVM
> one.
> 
> This is based on Jason's ongoing SMMUv3 refactor series[2].
> 
> Please take a look and let me know.
> 
> Thanks,
> Shameer
> 
> 1. https://lore.kernel.org/linux-arm-kernel/20210222155338.26132-1-shameerali.kolothum.thodi@huawei.com/
> 2. https://lore.kernel.org/linux-arm-kernel/0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com/
> 
> Jean-Philippe Brucker (1):
>   iommu/arm-smmu-v3: Enable broadcast TLB maintenance
> 
> Shameer Kolothum (6):
>   KVM: Add generic infrastructure to support pinned VMIDs
>   KVM: arm64: Introduce support to pin VMIDs
>   KVM: arm64: Add interfaces for pinned VMID support
>   iommufd: Associate kvm pointer to iommufd ctx
>   iommu: Pass in kvm pointer to domain_alloc_user
>   iommu/arm-smmu-v3: Use KVM VMID for s2 stage
> 
>  arch/arm64/include/asm/kvm_host.h           |  3 +
>  arch/arm64/kvm/Kconfig                      |  1 +
>  arch/arm64/kvm/arm.c                        | 14 ++++
>  arch/arm64/kvm/vmid.c                       | 84 ++++++++++++++++++++-
>  drivers/iommu/amd/iommu.c                   |  1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 42 +++++++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +
>  drivers/iommu/intel/iommu.c                 |  1 +
>  drivers/iommu/iommufd/hw_pagetable.c        |  5 +-
>  drivers/iommu/iommufd/iommufd_private.h     |  3 +
>  drivers/iommu/iommufd/main.c                | 14 ++++
>  drivers/iommu/iommufd/selftest.c            |  1 +
>  drivers/vfio/device_cdev.c                  |  3 +
>  include/linux/iommu.h                       |  3 +-
>  include/linux/iommufd.h                     |  7 ++
>  include/linux/kvm_host.h                    | 18 +++++
>  virt/kvm/Kconfig                            |  3 +
>  virt/kvm/kvm_main.c                         | 23 ++++++
>  18 files changed, 218 insertions(+), 11 deletions(-)
> 
> -- 
> 2.34.1
> 
