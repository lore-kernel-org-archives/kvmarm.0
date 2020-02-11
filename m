Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C82AC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 09:26:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2695E2051A
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 09:26:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2695E2051A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 805144AD09;
	Tue, 11 Feb 2020 04:26:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0RM8jT9wsHmF; Tue, 11 Feb 2020 04:26:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD864ACE6;
	Tue, 11 Feb 2020 04:26:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC404AC07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 04:26:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sSlo+o1FjW2i for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 04:26:24 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F33864A4F7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 04:26:23 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9686A31B;
 Tue, 11 Feb 2020 01:26:23 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA8EC3F68E;
 Tue, 11 Feb 2020 01:26:22 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 2/3] arm64: timer: Use the proper RDist
 register name in GICv3
To: Zenghui Yu <yuzenghui@huawei.com>, drjones@redhat.com,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200211083901.1478-1-yuzenghui@huawei.com>
 <20200211083901.1478-3-yuzenghui@huawei.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <50dcce90-b2b6-e375-b8af-9c1c53d43a4a@arm.com>
Date: Tue, 11 Feb 2020 09:26:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200211083901.1478-3-yuzenghui@huawei.com>
Content-Language: en-US
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

Hi,

On 2/11/20 8:39 AM, Zenghui Yu wrote:
> We're actually going to read GICR_ISACTIVER0 and GICR_ISPENDR0 (in
> SGI_base frame of the redistribitor) to get the active/pending state
> of the timer interrupt.  Fix this typo.
>
> And since they have the same value, there's no functional change.
>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  arm/timer.c          | 4 ++--
>  lib/arm/asm/gic-v3.h | 4 ++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arm/timer.c b/arm/timer.c
> index 94543f2..10a88f3 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -351,8 +351,8 @@ static void test_init(void)
>  		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
>  		break;
>  	case 3:
> -		gic_isactiver = gicv3_sgi_base() + GICD_ISACTIVER;
> -		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
> +		gic_isactiver = gicv3_sgi_base() + GICR_ISACTIVER0;
> +		gic_ispendr = gicv3_sgi_base() + GICR_ISPENDR0;
>  		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
>  		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
>  		break;
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 0dc838b..e2736a1 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -32,6 +32,10 @@
>  #define GICR_IGROUPR0			GICD_IGROUPR
>  #define GICR_ISENABLER0			GICD_ISENABLER
>  #define GICR_ICENABLER0			GICD_ICENABLER
> +#define GICR_ISPENDR0			GICD_ISPENDR
> +#define GICR_ICPENDR0			GICD_ICPENDR
> +#define GICR_ISACTIVER0			GICD_ISACTIVER
> +#define GICR_ICACTIVER0			GICD_ICACTIVER
>  #define GICR_IPRIORITYR0		GICD_IPRIORITYR
>  
>  #define ICC_SGI1R_AFFINITY_1_SHIFT	16

Looks like an improvement to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
