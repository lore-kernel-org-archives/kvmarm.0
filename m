From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 03/14] ARM: bugs: hook processor bug checking into SMP
 and suspend paths
Date: Fri, 25 May 2018 11:03:59 +0100
Message-ID: <20180525100359.GC17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjEx-00063Y-N5@rmk-PC.armlinux.org.uk>
 <b454e37c-52a8-387f-3649-8ce72c9a5b18@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 775A749F8B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:53:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PeLPOcGqOU4V for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 05:53:34 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 994FB49F7F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:53:34 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <b454e37c-52a8-387f-3649-8ce72c9a5b18@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 04:30:40PM -0700, Florian Fainelli wrote:
> On 05/21/2018 04:44 AM, Russell King wrote:
> > Check for CPU bugs when secondary processors are being brought online,
> > and also when CPUs are resuming from a low power mode.  This gives an
> > opportunity to check that processor specific bug workarounds are
> > correctly enabled for all paths that a CPU re-enters the kernel.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Something I missed, is that this correctly warns about e.g: missing the
> IBE bit for secondary cores, but it seems to be missing it for the boot CPU:

Are you sure that the boot CPU has the IBE bit clear?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
