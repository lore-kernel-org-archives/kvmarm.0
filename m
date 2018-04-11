From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: Re: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Wed, 11 Apr 2018 19:35:35 +0100
Message-ID: <032b1e7c-be0b-6237-96c0-0ef49eb90c05@arm.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
 <20180214145340.1223-2-jean-philippe.brucker@arm.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19108B0FE@SHSMSX101.ccr.corp.intel.com>
 <a11f1b52-c031-014c-8c23-1732f3d4666c@arm.com>
 <739fbfdf-1651-8036-367a-52940b93dee6@arm.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19108DC42@SHSMSX101.ccr.corp.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D191090157@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <virtio-dev-return-3823-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D191090157@SHSMSX101.ccr.corp.intel.com>
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, Robin Murphy <Robin.Murphy@arm.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "jayachandran.nair@cavium.com" <jayachandran.nair@cavium.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "mst@redhat.com" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, "jasowang@redhat.com" <jasowang@redhat.com>, Will Deacon <Will.Deacon@arm.com>, "jintack@cs.columbia.edu" <jintack@cs.columbia.edu>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 23/03/18 08:27, Tian, Kevin wrote:
>>> The host kernel needs to have *some* MSI region in place before the
>>> guest can start configuring interrupts, otherwise it won't know what
>>> address to give to the underlying hardware. However, as soon as the host
>>> kernel has picked a region, host userspace needs to know that it can no
>>> longer use addresses in that region for DMA-able guest memory. It's a
>>> lot easier when the address is fixed in hardware and the host userspace
>>> will never be stupid enough to try and VFIO_IOMMU_DMA_MAP it, but in
>>> the
>>> more general case where MSI writes undergo IOMMU address translation
>>> so
>>> it's an arbitrary IOVA, this has the potential to conflict with stuff
>>> like guest memory hotplug.
>>>
>>> What we currently have is just the simplest option, with the host kernel
>>> just picking something up-front and pretending to host userspace that
>>> it's a fixed hardware address. There's certainly scope for it to be a
>>> bit more dynamic in the sense of adding an interface to let userspace
>>> move it around (before attaching any devices, at least), but I don't
>>> think it's feasible for the host kernel to second-guess userspace enough
>>> to make it entirely transparent like it is in the DMA API domain case.
>>>
>>> Of course, that's all assuming the host itself is using a virtio-iommu
>>> (e.g. in a nested virt or emulation scenario). When it's purely within a
>>> guest then an MSI reservation shouldn't matter so much, since the guest
>>> won't be anywhere near the real hardware configuration anyway.
>>>
>>> Robin.
>>
>> Curious since anyway we are defining a new iommu architecture
>> is it possible to avoid those ARM-specific burden completely?
>>
> 
> OK, after some study around those tricks below is my learning:
> 
> - MSI_IOVA window is used only on request (iommu_dma_get
> _msi_page), not meant to take effect on all architectures once 
> initialized. e.g. ARM GIC does it but not x86. So it is reasonable 
> for virtio-iommu driver to implement such capability;
> 
> - I thought whether hardware MSI doorbell can be always reported
> on virtio-iommu since it's newly defined. Looks there is a problem
> if underlying IOMMU is sw-managed MSI style - valid mapping is
> expected in all level of translations, meaning guest has to manage
> stage-1 mapping in nested configuration since stage-1 is owned
> by guest. 
> 
> Then virtio-iommu is naturally expected to report the same MSI 
> model as supported by underlying hardware. Below are some
> further thoughts along this route (use 'IOMMU' to represent the
> physical one and 'virtio-iommu' for virtual one):
> 
> ----
> 
> In the scope of current virtio-iommu spec v.6, there is no nested
> consideration yet. Guest driver is expected to use MAP/UNMAP
> interface on assigned endpoints. In this case the MAP requests
> (IOVA->GPA) is caught and maintained within Qemu which then 
> further talks to VFIO to map IOVA->HPA in IOMMU.
> 
> Qemu can learn the MSI model of IOMMU from sysfs.
> 
> For hardware MSI doorbell (x86 and some ARM):
> * Host kernel reports to Qemu as IOMMU_RESV_MSI
> * Qemu report to guest as VIRTIO_IOMMU_RESV_MEM_T_MSI
> * Guest takes the range as IOMMU_RESV_MSI. reserved
> * Qemu MAP database has no mapping for the doorbell
> * Physical IOMMU page table has no mapping for the doorbell
> * MSI from passthrough device bypass IOMMU
> * MSI from emulated device bypass virtio-iommu
> 
> For software MSI doorbell (most ARM):
> * Host kernel reports to Qemu as IOMMU_RESV_SW_MSI
> * Qemu report to guest as VIRTIO_IOMMU_RESV_MEM_T_RESERVED
> * Guest takes the range as IOMMU_RESV_RESERVED
> * vGIC requests to map 'GPA of the virtual doorbell'
> * a map request (IOVA->GPA) sent on endpoint
> * Qemu maintains the mapping in MAP database
> 	* but no VFIO_MAP request since it's purely virtual
> * GIC requests to map 'HPA of the physical doorbell'
> 	* e.g. triggered by VFIO enable msi
> * IOMMU now includes a valid mapping (IOVA->HPA)
> * MSI from emulated device go through Qemu MAP
> database (IOVA->'GPA of virtual doorbell') and then hit vGIC
> * MSI from passthrough device go through IOMMU
> (IOVA->'HPA of physical doorbell') and then hit GIC
> 
> In this case, host doorbell is treated as reserved resource in
> guest side. Guest has its own sw-management for virtual
> doorbell which is only used for emulated device. two paths 
> are completely separated.
> 
> If above captures the right flow, current v0.6 spec is complete
> regarding to required function definition.

