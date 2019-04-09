From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] lib: arm: Use correct halt() prototype
 from smp.h
Date: Tue, 9 Apr 2019 12:11:35 +0200
Message-ID: <20190409101135.g5l6sxr2biflitu3@kamzik.brq.redhat.com>
References: <20190408151125.32080-1-alexandru.elisei@arm.com>
 <20190409074005.6fc5sve4kbpq6e5r@kamzik.brq.redhat.com>
 <3dea090b-9c48-34b2-f004-37661cb71f0e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 063324A36C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 06:11:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0QHux9PJkbC2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 06:11:39 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB0364A369
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 06:11:39 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <3dea090b-9c48-34b2-f004-37661cb71f0e@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 09, 2019 at 10:15:59AM +0100, Alexandru Elisei wrote:
> On 4/9/19 8:40 AM, Andrew Jones wrote:
> > On Mon, Apr 08, 2019 at 04:11:25PM +0100, Alexandru Elisei wrote:
> >> The prototype for the halt() function is incorrect, because halt() doesn't
> >> take any arguments. Fix it by using the prototype from smp.h.
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  lib/arm/io.c | 5 ++---
> >>  1 file changed, 2 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/lib/arm/io.c b/lib/arm/io.c
> >> index 8226b765bdc5..6d3d7afed002 100644
> >> --- a/lib/arm/io.c
> >> +++ b/lib/arm/io.c
> >> @@ -15,11 +15,10 @@
> >>  #include <asm/psci.h>
> >>  #include <asm/spinlock.h>
> >>  #include <asm/io.h>
> >> +#include <asm/smp.h>
> >>  
> >>  #include "io.h"
> >>  
> >> -extern void halt(int code);
> >> -
> >>  static struct spinlock uart_lock;
> >>  /*
> >>   * Use this guess for the uart base in order to make an attempt at
> >> @@ -93,6 +92,6 @@ void exit(int code)
> >>  {
> >>  	chr_testdev_exit(code);
> >>  	psci_system_off();
> >> -	halt(code);
> >> +	halt();
> >>  	__builtin_unreachable();
> >>  }
> >> -- 
> >> 2.17.0
> >>
> > I don't mind this change, because per the code it is the "correct"
> > thing to do. However, I was being a bit tricky here when I wrote it.
> > By changing the prototype to take 'code' as argument we guarantee
> > that 'code' will be in x0/r0 when we halt, giving us a last chance
> > to see it when inspecting the halted unit test state.
> >
> > Anyway, like I said, I'm fine with the cleanup, but the prototype
> > abuse does serve a purpose - maybe just not a good enough purpose
> > to justify the weirdness.
> 
> Now it makes sense. I didn't think it was intentional, but now that you have
> mentioned it, the same pattern is used by powerpc.

No surprise there. I wrote that too, based on the arm code :)

> 
> Perhaps a comment explaining that having different prototypes was on purpose
> would be the best solution?

Yes, either a comment explaining the weirdness or your patch to
remove it would be a good idea in order to avoid future head
scratching. I'll send a patch that adds comments to both arm and
powerpc.

Thanks,
drew
