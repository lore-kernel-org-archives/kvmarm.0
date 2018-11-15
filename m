From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH 3/4] arm64: arm_pmu: Exclude EL1,2 with :G :H perf
 attributes
Date: Thu, 15 Nov 2018 14:57:59 +0000
Message-ID: <2b4efe9a-4f2b-961f-c841-6378dbb4bbd3@arm.com>
References: <1542286549-4501-1-git-send-email-andrew.murray@arm.com>
 <1542286549-4501-4-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C31654A336
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 09:58:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sXi6sS+kJasr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Nov 2018 09:58:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A23E64A32C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Nov 2018 09:58:03 -0500 (EST)
In-Reply-To: <1542286549-4501-4-git-send-email-andrew.murray@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On 15/11/2018 12:55, Andrew Murray wrote:
> When using VHE, EL1 is unused by the host and EL2 is unused by the
> guest - therefore we can filter out these events with the PMU as per
> the 'exclude_host' and 'exclude_guest' attributes.
> 
> With both VHE and non-VHE we switch the counters between host/guest
> at EL2. With non-VHE when using 'exclude_host' we filter out EL2.
> 
> These changes eliminate counters counting host events on the
> boundaries of guest entry/exit when using :G. However when using :H
> unless exclude_hv is set on non-VHE then there is a small blackout
> window at the guest entry/exit where host events are not captured.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>   arch/arm64/kernel/perf_event.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 89d444f..c079c1f 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -971,12 +971,14 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>   	 * with other architectures (x86 and Power).
>   	 */
>   	if (is_kernel_in_hyp_mode()) {
> -		if (!attr->exclude_kernel)
> +		if (!attr->exclude_kernel && !attr->exclude_host)
>   			config_base |= ARMV8_PMU_INCLUDE_EL2;
> +		if (attr->exclude_guest)
> +			config_base |= ARMV8_PMU_EXCLUDE_EL1;

Do we really need this ? exclude_guest also implies you need to
exclude guest EL0. We anyway disable the events when we enter the
guest. So the above is not necessary and could possibly create
confusion.

>   	} else {
>   		if (attr->exclude_kernel)
>   			config_base |= ARMV8_PMU_EXCLUDE_EL1;
> -		if (!attr->exclude_hv)
> +		if (!attr->exclude_hv && !attr->exclude_host)
>   			config_base |= ARMV8_PMU_INCLUDE_EL2;
>   	}
>   	if (attr->exclude_user)
> 


I think this can be folded into the previous patch, which adds the
support for exclude_host/guest support. :G, :H are nothing but
the those exclude_ flags.

Otherwise looks good to me.

Cheers
Suzuki
