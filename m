From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v10 4/5] arm64: arm_pmu: Add support for
 exclude_host/exclude_guest attributes
Date: Mon, 11 Feb 2019 11:26:19 +0000
Message-ID: <20190211112619.GA32385@fuggles.cambridge.arm.com>
References: <1547482308-29839-1-git-send-email-andrew.murray@arm.com>
 <1547482308-29839-5-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B9494A330
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Feb 2019 06:26:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DUFzlaObQsDl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Feb 2019 06:26:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51BC049F94
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Feb 2019 06:26:31 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1547482308-29839-5-git-send-email-andrew.murray@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andrew,

On Mon, Jan 14, 2019 at 04:11:47PM +0000, Andrew Murray wrote:
> Add support for the :G and :H attributes in perf by handling the
> exclude_host/exclude_guest event attributes.
> 
> We notify KVM of counters that we wish to be enabled or disabled on
> guest entry/exit and thus defer from starting or stopping :G events
> as per the events exclude_host attribute.
> 
> With both VHE and non-VHE we switch the counters between host/guest
> at EL2. We are able to eliminate counters counting host events on
> the boundaries of guest entry/exit when using :G by filtering out
> EL2 for exclude_host. However when using :H unless exclude_hv is set
> on non-VHE then there is a small blackout window at the guest
> entry/exit where host events are not captured.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/kernel/perf_event.c | 53 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 46 insertions(+), 7 deletions(-)

[...]

>  static inline int armv8pmu_enable_intens(int idx)
> @@ -824,16 +851,25 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
>  	 * Therefore we ignore exclude_hv in this configuration, since
>  	 * there's no hypervisor to sample anyway. This is consistent
>  	 * with other architectures (x86 and Power).
> +	 *
> +	 * To eliminate counting host events on the boundaries of
> +	 * guest entry/exit we ensure EL2 is not included in hyp mode
> +	 * with !exclude_host.
>  	 */
>  	if (is_kernel_in_hyp_mode()) {
> -		if (!attr->exclude_kernel)
> +		if (!attr->exclude_kernel && !attr->exclude_host)
>  			config_base |= ARMV8_PMU_INCLUDE_EL2;
>  	} else {
> -		if (attr->exclude_kernel)
> -			config_base |= ARMV8_PMU_EXCLUDE_EL1;
>  		if (!attr->exclude_hv)
>  			config_base |= ARMV8_PMU_INCLUDE_EL2;
>  	}
> +
> +	/*
> +	 * Filter out !VHE kernels and guest kernels
> +	 */
> +	if (attr->exclude_kernel)
> +		config_base |= ARMV8_PMU_EXCLUDE_EL1;
> +

This series needs acks from the KVM folks, but I'd also like Christoffer to
confirm that he's happy with the way these checks ended up because I lost
track of where we got to on that.

Will
