From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [PATCH kvm-unit-tests v8 03/10] arm/arm64: add some
 delay routines
Date: Tue, 27 Dec 2016 17:27:44 +0100
Message-ID: <20161227162744.2ih6vmijri3slax5@kamzik.brq.redhat.com>
References: <20161208175030.12269-1-drjones@redhat.com>
 <20161208175030.12269-4-drjones@redhat.com>
 <dfb48863-82a7-3bd2-d2dc-498570325970@arm.com>
 <20161209121541.i3advgnpbu5gvoft@hawk.localdomain>
 <cd3f8a17-f080-5ac8-9398-cddee4d23521@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D584340199
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Dec 2016 11:26:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hh-sRlOA9CeO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Dec 2016 11:26:24 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6A0040194
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Dec 2016 11:26:24 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <cd3f8a17-f080-5ac8-9398-cddee4d23521@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Andre Przywara <andre.przywara@arm.com>, qemu-devel@nongnu.org, qemu-arm@nongnu.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 27, 2016 at 10:27:25AM -0500, Christopher Covington wrote:
> On 12/09/2016 07:15 AM, Andrew Jones wrote:
> > On Fri, Dec 09, 2016 at 11:41:06AM +0000, Andre Przywara wrote:
> >> Hi,
> >>
> >> On 08/12/16 17:50, Andrew Jones wrote:
> >>> Allow a thread to wait some specified amount of time. Can
> >>> specify in cycles, usecs, and msecs.
> 
> >>> +++ b/lib/arm/asm/delay.h
> >>> @@ -0,0 +1,14 @@
> >>> +#ifndef _ASMARM_DELAY_H_
> >>> +#define _ASMARM_DELAY_H_
> >>> +/*
> >>> + * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
> >>> + *
> >>> + * This work is licensed under the terms of the GNU LGPL, version 2.
> >>> + */
> >>> +#include <libcflat.h>
> >>> +
> >>> +extern void delay(u64 cycles);
> >>
> >> Nit: Shouldn't this parameter be called "ticks"? Cycles might be a bit
> >> misleading, especially since this prototype is the only documentation on
> >> this. You might just want to fix this when applying the patches.
> > 
> > Right or wrong the kernel uses 'cycles' for this function, named
> > __timer_delay for arm and __delay for arm64. I guess I prefer
> > consistency here.
> 
> I too expect timers to tick and CPUs to cycle. The benefit of
> parameter-name-precise consistency with the Linux source is not
> obvious to me.
>

I just didn't have a strong enough opinion on it to change it. It appears
I'm in a minority though. As this is in master already, patches welcome :)

Thanks,
drew
