From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding control
Date: Fri, 03 Jul 2015 15:12:20 +0200
Message-ID: <55968A34.5010409@linaro.org>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org> <1435843047-6327-13-git-send-email-eric.auger@linaro.org> <55953F5F.9090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55953F5F.9090203@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Paolo,
On 07/02/2015 03:40 PM, Paolo Bonzini wrote:
> 
> 
> On 02/07/2015 15:17, Eric Auger wrote:
>> - new fields are added on producer side: linux irq, vfio_device handle,
>>   active which reflects whether the source is active (at interrupt
>>   controller level or at VFIO level - automasked -) and finally an
>>   opaque pointer which will be used to point to the vfio_platform_device
>>   in this series.
> 
> Linux IRQ and active should be okay.  As to the vfio_device handle, you
> should link it from the vfio_platform_device instead.  And for the
> vfio_platform_device, you can link it from the vfio_platform_irq instead.
For this last one, I don't think this is achievable since if I store the
vfio_platform_irq in the opaque, it matches irqs[i] of
vfio_platform_device and I don't have any mean to retrieve "i" when
calling container_of.


	struct vfio_platform_irq *irq =
		container_of(prod, struct vfio_platform_irq, producer);
	struct vfio_platform_device *vpdev =
		container_of(irq, struct vfio_platform_device,  irqs[i?]);


struct vfio_platform_device {
../..
        struct vfio_platform_irq        *irqs;
../..
}
So I think I still need to pass vfio_platform_device in the opaque and
look on irqs array to identify the right vfio_platform_irq *.

Do I miss sthg?

- Eric


> 
> Once you've done this, embed the irq_bypass_producer struct in the
> vfio_platform_irq struct; in the new kvm_arch_* functions, go back to
> the vfio_platform_irq struct via container_of.  From there you can
> retrieve pointers to the vfio_platform_device and the vfio_device.
> 
>> - new fields on consumer side: the kvm handle, the gsi
> 
> You do not need to add these.  Instead, add the kvm handle to irqfd
> only.  Like above, embed the irq_bypass_consumer struct in the irqfd
> struct; in the new kvm_arch_* functions, go back to the
> vfio_platform_irq struct via container_of.
> 
> Paolo
> 

