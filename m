From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v4 09/21] KVM: arm/arm64: mask/unmask daif around VHE
 guests
Date: Fri, 03 Nov 2017 17:19:40 +0000
Message-ID: <59FCA52C.1070406@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
 <20171019145807.23251-10-james.morse@arm.com> <20171030074019.GS2166@lvm>
 <59FB0C24.7080503@arm.com> <20171103124502.GB14144@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA1049D32
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 13:19:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kVBfCOtj9+B6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Nov 2017 13:19:43 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD0140D25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Nov 2017 13:19:42 -0400 (EDT)
In-Reply-To: <20171103124502.GB14144@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 03/11/17 12:45, Christoffer Dall wrote:
> On Thu, Nov 02, 2017 at 12:14:28PM +0000, James Morse wrote:
>> On 30/10/17 07:40, Christoffer Dall wrote:
>>> On Thu, Oct 19, 2017 at 03:57:55PM +0100, James Morse wrote:
>>>> Non-VHE systems take an exception to EL2 in order to world-switch into the
>>>> guest. When returning from the guest KVM implicitly restores the DAIF
>>>> flags when it returns to the kernel at EL1.
>>>>
>>>> With VHE none of this exception-level jumping happens, so KVMs
>>>> world-switch code is exposed to the host kernel's DAIF values, and KVM
>>>> spills the guest-exit DAIF values back into the host kernel.
>>>> On entry to a guest we have Debug and SError exceptions unmasked, KVM
>>>> has switched VBAR but isn't prepared to handle these. On guest exit
>>>> Debug exceptions are left disabled once we return to the host and will
>>>> stay this way until we enter user space.


>>>> Give me a kick if you want this reworked as a fix (which will then
>>>> conflict with this series), or a backportable version.
>>>
>>> I don't know of any real-world issues where some more graceful handling
>>> of SErrors would make sense on older kernels, so I'm fine with just
>>> merging this together with this series.
>>
>> What about debug?

> Are we unmasking debug exceptions as we should with this patch?

With this patch, yes, it directly restores the DAIF flags the arch code wants
for irq-masked process-context. Debug is re-enabled.


> If so, I suppose that could be required for something like kgdb or when
> running KVM as a guest hypervisor (nested).
> 
> In that case, we should probably provide a backport for stable, if we
> think people are going to be running older kernels on VHE systems, which
> they probably are.

Okay, I will produce a backport once this gets merged.


>>> On guest exit Debug exceptions are left disabled once we return to the host
>>> and will stay this way until we enter user space.

> [The indentation seems to indicate I wrote this, but I don't think I
> did.  I'm confused.]

I quoted it from the commit message, but evidently not from this depth-of-reply.
Sorry for the confusion.


>> Today VHE:KVM causes the kernel to run with SError unmasked and debug disabled
>> until the next return to user-space, whereas previously the kernel expected
>> SError to be masked and debug enabled.
>>
>>
>> (Reposting just the SError rework without this patch changes the kernel to
>> expect SError to be unmasked, which isn't making this any worse.)

> I'm sorry, I don't understand this discussion.  What is today, and what

English has failed me. I'll try again:

v4.14-rc7 with VHE causes the kernel to run after guest-exit with SError
unmasked and debug disabled until the next return to user-space.

The arch code expects SError masked and debug enabled.

In your kgdb example, if we switch-to a new task instead of returning to user
space, it won't hit any break/watchpoints.


> is previously, and are you suggesting we drop this patch, or that the
> rest of this series is somehow going to be applied without this patch?

I reposted just the SError rework, patches 1-10 without this patch.

If merged, this would change the arch code to expect SError to be unmasked from
process context, leaving just the debug disabled after VHE guest-exit.

I was (hurriedly) trying to work out if reposting the SError-rework without this
patch made the situation worse.


Sorry for the confusion!

James



> Reset: I think this patch is fine in the context of this series..  I now
> have no idea what we need to do in terms of older kernels.
> 
> Thanks,
> -Christoffer
> 
