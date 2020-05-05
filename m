Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E6BC47247
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 07:02:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9045820721
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 07:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9045820721
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFD184B319;
	Tue,  5 May 2020 03:02:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QMkuULRjz9cp; Tue,  5 May 2020 03:02:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A5974B30E;
	Tue,  5 May 2020 03:02:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B14654B2CC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 03:02:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tEwAtC88W4oe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 03:02:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFB984B2A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 03:02:28 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 599271FB;
 Tue,  5 May 2020 00:02:28 -0700 (PDT)
Received: from [10.163.71.248] (unknown [10.163.71.248])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 467B53F68F;
 Tue,  5 May 2020 00:02:24 -0700 (PDT)
Subject: Re: [PATCH V3 06/16] arm64/cpufeature: Introduce ID_MMFR5 CPU register
To: Will Deacon <will@kernel.org>
References: <1588426445-24344-1-git-send-email-anshuman.khandual@arm.com>
 <1588426445-24344-7-git-send-email-anshuman.khandual@arm.com>
 <20200504203313.GB5012@willie-the-truck>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <97cd9ba9-d5de-2a85-5eac-0cb460061617@arm.com>
Date: Tue, 5 May 2020 12:31:54 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200504203313.GB5012@willie-the-truck>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
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



On 05/05/2020 02:03 AM, Will Deacon wrote:
> On Sat, May 02, 2020 at 07:03:55PM +0530, Anshuman Khandual wrote:
>> This adds basic building blocks required for ID_MMFR5 CPU register which
>> provides information about the implemented memory model and memory
>> management support in AArch32 state. This is added per ARM DDI 0487F.a
>> specification.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>>
>> Suggested-by: Will Deacon <will@kernel.org>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/cpu.h    |  1 +
>>  arch/arm64/include/asm/sysreg.h |  3 +++
>>  arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
>>  arch/arm64/kernel/cpuinfo.c     |  1 +
>>  arch/arm64/kvm/sys_regs.c       |  2 +-
>>  5 files changed, 16 insertions(+), 1 deletion(-)
> 
> [...]
> 
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 2ce952d9668d..c790cc200bb1 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -403,6 +403,11 @@ static const struct arm64_ftr_bits ftr_id_isar4[] = {
>>  	ARM64_FTR_END,
>>  };
>>  
>> +static const struct arm64_ftr_bits ftr_id_mmfr5[] = {
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_MMFR5_ETS_SHIFT, 4, 0),
>> +	ARM64_FTR_END,
>> +};
>> +
>>  static const struct arm64_ftr_bits ftr_id_isar6[] = {
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR6_I8MM_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_ISAR6_BF16_SHIFT, 4, 0),
>> @@ -527,6 +532,7 @@ static const struct __ftr_reg_entry {
>>  	ARM64_FTR_REG(SYS_MVFR2_EL1, ftr_mvfr2),
>>  	ARM64_FTR_REG(SYS_ID_PFR2_EL1, ftr_id_pfr2),
>>  	ARM64_FTR_REG(SYS_ID_DFR1_EL1, ftr_id_dfr1),
>> +	ARM64_FTR_REG(SYS_ID_MMFR5_EL1, ftr_id_mmfr5),
>>  
>>  	/* Op1 = 0, CRn = 0, CRm = 4 */
>>  	ARM64_FTR_REG(SYS_ID_AA64PFR0_EL1, ftr_id_aa64pfr0),
>> @@ -732,6 +738,7 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
>>  		init_cpu_ftr_reg(SYS_ID_MMFR1_EL1, info->reg_id_mmfr1);
>>  		init_cpu_ftr_reg(SYS_ID_MMFR2_EL1, info->reg_id_mmfr2);
>>  		init_cpu_ftr_reg(SYS_ID_MMFR3_EL1, info->reg_id_mmfr3);
>> +		init_cpu_ftr_reg(SYS_ID_MMFR5_EL1, info->reg_id_mmfr5);
>>  		init_cpu_ftr_reg(SYS_ID_PFR0_EL1, info->reg_id_pfr0);
>>  		init_cpu_ftr_reg(SYS_ID_PFR1_EL1, info->reg_id_pfr1);
>>  		init_cpu_ftr_reg(SYS_ID_PFR2_EL1, info->reg_id_pfr2);
>> @@ -866,6 +873,8 @@ static int update_32bit_cpu_features(int cpu, struct cpuinfo_arm64 *info,
>>  				      info->reg_id_mmfr2, boot->reg_id_mmfr2);
>>  	taint |= check_update_ftr_reg(SYS_ID_MMFR3_EL1, cpu,
>>  				      info->reg_id_mmfr3, boot->reg_id_mmfr3);
> 
> Looks like MMFR4 is missing here?

ID_MMFR4 is missing from cpuinfo_arm64 itself, hence from init_cpu_features()
and update_cpu_features() as well. But it is defined in arm64_ftr_regs[]. I
was wondering about it but left as it is (due to lack of complete context).
Unless there is any other concern, will add it up in cpuinfo_arm64 and make
it a part of the CPU context.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
