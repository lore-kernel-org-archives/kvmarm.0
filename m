From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: unregister notifiers in hyp mode teardown path
Date: Wed, 6 Apr 2016 15:15:25 +0200
Message-ID: <20160406131525.GD16355@cbox>
References: <1459777611-22592-1-git-send-email-sudeep.holla@arm.com>
 <20160406115250.GC16355@cbox> <57050A82.7030905@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63C724053F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 09:14:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sk9ELaQoOEcn for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Apr 2016 09:13:55 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5CE5C40402
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Apr 2016 09:13:54 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id 191so57706106wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 06 Apr 2016 06:15:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57050A82.7030905@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 06, 2016 at 02:09:22PM +0100, Sudeep Holla wrote:
> Hi Christoffer,
> 
> On 06/04/16 12:52, Christoffer Dall wrote:
> >Hi Sudeep,
> >
> >
> >On Mon, Apr 04, 2016 at 02:46:51PM +0100, Sudeep Holla wrote:
> >>Commit 1e947bad0b63 ("arm64: KVM: Skip HYP setup when already running
> >>in HYP") re-organized the hyp init code and ended up leaving the CPU
> >>hotplug and PM notifier even if hyp mode initialization fails.
> >>
> >>Since KVM is not yet supported with ACPI, the above mentioned commit
> >>breaks CPU hotplug in ACPI boot.
> >>
> >>This patch fixes teardown_hyp_mode to properly unregister both CPU
> >>hotplug and PM notifiers in the teardown path.
> >>
> >>Fixes: 1e947bad0b63 ("arm64: KVM: Skip HYP setup when already running in HYP")
> >>Cc: Christoffer Dall <christoffer.dall@linaro.org>
> >>Cc: Marc Zyngier <marc.zyngier@arm.com>
> >>Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> >
> >I fixed up your patch to apply after James' patch:
> >5f5560b (arm64: KVM: Register CPU notifiers when the kernel runs at HYP, 2016-03-30)
> >
> 
> Thanks for that, sorry I didn't realize it would conflict with that change.
> 
> >My only concern with this approach is that we're not checking the return
> >values from the cpu_pm_register_notifier calls, and we're potentially
> >calling unregister_cpu_notifier even if the original registration
> >failed.
> >
> 
> I agree with your concern and I had the same when I first wrote the
> patch. But considering the return values makes it unnecessarily ugly, so
> I dropped it and kept it simple.
> 
> >I know this can't happen given current implementations, but if any of
> >these functions ever start returning error values, then we're silently
> >ignoring them.  What is our policy on these things?
> >
> 
> I am fine to handle that, but as you mentioned it's not really needed.
> May be we can add some error message if that's really required.
> 

Hopefully we're not the only ones taking a slight shortcut here, so
anyone modifying those functions will notice it when doing so...

> >Let me know if the following revised version of your patch looks ok to
> >you (against kvmarm/master):
> >
> 
> Looks fine and tested kvmarm/master with this patch on top.
> 

Thanks, will queue it then.

-Christoffer
