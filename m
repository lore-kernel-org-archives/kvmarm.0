From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] help guest boot up on AArch64 host with GICv2
Date: Wed, 27 Jan 2016 09:12:46 +0000
Message-ID: <56A88A0E.40002@arm.com>
References: <56995068.9050207@ezchip.com> <569CB034.1060307@arm.com>
 <56A7DA7C.8090202@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 744E740C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2016 04:07:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yiTScVaIRQnG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2016 04:07:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 218F440F90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2016 04:07:51 -0500 (EST)
In-Reply-To: <56A7DA7C.8090202@ezchip.com>
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

On 26/01/16 20:43, Chris Metcalf wrote:
> On 01/18/2016 04:28 AM, Marc Zyngier wrote:
>> Hi Chris,
>>
>> On 15/01/16 20:02, Chris Metcalf wrote:
>>> We are using GICv2 compatibility mode in the Fast Models/Foundation
>>> Models simulations we are running because the boot code (ATF/UEFI)
>>> doesn't support GICv3 in our system at the moment.
>>>
>>> However, starting with kernel 4.2, the guest couldn't boot up because it
>>> wasn't getting timer interrupts.  I tracked this down to a kernel commit
>>> that switched to using the "alternatives" mechanism -- rather than
>>> seeing either a GICv2 or GICv3 and configuring appropriately, the KVM
>>> code just configured the code that saves/restores the vgic state based
>>> on the presence of the system register interface to the GIC CPU
>>> interface.  See the attached patch for a fix that manages this
>>> differently and allows me to boot up the guest in this configuration.
>>>
>>> However, even assuming this patch can be taken into an upstream tree, I
>>> still have a couple of additional problems:
>>>
>>> - I can boot up with the Foundation Models using this change, but not
>>> with the Fast Models (again, using a v3 GIC but in v2 compatibility mode
>>> in the device tree).  The Fast Models dts looks like it has the same
>>> configuration for the GIC and the timers so I'm not sure what's going on
>>> here.  Any suggestions appreciated.
>>>
>>> - Without this change, I could only boot kernels up to 4.1.  With the
>>> change, I can boot kernels up to 4.3.  But 4.4 won't boot for me either;
>>> I haven't bisected it down yet.  So any suggestions on what might be
>>> going wrong here would also be appreciated.
>>>
>>> We are planning to eventually use GICv3 mode in our software stack but
>>> for the time being I assume it is interesting to resolve issues with GIC
>>> v2 compatibility mode on GIC v3.
>>>
>> I'm afraid that this is the wrong approach. Whilst 4.2 was a bit too
>> eager to use GICv3 (only checking the CPU capability and ignoring the
>> actual state of the EL2/EL3 SRE bits), the fact that 4.4 doesn't boot is
>> probably the sign of a broken firmware that enables the system register
>> interface at EL3, letting the rest of the software stack to use GICv3 in
>> native mode, and yet providing a GICv2 DT.
>>
>> This combination is unpredictable, and is likely to  cause issues on
>> some HW implementations.
>>
>> Could you please point me to the firmware you're using?
>>
>> Also, please check the following patches:
>>
>> 6d32ab2 arm64: Update booting requirements for GICv3 in GICv2 mode
>> 76e52dd irqchip/gic: Warn if GICv3 system registers are enabled
>> 963fcd4 arm64: cpufeatures: Check ICC_EL1_SRE.SRE before enabling
>> ARM64_HAS_SYSREG_GIC_CPUIF
>> 7cabd00 irqchip/gic-v3: Make gic_enable_sre an inline function
>> d271976 arm64: el2_setup: Make sure ICC_SRE_EL2.SRE sticks before using
>> GICv3 sysregs
>>
>> Can you point me to the one that prevents you from booting?
> 
> The problematic commit is 963fcd4, because it calls gic_enable_sre()
> in the host kernel even with a GICv2 DT specified, and this seems to
> put things in a state such that we don't receive virtual timer
> interrupts in the guest when we boot it up.  (I'm not that familiar with
> the QEMU DT but it is providing a GIC v2 to the guest.)
> 
> With a v4.5-rc1 host, if I "return false" before the code in gic_enable_sre()
> that tries to actually enable the SRE, and then hardcode the
> __vgic_v2_XXX_state() save/restore calls into the __vgic_XXX_state()
> routines, then my guest boots up OK.

What if you just do the "return false"? I bet that it will work as well...

> We are using a modified ARM version of EDK v3.0-rc0, and a modified
> ARM Trusted Firmware based on commit 963fcd4 (between v1.1 and 1.2).

Are you sure of that commit? It looks suspiciously like the ID ftom the
kernel tree...

> We certainly haven't touched any of the GIC code in either one.
> 
> I tried to modify the host DT to enable GICv3, but then the host itself
> hangs on boot, so clearly more is needed.  (To be fair I've only tested
> v4.4 in that configuration, not v4.5-rc1.)  The firmware isn't yet using
> GICv3 so perhaps that is part of the problem.

That's indeed part of the problem. The firmware running at EL3 insists
on using GICv2, but still let EL2 (and EL1) use GICv3 system registers.
Could you please dump the content of ICC_SRE_EL3 just before entering
the kernel at EL2? If you see ICC_SRE_EL3.SRE being set, then this would
indicate a firmware bug (and leave the system in an unpredictable
configuration).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
