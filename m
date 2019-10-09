Return-Path: <SRS0=o2N9=YC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0181C47404
	for <kvmarm@archiver.kernel.org>; Wed,  9 Oct 2019 12:34:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27DCE206C0
	for <kvmarm@archiver.kernel.org>; Wed,  9 Oct 2019 12:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27DCE206C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6427C4A8C9;
	Wed,  9 Oct 2019 08:34:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0b13of52iRpw; Wed,  9 Oct 2019 08:34:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1418C4A8BC;
	Wed,  9 Oct 2019 08:34:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9044A8B4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Oct 2019 08:34:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BAYigtucLWZ4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Oct 2019 08:34:07 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 056DF4A89B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Oct 2019 08:34:07 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 51FF9588FBDDDBD42A78;
 Wed,  9 Oct 2019 20:34:03 +0800 (CST)
Received: from [127.0.0.1] (10.133.216.73) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Wed, 9 Oct 2019
 20:33:55 +0800
From: Guoheyi <guoheyi@huawei.com>
Subject: Re: [RFC PATCH 1/2] kvm/arm: add capability to forward hypercall to
 user space
To: James Morse <james.morse@arm.com>
References: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
 <1569338454-26202-2-git-send-email-guoheyi@huawei.com>
 <e097fb69-1e68-4082-d310-e7666e30b5d6@arm.com>
Message-ID: <d62b84ac-1a7e-de05-a1c1-c52dfb463462@huawei.com>
Date: Wed, 9 Oct 2019 20:33:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <e097fb69-1e68-4082-d310-e7666e30b5d6@arm.com>
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

Sorry for late response as we had our long holiday last week :)


On 2019/10/2 1:19, James Morse wrote:
> Hi Heyi,
>
> On 24/09/2019 16:20, Heyi Guo wrote:
>> As more SMC/HVC usages emerge on arm64 platforms, like SDEI, it makes
>> sense for kvm to have the capability of forwarding such calls to user
>> space for further emulation.
> (what do you mean by further? Doesn't user-space have to do all of it?)
For kvm will always handle hvc/smc guest exit for the first step, even 
if it is only a simple forwarding, I called the user-space processing as 
"further emulation".

>> We reuse the existing term "hypercall" for SMC/HVC, as well as the
>> hypercall structure in kvm_run to exchange arguments and return
>> values. The definition on arm64 is as below:
>>
>> exit_reason: KVM_EXIT_HYPERCALL
>>
>> Input:
>>    nr: the immediate value of SMC/HVC calls; not really used today.
>>    args[6]: x0..x5 (This is not fully conform with SMCCC which requires
>>             x6 as argument as well, but use space can use GET_ONE_REG
>>             ioctl for such rare case).
> If this structure isn't right for us, we could define a different one for arm/arm64.
> (we did this for kvm_vcpu_events)
Do you mean that we can move the hypercall struct definition to arch 
specific kvm_host.h? For it is in the common kvm_run structure, we'll 
need to change every kvm supported architectures, including x86, mips, 
powerpc, s390. Is it acceptable?

I found another solution from papr which defines its own hypercall 
structure in the kvm_run union definition:

         /* KVM_EXIT_PAPR_HCALL */
         struct {
             __u64 nr;
             __u64 ret;
             __u64 args[9];
         } papr_hcall;

How about we define a new structure for ARM/ARM64 specifically?

>
>> Return:
>>    args[0..3]: x0..x3 as defined in SMCCC. We need to extract
>>                args[0..3] and write them to x0..x3 when hypercall exit
>>                returns.
> Are we saying that KVM_EXIT_HYPERCALL expects to be used with SMC-CC?
> (if so, we should state that).
Yes I followed SMC-CC when writing this.
>
> I'm not certain we should tie this to SMC-CC.
>
> If we don't tie it to SMC-CC this selection of in/out registers looks odd, there is
> nothing about HVC/SMC that uses these registers, its just the SMC convention.
Maybe we don't need to tie it to SMC-CC, and simply load all values in 
args[6] to GP registers...
And then there is either no strong reason to extend hypercall structure 
for ARM.
>
>> Flag hypercall_forward is added to turn on/off hypercall forwarding
>> and the default is false. Another flag hypercall_excl_psci is to
>> exclude PSCI from forwarding for backward compatible, and it only
>> makes sense to check its value when hypercall_forward is enabled.
> Calling out PSCI like this is something we shouldn't do. There will be, (are!) other
> SMC-CC calls that the kernel provides emulation for, we can't easily add to this list.
Yes; I didn't figure out good way to keep compatibility and future 
extension...
> I think the best way to avoid this, is to say the hypercall mechanism forwards 'unhandled
> SMC/HVC' to user-space. Which things the kernel chooses to handle can change.
>
> We need a way for user-space to know which SMC/HVC calls the kernel will handle, and will
> not forward. A suggestion is to add a co-processor that lists these by #imm and r0/x0
> value. User-space can then query any call to find out if it would be exported if the guest
> made that call. Something like kvm_arm_get_fw_reg().
Do you mean we add only one co-processor to list all SMC/HVC calls 
kernel will handle? So the reg size should be large enough to hold the 
list, each entry of which contains a #imm and r0/x0 pair? Is the reg 
size fixed by definition or it can be queried by user-space? If it is 
fixed, what's the size should we choose?

Does it make sense to extend the entry to hold the function ID base and 
limit, so that it can describe the whole range for each function group, 
like PSCI, SDEI, etc?

>
> I agree it should be possible to export the PSCI range to user-space, so that user-space
> can provide a newer/better version than the kernel emulates, or prevent secondary cores
> coming online. (we should check how gracefully the kernel handles that... it doesn't
> happen on real systems)
> This could be done with something like kvm_vm_ioctl_enable_cap(), one option is to use the
> args to toggle the on/off value, but it may be simpler to expose a
> KVM_CAP_ARM_PSCI_TO_USER that can be enabled.
Sounds good. Then it may not be something we need to do in this patch 
set :) We can postpone this change when user-space PSCI is ready.
>
>
> Please update Documentation/virt/kvm/api.txt as part of the patches that make user-visible
> changes.
Sure; I can do that when we determine the interfaces.
>
> For 32bit, are we going to export SMC/HVC calls that failed their condition-code checks?
I'm not familiar with 32bit, either we don't have 32bit platforms to 
test the code. So my preference is not to make many changes to 32bit...
>
> The hypercall structure should probably indicate whether the SMC/HVC call came from
> aarch32 or aarch64, as the behaviour may be different.
How about to use the longmode field in hypercall structure? Standard 
service calls will indicate this in function ID, but we may need to know 
before parsing the function ID, isn't it?

Really appreciate your comments and suggestions. They are really helpful.

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
