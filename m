From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/2] Detect vGIC presence at runtime
Date: Thu, 9 Jul 2015 15:25:02 +0200
Message-ID: <20150709132502.GO13530@cbox>
References: <cover.1436264839.git.p.fedin@samsung.com>
 <8f44081ef96f51c6f2a5753e5933d7de1e3c2c2f.1436264839.git.p.fedin@samsung.com>
 <20150709113721.GJ13530@cbox>
 <01b401d0ba45$e23be430$a6b3ac90$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF2D583D4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:13:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4VB-zaqa-bWj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 09:13:23 -0400 (EDT)
Received: from mail-la0-f52.google.com (mail-la0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F6CD583C4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 09:13:22 -0400 (EDT)
Received: by laar3 with SMTP id r3so246701643laa.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 06:24:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <01b401d0ba45$e23be430$a6b3ac90$@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Marc Zyngier' <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 09, 2015 at 03:50:49PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > why not report ENXIO as an error?  If probing the vgic fails due to
> > being unable to request the irq or something similar, then surely your
> > system has and error and this should be reported.
> 
>  It is reported by probe function itself.
>  -ENODEV here means there's no GIC at all. -ENXIO happens when, for example, there is GIC node in
> the device tree, but it does not specify vGIC resources. Normally this means that vGIC is defunct on
> the machine.

I'd like to distinguish between the 'missing vgic' and 'something bad
happened when trying to initialize the vgic' cases, which I don't think
we do currently, because the ENXIO code is used in various situations.

> 
> > This may be more nicely implemented by letting the vgic init/probe
> > functions set the vgic_present, or maybe better yet, just export a
> > function from vgic.c:
> > 
> > bool kvm_vgic_present(void)
> > {
> > 	return vgic_ops != NULL;
> > }
> 
>  Is it necessary? Actually this flag is not needed anywhere else except arch/arm/kvm/arm.c, only at
> init time. Runtime should, i believe, use irqchip_in_kernel(), because userland can choose just not
> to use vGIC for some reason (testing for example).
> 
I feel the init flow is relatively difficult to follow and adding a
bunch of flags here and there doesn't seem to help.  By adding a
function with a proper comment, it should be more clear, and I don't
like the switch statement on the error return values.

-Christoffer
