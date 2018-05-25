From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 08/15] ARM: spectre-v2: harden user aborts in kernel
 space
Date: Fri, 25 May 2018 08:47:42 -0700
Message-ID: <20180525154742.GA77025@atomide.com>
References: <20180525135938.GE17671@n2100.armlinux.org.uk>
 <E1fMDHD-00073Q-Ob@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <E1fMDHD-00073Q-Ob@rmk-PC.armlinux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

* Russell King <rmk+kernel@armlinux.org.uk> [180525 15:10]:
> +static void cpu_v7_spectre_init(void)
> +{
> +	const char *spectre_v2_method = NULL;
> +	int cpu = smp_processor_id();
> +
> +	if (per_cpu(harden_branch_predictor_fn, cpu))
> +		return;
> +
> +	switch (read_cpuid_part()) {
> +	case ARM_CPU_PART_CORTEX_A8:
> +	case ARM_CPU_PART_CORTEX_A9:
> +	case ARM_CPU_PART_CORTEX_A12:
> +	case ARM_CPU_PART_CORTEX_A17:
> +	case ARM_CPU_PART_CORTEX_A73:
> +	case ARM_CPU_PART_CORTEX_A75:
> +		per_cpu(harden_branch_predictor_fn, cpu) =
> +			harden_branch_predictor_bpiall;
> +		spectre_v2_method = "BPIALL";
> +		break;
> +
> +	case ARM_CPU_PART_CORTEX_A15:
> +	case ARM_CPU_PART_BRAHMA_B15:
> +		per_cpu(harden_branch_predictor_fn, cpu) =
> +			harden_branch_predictor_iciallu;
> +		spectre_v2_method = "ICIALLU";
> +		break;
> +	}
> +	if (spectre_v2_method)
> +		pr_info("CPU%u: Spectre v2: using %s workaround\n",
> +			smp_processor_id(), spectre_v2_method);
> +}

We can now get this with the whole series applied:

CPU0: Spectre v2: firmware did not set auxiliary control register
IBE bit, system vulnerable
CPU: Spectre v2: using ICIALLU workaround

So maybe change the wording from "using %s workaround" to
"chosen workaround %s"?

Or I guess disabling the pr_info when not functional can
be done in the later patches based on some variable set
by check_spectre_auxcr() would be doable too.

Regards,

Tony
