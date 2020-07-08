Return-Path: <SRS0=frvT=AT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01023C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jul 2020 22:03:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FCB120775
	for <kvmarm@archiver.kernel.org>; Wed,  8 Jul 2020 22:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zy98ets4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FCB120775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3FBB4B09C;
	Wed,  8 Jul 2020 18:03:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KQCv1l1Lad2o; Wed,  8 Jul 2020 18:03:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E97B54B188;
	Wed,  8 Jul 2020 18:03:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D70A54B103
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2020 18:03:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id biWaNyih6o+q for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Jul 2020 18:03:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CF23C4B09C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Jul 2020 18:03:05 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 65AF72078B;
 Wed,  8 Jul 2020 22:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594245784;
 bh=e728ffDVeqv3WeOeJ7GNFTrNtwbhwF2eVYgQ+USzSnI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Zy98ets4HLJmLAdBvOCQPsDA1OhRQuMl+JiDC0T5A7ygtUZwqdMy6GtRuZR4MLp6C
 mqbLq25w8Mv3FBLj/VfgSomNK58RRM2Nvp1b1jtKvaxFlg2wkxJ15Qorwma5G5vyjR
 eGOTyRSmV8d+RnZ5OF0bNApntkE1LM6iOmL6JXb0=
From: Will Deacon <will@kernel.org>
To: Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
Date: Wed,  8 Jul 2020 23:02:39 +0100
Message-Id: <159424054981.2034173.14116435447086960033.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708162546.26176-1-will@kernel.org>
References: <20200708162546.26176-1-will@kernel.org>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, stable@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>
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

On Wed, 8 Jul 2020 17:25:46 +0100, Will Deacon wrote:
> PAGE_HYP_DEVICE is intended to encode attribute bits for an EL2 stage-1
> pte mapping a device. Unfortunately, it includes PROT_DEVICE_nGnRE which
> encodes attributes for EL1 stage-1 mappings such as UXN and nG, which are
> RES0 for EL2, and DBM which is meaningless as TCR_EL2.HD is not set.
> 
> Fix the definition of PAGE_HYP_DEVICE so that it doesn't set RES0 bits
> at EL2.

Applied to arm64 (for-next/fixes), thanks!

[1/1] KVM: arm64: Fix definition of PAGE_HYP_DEVICE
      https://git.kernel.org/arm64/c/68cf617309b5

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
