Return-Path: <SRS0=ht6V=WR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C04C3A59E
	for <kvmarm@archiver.kernel.org>; Wed, 21 Aug 2019 10:28:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A180822DD3
	for <kvmarm@archiver.kernel.org>; Wed, 21 Aug 2019 10:27:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A180822DD3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EA8C94A594;
	Wed, 21 Aug 2019 06:27:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id txOAU68vKd-a; Wed, 21 Aug 2019 06:27:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D804A5AA;
	Wed, 21 Aug 2019 06:27:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1901E4A594
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Aug 2019 06:27:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IOyJjvvZUrgu for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Aug 2019 06:27:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 882CF4A57E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Aug 2019 06:27:55 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A83B28;
 Wed, 21 Aug 2019 03:27:55 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B57B3F706;
 Wed, 21 Aug 2019 03:27:53 -0700 (PDT)
Subject: Re: [PATCH v2 4/9] KVM: arm64: Support stolen time reporting via
 shared structure
To: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
References: <20190819140436.12207-1-steven.price@arm.com>
 <20190819140436.12207-5-steven.price@arm.com>
 <f6fad4fa-323d-306c-c582-de07464f4d00@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <4703baa7-0116-f5d6-291e-1e669a36545d@arm.com>
Date: Wed, 21 Aug 2019 11:27:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <f6fad4fa-323d-306c-c582-de07464f4d00@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

On 19/08/2019 17:40, Marc Zyngier wrote:
> Hi Steven,
> 
> On 19/08/2019 15:04, Steven Price wrote:
>> Implement the service call for configuring a shared structure between a
>> VCPU and the hypervisor in which the hypervisor can write the time
>> stolen from the VCPU's execution time by other tasks on the host.
>>
>> The hypervisor allocates memory which is placed at an IPA chosen by user
>> space. The hypervisor then uses WRITE_ONCE() to update the shared
>> structure ensuring single copy atomicity of the 64-bit unsigned value
>> that reports stolen time in nanoseconds.
>>
>> Whenever stolen time is enabled by the guest, the stolen time counter is
>> reset.
>>
>> The stolen time itself is retrieved from the sched_info structure
>> maintained by the Linux scheduler code. We enable SCHEDSTATS when
>> selecting KVM Kconfig to ensure this value is meaningful.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm/include/asm/kvm_host.h   | 15 +++++++
>>  arch/arm64/include/asm/kvm_host.h | 16 ++++++-
>>  arch/arm64/kvm/Kconfig            |  1 +
>>  include/linux/kvm_types.h         |  2 +
>>  virt/kvm/arm/arm.c                | 19 +++++++++
>>  virt/kvm/arm/hypercalls.c         |  3 ++
>>  virt/kvm/arm/pvtime.c             | 71 +++++++++++++++++++++++++++++++
>>  7 files changed, 126 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 369b5d2d54bf..14d61a84c270 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -39,6 +39,7 @@
>>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>  #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
>>  #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
>> +#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
>>  
>>  DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
>>  
>> @@ -77,6 +78,12 @@ struct kvm_arch {
>>  
>>  	/* Mandated version of PSCI */
>>  	u32 psci_version;
>> +
>> +	struct kvm_arch_pvtime {
>> +		struct gfn_to_hva_cache st_ghc;
>> +		gpa_t st_base;
>> +		u64 st_size;
>> +	} pvtime;
> 
> It'd be good if we could avoid having this in the 32bit vcpu structure,
> given that it serves no real purpose (other than being able to compile
> things).

Good point - I think I can fix that with a couple more static inline
functions... It's a little tricky due to header file include order, but
I think I can make it work.

[...]
>> +int kvm_update_stolen_time(struct kvm_vcpu *vcpu, bool init)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +	struct kvm_arch_pvtime *pvtime = &kvm->arch.pvtime;
>> +	u64 steal;
>> +	u64 steal_le;
>> +	u64 offset;
>> +	int idx;
>> +	const int stride = sizeof(struct pvclock_vcpu_stolen_time);
>> +
>> +	if (pvtime->st_base == GPA_INVALID)
>> +		return -ENOTSUPP;
>> +
>> +	/* Let's do the local bookkeeping */
>> +	steal = vcpu->arch.steal.steal;
>> +	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
>> +	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
>> +	vcpu->arch.steal.steal = steal;
>> +
>> +	offset = stride * kvm_vcpu_get_idx(vcpu);
>> +
>> +	if (unlikely(offset + stride > pvtime->st_size))
>> +		return -EINVAL;
>> +
>> +	steal_le = cpu_to_le64(steal);
>> +	pagefault_disable();
> 
> What's the reason for doing a pagefault_disable()? What I'd expect is
> for the userspace page to be faulted in and written to, and doing a
> pagefault_disable() seems to be going against this idea.

Umm... this is me screwing up the locking...

The current code is very confused about which locks should/can be held
when kvm_update_stolen_time() is called. vcpu_req_record_steal()
explicitly takes the kvm->srcu read lock - which is then taken again
here. But kvm_hypercall_stolen_time doesn't hold any lock. And obviously
at some point in time I expected this to be called in atomic context...

In general the page is likely to be faulted in (as a guest which is
using stolen time is surely looking at the numbers there). But there's
no need for the pagefault_disable(). It also shouldn't be the callers
responsibility to hold kvm->srcu.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
