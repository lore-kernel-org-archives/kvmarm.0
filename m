From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [RFC PATCH v2 2/5] iommu/virtio-iommu: Add probe request
Date: Fri, 19 Jan 2018 16:21:52 +0000
Message-ID: <b9ede9e9-25a6-2848-e152-ffc61d560be8@arm.com>
References: <20171117185211.32593-1-jean-philippe.brucker@arm.com>
 <20171117185211.32593-3-jean-philippe.brucker@arm.com>
 <5b236aaa-4abb-2cac-1c74-f8137a0c2244@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93EBE49E0C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 11:14:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vx6o9qIuJPce for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jan 2018 11:14:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A97149DC5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jan 2018 11:14:11 -0500 (EST)
In-Reply-To: <5b236aaa-4abb-2cac-1c74-f8137a0c2244@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "devel@acpica.org" <devel@acpica.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>
Cc: "Jayachandran.Nair@cavium.com" <Jayachandran.Nair@cavium.com>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, "ashok.raj@intel.com" <ashok.raj@intel.com>, "mst@redhat.com" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "robert.moore@intel.com" <robert.moore@intel.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, Sudeep Holla <Sudeep.Holla@arm.com>, "lenb@kernel.org" <lenb@kernel.org>, Robin Murphy <Robin.Murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>, "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 16/01/18 23:26, Auger Eric wrote:
[...]
>> +	switch (mem->subtype) {
>> +	case VIRTIO_IOMMU_RESV_MEM_T_MSI:
>> +		region = iommu_alloc_resv_region(addr, size, prot,
>> +						 IOMMU_RESV_MSI);
> if (!region)
> 	return -ENOMEM;
>> +		break;
>> +	case VIRTIO_IOMMU_RESV_MEM_T_RESERVED:
>> +	default:
>> +		region = iommu_alloc_resv_region(addr, size, 0,
>> +						 IOMMU_RESV_RESERVED);
> same.

I'll add them, thanks

> There is another issue related to the exclusion of iovas belonging to
> reserved regions. Typically on x86, when attempting to run
> virtio-blk-pci with iommu I eventually saw the driver using iova
> belonging to the IOAPIC regions to map phys addr and this stalled qemu
> with a drown trace:
> 
> "virtio: bogus descriptor or out of resources"
> 
> those regions need to be excluded from the iova allocator. This was
> resolved by adding
> if (iommu_dma_init_domain(domain,
> 			  vdev->viommu->geometry.aperture_start,
> 			  vdev->viommu->geometry.aperture_end,
> 			  dev))
> in viommu_attach_dev()

The most recent hack for x86 [1] does call iommu_dma_init_domain() in
attach_dev(). Is it buggy?

We probably shouldn't call iommu_dma_init_domain() unconditionally
(outside of CONFIG_X86 that is), since it's normally done by the arch
(arch/arm64/mm/dma-mapping.c)

Thanks,
Jean

[1]
http://www.linux-arm.org/git?p=linux-jpb.git;a=commitdiff;h=e910e224b58712151dda06df595a53ff07edef63
on branch virtio-iommu/v0.5-x86
