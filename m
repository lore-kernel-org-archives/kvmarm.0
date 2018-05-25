From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v3 08/15] ARM: spectre-v2: harden user aborts in kernel
 space
Date: Fri, 25 May 2018 16:52:08 +0100
Message-ID: <20180525155207.GF17671@n2100.armlinux.org.uk>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
 <E1fMDHD-00073Q-Ob@rmk-PC.armlinux.org.uk>
 <20180525154742.GA77025@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61A4E49F94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 11:42:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CnbvMtEo9lqP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 11:41:44 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 155D949F8C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 11:41:44 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180525154742.GA77025@atomide.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Tony Lindgren <tony@atomide.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 25, 2018 at 08:47:42AM -0700, Tony Lindgren wrote:
> * Russell King <rmk+kernel@armlinux.org.uk> [180525 15:10]:
> > +static void cpu_v7_spectre_init(void)
> > +{
> > +	const char *spectre_v2_method = NULL;
> > +	int cpu = smp_processor_id();
> > +
> > +	if (per_cpu(harden_branch_predictor_fn, cpu))
> > +		return;
> > +
> > +	switch (read_cpuid_part()) {
> > +	case ARM_CPU_PART_CORTEX_A8:
> > +	case ARM_CPU_PART_CORTEX_A9:
> > +	case ARM_CPU_PART_CORTEX_A12:
> > +	case ARM_CPU_PART_CORTEX_A17:
> > +	case ARM_CPU_PART_CORTEX_A73:
> > +	case ARM_CPU_PART_CORTEX_A75:
> > +		per_cpu(harden_branch_predictor_fn, cpu) =
> > +			harden_branch_predictor_bpiall;
> > +		spectre_v2_method = "BPIALL";
> > +		break;
> > +
> > +	case ARM_CPU_PART_CORTEX_A15:
> > +	case ARM_CPU_PART_BRAHMA_B15:
> > +		per_cpu(harden_branch_predictor_fn, cpu) =
> > +			harden_branch_predictor_iciallu;
> > +		spectre_v2_method = "ICIALLU";
> > +		break;
> > +	}
> > +	if (spectre_v2_method)
> > +		pr_info("CPU%u: Spectre v2: using %s workaround\n",
> > +			smp_processor_id(), spectre_v2_method);
> > +}
> 
> We can now get this with the whole series applied:
> 
> CPU0: Spectre v2: firmware did not set auxiliary control register
> IBE bit, system vulnerable
> CPU: Spectre v2: using ICIALLU workaround
> 
> So maybe change the wording from "using %s workaround" to
> "chosen workaround %s"?
> 
> Or I guess disabling the pr_info when not functional can
> be done in the later patches based on some variable set
> by check_spectre_auxcr() would be doable too.

You should not be getting both messages.  It looks like you're using
an older series - I assumed you pulled my git tree rather than the
patches?  The public git tree isn't up to date with these changes.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
