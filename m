Return-Path: <SRS0=oLPE=YY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6457BCA9ECB
	for <kvmarm@archiver.kernel.org>; Thu, 31 Oct 2019 13:07:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E9D0A2080F
	for <kvmarm@archiver.kernel.org>; Thu, 31 Oct 2019 13:07:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9D0A2080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 586E84AC65;
	Thu, 31 Oct 2019 09:07:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KkAVw-Xr5gYn; Thu, 31 Oct 2019 09:07:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05DC34AC66;
	Thu, 31 Oct 2019 09:07:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFDF64A98A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Oct 2019 09:07:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hjjfqPeSjAae for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Oct 2019 09:07:43 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 976A14A591
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Oct 2019 09:07:42 -0400 (EDT)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 1D02563FB0F6D69357FD;
 Thu, 31 Oct 2019 21:07:35 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Thu, 31 Oct 2019
 21:07:24 +0800
Subject: Re: [RFC PATCH 1/2] kvm/arm: add capability to forward hypercall to
 user space
To: James Morse <james.morse@arm.com>
References: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
 <1569338454-26202-2-git-send-email-guoheyi@huawei.com>
 <e097fb69-1e68-4082-d310-e7666e30b5d6@arm.com>
 <d62b84ac-1a7e-de05-a1c1-c52dfb463462@huawei.com>
 <22aa23e0-cd4e-3692-ee94-e110ace49adb@arm.com>
From: Guoheyi <guoheyi@huawei.com>
Message-ID: <4af47d1c-40cc-8440-d834-d721e1c0a758@huawei.com>
Date: Thu, 31 Oct 2019 21:07:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <22aa23e0-cd4e-3692-ee94-e110ace49adb@arm.com>
X-Originating-IP: [10.133.216.73]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin
 Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Sorry for the late, for it took some time for me to think it over...


