Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89561C43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 13:42:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0735620DD4
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 13:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0735620DD4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=Huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 506884B3B6;
	Fri,  4 Sep 2020 09:42:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oUxhAAsuF-Ao; Fri,  4 Sep 2020 09:42:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 510D54B3D4;
	Fri,  4 Sep 2020 09:42:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E50DE4B3B6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 09:42:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B4u94YmjIZe7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 09:42:06 -0400 (EDT)
Received: from huawei.com (lhrrgout.huawei.com [185.176.76.210])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 18B004B3AD
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 09:42:06 -0400 (EDT)
Received: from lhreml710-chm.china.huawei.com (unknown [172.18.7.107])
 by Forcepoint Email with ESMTP id 59EFE247F430A0538772;
 Fri,  4 Sep 2020 14:42:04 +0100 (IST)
Received: from localhost (10.52.125.29) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 4 Sep 2020
 14:42:03 +0100
Date: Fri, 4 Sep 2020 14:40:29 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 02/23] irqchip/rvic: Add support for untrusted interrupt
 allocation
Message-ID: <20200904144029.000017ca@Huawei.com>
In-Reply-To: <20200903152610.1078827-3-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
 <20200903152610.1078827-3-maz@kernel.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
X-Originating-IP: [10.52.125.29]
X-ClientProxiedBy: lhreml743-chm.china.huawei.com (10.201.108.193) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Thu,  3 Sep 2020 16:25:49 +0100
Marc Zyngier <maz@kernel.org> wrote:

> Signed-off-by: Marc Zyngier <maz@kernel.org>
Hi Marc,

One trivial comment inline.

> ---
>  drivers/irqchip/irq-rvic.c | 47 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-rvic.c b/drivers/irqchip/irq-rvic.c
> index 6f37aa4318b6..2747a452202f 100644
> --- a/drivers/irqchip/irq-rvic.c
> +++ b/drivers/irqchip/irq-rvic.c
> @@ -37,6 +37,8 @@ static DEFINE_PER_CPU(unsigned long *, trusted_masked);
>  struct rvic_data {
>  	struct fwnode_handle	*fwnode;
>  	struct irq_domain	*domain;
> +	unsigned long 		*bitmap;
> +	struct mutex		lock;

Nitpick. Good to document the scope of that lock. It's obvious in this
patch but might not be 10 years down the line!

>  	unsigned int		nr_trusted;
>  	unsigned int		nr_untrusted;
>  };
...

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
