Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FFBC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:07:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8F5432222A
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:07:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F5432222A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7E8E4B2A3;
	Mon, 18 Jan 2021 08:07:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rf+v5viMbuyP; Mon, 18 Jan 2021 08:07:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FB1B4B270;
	Mon, 18 Jan 2021 08:07:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 654FA4B267
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:07:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tndZuujOxh81 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:07:38 -0500 (EST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C96B4B253
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:07:38 -0500 (EST)
Received: by mail-wr1-f54.google.com with SMTP id w5so16381515wrm.11
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 05:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fApAfVti2xStmYCcy/4S1EcAaXemwrEyH97isCiUdgA=;
 b=fkfgG2GGlDRAgOzcHfGUCb5XrhGcmeGRdSsDpWQ8suunOwB4DhxAxKytiwq57Sy9nT
 QkDRZSmhuWpxYdFiLinfXIlrNME/6hLpoih0jLyM2+85NyfLDjC6bX4zk8Cbpg1ckS8w
 43g0ssguzSAKsd5PI4H3Cv2F5Lbi9w57NCHLB6aWqc2L9117nWRDOAUVPr8HRBb0zTGG
 8C6LmyoQD8ep+dDWpxj1G1Vpijwr3/XqXxCZ+Bx5pF+7Ui+Anrw7aG5VbVyhzUcZYB6H
 w9uA4Ly8A4SjYwuzwqtkowELj81pooRxM08PXZPWALIZSHrPIZlraNJlR1waEDT8n6bt
 KUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fApAfVti2xStmYCcy/4S1EcAaXemwrEyH97isCiUdgA=;
 b=f2Sd/mKH2T2Ttu+Nm3yzdUFm9qqaNz1gNx+P0Mt2v3ppEIG33KEK/Fxx3OTFt4WVbx
 wamwbnn1kIjEIDVGe/KMM09DWOZLLGrN61As4yKCU0/tnG89V/W8NsUqbrDbPQE1YBJx
 Q85IyovteNRVrkMEKWDL0KFOPnMq5AEdYsXiVCN0Ofg1x+ylVNUtfFfYCRIOqmE56fvW
 TD6a+12q7sTKc+3VcKk/eYtgeIb8kONQd4LBZ7Ihy2cdm8PbgHdOYC5Ti1omOHdf7Jra
 d8EJpeVmzuBTT9VcKmykLdGP9TLnZpZFwkUlsiSUBXFdoNt0V0oGOXeuPtrYDnIiQ1q1
 6VDA==
X-Gm-Message-State: AOAM531RdV1XEKr6nRRElkqo1r1cAl3BCUVCWnPlugtJNDEgqJOUZdBX
 +cTGJiqlUHPA+NCCzZuKTwpApw==
X-Google-Smtp-Source: ABdhPJyQKadjPOln9TuGqhkP3mnY+iLzGGewW27eQj9ewfg04ijF5C6QPMBPqYy4T4GANzpf1dk/VQ==
X-Received: by 2002:adf:d1cb:: with SMTP id b11mr20350208wrd.118.1610975257074; 
 Mon, 18 Jan 2021 05:07:37 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:3d4d:985d:87b7:4d55])
 by smtp.gmail.com with ESMTPSA id b7sm28827076wru.33.2021.01.18.05.07.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Jan 2021 05:07:36 -0800 (PST)
Date: Mon, 18 Jan 2021 13:07:35 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 12/21] arm64: cpufeature: Add an early command-line
 cpufeature override facility
Message-ID: <20210118130735.aor3g4eqxazf3mkq@google.com>
References: <20210118094533.2874082-1-maz@kernel.org>
 <20210118094533.2874082-13-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210118094533.2874082-13-maz@kernel.org>
Cc: kernel-team@android.com, Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 Prasad Sodagudi <psodagud@codeaurora.org>, Will Deacon <will@kernel.org>,
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

On Mon, Jan 18, 2021 at 09:45:24AM +0000, Marc Zyngier wrote:
> In order to be able to override CPU features at boot time,
> let's add a command line parser that matches options of the
> form "cpureg.feature=value", and store the corresponding
> value into the override val/mask pair.
> 
> No features are currently defined, so no expected change in
> functionality.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: David Brazdil <dbrazdil@google.com>

