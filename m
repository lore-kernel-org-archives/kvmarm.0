Return-Path: <SRS0=hjn/=55=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097EAC2BA19
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 03:33:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 806C7206C3
	for <kvmarm@archiver.kernel.org>; Mon, 13 Apr 2020 03:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 806C7206C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED10D4B12B;
	Sun, 12 Apr 2020 23:33:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JUFYwhrhQrsA; Sun, 12 Apr 2020 23:33:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C63F84B0D0;
	Sun, 12 Apr 2020 23:33:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0704B0D0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Apr 2020 23:33:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 02r6eF0HQ7gs for <kvmarm@lists.cs.columbia.edu>;
 Sun, 12 Apr 2020 23:33:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 835A64B0BA
 for <kvmarm@lists.cs.columbia.edu>; Sun, 12 Apr 2020 23:33:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E24C530E;
 Sun, 12 Apr 2020 20:33:07 -0700 (PDT)
Received: from [10.163.1.49] (unknown [10.163.1.49])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 089B43F6C4;
 Sun, 12 Apr 2020 20:33:04 -0700 (PDT)
Subject: Re: [PATCH 1/6] arm64/cpufeature: Introduce ID_PFR2 CPU register
To: Will Deacon <will@kernel.org>
References: <1580215149-21492-1-git-send-email-anshuman.khandual@arm.com>
 <1580215149-21492-2-git-send-email-anshuman.khandual@arm.com>
 <20200409125431.GB13078@willie-the-truck>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <8b905244-c296-3859-b515-711550bef3a2@arm.com>
Date: Mon, 13 Apr 2020 09:02:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200409125431.GB13078@willie-the-truck>
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



On 04/09/2020 06:24 PM, Will Deacon wrote:
> On Tue, Jan 28, 2020 at 06:09:04PM +0530, Anshuman Khandual wrote:
>> This adds basic building blocks required for ID_PFR2 CPU register which
>> provides information about the AArch32 programmers model which must be
>> interpreted along with ID_PFR0 and ID_PFR1 CPU registers.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: James Morse <james.morse@arm.com>
>> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/cpu.h    |  1 +
>>  arch/arm64/include/asm/sysreg.h |  4 ++++
>>  arch/arm64/kernel/cpufeature.c  | 11 +++++++++++
>>  arch/arm64/kernel/cpuinfo.c     |  1 +
>>  arch/arm64/kvm/sys_regs.c       |  2 +-
>>  5 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
>> index b4a40535a3d8..464e828a994d 100644
>> --- a/arch/arm64/include/asm/cpu.h
>> +++ b/arch/arm64/include/asm/cpu.h
>> @@ -46,6 +46,7 @@ struct cpuinfo_arm64 {
>>  	u32		reg_id_mmfr3;
>>  	u32		reg_id_pfr0;
>>  	u32		reg_id_pfr1;
>> +	u32		reg_id_pfr2;
>>  
>>  	u32		reg_mvfr0;
>>  	u32		reg_mvfr1;
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index b91570ff9db1..054aab7ebf1b 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -151,6 +151,7 @@
>>  #define SYS_MVFR0_EL1			sys_reg(3, 0, 0, 3, 0)
>>  #define SYS_MVFR1_EL1			sys_reg(3, 0, 0, 3, 1)
>>  #define SYS_MVFR2_EL1			sys_reg(3, 0, 0, 3, 2)
>> +#define SYS_ID_PFR2_EL1			sys_reg(3, 0, 0, 3, 4)
>>  
>>  #define SYS_ID_AA64PFR0_EL1		sys_reg(3, 0, 0, 4, 0)
>>  #define SYS_ID_AA64PFR1_EL1		sys_reg(3, 0, 0, 4, 1)
>> @@ -717,6 +718,9 @@
>>  #define ID_ISAR6_DP_SHIFT		4
>>  #define ID_ISAR6_JSCVT_SHIFT		0
>>  
>> +#define ID_PFR2_SSBS_SHIFT		4
>> +#define ID_PFR2_CSV3_SHIFT		0
>> +
>>  #define MVFR0_FPROUND_SHIFT		28
>>  #define MVFR0_FPSHVEC_SHIFT		24
>>  #define MVFR0_FPSQRT_SHIFT		20
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 0b6715625cf6..c1e837fc8f97 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -348,6 +348,12 @@ static const struct arm64_ftr_bits ftr_id_pfr0[] = {
>>  	ARM64_FTR_END,
>>  };
>>  
>> +static const struct arm64_ftr_bits ftr_id_pfr2[] = {
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_PFR2_SSBS_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_PFR2_CSV3_SHIFT, 4, 0),
> 
> Why is CSV3 strict here, but not when we see if in aa64pfr0? I think it
> should be non-strict in both cases.

Sure, will do.

> 
> Will
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
