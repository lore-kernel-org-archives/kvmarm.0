Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56FAC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 10:57:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1080041173;
	Tue, 25 Jan 2022 05:57:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CEl-IrJtU4Vc; Tue, 25 Jan 2022 05:57:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9CC349AF7;
	Tue, 25 Jan 2022 05:57:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F68141173
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 05:57:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c-50uwPP1C5Y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 05:57:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2AE340B85
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 05:57:51 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1E2551FB;
 Tue, 25 Jan 2022 02:57:51 -0800 (PST)
Received: from [10.57.86.86] (unknown [10.57.86.86])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2A303F7D8;
 Tue, 25 Jan 2022 02:57:48 -0800 (PST)
Message-ID: <edc0a8a0-5439-ff34-3de0-89ae0a4e60f4@arm.com>
Date: Tue, 25 Jan 2022 10:57:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v8 01/38] arm64: cpufeature: Always specify and use a
 field width for capabilities
To: Mark Brown <broonie@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
References: <20220125001114.193425-1-broonie@kernel.org>
 <20220125001114.193425-2-broonie@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20220125001114.193425-2-broonie@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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

On 25/01/2022 00:10, Mark Brown wrote:
> Since all the fields in the main ID registers are 4 bits wide we have up
> until now not bothered specifying the width in the code. Since we now
> wish to use this mechanism to enumerate features from the floating point
> feature registers which do not follow this pattern add a width to the
> table.  This means updating all the existing table entries but makes it
> less likely that we run into issues in future due to implicitly assuming
> a 4 bit width.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   arch/arm64/include/asm/cpufeature.h |   1 +
>   arch/arm64/kernel/cpufeature.c      | 167 +++++++++++++++++-----------
>   2 files changed, 102 insertions(+), 66 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index ef6be92b1921..2728abd9cae4 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -356,6 +356,7 @@ struct arm64_cpu_capabilities {
>   		struct {	/* Feature register checking */
>   			u32 sys_reg;
>   			u8 field_pos;
> +			u8 field_width;
>   			u8 min_field_value;
>   			u8 hwcap_type;
>   			bool sign;


> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index a46ab3b1c4d5..d9f09e40aaf6 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1307,7 +1307,9 @@ u64 __read_sysreg_by_encoding(u32 sys_id)
>   static bool
>   feature_matches(u64 reg, const struct arm64_cpu_capabilities *entry)
>   {
> -	int val = cpuid_feature_extract_field(reg, entry->field_pos, entry->sign);
> +	int val = cpuid_feature_extract_field_width(reg, entry->field_pos,
> +						    entry->field_width,
> +						    entry->sign);
>   

Could we do something like :

+ int val = cpuid_feature_extract_field_width(reg, 		entry->field_pos,
		entry->field_width ? : 4,
		..
		);

and leave the existing structures as they are ?

>   	return val >= entry->min_field_value;
>   }
> @@ -1952,6 +1954,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {

There is arm64_errata[] array in cpu_errata.c. So, if we use the above
proposal we could leave things unchanged for all existing uses.

>   		.matches = has_cpuid_feature,
>   		.sys_reg = SYS_ID_AA64MMFR0_EL1,
>   		.field_pos = ID_AA64MMFR0_ECV_SHIFT,
> +		.field_width = 4,
>   		.sign = FTR_UNSIGNED,
>   		.min_field_value = 1,
>   	},
...

> -#define HWCAP_CPUID_MATCH(reg, field, s, min_value)				\
> +#define HWCAP_CPUID_MATCH(reg, field, width, s, min_value)			\
>   		.matches = has_cpuid_feature,					\
>   		.sys_reg = reg,							\
>   		.field_pos = field,						\
> +		.field_width = width,						\
>   		.sign = s,							\
>   		.min_field_value = min_value,

And that could avoid these changes too. We could add :

#define HWCAP_CPUID_MATCH_WIDTH(...)

when/if we need one, which sets the width.

Cheers
Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
