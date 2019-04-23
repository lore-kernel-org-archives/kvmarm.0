Return-Path: <SRS0=x1Dw=SZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AD7C10F14
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 09:25:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DA396206A3
	for <kvmarm@archiver.kernel.org>; Tue, 23 Apr 2019 09:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA396206A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 298774A4C3;
	Tue, 23 Apr 2019 05:25:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nONvvfjtDf7f; Tue, 23 Apr 2019 05:25:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D59904A389;
	Tue, 23 Apr 2019 05:25:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 527954A389
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 05:25:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XwYcHe1CZH8I for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Apr 2019 05:25:05 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 568414A380
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Apr 2019 05:25:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E9CE374;
 Tue, 23 Apr 2019 02:25:04 -0700 (PDT)
Received: from [10.37.12.155] (unknown [10.37.12.155])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 47D883F557;
 Tue, 23 Apr 2019 02:25:03 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.0 29/98] KVM: arm/arm64: Enforce PTE mappings at
 stage2 when needed
To: sashal@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190422194205.10404-1-sashal@kernel.org>
 <20190422194205.10404-29-sashal@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <e166bc0d-5184-6dda-15ef-2f24d2e42203@arm.com>
Date: Tue, 23 Apr 2019 10:27:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20190422194205.10404-29-sashal@kernel.org>
Content-Language: en-US
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190423092726.VfZlOPNl2tLI_m5ccDhTix6PBu9VKnwic_SEqp6MMM4@z>

Hi Sasha,

On 04/22/2019 08:40 PM, Sasha Levin wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> [ Upstream commit a80868f398554842b14d07060012c06efb57c456 ]
> 
> commit 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
> made the checks to skip huge mappings, stricter. However it introduced
> a bug where we still use huge mappings, ignoring the flag to
> use PTE mappings, by not reseting the vma_pagesize to PAGE_SIZE.
> 
> Also, the checks do not cover the PUD huge pages, that was
> under review during the same period. This patch fixes both
> the issues.
> 
> Fixes : 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Zenghui Yu <yuzenghui@huawei.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>

Please be aware that we need a follow up fix for this patch to fix the
problem for THP backed memory.

http://lists.infradead.org/pipermail/linux-arm-kernel/2019-April/645324.html


It should appear upstream soon.


Cheers
Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
