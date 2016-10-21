From: Auger Eric <eric.auger@redhat.com>
Subject: Re: v4.9-rc1 fails booting as a guest on ARM64 Cavium ThunderX
Date: Fri, 21 Oct 2016 11:46:04 +0200
Message-ID: <e52f2867-102f-8aad-4815-2a682586f129@redhat.com>
References: <924fd627-329a-54e0-694c-a9bdf979f696@redhat.com>
 <de2acaca-f694-be1a-5d2c-93fcf3b25011@arm.com>
 <99c7d3b5-0495-083f-b4b7-b58b20cf859e@redhat.com>
 <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A58B49B2C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:35:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6CY21nJ6Y0+L for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Oct 2016 05:35:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C29849B1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Oct 2016 05:35:40 -0400 (EDT)
In-Reply-To: <5a5e4ed5-a575-f720-36f0-acb545a170f4@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Robert Richter <robert.richter@caviumnetworks.com>, daniel.thompson@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 21/10/2016 11:40, Marc Zyngier wrote:
> On 21/10/16 10:05, Auger Eric wrote:
>> Hi Marc,
>>
>> On 21/10/2016 10:45, Marc Zyngier wrote:
>>> +Robert
>>>
>>> On 21/10/16 08:01, Auger Eric wrote:
>>>> Hi,
>>>>
>>>> I am not able to boot 4.9-rc1 as a guest on Cavium ThunderX (dt and acpi
>>>> mode). Bisecting the guest shows that the problem shows up at
>>>>
>>>> 91ef84428a86b75a52e15c6fe4f56b446ba75f93
>>>> irqchip/gic-v3: Reset BPR during initialization
>>>>
>>>> If I remove the write to the ICC_BPR1_EL1 register on guest, the VM boots.
>>>
>>> That's very odd. A ICC_BPR1_EL1 access when HCR_EL2.IMO is set only
>>> affects ICH_VMCR_EL2.VBPR1. It is not trapped, since we don't set
>>> ICH_HCR_EL2.TALL1. It is a very boring sysreg!
>>>
>>> So from a pure architectural point of view, I don't see how this can
>>> fail. I've just run the same configuration on my Freescale board (GICv3
>>> as well), and can't see any issue at all.
>>>
>>>> Investigating KVM code ...
>>>
>>> What is the failure syndrome? Do you see it crashing? Locking up? What
>>> is the PC at that stage?
>> No guest crash. the guest just locks up. No traces output.
> 
> But you're able to kill the guest, right,
Yes I am
 and the CPU is not going to
> lalaland. We should be able to put a breakpoint on this instruction
> using qemu + GDB, and step it to find out what's happening. Or even
> execute the instruction in isolation with a bunch of printks in the guest.
Yep I will investigate this afternoon.

Thanks

Eric
> 
> 	M.
> 
