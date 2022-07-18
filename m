Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D65C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 16:41:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE6A4D78C;
	Mon, 18 Jul 2022 12:41:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O94K4CVoKHOg; Mon, 18 Jul 2022 12:41:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1CB94D780;
	Mon, 18 Jul 2022 12:41:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7DAD4D772
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:41:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZozzEISz9hoc for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 12:41:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B68524D6A5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 12:41:42 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB9971042;
 Mon, 18 Jul 2022 09:41:42 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3F443F73D;
 Mon, 18 Jul 2022 09:41:40 -0700 (PDT)
Date: Mon, 18 Jul 2022 17:42:08 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [kvm-unit-tests PATCH 0/3] arm: pmu: Fixes for bare metal
Message-ID: <YtWNYGuP/Nu1HwDU@monolith.localdoman>
References: <20220718154910.3923412-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 andrew.jones@linux.dev, kvmarm@lists.cs.columbia.edu
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

Hi,

I believe you're missing the updated email for the arm maintainer. Added it.

Thanks,
Alex

On Mon, Jul 18, 2022 at 08:49:07AM -0700, Ricardo Koller wrote:
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
> I believe the third fix also requires a KVM change, but would like to
> double check with others first.  The only reference I could find in the
> ARM ARM is the AArch64.IncrementEventCounter() pseudocode (DDI 0487H.a,
> J1.1.1 "aarch64/debug") that unconditionally sets the PMOVS bit on
> overflow.
> 
> Ricardo Koller (3):
>   arm: pmu: Add missing isb()'s after sys register writing
>   arm: pmu: Reset the pmu registers before starting some tests
>   arm: pmu: Remove checks for !overflow in chained counters tests
> 
>  arm/pmu.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> -- 
> 2.37.0.170.g444d1eabd0-goog
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
