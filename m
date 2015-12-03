From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v2 0/3] Introduce MSI hardware mapping for VFIO
Date: Thu, 03 Dec 2015 16:16:54 +0300
Message-ID: <00eb01d12dcc$e20df980$a629ec80$@samsung.com>
References: <cover.1448372839.git.p.fedin@samsung.com>
 <1449091979.15753.134.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1449091979.15753.134.camel@redhat.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Alex Williamson' <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Thomas Gleixner' <tglx@linutronix.de>, 'Jason Cooper' <jason@lakedaemon.net>, 'Manish Jaggi' <mjaggi@caviumnetworks.com>, 'Pranavkumar Sawargaonkar' <pranavkumar@linaro.org>, 'Bharat Bhushan' <Bharat.Bhushan@freescale.com>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I like that you're making this transparent
> for the user, but at the same time, directly calling function pointers
> through the msi_domain_ops is quite ugly.

 Do you mean dereferencing info->ops->vfio_map() in .c code? I can introduce some wrappers in include/linux/msi.h like msi_domain_vfio_map()/msi_domain_vfio_unmap(), this would not conceptually change anything.

>  There needs to be a real, interface there that isn't specific to vfio.

 Hm... What else is going to use this?
 Actually, in my implementation the only thing specific to vfio is using struct vfio_iommu_driver_ops. This is because we have to perform MSI mapping for all "vfio domains" registered for this container. At least this is how original type1 driver works.
 Can anybody explain me, what these "vfio domains" are? From the code it looks like we can have several IOMMU instances belonging to one VFIO container, and in this case one IOMMU == one "vfio domain". So is my understanding correct that "vfio domain" is IOMMU instance?
 And here come completely different ideas...
 First of all, can anybody explain, why do i perform all mappings on per-IOMMU basis, not on per-device basis? AFAIK at least ARM SMMU knows about "stream IDs", and therefore it should be capable of distinguishing between different devices. So can i have per-device mapping? This would make things much simpler.
 So:
 Idea 1: do per-device mappings. In this case i don't have to track down which devices belong to which group and which IOMMU...
 Idea 2: What if we indeed simply simulate x86 behavior? What if we just do 1:1 mapping for MSI register when IOMMU is initialized and forget about it, so that MSI messages are guaranteed to reach the host? Or would this mean that we would have to do 1:1 mapping for the whole address range? Looks like (1) tried to do something similar, with address reservation.
 Idea 3: Is single device guaranteed to correspond to a single "vfio domain" (and, as a consequence, to a single IOMMU)? In this case it's very easy to unlink interface introduced by 0002 of my series from vfio, and pass just raw struct iommu_domain * without any driver_ops? irqchip code would only need iommu_map() and iommu_unmap() then, no calling back to vfio layer.

Cc'ed to authors of all mentioned series

> [1] http://www.spinics.net/lists/kvm/msg121669.html,
> http://www.spinics.net/lists/kvm/msg121662.html
> [2] http://www.spinics.net/lists/kvm/msg119236.html

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


