Return-Path: <SRS0=6NFX=5P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603EDC43331
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 08:30:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB23E2073B
	for <kvmarm@archiver.kernel.org>; Mon, 30 Mar 2020 08:30:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB23E2073B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5971A4B0B3;
	Mon, 30 Mar 2020 04:30:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LLrEPGILtE3C; Mon, 30 Mar 2020 04:30:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ECB34B1CB;
	Mon, 30 Mar 2020 04:30:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 453504B0B3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 04:30:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c7r1IsGo6Blq for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Mar 2020 04:30:20 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B6D74A3A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Mar 2020 04:30:20 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 8FB628AC18DDC1F41535;
 Mon, 30 Mar 2020 16:30:12 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 30 Mar 2020
 16:30:09 +0800
Subject: Re: [kvm-unit-tests PATCH v7 06/13] arm/arm64: ITS: Introspection
 tests
To: Eric Auger <eric.auger@redhat.com>
References: <20200320092428.20880-1-eric.auger@redhat.com>
 <20200320092428.20880-7-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <947a79f5-1f79-532b-9ec7-6fd539ccd183@huawei.com>
Date: Mon, 30 Mar 2020 16:30:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200320092428.20880-7-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, thuth@redhat.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

On 2020/3/20 17:24, Eric Auger wrote:
> +static void its_cmd_queue_init(void)
> +{
> +	unsigned long order = get_order(SZ_64K >> PAGE_SHIFT);
> +	u64 cbaser;
> +
> +	its_data.cmd_base = (void *)virt_to_phys(alloc_pages(order));

Shouldn't the cmd_base (and the cmd_write) be set as a GVA?

Otherwise I think we will end-up with memory corruption when writing
the command queue.  But it seems that everything just works fine ...
So I'm really confused here :-/

> +
> +	cbaser = ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)	| GITS_CBASER_VALID);
> +
> +	writeq(cbaser, its_data.base + GITS_CBASER);
> +
> +	its_data.cmd_write = its_data.cmd_base;
> +	writeq(0, its_data.base + GITS_CWRITER);
> +}

Otherwise this looks good,
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
