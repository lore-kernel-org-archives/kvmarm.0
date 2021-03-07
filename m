Return-Path: <SRS0=uFXH=IF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69555C433E0
	for <kvmarm@archiver.kernel.org>; Sun,  7 Mar 2021 11:54:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B8ED0650FD
	for <kvmarm@archiver.kernel.org>; Sun,  7 Mar 2021 11:54:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8ED0650FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 20F6C4B347;
	Sun,  7 Mar 2021 06:54:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cBAIW4Hp2Kj6; Sun,  7 Mar 2021 06:54:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B54CC4B2E6;
	Sun,  7 Mar 2021 06:54:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 280DD4B2C4
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Mar 2021 06:54:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xI8SHUjQ7LRo for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Mar 2021 06:53:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1114B269
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Mar 2021 06:53:58 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CA147D6E;
 Sun,  7 Mar 2021 03:53:57 -0800 (PST)
Received: from [192.168.0.130] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E2D23F766;
 Sun,  7 Mar 2021 03:53:54 -0800 (PST)
Subject: Re: [PATCH] arm64/mm: Fix __enable_mmu() for new TGRAN range values
To: Mark Rutland <mark.rutland@arm.com>
References: <1614954969-14338-1-git-send-email-anshuman.khandual@arm.com>
 <20210305145111.GA78884@C02TD0UTHF1T.local>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <1f339512-34ac-9779-e534-bee6698b99aa@arm.com>
Date: Sun, 7 Mar 2021 17:24:21 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210305145111.GA78884@C02TD0UTHF1T.local>
Content-Language: en-US
Cc: linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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



On 3/5/21 8:21 PM, Mark Rutland wrote:
> On Fri, Mar 05, 2021 at 08:06:09PM +0530, Anshuman Khandual wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> As per ARM ARM DDI 0487G.a, when FEAT_LPA2 is implemented, ID_AA64MMFR0_EL1
>> might contain a range of values to describe supported translation granules
>> (4K and 16K pages sizes in particular) instead of just enabled or disabled
>> values. This changes __enable_mmu() function to handle complete acceptable
>> range of values (depending on whether the field is signed or unsigned) now
>> represented with ID_AA64MMFR0_TGRAN_SUPPORTED_[MIN..MAX] pair. While here,
>> also fix similar situations in EFI stub and KVM as well.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-efi@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/sysreg.h           | 20 ++++++++++++++------
>>  arch/arm64/kernel/head.S                  |  6 ++++--
>>  arch/arm64/kvm/reset.c                    | 23 ++++++++++++-----------
>>  drivers/firmware/efi/libstub/arm64-stub.c |  2 +-
>>  4 files changed, 31 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index dfd4edb..d4a5fca9 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -796,6 +796,11 @@
>>  #define ID_AA64MMFR0_PARANGE_48		0x5
>>  #define ID_AA64MMFR0_PARANGE_52		0x6
>>  
>> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_DEFAULT	0x0
>> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_NONE	0x1
>> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MIN	0x2
>> +#define ID_AA64MMFR0_TGRAN_2_SUPPORTED_MAX	0x7
>
> The TGRAN2 fields doesn't quite follow the usual ID scheme rules, so how
> do we deteremine the max value? Does the ARM ARM say anything in
> particular about them, like we do for some of the PMU ID fields?

Did not find anything in ARM ARM, regarding what scheme TGRAN2 fields
actually follow. I had arrived at more restrictive 0x7 value, like the
usual signed fields as the TGRAN4 fields definitely do not follow the
unsigned ID scheme. Would restricting max value to 0x3 (i.e LPA2) be a
better option instead ?

> 
> Otherwise, this patch looks correct to me.
> 
> Thanks,
> Mark.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
