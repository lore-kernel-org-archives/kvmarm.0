Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F0CC433ED
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 10:51:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0F16761184
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 10:51:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F16761184
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 912C34B6B7;
	Thu, 20 May 2021 06:51:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hU5cGWq7DwV3; Thu, 20 May 2021 06:51:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AAB44B47D;
	Thu, 20 May 2021 06:51:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D16234B47D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 06:51:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1zSvwKhBbgzT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 06:51:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88E8A4B45C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 06:51:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F182B14FF;
 Thu, 20 May 2021 03:51:28 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4372F3F719;
 Thu, 20 May 2021 03:51:26 -0700 (PDT)
Subject: Re: [PATCH v12 6/8] arm64: kvm: Expose KVM_ARM_CAP_MTE
To: Marc Zyngier <maz@kernel.org>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-7-steven.price@arm.com> <87tun1tg1l.wl-maz@kernel.org>
 <4e1fc7b7-ea8c-a87c-9177-d9e03ff96cb8@arm.com> <8735uhvhqz.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <2dff0e85-abfd-4261-a670-6008ff9195ff@arm.com>
Date: Thu, 20 May 2021 11:51:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <8735uhvhqz.wl-maz@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 20/05/2021 11:09, Marc Zyngier wrote:
> On Wed, 19 May 2021 14:26:31 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> On 17/05/2021 18:40, Marc Zyngier wrote:
>>> On Mon, 17 May 2021 13:32:37 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> It's now safe for the VMM to enable MTE in a guest, so expose the
>>>> capability to user space.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>>  arch/arm64/kvm/arm.c      | 9 +++++++++
>>>>  arch/arm64/kvm/sys_regs.c | 3 +++
>>>>  2 files changed, 12 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>>> index 1cb39c0803a4..e89a5e275e25 100644
>>>> --- a/arch/arm64/kvm/arm.c
>>>> +++ b/arch/arm64/kvm/arm.c
>>>> @@ -93,6 +93,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>>>  		r = 0;
>>>>  		kvm->arch.return_nisv_io_abort_to_user = true;
>>>>  		break;
>>>> +	case KVM_CAP_ARM_MTE:
>>>> +		if (!system_supports_mte() || kvm->created_vcpus)
>>>> +			return -EINVAL;
>>>> +		r = 0;
>>>> +		kvm->arch.mte_enabled = true;
>>>
>>> As far as I can tell from the architecture, this isn't valid for a
>>> 32bit guest.
>>
>> Indeed, however the MTE flag is a property of the VM not of the vCPU.
>> And, unless I'm mistaken, it's technically possible to create a VM where
>> some CPUs are 32 bit and some 64 bit. Not that I can see much use of a
>> configuration like that.
> 
> It looks that this is indeed a bug, and I'm on my way to squash it.
> Can't believe we allowed that for so long...

Ah, well if you're going to kill off mixed 32bit/64bit VMs then...

> But the architecture clearly states:
> 
> <quote>
> These features are supported in AArch64 state only.
> </quote>
> 
> So I'd expect something like:
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 956cdc240148..50635eacfa43 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -220,7 +220,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> -			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
> +			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) ||
> +			    vcpu->kvm->arch.mte_enabled) {
>  				ret = -EINVAL;
>  				goto out;
>  			}
> 
> that makes it completely impossible to create 32bit CPUs within a
> MTE-enabled guest.

... that makes complete sense, and I'll include this hunk in my next
posting.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
