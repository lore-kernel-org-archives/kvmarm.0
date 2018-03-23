From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/4] iommu: Add virtio-iommu driver
Date: Fri, 23 Mar 2018 08:27:10 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D191090157@SHSMSX101.ccr.corp.intel.com>
References: <20180214145340.1223-1-jean-philippe.brucker@arm.com>
	<20180214145340.1223-2-jean-philippe.brucker@arm.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D19108B0FE@SHSMSX101.ccr.corp.intel.com>
	<a11f1b52-c031-014c-8c23-1732f3d4666c@arm.com>
	<739fbfdf-1651-8036-367a-52940b93dee6@arm.com>
	<AADFC41AFE54684AB9EE6CBC0274A5D19108DC42@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19108DC42-0J0gbvR4kThpB2pF5aRoyrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: 'Robin Murphy' <robin.murphy-5wv7dgnIgG8@public.gmane.org>, Jean-Philippe Brucker <jean-philippe.brucker-5wv7dgnIgG8@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org" <virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org>, "kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org" <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>
Cc: "jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <jayachandran.nair-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org" <tnowicki-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Marc Zyngier <Marc.Zyngier-5wv7dgnIgG8@public.gmane.org>, "jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org" <jintack-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, "eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.auger.pro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: kvmarm@lists.cs.columbia.edu

> From: Tian, Kevin
> Sent: Thursday, March 22, 2018 6:06 PM
> 
> > From: Robin Murphy [mailto:robin.murphy-5wv7dgnIgG8@public.gmane.org]
> > Sent: Wednesday, March 21, 2018 10:24 PM
> >
> > On 21/03/18 13:14, Jean-Philippe Brucker wrote:
> > > On 21/03/18 06:43, Tian, Kevin wrote:
> > > [...]
> > >>> +
> > >>> +#include <uapi/linux/virtio_iommu.h>
> > >>> +
> > >>> +#define MSI_IOVA_BASE			0x8000000
> > >>> +#define MSI_IOVA_LENGTH			0x100000
> > >>
> > >> this is ARM specific, and according to virtio-iommu spec isn't it
> > >> better probed on the endpoint instead of hard-coding here?
> > >
> > > These values are arbitrary, not really ARM-specific even if ARM is the
> > > only user yet: we're just reserving a random IOVA region for mapping
> > MSIs.
> > > It is hard-coded because of the way iommu-dma.c works, but I don't
> > quite
> > > remember why that allocation isn't dynamic.
> >
> > The host kernel needs to have *some* MSI region in place before the
> > guest can start configuring interrupts, otherwise it won't know what
> > address to give to the underlying hardware. However, as soon as the host
> > kernel has picked a region, host userspace needs to know that it can no
> > longer use addresses in that region for DMA-able guest memory. It's a
> > lot easier when the address is fixed in hardware and the host userspace
> > will never be stupid enough to try and VFIO_IOMMU_DMA_MAP it, but in
> > the
> > more general case where MSI writes undergo IOMMU address translation
> > so
> > it's an arbitrary IOVA, this has the potential to conflict with stuff
> > like guest memory hotplug.
> >
> > What we currently have is just the simplest option, with the host kernel
> > just picking something up-front and pretending to host userspace that
> > it's a fixed hardware address. There's certainly scope for it to be a
> > bit more dynamic in the sense of adding an interface to let userspace
> > move it around (before attaching any devices, at least), but I don't
> > think it's feasible for the host kernel to second-guess userspace enough
> > to make it entirely transparent like it is in the DMA API domain case.
> >
> > Of course, that's all assuming the host itself is using a virtio-iommu
> > (e.g. in a nested virt or emulation scenario). When it's purely within a
> > guest then an MSI reservation shouldn't matter so much, since the guest
> > won't be anywhere near the real hardware configuration anyway.
> >
> > Robin.
> 
> Curious since anyway we are defining a new iommu architecture
> is it possible to avoid those ARM-specific burden completely?
> 

OK, after some study around those tricks below is my learning:

- MSI_IOVA window is used only on request (iommu_dma_get
_msi_page), not meant to take effect on all architectures once 
initialized. e.g. ARM GIC does it but not x86. So it is reasonable 
for virtio-iommu driver to implement such capability;

