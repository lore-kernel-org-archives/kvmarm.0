Return-Path: <SRS0=/Ra0=HH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD20AC433DB
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 16:42:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2270E64EE1
	for <kvmarm@archiver.kernel.org>; Fri,  5 Feb 2021 16:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2270E64EE1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EA794B40E;
	Fri,  5 Feb 2021 11:42:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YbtpnlH4jLRD; Fri,  5 Feb 2021 11:42:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50F924B43A;
	Fri,  5 Feb 2021 11:42:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2EEB4B40E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 11:42:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SCJYPUrT3ZAj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2021 11:42:15 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CACE4B40C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2021 11:42:15 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1B2E464EDE;
 Fri,  5 Feb 2021 16:42:14 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1l84BP-00CILP-M7; Fri, 05 Feb 2021 16:42:11 +0000
MIME-Version: 1.0
Date: Fri, 05 Feb 2021 16:42:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v6 12/21] arm64: cpufeature: Add an early command-line
 cpufeature override facility
In-Reply-To: <20210205163521.GA22665@willie-the-truck>
References: <20210201115637.3123740-1-maz@kernel.org>
 <20210201115637.3123740-13-maz@kernel.org>
 <20210205163521.GA22665@willie-the-truck>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <a51c546a1e495cc744170244771674fe@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, mark.rutland@arm.com, dbrazdil@google.com,
 alexandru.elisei@arm.com, ardb@kernel.org, jingzhangos@google.com,
 pajay@qti.qualcomm.com, psodagud@codeaurora.org, sramana@codeaurora.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-02-05 16:35, Will Deacon wrote:
> On Mon, Feb 01, 2021 at 11:56:28AM +0000, Marc Zyngier wrote:
>> In order to be able to override CPU features at boot time,
>> let's add a command line parser that matches options of the
>> form "cpureg.feature=value", and store the corresponding
>> value into the override val/mask pair.
>> 
>> No features are currently defined, so no expected change in
>> functionality.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Acked-by: David Brazdil <dbrazdil@google.com>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> ---
>>  arch/arm64/kernel/Makefile         |   2 +-
>>  arch/arm64/kernel/head.S           |   1 +
>>  arch/arm64/kernel/idreg-override.c | 164 
>> +++++++++++++++++++++++++++++
>>  3 files changed, 166 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/kernel/idreg-override.c
>> 
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index 86364ab6f13f..2262f0392857 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -17,7 +17,7 @@ obj-y			:= debug-monitors.o entry.o irq.o 
>> fpsimd.o		\
>>  			   return_address.o cpuinfo.o cpu_errata.o		\
>>  			   cpufeature.o alternative.o cacheinfo.o		\
>>  			   smp.o smp_spin_table.o topology.o smccc-call.o	\
>> -			   syscall.o proton-pack.o
>> +			   syscall.o proton-pack.o idreg-override.o
>> 
>>  targets			+= efi-entry.o
>> 
>> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
>> index d74e5f84042e..3243e3ae9bd8 100644
>> --- a/arch/arm64/kernel/head.S
>> +++ b/arch/arm64/kernel/head.S
>> @@ -435,6 +435,7 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>> 
>>  	mov	x0, x21				// pass FDT address in x0
>>  	bl	early_fdt_map			// Try mapping the FDT early
>> +	bl	init_feature_override
>>  	bl	switch_to_vhe
>>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>>  	bl	kasan_early_init
>> diff --git a/arch/arm64/kernel/idreg-override.c 
>> b/arch/arm64/kernel/idreg-override.c
>> new file mode 100644
>> index 000000000000..d8d0d3b25bc3
>> --- /dev/null
>> +++ b/arch/arm64/kernel/idreg-override.c
>> @@ -0,0 +1,164 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Early cpufeature override framework
>> + *
>> + * Copyright (C) 2020 Google LLC
>> + * Author: Marc Zyngier <maz@kernel.org>
>> + */
>> +
>> +#include <linux/ctype.h>
>> +#include <linux/kernel.h>
>> +#include <linux/libfdt.h>
>> +
>> +#include <asm/cacheflush.h>
>> +#include <asm/setup.h>
>> +
>> +#define FTR_DESC_NAME_LEN	20
>> +#define FTR_DESC_FIELD_LEN	10
>> +
>> +struct ftr_set_desc {
>> +	char 				name[FTR_DESC_NAME_LEN];
>> +	struct arm64_ftr_override	*override;
>> +	struct {
>> +		char			name[FTR_DESC_FIELD_LEN];
>> +		u8			shift;
>> +	} 				fields[];
>> +};
>> +
>> +static const struct ftr_set_desc * const regs[] __initconst = {
>> +};
>> +
>> +static char *cmdline_contains_option(const char *cmdline, const char 
>> *option)
>> +{
>> +	char *str = strstr(cmdline, option);
>> +
>> +	if ((str == cmdline || (str > cmdline && isspace(*(str - 1)))))
>> +		return str;
>> +
>> +	return NULL;
>> +}
>> +
>> +static int __init find_field(const char *cmdline,
>> +			     const struct ftr_set_desc *reg, int f, u64 *v)
>> +{
>> +	char opt[FTR_DESC_NAME_LEN + FTR_DESC_FIELD_LEN + 2], *str;
>> +	size_t len;
>> +
>> +	snprintf(opt, ARRAY_SIZE(opt), "%s.%s=", reg->name, 
>> reg->fields[f].name);
>> +
>> +	str = cmdline_contains_option(cmdline, opt);
>> +	if (!str)
>> +		return -1;
>> +
>> +	str += strlen(opt);
>> +	len = strcspn(str, " ");
> 
> I'm absolutely terrified of string parsing in C, but just wondering why 
> you
> only ignore literal spaces here. I _think_ the full-fat cmdline parsing 
> uses
> isspace() to delimit the options.

That's clearly an oversight, as I use a more complete set of characters
for the rest of the option splicing. I also think that with the way
things are now parsed (options being extracted early and trimmed),
we can drop this altogether.

> Would it be possible to reuse any of the logic over in parse_args() to 
> avoid
> having to roll this ourselves?

Maybe. I need to have a look.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
