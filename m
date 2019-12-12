Return-Path: <SRS0=bs2E=2C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA1DC43603
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 15:22:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 976202067C
	for <kvmarm@archiver.kernel.org>; Thu, 12 Dec 2019 15:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 976202067C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EE61A4A2E7;
	Thu, 12 Dec 2019 10:22:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8kh2WexHjyJQ; Thu, 12 Dec 2019 10:22:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE37C4AC80;
	Thu, 12 Dec 2019 10:22:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F1864AC80
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 10:22:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jnN-FFB4VvYc for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Dec 2019 10:22:16 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25EFE4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Dec 2019 10:22:16 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A559030E;
 Thu, 12 Dec 2019 07:22:15 -0800 (PST)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88AC73F6CF;
 Thu, 12 Dec 2019 07:22:14 -0800 (PST)
Subject: Re: [PATCH] arm64: Introduce ISAR6 CPU ID register
To: Mark Rutland <mark.rutland@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <1576145663-9909-1-git-send-email-anshuman.khandual@arm.com>
 <20191212144633.GE46910@lakrids.cambridge.arm.com>
From: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>
Message-ID: <be707b09-6469-d12f-07d5-50d574dc7284@arm.com>
Date: Thu, 12 Dec 2019 15:22:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191212144633.GE46910@lakrids.cambridge.arm.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 12/12/2019 14:46, Mark Rutland wrote:
> On Thu, Dec 12, 2019 at 03:44:23PM +0530, Anshuman Khandual wrote:
>> +#define ID_ISAR6_JSCVT_SHIFT		0
>> +#define ID_ISAR6_DP_SHIFT		4
>> +#define ID_ISAR6_FHM_SHIFT		8
>> +#define ID_ISAR6_SB_SHIFT		12
>> +#define ID_ISAR6_SPECRES_SHIFT		16
>> +#define ID_ISAR6_BF16_SHIFT		20
>> +#define ID_ISAR6_I8MM_SHIFT		24
> 
>> @@ -399,6 +399,7 @@ static const struct __ftr_reg_entry {
>>   	ARM64_FTR_REG(SYS_ID_ISAR4_EL1, ftr_generic_32bits),
>>   	ARM64_FTR_REG(SYS_ID_ISAR5_EL1, ftr_id_isar5),
>>   	ARM64_FTR_REG(SYS_ID_MMFR4_EL1, ftr_id_mmfr4),
> 
>> +	ARM64_FTR_REG(SYS_ID_ISAR6_EL1, ftr_generic_32bits),
> 
> Using ftr_generic_32bits exposes the lowest-common-denominator for all
> 4-bit fields in the register, and I don't think that's the right thing
> to do here, because:
> 
> * We have no idea what ID_ISAR6 bits [31:28] may mean in future.
> 
> * AFAICT, the instructions described by ID_ISAR6.SPECRES (from the
>    ARMv8.0-PredInv extension) operate on the local PE and are not
>    broadcast. To make those work as a guest expects, the host will need
>    to do additional things (e.g. to preserve that illusion when a vCPU is
>    migrated from one pCPU to another and back).
> 
> Given that, think we should add an explicit ftr_id_isar6 which only
> exposes the fields that we're certain are safe to expose to a guest
> (i.e. without SPECRES).

Agree. Thanks for pointing this out. I recommended the usage of
generic_32bits table without actually looking at the feature
definitions.

Anshuman,

Sorry about this.

Cheers
Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
