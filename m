From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 25/26] KVM: arm/arm64: GICv4: Prevent heterogenous
 systems from using GICv4
Date: Thu, 26 Oct 2017 16:48:39 +0100
Message-ID: <20171026154839.ebtmqzcy7jjyejul@salmiak>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-26-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E53EF49D23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 11:47:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T7uR3E7+2ABQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Oct 2017 11:47:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7702349D21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Oct 2017 11:47:28 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-26-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On Fri, Oct 06, 2017 at 04:34:00PM +0100, Marc Zyngier wrote:
> The GICv4 architecture doesn't prevent CPUs implementing GICv4 to
> cohabit with CPUs limited to GICv3 in the same system.
> 
> This is mad (the scheduler would have to be made aware of the v4
> capability), and we're certainly not going to support this any
> time soon. So let's check that all online CPUs are GICv4 capable,
> and disable the functionnality if not.

I just spotted this because of Christoffer's review; apologies for the late
drive-by comment...

> @@ -485,8 +495,21 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
>  	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
>  
> -	/* GICv4 support? */
> +	/*
> +	 * GICv4 support? We need to check on all CPUs in case of some
> +	 * extremely creative form of big-little brain damage...
> +	 */
>  	if (info->has_v4) {
> +		int cpu;
> +
> +		for_each_online_cpu(cpu) {
> +			bool enable;
> +
> +			smp_call_function_single(cpu, vgic_check_v4_cpuif,
> +						 &enable, 1);
> +			gicv4_enable = gicv4_enable && enable;
> +		}

With maxcpus=N on the command line, CPUs can be brought online late, so we
might need this in a hotplug callback (and/or in the arm64 cpufeature
framework) to handle that case.

Thanks,
Mark.
