From: "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Fri, 3 Jul 2015 07:16:17 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0025E7167@SHSMSX104.ccr.corp.intel.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
 <E959C4978C3B6342920538CF579893F0025E6C89@SHSMSX104.ccr.corp.intel.com>
 <5596311A.3010703@redhat.com>
 <E959C4978C3B6342920538CF579893F0025E70BF@SHSMSX104.ccr.corp.intel.com>
 <55963469.9030805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55963469.9030805@redhat.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "Wu, Feng" <feng.wu@intel.com>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Friday, July 03, 2015 3:06 PM
> To: Wu, Feng; Eric Auger; eric.auger@st.com;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; christoffer.dall@linaro.org; marc.zyngier@arm.com;
> alex.williamson@redhat.com; avi.kivity@gmail.com; mtosatti@redhat.com;
> joro@8bytes.org; b.reynal@virtualopensystems.com
> Cc: linux-kernel@vger.kernel.org; patches@linaro.org
> Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
> control
> 
> 
> 
> On 03/07/2015 09:00, Wu, Feng wrote:
> >>> > > struct irq_bypass_consumer {
> >>> > >        struct list_head node;
> >>> > >        void *token;
> >>> > > +      unsigned irq;	/*got from producer when registered*/
> >>> > >        void (*add_producer)(struct irq_bypass_producer *,
> >>> > >                             struct irq_bypass_consumer *);
> >>> > >        void (*del_producer)(struct irq_bypass_producer *,
> >>> > >                             struct irq_bypass_consumer *);
> >>> > > +      void (*update)(struct irq_bypass_consumer *);
> >>> > > };
> >>> > >
> >>> > > 'update' is used to update the IRTE, while irq is initialized when
> >>> > > registered, which is used to find the right IRTE.
> >> >
> >> > Feel free to add "update" in your PI patches.  I am not sure if "irq"
> >> > belongs here or in the containing struct.  You can play with both and
> >> > submit the version that looks better to you.
> > Thanks for your review, Paolo. In my understanding, irq comes from
> > the producer side, while gsi belongs to the consumer, so we need
> > to get the irq from the producer somewhere. I am not sure adding
> > irq here is the good way, but what I need is in the 'update' function,
> > I have irq, gsi in hand. :)
> 
> It's difficult to say without seeing the patches...  The IRQ is stored
> in the producer already with Eric's changes.  If you need to store the
> old IRQ value, because "update" needs to do something with it, then I
> think "irq" belongs in the container struct.
> 
> Perhaps "update" needs to have a producer argument as well?

I also consider this method, basically, I will call 'update' in irqfd_update(),
but seems I need do extra things to get the producer structure (such as,
iterate the producer list to find the one with the same 'token') before
calling 'update' from consumer side. I am not sure it is worth doing
that way.

Thanks,
Feng

> 
> Paolo
