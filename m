From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 09/14] ARM: spectre-v2: add PSCI based hardening
Date: Tue, 22 May 2018 18:57:18 +0100
Message-ID: <20180522175717.GT17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFT-00064F-Bs@rmk-PC.armlinux.org.uk>
 <35edb3df-fed4-b6e6-be0c-ee758618c92e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B0AF849F93
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 13:47:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m9YdLkil0m5A for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 13:46:50 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B465F49F94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 13:46:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <35edb3df-fed4-b6e6-be0c-ee758618c92e@arm.com>
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

On Tue, May 22, 2018 at 06:24:13PM +0100, Marc Zyngier wrote:
> On 21/05/18 12:45, Russell King wrote:
> > Add PSCI based hardening for cores that require more complex handling in
> > firmware.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm/mm/proc-v7-bugs.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++
> >  arch/arm/mm/proc-v7.S      | 21 +++++++++++++++++++
> >  2 files changed, 71 insertions(+)
> > 
> > diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
> > index 65a9b8141f86..0c37e6a2830d 100644
> > --- a/arch/arm/mm/proc-v7-bugs.c
> > +++ b/arch/arm/mm/proc-v7-bugs.c
> > @@ -1,9 +1,12 @@
> >  // SPDX-License-Identifier: GPL-2.0
> > +#include <linux/arm-smccc.h>
> >  #include <linux/kernel.h>
> > +#include <linux/psci.h>
> >  #include <linux/smp.h>
> >  
> >  #include <asm/cp15.h>
> >  #include <asm/cputype.h>
> > +#include <asm/proc-fns.h>
> >  #include <asm/system_misc.h>
> >  
> >  void cpu_v7_bugs_init(void);
> > @@ -39,6 +42,9 @@ void cpu_v7_ca15_ibe(void)
> >  #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
> >  void (*harden_branch_predictor)(void);
> >  
> > +extern void cpu_v7_smc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
> > +extern void cpu_v7_hvc_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
> > +
> >  static void harden_branch_predictor_bpiall(void)
> >  {
> >  	write_sysreg(0, BPIALL);
> > @@ -49,6 +55,18 @@ static void harden_branch_predictor_iciallu(void)
> >  	write_sysreg(0, ICIALLU);
> >  }
> >  
> > +#ifdef CONFIG_ARM_PSCI
> > +static void call_smc_arch_workaround_1(void)
> > +{
> > +	arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
> > +}
> > +
> > +static void call_hvc_arch_workaround_1(void)
> > +{
> > +	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
> > +}
> > +#endif
> > +
> >  void cpu_v7_bugs_init(void)
> >  {
> >  	const char *spectre_v2_method = NULL;
> > @@ -73,6 +91,38 @@ void cpu_v7_bugs_init(void)
> >  		spectre_v2_method = "ICIALLU";
> >  		break;
> >  	}
> > +
> > +#ifdef CONFIG_ARM_PSCI
> > +	if (psci_ops.smccc_version != SMCCC_VERSION_1_0) {
> > +		struct arm_smccc_res res;
> > +
> > +		switch (psci_ops.conduit) {
> > +		case PSCI_CONDUIT_HVC:
> > +			arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> > +					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
> > +			if ((int)res.a0 < 0)
> > +				break;
> 
> I just realised that there is a small, but significant difference
> between this and the arm64 version: On arm64, we have a table of
> vulnerable implementations, and we try the mitigation on a per-cpu
> basis. Here, you entirely rely on the firmware to discover whether the
> CPU needs mitigation or not. You then need to check for a return value
> of 1, which indicates that although the mitigation is implemented, it is
> not required on this particular CPU.
> 
> But that's probably moot if you don't support BL systems.
> 
> > +			harden_branch_predictor = call_hvc_arch_workaround_1;
> > +			processor.switch_mm = cpu_v7_hvc_switch_mm;
> > +			spectre_v2_method = "hypervisor";
> > +			break;
> > +
> > +		case PSCI_CONDUIT_SMC:
> > +			arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
> > +					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
> > +			if ((int)res.a0 < 0)
> > +				break;
> > +			harden_branch_predictor = call_smc_arch_workaround_1;
> > +			processor.switch_mm = cpu_v7_smc_switch_mm;
> > +			spectre_v2_method = "firmware PSCI";
> 
> My previous remark still stands: this is not really PSCI.

Sorry, no.  Your comment was for the HVC call, not the SMC.  You said
nothing about this one.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
