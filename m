From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v5 10/15] ARM: spectre-v2: warn about incorrect context
 switching functions
Date: Thu, 31 May 2018 10:49:22 +0100
Message-ID: <20180531094922.GQ17671@n2100.armlinux.org.uk>
References: <20180529145320.GJ17671@n2100.armlinux.org.uk>
 <E1fNg1d-00059d-NR@rmk-PC.armlinux.org.uk>
 <86r2lu9yzf.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E6404A0F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 May 2018 05:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cgBUXNyryRrV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 May 2018 05:38:37 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7A4E4A0EA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 May 2018 05:38:36 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <86r2lu9yzf.wl-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 29, 2018 at 06:02:28PM +0100, Marc Zyngier wrote:
> On Tue, 29 May 2018 15:55:01 +0100,
> Russell King wrote:
> > 
> > Warn at error level if the context switching function is not what we
> > are expecting.  This can happen with big.Little systems, which we
> > currently do not support.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Boot-tested-by: Tony Lindgren <tony@atomide.com>
> > Reviewed-by: Tony Lindgren <tony@atomide.com>
> 
> I assume this is a temporary situation until the ARM port grows the
> necessary infrastructure to support this mitigation on heterogeneous
> systems.

As I've said, I think that is going to be a very difficult problem to
resolve.  I detailed why in previous emails, but it seems each time I
do that, no one bothers to respond (presumably because no one has any
ideas how to sort that problem either.)

I believe that it's better to get some of the mitigations in the kernel
and warn about non-supported setups than it is to hold it back.

I notice that you haven't replied to some of the patches (7 and 8),
which makes me think that you have an issue with them - and as tonight
is likely the last linux-next before the merge window, we're basically
out of time to do another respin if there's something you don't like
there and if we want to get them in during the next merge window.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
