From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 03/14] ARM: bugs: hook processor bug checking into SMP
 and suspend paths
Date: Sat, 19 May 2018 11:13:32 +0100
Message-ID: <20180519101332.GJ17671@n2100.armlinux.org.uk>
References: <20180516105949.GJ16141@n2100.armlinux.org.uk>
 <E1fIuAu-0003jr-Kc@rmk-PC.armlinux.org.uk>
 <01094c0d-af69-7e4c-65ec-7acddc778b5e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <01094c0d-af69-7e4c-65ec-7acddc778b5e@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, May 16, 2018 at 09:23:01AM -0700, Florian Fainelli wrote:
> On 05/16/2018 04:00 AM, Russell King wrote:
> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > index 2da087926ebe..5ad0b67b9e33 100644
> > --- a/arch/arm/kernel/smp.c
> > +++ b/arch/arm/kernel/smp.c
> > @@ -31,6 +31,7 @@
> >  #include <linux/irq_work.h>
> >  
> >  #include <linux/atomic.h>
> > +#include <asm/bugs.h>
> >  #include <asm/smp.h>
> >  #include <asm/cacheflush.h>
> >  #include <asm/cpu.h>
> > @@ -405,6 +406,9 @@ asmlinkage void secondary_start_kernel(void)
> >  	 * before we continue - which happens after __cpu_up returns.
> >  	 */
> >  	set_cpu_online(cpu, true);
> > +
> > +	check_other_bugs();
> 
> Given what is currently implemented, I don't think the location of
> check_other_bugs() matters too much, but we might have to move this
> after the local_irq_enable() at some point if we need to check for e.g:
> a bogus local timer or whatever?

We could move it later if we need to.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
