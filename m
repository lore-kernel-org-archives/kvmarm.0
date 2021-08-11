Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7517FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 05:54:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3AE360F46
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 05:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D3AE360F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46FFD4A4A0;
	Wed, 11 Aug 2021 01:54:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E9++mVUMY9UI; Wed, 11 Aug 2021 01:54:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0A04A193;
	Wed, 11 Aug 2021 01:54:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 832F2405A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 01:54:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DRN7rlEiEWdL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 01:54:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EE3D4056A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 01:54:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D6431FB;
 Tue, 10 Aug 2021 22:54:08 -0700 (PDT)
Received: from [10.163.67.241] (unknown [10.163.67.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1EA133F718;
 Tue, 10 Aug 2021 22:54:04 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: arm64: Drop check_kvm_target_cpu() based percpu
 probe
To: Will Deacon <will@kernel.org>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-4-git-send-email-anshuman.khandual@arm.com>
 <20210810132822.GC2946@willie-the-truck>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <c7f87766-bf91-d0c1-ce9d-893506350020@arm.com>
Date: Wed, 11 Aug 2021 11:24:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210810132822.GC2946@willie-the-truck>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
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



On 8/10/21 6:58 PM, Will Deacon wrote:
> On Tue, Aug 10, 2021 at 12:32:39PM +0530, Anshuman Khandual wrote:
>> kvm_target_cpu() never returns a negative error code, so check_kvm_target()
>> would never have 'ret' filled with a negative error code. Hence the percpu
>> probe via check_kvm_target_cpu() does not make sense as its never going to
>> find an unsupported CPU, forcing kvm_arch_init() to exit early. Hence lets
>> just drop this percpu probe (and also check_kvm_target_cpu()) altogether.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/kvm/arm.c | 14 --------------
>>  1 file changed, 14 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 19560e457c11..16f93678c17e 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2010,11 +2010,6 @@ static int finalize_hyp_mode(void)
>>  	return 0;
>>  }
>>  
>> -static void check_kvm_target_cpu(void *ret)
>> -{
>> -	*(int *)ret = kvm_target_cpu();
>> -}
>> -
>>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
>>  {
>>  	struct kvm_vcpu *vcpu;
>> @@ -2074,7 +2069,6 @@ void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
>>  int kvm_arch_init(void *opaque)
>>  {
>>  	int err;
>> -	int ret, cpu;
>>  	bool in_hyp_mode;
>>  
>>  	if (!is_hyp_mode_available()) {
>> @@ -2089,14 +2083,6 @@ int kvm_arch_init(void *opaque)
>>  		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
>>  			 "Only trusted guests should be used on this system.\n");
>>  
>> -	for_each_online_cpu(cpu) {
>> -		smp_call_function_single(cpu, check_kvm_target_cpu, &ret, 1);
>> -		if (ret < 0) {
>> -			kvm_err("Error, CPU %d not supported!\n", cpu);
>> -			return -ENODEV;
>> -		}
>> -	}
> 
> Looks like kvm_target_cpu() *could* return an error at one time of day (at
> least on 32-bit), but agreed that this checking is no longer needed:
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> Perhaps it's worth making the return type of kvm_target_cpu() a u32 to
> make it a bit more explicit that you shouldn't be returning an error code
> there?

Sure, will change the return type to u32.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
