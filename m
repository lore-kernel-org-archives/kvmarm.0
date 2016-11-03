From: cov@codeaurora.org
Subject: Re: [PATCH 1/1] KVM: ARM64: Fix the issues when PMCCFILTR is
 configured
Date: Wed, 02 Nov 2016 22:11:16 -0600
Message-ID: <db2cdc7caf7dc40b0895e1b6f91c7758@codeaurora.org>
References: <1478120132-9928-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D70104027C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2016 00:11:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOWinzTl-9Uc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2016 00:11:04 -0400 (EDT)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D74B14025C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2016 00:11:04 -0400 (EDT)
In-Reply-To: <1478120132-9928-1-git-send-email-wei@redhat.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Wei,

On 2016-11-02 14:55, Wei Huang wrote:
> KVM calls kvm_pmu_set_counter_event_type() when PMCCFILTR is 
> configured.
> But this function can't deals with PMCCFILTR correctly because the 
> evtCount
> bit of PMCCFILTR, which is reserved 0, conflits with the SW_INCR event
> type of other PMXEVTYPER<n> registers. To fix it, when eventsel == 0, 
> KVM
> shouldn't return immediately, but instead it needs to check further if
> select_idx is ARMV8_PMU_CYCLE_IDX.
> 
> Another issue is that KVM shouldn't copy the eventsel bits of 
> PMCCFILTER
> directly to attr.config. Istead it shoudl convert the request to
> perf_event of type 0x11 (i.e. the "cpu cycle" event type).
> 
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>  virt/kvm/arm/pmu.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 6e9c40e..13cc812 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -379,7 +379,8 @@ void kvm_pmu_set_counter_event_type(struct
> kvm_vcpu *vcpu, u64 data,
>  	eventsel = data & ARMV8_PMU_EVTYPE_EVENT;
> 
>  	/* Software increment event does't need to be backed by a perf event 
> */
> -	if (eventsel == ARMV8_PMU_EVTYPE_EVENT_SW_INCR)
> +	if (eventsel == ARMV8_PMU_EVTYPE_EVENT_SW_INCR &&
> +	    select_idx != ARMV8_PMU_CYCLE_IDX)
>  		return;
> 
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
> @@ -391,7 +392,7 @@ void kvm_pmu_set_counter_event_type(struct
> kvm_vcpu *vcpu, u64 data,
>  	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
>  	attr.exclude_hv = 1; /* Don't count EL2 events */
>  	attr.exclude_host = 1; /* Don't count host events */
> -	attr.config = eventsel;
> +	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ? 0x011 : eventsel;

Nit: Is there some way you could use ARMV8_PMUV3_PERFCTR_CPU_CYCLES 
currently
defined in arch/arm64/kernel/perf_event.c?

Thanks,
Cov
