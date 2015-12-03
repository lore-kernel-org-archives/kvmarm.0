From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
Date: Thu, 03 Dec 2015 10:05:52 -0700
Message-ID: <1449162352.15753.192.camel@redhat.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
	 <1449091979.15753.134.camel@redhat.com>
	 <00eb01d12dcc$e20df980$a629ec80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00eb01d12dcc$e20df980$a629ec80$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Thomas Gleixner' <tglx@linutronix.de>, 'Jason Cooper' <jason@lakedaemon.net>, 'Manish Jaggi' <mjaggi@caviumnetworks.com>, 'Pranavkumar Sawargaonkar' <pranavkumar@linaro.org>, 'Bharat Bhushan' <Bharat.Bhushan@freescale.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-12-03 at 16:16 +0300, Pavel Fedin wrote:
>  Hello!
> 
> > I like that you're making this transparent
> > for the user, but at the same time, directly calling function pointers
> > through the msi_domain_ops is quite ugly.
> 
>  Do you mean dereferencing info->ops->vfio_map() in .c code? I can
> introduce some wrappers in include/linux/msi.h like
> msi_domain_vfio_map()/msi_domain_vfio_unmap(), this would not
> conceptually change anything.

But otherwise we're parsing data structures that are possibly intended
to be private.  An interface also abstracts the implementation from the
caller.

> >  There needs to be a real, interface there that isn't specific to
> vfio.
> 
>  Hm... What else is going to use this?

I don't know, but pushing vfio specific data structures and concepts
into core kernel callbacks is clearly the wrong direction to go.

>  Actually, in my implementation the only thing specific to vfio is
> using struct vfio_iommu_driver_ops. This is because we have to perform
> MSI mapping for all "vfio domains" registered for this container. At
> least this is how original type1 driver works.
>  Can anybody explain me, what these "vfio domains" are? From the code
> it looks like we can have several IOMMU instances belonging to one
> VFIO container, and in this case one IOMMU == one "vfio domain". So is
> my understanding correct that "vfio domain" is IOMMU instance?

There's no such thing as a vfio domain, I think you mean iommu domains.
A vfio container represents a user iommu context.  All of the groups
(and thus devices) within a container have the same iommu mappings.
However, not all of the groups are necessarily behind iommu hardware
units that support the same set of features.  We might therefore need to
mirror the user iommu context for the container across multiple physical
iommu contexts (aka domains).  When we walk the iommu->domain_list,
we're mirroring mappings across these multiple iommu domains within the
container.

>  And here come completely different ideas...
>  First of all, can anybody explain, why do i perform all mappings on
> per-IOMMU basis, not on per-device basis? AFAIK at least ARM SMMU
> knows about "stream IDs", and therefore it should be capable of
> distinguishing between different devices. So can i have per-device
> mapping? This would make things much simpler.

vfio is built on iommu groups with the premise being that an iommu group
represents the smallest set of devices that are isolated from all other
devices both by iommu visibility and by DMA isolation (peer-to-peer).
Therefore we base iommu mappings on an iommu group because we cannot
enforce userspace isolation at a sub-group level.  In a system or
topology that is well architected for device isolation, there will be a
one-to-one mapping of iommu groups to devices.

So, iommu mappings are always on a per-group basis, but the user may
attach multiple groups to a single container, which as discussed above
represents a single iommu context.  That single context may be backed by
one or more iommu domains, depending on the capabilities of the iommu
hardware.  You're therefore not performing all mappings on a per-iommu
basis unless you have a user defined container spanning multiple iommus
which are incompatible in a way that requires us to manage them with
separate iommu domains.

The iommu's ability to do per device mappings here is irrelevant.
You're working within a user defined IOMMU context where they have
decided that all of the devices should have the same context.

>  So:
>  Idea 1: do per-device mappings. In this case i don't have to track
> down which devices belong to which group and which IOMMU...

Nak, that doesn't solve anything.

>  Idea 2: What if we indeed simply simulate x86 behavior? What if we
> just do 1:1 mapping for MSI register when IOMMU is initialized and
> forget about it, so that MSI messages are guaranteed to reach the
> host? Or would this mean that we would have to do 1:1 mapping for the
> whole address range? Looks like (1) tried to do something similar,
> with address reservation.

x86 isn't problem-free in this space.  An x86 VM is going to know that
the 0xfee00000 address range is special, it won't be backed by RAM and
won't be a DMA target, thus we'll never attempt to map it for an iova
address.  However, if we run a non-x86 VM or a userspace driver, it
doesn't necessarily know that there's anything special about that range
of iovas.  I intend to resolve this with an extension to the iommu info
ioctl that describes the available iova space for the iommu.  The
interrupt region would simply be excluded.

This may be an option for you too, but you need to consider whether it
precludes things like hotplug.  Even in the x86 case, if we have a
non-x86 VM and we try to hot-add a PCI device, we can't dynamically
remove the RAM that would interfere with with the MSI vector block.  I
don't know what that looks like on your platform, whether you can pick a
fixed range for the VM and use it regardless of the devices attached
later.

>  Idea 3: Is single device guaranteed to correspond to a single "vfio
> domain" (and, as a consequence, to a single IOMMU)? In this case it's
> very easy to unlink interface introduced by 0002 of my series from
> vfio, and pass just raw struct iommu_domain * without any driver_ops?
> irqchip code would only need iommu_map() and iommu_unmap() then, no
> calling back to vfio layer.

Again, the context is per contain.  It would certainly be more correct
to setup the mapping for each iommu domain than to introduce any vfio
related concepts down at the MSI mapping level, but you're still
imposing a mapping into the user's iommu context.  That needs to be
dealt with.  Thanks,

Alex

