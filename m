Return-Path: <SRS0=6Z91=G2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1376DC433E0
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 16:04:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B87922B40
	for <kvmarm@archiver.kernel.org>; Sat, 23 Jan 2021 16:04:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B87922B40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E135A4B17C;
	Sat, 23 Jan 2021 11:04:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RjEQJVFRc5Ny; Sat, 23 Jan 2021 11:04:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB0674B17D;
	Sat, 23 Jan 2021 11:04:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C524B173
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 11:04:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RJe3Alu7wh4K for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Jan 2021 11:04:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B1A4B0C3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Jan 2021 11:04:41 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EA4B11D4;
 Sat, 23 Jan 2021 08:04:40 -0800 (PST)
Received: from [10.57.40.145] (unknown [10.57.40.145])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60D263F68F;
 Sat, 23 Jan 2021 08:04:34 -0800 (PST)
Subject: Re: [PATCH v4 10/21] arm64: cpufeature: Use IDreg override in
 __read_sysreg_by_encoding()
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-11-maz@kernel.org> <20210122185344.GH8567@gaia>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <95659e7f-090e-0ff7-3e89-1ed17df68e6d@arm.com>
Date: Sat, 23 Jan 2021 16:04:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122185344.GH8567@gaia>
Content-Language: en-GB
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>, kernel-team@android.com,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Ajay Patil <pajay@qti.qualcomm.com>, Will Deacon <will@kernel.org>,
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

On 1/22/21 6:53 PM, Catalin Marinas wrote:
> On Mon, Jan 18, 2021 at 09:45:22AM +0000, Marc Zyngier wrote:
>> __read_sysreg_by_encoding() is used by a bunch of cpufeature helpers,
>> which should take the feature override into account. Let's do that.
>>
>> For a good measure (and because we are likely to need to further
>> down the line), make this helper available to the rest of the
>> non-modular kernel.
>>
>> Code that needs to know the *real* features of a CPU can still
>> use read_sysreg_s(), and find the bare, ugly truth.
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>

>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index aaa075c6f029..48a011935d8c 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -1149,14 +1149,17 @@ u64 read_sanitised_ftr_reg(u32 id)
>>   EXPORT_SYMBOL_GPL(read_sanitised_ftr_reg);
>>   
>>   #define read_sysreg_case(r)	\
>> -	case r:		return read_sysreg_s(r)
>> +	case r:		val = read_sysreg_s(r); break;
>>   
>>   /*
>>    * __read_sysreg_by_encoding() - Used by a STARTING cpu before cpuinfo is populated.
>>    * Read the system register on the current CPU
>>    */
>> -static u64 __read_sysreg_by_encoding(u32 sys_id)
>> +u64 __read_sysreg_by_encoding(u32 sys_id)
>>   {
>> +	struct arm64_ftr_reg *regp;
>> +	u64 val;
>> +
>>   	switch (sys_id) {
>>   	read_sysreg_case(SYS_ID_PFR0_EL1);
>>   	read_sysreg_case(SYS_ID_PFR1_EL1);
>> @@ -1199,6 +1202,14 @@ static u64 __read_sysreg_by_encoding(u32 sys_id)
>>   		BUG();
>>   		return 0;
>>   	}
>> +
>> +	regp  = get_arm64_ftr_reg(sys_id);
>> +	if (regp && regp->override_mask && regp->override_val) {
>> +		val &= ~*regp->override_mask;
>> +		val |= (*regp->override_val & *regp->override_mask);
>> +	}
>> +
>> +	return val;
> 
> Ah, now the previous patch makes more sense. I don't particularly like
> this but I can't tell how to work around it. I was hoping that the
> overriding feature behaves more like a secondary CPU that limits all the
> overridden features. However, this approach would fail for FTR_EXACT
> cases (like PAC, though I wonder whether it fails already with your
> previous patch since the boot CPU value won't match the override, hence
> dropping to the safe one).
> 

Correct !For FTR_EXACT, we dont want to override a value that is not safe, e.g PAC.
This is handled correctly in the previous patch and thus we are covered.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
