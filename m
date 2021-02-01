Return-Path: <SRS0=CHPd=HD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3B2C433DB
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:28:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2C0064EAC
	for <kvmarm@archiver.kernel.org>; Mon,  1 Feb 2021 17:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2C0064EAC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 66DA84B398;
	Mon,  1 Feb 2021 12:28:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H-vpvcSXLDGW; Mon,  1 Feb 2021 12:28:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B14F4B39F;
	Mon,  1 Feb 2021 12:28:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5922D4B2DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:28:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 21yPkiSlPqq9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  1 Feb 2021 12:28:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 59DB44B2D9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  1 Feb 2021 12:28:41 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77E5F64EA9;
 Mon,  1 Feb 2021 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612200520;
 bh=uHAWWNmon96KsVjmF8ftVBBdEemkthXQ9UJ2fc8srng=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=CvvqVRBGSncQ6Xl0DR8gjXVt3iAOTkyc7pce4aId8ICWxg6VACch4KtFpnYVLnmM0
 PE7ItfKktIRiDNqh7Doo9Xfv5rmfLLKmU179IQx5nVT06+Lw2xgisT7u5GvGOLE94r
 eYoDXigDq3eE2yjj7UO32kd7q7wtHyt2j8Am/WYH6BPNqYtIUMwk3x2d+qVOfVK1aV
 bp6HTErm/mDCVqnYV2WdLnjlin63sROqBW/Hht+GatldssqbfS8MA5N1tlWKakjzZC
 nB83x2hfJxugpY+PMHwWVg7lnc4Y6rHRzCgJ66hnF4T/7xnjvdM4CZQelCzbAER10e
 0emvH5Ijw9whA==
Date: Mon, 1 Feb 2021 17:28:34 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH v2 03/26] arm64: kvm: Add standalone ticket spinlock
 implementation for use at hyp
Message-ID: <20210201172833.GA15632@willie-the-truck>
References: <20210108121524.656872-1-qperret@google.com>
 <20210108121524.656872-4-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210108121524.656872-4-qperret@google.com>
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

On Fri, Jan 08, 2021 at 12:15:01PM +0000, Quentin Perret wrote:
> From: Will Deacon <will@kernel.org>
> 
> We will soon need to synchronise multiple CPUs in the hyp text at EL2.
> The qspinlock-based locking used by the host is overkill for this purpose
> and relies on the kernel's "percpu" implementation for the MCS nodes.
> 
> Implement a simple ticket locking scheme based heavily on the code removed
> by commit c11090474d70 ("arm64: locking: Replace ticket lock implementation
> with qspinlock").
> 
> Signed-off-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/spinlock.h | 92 ++++++++++++++++++++++
>  1 file changed, 92 insertions(+)
>  create mode 100644 arch/arm64/kvm/hyp/include/nvhe/spinlock.h
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/spinlock.h b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
> new file mode 100644
> index 000000000000..7584c397bbac
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/include/nvhe/spinlock.h
> @@ -0,0 +1,92 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * A stand-alone ticket spinlock implementation for use by the non-VHE
> + * KVM hypervisor code running at EL2.
> + *
> + * Copyright (C) 2020 Google LLC
> + * Author: Will Deacon <will@kernel.org>
> + *
> + * Heavily based on the implementation removed by c11090474d70 which was:
> + * Copyright (C) 2012 ARM Ltd.
> + */
> +
> +#ifndef __ARM64_KVM_NVHE_SPINLOCK_H__
> +#define __ARM64_KVM_NVHE_SPINLOCK_H__
> +
> +#include <asm/alternative.h>
> +#include <asm/lse.h>
> +
> +typedef union hyp_spinlock {
> +	u32	__val;
> +	struct {
> +#ifdef __AARCH64EB__
> +		u16 next, owner;
> +#else
> +		u16 owner, next;
> +	};
> +#endif

Looks like I put this #endif in the wrong place; probably needs to be a line
higher.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
