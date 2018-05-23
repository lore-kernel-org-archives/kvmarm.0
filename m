From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 09/14] ARM: spectre-v2: add PSCI based hardening
Date: Wed, 23 May 2018 20:45:04 +0100
Message-ID: <20180523194503.GX17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <E1fKjFT-00064F-Bs@rmk-PC.armlinux.org.uk>
 <35edb3df-fed4-b6e6-be0c-ee758618c92e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8254A0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 May 2018 15:35:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OhdOIH4N0Ts7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 May 2018 15:34:44 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7496A4A0C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 May 2018 15:34:44 -0400 (EDT)
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

Okay, so digging further into the documentation seems to suggest that we
only need to check the firmware for A72 and A57 CPUs, and given this
statement:

"Arm recommends that the caller only call this on PEs for which a
 firmware based mitigation of CVE-2017-5715 is required, or where
 a local workaround is infeasible."

it seems that the right answer is to ignore the PSCI based methods when
we have anything but these CPUs.  Do you agree?

> But that's probably moot if you don't support BL systems.

Any bL systems with A72 or A57?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
