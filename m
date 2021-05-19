Return-Path: <SRS0=M1+/=KO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C5CC433B4
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 17:32:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 535B061355
	for <kvmarm@archiver.kernel.org>; Wed, 19 May 2021 17:32:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 535B061355
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D487E4B4C3;
	Wed, 19 May 2021 13:32:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2JCaQlbA9cwy; Wed, 19 May 2021 13:32:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E3B4B869;
	Wed, 19 May 2021 13:32:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9CC34B860
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 13:32:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ejxSmTla4xnE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 May 2021 13:32:34 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A35954B4C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 13:32:34 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6564611BF;
 Wed, 19 May 2021 17:32:30 +0000 (UTC)
Date: Wed, 19 May 2021 18:32:28 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v12 1/8] arm64: mte: Handle race when synchronising tags
Message-ID: <20210519173228.GC21619@arm.com>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-2-steven.price@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210517123239.8025-2-steven.price@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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

On Mon, May 17, 2021 at 01:32:32PM +0100, Steven Price wrote:
> mte_sync_tags() used test_and_set_bit() to set the PG_mte_tagged flag
> before restoring/zeroing the MTE tags. However if another thread were to
> race and attempt to sync the tags on the same page before the first
> thread had completed restoring/zeroing then it would see the flag is
> already set and continue without waiting. This would potentially expose
> the previous contents of the tags to user space, and cause any updates
> that user space makes before the restoring/zeroing has completed to
> potentially be lost.
> 
> Since this code is run from atomic contexts we can't just lock the page
> during the process. Instead implement a new (global) spinlock to protect
> the mte_sync_page_tags() function.
> 
> Fixes: 34bfeea4a9e9 ("arm64: mte: Clear the tags when a page is mapped in user-space with PROT_MTE")
> Signed-off-by: Steven Price <steven.price@arm.com>

Other than the missing spinlock initialisation, the patch looks fine to
me.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

(though I'll probably queue it as a fix, waiting a couple of days for
comments)

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
