Return-Path: <SRS0=bv25=S2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF57EC10F11
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 10:29:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3988921773
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 10:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3988921773
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F5D4A4DB;
	Wed, 24 Apr 2019 06:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V5UCErdnJLh8; Wed, 24 Apr 2019 06:29:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30FB24A4AB;
	Wed, 24 Apr 2019 06:29:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9267F4A494
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 06:29:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wvO7dDhWYQMu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 06:29:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9D5D4A417
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 06:29:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 339AFA78;
 Wed, 24 Apr 2019 03:29:46 -0700 (PDT)
Received: from [10.1.196.92] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 893B63F5AF; Wed, 24 Apr 2019 03:29:40 -0700 (PDT)
Subject: Re: [PATCH v10 2/5] KVM: arm/arm64: context-switch ptrauth registers
To: Dave Martin <Dave.Martin@arm.com>,
 Amit Daniel Kachhap <amit.kachhap@arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-3-git-send-email-amit.kachhap@arm.com>
 <8636m9awmu.wl-marc.zyngier@arm.com>
 <c961a9d1-8cc8-6e40-de1d-527f7feb0f41@arm.com>
 <20190423154430.GM3567@e103592.cambridge.arm.com>
From: Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <09bd4e79-c507-1f00-01c5-38afb2a62077@arm.com>
Date: Wed, 24 Apr 2019 11:29:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190423154430.GM3567@e103592.cambridge.arm.com>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190424102937.HJk-l2XfdDA90A0u7ZUjwoJwe6C8J4In_3vfFI6F7jg@z>

On 23/04/2019 16:44, Dave Martin wrote:
> On Tue, Apr 23, 2019 at 03:54:32PM +0530, Amit Daniel Kachhap wrote:
>> Hi Mark,
>>
>> On 4/23/19 3:09 PM, Marc Zyngier wrote:
>>> On Tue, 23 Apr 2019 05:42:35 +0100,
>>> Amit Daniel Kachhap <amit.kachhap@arm.com> wrote:
>>>>
>>>> From: Mark Rutland <mark.rutland@arm.com>
>>>>
>>>> When pointer authentication is supported, a guest may wish to use it.
>>>> This patch adds the necessary KVM infrastructure for this to work, with
>>>> a semi-lazy context switch of the pointer auth state.
>>>>
>>>> Pointer authentication feature is only enabled when VHE is built
>>>> in the kernel and present in the CPU implementation so only VHE code
>>>> paths are modified.
>>>>
>>>> When we schedule a vcpu, we disable guest usage of pointer
>>>> authentication instructions and accesses to the keys. While these are
>>>> disabled, we avoid context-switching the keys. When we trap the guest
>>>> trying to use pointer authentication functionality, we change to eagerly
>>>> context-switching the keys, and enable the feature. The next time the
>>>> vcpu is scheduled out/in, we start again. However the host key save is
>>>> optimized and implemented inside ptrauth instruction/register access
>>>> trap.
>>>>
>>>> Pointer authentication consists of address authentication and generic
>>>> authentication, and CPUs in a system might have varied support for
>>>> either. Where support for either feature is not uniform, it is hidden
>>> >from guests via ID register emulation, as a result of the cpufeature
>>>> framework in the host.
>>>>
>>>> Unfortunately, address authentication and generic authentication cannot
>>>> be trapped separately, as the architecture provides a single EL2 trap
>>>> covering both. If we wish to expose one without the other, we cannot
>>>> prevent a (badly-written) guest from intermittently using a feature
>>>> which is not uniformly supported (when scheduled on a physical CPU which
>>>> supports the relevant feature). Hence, this patch expects both type of
>>>> authentication to be present in a cpu.
>>>>
>>>> This switch of key is done from guest enter/exit assembly as preparation
>>>> for the upcoming in-kernel pointer authentication support. Hence, these
>>>> key switching routines are not implemented in C code as they may cause
>>>> pointer authentication key signing error in some situations.
>>>>
>>>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>>>> [Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
>>>> , save host key in ptrauth exception trap]
>>>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>>>> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>>> Cc: kvmarm@lists.cs.columbia.edu
>>>> ---
>>>> Changes since v9:
>>>>
>>>> * Removed hardcoding of enum values[Mark Zyngier].
>>>> * Changed kvm_ptrauth_asm.h to kvm_ptrauth.h[Mark Zyngier].
>>>> * Removed macro __ptrauth_save_state and applied inline [Marc Zyngier].
>>>> * Moved kvm_arm_vcpu_ptrauth_setup_lazy, kvm_arm_vcpu_ptrauth_enable and
>>>>   kvm_arm_vcpu_ptrauth_disable from *.c to kvm_emulate.h file [Marc Zyngier].
>>>> * Added/Modified comments at few places [Marc Zyngier].
>>>>
>>>>  arch/arm/include/asm/kvm_emulate.h   |   2 +
>>>>  arch/arm64/Kconfig                   |   5 +-
>>>>  arch/arm64/include/asm/kvm_emulate.h |  16 ++++++
>>>>  arch/arm64/include/asm/kvm_host.h    |  14 +++++
>>>>  arch/arm64/include/asm/kvm_ptrauth.h | 108 +++++++++++++++++++++++++++++++++++
>>>>  arch/arm64/kernel/asm-offsets.c      |   6 ++
>>>>  arch/arm64/kvm/handle_exit.c         |  36 +++++++++---
>>>>  arch/arm64/kvm/hyp/entry.S           |  15 +++++
>>>>  arch/arm64/kvm/sys_regs.c            |  43 +++++++++++++-
>>>>  virt/kvm/arm/arm.c                   |   2 +
>>>>  10 files changed, 234 insertions(+), 13 deletions(-)
>>>>  create mode 100644 arch/arm64/include/asm/kvm_ptrauth.h
> 
> [...]
> 
>>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>>> index 7e34b9e..3cfe2eb 100644
>>>> --- a/arch/arm64/Kconfig
>>>> +++ b/arch/arm64/Kconfig
>>>> @@ -1301,8 +1301,9 @@ config ARM64_PTR_AUTH
>>>>  	  context-switched along with the process.
>>>>  	  The feature is detected at runtime. If the feature is not present in
>>>> -	  hardware it will not be advertised to userspace nor will it be
>>>> -	  enabled.
>>>> +	  hardware it will not be advertised to userspace/KVM guest nor will it
>>>> +	  be enabled. However, KVM guest also require VHE mode and hence
>>>> +	  CONFIG_ARM64_VHE=y option to use this feature.
>>>
>>> SVE seems to have the exact same requirements, and has
>>>
>>> 	depends on !KVM || ARM64_VHE
>>>
>>> Why don't we have that for PTR_AUTH too?
>> This point came up earlier also and it was suggested by  Dave[1] to leave
>> userspace ptrauth for non-vhe mode as that would bring regression now.
>> [1]:https://lkml.org/lkml/2019/3/27/583
> 
> I see Marc applied this change in
> https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=queue&id=e19b245fa4c61558536bd34f80845f0c41eab65f0

That's only for me not to forget anything, and it hasn't been folded
into the original patch yet.

> The risk here is that someone has a custom config from an old kernel
> that explicitly turns CONFIG_ARM64_VHE off, and that try to use that
> config with this patch.
> 
> I'm not sure how much we care about that.
> 
> Otherwise, blocking this config so that people don't accidentally rely
> on it seems sensible.

What I'm trying to do is to reduce the amount of valid kernel
configurations that we need to validate independently.

At this stage, I'm tempted to just restrict it as described above, and
maybe relax it if someone shouts at me.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
