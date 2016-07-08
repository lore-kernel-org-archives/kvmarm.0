From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RFC v6 4/6] KVM: arm/arm64: enable irqchip routing
Date: Fri, 8 Jul 2016 22:55:43 +0200
Message-ID: <20160708205543.GC10741@potion>
References: <1467794875-5237-1-git-send-email-eric.auger@redhat.com>
 <1467794875-5237-5-git-send-email-eric.auger@redhat.com>
 <20160707172052.5weyrjus3i3mgzik@hawk.localdomain>
 <11b05e3b-f3fd-aae3-b1e7-6ca9836cfc97@redhat.com>
 <20160708085233.qjptxd4qh7ukbgl3@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160708085233.qjptxd4qh7ukbgl3@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>
Cc: Auger Eric <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

2016-07-08 10:52+0200, Andrew Jones:
> On Fri, Jul 08, 2016 at 10:16:53AM +0200, Auger Eric wrote:
>> On 07/07/2016 19:20, Andrew Jones wrote:
>> > On Wed, Jul 06, 2016 at 10:47:53AM +0200, Eric Auger wrote:
>> >> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
>> >> @@ -29,7 +29,9 @@
>> >>  #include <linux/srcu.h>
>> >>  #include <linux/export.h>
>> >>  #include <trace/events/kvm.h>
>> >> +#if !defined(CONFIG_ARM) && !defined(CONFIG_ARM64)
>> >>  #include "irq.h"
>> >> +#endif
>> > 
>> > Instead of doing this, shouldn't we add arch/arm[64]/kvm/irq.h files.
>> > Probably a simple one like ./arch/s390/kvm/irq.h ?
>> 
>> Well I considered this solution in the past but I did not find much to
>> put there (it was even void). typically irqchip_in_kernel is in
>> include/kvm/arm_vgic.h since the macro can be shared between arm/arm64.
> 
> I think I'd prefer a nearly empty file to the #ifdef's, but Paolo and
> Radim should chime in.

I concur, hiding ugliness in header files is what we strive for.

The files could #include <include/kvm/arm_vgic.h>, which might make
their existence easier to understand.
