Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4984C43603
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 05:53:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26CF6206EC
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 05:53:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26CF6206EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F52F4A524;
	Wed, 18 Dec 2019 00:53:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rTSBaMzddnJO; Wed, 18 Dec 2019 00:53:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 428C84A541;
	Wed, 18 Dec 2019 00:53:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72A094A51F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 00:53:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4eY0CWaXeQQo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 00:53:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02F8A4A36B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 00:53:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6511D1FB;
 Tue, 17 Dec 2019 21:53:07 -0800 (PST)
Received: from [10.163.1.79] (unknown [10.163.1.79])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3833D3F718;
 Tue, 17 Dec 2019 21:52:50 -0800 (PST)
Subject: Re: [PATCH] arm64: Introduce ISAR6 CPU ID register
To: Mark Rutland <mark.rutland@arm.com>,
 Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
References: <1576145663-9909-1-git-send-email-anshuman.khandual@arm.com>
 <20191212144633.GE46910@lakrids.cambridge.arm.com>
 <be707b09-6469-d12f-07d5-50d574dc7284@arm.com>
 <20191212163120.GH46910@lakrids.cambridge.arm.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <b815ef0b-4dee-fea1-a43a-182952035afb@arm.com>
Date: Wed, 18 Dec 2019 11:23:44 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191212163120.GH46910@lakrids.cambridge.arm.com>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
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

On 12/12/2019 10:01 PM, Mark Rutland wrote:
> On Thu, Dec 12, 2019 at 03:22:13PM +0000, Suzuki Kuruppassery Poulose wrote:
>> On 12/12/2019 14:46, Mark Rutland wrote:
>>> On Thu, Dec 12, 2019 at 03:44:23PM +0530, Anshuman Khandual wrote:
>>>> +#define ID_ISAR6_JSCVT_SHIFT		0
>>>> +#define ID_ISAR6_DP_SHIFT		4
>>>> +#define ID_ISAR6_FHM_SHIFT		8
>>>> +#define ID_ISAR6_SB_SHIFT		12
>>>> +#define ID_ISAR6_SPECRES_SHIFT		16
>>>> +#define ID_ISAR6_BF16_SHIFT		20
>>>> +#define ID_ISAR6_I8MM_SHIFT		24
>>>
>>>> @@ -399,6 +399,7 @@ static const struct __ftr_reg_entry {
>>>>   	ARM64_FTR_REG(SYS_ID_ISAR4_EL1, ftr_generic_32bits),
>>>>   	ARM64_FTR_REG(SYS_ID_ISAR5_EL1, ftr_id_isar5),
>>>>   	ARM64_FTR_REG(SYS_ID_MMFR4_EL1, ftr_id_mmfr4),
>>>
>>>> +	ARM64_FTR_REG(SYS_ID_ISAR6_EL1, ftr_generic_32bits),
>>>
>>> Using ftr_generic_32bits exposes the lowest-common-denominator for all
>>> 4-bit fields in the register, and I don't think that's the right thing
>>> to do here, because:
>>>
>>> * We have no idea what ID_ISAR6 bits [31:28] may mean in future.
>>>
>>> * AFAICT, the instructions described by ID_ISAR6.SPECRES (from the
>>>    ARMv8.0-PredInv extension) operate on the local PE and are not
>>>    broadcast. To make those work as a guest expects, the host will need
>>>    to do additional things (e.g. to preserve that illusion when a vCPU is
>>>    migrated from one pCPU to another and back).
>>>
>>> Given that, think we should add an explicit ftr_id_isar6 which only
>>> exposes the fields that we're certain are safe to expose to a guest
>>> (i.e. without SPECRES).
>>
>> Agree. Thanks for pointing this out. I recommended the usage of
>> generic_32bits table without actually looking at the feature
>> definitions.
> 
> No worries; this is /really/ easy to miss!
> 
> Looking again, comparing to ARM DDI 0487E.a, there are a few other
> things we should probably sort out:
> 
> * ID_DFR0 fields need more thought; we should limit what we expose here.
>   I don't think it's valid for us to expose TraceFilt, and I suspect we

Sure, will go ahead and drop TraceFilt [28..31] from ID_DFR0 register.

>   need to add capping for debug features we currently emulate.

Could you please elaborate ?

> 
> * ID_ISAR0[31:28] are RES0 in ARMv8, Reserved/UNK in ARMv7.
>   We should probably ftr_id_isar0 so we can hide those bits.

Sure, will do.

> 
> * ID_ISAR5[23:10] are RES0
>   We handle this already! :)

I may be missing something here but some of these fields are already there.

#define ID_ISAR5_RDM_SHIFT              24
#define ID_ISAR5_CRC32_SHIFT            16
#define ID_ISAR5_SHA2_SHIFT             12
#define ID_ISAR5_SHA1_SHIFT             8
#define ID_ISAR5_AES_SHIFT              4
#define ID_ISAR5_SEVL_SHIFT             0

static const struct arm64_ftr_bits ftr_id_isar5[] = {
        ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_RDM_SHIFT, 4, 0),
        ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_CRC32_SHIFT, 4, 0),
        ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SHA2_SHIFT, 4, 0),
        ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SHA1_SHIFT, 4, 0),
        ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_AES_SHIFT, 4, 0),
        ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR5_SEVL_SHIFT, 4, 0),
        ARM64_FTR_END,
};

> 
> * ID_MMFR4.SpecSEI should be trated as higher safe.
>   We should update ftr_id_mmfr4 to handle this and other fields.

Sure but should we also export other fields as higher safe in there ?

> 
> * ID_PFR0 is missing DIT and CSV2
>   We should probably add these (but neither RAS not AMU).

Sure, will do.

> 
> * ID_PFR2 is missing
>   We should probably add this for SSBS and CSV3.

Sure but should we add corresponding ID_AA64PFR2_EL1 register as well ?

> 
> Thanks,
> Mark.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
