From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding control
Date: Fri, 03 Jul 2015 19:23:45 +0200
Message-ID: <5596C521.1030005@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org> <1435843047-6327-13-git-send-email-eric.auger@linaro.org> <55953F5F.9090203@redhat.com> <55968A34.5010409@linaro.org> <5596C44F.8070903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5596C44F.8070903@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 07/03/2015 07:20 PM, Paolo Bonzini wrote:
> 
> 
> On 03/07/2015 15:12, Eric Auger wrote:
>>>> Linux IRQ and active should be okay.  As to the vfio_device handle, you
>>>> should link it from the vfio_platform_device instead.  And for the
>>>> vfio_platform_device, you can link it from the vfio_platform_irq instead.
>> For this last one, I don't think this is achievable since if I store the
>> vfio_platform_irq in the opaque, it matches irqs[i] of
>> vfio_platform_device and I don't have any mean to retrieve "i" when
>> calling container_of.
> 
> Right, notice I said "link it":
> 
> 	struct vfio_platform_irq *irq =
> 		container_of(prod, struct vfio_platform_irq, producer);
> 	struct vfio_platform_device *vpdev = irq->vpdev;
> 	struct vfio_device *vdev = vpdev->vdev;
> 
> Would this be okay?

Yes that's what I did. I added the vfio_device handle in struct
vfio_platform_irq

Thanks ;-)

Have a nice WE

Eric
> 
> Paolo
> 
