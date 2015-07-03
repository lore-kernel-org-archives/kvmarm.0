From: "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Fri, 3 Jul 2015 02:24:04 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0025E6C38@SHSMSX104.ccr.corp.intel.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
 <55953F5F.9090203@redhat.com>
 <E959C4978C3B6342920538CF579893F0025E6C23@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <E959C4978C3B6342920538CF579893F0025E6C23@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "Wu, Feng" <feng.wu@intel.com>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Wu, Feng
> Sent: Friday, July 03, 2015 10:20 AM
> To: Paolo Bonzini; Eric Auger; eric.auger@st.com;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; christoffer.dall@linaro.org; marc.zyngier@arm.com;
> alex.williamson@redhat.com; avi.kivity@gmail.com; mtosatti@redhat.com;
> joro@8bytes.org; b.reynal@virtualopensystems.com
> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; Wu, Feng
> Subject: RE: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
> control
> 
> 
> 
> > -----Original Message-----
> > From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> > Sent: Thursday, July 02, 2015 9:41 PM
> > To: Eric Auger; eric.auger@st.com; linux-arm-kernel@lists.infradead.org;
> > kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> > christoffer.dall@linaro.org; marc.zyngier@arm.com;
> > alex.williamson@redhat.com; avi.kivity@gmail.com; mtosatti@redhat.com;
> > Wu, Feng; joro@8bytes.org; b.reynal@virtualopensystems.com
> > Cc: linux-kernel@vger.kernel.org; patches@linaro.org
> > Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
> > control
> >
> >
> >
> > On 02/07/2015 15:17, Eric Auger wrote:
> > > - new fields are added on producer side: linux irq, vfio_device handle,
> > >   active which reflects whether the source is active (at interrupt
> > >   controller level or at VFIO level - automasked -) and finally an
> > >   opaque pointer which will be used to point to the vfio_platform_device
> > >   in this series.
> >
> > Linux IRQ and active should be okay.  As to the vfio_device handle, you
> > should link it from the vfio_platform_device instead.  And for the
> > vfio_platform_device, you can link it from the vfio_platform_irq instead.
> >
> > Once you've done this, embed the irq_bypass_producer struct in the
> > vfio_platform_irq struct; in the new kvm_arch_* functions, go back to
> > the vfio_platform_irq struct via container_of.  From there you can
> > retrieve pointers to the vfio_platform_device and the vfio_device.
> >
> > > - new fields on consumer side: the kvm handle, the gsi
> >
> > You do not need to add these.  Instead, add the kvm handle to irqfd
> > only.  Like above, embed the irq_bypass_consumer struct in the irqfd
> > struct; in the new kvm_arch_* functions, go back to the
> > vfio_platform_irq struct via container_of.
> >
> 
> I also need the gsi field here, for posted-interrupts, I need 'gsi', 'irq' to
> update the IRTE.

Oh... we can get gsi from irq_bypass_consumer -> _irqfd -> gsi, so it
is not needed in irq_bypass_consumer. Got it! :)

Thanks,
Feng

> 
> Thanks,
> Feng
> 
> 
> > Paolo
