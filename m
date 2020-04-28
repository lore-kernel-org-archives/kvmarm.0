Return-Path: <SRS0=hKGY=6M=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BFAC83001
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 14:50:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F907206C0
	for <kvmarm@archiver.kernel.org>; Tue, 28 Apr 2020 14:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uB8e0UjJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F907206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 692A64B117;
	Tue, 28 Apr 2020 10:50:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uPdAmUX5wSsD; Tue, 28 Apr 2020 10:50:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 167A64B2BB;
	Tue, 28 Apr 2020 10:50:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D8104B1C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 10:50:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TyUxfmIVJgpY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2020 10:50:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 66B694B117
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2020 10:50:04 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0A4902070B;
 Tue, 28 Apr 2020 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588085403;
 bh=wLkMog+C31R9s35T9i+aq0ijLlgLzB9NiqhRDEWFHMQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=uB8e0UjJMU74eFifX38zXKgiEWe5bPcwPZo6dQ4B8kxElcPzsVdGWiWxaUJXmWQht
 HMqWj7ty10mNGN1QhEW6R0qQw3+wJ/YhtTkQXXiSAgij77C1YfHWYuwNI86nwJwmmW
 AI7IT2t8GdCO5wjcb3fuXrLuo20ZTElweDMz59l4=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Drop PTE_S2_MEMATTR_MASK
Date: Tue, 28 Apr 2020 15:49:41 +0100
Message-Id: <158808189342.219357.12380979087402977148.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415105746.314-1-yuzenghui@huawei.com>
References: <20200415105746.314-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, Will Deacon <will@kernel.org>, maz@kernel.org
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

On Wed, 15 Apr 2020 18:57:46 +0800, Zenghui Yu wrote:
> The only user of PTE_S2_MEMATTR_MASK macro had been removed since
> commit a501e32430d4 ("arm64: Clean up the default pgprot setting").
> It has been about six years and no one has used it again.
> 
> Let's drop it.

Applied to arm64 (for-next/misc), thanks!

[1/1] KVM: arm64: Drop PTE_S2_MEMATTR_MASK
      https://git.kernel.org/arm64/c/f4be140fa33f

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
