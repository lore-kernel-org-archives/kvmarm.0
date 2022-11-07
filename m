Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14B6C43217
	for <kvmarm@archiver.kernel.org>; Thu, 10 Nov 2022 14:51:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34C864BB65;
	Thu, 10 Nov 2022 09:51:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1uQq0DB-cTx9; Thu, 10 Nov 2022 09:51:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD3E4BB29;
	Thu, 10 Nov 2022 09:51:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7592E4B87C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:58:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lC6erWwSb7Y1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 12:58:04 -0500 (EST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4360D4B868
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 12:58:04 -0500 (EST)
Received: by mail-wm1-f47.google.com with SMTP id
 fn7-20020a05600c688700b003b4fb113b86so7667670wmb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Nov 2022 09:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=mime-version:user-agent:message-id:date:references:subject:cc:to
 :from:from:to:cc:subject:date:message-id:reply-to;
 bh=3/UsOLSVJeRrP3hKZ9XAB4D/JQx5F5JGX1FwiQPvVuU=;
 b=cN2PpU8w5R2dGTCKi5Q3mrHU2O2eEm8NRLA4oJn3gXKgwYvWUGzX8ieo/RXw6RfGik
 dnpAhH0P9gzQTOtEFsMuej1JSGcRVQT2+jz9EQxY7IW1NmU2uGRHyGwOnWHtqiehjA82
 Qe14hhcb7Ob/3syPlHGOy9eSFnY0s5lUJ01BQXgog2TBMZJUqSACQtWVmIiq2K5sfeqx
 0CN5GAmfwLAp8ZzsHzVmhCM1cPGAUsRs5qh1aGWg+UIPv2TfXtFF7pe8N1Ar7p7qFMHJ
 0gqYD9GtLugFGiVJRyelKODICgOo6FrDlzU/SS6CCTinBOMn1PlHse8jAoL0wga5t3tC
 nOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=mime-version:user-agent:message-id:date:references:subject:cc:to
 :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=3/UsOLSVJeRrP3hKZ9XAB4D/JQx5F5JGX1FwiQPvVuU=;
 b=vL+uNApDx7y485GPqO4gxnZd7O2cb354W1jlxXRRll0meK4NOtULPqsau9P3XPFPzx
 nEhtQkrr65gs5wkZsXfZNq+MaPrlRRqVQKC89hf5u7btJBgyIupKO9WeoXuIanphdc5c
 Y8nLZkqogtXv7xwVSgM3EBalIEfVgwwvX3RwcoqSOG8RBf1qg99FjFofJ33jWDc5oCFY
 OPX+/CFTS1/iWMWiF1Yi/aFMFABJKFSVnalP4AuXzUdU4dNqYGOvAKPnpN/4FLtUtkwi
 YxdwZzX1lySJnp+z94uYmLeR7HlK7jpnFimCG0ygyErRl0+gc6Yva4J152bTfkB2AFxF
 KBOQ==
X-Gm-Message-State: ANoB5pmmfYfnprDsgmboqmxPgTKUhVsmgrvvBZA3WsNsbHHwHYFadZPR
 HsjUjgnc0+tc0+MZL/AW9iq9Gg==
X-Google-Smtp-Source: AA0mqf45hAf2eMGXeCEaPsHNxIabuTwUDaLIbBELqZs+Mkr1Si2gd7+wy0i/EyOsvqAwI8wbbgmJXw==
X-Received: by 2002:a05:600c:1695:b0:3cf:a9b7:81e7 with SMTP id
 k21-20020a05600c169500b003cfa9b781e7mr5268454wmn.116.1667843883081; 
 Mon, 07 Nov 2022 09:58:03 -0800 (PST)
Received: from localhost ([95.148.15.66]) by smtp.gmail.com with ESMTPSA id
 n17-20020a5d6611000000b002383edcde09sm7994811wru.59.2022.11.07.09.58.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Nov 2022 09:58:02 -0800 (PST)
From: Punit Agrawal <punit.agrawal@bytedance.com>
To: Usama Arif <usama.arif@bytedance.com>
Subject: Re: [v2 2/6] KVM: arm64: Add SMCCC paravirtualised lock calls
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <20221104062105.4119003-3-usama.arif@bytedance.com>
Date: Mon, 07 Nov 2022 17:58:01 +0000
Message-ID: <87cz9y3avq.fsf@stealth>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 10 Nov 2022 09:51:44 -0500
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
 fam.zheng@bytedance.com, bagasdotme@gmail.com, maz@kernel.org,
 punit.agrawal@bytedance.com, linux@armlinux.org.uk, liangma@liangbit.com,
 steven.price@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Usama Arif <usama.arif@bytedance.com> writes:

> Add a new SMCCC compatible hypercalls for PV lock features:
>   ARM_SMCCC_KVM_FUNC_PV_LOCK:   0xC6000002
>
> Also add the header file which defines the ABI for the paravirtualized
> lock features we're about to add.
>
> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>  arch/arm64/include/asm/pvlock-abi.h | 17 +++++++++++++++++
>  include/linux/arm-smccc.h           |  8 ++++++++
>  tools/include/linux/arm-smccc.h     |  8 ++++++++
>  3 files changed, 33 insertions(+)
>  create mode 100644 arch/arm64/include/asm/pvlock-abi.h
>
> diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
> new file mode 100644
> index 000000000000..3f4574071679
> --- /dev/null
> +++ b/arch/arm64/include/asm/pvlock-abi.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
> + * Author: Zengruan Ye <yezengruan@huawei.com>
> + *         Usama Arif <usama.arif@bytedance.com>
> + */
> +
> +#ifndef __ASM_PVLOCK_ABI_H
> +#define __ASM_PVLOCK_ABI_H
> +
> +struct pvlock_vcpu_state {
> +	__le64 preempted;
> +	/* Structure must be 64 byte aligned, pad to that size */
> +	u8 padding[56];
> +} __packed;

For structure alignment, I'd have expected to see the use of "aligned"
attribute. Is there any benefit in using padding to achieve alignment?

[...]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