Yes I think this summarizes well the current state or SW/HW MSI

> Then comes nested case, with two level page tables (stage-1
> and stage-2) in IOMMU. stage-1 is for IOVA->GPA and stage-2
> is for GPA->HPA. VFIO map/unmap happens on stage-2, 
> while stage-1 is directly managed by guest (and bound to
> IOMMU which enables nested translation from IOVA->GPA
> ->HPA).
> 
> For hardware MSI, there is nothing special compared to
> previous requirement. Both host/guest treat the doorbell
> as reserved and guarantee no mapping in either stage-1 or 
> stage-2. 
> 
> For software MSI, more consideration is required:
> 
> * for emulated device it is just fine as long as guest keeps
> IOVA->'GPA of virtual doorbell' in stage-1. Qemu is expected
> to walk stage-1 page table upon MSI request from emulated
> device to hit vGIC;
> 
> * for passthrough device however there is a problem. We
> need valid mapping in both stage-1 and stage-2, while host
> kernel is only responsible for stage-2:
> 
> 	1) if we expect to keep same isolation policy (i.e.
> host MSI fully managed by host kernel), then an identity
> mapping for host-reported MSI range is expected in stage-1.
> In such case we need a new type VIRTIO_IOMMU_RESV_
> MEM_T_DIRECT to teach guest setup identity mapping.
> it should be the right thing to add since anyway there might
> be true IOMMU_RESV_DIRECT range reported from host
> which also should be handled.
> 
> 	2) Alternatively we could instead allow Qemu to
> request dynamic change of physical doorbell mapping in 
> stage2, e.g. from GPA of virtual doorbell to HPA of physical 
> doorbell. But it doesn't like a good design - VFIO doesn't
> assign interrupt controller to user space then why should 
> VFIO allow user mapping to doorbell...
> 
> if 1) is agreed, looks the missing part in spec is just VIRTIO_
> IOMMU_RESV_MEM_T_DIRECT, though the whole story 
> is lengthy and fully enabling nested require many other
> works. :-)

This is a great write-up, thanks. As said on the v0.6 thread [1], I also
prefer 1), because it doesn't require any additional interface in the
host kernel, and it doesn't force host userspace to guess which doorbell
address the guest is writing into the MSI-X table.

Thanks,
Jean

[1] https://www.mail-archive.com/virtualization@lists.linux-foundation.org/msg30104.html
