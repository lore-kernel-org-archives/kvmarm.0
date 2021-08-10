Return-Path: <SRS0=u6p1=NB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3A4C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 13:20:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B6366101E
	for <kvmarm@archiver.kernel.org>; Tue, 10 Aug 2021 13:20:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6B6366101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07EE64A3A3;
	Tue, 10 Aug 2021 09:20:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aBG3IhVT+ylP; Tue, 10 Aug 2021 09:20:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 923064A3A5;
	Tue, 10 Aug 2021 09:20:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56DC64A19F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 09:20:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y55PYnHvaXY8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Aug 2021 09:20:23 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDBAE4056A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Aug 2021 09:20:23 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE91E60F38;
 Tue, 10 Aug 2021 13:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628601622;
 bh=i8aV5+sUyxbK8b8J3GdV5Q1yGwzOp1R2o33rDjK+wH4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=dqSO0i7ySLnw7yIc8Eok1mNOrrXvrLrw/T559Lgl4LtbGnapFY3pDfSn3sWrxWoc0
 MFs6WyE3ASeGm7FdHxYFUdsaF6wxBgNMNNTs3cwI09DeRnPD70u5I13jEKoTyrRrKw
 2tOZbqULGJeDQua64XNnYlfSdBdaCY3q9QctVcWC+Sn/pYyAnE6HlP6/66L5H7D1GP
 Oop4mI7/SHPceddDvkb5f4tgb1O83AZ/z5EZvJYbkreZJHcsBBERTgwUEdLDK/tL22
 n/xzkteQewS12TQIff0Lqb7ypLAhv0RqAS1bZap3SR/LeKQP9aT8FOHFhYmo/ROfXl
 nRwvjdhREOenw==
Date: Tue, 10 Aug 2021 14:20:15 +0100
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Drop direct PAGE_[SHIFT|SIZE] usage as
 page size
Message-ID: <20210810132015.GA2946@willie-the-truck>
References: <1628578961-29097-1-git-send-email-anshuman.khandual@arm.com>
 <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1628578961-29097-2-git-send-email-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Tue, Aug 10, 2021 at 12:32:37PM +0530, Anshuman Khandual wrote:
> All instances here could just directly test against CONFIG_ARM64_XXK_PAGES
> instead of evaluating via PAGE_SHIFT or PAGE_SIZE. With this change, there
> will be no such usage left.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: James Morse <james.morse@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 6 +++---
>  arch/arm64/mm/mmu.c          | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)

Why is this better?

WIll
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