- I thought whether hardware MSI doorbell can be always reported
on virtio-iommu since it's newly defined. Looks there is a problem
if underlying IOMMU is sw-managed MSI style - valid mapping is
expected in all level of translations, meaning guest has to manage
stage-1 mapping in nested configuration since stage-1 is owned
by guest. 

Then virtio-iommu is naturally expected to report the same MSI 
model as supported by underlying hardware. Below are some
further thoughts along this route (use 'IOMMU' to represent the
physical one and 'virtio-iommu' for virtual one):

----

In the scope of current virtio-iommu spec v.6, there is no nested
consideration yet. Guest driver is expected to use MAP/UNMAP
interface on assigned endpoints. In this case the MAP requests
(IOVA->GPA) is caught and maintained within Qemu which then 
further talks to VFIO to map IOVA->HPA in IOMMU.

Qemu can learn the MSI model of IOMMU from sysfs.

For hardware MSI doorbell (x86 and some ARM):
* Host kernel reports to Qemu as IOMMU_RESV_MSI
* Qemu report to guest as VIRTIO_IOMMU_RESV_MEM_T_MSI
* Guest takes the range as IOMMU_RESV_MSI. reserved
* Qemu MAP database has no mapping for the doorbell
* Physical IOMMU page table has no mapping for the doorbell
* MSI from passthrough device bypass IOMMU
* MSI from emulated device bypass virtio-iommu

For software MSI doorbell (most ARM):
* Host kernel reports to Qemu as IOMMU_RESV_SW_MSI
* Qemu report to guest as VIRTIO_IOMMU_RESV_MEM_T_RESERVED
* Guest takes the range as IOMMU_RESV_RESERVED
* vGIC requests to map 'GPA of the virtual doorbell'
* a map request (IOVA->GPA) sent on endpoint
* Qemu maintains the mapping in MAP database
	* but no VFIO_MAP request since it's purely virtual
* GIC requests to map 'HPA of the physical doorbell'
	* e.g. triggered by VFIO enable msi
* IOMMU now includes a valid mapping (IOVA->HPA)
* MSI from emulated device go through Qemu MAP
database (IOVA->'GPA of virtual doorbell') and then hit vGIC
* MSI from passthrough device go through IOMMU
(IOVA->'HPA of physical doorbell') and then hit GIC

In this case, host doorbell is treated as reserved resource in
guest side. Guest has its own sw-management for virtual
doorbell which is only used for emulated device. two paths 
are completely separated.

If above captures the right flow, current v0.6 spec is complete
regarding to required function definition.

----

Then comes nested case, with two level page tables (stage-1
and stage-2) in IOMMU. stage-1 is for IOVA->GPA and stage-2
is for GPA->HPA. VFIO map/unmap happens on stage-2, 
while stage-1 is directly managed by guest (and bound to
IOMMU which enables nested translation from IOVA->GPA
->HPA).

For hardware MSI, there is nothing special compared to
previous requirement. Both host/guest treat the doorbell
as reserved and guarantee no mapping in either stage-1 or 
stage-2. 

For software MSI, more consideration is required:

* for emulated device it is just fine as long as guest keeps
IOVA->'GPA of virtual doorbell' in stage-1. Qemu is expected
to walk stage-1 page table upon MSI request from emulated
device to hit vGIC;

* for passthrough device however there is a problem. We
need valid mapping in both stage-1 and stage-2, while host
kernel is only responsible for stage-2:

	1) if we expect to keep same isolation policy (i.e.
host MSI fully managed by host kernel), then an identity
mapping for host-reported MSI range is expected in stage-1.
In such case we need a new type VIRTIO_IOMMU_RESV_
MEM_T_DIRECT to teach guest setup identity mapping.
it should be the right thing to add since anyway there might
be true IOMMU_RESV_DIRECT range reported from host
which also should be handled.

	2) Alternatively we could instead allow Qemu to
request dynamic change of physical doorbell mapping in 
stage2, e.g. from GPA of virtual doorbell to HPA of physical 
doorbell. But it doesn't like a good design - VFIO doesn't
assign interrupt controller to user space then why should 
VFIO allow user mapping to doorbell...

if 1) is agreed, looks the missing part in spec is just VIRTIO_
IOMMU_RESV_MEM_T_DIRECT, though the whole story 
is lengthy and fully enabling nested require many other
works. :-)

Thanks
Kevin
