From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/1] KVM: ARM64: Fix the issues when guest PMCCFILTR
 is configured
Date: Thu, 17 Nov 2016 13:30:39 +0000
Message-ID: <20161117133039.GH22855@arm.com>
References: <1479316160-8567-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 422274022C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 08:30:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iHJLk0dMz8yz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 08:30:08 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05B72401E8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 08:30:07 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1479316160-8567-1-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 16, 2016 at 11:09:20AM -0600, Wei Huang wrote:
> KVM calls kvm_pmu_set_counter_event_type() when PMCCFILTR is configured.
> But this function can't deals with PMCCFILTR correctly because the evtCount
> bits of PMCCFILTR, which is reserved 0, conflits with the SW_INCR event
> type of other PMXEVTYPER<n> registers. To fix it, when eventsel == 0, this
> function shouldn't return immediately; instead it needs to check further
> if select_idx is ARMV8_PMU_CYCLE_IDX.
> 
> Another issue is that KVM shouldn't copy the eventsel bits of PMCCFILTER
> blindly to attr.config. Instead it ought to convert the request to the
> "cpu cycle" event type (i.e. 0x11).
> 
> To support this patch and to prevent duplicated definitions, a limited
> set of ARMv8 perf event types were relocated from perf_event.c to
> asm/perf_event.h.
> 
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  arch/arm64/include/asm/perf_event.h | 10 +++++++++-
>  arch/arm64/kernel/perf_event.c      | 10 +---------
>  virt/kvm/arm/pmu.c                  |  8 +++++---
>  3 files changed, 15 insertions(+), 13 deletions(-)

Acked-by: Will Deacon <will.deacon@arm.com>

I'm assuming this will go via kvm-arm.

Will
