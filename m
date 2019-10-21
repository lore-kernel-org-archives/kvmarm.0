Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBDACA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 10:40:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7AB072067B
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 10:40:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AB072067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECF634A9B8;
	Mon, 21 Oct 2019 06:40:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eQqf+r4rpwWW; Mon, 21 Oct 2019 06:40:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB9484A9AC;
	Mon, 21 Oct 2019 06:40:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0C1F4A986
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 06:40:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PB60JAvq05y5 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 06:40:22 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BAC5B4A87D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 06:40:22 -0400 (EDT)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iMV6l-00020K-Os; Mon, 21 Oct 2019 12:40:15 +0200
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 21 Oct 2019 11:40:15 +0100
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <1bb10eb5-0fe8-57c9-3b67-9b3661a73d29@arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-6-steven.price@arm.com> <86eez9yoog.wl-maz@kernel.org>
 <1bb10eb5-0fe8-57c9-3b67-9b3661a73d29@arm.com>
Message-ID: <cc639f743d621198ef02f880089bb54d@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: steven.price@arm.com, mark.rutland@arm.com,
 kvm@vger.kernel.org, rkrcmar@redhat.com, catalin.marinas@arm.com,
 suzuki.poulose@arm.com, linux-doc@vger.kernel.org, linux@armlinux.org.uk,
 linux-kernel@vger.kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, pbonzini@redhat.com, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2019-10-21 11:21, Steven Price wrote:
> On 19/10/2019 12:12, Marc Zyngier wrote:
>> On Fri, 11 Oct 2019 13:59:25 +0100,
>> Steven Price <steven.price@arm.com> wrote:
>>>
>>> Implement the service call for configuring a shared structure 
>>> between a
>>> VCPU and the hypervisor in which the hypervisor can write the time
>>> stolen from the VCPU's execution time by other tasks on the host.
>>>
>>> User space allocates memory which is placed at an IPA also chosen 
>>> by user
>>> space. The hypervisor then updates the shared structure using
>>> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
>>> reporting the stolen time in nanoseconds.
>>>
>>> Whenever stolen time is enabled by the guest, the stolen time 
>>> counter is
>>> reset.
>>>
>>> The stolen time itself is retrieved from the sched_info structure
>>> maintained by the Linux scheduler code. We enable SCHEDSTATS when
>>> selecting KVM Kconfig to ensure this value is meaningful.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>  arch/arm/include/asm/kvm_host.h   | 20 +++++++++++
>>>  arch/arm64/include/asm/kvm_host.h | 21 +++++++++++-
>>>  arch/arm64/kvm/Kconfig            |  1 +
>>>  include/linux/kvm_types.h         |  2 ++
>>>  virt/kvm/arm/arm.c                | 11 ++++++
>>>  virt/kvm/arm/hypercalls.c         |  3 ++
>>>  virt/kvm/arm/pvtime.c             | 56 
>>> +++++++++++++++++++++++++++++++
>>>  7 files changed, 113 insertions(+), 1 deletion(-)

[...]

>>> +long kvm_hypercall_stolen_time(struct kvm_vcpu *vcpu)
>>
>> Why long? If that's a base address, then it is either a phys_addr_t 
>> or
>> a gpa_t. I'd suggest you move the error check to the caller.
>
> This is a bit more tricky. It's a long because that's the declared 
> type
> of the SMCCC return in kvm_hvc_call_handler(). I can't (easily) move 
> the
> code into kvm_hvc_call_handler() because that is compiled for arm (as
> well as arm64) and we don't have the definitions for stolen time 
> there.
> The best option I could come up with is to have a dummy stub for arm 
> and
> use generic types for this function.
>
> This means we need a type which can contain both a gpa_t and the
> SMCCC_RET_NOT_SUPPORTED error code.
>
> I'm open to alternative suggestions on how to make this work.

My suggestion would be to always return a gpa_t from this function, and
change the 32bit stub for kvm_hypercall_stolen_time() to always return
GPA_INVALID.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
