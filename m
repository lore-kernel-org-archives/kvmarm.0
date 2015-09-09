From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/5] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Wed, 09 Sep 2015 14:28:32 +0300
Message-ID: <020101d0eaf2$a9242d50$fb6c87f0$@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <fc3dabfbff09f5c70affdde2996f3658b2000825.1441370053.git.p.fedin@samsung.com>
 <55E9A267.4040404@arm.com> <015e01d0e942$c2dbc340$489349c0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9259340FF5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 07:27:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aRI4VzBxbEM6 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Sep 2015 07:27:56 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7759140FAB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Sep 2015 07:27:56 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NUE00FMTQJLYY20@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Wed, 09 Sep 2015 12:28:34 +0100 (BST)
In-reply-to: <015e01d0e942$c2dbc340$489349c0$@samsung.com>
Content-language: ru
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: 'Andre Przywara' <andre.przywara@arm.com>
Cc: 'Marc Zyngier' <Marc.Zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello Andre! I haven't heard from you on any of my questions. But, nevertheless, i would like to
inform you (and other interested people) that i'm leaving on vacation, and will be back 2 weeks
later. Just in case if someone writes me something and i don't reply.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf Of Pavel Fedin
> Sent: Monday, September 07, 2015 10:57 AM
> To: 'Andre Przywara'
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; 'Marc Zyngier'; 'Peter Maydell'
> Subject: RE: [PATCH v3 2/5] KVM: arm64: Implement vGICv3 distributor and redistributor access
> from userspace
> 
>  Hello!
> 
> > > --- a/virt/kvm/arm/vgic.c
> > > +++ b/virt/kvm/arm/vgic.c
> > > @@ -2468,6 +2468,7 @@ int vgic_attr_regs_access(struct kvm_device *dev,
> > >  	 * access. For 64-bit registers we have to split up the operation.
> > >  	 */
> > >  	mmio->len = sizeof(u32);
> > > +	mmio->private = vcpu; /* For redistributor handlers */
> >
> > I guess this can be moved into the caller and then you can drop the vcpu
> > parameter and use private here instead, no?
> 
>  No because 'vcpu' is not a parameter. It is figured out in the middle of the function, under
> dev->kvm->lock mutex, out of 'cpuid' index.
> 
> Kind regards,
> Pavel Fedin
> Expert Engineer
> Samsung Electronics Research center Russia
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
