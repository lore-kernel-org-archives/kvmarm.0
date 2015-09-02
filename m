From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 11/15] KVM: arm: add a function to keep track of host
 use of the debug registers
Date: Wed, 2 Sep 2015 17:40:16 +0200
Message-ID: <20150902154016.GN10991@cbox>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
 <1439213167-8988-12-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439213167-8988-12-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 10, 2015 at 09:26:03PM +0800, Zhichao Huang wrote:
> As we're about to implement a lazy world switch for debug registers,
> we add a function reading the break/watch control variables directly to
> indicate whether the host has enabled any break/watch points or not.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/include/asm/hw_breakpoint.h |  5 +++++
>  arch/arm/kernel/hw_breakpoint.c      | 21 +++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/asm/hw_breakpoint.h
> index f2f4c61..6f375c5 100644
> --- a/arch/arm/include/asm/hw_breakpoint.h
> +++ b/arch/arm/include/asm/hw_breakpoint.h
> @@ -66,9 +66,14 @@ int arch_install_hw_breakpoint(struct perf_event *bp);
>  void arch_uninstall_hw_breakpoint(struct perf_event *bp);
>  void hw_breakpoint_pmu_read(struct perf_event *bp);
>  int hw_breakpoint_slots(int type);
> +bool hw_breakpoint_enabled(void);
>  
>  #else
>  static inline void clear_ptrace_hw_breakpoint(struct task_struct *tsk) {}
> +static inline bool hw_breakpoint_enabled(void)
> +{
> +	return false;
> +}
>  
>  #endif	/* CONFIG_HAVE_HW_BREAKPOINT */
>  #endif  /* __ASSEMBLY */
> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> index dc7d0a9..f56788f 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -227,6 +227,27 @@ static int get_num_brps(void)
>  	return core_has_mismatch_brps() ? brps - 1 : brps;
>  }
>  
> +/* Indicate whether the host has enabled any break/watch points or not. */
> +bool hw_breakpoint_enabled(void)
> +{
> +	struct perf_event **slots;
> +	int i;

since this is exported, shouldn't you have BUG_ON(preemptible()) here
isnce you're using this_cpu_ptr()?

At least the comment to the function should describe the context in
which this can be used.

It also looks like these arrays are protected with rcu locks, so don't
you need to do rcu_read_lock() before looking at these?

> +
> +	slots = this_cpu_ptr(bp_on_reg);
> +	for (i = 0; i < core_num_brps; i++) {
> +		if (slots[i])
> +			return true;
> +	}
> +
> +	slots = this_cpu_ptr(wp_on_reg);
> +	for (i = 0; i < core_num_wrps; i++) {
> +		if (slots[i])
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * In order to access the breakpoint/watchpoint control registers,
>   * we must be running in debug monitor mode. Unfortunately, we can
> -- 
> 1.7.12.4
> 
