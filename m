Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1891FC4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 10:42:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8857F60E78
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 10:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8857F60E78
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E98854A19F;
	Wed, 11 Aug 2021 06:42:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nWgMIAgsB7RE; Wed, 11 Aug 2021 06:42:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85D2F49FB7;
	Wed, 11 Aug 2021 06:42:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 759F049FA6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 06:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eGjjl5VYjNfg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 06:42:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F20694083E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 06:42:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 636A9106F;
 Wed, 11 Aug 2021 03:42:30 -0700 (PDT)
Received: from [10.163.67.241] (unknown [10.163.67.241])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 227203F70D;
 Wed, 11 Aug 2021 03:42:26 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Restrict IPA size to maximum 48 bits on 4K
 and 16K page size
To: Marc Zyngier <maz@kernel.org>
References: <1628657549-27584-1-git-send-email-anshuman.khandual@arm.com>
 <87v94c9vbu.wl-maz@kernel.org>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <acffb56d-8d35-93dc-f96e-61f763bda876@arm.com>
Date: Wed, 11 Aug 2021 16:13:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87v94c9vbu.wl-maz@kernel.org>
Content-Language: en-US
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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



On 8/11/21 3:06 PM, Marc Zyngier wrote:
> On Wed, 11 Aug 2021 05:52:29 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> Even though ID_AA64MMFR0.PARANGE reports 52 bit PA size support, it cannot
>> be enabled as guest IPA size on 4K or 16K page size configurations. Hence
>> kvm_ipa_limit must be restricted to 48 bits. This change achieves required
>> IPA capping.
>>
>> Before the commit c9b69a0cf0b4 ("KVM: arm64: Don't constrain maximum IPA
>> size based on host configuration"), the problem here would have been just
>> latent via PHYS_MASK_SHIFT (which earlier in turn capped kvm_ipa_limit),
>> which remains capped at 48 bits on 4K and 16K configs.
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
>> Fixes: c9b69a0cf0b4 ("KVM: arm64: Don't constrain maximum IPA size based on host configuration")
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> This applies on v5.14-rc5
>>
>>  arch/arm64/kvm/reset.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 20588220fe66..e66974c4b9d3 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -337,6 +337,15 @@ int kvm_set_ipa_limit(void)
>>  		return -EINVAL;
>>  	}
>>  
>> +	/*
>> +	 * IPA size beyond 48 bits could not be supported
>> +	 * on either 4K or 16K page size. Hence let's cap
>> +	 * it to 48 bits, in case it's reported as larger
>> +	 * on the system.
>> +	 */
>> +	if (!IS_ENABLED(CONFIG_ARM64_64K_PAGES))
> 
> As per our earlier discussion, please use (PAGE_SIZE != SZ_64K)
> instead. This is in keeping with the rest of the file.

Sure, will change.

> 
>> +		parange = min(parange, (unsigned int)ID_AA64MMFR0_PARANGE_48);
>> +
> 
> Also, please move it next to the point where we assign parange.

Sure, will move.


> 
>>  	kvm_ipa_limit = id_aa64mmfr0_parange_to_phys_shift(parange);
>>  	kvm_info("IPA Size Limit: %d bits%s\n", kvm_ipa_limit,
>>  		 ((kvm_ipa_limit < KVM_PHYS_SHIFT) ?
> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
