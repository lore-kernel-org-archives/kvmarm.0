From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH] help guest boot up on AArch64 host with GICv2
Date: Fri, 29 Jan 2016 12:49:25 -0500
Message-ID: <56ABA625.3020300@ezchip.com>
References: <56995068.9050207@ezchip.com> <569CB034.1060307@arm.com>
 <56A7DA7C.8090202@ezchip.com> <56A88A0E.40002@arm.com>
 <56AA7618.8030406@ezchip.com>
 <CAKv+Gu-FpPfGg7mdGy6w00CcMiqVo1K84R1ayxMp6W_1rROfMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D545A407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 12:44:35 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sK3q3GOzOKbo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Jan 2016 12:44:33 -0500 (EST)
Received: from emea01-am1-obe.outbound.protection.outlook.com
 (mail-am1on0069.outbound.protection.outlook.com [157.56.112.69])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79F4C40402
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Jan 2016 12:44:33 -0500 (EST)
In-Reply-To: <CAKv+Gu-FpPfGg7mdGy6w00CcMiqVo1K84R1ayxMp6W_1rROfMw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/29/2016 02:24 AM, Ard Biesheuvel wrote:
> On 28 January 2016 at 21:12, Chris Metcalf <cmetcalf@ezchip.com> wrote:
>> On 01/27/2016 04:12 AM, Marc Zyngier wrote:
>>> On 26/01/16 20:43, Chris Metcalf wrote:
>>>> On 01/18/2016 04:28 AM, Marc Zyngier wrote:
>>>>> Hi Chris,
>>>>>
>>>>> On 15/01/16 20:02, Chris Metcalf wrote:
>>>>>> We are using GICv2 compatibility mode in the Fast Models/Foundation
>>>>>> Models simulations we are running because the boot code (ATF/UEFI)
>>>>>> doesn't support GICv3 in our system at the moment.
>>>>>>
>>>>>> However, starting with kernel 4.2, the guest couldn't boot up because
>>>>>> it
>>>>>> wasn't getting timer interrupts.  I tracked this down to a kernel
>>>>>> commit
>>>>>> that switched to using the "alternatives" mechanism -- rather than
>>>>>> seeing either a GICv2 or GICv3 and configuring appropriately, the KVM
>>>>>> code just configured the code that saves/restores the vgic state based
>>>>>> on the presence of the system register interface to the GIC CPU
>>>>>> interface.  See the attached patch for a fix that manages this
>>>>>> differently and allows me to boot up the guest in this configuration.
>>>>>>
>>>>>> However, even assuming this patch can be taken into an upstream tree, I
>>>>>> still have a couple of additional problems:
>>>>>>
>>>>>> - I can boot up with the Foundation Models using this change, but not
>>>>>> with the Fast Models (again, using a v3 GIC but in v2 compatibility
>>>>>> mode
>>>>>> in the device tree).  The Fast Models dts looks like it has the same
>>>>>> configuration for the GIC and the timers so I'm not sure what's going
>>>>>> on
>>>>>> here.  Any suggestions appreciated.
>>>>>>
>>>>>> - Without this change, I could only boot kernels up to 4.1.  With the
>>>>>> change, I can boot kernels up to 4.3.  But 4.4 won't boot for me
>>>>>> either;
>>>>>> I haven't bisected it down yet.  So any suggestions on what might be
>>>>>> going wrong here would also be appreciated.
>>>>>>
>>>>>> We are planning to eventually use GICv3 mode in our software stack but
>>>>>> for the time being I assume it is interesting to resolve issues with
>>>>>> GIC
>>>>>> v2 compatibility mode on GIC v3.
>>>>>>
>>>>> I'm afraid that this is the wrong approach. Whilst 4.2 was a bit too
>>>>> eager to use GICv3 (only checking the CPU capability and ignoring the
>>>>> actual state of the EL2/EL3 SRE bits), the fact that 4.4 doesn't boot is
>>>>> probably the sign of a broken firmware that enables the system register
>>>>> interface at EL3, letting the rest of the software stack to use GICv3 in
>>>>> native mode, and yet providing a GICv2 DT.
>>>>>
>>>>> This combination is unpredictable, and is likely to  cause issues on
>>>>> some HW implementations.
>>>>>
>>>>> Could you please point me to the firmware you're using?
>>>>>
>>>>> Also, please check the following patches:
>>>>>
>>>>> 6d32ab2 arm64: Update booting requirements for GICv3 in GICv2 mode
>>>>> 76e52dd irqchip/gic: Warn if GICv3 system registers are enabled
>>>>> 963fcd4 arm64: cpufeatures: Check ICC_EL1_SRE.SRE before enabling
>>>>> ARM64_HAS_SYSREG_GIC_CPUIF
>>>>> 7cabd00 irqchip/gic-v3: Make gic_enable_sre an inline function
>>>>> d271976 arm64: el2_setup: Make sure ICC_SRE_EL2.SRE sticks before using
>>>>> GICv3 sysregs
>>>>>
>>>>> Can you point me to the one that prevents you from booting?
>>>> The problematic commit is 963fcd4, because it calls gic_enable_sre()
>>>> in the host kernel even with a GICv2 DT specified, and this seems to
>>>> put things in a state such that we don't receive virtual timer
>>>> interrupts in the guest when we boot it up.  (I'm not that familiar with
>>>> the QEMU DT but it is providing a GIC v2 to the guest.)
>>>>
>>>> With a v4.5-rc1 host, if I "return false" before the code in
>>>> gic_enable_sre()
>>>> that tries to actually enable the SRE, and then hardcode the
>>>> __vgic_v2_XXX_state() save/restore calls into the __vgic_XXX_state()
>>>> routines, then my guest boots up OK.
>>> What if you just do the "return false"? I bet that it will work as well...
>>
>> Yes, that also works for my case.
>>
>>>> We are using a modified ARM version of EDK v3.0-rc0, and a modified
>>>> ARM Trusted Firmware based on commit 963fcd4 (between v1.1 and 1.2).
>
> What does 'EDK v3.0-rc0' mean? We don't do any versioned releases afaik,

