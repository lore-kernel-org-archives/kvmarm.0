From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 08/14] ARM: spectre-v2: harden user aborts in kernel space
Date: Wed, 23 May 2018 00:25:20 +0100
Message-ID: <20180522232519.GV17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFO-000648-8d@rmk-PC.armlinux.org.uk>
 <e52b3541-7106-a6dc-5851-01b091bec38f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <e52b3541-7106-a6dc-5851-01b091bec38f@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 22, 2018 at 06:15:02PM +0100, Marc Zyngier wrote:
> On 21/05/18 12:45, Russell King wrote:
> > +	switch (read_cpuid_part()) {
> > +	case ARM_CPU_PART_CORTEX_A8:
> > +	case ARM_CPU_PART_CORTEX_A9:
> > +	case ARM_CPU_PART_CORTEX_A12:
> > +	case ARM_CPU_PART_CORTEX_A17:
> > +	case ARM_CPU_PART_CORTEX_A73:
> > +	case ARM_CPU_PART_CORTEX_A75:
> > +		harden_branch_predictor = harden_branch_predictor_bpiall;
> > +		spectre_v2_method = "BPIALL";
> > +		break;
> 
> You don't seem to take into account the PFR0.CSV2 field which indicates
> that the CPU has a branch predictor that is immune to Spectre-v2.

That information is not covered in the description of the vulnerability
- the published information on the security-updates site states that
BPIALL is required without stating any conditions.

> See for example the Cortex-A75 r3p0 TRM[1].

So which cores should such a test be applied to?  As I mention,
the support site doesn't give this detail.  That brings up the
obvious question: what else does the web page miss out on?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
