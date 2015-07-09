From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH 2/2] Detect vGIC presence at runtime
Date: Thu, 09 Jul 2015 16:47:18 +0300
Message-ID: <020c01d0ba4d$c60181a0$520484e0$@samsung.com>
References: <cover.1436264839.git.p.fedin@samsung.com>
 <8f44081ef96f51c6f2a5753e5933d7de1e3c2c2f.1436264839.git.p.fedin@samsung.com>
 <20150709113721.GJ13530@cbox> <01b401d0ba45$e23be430$a6b3ac90$@samsung.com>
 <20150709132502.GO13530@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 261D7583A5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:35:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a8i4KryaRjSd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 09:35:47 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 123BA58358
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:35:46 -0400 (EDT)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR800H5X3MVLT70@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 09 Jul 2015 14:47:19 +0100 (BST)
In-reply-to: <20150709132502.GO13530@cbox>
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
To: 'Christoffer Dall' <christoffer.dall@linaro.org>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> I'd like to distinguish between the 'missing vgic' and 'something bad
> happened when trying to initialize the vgic' cases, which I don't think
> we do currently, because the ENXIO code is used in various situations.

 It is done. Check, for example, vgic_v2_probe(). -ENXIO is returned when some of resources are
either missing from DT specification or wrongly given (not page-aligned). In the rest of cases error
code is taken from underlying functions, which are more supposed to return things like -EINVAL or
-ENOMEM.
 If you are doubtful, i could suggest to replace -EINVAL with -ENODEV in cases where resources are
not present. This would give more clear indication of "we don't have vGIC" condition.

> I feel the init flow is relatively difficult to follow and adding a
> bunch of flags here and there doesn't seem to help.  By adding a
> function with a proper comment, it should be more clear, and I don't
> like the switch statement on the error return values.

 Well, the alternative is:
 1. If GIC node or vGIC resources are not present, return 0 instead of error code.
 2. Implement a function which you suggest.
 Then:
 1. Situation with missing vGIC is just considered to be normal; it's not a to-be-ignored error any
more.
 2. "vGIC present" situation is automatically determined by vgic_ops != NULL; this means that probe
function completely worked and vGIC implementation has been chosen.

 Agree?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


> -----Original Message-----
> From: Christoffer Dall [mailto:christoffer.dall@linaro.org]
> Sent: Thursday, July 09, 2015 4:25 PM
> To: Pavel Fedin
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; 'Marc Zyngier'
> Subject: Re: [PATCH 2/2] Detect vGIC presence at runtime
> 
> On Thu, Jul 09, 2015 at 03:50:49PM +0300, Pavel Fedin wrote:
> >  Hello!
> >
> > > why not report ENXIO as an error?  If probing the vgic fails due to
> > > being unable to request the irq or something similar, then surely your
> > > system has and error and this should be reported.
> >
> >  It is reported by probe function itself.
> >  -ENODEV here means there's no GIC at all. -ENXIO happens when, for example, there is GIC node
in
> > the device tree, but it does not specify vGIC resources. Normally this means that vGIC is
defunct on
> > the machine.
> 
> >
> > > This may be more nicely implemented by letting the vgic init/probe
> > > functions set the vgic_present, or maybe better yet, just export a
> > > function from vgic.c:
> > >
> > > bool kvm_vgic_present(void)
> > > {
> > > 	return vgic_ops != NULL;
> > > }
> >
> >  Is it necessary? Actually this flag is not needed anywhere else except arch/arm/kvm/arm.c, only
at
> > init time. Runtime should, i believe, use irqchip_in_kernel(), because userland can choose just
not
> > to use vGIC for some reason (testing for example).
> >
> I feel the init flow is relatively difficult to follow and adding a
> bunch of flags here and there doesn't seem to help.  By adding a
> function with a proper comment, it should be more clear, and I don't
> like the switch statement on the error return values.
> 
> -Christoffer
