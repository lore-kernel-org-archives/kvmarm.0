From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
Date: Thu, 3 Dec 2015 14:49:59 +0000
Message-ID: <20151203144959.4b14f195@arm.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
 <1449091979.15753.134.camel@redhat.com>
 <00eb01d12dcc$e20df980$a629ec80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D1C9499C3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 09:48:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PSiMxe9BDTWm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 09:48:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEABE49958
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 09:48:33 -0500 (EST)
In-Reply-To: <00eb01d12dcc$e20df980$a629ec80$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Jason Cooper' <jason@lakedaemon.net>, kvm@vger.kernel.org, 'Manish Jaggi' <mjaggi@caviumnetworks.com>, 'Alex Williamson' <alex.williamson@redhat.com>, 'Thomas Gleixner' <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 3 Dec 2015 16:16:54 +0300
Pavel Fedin <p.fedin@samsung.com> wrote:

Pavel,

>  Hello!
> 
> > I like that you're making this transparent
> > for the user, but at the same time, directly calling function pointers
> > through the msi_domain_ops is quite ugly.
> 
>  Do you mean dereferencing info->ops->vfio_map() in .c code? I can introduce some wrappers in include/linux/msi.h like msi_domain_vfio_map()/msi_domain_vfio_unmap(), this would not conceptually change anything.
> 
> >  There needs to be a real, interface there that isn't specific to vfio.
> 
>  Hm... What else is going to use this?
>  Actually, in my implementation the only thing specific to vfio is
> using struct vfio_iommu_driver_ops. This is because we have to
> perform MSI mapping for all "vfio domains" registered for this
> container. At least this is how original type1 driver works.

>  Can anybody explain me, what these "vfio domains" are? From the code
> it looks like we can have several IOMMU instances belonging to one
> VFIO container, and in this case one IOMMU == one "vfio domain". So
> is my understanding correct that "vfio domain" is IOMMU instance?

>  And here come completely different ideas...

>  First of all, can anybody explain, why do i perform all mappings on
> per-IOMMU basis, not on per-device basis? AFAIK at least ARM SMMU
> knows about "stream IDs", and therefore it should be capable of
> distinguishing between different devices. So can i have per-device
> mapping? This would make things much simpler.

Not exactly. You can have a a bunch of devices between a single
StreamID (making them completely indistinguishable). This is a system
integration decision.

>  So:
>  Idea 1: do per-device mappings. In this case i don't have to track
> down which devices belong to which group and which IOMMU...

As explained above, this doesn't work.

>  Idea 2: What if we indeed simply simulate x86 behavior? What if we
> just do 1:1 mapping for MSI register when IOMMU is initialized and
> forget about it, so that MSI messages are guaranteed to reach the
> host? Or would this mean that we would have to do 1:1 mapping for the
> whole address range? Looks like (1) tried to do something similar,
> with address reservation.

Neither. We want userspace to be in control of the memory map, and it
is the kernel's job to tell us whether or not this matches the HW
capabilities or not. A fixed mapping may completely clash with the
memory map I want (think emulating HW x on platform y), and there is no
reason why we should have the restrictions x86 has.

My understanding is that userspace should be in charge here, and maybe
obtain a range of acceptable IOVAs for the MSI doorbell to be mapped.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
