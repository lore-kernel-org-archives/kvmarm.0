From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 3/9] KVM: arm/arm64: Don't cache the timer IRQ level
Date: Tue, 19 Dec 2017 21:35:20 +0100
Message-ID: <20171219203520.GD5380@cbox>
References: <20171213104602.16383-1-christoffer.dall@linaro.org>
 <20171213104602.16383-4-christoffer.dall@linaro.org>
 <517ead96-a689-d6f6-564f-67b1cd020daf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <517ead96-a689-d6f6-564f-67b1cd020daf@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 19, 2017 at 02:17:38PM +0000, Julien Thierry wrote:
> Hi Christoffer,
> 
> A few nits in the commit message.
> 
> On 13/12/17 10:45, Christoffer Dall wrote:
> >The timer was modeled after a strict idea of modelling an interrupt line
> 
> nit: modelling (also, modeled after a strict idea of modelling?)
> 

Yes, I model the modelling of models of modeled timers.  Is that not
clear?  ;)

> >level in software, meaning that only transitions in the level needed to
> 
> s/needed/need/ ?
> 

ack

> >be reported to the VGIC.  This works well for the timer, because the
> >arch timer code is in complete control of the device and can track the
> >transitions of the line.
> >
> >However, as we are about to support using the HW bit in the VGIC not
> >just for the timer, but also for VFIO which cannot track transitions of
> >the interrupt line, we have to decide on an interface for level
> >triggered mapped interrupts to the GIC, which both the timer and VFIO
> 
> "level triggered interrupts mapped to the GIC" ?
> 

an interface to the GIC for level ...

My writing here is really crap.  Thanks for pointing that out.

> >can use.
> >
> >VFIO only sees an asserting transition of the physical interrupt line,
> >and tells the VGIC when that happens.  That means that part of the
> >interrupt flow is offloaded to the hardware.
> >
> >To use the same interface for VFIO devices and the timer, we therefore
> >have to change the timer (we cannot change VFIO because it doesn't know
> >the details of the device it is assigning to a VM).
> >
> >Luckily, changing the timer is simple, we just need to stop 'caching'
> >the line level, but instead let the VGIC know the state of the timer
> >every time there is a potential change in the line level, and when the
> >line level should be asserted from the timer ISR.  The VGIC can ignore
> >extra notifications using its validate mechanism.
> >
> >Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> >Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> 

Thanks,
-Christoffer
