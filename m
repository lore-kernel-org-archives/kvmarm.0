From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 00/13] arm64: Virtualization Host Extension support
Date: Wed, 26 Aug 2015 11:54:38 +0200
Message-ID: <55DD8CDE.8000407@siemens.com>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <55DD82FB.60903@huawei.com> <55DD851B.4040106@siemens.com>
 <55DD86CF.70309@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB58D431E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2015 05:54:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sZ6Rass0F+vb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Aug 2015 05:54:46 -0400 (EDT)
Received: from goliath.siemens.de (goliath.siemens.de [192.35.17.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7344B41487
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2015 05:54:46 -0400 (EDT)
In-Reply-To: <55DD86CF.70309@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Antonios Motakis <antonios.motakis@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jani.kokkonen@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 2015-08-26 11:28, Antonios Motakis wrote:
> 
> 
> On 26-Aug-15 11:21, Jan Kiszka wrote:
>> On 2015-08-26 11:12, Antonios Motakis wrote:
>>> Hello Marc,
>>>
>>> On 08-Jul-15 18:19, Marc Zyngier wrote:
>>>> ARMv8.1 comes with the "Virtualization Host Extension" (VHE for
>>>> short), which enables simpler support of Type-2 hypervisors.
>>>>
>>>> This extension allows the kernel to directly run at EL2, and
>>>> significantly reduces the number of system registers shared between
>>>> host and guest, reducing the overhead of virtualization.
>>>>
>>>> In order to have the same kernel binary running on all versions of the
>>>> architecture, this series makes heavy use of runtime code patching.
>>>>
>>>> The first ten patches massage the KVM code to deal with VHE and enable
>>>> Linux to run at EL2.
>>>
>>> I am currently working on getting the Jailhouse hypervisor to work on AArch64.
>>>
>>> I've been looking at your patches, trying to figure out the implications for Jailhouse. It seems there are a few :)
>>>
>>> Jailhouse likes to be loaded by Linux into memory, and then to inject itself at a higher level than Linux (demoting Linux into being the "root cell"). This works on x86 and ARM (AArch32 and eventually AArch64 without VHE). What this means in ARM, is that Jailhouse hooks into the HVC stub exposed by Linux, and happily installs itself in EL2.
>>>
>>> With Linux running in EL2 though, that won't be as straightforward. It looks like we can't just demote Linux to EL1 without breaking something. Obviously it's OK for us that KVM won't work, but it looks like at least the timer code will break horribly if we try to do something like that.
>>>
>>> Any comments on this? One work around would be to just remap the incoming interrupt from the timer, so Linux never really realizes it's not running in EL2 anymore. Then we would also have to deal with the intricacies of removing and re-adding vCPUs to the Linux root cell, so we would have to maintain the illusion of running in EL2 for each one of them.
>>
>> Without knowing any of the details, I would say there are two strategies
>> regarding this:
>>
>> - Disable KVM support in the Linux kernel - then we shouldn't boot into
>>   EL2 in the first place, should we?
> 
> We would have to ask the user to patch the kernel, to ignore VHE and keep all the hyp stub magic that we rely on currently. It is an option of course.

Patch or reconfigure? CONFIG_KVM isn't mandatory for arm64, is it?

Jan

> 
>>
>> - Emulate what Linux is missing after take-over by Jailhouse (we do
>>   this on x86 with VT-d interrupt remapping which cannot be disabled
>>   anymore for Linux once it started with it, and we cannot boot without
>>   it when we want to use the x2APIC).
> 
> Essentially what I described above; let's call it nested virtualization without the virtualization parts? :)
> 
>>
>> Jan
>>
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
