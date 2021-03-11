Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C69C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 16:11:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 543F864FEB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 16:11:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 543F864FEB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9554B6D0;
	Thu, 11 Mar 2021 11:11:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d1TdKEyXWcpv; Thu, 11 Mar 2021 11:11:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D81B14B6E0;
	Thu, 11 Mar 2021 11:11:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E8EE4B6D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 11:11:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SvlyVDGdeSe4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 11:11:36 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33DC04B6D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 11:11:36 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B2464FA3;
 Thu, 11 Mar 2021 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615479095;
 bh=E87K7pnoXEeIDrTmeoC6YBHh9dve+IPi3cHQxxCc+48=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=r4nQkqHdL2JuiHy0v2ICafmTOqoiN8+zS4zbPAFePc4r1RMXoTJGboIAYvQZfEPBF
 GASa0lX9rDFbjdV/u9cqZYMIfoNOCbLZtk5qU9ZXXBK88F9pjPW5AaudDHtLSMCwAK
 UaCYzk52WXL9ew+/ibFLCtNCEoxbKtXA8hLTLaHKBz0VYcIBOLhKVG/yDso31B+O3a
 kg08E5Shw0uyYbCKengLJSNL8r9DwTPM+BhQI9l/Avm9I16E4tw+u/FbILg0EGqcOZ
 ZhHS/8FgummcqWjQ+ZKJoYyJ9/JRTfmt/XT0iRGrGFYfvcz9ARI3R119VVk1wpNUE2
 /M+7wLuvdDMlQ==
Date: Thu, 11 Mar 2021 16:11:28 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 11/34] KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
Message-ID: <20210311161127.GB31206@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-12-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310175751.3320106-12-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 10, 2021 at 05:57:28PM +0000, Quentin Perret wrote:
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
> index 24ff99e2eac5..144da72ad510 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -13,7 +13,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
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

This isn't any worse than disabling DEBUG_LIST for the EL2 object, so as
an initial implementation:

Acked-by: Will Deacon <will@kernel.org>

but we really should have the debug list checks on (probably
unconditionally) for the EL2 code in my opinion.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
