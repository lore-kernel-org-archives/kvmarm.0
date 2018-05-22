From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 06/14] ARM: spectre-v2: harden branch predictor on
 context switches
Date: Tue, 22 May 2018 10:55:06 +0100
Message-ID: <20180522095506.GQ17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFD-00063u-Q5@rmk-PC.armlinux.org.uk>
 <61e24c59-9905-8524-92ba-98cdbadb3011@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D68A84A0C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 05:45:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6VPCSN8KqPim for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 05:45:22 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 02E684A054
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 05:45:22 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <61e24c59-9905-8524-92ba-98cdbadb3011@gmail.com>
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

On Mon, May 21, 2018 at 08:21:58PM -0700, Florian Fainelli wrote:
> 
> 
> On 05/21/2018 04:44 AM, Russell King wrote:
> > Harden the branch predictor against Spectre v2 attacks on context
> > switches for ARMv7 and later CPUs.  We do this by:
> > 
> > Cortex A9, A12, A17, A73, A75: invalidating the BTB.
> > Cortex A15, Brahma B15: invalidating the instruction cache.
> > 
> > Cortex A57 and Cortex A72 are not addressed in this patch.
> > 
> > Cortex R7 and Cortex R8 are also not addressed as we do not enforce
> > memory protection on these cores.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

It does need this additional patch to avoid some build errors - I'm
surprised that my autobuilder found it before the 0-day builder...

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 0c37e6a2830d..526d07ab6b7a 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -127,4 +127,8 @@ void cpu_v7_bugs_init(void)
 		pr_info("CPU: Spectre v2: using %s workaround\n",
 			spectre_v2_method);
 }
+#else
+void cpu_v7_bugs_init(void)
+{
+}
 #endif


-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
