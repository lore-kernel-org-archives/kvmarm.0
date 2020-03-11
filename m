Return-Path: <SRS0=5IFU=44=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15517C10F27
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 08:37:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94C4020637
	for <kvmarm@archiver.kernel.org>; Wed, 11 Mar 2020 08:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94C4020637
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D39D54A524;
	Wed, 11 Mar 2020 04:37:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GSk9pdZC7tVB; Wed, 11 Mar 2020 04:37:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E48704A4E1;
	Wed, 11 Mar 2020 04:37:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABDA04A483
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 04:37:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 36GKprepQobb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Mar 2020 04:37:43 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EEDBB4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Mar 2020 04:37:42 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 439021D9CE9A4ADD8EEC;
 Wed, 11 Mar 2020 16:37:36 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Mar 2020
 16:37:26 +0800
Subject: Re: [kvm-unit-tests PATCH v5 06/13] arm/arm64: ITS: Introspection
 tests
To: Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
 <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-7-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <83ffda30-e0dc-7fbf-1775-bc45a308acb4@huawei.com>
Date: Wed, 11 Mar 2020 16:37:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200310145410.26308-7-eric.auger@redhat.com>
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

On 2020/3/10 22:54, Eric Auger wrote:
> +#define GITS_TYPER_PLPIS                BIT(0)
> +#define GITS_TYPER_VLPIS		BIT(1)
> +#define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
> +#define GITS_TYPER_IDBITS		GENMASK_ULL(8, 12)

Note that this should be GENMASK_ULL(12, 8).

> +#define GITS_TYPER_IDBITS_SHIFT         8
> +#define GITS_TYPER_DEVBITS		GENMASK_ULL(13, 17)

(17, 13)

> +#define GITS_TYPER_DEVBITS_SHIFT        13
> +#define GITS_TYPER_PTA                  BIT(19)
> +#define GITS_TYPER_CIDBITS		GENMASK_ULL(32, 35)

(35, 32)

> +#define GITS_TYPER_CIDBITS_SHIFT	32
> +#define GITS_TYPER_CIL			BIT(36)

And please use tab for all of them.


Thanks,
Zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
