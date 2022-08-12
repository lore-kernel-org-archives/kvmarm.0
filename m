Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B751DC25B0F
	for <kvmarm@archiver.kernel.org>; Fri, 12 Aug 2022 06:33:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 101DB4F388;
	Fri, 12 Aug 2022 02:33:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LIApfcNXQ2jT; Fri, 12 Aug 2022 02:33:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA6AF4F381;
	Fri, 12 Aug 2022 02:33:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE8EA4F37F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 02:33:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xkSn9KqDNb8u for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Aug 2022 02:33:10 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 692104F37C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Aug 2022 02:33:10 -0400 (EDT)
Date: Fri, 12 Aug 2022 08:33:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660285989;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=e/R2RtYnD6Q7wcxCvEyj8OZOZ463/n6rqqGVTkkChbE=;
 b=nJ5HsilxsH9h4LyeN5wt8CBqCUvIYxKYJWClgIQhvd3847Sl1HbQhj/FWMUUGzCPsUbb6a
 UJFjToso2iSl1XCSXyZyaW9LRy81BVLs8BW3GoViyvZ3cwR3e6URtZNhaK0+1gufIRRcjg
 QK59h302zcQ751xgsXc+7ZkFpB1eF4I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH v4 0/4] arm: pmu: Fixes for bare metal
Message-ID: <20220812063300.ygeyivgzzkyzg3uo@kamzik>
References: <20220811185210.234711-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Thu, Aug 11, 2022 at 11:52:06AM -0700, Ricardo Koller wrote:
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
> https://lore.kernel.org/kvmarm/YvPsBKGbHHQP+0oS@google.com/T/#mb077998e2eb9fb3e15930b3412fd7ba2fb4103ca
> - add pmu_reset() for 32-bit arm [Andrew]
> - collect r-b from Alexandru

You forgot to pick up Oliver's r-b's and his Link suggestion. I can do
that again, though.

Thanks,
drew
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
