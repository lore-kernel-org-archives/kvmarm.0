From: Antonios Motakis <antonios.motakis@huawei.com>
Subject: Re: [PATCH 00/13] arm64: Virtualization Host Extension support
Date: Wed, 26 Aug 2015 13:16:52 +0200
Message-ID: <55DDA024.8040303@huawei.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com> <55DD82FB.60903@huawei.com> <55DD851B.4040106@siemens.com> <55DD8DEF.9080301@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55DD8DEF.9080301@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Jan Kiszka <jan.kiszka@siemens.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Claudio Fontana <claudio.fontana@huawei.com>, jani.kokkonen@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 26-Aug-15 11:59, Marc Zyngier wrote:
> On 26/08/15 10:21, Jan Kiszka wrote:
>> On 2015-08-26 11:12, Antonios Motakis wrote:
>>> Hello Marc,
>>>
>>> On 08-Jul-15 18:19, Marc Zyngier wrote:
>>>> ARMv8.1 comes with the "Virtualization Host Extension" (VHE for=20
>>>> short), which enables simpler support of Type-2 hypervisors.
>>>>
>>>> This extension allows the kernel to directly run at EL2, and=20
>>>> significantly reduces the number of system registers shared
>>>> between host and guest, reducing the overhead of virtualization.
>>>>
>>>> In order to have the same kernel binary running on all versions
>>>> of the architecture, this series makes heavy use of runtime code
>>>> patching.
>>>>
>>>> The first ten patches massage the KVM code to deal with VHE and
>>>> enable Linux to run at EL2.
>>>
>>> I am currently working on getting the Jailhouse hypervisor to work
>>> on AArch64.
>>>
>>> I've been looking at your patches, trying to figure out the
>>> implications for Jailhouse. It seems there are a few :)
>>>
>>> Jailhouse likes to be loaded by Linux into memory, and then to
>>> inject itself at a higher level than Linux (demoting Linux into
>>> being the "root cell"). This works on x86 and ARM (AArch32 and
>>> eventually AArch64 without VHE). What this means in ARM, is that
>>> Jailhouse hooks into the HVC stub exposed by Linux, and happily
>>> installs itself in EL2.
>>>
>>> With Linux running in EL2 though, that won't be as straightforward.
>>> It looks like we can't just demote Linux to EL1 without breaking
>>> something. Obviously it's OK for us that KVM won't work, but it
>>> looks like at least the timer code will break horribly if we try to
>>> do something like that.
>>>
>>> Any comments on this? One work around would be to just remap the
>>> incoming interrupt from the timer, so Linux never really realizes
>>> it's not running in EL2 anymore. Then we would also have to deal
>>> with the intricacies of removing and re-adding vCPUs to the Linux
>>> root cell, so we would have to maintain the illusion of running in
>>> EL2 for each one of them.
>=20
> Unfortunately, there is more to downgrading to EL1 than just interrup=
ts.
> You need to migrate the whole VM context from EL2 to EL1 in an atomic
> fashion, clear the HCR_EL2.E2H and HCR_EL2.TGE bits while running at =
EL2
> (which is a bit like pulling the rug from under your own feet so you
> need to transition via a low mapping or an idmap), reinstall the EL2
> stub and do an exception return into EL1.

When enabling Jailhouse, we already do most of that. We already use ide=
ntity mapping, since we need to switch on the MMU for EL2, switch the e=
xception level, etc. Jailhouse entry looks a lot like initializing a ne=
w kernel; we just save the state of what was running before it and rest=
ore it as the "root cell".

So I think we could handle the cpu context switch, with changes only in=
 the Jailhouse entry code. But then of course, Linux would be expecting=
 to be in EL2, while it is running in EL1, so we would have to emulate =
the differences in behavior. But...

>=20
> And that's only for the CPU. Downgrading to EL1 has other fun
> consequences at the system level (SMMUs listening to TLB traffic woul=
d
> need to be reconfigured on the flight - it's a joke, don't even think=
 of
> it).

=2E..but then there's that.

Hm... even if the kernel is running in EL2, it will still be configurin=
g stage 1 on the SMMU, no? I wonder if this could still be handled some=
how... The root cell would be restored with identity mapping, too... Ju=
st thinking out loud :)

>=20
>>
>> Without knowing any of the details, I would say there are two
>> strategies regarding this:
>>
>> - Disable KVM support in the Linux kernel - then we shouldn't boot
>> into EL2 in the first place, should we?
>=20
> Disabling KVM support won't drop the kernel to EL1. At least that's n=
ot
> what the current code does (we stay at EL2 if we detect VHE), and tha=
t's
> way too early to be able to parse a command line option.
>=20
>> - Emulate what Linux is missing after take-over by Jailhouse (we do=20
>> this on x86 with VT-d interrupt remapping which cannot be disabled=20
>> anymore for Linux once it started with it, and we cannot boot
>> without it when we want to use the x2APIC).
>=20
> I can't really see what you want to emulate (I'm afraid I'm lacking t=
he
> x86-specific background).
>=20
> As far as I can see, the only practical solution to this is to have a
> VHE config option, and Jailhouse that can be set to conflict it (depe=
nds
> on !VHE).

Having a toggle to turn VHE off at build time would definitely be the e=
asy way out. Then we can just tell the user that we only support kernel=
s built without it (the Jailhouse driver is out of tree atm).

I don't have access to a VHE model though. Are you considering to add a=
 config option for VHE in the next version of your patches?

In any case thanks for your thoughts,

--=20
Antonios Motakis
Virtualization Engineer
Huawei Technologies Duesseldorf GmbH
European Research Center
Riesstrasse 25, 80992 M=FCnchen
