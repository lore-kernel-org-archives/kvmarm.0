Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D888B2451C1
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 04:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733891578; cv=none; b=V4lE8aXM1KoxwMEwze5jQwtH4LxIpXslcPXvREudMIgdNbTsf55H2bPwPB3ZrEhgr85h9VyLtDbE2xebgyugyiAmyLMcU6cjANX81GN2kLebcZ+C51DDU6Q+6EZe3fSXgZkX54tdexyeAv7bEbfuE0MUlZNLaUUivJPHuS1HsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733891578; c=relaxed/simple;
	bh=NUK3jR8qNd4aOTWycj86Dbw7wtn4nFZ4Q8YBK/qOy/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LXMlnK6QcS41vHAFK9LrFtdr9uP0QtEwqN/M83JeowjiiQ+ksqJEhkEiONkvhd6xCYBG69wmq4KGbXloWSA6jEHvR9Wl+bO5lHSyXMprdzCgVS+x9+BI6a7waG9mPvtiO76HovDEJZLhlL4dbXOZp9X22l8NHpy8s+an/QVXw/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AD7B1007;
	Tue, 10 Dec 2024 20:33:16 -0800 (PST)
Received: from [10.162.16.49] (a077893.blr.arm.com [10.162.16.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 287173F720;
	Tue, 10 Dec 2024 20:32:44 -0800 (PST)
Message-ID: <a382200e-00c4-405a-a417-f4c09bd91fb7@arm.com>
Date: Wed, 11 Dec 2024 10:02:42 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 5/7] arm64/cpufeature: Add field details for
 ID_AA64DFR1_EL1 register
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
 <20241028053426.2486633-6-anshuman.khandual@arm.com>
 <20241210164144.GA16039@willie-the-truck>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20241210164144.GA16039@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/10/24 22:11, Will Deacon wrote:
> On Mon, Oct 28, 2024 at 11:04:24AM +0530, Anshuman Khandual wrote:
>> This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
>> ftr_raz[] array which is now redundant. These register fields will be used
>> to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
>> later.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> cc: Mark Brown <broonie@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/kernel/cpufeature.c | 21 ++++++++++++++++-----
>>  1 file changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 718728a85430..bd4d85f5dd92 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -530,6 +530,21 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>>  	ARM64_FTR_END,
>>  };
>>  
>> +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
>> +	ARM64_FTR_END,
>> +};
> 
> I think I mentioned this on an earlier series, but it would be useful to
> see some justification in the commit message as to why some of these
> features are considered STRICT vs NONSTRICT and why LOWER_SAFE is
> preferred over EXACT.

I have updated the commit message regarding STRICT vs NONSTRICT as Mark had
mentioned earlier (see below). But just wondering about FTR_LOWER_SAFE. All
similar fields have been marked as FTR_LOWER_SAFE.

> 
> For example, why is EBEP strict whereas other PMU-related fields aren't?

IIUC there are two types of fields here.

- Feature presence     (EBEP, ITE, ABLE etc)		---> FTR_STRICT
- Debug resource count (WRPs, BRPs, CTX_CMPs etc)	---> FTR_NONSTRICT

> Why is the CTX_CMPs field treated differently to the same field in DFR0?

There is mismatch not only for CTX_CMPs but for WRPs and BRPs as well. As
mentioned earlier, being resource count type, I believe these should be
marked as FTR_NONSTRICT in existing DFR0 as well. I could send a patch
fixing DFR0 first.

> 
> I'm not saying the above table is wrong, it just looks arbitrary without
> the justification.

Please find the updated version (v3) for this patch here for reference.

--------------
[PATCH] arm64/cpufeature: Add field details for ID_AA64DFR1_EL1 register

This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
ftr_raz[] array which is now redundant. These register fields will be used
to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
later. The register fields have been marked as FTR_STRICT, unless there is
a known variation in practice.

Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ce71f444ed8..0dc22fde104e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -534,6 +534,21 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
+	ARM64_FTR_END,
+};
+
 static const struct arm64_ftr_bits ftr_mvfr0[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_EL1_FPRound_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, MVFR0_EL1_FPShVec_SHIFT, 4, 0),
@@ -720,10 +735,6 @@ static const struct arm64_ftr_bits ftr_single32[] = {
 	ARM64_FTR_END,
 };
 
-static const struct arm64_ftr_bits ftr_raz[] = {
-	ARM64_FTR_END,
-};
-
 #define __ARM64_FTR_REG_OVERRIDE(id_str, id, table, ovr) {	\
 		.sys_id = id,					\
 		.reg = 	&(struct arm64_ftr_reg){		\
@@ -796,7 +807,7 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 0, CRm = 5 */
 	ARM64_FTR_REG(SYS_ID_AA64DFR0_EL1, ftr_id_aa64dfr0),
-	ARM64_FTR_REG(SYS_ID_AA64DFR1_EL1, ftr_raz),
+	ARM64_FTR_REG(SYS_ID_AA64DFR1_EL1, ftr_id_aa64dfr1),
 
 	/* Op1 = 0, CRn = 0, CRm = 6 */
 	ARM64_FTR_REG(SYS_ID_AA64ISAR0_EL1, ftr_id_aa64isar0),
-- 
2.25.1
--------------
Changes in V3:
 
- Updated commit message regarding FTR_STRICT
- Updated ID_AA64DFR1_EL1.ABLE as FTR_NONSTRICT
