From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Add VGICv3 save/restore API documentation
Date: Thu, 8 Oct 2015 14:36:30 +0200
Message-ID: <20151008123630.GC20936@cbox>
References: <1444247430-14808-1-git-send-email-christoffer.dall@linaro.org>
 <003a01d10199$58e96590$0abc30b0$@samsung.com>
 <20151008082302.GE14315@cbox>
 <005e01d101a9$31ee80f0$95cb82d0$@samsung.com>
 <20151008092858.GA16100@cbox> <561641F5.4060202@arm.com>
 <009501d101c4$dde8e2e0$99baa8a0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EE3A41978
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:34:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lpHSij9IBEIM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Oct 2015 08:34:17 -0400 (EDT)
Received: from mail-lb0-f177.google.com (mail-lb0-f177.google.com
 [209.85.217.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C8D54130B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Oct 2015 08:34:17 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so45680720lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Oct 2015 05:36:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <009501d101c4$dde8e2e0$99baa8a0$@samsung.com>
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
Cc: kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>, 'Andre Przywara' <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 08, 2015 at 03:28:40PM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > Well, compatibility with GICv2 is the biggest mistake we made when
> > designing the GICv3 architecture. And that's why our emulation doesn't
> > give a damn about v2 compatibility.
> 
>  Ok, i see your arguments, and after that it becomes a matter of personal taste. Three beat one, i
> go your way. :) Don't know if i'll be able to roll out v5 tomorrow, but i think on monday i'll
> definitely do.
> 
There's no rush, I don't think this will make it into v4.4 anyhow, as
we're already on -rc4 and there's a bunch of other stuff in flight, and
I haven't configured a way to test these patches yet.

Speaking of which, does the QEMU side of this patch set require first
adding the GICv3 emulation for the data structures or is there a
stand-alone migration patch set somewhere?

-Christoffer
