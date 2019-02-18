From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 0/5] KVM: arm/arm64: add support for chained counters
Date: Mon, 18 Feb 2019 08:52:17 +0000
Message-ID: <20190218085217.4c4ff56f@why.wild-wind.fr.eu.org>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6362E4A321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 03:52:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kUVXVYrrIQi9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 03:52:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC4540493
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 03:52:23 -0500 (EST)
In-Reply-To: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, 4 Feb 2019 16:53:33 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

> ARMv8 provides support for chained PMU counters, where an event type
> of 0x001E is set for odd-numbered counters, the event counter will
> increment by one for each overflow of the preceding even-numbered
> counter. Let's emulate this in KVM by creating a 64 bit perf counter
> when a user chains two emulated counters together.
> 
> Testing has been performed by hard-coding hwc->sample_period in
> __hw_perf_event_init (arm_pmu.c) to a small value, this results in
> regular overflows (for non sampling events). The following command
> was then used to measure chained and non-chained instruction cycles:
> 
> perf stat -e armv8_pmuv3/long=1,inst_retired/u \
>           -e armv8_pmuv3/long=0,inst_retired/u dd if=/dev/zero bs=1M \
> 	  count=10 | gzip > /dev/null
> 
> The reported values were identical (and for non-chained was in the
> same ballpark when running on a kernel without this patchset). Debug
> was added to verify that the guest received overflow interrupts for
> the chain counter.

Hi Andrew,

We're getting quite close to the merge window, and I need to wrap up the
pull request pretty soon. If you want this to make it into 5.1, you'll
have to respin it pretty quickly (right now, basically...), addressing
the comments Suzuki and Julien raised.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
