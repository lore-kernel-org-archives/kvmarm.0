From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 00/23] arm64: Virtualization Host Extension support
Date: Mon, 15 Feb 2016 10:34:18 +0000
Message-ID: <56C1A9AA.9040504@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
 <20160211190701.GA4842@cbox> <56BCDCBA.5080202@arm.com>
 <20160215102324.GD13683@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56280496E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Feb 2016 05:28:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OSKWUPUJjwNq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Feb 2016 05:28:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20803496C2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Feb 2016 05:28:11 -0500 (EST)
In-Reply-To: <20160215102324.GD13683@e104818-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 15/02/16 10:23, Catalin Marinas wrote:
> On Thu, Feb 11, 2016 at 07:10:50PM +0000, Marc Zyngier wrote:
>> On 11/02/16 19:07, Christoffer Dall wrote:
>>> On Thu, Feb 11, 2016 at 06:39:41PM +0000, Marc Zyngier wrote:
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
>>>> The first 22 patches massage the KVM code to deal with VHE and enable
>>>> Linux to run at EL2. The last patch catches an ugly case when VHE
>>>> capable CPUs are paired with some of their less capable siblings. This
>>>> should never happen, but hey...
>>>>
>>>> I have deliberately left out some of the more "advanced"
>>>> optimizations, as they are likely to distract the reviewer from the
>>>> core infrastructure, which is what I care about at the moment.
>>>>
>>>> Note: GDB is currently busted on VHE systems, as it checks for version
>>>>       6 on the debug architecture, while VHE is version 7. The
>>>>       binutils people are on the case.
>>>>
>>>> This has been tested on the FVP_Base_SLV-V8-A model, and based on
>>>> v4.5-rc3 + kvmarm/master. I've put a branch out on:
>>>>
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/vhe
>>>
>>> I'm happy with this series as it stands, we just need someone to take a
>>> look at that debug patch and be happy with it.
>>
>> I think Will is planning to have a go at it shortly. Once he and Catalin
>> are happy with the thing, I'll throw it into -next for a good shake.
> 
> Fine by me but it would be good for Will to have a look, especially on
> the debug and perf stuff.

Definitely. To make it clear, I do not intend to put anything in -next
until all the relevant people has reviewed it, and at least given their Ack.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
