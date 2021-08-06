Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD0AC4338F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:34:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA7596108D
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 11:34:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AA7596108D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A8FD49FE6;
	Fri,  6 Aug 2021 07:34:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hxutCpkwx94F; Fri,  6 Aug 2021 07:34:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 296124B092;
	Fri,  6 Aug 2021 07:34:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43FC54B092
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:34:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eNfMAO17tm7v for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 07:34:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C84B49FE6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 07:34:21 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D2E60FE7;
 Fri,  6 Aug 2021 11:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628249660;
 bh=1+KiZplv3MguZUZepGmue5Z/n03MIoOuRn2s0KMeuIo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=eWHjhLQAAnrtFOQ2us3+TgZtQZtaAToDcCSN6k7dni+sBjzSJAmDcimFdlF2rGmcs
 8lCvShrSLS1Xa/Y0k+hkekDfsKbYrwA7loz5OK5TnyPicR6Zfu7WdxsIZt6XvJ/ECc
 Y9cewdnJdpyNNqvbgC84DMw4nkI4m8hSRPZtTpfasKx/sHG9b7Y1yrEIZYllVWz+Aq
 M48x7rxWhWHtyAfcmgpI5pIFETl4PPVRkK7goaGtppvUEl4I23yIGFbl73WCM8G8QQ
 nALdSk0XhrTHRL8oGQC3Pxn+h3D9G+TzmkaMI/eifnwtUiwktT8KK7rqc1mUb45/0B
 IOmEtsiaD3z0Q==
Date: Fri, 6 Aug 2021 12:34:14 +0100
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: restricted dma: Don't fail device probe on rmem init
 failure
Message-ID: <20210806113414.GA2531@willie-the-truck>
References: <20210806113109.2475-1-will@kernel.org>
 <20210806113109.2475-3-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210806113109.2475-3-will@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: linux-arch@vger.kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Robin Murphy <robin.murphy@arm.com>,
 Christoph Hellwig <hch@lst.de>, Rob Herring <robh+dt@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Claire Chang <tientzu@chromium.org>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Jade Alglave <jade.alglave@arm.com>
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

On Fri, Aug 06, 2021 at 12:31:05PM +0100, Will Deacon wrote:
> If CONFIG_DMA_RESTRICTED_POOL=n then probing a device with a reference
> to a "restricted-dma-pool" will fail with a reasonably cryptic error:
> 
>   | pci-host-generic: probe of 10000.pci failed with error -22
> 
> Print a more helpful message in this case and try to continue probing
> the device as we do if the kernel doesn't have the restricted DMA patches
> applied or either CONFIG_OF_ADDRESS or CONFIG_HAS_DMA =n.
> 
> Cc: Claire Chang <tientzu@chromium.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  drivers/of/address.c    | 8 ++++----
>  drivers/of/device.c     | 2 +-
>  drivers/of/of_private.h | 8 +++-----
>  3 files changed, 8 insertions(+), 10 deletions(-)

Sorry, didn't mean to send this patch a second time, it was still kicking
around in my tree from yesterday and I accidentally picked it up when
sending my TLBI series.

Please ignore.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
