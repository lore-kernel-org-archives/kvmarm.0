From: "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Fri, 3 Jul 2015 02:19:46 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0025E6C23@SHSMSX104.ccr.corp.intel.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
 <55953F5F.9090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ECC2D57858
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 22:08:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AycI8UVlJlDH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jul 2015 22:08:36 -0400 (EDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB5B357857
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jul 2015 22:08:35 -0400 (EDT)
In-Reply-To: <55953F5F.9090203@redhat.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "Wu, Feng" <feng.wu@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Thursday, July 02, 2015 9:41 PM
> To: Eric Auger; eric.auger@st.com; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> christoffer.dall@linaro.org; marc.zyngier@arm.com;
> alex.williamson@redhat.com; avi.kivity@gmail.com; mtosatti@redhat.com;
> Wu, Feng; joro@8bytes.org; b.reynal@virtualopensystems.com
> Cc: linux-kernel@vger.kernel.org; patches@linaro.org
> Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
> control
> 
> 
> 
> On 02/07/2015 15:17, Eric Auger wrote:
> > - new fields are added on producer side: linux irq, vfio_device handle,
> >   active which reflects whether the source is active (at interrupt
> >   controller level or at VFIO level - automasked -) and finally an
> >   opaque pointer which will be used to point to the vfio_platform_device
> >   in this series.
> 
> Linux IRQ and active should be okay.  As to the vfio_device handle, you
> should link it from the vfio_platform_device instead.  And for the
> vfio_platform_device, you can link it from the vfio_platform_irq instead.
> 
> Once you've done this, embed the irq_bypass_producer struct in the
> vfio_platform_irq struct; in the new kvm_arch_* functions, go back to
> the vfio_platform_irq struct via container_of.  From there you can
> retrieve pointers to the vfio_platform_device and the vfio_device.
> 
> > - new fields on consumer side: the kvm handle, the gsi
> 
> You do not need to add these.  Instead, add the kvm handle to irqfd
> only.  Like above, embed the irq_bypass_consumer struct in the irqfd
> struct; in the new kvm_arch_* functions, go back to the
> vfio_platform_irq struct via container_of.
> 

I also need the gsi field here, for posted-interrupts, I need 'gsi', 'irq' to
update the IRTE.

Thanks,
Feng


> Paolo
