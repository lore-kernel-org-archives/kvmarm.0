From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] help guest boot up on AArch64 host with GICv2
Date: Mon, 18 Jan 2016 09:28:20 +0000
Message-ID: <569CB034.1060307@arm.com>
References: <56995068.9050207@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37EED4130A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2016 04:24:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pvhm-HujEqGn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2016 04:23:59 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08A84412A6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2016 04:23:58 -0500 (EST)
In-Reply-To: <56995068.9050207@ezchip.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Chris Metcalf <cmetcalf@ezchip.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Chris,

On 15/01/16 20:02, Chris Metcalf wrote:
> We are using GICv2 compatibility mode in the Fast Models/Foundation 
> Models simulations we are running because the boot code (ATF/UEFI) 
> doesn't support GICv3 in our system at the moment.
> 
> However, starting with kernel 4.2, the guest couldn't boot up because it 
> wasn't getting timer interrupts.  I tracked this down to a kernel commit 
> that switched to using the "alternatives" mechanism -- rather than 
> seeing either a GICv2 or GICv3 and configuring appropriately, the KVM 
> code just configured the code that saves/restores the vgic state based 
> on the presence of the system register interface to the GIC CPU 
> interface.  See the attached patch for a fix that manages this 
> differently and allows me to boot up the guest in this configuration.
> 
> However, even assuming this patch can be taken into an upstream tree, I 
> still have a couple of additional problems:
> 
> - I can boot up with the Foundation Models using this change, but not 
> with the Fast Models (again, using a v3 GIC but in v2 compatibility mode 
> in the device tree).  The Fast Models dts looks like it has the same 
> configuration for the GIC and the timers so I'm not sure what's going on 
> here.  Any suggestions appreciated.
> 
> - Without this change, I could only boot kernels up to 4.1.  With the 
> change, I can boot kernels up to 4.3.  But 4.4 won't boot for me either; 
> I haven't bisected it down yet.  So any suggestions on what might be 
> going wrong here would also be appreciated.
> 
> We are planning to eventually use GICv3 mode in our software stack but 
> for the time being I assume it is interesting to resolve issues with GIC 
> v2 compatibility mode on GIC v3.
> 

I'm afraid that this is the wrong approach. Whilst 4.2 was a bit too
eager to use GICv3 (only checking the CPU capability and ignoring the
actual state of the EL2/EL3 SRE bits), the fact that 4.4 doesn't boot is
probably the sign of a broken firmware that enables the system register
interface at EL3, letting the rest of the software stack to use GICv3 in
native mode, and yet providing a GICv2 DT.

This combination is unpredictable, and is likely to  cause issues on
some HW implementations.

Could you please point me to the firmware you're using?

Also, please check the following patches:

6d32ab2 arm64: Update booting requirements for GICv3 in GICv2 mode
76e52dd irqchip/gic: Warn if GICv3 system registers are enabled
963fcd4 arm64: cpufeatures: Check ICC_EL1_SRE.SRE before enabling
ARM64_HAS_SYSREG_GIC_CPUIF
7cabd00 irqchip/gic-v3: Make gic_enable_sre an inline function
d271976 arm64: el2_setup: Make sure ICC_SRE_EL2.SRE sticks before using
GICv3 sysregs

Can you point me to the one that prevents you from booting?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
