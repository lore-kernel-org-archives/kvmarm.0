From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool 6/6] arm: Auto-detect guest GIC type
Date: Thu, 31 Jan 2019 18:46:45 +0000
Message-ID: <20190131184645.23381476@donnerap.cambridge.arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
 <20190125180801.209910-7-andre.przywara@arm.com>
 <20190130182046.GI18558@fuggles.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AF894A2E4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 13:46:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1xTRwb+R1HeG for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 13:46:50 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F0B4A321
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 13:46:50 -0500 (EST)
In-Reply-To: <20190130182046.GI18558@fuggles.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 30 Jan 2019 18:20:46 +0000
Will Deacon <will.deacon@arm.com> wrote:

> On Fri, Jan 25, 2019 at 06:08:01PM +0000, Andre Przywara wrote:
> > At the moment kvmtool always tries to instantiate a virtual GICv2
> > for the guest, and fails with some scary error message if that
> > doesn't work. The user has then to manually specify
> > "--irqchip=gicv3", which is not really obvious.
> > With the advent of more GICv3-only machines, let's try to be more
> > clever and implement some auto-detection of the GIC type needed:
> > - We try GICv3 first. On GICv3-only hosts this will be the only
> > working option, so we don't loose anything. On GICv2-backwards
> > compatible GICv3 machines GICv3 is probably the better choice these
> > days.  
> 
> Could you elaborate on "probably the better choice" please?

When we introduced the GICv3 emulation and the kvmtool support,
it was deemed less mature than the GICv2 support. This was one of the
reasons we were happy with GICv2-on-v3 as the default. Now with GICv3
support being stable, we should use the advantages like the system
register interface.

> > - If that fails, we try GICv2.
> > - If that fails, we ran out out options and bail out.
> > 
> > We deduce the choice between "ITS vs. pure GICv3" and "GICv2m vs.
> > GICv2" by the presence of PCI devices, they would be the only MSI
> > users anyway.  
> 
> This feels really flakey. Why don't we just try, in order:
> 
>   v3 + ITS
>   v3
>   v2m
>   v2

I think v2m will fail only rarely (doesn't rely on any kernel
support), so in practise we will likely never get a "pure" GICv2. But
since we always have the --irqchip option to override this, that's
probably OK.

Will change it to that effect.

Cheers,
Andre.