It's a git tag from the repo at git://github.com/ARM-software/edk2 .
In fact I'm not quite sure we are at that exact tag, since it seems like
some fixes present in v3.0-rc0 are missing from our code base.
But it's an early 2015 drop in any case.

> I recently fixed a GIC issue in the FVP EDK2 code, which prevented it
> from running the GICv3 in native mode rather than in GICv2
> compatibility mode.
>
> 33ed33f ArmPkg/ArmGic: fix bug in GICv3 distributor configuration

Looks like an alternate version of that fix is present in the ARM repo
as commit 152ac4, and we have that fix in our repo too.

>>>> We certainly haven't touched any of the GIC code in either one.
>>>>
>>>> I tried to modify the host DT to enable GICv3, but then the host itself
>>>> hangs on boot, so clearly more is needed.  (To be fair I've only tested
>>>> v4.4 in that configuration, not v4.5-rc1.)  The firmware isn't yet using
>>>> GICv3 so perhaps that is part of the problem.
>>> That's indeed part of the problem. The firmware running at EL3 insists
>>> on using GICv2, but still let EL2 (and EL1) use GICv3 system registers.
>>> Could you please dump the content of ICC_SRE_EL3 just before entering
>>> the kernel at EL2? If you see ICC_SRE_EL3.SRE being set, then this would
>>> indicate a firmware bug (and leave the system in an unpredictable
>>> configuration).
>>
>> Well, the firmware clearly does this intentionally.  In ATF's
>> drivers/arm/giv/arm_gic.c, the gicv3_cpuif_setup() function has
>> a comment that reads:
>>
>> /*******************************************************************************
>>   * This function does some minimal GICv3 configuration. The Firmware itself
>> does
>>   * not fully support GICv3 at this time and relies on GICv2 emulation as
>>   * provided by GICv3. This function allows software (like Linux) in later
>> stages
>>   * to use full GICv3 features.
>>
>> ******************************************************************************/
>>
> This is deliberate, since running the GIC in v3 mode on the secure
> side would remove the ability on the non-secure side to use the v2
> legacy mode. It does not limit the utility of the GICv3 on the
> non-secure side

It does seem that it conflicts with trying to use a GIC v2 in the DT
for tip Linux, though.

>> and the function ends with:
>>
>>          val = read_icc_sre_el3();
>>          write_icc_sre_el3(val | ICC_SRE_EN | ICC_SRE_SRE);
>>
>> In our build environment, if I comment out those two lines, that
>> fixes the guest boot problem (without any hacking on the Linux side),
>> so that's good anyway.  With this change it works for me in the
>> Fast Models as well as Foundation Models, too.
>>
> For historical reasons, the EDK2 GIC driver infers the presence of a
> GICv3 from the ability to use the system register interface, and
> ignores the ID registers completely. Without the patch above, or the
> PcdArmGicV3WithV2Legacy set, the symptoms you are seeing on the
> firmware side are not entirely unexpected.

I believe we do set PcdArmGicV3WithV2Legacy to TRUE for
our platform, but we did require my patch above in addition:

[PcdsFeatureFlag.common]

   # Force the UEFI GIC driver to use GICv2 legacy mode. To use
   # GICv3 without GICv2 legacy in UEFI, the ARM Trusted Firmware needs
   # to configure the Non-Secure interrupts in the GIC Redistributors
   # which is not supported at the moment.
   gArmTokenSpaceGuid.PcdArmGicV3WithV2Legacy|TRUE


> Also note that, on the
> Foundation model, the GICv2 and the GICv3 live at different memory
> addresses.

We have the GIC at different addresses in any case, but I will check
with our hardware folks to see if we should be using different
addresses if we try to use a GIC v3.  Thanks!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
