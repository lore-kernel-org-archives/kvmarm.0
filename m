From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC 12/17] irq: bypass: Extend skeleton for ARM forwarding
 control
Date: Fri, 3 Jul 2015 09:06:17 +0200
Message-ID: <55963469.9030805@redhat.com>
References: <1435843047-6327-1-git-send-email-eric.auger@linaro.org>
 <1435843047-6327-13-git-send-email-eric.auger@linaro.org>
 <E959C4978C3B6342920538CF579893F0025E6C89@SHSMSX104.ccr.corp.intel.com>
 <5596311A.3010703@redhat.com>
 <E959C4978C3B6342920538CF579893F0025E70BF@SHSMSX104.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 058025788F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 02:55:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x0lnb4a+JiW3 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Jul 2015 02:55:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19DB257887
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Jul 2015 02:55:07 -0400 (EDT)
In-Reply-To: <E959C4978C3B6342920538CF579893F0025E70BF@SHSMSX104.ccr.corp.intel.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Wu, Feng" <feng.wu@intel.com>, Eric Auger <eric.auger@linaro.org>, "eric.auger@st.com" <eric.auger@st.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "alex.williamson@redhat.com" <alex.williamson@redhat.com>, "avi.kivity@gmail.com" <avi.kivity@gmail.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>, "b.reynal@virtualopensystems.com" <b.reynal@virtualopensystems.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu



On 03/07/2015 09:00, Wu, Feng wrote:
>>> > > struct irq_bypass_consumer {
>>> > >        struct list_head node;
>>> > >        void *token;
>>> > > +      unsigned irq;	/*got from producer when registered*/
>>> > >        void (*add_producer)(struct irq_bypass_producer *,
>>> > >                             struct irq_bypass_consumer *);
>>> > >        void (*del_producer)(struct irq_bypass_producer *,
>>> > >                             struct irq_bypass_consumer *);
>>> > > +      void (*update)(struct irq_bypass_consumer *);
>>> > > };
>>> > >
>>> > > 'update' is used to update the IRTE, while irq is initialized when
>>> > > registered, which is used to find the right IRTE.
>> > 
>> > Feel free to add "update" in your PI patches.  I am not sure if "irq"
>> > belongs here or in the containing struct.  You can play with both and
>> > submit the version that looks better to you.
> Thanks for your review, Paolo. In my understanding, irq comes from
> the producer side, while gsi belongs to the consumer, so we need
> to get the irq from the producer somewhere. I am not sure adding
> irq here is the good way, but what I need is in the 'update' function,
> I have irq, gsi in hand. :)

It's difficult to say without seeing the patches...  The IRQ is stored
in the producer already with Eric's changes.  If you need to store the
old IRQ value, because "update" needs to do something with it, then I
think "irq" belongs in the container struct.

Perhaps "update" needs to have a producer argument as well?

Paolo