On 2019/10/22 0:42, James Morse wrote:
> Hi Heyi,
>
> On 09/10/2019 13:33, Guoheyi wrote:
>> On 2019/10/2 1:19, James Morse wrote:
>>> On 24/09/2019 16:20, Heyi Guo wrote:
>>>> As more SMC/HVC usages emerge on arm64 platforms, like SDEI, it makes
>>>> sense for kvm to have the capability of forwarding such calls to user
>>>> space for further emulation.
>>> (what do you mean by further? Doesn't user-space have to do all of it?)
>> For kvm will always handle hvc/smc guest exit for the first step, even if it is only a
>> simple forwarding, I called the user-space processing as "further emulation".
>>
>>>> We reuse the existing term "hypercall" for SMC/HVC, as well as the
>>>> hypercall structure in kvm_run to exchange arguments and return
>>>> values. The definition on arm64 is as below:
>>>>
>>>> exit_reason: KVM_EXIT_HYPERCALL
>>>>
>>>> Input:
>>>>     nr: the immediate value of SMC/HVC calls; not really used today.
>>>>     args[6]: x0..x5 (This is not fully conform with SMCCC which requires
>>>>              x6 as argument as well, but use space can use GET_ONE_REG
>>>>              ioctl for such rare case).
>>> If this structure isn't right for us, we could define a different one for arm/arm64.
>>> (we did this for kvm_vcpu_events)
>> Do you mean that we can move the hypercall struct definition to arch specific kvm_host.h?
>> For it is in the common kvm_run structure, we'll need to change every kvm supported
>> architectures, including x86, mips, powerpc, s390. Is it acceptable?
> Ah! Sorry, I'd missed this was in the kvm_run structure. The get-events example doesn't
> apply here as that was a separate ioctl().
>
>
>>>> Return:
>>>>     args[0..3]: x0..x3 as defined in SMCCC. We need to extract
>>>>                 args[0..3] and write them to x0..x3 when hypercall exit
>>>>                 returns.
>>> Are we saying that KVM_EXIT_HYPERCALL expects to be used with SMC-CC?
>>> (if so, we should state that).
>> Yes I followed SMC-CC when writing this.
>>> I'm not certain we should tie this to SMC-CC.
>>>
>>> If we don't tie it to SMC-CC this selection of in/out registers looks odd, there is
>>> nothing about HVC/SMC that uses these registers, its just the SMC convention.
>> Maybe we don't need to tie it to SMC-CC, and simply load all values in args[6] to GP
>> registers...
>> And then there is either no strong reason to extend hypercall structure for ARM.
>
>>>> Flag hypercall_forward is added to turn on/off hypercall forwarding
>>>> and the default is false. Another flag hypercall_excl_psci is to
>>>> exclude PSCI from forwarding for backward compatible, and it only
>>>> makes sense to check its value when hypercall_forward is enabled.
>>> Calling out PSCI like this is something we shouldn't do. There will be, (are!) other
>>> SMC-CC calls that the kernel provides emulation for, we can't easily add to this list.
>> Yes; I didn't figure out good way to keep compatibility and future extension...
> I think the best trick is not to interpret the SMC/HVC calls from the guest. The kernel
> obviously does, but the API shouldn't force us to.
>
>
>>> I think the best way to avoid this, is to say the hypercall mechanism forwards 'unhandled
>>> SMC/HVC' to user-space. Which things the kernel chooses to handle can change.
>>>
>>> We need a way for user-space to know which SMC/HVC calls the kernel will handle, and will
>>> not forward. A suggestion is to add a co-processor that lists these by #imm and r0/x0
>>> value. User-space can then query any call to find out if it would be exported if the guest
>>> made that call. Something like kvm_arm_get_fw_reg().
>> Do you mean we add only one co-processor to list all SMC/HVC calls kernel will handle?
> Yes, some way of listing them.
> e.g. user-space wants to handle HVC's with #imm==0 and w0==0x84000000, this co-processor
> would list that as one of the things that the kernel will handle.
>
> If we can find a way of describing 64bit register values that would save them from being a
> problem in the future, but it may be too complicated to describe a 64bit register space
> and 16 bits of immediate.
>
> I think its okay for this co-processor to be SMC-CC specific, as its describing what the
> kernel supports. The KVM-api in contrast should be flexible enough to describe anything
> any guest may wish to do.
>
>
>> So
>> the reg size should be large enough to hold the list, each entry of which contains a #imm
>> and r0/x0 pair? Is the reg size fixed by definition or it can be queried by user-space? If
>> it is fixed, what's the size should we choose?
> (fixed/not-fixed - its a trade-off for complexity now, but no-one may ever use the full
> flexibility).
>
> I think we can assume the kernel will only offer things that look like SMC-CC to the
> guest. If the guest does something outside this space, its up to user-space to handle. (so
> the KVM-API must support non-SMC-CC stuff). I think we should define a co-processor for
> SMC/HVC where the #imm is 0. This then gives us 32bits of space we can map directly onto
> the w0 values.
Shall we setup a new class of co-processor and use the following id bit 
patterns (assuming the type index to be 0x0016)?

0x6030 <high 16 bits of SMC-CC function ID> 0016 <low 16 bits of SMC-CC 
function ID>

And the value of the co-processor returned to user space can be 0 (KVM 
will not handle) or 1 (KVM will handle)?

>
>
>> Does it make sense to extend the entry to hold the function ID base and limit, so that it
>> can describe the whole range for each function group, like PSCI, SDEI, etc?
> This may be over-complex, user-space would always need to enumerate the whole thing. I
> think commonly user-space would only want to know about one entry: For cases where we know
> the structure, user-space can just query the '_VERSION' call. If that isn't supported,
> user-space can assume the rest of that space is unimplemented. (the kernel shouldn't
> provide an incomplete emulation of these APIs)
>
>
>>> For 32bit, are we going to export SMC/HVC calls that failed their condition-code checks?
>> I'm not familiar with 32bit, either we don't have 32bit platforms to test the code. So my
>> preference is not to make many changes to 32bit...
> I'm not that familiar with it either ... You don't have anything with aarch32 support at
> EL1? I don't think we should add an API that only works with Aarch64 guests.
We have some D05 which is based on cortex A72 and should support aarch32 
guest. I can take a try.

Our object is to support aarch32 guest on an aarch64 hypervisor, but not 
on an aarch32 hypervisor, isn't it?

>
> For 32bit, we either need to expose these condition-code bits, and say user-space should
> work out if it needs to do anything. Or, handle this in the kernel, in which case we don't
> need to expose the condition-code bits, but we should document that the kernel will do the
> check.
>
>
> Nested-virt may cause some 'fun' here. If user-space starts an aarch64 guest at EL2, it
> may start its own aarch32 guest at EL1. If the aarch32 guest makes an SMC, who handles it?
> If user-space's aarch64 guest didn't set the traps for SMC, I think this should be
> delivered to user-space, which may be surprised by the request from an aarch32 guest.
>
> (its also possible nested-virt has me confused, it is pretty mind bending!)
>
>
>>> The hypercall structure should probably indicate whether the SMC/HVC call came from
>>> aarch32 or aarch64, as the behaviour may be different.
>> How about to use the longmode field in hypercall structure? Standard service calls will
>> indicate this in function ID, but we may need to know before parsing the function ID,
>> isn't it?
> Sure, as its a __u32, we could dump the guest PSTATE from SPSR in there.
>
>
> I think the last thing is 'ret', and whether we should provide a way of passing 'x0' back
> to the guest, or expect user-space to use set-one-reg. Most of the time user-space will
> only want to set x0, and doing this would let us initialise it to all-ones in the kernel,
> which means the guest gets the unknown-smc value back if user-space ignores the exit.
The current RFC is not expecting user-space to use set-one-reg to set GP 
registers for returning, to reduce ioctl() invocations for better 
performance.
I didn't use "ret" for guest to hold the returned x0, but still used 
"args[6]" to exchange x0~x5. I agree to set quick path for x0 only, and 
kvm doesn't bother to set the other 5 GP registers.

Thanks a lot,

Heyi

>
>
> Thanks,
>
> James
>
> .
>


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
