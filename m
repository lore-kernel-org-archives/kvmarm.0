Return-Path: <SRS0=A5dY=CQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C34BC43461
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 16:06:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C61DD2145D
	for <kvmarm@archiver.kernel.org>; Mon,  7 Sep 2020 16:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Socdqn0E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C61DD2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FEE44B4C9;
	Mon,  7 Sep 2020 12:06:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E3I-twLHrsPv; Mon,  7 Sep 2020 12:05:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4463E4B42A;
	Mon,  7 Sep 2020 12:05:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B2E4B41D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 12:05:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a0jEW3i9pvSS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Sep 2020 12:05:57 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E6CE64B41C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Sep 2020 12:05:56 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E42802087D;
 Mon,  7 Sep 2020 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599494755;
 bh=QeHIkF/ix+36XFjoiPIijp204FQoC8LDlQRpbEiIysg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Socdqn0EXGvMtm8FRILCbjcfp7AsK5TCutrjKh1GILpklZ7512+lBf83RxCbPJ5vD
 K8gojHaAp54F2cRf2AYGcCnGy1PXXc36qTauT2r+yEPXfm/n2cvkwjmWDp4XBUvedq
 krEp9gJL+uWIzpUt6HDaFZg1vcbXeJOY4rMgHl4I=
From: Will Deacon <will@kernel.org>
To: maz@kernel.org, julien.thierry.kdev@gmail.com,
 linux-kernel@vger.kernel.org, Xiaoming Ni <nixiaoming@huawei.com>,
 mark.rutland@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64: fix some spelling mistakes in the comments by
 codespell
Date: Mon,  7 Sep 2020 17:05:35 +0100
Message-Id: <159948473119.582952.94642666556393887.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200828031822.35928-1-nixiaoming@huawei.com>
References: <20200828031822.35928-1-nixiaoming@huawei.com>
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, wangle6@huawei.com, kernel-team@android.com
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

On Fri, 28 Aug 2020 11:18:22 +0800, Xiaoming Ni wrote:
> 


Applied to arm64 (for-next/tpyos), thanks!

[1/1] arm64: fix some spelling mistakes in the comments by codespell
      https://git.kernel.org/arm64/c/ad14c19242b5

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
