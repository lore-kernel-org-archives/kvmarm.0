Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42795C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 11:39:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A03164FF2
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 11:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A03164FF2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C374B39A;
	Wed, 10 Mar 2021 06:39:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sFdE-gJFTQEI; Wed, 10 Mar 2021 06:39:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEF774B39F;
	Wed, 10 Mar 2021 06:39:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 050924B395
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 06:39:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rUCsq3gkVsTZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 06:39:27 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE2D44B366
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 06:39:26 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D73564FE5;
 Wed, 10 Mar 2021 11:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615376365;
 bh=aIsRlz8+KjMr611NkESIos4nUSuwP1XkbN6BEUu4+FI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HKpD+iC4jfRxdVMDbqZkqucj0bxrjDIFWVN85owR29Pt3ysbI1NUudEobXvDz7Exd
 slg48riqQXVtmI5EYhs6J5XkbCSZLzLVcZ+if+qGTw93plVMFpmm0xCh+GTSZ9wVsn
 cku85JAgoR+bPvCPCqb8eWlpnu3XFFuelvAFkXNswsGE3a3Pq0b41Ue2RJlTtRmDcq
 f+kE1cqSTsuAw9W5vUbwoaB+zfqR0m1Mru3GHTmk4pWTXwlkRyxRkCBXqwyjFrJEEp
 yyWeJ/3oX1ciIx9dAw8xzcCm7nRtzLOQAfxuKaFVGKbvepA9xeE7jgJNTaR12FBYyf
 7fGjsb1ussc3g==
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2] arm64/mm: Fix __enable_mmu() for new TGRAN range values
Date: Wed, 10 Mar 2021 11:39:16 +0000
Message-Id: <161537411789.1674334.2037758954337206352.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1615355590-21102-1-git-send-email-anshuman.khandual@arm.com>
References: <1615355590-21102-1-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Cc: linux-efi@vger.kernel.org, Will Deacon <will@kernel.org>,
 catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, 10 Mar 2021 11:23:10 +0530, Anshuman Khandual wrote:
> As per ARM ARM DDI 0487G.a, when FEAT_LPA2 is implemented, ID_AA64MMFR0_EL1
> might contain a range of values to describe supported translation granules
> (4K and 16K pages sizes in particular) instead of just enabled or disabled
> values. This changes __enable_mmu() function to handle complete acceptable
> range of values (depending on whether the field is signed or unsigned) now
> represented with ID_AA64MMFR0_TGRAN_SUPPORTED_[MIN..MAX] pair. While here,
> also fix similar situations in EFI stub and KVM as well.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64/mm: Fix __enable_mmu() for new TGRAN range values
      https://git.kernel.org/arm64/c/26f55386f964

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
