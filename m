Return-Path: <SRS0=W6Rg=6S=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438BAC3A5A9
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 15:33:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C14F4206D7
	for <kvmarm@archiver.kernel.org>; Mon,  4 May 2020 15:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6MlwFan"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C14F4206D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 657B64B3FE;
	Mon,  4 May 2020 11:33:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 84RmyMV-+hpn; Mon,  4 May 2020 11:33:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE764B3B3;
	Mon,  4 May 2020 11:33:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35DC74B3B2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 11:33:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FwLoeSRqY1JY for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 May 2020 11:33:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1200D4B3AF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 May 2020 11:33:49 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id BCF06206B9;
 Mon,  4 May 2020 15:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1588606428;
 bh=1skABZsLUeXIOnu1TfJo0+k1rN+sSrAwTKB/o8pjzhk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=C6MlwFanHBj+ZBgvj1AxoagEd62AmjVySC4zrliTFT5nloKLbHVgeOhdfdP70dtV5
 FTFF2Lr4L/ihMTEu6uap5HD24dSFqYQxVzU1/+FHZv/pkD1vym+ZPChQN3p879webH
 Wm10+fqLXUP3Rmlwcs5zE9RbdVlbNC9EGYeregQI=
From: Will Deacon <will@kernel.org>
To: Andrew Scull <ascull@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v3] arm64: Unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
Date: Mon,  4 May 2020 16:33:34 +0100
Message-Id: <158860474729.32373.13097677494498104727.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504094858.108917-1-ascull@google.com>
References: <20200504094858.108917-1-ascull@google.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, Steven Price <steven.price@arm.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
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

On Mon, 4 May 2020 10:48:58 +0100, Andrew Scull wrote:
> Errata 1165522, 1319367 and 1530923 each allow TLB entries to be
> allocated as a result of a speculative AT instruction. In order to
> avoid mandating VHE on certain affected CPUs, apply the workaround to
> both the nVHE and the VHE case for all affected CPUs.

Applied to arm64 (for-next/kvm/errata), thanks!

[1/1] arm64: Unify WORKAROUND_SPECULATIVE_AT_{NVHE,VHE}
      https://git.kernel.org/arm64/c/02ab1f5018c3

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
