Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D88AC00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 17:34:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D53894DA13;
	Wed, 10 Aug 2022 13:34:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uVqOzk75yGBL; Wed, 10 Aug 2022 13:34:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5D34DA07;
	Wed, 10 Aug 2022 13:34:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08F4D4DA07
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 13:34:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ibjD11QA281O for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 13:34:04 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B27B04D9FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 13:34:04 -0400 (EDT)
Date: Wed, 10 Aug 2022 12:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660152843;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=EIsXvKSqgfKF5lprwB47UCU5MtfY2ezmKVd9Db/rJWQ=;
 b=opu2mvci43APyNG3UpMrdiqYtHV720jCH0FALFn9J5Op+aPnItMayJsJcV0Rbb7Yl/FPYQ
 tmJQdDvjRflJ5Ys73dxny6ESWoCLyxmM1LYoepRVsKYbBkmcCzry/7FVo0dZaZkUj0mOKN
 5nXRdkoRdWazMPBy6hBm5NZUZbTicOQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: pmu: Fixes for bare metal
Message-ID: <YvPsBKGbHHQP+0oS@google.com>
References: <20220805004139.990531-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220805004139.990531-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, maz@kernel.org, andrew.jones@linux.dev,
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

On Thu, Aug 04, 2022 at 05:41:36PM -0700, Ricardo Koller wrote:
> There are some tests that fail when running on bare metal (including a
> passthrough prototype).  There are three issues with the tests.  The
> first one is that there are some missing isb()'s between enabling event
> counting and the actual counting. This wasn't an issue on KVM as
> trapping on registers served as context synchronization events. The
> second issue is that some tests assume that registers reset to 0.  And
> finally, the third issue is that overflowing the low counter of a
> chained event sets the overflow flag in PMVOS and some tests fail by
> checking for it not being set.
> 
> Addressed all comments from the previous version:
> https://lore.kernel.org/kvmarm/20220803182328.2438598-1-ricarkol@google.com/T/#t
> - adding missing isb() and fixed the commit message (Alexandru).
> - fixed wording of a report() check (Andrew).
> 
> Thanks!
> Ricardo
> 
> Ricardo Koller (3):
>   arm: pmu: Add missing isb()'s after sys register writing
>   arm: pmu: Reset the pmu registers before starting some tests
>   arm: pmu: Check for overflow in the low counter in chained counters
>     tests

For the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
