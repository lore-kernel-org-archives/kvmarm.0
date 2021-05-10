Return-Path: <SRS0=2g2/=KF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A3DC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 15:13:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 094D761409
	for <kvmarm@archiver.kernel.org>; Mon, 10 May 2021 15:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 094D761409
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E84E4B3AD;
	Mon, 10 May 2021 11:13:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mb+EIm4DqPEO; Mon, 10 May 2021 11:13:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1B2F4B3BF;
	Mon, 10 May 2021 11:13:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 820AA4B3BD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 11:13:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N4+MvcQbmQyy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 May 2021 11:13:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0A14B3AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 May 2021 11:13:53 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B1CA1688;
 Mon, 10 May 2021 08:13:53 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 328293F719;
 Mon, 10 May 2021 08:13:52 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: Commit pending PC adjustemnts before
 returning to userspace
To: Marc Zyngier <maz@kernel.org>
References: <20210510094915.1909484-1-maz@kernel.org>
 <20210510094915.1909484-3-maz@kernel.org>
 <7a0f43c8-cc36-810e-0b8e-ffe66672ca82@arm.com> <87v97qociy.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <65b5cad7-13d8-13a9-9502-7c21e0b72761@arm.com>
Date: Mon, 10 May 2021 16:14:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87v97qociy.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 5/10/21 4:04 PM, Marc Zyngier wrote:
> On Mon, 10 May 2021 15:55:28 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 5/10/21 10:49 AM, Marc Zyngier wrote:
>>> KVM currently updates PC (and the corresponding exception state)
>>> using a two phase approach: first by setting a set of flags,
>>> then by converting these flags into a state update when the vcpu
>>> is about to enter the guest.
>>>
>>> However, this creates a disconnect with userspace if the vcpu thread
>>> returns there with any exception/PC flag set. In this case, the exposed
>> The code seems to handle only the KVM_ARM64_PENDING_EXCEPTION
>> flag. Is the "PC flag" a reference to the KVM_ARM64_INCREMENT_PC
>> flag?
> No, it does handle both exception and PC increment, unless I have
> completely bodged something (entirely possible).

The message is correct, my bad.

>
>>> context is wrong, as userpsace doesn't have access to these flags
>> s/userpsace/userspace
>>
>>> (they aren't architectural). It also means that these flags are
>>> preserved across a reset, which isn't expected.
>>>
>>> To solve this problem, force an explicit synchronisation of the
>>> exception state on vcpu exit to userspace. As an optimisation
>>> for nVHE systems, only perform this when there is something pending.
>>>
>>> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> Cc: stable@vger.kernel.org # 5.11
>>> ---
>>>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>>>  arch/arm64/kvm/arm.c               | 10 ++++++++++
>>>  arch/arm64/kvm/hyp/exception.c     |  4 ++--
>>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
>>>  4 files changed, 21 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>>> index d5b11037401d..5e9b33cbac51 100644
>>> --- a/arch/arm64/include/asm/kvm_asm.h
>>> +++ b/arch/arm64/include/asm/kvm_asm.h
>>> @@ -63,6 +63,7 @@
>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
>>>  #define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
>>> +#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
>>>  
>>>  #ifndef __ASSEMBLY__
>>>  
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 1cb39c0803a4..d62a7041ebd1 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -897,6 +897,16 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>  
>>>  	kvm_sigset_deactivate(vcpu);
>>>  
>>> +	/*
>>> +	 * In the unlikely event that we are returning to userspace
>>> +	 * with pending exceptions or PC adjustment, commit these
>> I'm going to assume "PC adjustment" means the KVM_ARM64_INCREMENT_PC
>> flag. Please correct me if that's not true, but if that's the case,
>> then the flag isn't handled below.
>>
>>> +	 * adjustments in order to give userspace a consistent view of
>>> +	 * the vcpu state.
>>> +	 */
>>> +	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
>>> +					 KVM_ARM64_EXCEPT_MASK)))
>> The condition seems to suggest that it is valid to set
>> KVM_ARM64_EXCEPT_{AA32,AA64}_* without setting
>> KVM_ARM64_PENDING_EXCEPTION, which looks rather odd to me.
>> Is that a valid use of the KVM_ARM64_EXCEPT_MASK bits? If it's not
>> (the existing code always sets the exception type with the
>> KVM_ARM64_PENDING_EXCEPTION), that I was thinking that checking only
>> the KVM_ARM64_PENDING_EXCEPTION flag would make the intention
>> clearer.
> No, you are missing this (subtle) comment in kvm_host.h:
>
> <quote>
> /*
>  * Overlaps with KVM_ARM64_EXCEPT_MASK on purpose so that it can't be
>  * set together with an exception...
>  */
> #define KVM_ARM64_INCREMENT_PC		(1 << 9) /* Increment PC */
> </quote>
>
> So (KVM_ARM64_PENDING_EXCEPTION | KVM_ARM64_EXCEPT_MASK) checks for
> *both* an exception and a PC increment.

Then how about explicitly checking for the KVM_ARM64_PENDING_EXCEPTION and
KVM_ARM64_INCREMENT_PC flags, like it's done in __kvm_adjust_pc? That would
certainly make the code easier to understand, as it's not immediately obvious that
the EXCEPT mask includes the INCREMENT_PC flag.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
