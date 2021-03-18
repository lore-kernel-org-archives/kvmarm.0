Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C68C433E6
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 15:18:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2539B64F30
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 15:18:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2539B64F30
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A57E54B751;
	Thu, 18 Mar 2021 11:17:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5mrkIBrBtHVc; Thu, 18 Mar 2021 11:17:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ADCE64B74B;
	Thu, 18 Mar 2021 11:17:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A04D4B74B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 11:17:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J7ylFMUei7SZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 11:17:55 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 275634B73C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 11:17:55 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDFC64E89;
 Thu, 18 Mar 2021 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1616080672;
 bh=suGCRxhv6rY50k2y5nlMkUlw6r3nWGbgq0qE+GJmeRE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=FUVkbJz0GEIzNDNRtUcfV6MT+VxkZZZL5MITruFHfZgwLkRRVLjLidVE0mcT4FZLC
 6Ib8+HCJECZUPz8u0JraAqPQdT6BSE8xttkAYbcpleDwv8/aOtmzBOApGKxy8cgwU+
 Ej9oC4qhEQGc4ZkhuUIr8DTcggny5H/WRkdR2S2p9njYUImrFLtnji6XeBZ6o+Poqq
 c1Ev3yP5PlC+nXyk8mhj4W7iNQuY27sBPJ25m6zcZGXSPPpEbjSdwUmtsSmDQGm91X
 I+y5+fKVJyHCnd8U87iztbpYEnBXBHFv2LCoLW7d0orBeLWRRMYDghRnIWdFTncr9X
 xbpVlfwyn5pTA==
Date: Thu, 18 Mar 2021 15:17:46 +0000
From: Will Deacon <will@kernel.org>
To: Andrew Scull <ascull@google.com>
Subject: Re: [PATCH v3 1/5] bug: Remove redundant condition check in report_bug
Message-ID: <20210318151746.GA7531@willie-the-truck>
References: <20210318143311.839894-1-ascull@google.com>
 <20210318143311.839894-2-ascull@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210318143311.839894-2-ascull@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Peter Zijlstra <peterz@infradead.org>, catalin.marinas@arm.com,
 "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>, maz@kernel.org,
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

Hi Andrew,

Thanks for the patch.

On Thu, Mar 18, 2021 at 02:33:07PM +0000, Andrew Scull wrote:
> report_bug() will return early if it cannot find a bug corresponding to
> the provided address. The subsequent test for the bug will always be
> true so remove it.
> 
> Fixes: 1b4cfe3c0a30d ("lib/bug.c: exclude non-BUG/WARN exceptions from report_bug()")

This is purely cosmetic, so I'm not sure this warrants a fixes tag (i.e. I
wouldn't expect this change to be backported).

> Signed-off-by: Andrew Scull <ascull@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  lib/bug.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)

But the change looks good:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
