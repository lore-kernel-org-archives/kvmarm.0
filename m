Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2520C10F0E
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 03:42:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E21420880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 03:42:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E21420880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B054A480;
	Sun,  7 Apr 2019 23:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hIpwnb4xocYU; Sun,  7 Apr 2019 23:42:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 53C894A477;
	Sun,  7 Apr 2019 23:42:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E4044A474
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 23:42:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ksUdCGdgQyOv for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Apr 2019 23:42:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C4624A46F
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Apr 2019 23:42:30 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 709BC15AD;
 Sun,  7 Apr 2019 20:42:29 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B373B3F718;
 Sun,  7 Apr 2019 20:42:26 -0700 (PDT)
Subject: Re: [PATCH v8 3/9] KVM: arm64: Move hyp_symbol_addr to fix dependency
To: Dave Martin <Dave.Martin@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-4-git-send-email-amit.kachhap@arm.com>
 <20190405110219.GQ3567@e103592.cambridge.arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <3010dfe9-f423-1e28-d89f-0731ae52a08b@arm.com>
Date: Mon, 8 Apr 2019 09:12:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190405110219.GQ3567@e103592.cambridge.arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408034224.qIgpeXk-o9frxICKSHvko6o3uf_3wZs2uGKEYyzTlq8@z>

Hi,

On 4/5/19 4:32 PM, Dave Martin wrote:
> On Tue, Apr 02, 2019 at 07:57:11AM +0530, Amit Daniel Kachhap wrote:
>> Currently hyp_symbol_addr is placed in kvm_mmu.h which is mostly
>> used by __hyp_this_cpu_ptr in kvm_asm.h but it cannot include
>> kvm_mmu.h directly as kvm_mmu.h uses kvm_ksym_ref which is
>> defined inside kvm_asm.h. Hence, hyp_symbol_addr is moved inside
>> kvm_asm.h to fix this dependency on each other.
>>
>> Also, hyp_symbol_addr corresponding counterpart, kvm_ksym_ref,
>> is already in kvm_asm.h, making it more sensible to move
>> kvm_symbol_addr to the same file.
>>
>> Suggested by: James Morse <james.morse@arm.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>
>> Changes since v7:
>> * Slight change in commit message [Julien Thierry].
>>
>>   arch/arm64/include/asm/kvm_asm.h | 20 ++++++++++++++++++++
>>   arch/arm64/include/asm/kvm_mmu.h | 20 --------------------
>>   2 files changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>> index f5b79e9..57a07e8 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -80,6 +80,26 @@ extern void __vgic_v3_init_lrs(void);
>>   
>>   extern u32 __kvm_get_mdcr_el2(void);
>>   
>> +/*
>> + * Obtain the PC-relative address of a kernel symbol
>> + * s: symbol
>> + *
>> + * The goal of this macro is to return a symbol's address based on a
>> + * PC-relative computation, as opposed to a loading the VA from a
>> + * constant pool or something similar. This works well for HYP, as an
>> + * absolute VA is guaranteed to be wrong. Only use this if trying to
>> + * obtain the address of a symbol (i.e. not something you obtained by
>> + * following a pointer).
>> + */
>> +#define hyp_symbol_addr(s)						\
>> +	({								\
>> +		typeof(s) *addr;					\
>> +		asm("adrp	%0, %1\n"				\
>> +		    "add	%0, %0, :lo12:%1\n"			\
>> +		    : "=r" (addr) : "S" (&s));				\
>> +		addr;							\
>> +	})
>> +
> 
> Do we need to include <asm/kvm_asm.h> in vgic-v2-cpuif-proxy.c now?
Yes asm/kvm_asm.h should be included now.
> 
> Otherwise,
> 
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Thanks,
Amit D
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
