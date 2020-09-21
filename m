Return-Path: <SRS0=bMLL=C6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E53C43468
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 15:44:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F420420888
	for <kvmarm@archiver.kernel.org>; Mon, 21 Sep 2020 15:44:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F420420888
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E25C4B48A;
	Mon, 21 Sep 2020 11:44:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RKxaKUy5X43N; Mon, 21 Sep 2020 11:44:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DFFB24B4AB;
	Mon, 21 Sep 2020 11:44:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDFB04B4A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 11:44:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ANkD0kPO5JkE for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2020 11:44:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95EB04B48A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2020 11:44:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A864E147A;
 Mon, 21 Sep 2020 08:44:46 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B01013F718;
 Mon, 21 Sep 2020 08:44:44 -0700 (PDT)
Subject: Re: [PATCH v6 5/7] KVM: arm64: pmu: Make overflow handler NMI safe
To: Will Deacon <will@kernel.org>
References: <20200819133419.526889-1-alexandru.elisei@arm.com>
 <20200819133419.526889-6-alexandru.elisei@arm.com>
 <20200921134301.GJ2139@willie-the-truck>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a8763d49-d105-3920-8acf-c14d3a723b18@arm.com>
Date: Mon, 21 Sep 2020 16:45:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200921134301.GJ2139@willie-the-truck>
Content-Language: en-US
Cc: sumit.garg@linaro.org, kvm@vger.kernel.org,
 Marc Zyngier <marc.zyngier@arm.com>, maz@kernel.org,
 Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
 swboyd@chromium.org, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Will,

On 9/21/20 2:43 PM, Will Deacon wrote:
> On Wed, Aug 19, 2020 at 02:34:17PM +0100, Alexandru Elisei wrote:
>> From: Julien Thierry <julien.thierry@arm.com>
>>
>> kvm_vcpu_kick() is not NMI safe. When the overflow handler is called from
>> NMI context, defer waking the vcpu to an irq_work queue.
>>
>> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Pouloze <suzuki.poulose@arm.com>
>> Cc: kvm@vger.kernel.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Signed-off-by: Julien Thierry <julien.thierry@arm.com>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arch/arm64/kvm/pmu-emul.c | 25 ++++++++++++++++++++++++-
>>  include/kvm/arm_pmu.h     |  1 +
>>  2 files changed, 25 insertions(+), 1 deletion(-)
> I'd like an Ack from the KVM side on this one, but some minor comments
> inline.
>
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index f0d0312c0a55..30268397ed06 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -433,6 +433,22 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
>>  	kvm_pmu_update_state(vcpu);
>>  }
>>  
>> +/**
>> + * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
>> + * to the event.
>> + * This is why we need a callback to do it once outside of the NMI context.
>> + */
>> +static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
>> +{
>> +	struct kvm_vcpu *vcpu;
>> +	struct kvm_pmu *pmu;
>> +
>> +	pmu = container_of(work, struct kvm_pmu, overflow_work);
>> +	vcpu = kvm_pmc_to_vcpu(&pmu->pmc[0]);
> Can you spell this kvm_pmc_to_vcpu(pmu->pmc); ?

Of course, that is much better.

>
>> +
>> +	kvm_vcpu_kick(vcpu);
> How do we guarantee that the vCPU is still around by the time this runs?
> Sorry to ask such a horrible question, but I don't see anything associating
> the workqueue with the lifetime of the vCPU.

That's a very nice catch, indeed the code doesn't guarantee that the VM is still
around when the work is executed. I will add an irq_work_sync() call to
kvm_pmu_vcpu_destroy() (which is called by kvm_vcpu_destroy() ->
kvm_arch_vcpu_destroy()), and to kvm_pmu_vcpu_reset(), similar to how x86 handles it.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
