Return-Path: <SRS0=zWKl=TC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDF4C43219
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 12:56:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AC7C2085A
	for <kvmarm@archiver.kernel.org>; Thu,  2 May 2019 12:56:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1CNu64D"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AC7C2085A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A57204A4F3;
	Thu,  2 May 2019 08:56:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MWI2SEqFUqDr; Thu,  2 May 2019 08:56:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 190CA4A4F7;
	Thu,  2 May 2019 08:56:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41FA54A4F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 08:56:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CZg8E+ubCG0L for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 May 2019 08:56:50 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D271B4A4AD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 May 2019 08:56:50 -0400 (EDT)
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 39FB420449;
 Thu,  2 May 2019 12:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1556801809;
 bh=yj300TW+fJqT6K6BSGF2jtEG/Xt4a4FDcEA/4LmZcjs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=N1CNu64DdNDI6n6Pd4zvz/PjlpDiFGriUxmGgT0/aEEIlVYPNO5MpTGqG7iTelmKQ
 JozEqiBnuNmR0hNLn0yOAQTnPD5zKtk6yBqYPUuJl8FJoyUq8mFmzKss3kpaJ/vgJM
 2NV/TrbxUU0gmrBBPMtprJNCOepEvFx6dTFGe1Ek=
Date: Thu, 2 May 2019 08:50:01 -0400
From: Sasha Levin <sashal@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH AUTOSEL 5.0 29/98] KVM: arm/arm64: Enforce PTE mappings
 at stage2 when needed
Message-ID: <20190502125001.GB11584@sasha-vm>
References: <20190422194205.10404-1-sashal@kernel.org>
 <20190422194205.10404-29-sashal@kernel.org>
 <e166bc0d-5184-6dda-15ef-2f24d2e42203@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e166bc0d-5184-6dda-15ef-2f24d2e42203@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: marc.zyngier@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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
Message-ID: <20190502125001.e-6UAE1Ux2Fyz4p4zT0cc-nNVdR7NIzeHFo-ZndHI4o@z>

On Tue, Apr 23, 2019 at 10:27:26AM +0100, Suzuki K Poulose wrote:
>Hi Sasha,
>
>On 04/22/2019 08:40 PM, Sasha Levin wrote:
>>From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>>[ Upstream commit a80868f398554842b14d07060012c06efb57c456 ]
>>
>>commit 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
>>made the checks to skip huge mappings, stricter. However it introduced
>>a bug where we still use huge mappings, ignoring the flag to
>>use PTE mappings, by not reseting the vma_pagesize to PAGE_SIZE.
>>
>>Also, the checks do not cover the PUD huge pages, that was
>>under review during the same period. This patch fixes both
>>the issues.
>>
>>Fixes : 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
>>Reported-by: Zenghui Yu <yuzenghui@huawei.com>
>>Cc: Zenghui Yu <yuzenghui@huawei.com>
>>Cc: Christoffer Dall <christoffer.dall@arm.com>
>>Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
>
>Please be aware that we need a follow up fix for this patch to fix the
>problem for THP backed memory.
>
>http://lists.infradead.org/pipermail/linux-arm-kernel/2019-April/645324.html
>
>
>It should appear upstream soon.

Since it's not upstream yet, I'll drop this patch for now and queue it
for a later release.

--
Thanks,
Sasha
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
