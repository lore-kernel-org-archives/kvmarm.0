Return-Path: <SRS0=r+CV=5K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43340C43331
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 10:39:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE79220775
	for <kvmarm@archiver.kernel.org>; Wed, 25 Mar 2020 10:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE79220775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 285704B08E;
	Wed, 25 Mar 2020 06:39:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SyxPoiy+sNSh; Wed, 25 Mar 2020 06:39:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B3774B08F;
	Wed, 25 Mar 2020 06:39:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C468E4B088
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 06:38:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PChnG0g3rq4u for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2020 06:38:58 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EB804A588
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2020 06:38:58 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 7787C72ABDB49AE56E7A;
 Wed, 25 Mar 2020 18:38:47 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.25) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 25 Mar 2020
 18:38:42 +0800
Subject: Re: [PATCH v2 67/94] arm64: Add level-hinted TLB invalidation helper
To: Marc Zyngier <maz@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-68-maz@kernel.org>
From: Zhenyu Ye <yezhenyu2@huawei.com>
Message-ID: <b4120382-d175-0c2f-249e-cc77a09709db@huawei.com>
Date: Wed, 25 Mar 2020 18:38:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200211174938.27809-68-maz@kernel.org>
X-Originating-IP: [10.173.220.25]
X-CFilter-Loop: Reflected
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

Hi Marc,

On 2020/2/12 1:49, Marc Zyngier wrote:
> Add a level-hinted TLB invalidation helper that only gets used if
> ARMv8.4-TTL gets detected.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/tlbflush.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index bc3949064725..a3f70778a325 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -10,6 +10,7 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#include <linux/bitfield.h>
>  #include <linux/mm_types.h>
>  #include <linux/sched.h>
>  #include <asm/cputype.h>
> @@ -59,6 +60,35 @@
>  		__ta;						\
>  	})
>  
> +#define TLBI_TTL_MASK	GENMASK_ULL(47, 44)
> +
> +#define __tlbi_level(op, addr, level)					\
> +	do {								\
> +		u64 arg = addr;						\
> +									\
> +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
> +		    level) {						\
> +			u64 ttl = level;				\
> +									\
> +			switch (PAGE_SIZE) {				\
> +			case SZ_4K:					\
> +				ttl |= 1 << 2;				\
> +				break;					\
> +			case SZ_16K:					\
> +				ttl |= 2 << 2;				\
> +				break;					\
> +			case SZ_64K:					\
> +				ttl |= 3 << 2;				\
> +				break;					\
> +			}						\

Can we define a macro here to replace the switch? It will be more
clearly and efficient. Such as:

#define __TG ((PAGE_SHIFT - 12) / 2 + 1)
ttl |= __TG << 2;

> +									\
> +			arg &= ~TLBI_TTL_MASK;				\
> +			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\
> +		}							\
> +									\
> +		__tlbi(op,  arg);					\
> +	} while(0)
> +
>  /*
>   *	TLB Invalidation
>   *	================
> 

Thanks,
Zhenyu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
