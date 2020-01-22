Return-Path: <SRS0=OV02=3L=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC3CC2D0CE
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 02:59:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 11FDD2087E
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jan 2020 02:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11FDD2087E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DA334A541;
	Tue, 21 Jan 2020 21:59:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OmDwCfNiKEBZ; Tue, 21 Jan 2020 21:59:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7342F4A968;
	Tue, 21 Jan 2020 21:59:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E1B44A957
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 21:59:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i3NUM3nwUhiT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 21:59:34 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D1324A541
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 21:59:34 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id ADF7244081C22D3B539C;
 Wed, 22 Jan 2020 10:59:30 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 22 Jan 2020
 10:59:21 +0800
Subject: Re: [PATCH v3 05/32] irqchip/gic-v4.1: VPE table (aka
 GICR_VPROPBASER) allocation
To: Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
References: <20191224111055.11836-1-maz@kernel.org>
 <20191224111055.11836-6-maz@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1c278098-f365-2b50-ce60-b27faeef2e48@huawei.com>
Date: Wed, 22 Jan 2020 10:59:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191224111055.11836-6-maz@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>
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

On 2019/12/24 19:10, Marc Zyngier wrote:

> @@ -4147,6 +4453,8 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>   	bool has_v4 = false;
>   	int err;
>   
> +	gic_rdists = rdists;
> +
>   	its_parent = parent_domain;
>   	of_node = to_of_node(handle);
>   	if (of_node)
> @@ -4159,8 +4467,6 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
>   		return -ENXIO;
>   	}
>   
> -	gic_rdists = rdists;
> -
>   	err = allocate_lpi_tables();
>   	if (err)
>   		return err;

And shouldn't this be part of patch#2?  (As the new ITS_MAX_VPEID_BITS
would use gic_rdists in the allocation of ITS vPE table.)

But I haven't tested the first two patches separately, I guess it may
crash my box ;-)


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
