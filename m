From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Wed, 21 Mar 2018 14:23:38 +0000
Message-ID: <739fbfdf-1651-8036-367a-52940b93dee6@arm.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
	<20180214145340.1223-2-jean-philippe.brucker@arm.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D19108B0FE@SHSMSX101.ccr.corp.intel.com>
	<a11f1b52-c031-014c-8c23-1732f3d4666c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <a11f1b52-c031-014c-8c23-1732f3d4666c@arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>, "Tian, Kevin" <kevin.tian@intel.com>, "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: "jayachandran.nair@cavium.com" <jayachandran.nair@cavium.com>, "tnowicki@caviumnetworks.com" <tnowicki@caviumnetworks.com>, "mst@redhat.com" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>, "jintack@cs.columbia.edu" <jintack@cs.columbia.edu>, "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 21/03/18 13:14, Jean-Philippe Brucker wrote:
> On 21/03/18 06:43, Tian, Kevin wrote:
> [...]
>>> +
>>> +#include <uapi/linux/virtio_iommu.h>
>>> +
>>> +#define MSI_IOVA_BASE			0x8000000
>>> +#define MSI_IOVA_LENGTH			0x100000
>>
>> this is ARM specific, and according to virtio-iommu spec isn't it
>> better probed on the endpoint instead of hard-coding here?
> 
> These values are arbitrary, not really ARM-specific even if ARM is the
> only user yet: we're just reserving a random IOVA region for mapping MSIs.
> It is hard-coded because of the way iommu-dma.c works, but I don't quite
> remember why that allocation isn't dynamic.

The host kernel needs to have *some* MSI region in place before the 
guest can start configuring interrupts, otherwise it won't know what 
address to give to the underlying hardware. However, as soon as the host 
kernel has picked a region, host userspace needs to know that it can no 
longer use addresses in that region for DMA-able guest memory. It's a 
lot easier when the address is fixed in hardware and the host userspace 
will never be stupid enough to try and VFIO_IOMMU_DMA_MAP it, but in the 
more general case where MSI writes undergo IOMMU address translation so 
it's an arbitrary IOVA, this has the potential to conflict with stuff 
like guest memory hotplug.

What we currently have is just the simplest option, with the host kernel 
just picking something up-front and pretending to host userspace that 
it's a fixed hardware address. There's certainly scope for it to be a 
bit more dynamic in the sense of adding an interface to let userspace 
move it around (before attaching any devices, at least), but I don't 
think it's feasible for the host kernel to second-guess userspace enough 
to make it entirely transparent like it is in the DMA API domain case.

Of course, that's all assuming the host itself is using a virtio-iommu 
(e.g. in a nested virt or emulation scenario). When it's purely within a 
guest then an MSI reservation shouldn't matter so much, since the guest 
won't be anywhere near the real hardware configuration anyway.

Robin.

> As said on the v0.6 spec thread, I'm not sure allocating the IOVA range in
> the host is preferable. With nested translation the guest has to map it
> anyway, and I believe dealing with IOVA allocation should be left to the
> guest when possible.
> 
> Thanks,
> Jean
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
