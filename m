From: James Morse <james.morse@arm.com>
Subject: Re: =?gbk?Q?=B4=F0=B8=B4=3A_=5BPATCH_v6_4/7=5D_arm64=3A_?=
 =?gbk?Q?kvm=3A_support_user_space_to_query_RAS_extension_?=
 =?gbk?Q?feature?=
Date: Thu, 14 Sep 2017 13:38:52 +0100
Message-ID: <59BA785C.40504@arm.com>
References: <1503916701-13516-1-git-send-email-gengdongjiu@huawei.com>
 <1503916701-13516-5-git-send-email-gengdongjiu@huawei.com>
 <59A84F9D.8030309@arm.com> <29951852-8d91-7c33-c68b-ad8b4bbdea54@huawei.com>
 <59B1747A.5030909@arm.com>
 <0184EA26B2509940AA629AE1405DD7F2015F61EA@DGGEMA503-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FDA49C19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 08:37:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zliE3jgXv8p8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Sep 2017 08:37:48 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53CAC40FAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 08:37:48 -0400 (EDT)
In-Reply-To: <0184EA26B2509940AA629AE1405DD7F2015F61EA@DGGEMA503-MBX.china.huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: "Wangkefeng (Kevin)" <wangkefeng.wang@huawei.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "david.daney@cavium.com" <david.daney@cavium.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "tbaicar@codeaurora.org" <tbaicar@codeaurora.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Linuxarm <linuxarm@huawei.com>, "robert.moore@intel.com" <robert.moore@intel.com>, "lv.zheng@intel.com" <lv.zheng@intel.com>, "zjzhang@codeaurora.org" <zjzhang@codeaurora.org>, "mingo@kernel.org" <mingo@kernel.org>, "stefan@hello-penguin.com" <stefan@hello-penguin.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Huangshaoyu <huangshaoyu@huawei.com>, huangdaode <huangdaode@hisilicon.com>, "bp@suse.de" <bp@suse.de>, "Dave.Martin@arm.com" <Dave.Martin@ar>
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 08/09/17 18:36, gengdongjiu wrote:
>> The code to signal memory-failure to user-space doesn't depend on the CPU's RAS-extensions.
> I roughly check your answer and agree with your general idea.
> late I will check it in detail.

> I have a question, do you sure that if CPU does not support RAS-extensions kernel can still call
> memory-failure() to send signal to qemu?

If CONFIG_MEMORY_FAILURE is selected then the kernel has the code to send
SIGBUS_MCCERR_A* signals to user space.
This can be triggered by any GHES. A case in point: the 'AMD Seattle Overdrive'
under my desk has a HEST with four polled GHES entries. If any of these generate
a memory error the kernel will trigger the memory_failure() code.

Without all the ACPI stuff we still have CONFIG_HWPOISON_INJECT,
madvise(MADV_HWPOISON).
sysfs's: 'soft_offline_page' and 'hard_offline_page' as mechanisms that may
trigger memory_failure().

User space shouldn't try and guess whether its likely to get one of these.

I've been using these mechanisms to test SDEI virtualisation with kvmtool.


> After my checking the code, the general flow is RAS module detects the error or CPU consumes the
> hardware poison data, happen exception, then EL3 firmware records the address
to APEI table and
> send notification to kernel. Kernel parses the APEI table to get address and
call memory_failure() to
> identify the page to poison. That is to say, usually, after RAS detect the
error, it call memory_failure(),
> otherwise, it does not know whether this address is poison.

> I am worried about one thing, if hardware does not has RAS, OS cannot know which address is poison,
> so it cannot identify the address , then the address that is delivered to
Qemu(user space) may not right.

You've switched from talking about the CPU's 'ARM v8.2 RAS extensions' to 'RAS'.
Supporting memory_failure() is a linux:RAS feature, it doesn't depend on the
cpu:'ARM v8.2 RAS extensions'.

> As you said, kernel can also call memory_failure() even without RAS support. in this without RAS case,
> how it consider the address is poison and needs to send SIGBUS to QEMU?

Which component doesn't have RAS? The CPU? Okay, what about the memory controller:
The memory controller may catch a parity error during dram refresh/scrub, and
signal firmware via an interrupt. Firmware can then read the affected address
from the memory-controller's error registers and report it to the OS as a
firmware-first error.
The CPU doesn't need any RAS features for this to work.

To caricature your argument: 'the CPU doesn't have this particular version of
this particular RAS feature, thus no component in the system has any RAS feature'.

APEI's firmware-first is an abstraction so that we don't need to know which
system components have RAS features (or how to drive them) , we let firmware do
the work and tell us the results.


>> If Qemu supports notifying the guest about RAS errors using CPER records, it should generate a HEST describing firmware first. It can then
>> choose the notification methods, some of which may require optional KVM APIs to support.
>>
>> Seattle has a HEST, it doesn't support the CPU RAS-extensions. The kernel can notify user-space about memory_failure() on this machine. I
>> would expect Qemu to be able to receive signals and describe memory errors to a guest (1).
> 
> Usually we consider the address got from APEI table is poison. If so, I want to know, without RAS and APEI table, how it identify the address to hwpoison?

~s/APEI/CPER/

I agree the main path into memory_failure() is from APEI, and we get the address
from the CPER records. This isn't the only path into memory_failure, and there
may be more in the future.
None of the firmware-first stuff depends on CPU RAS features, it may be
reporting errors from some other component in the system.

Back to the issue at hand: should qemu/kvmtool generate a HEST?
If these tools want to inject emulated errors into a guest: yes. (this may be
totally independent of what the host supports)
If these tools want to pass memory-failure notifications for guest-memory into a
guest: yes.
You may want to make this depend on whether the host supports memory-failure
notifications, but you  shouldn't care where they come from.

Does the host support memory-failure notifications?
You can poke around in /proc to find this out, /proc/sys/vm has:
> memory_failure_early_kill
> memory_failure_recovery
when the kernel was built with CONFIG_MEMORY_FAILURE, but it user-space has
support for this stuff I don't know why you wouldn't unconditionally turn it on.
(what happens if you migrate between hosts with different support...)


James
