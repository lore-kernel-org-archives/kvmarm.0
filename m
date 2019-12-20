Return-Path: <SRS0=zNRV=2K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0277FC43603
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 07:10:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7AD1724679
	for <kvmarm@archiver.kernel.org>; Fri, 20 Dec 2019 07:10:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AD1724679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1F924A7FE;
	Fri, 20 Dec 2019 02:10:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ubZnaTFDLUlE; Fri, 20 Dec 2019 02:10:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E5E7C4A94D;
	Fri, 20 Dec 2019 02:10:47 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EBEB4A7FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 02:10:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TjdUsyemBx1C for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Dec 2019 02:10:45 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B209E4A597
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Dec 2019 02:10:45 -0500 (EST)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 2F8FC377EBD1CE8A33B3;
 Fri, 20 Dec 2019 15:10:39 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Dec 2019
 15:10:31 +0800
Subject: Re: [kvm-unit-tests PATCH 08/16] arm/arm64: ITS: Init the command
 queue
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-9-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <37c8b078-900b-a474-04a0-0273c3a32aed@huawei.com>
Date: Fri, 20 Dec 2019 15:10:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191216140235.10751-9-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com, thuth@redhat.com
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

Hi Eric,

On 2019/12/16 22:02, Eric Auger wrote:
> Allocate the command queue and initialize related registers:
> CBASER, CREADR, CWRITER.
> 
> The command queue is 64kB. This aims at not bothing with fullness.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>   lib/arm/asm/gic-v3-its.h |  7 +++++++
>   lib/arm/gic-v3-its.c     | 37 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 44 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> index 0d11aed..ed42707 100644
> --- a/lib/arm/asm/gic-v3-its.h
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -113,10 +113,17 @@ struct its_baser {
>   	int esz;
>   };
>   
> +struct its_cmd_block {
> +	u64     raw_cmd[4];
> +};
> +
>   struct its_data {
>   	void *base;
>   	struct its_typer typer;
>   	struct its_baser baser[GITS_BASER_NR_REGS];
> +	struct its_cmd_block *cmd_base;
> +	struct its_cmd_block *cmd_write;
> +	struct its_cmd_block *cmd_readr;

I think we can just get rid of the 'cmd_readr'. As GITS_CREADR is
generally manipulated by the ITS, and ...

>   };
>   
>   extern struct its_data its_data;
> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
> index 0b5a700..8b6a095 100644
> --- a/lib/arm/gic-v3-its.c
> +++ b/lib/arm/gic-v3-its.c
> @@ -188,3 +188,40 @@ void set_pending_table_bit(int rdist, int n, bool set)
>   		byte &= ~mask;
>   	*ptr = byte;
>   }
> +
> +/**
> + * init_cmd_queue: Allocate the command queue and initialize
> + * CBASER, CREADR, CWRITER
> + */
> +void init_cmd_queue(void);
> +void init_cmd_queue(void)
> +{
> +	unsigned long n = SZ_64K >> PAGE_SHIFT;
> +	unsigned long order = fls(n);
> +	u64 cbaser, tmp;
> +
> +	its_data.cmd_base = (void *)virt_to_phys(alloc_pages(order));
> +
> +	cbaser = ((u64)its_data.cmd_base	|
> +		 GITS_CBASER_WaWb               |
> +		 GITS_CBASER_InnerShareable     |
> +		 (SZ_64K / SZ_4K - 1) |
> +		 GITS_CBASER_VALID);
> +
> +	writeq(cbaser, its_data.base + GITS_CBASER);

..."(CREADR) is cleared to 0 when a value is written to GITS_CBASER."
-- from IHI0069E 9.19.3

> +	tmp = readq(its_data.base + GITS_CBASER);
> +
> +	if ((tmp ^ cbaser) & GITS_CBASER_SHAREABILITY_MASK) {
> +		if (!(tmp & GITS_CBASER_SHAREABILITY_MASK)) {
> +			cbaser &= ~(GITS_CBASER_SHAREABILITY_MASK |
> +				GITS_CBASER_CACHEABILITY_MASK);
> +			cbaser |= GITS_CBASER_nC;
> +			writeq(cbaser, its_data.base + GITS_CBASER);
> +		}
> +	}
> +
> +	its_data.cmd_write = its_data.cmd_base;
> +	its_data.cmd_readr = its_data.cmd_base;
> +	writeq(0, its_data.base + GITS_CWRITER);
> +	writeq(0, its_data.base + GITS_CREADR);

So this writeq() is also not needed.

Or I've just missed the point that this is done by intention to test
"whether the GITS_CREADR implemented by KVM is Write Ignored"?
If so, please ignore all of the comments above :)


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
