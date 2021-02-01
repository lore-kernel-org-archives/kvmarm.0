Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C73FC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 19:06:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD59C64E8D
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 19:06:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD59C64E8D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2563F4B427;
	Mon,  1 Feb 2021 14:06:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x8Qc+evKt1xx; Mon,  1 Feb 2021 14:06:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AF774B428;
	Mon,  1 Feb 2021 14:06:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C068B4B3F6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 14:06:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BWCKZwv6y3Xd for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 14:06:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A04864B3C7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 14:06:27 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B0564E24;
 Mon,  1 Feb 2021 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612206386;
 bh=T3mY97qTIItV8Y42MPe/7OnIIOnipORNs8aCgjUcDfY=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=IK3X+++h0B6P2DMotlKVBwgwm+p26fmU7HUAU1uWWJnmTH9dbm4S29ZapeAO/IFNX
 wXXumwIvhBuHTt6leVMXrHaCknYWtXpMFHEhuDPYwZ7e79REIoHIBrQW/N+2FahWAm
 lSWxcMm/v1ZRquJyuDh4jGkxa6FFsC48AjSU98APyloPdqkFwkJEX3GKC/Q+vYFaQ6
 RbG7juz//Uh5l4ZEU8tLTFZcuG20N6vCXc53cxkcTq0cm5NNyogSU9ubuxW6foC1YQ
 EvPVxGyBT8IqJVy0L4CVuODoaq4lbhgWoWWjl5x+XPghhXPMWqBgsNh7yFZDoFMkTc
 cV6HjB1xTMGFw==
Date: Mon, 1 Feb 2021 19:06:20 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 11/26] KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
Message-ID: <20210201190620.GJ15632@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-12-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-12-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: devicetree@vger.kernel.org, kernel-team@android.com, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu
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

On Fri, Jan 08, 2021 at 12:15:09PM +0000, Quentin Perret wrote:
> In order to use the kernel list library at EL2, introduce stubs for the
> CONFIG_DEBUG_LIST out-of-lines calls.
> 
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/Makefile |  2 +-
>  arch/arm64/kvm/hyp/nvhe/stub.c   | 22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 1fc0684a7678..33bd381d8f73 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -10,7 +10,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
>  lib-objs := $(addprefix ../../../lib/, $(lib-objs))
>  
>  obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
> -	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o
> +	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o
>  obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
>  	 ../fpsimd.o ../hyp-entry.o ../exception.o
>  obj-y += $(lib-objs)
> diff --git a/arch/arm64/kvm/hyp/nvhe/stub.c b/arch/arm64/kvm/hyp/nvhe/stub.c
> new file mode 100644
> index 000000000000..c0aa6bbfd79d
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/stub.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Stubs for out-of-line function calls caused by re-using kernel
> + * infrastructure at EL2.
> + *
> + * Copyright (C) 2020 - Google LLC
> + */
> +
> +#include <linux/list.h>
> +
> +#ifdef CONFIG_DEBUG_LIST
> +bool __list_add_valid(struct list_head *new, struct list_head *prev,
> +		      struct list_head *next)
> +{
> +		return true;
> +}
> +
> +bool __list_del_entry_valid(struct list_head *entry)
> +{
> +		return true;
> +}
> +#endif

Can we get away with defining our own CHECK_DATA_CORRUPTION macro instead?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