> ---
>  arch/arm64/kernel/Makefile         |   2 +-
>  arch/arm64/kernel/head.S           |   1 +
>  arch/arm64/kernel/idreg-override.c | 119 +++++++++++++++++++++++++++++
>  3 files changed, 121 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kernel/idreg-override.c
> 
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 86364ab6f13f..2262f0392857 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -17,7 +17,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
>  			   return_address.o cpuinfo.o cpu_errata.o		\
>  			   cpufeature.o alternative.o cacheinfo.o		\
>  			   smp.o smp_spin_table.o topology.o smccc-call.o	\
> -			   syscall.o proton-pack.o
> +			   syscall.o proton-pack.o idreg-override.o
>  
>  targets			+= efi-entry.o
>  
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index d74e5f84042e..b3c4dd04f74b 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -435,6 +435,7 @@ SYM_FUNC_START_LOCAL(__primary_switched)
>  
>  	mov	x0, x21				// pass FDT address in x0
>  	bl	early_fdt_map			// Try mapping the FDT early
> +	bl	init_shadow_regs
>  	bl	switch_to_vhe
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>  	bl	kasan_early_init
> diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
> new file mode 100644
> index 000000000000..392f93b67103
> --- /dev/null
> +++ b/arch/arm64/kernel/idreg-override.c
> @@ -0,0 +1,119 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Early cpufeature override framework
> + *
> + * Copyright (C) 2020 Google LLC
> + * Author: Marc Zyngier <maz@kernel.org>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/libfdt.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/setup.h>
> +
> +struct reg_desc {
> +	const char * const	name;
> +	u64 * const		val;
> +	u64 * const		mask;
> +	struct {
> +		const char * const	name;
> +		u8			 shift;
nit: There's an extra space before `shift`.

> +	} 			fields[];
> +};
> +
> +static const struct reg_desc * const regs[] __initdata = {
> +};
> +
> +static int __init find_field(const char *cmdline, const struct reg_desc *reg,
> +			     int f, u64 *v)
> +{
> +	char buf[256], *str;
> +	size_t len;
> +
> +	snprintf(buf, ARRAY_SIZE(buf), "%s.%s=", reg->name, reg->fields[f].name);
> +
> +	str = strstr(cmdline, buf);
> +	if (!(str == cmdline || (str > cmdline && *(str - 1) == ' ')))
> +		return -1;
> +
> +	str += strlen(buf);
> +	len = strcspn(str, " ");
> +	len = min(len, ARRAY_SIZE(buf) - 1);
> +	strncpy(buf, str, len);
> +	buf[len] = 0;
> +
> +	return kstrtou64(buf, 0, v);
> +}
> +
> +static void __init match_options(const char *cmdline)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(regs); i++) {
> +		int f;
> +
> +		if (!regs[i]->val || !regs[i]->mask)
> +			continue;
> +
> +		for (f = 0; regs[i]->fields[f].name; f++) {
> +			u64 v;
> +
> +			if (find_field(cmdline, regs[i], f, &v))
> +				continue;
> +
> +			*regs[i]->val  |= (v & 0xf) << regs[i]->fields[f].shift;
> +			*regs[i]->mask |= 0xfUL << regs[i]->fields[f].shift;
> +		}
> +	}
> +}
> +
> +static __init void parse_cmdline(void)
> +{
> +	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
> +		const u8 *prop;
> +		void *fdt;
> +		int node;
> +
> +		fdt = get_early_fdt_ptr();
> +		if (!fdt)
> +			goto out;
> +
> +		node = fdt_path_offset(fdt, "/chosen");
> +		if (node < 0)
> +			goto out;
> +
> +		prop = fdt_getprop(fdt, node, "bootargs", NULL);
> +		if (!prop)
> +			goto out;
> +
> +		match_options(prop);
> +
> +		if (!IS_ENABLED(CONFIG_CMDLINE_EXTEND))
> +			return;
> +	}
> +
> +out:
> +	match_options(CONFIG_CMDLINE);
> +}
> +
> +void __init init_shadow_regs(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(regs); i++) {
> +		if (regs[i]->val)
> +			*regs[i]->val  = 0;
> +		if (regs[i]->mask)
> +			*regs[i]->mask = 0;
> +	}
> +
> +	parse_cmdline();
> +
> +	for (i = 0; i < ARRAY_SIZE(regs); i++) {
> +		if (regs[i]->val)
> +			__flush_dcache_area(regs[i]->val, sizeof(*regs[i]->val));
> +		if (regs[i]->mask)
> +			__flush_dcache_area(regs[i]->mask, sizeof(*regs[i]->mask));
> +	}
> +}
> -- 
> 2.29.2
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
