Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F8CC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 17:33:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3420464F90
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 17:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3420464F90
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B03274B62D;
	Thu, 11 Mar 2021 12:33:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id idnLnVpyRIyX; Thu, 11 Mar 2021 12:33:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B95864B5A5;
	Thu, 11 Mar 2021 12:33:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 19C474B347
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 12:33:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hk-xlPGRN9SL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 12:33:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F7604B2EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 12:33:48 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA49D64F3B;
 Thu, 11 Mar 2021 17:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615484026;
 bh=o1Y/vDKuu7aZiyDLEgSjzY1Vv/0l7khcTBK8HwjsoGQ=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=StXTdMIYRq9vcgvR/dNjfS56cBddLlVJKJKQCvqtMCFBUNOmXutiPeoJ11Xx+VuFf
 /+KHCvw2+OwLpL5UG3eIpA7QD+TTLKRBf0ZNuXB0dXulvFP4o8j0qXCShLJTTRziEJ
 Jz93U5S57TqEzZGJGMG3o+bJfkctMgi7nsgqDrS6tbFL2JVzI0kj4XQPNvj03uWuX8
 aQe+reCBQMj3x6wujDSOp9VOMDgySuxMMasbiUj2/yB8tsH1wzLGSBQSdbFO4ZR+Nl
 oLgn3H/8voL9Qn7/3w3ZDyYgX4JmD3GrntZ7HSnGS021nluLybNz8+xGkf6pjORDrJ
 FuNIT9hRcqnyA==
Date: Thu, 11 Mar 2021 17:33:38 +0000
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v4 27/34] KVM: arm64: Always zero invalid PTEs
Message-ID: <20210311173338.GB31378@willie-the-truck>
References: <20210310175751.3320106-1-qperret@google.com>
 <20210310175751.3320106-28-qperret@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310175751.3320106-28-qperret@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: android-kvm@google.com, catalin.marinas@arm.com, mate.toth-pal@arm.com,
 seanjc@google.com, tabba@google.com, linux-kernel@vger.kernel.org,
 robh+dt@kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Mar 10, 2021 at 05:57:44PM +0000, Quentin Perret wrote:
> kvm_set_invalid_pte() currently only clears bit 0 from a PTE because
> stage2_map_walk_table_post() needs to be able to follow the anchor. In
> preparation for re-using bits 63-02 from invalid PTEs, make sure to zero

Why do you exclude bit 1 from this range?

> it entirely by ensuring to cache the anchor's child upfront.
> 
> Suggested-by: Will Deacon <will@kernel.org>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)

For the patch:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
