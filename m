From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 1/4] arm64: arm_pmu: remove unnecessary isb instruction
Date: Wed, 21 Nov 2018 15:58:14 +0000
Message-ID: <20181121155814.5jvhnrtftiwzaczo@lakrids.cambridge.arm.com>
References: <1542723322-42536-1-git-send-email-andrew.murray@arm.com>
 <1542723322-42536-2-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFCB94A262
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 10:58:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8JoJGiDNFAQ8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Nov 2018 10:58:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DECC40217
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Nov 2018 10:58:19 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1542723322-42536-2-git-send-email-andrew.murray@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Nov 20, 2018 at 02:15:19PM +0000, Andrew Murray wrote:
> The armv8pmu_enable_event_counter function issues an isb instruction
> after enabling a pair of counters - this doesn't provide any value
> and is inconsistent with the armv8pmu_disable_event_counter.
> 
> In any case armv8pmu_enable_event_counter is always called with the
> PMU stopped. Starting the PMU with armv8pmu_start results in an isb
> instruction being issued.
> 
> Let's remove the unnecessary isb instruction.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>

Acked-by: Mark Rutland <mark.rutland@arm.com>

... though it would be nice to explicitly point out that the ISB in 
armv8pmu_start() is before the write to PMCR_EL1, if you happen to
respin this patch.

Mark.

> ---
>  arch/arm64/kernel/perf_event.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 8e38d52..de564ae 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -652,7 +652,6 @@ static inline void armv8pmu_enable_event_counter(struct perf_event *event)
>  	armv8pmu_enable_counter(idx);
>  	if (armv8pmu_event_is_chained(event))
>  		armv8pmu_enable_counter(idx - 1);
> -	isb();
>  }
>  
>  static inline int armv8pmu_disable_counter(int idx)
> -- 
> 2.7.4
> 
