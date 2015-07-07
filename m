From: "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Tue, 7 Jul 2015 11:33:32 +0000
Message-ID: <E959C4978C3B6342920538CF579893F0025F3645@SHSMSX104.ccr.corp.intel.com>
References: <1436184692-20927-1-git-send-email-eric.auger@linaro.org>
 <1436184692-20927-4-git-send-email-eric.auger@linaro.org>
 <E959C4978C3B6342920538CF579893F0025F342B@SHSMSX104.ccr.corp.intel.com>
 <559BB167.1030603@redhat.com>
 <E959C4978C3B6342920538CF579893F0025F34FC@SHSMSX104.ccr.corp.intel.com>
 <559BB463.6090406@redhat.com>
 <E959C4978C3B6342920538CF579893F0025F3568@SHSMSX104.ccr.corp.intel.com>
 <559BB642.5010701@redhat.com>
 <E959C4978C3B6342920538CF579893F0025F35E1@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <E959C4978C3B6342920538CF579893F0025F35E1@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "Wu, Feng" <feng.wu@intel.com>
List-Id: kvmarm@lists.cs.columbia.edu



> -----Original Message-----
> From: Wu, Feng
> Sent: Tuesday, July 07, 2015 7:24 PM
> To: Paolo Bonzini; Eric Auger; eric.auger@st.com;
> linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; christoffer.dall@linaro.org; marc.zyngier@arm.com;
> alex.williamson@redhat.com; avi.kivity@gmail.com; mtosatti@redhat.com;
> joro@8bytes.org; b.reynal@virtualopensystems.com
> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; Wu, Feng
> Subject: RE: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
> control
> 
> 
> 
> > -----Original Message-----
> > From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> > Sent: Tuesday, July 07, 2015 7:22 PM
> > To: Wu, Feng; Eric Auger; eric.auger@st.com;
> > linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> > kvm@vger.kernel.org; christoffer.dall@linaro.org; marc.zyngier@arm.com;
> > alex.williamson@redhat.com; avi.kivity@gmail.com; mtosatti@redhat.com;
> > joro@8bytes.org; b.reynal@virtualopensystems.com
> > Cc: linux-kernel@vger.kernel.org; patches@linaro.org
> > Subject: Re: [RFC v2 3/6] irq: bypass: Extend skeleton for ARM forwarding
> > control
> >
> >
> >
> > On 07/07/2015 13:18, Wu, Feng wrote:
> > > Then I still need assign prod and de-assign prod in
> > > irq_bypass_register_consumer/irq_bypass_unregister_consumer, Right?
> > > Would you please share why this is better.
> >
> > The need to store the consumer->producer link seems to be unique to
> > posted interrupts.  It is difficult to say without seeing the PI code,
> > but I prefer to keep the bypass manager as small as possible.
> 
> Fine. I will follow your suggestion!

If using the following changes, how can we assign 'prod', we need to use
container_of to get struct kvm_kernel_irqfd and then refer to 'prod', but
we cannot do this in irq_bypass_register_consumer(), right? It is a
common API. But we can only get the associated producer info inside
bypass manager, right?

Thanks,
Feng

struct kvm_kernel_irqfd {

 	......

 	struct irq_bypass_consumer cons;
 	struct irq_bypass_producer *prod;
};


> 
> Thanks,
> Feng
> 
> >
> > Paolo
