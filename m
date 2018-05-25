From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 03/14] ARM: bugs: hook processor bug checking into SMP
 and suspend paths
Date: Fri, 25 May 2018 12:31:39 +0100
Message-ID: <20180525113139.GD17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjEx-00063Y-N5@rmk-PC.armlinux.org.uk>
 <b454e37c-52a8-387f-3649-8ce72c9a5b18@gmail.com>
 <20180525100359.GC17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20180525100359.GC17671@n2100.armlinux.org.uk>
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

On Fri, May 25, 2018 at 11:03:59AM +0100, Russell King - ARM Linux wrote:
> On Thu, May 24, 2018 at 04:30:40PM -0700, Florian Fainelli wrote:
> > On 05/21/2018 04:44 AM, Russell King wrote:
> > > Check for CPU bugs when secondary processors are being brought online,
> > > and also when CPUs are resuming from a low power mode.  This gives an
> > > opportunity to check that processor specific bug workarounds are
> > > correctly enabled for all paths that a CPU re-enters the kernel.
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> > 
> > Something I missed, is that this correctly warns about e.g: missing the
> > IBE bit for secondary cores, but it seems to be missing it for the boot CPU:
> 
> Are you sure that the boot CPU has the IBE bit clear?

Here's what I get on TI Keystone 2, which doesn't set the IBE bit for
any CPU:

CPU: Testing write buffer coherency: ok
CPU0: Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable
CPU0: Spectre v2: using ICIALLU workaround
/cpus/cpu@0 missing clock-frequency property
/cpus/cpu@1 missing clock-frequency property
/cpus/cpu@2 missing clock-frequency property
/cpus/cpu@3 missing clock-frequency property
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Setting up static identity map for 0x80008300 - 0x80008438
Hierarchical SRCU implementation.
smp: Bringing up secondary CPUs ...
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
CPU1: Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable
CPU1: Spectre v2: using ICIALLU workaround
CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
CPU2: Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable
CPU2: Spectre v2: using ICIALLU workaround
CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
CPU3: Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable
CPU3: Spectre v2: using ICIALLU workaround

It should be noted that, if we implement a "bugs" bit exported to
userspace (as I think someone requested) that booting on a system
where only the boot CPU initially comes up (which has the IBE bit
set) and then bringing the secondary CPUs online after userspace
has started (where those CPUs don't have the IBE bit set) will
result in the system initially not being vulnerable, but then
becoming vulnerable when running on those other CPUs.

If the bugs bit had already been checked by userspace, then it would
think that there's no system level vulnerability.  Userspace would
need to check the status each time a CPU comes online.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
