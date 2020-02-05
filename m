Return-Path: <SRS0=/ADY=3Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78176C35254
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 12:46:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EF0BF2082E
	for <kvmarm@archiver.kernel.org>; Wed,  5 Feb 2020 12:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMo0yvYV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF0BF2082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9964C4A7E4;
	Wed,  5 Feb 2020 07:46:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q9wG7BLiBLzb; Wed,  5 Feb 2020 07:46:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 266114A4E5;
	Wed,  5 Feb 2020 07:46:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD34B4A4E5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 07:46:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GDVB0Q9mFNvE for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Feb 2020 07:46:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3F9B4A49F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Feb 2020 07:46:38 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9E6FC20702;
 Wed,  5 Feb 2020 12:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1580906797;
 bh=GfGSMXXeXChdHY2rFyfqEnWPYUrl7k3y4PXuksqSPxo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=MMo0yvYVxHW6Ixw5DBnn9oa1n/Z6efinNp30im/8hwmaiqSxnnz2ll2SgDS2KifNh
 SpqDffeu0rM2ygdSsyGGqC/wnOcfv28oW/XLzPxC4VpH+UnWWAfRJhWzOcVRkKJezh
 KQDjqqsYfIdPBc+UZa49K//qIZGwFqxl+vBcqCqc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1izK4h-00388J-VA; Wed, 05 Feb 2020 12:46:36 +0000
MIME-Version: 1.0
Date: Wed, 05 Feb 2020 12:46:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/5] irqchip/gic-v4.1: Cleanup and fixes for GICv4.1
In-Reply-To: <20200204090940.1225-1-yuzenghui@huawei.com>
References: <20200204090940.1225-1-yuzenghui@huawei.com>
Message-ID: <004ca9ea2d525d5b1bcf1d78f10c61ba@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 tglx@linutronix.de, jason@lakedaemon.net, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: jason@lakedaemon.net, linux-kernel@vger.kernel.org, tglx@linutronix.de,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Zenghui,

On 2020-02-04 09:09, Zenghui Yu wrote:
> Hi,
> 
> This series contains some cleanups, VPROPBASER field programming fix
> and level2 vPE table allocation enhancement, collected while looking
> through the GICv4.1 driver one more time.
> 
> Hope they will help, thanks!
> 
> Zenghui Yu (5):
>   irqchip/gic-v4.1: Fix programming of GICR_VPROPBASER_4_1_SIZE
>   irqchip/gic-v4.1: Set vpe_l1_base for all redistributors
>   irqchip/gic-v4.1: Ensure L2 vPE table is allocated at RD level
>   irqchip/gic-v4.1: Drop 'tmp' in inherit_vpe_l1_table_from_rd()
>   irqchip/gic-v3-its: Remove superfluous WARN_ON
> 
>  drivers/irqchip/irq-gic-v3-its.c   | 80 +++++++++++++++++++++++++++---
>  include/linux/irqchip/arm-gic-v3.h |  2 +-
>  2 files changed, 75 insertions(+), 7 deletions(-)

Thanks a lot for this, much appreciated, I'm quite happy with the 
overall
state of the series. If you can just address the couple of nits I have 
on
patch #3, I'll then queue the series and send off to Thomas together 
with
the rest of the queued fixes.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
