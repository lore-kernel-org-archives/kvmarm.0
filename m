Return-Path: <SRS0=e8LN=FA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE211C64E7D
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 09:30:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 222BF21D93
	for <kvmarm@archiver.kernel.org>; Thu, 26 Nov 2020 09:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 222BF21D93
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EF844B42E;
	Thu, 26 Nov 2020 04:30:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bL90rsB0Waz3; Thu, 26 Nov 2020 04:30:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E92FC4C26A;
	Thu, 26 Nov 2020 04:30:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024B74C268
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 04:30:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rsexnSFujRSg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Nov 2020 04:30:47 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1A0884B704
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Nov 2020 04:30:47 -0500 (EST)
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ChXY95fs7z741P;
 Thu, 26 Nov 2020 17:30:21 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 26 Nov 2020 17:30:31 +0800
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To: Alexandru Elisei <alexandru.elisei@arm.com>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <drjones@redhat.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
Date: Thu, 26 Nov 2020 17:30:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-11-alexandru.elisei@arm.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com
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

On 2020/11/25 23:51, Alexandru Elisei wrote:
> The reason for the failure is that the test "dev2/eventid=20 now triggers
> an LPI" triggers 2 LPIs, not one. This behavior was present before this
> patch, but it was ignored because check_lpi_stats() wasn't looking at the
> acked array.
> 
> I'm not familiar with the ITS so I'm not sure if this is expected, if the
> test is incorrect or if there is something wrong with KVM emulation.

I think this is expected, or not.

Before INVALL, the LPI-8195 was already pending but disabled. On
receiving INVALL, VGIC will reload configuration for all LPIs targeting
collection-3 and deliver the now enabled LPI-8195. We'll therefore see
and handle it before sending the following INT (which will set the
LPI-8195 pending again).

> Did some more testing on an Ampere eMAG (fast out-of-order cores) using
> qemu and kvmtool and Linux v5.8, here's what I found:
> 
> - Using qemu and gic.flat built from*master*: error encountered 864 times
>    out of 1088 runs.
> - Using qemu: error encountered 852 times out of 1027 runs.
> - Using kvmtool: error encountered 8164 times out of 10602 runs.

If vcpu-3 hadn't seen and handled LPI-8195 as quickly as possible (e.g.,
vcpu-3 hadn't been scheduled), the following INT will set the already
pending LPI-8195 pending again and we'll receive it *once* on vcpu-3.
And we won't see the mentioned failure.

I think we can just drop the (meaningless and confusing?) INT.


Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
