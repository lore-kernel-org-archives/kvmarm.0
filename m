From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH v3 2/5] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Mon, 07 Sep 2015 10:56:52 +0300
Message-ID: <015e01d0e942$c2dbc340$489349c0$@samsung.com>
References: <cover.1441370053.git.p.fedin@samsung.com>
 <fc3dabfbff09f5c70affdde2996f3658b2000825.1441370053.git.p.fedin@samsung.com>
 <55E9A267.4040404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 810ED4117E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 03:56:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jTGbsJhMjB4I for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2015 03:56:22 -0400 (EDT)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9695F40FB5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2015 03:56:22 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NUA006WWREU2F00@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 07 Sep 2015 08:56:54 +0100 (BST)
In-reply-to: <55E9A267.4040404@arm.com>
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

 Hello!

> > --- a/virt/kvm/arm/vgic.c
> > +++ b/virt/kvm/arm/vgic.c
> > @@ -2468,6 +2468,7 @@ int vgic_attr_regs_access(struct kvm_device *dev,
> >  	 * access. For 64-bit registers we have to split up the operation.
> >  	 */
> >  	mmio->len = sizeof(u32);
> > +	mmio->private = vcpu; /* For redistributor handlers */
> 
> I guess this can be moved into the caller and then you can drop the vcpu
> parameter and use private here instead, no?

 No because 'vcpu' is not a parameter. It is figured out in the middle of the function, under
dev->kvm->lock mutex, out of 'cpuid' index.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
