Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793725460;
	b=yXxOn/H288Kbha++P279avtE4PG267i7ziKZ9BjOLf+9v9FlTJu7vlVzsRlykyZAgj/M
	 D6jSIXf0oObILzzATlEbWm49lVguiKUU6Rbmu8JanlIZ4L8klqlD1QLljhvbHbDxWvW5Y
	 KrznqdFO6aw/qCb00W/P7UA3eYD2ZKhm+xo2HRbSTxABJ+Of25/wuMFQUfKBkXchVsNLn
	 I9X8NhtANFzibuYDFX6QKWBUzRDjB0tksV+omKkzZvZo7cCVQshPBl5guoJdmOxn3ly3I
	 QnOjDrgJHzZ5ZmA5bsrt/gyVxrKABDJT9Bqx4T8/D66F7SPFpaE9d5KcGdv9BQjjO2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793725460;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4sghRfvpX+eAonCWMENYaARxGNgqibOAgOQ2PAAwmw4=;
	b=0FMCPxPkDSzo1PcZpfL9lOQjzLph+WxZHYpBUvnbpkqdN+3GwgtsTjhvVmgshzO2+v89
	 3xnNzl5sdH7nYfvoJMpbdTsrc78DU+42j2yMGxMGPQXGVpyB1pQatajASVY5IRS67HnI/
	 T77rxSAyU2yLukr+S2LId74VS20LIlZUphd3NnJMFxJj3EIiQWi73Jr1fO4Ey10GGiF3V
	 lorGEnDqUwMjzCrKioQ0TFSA8nCfmyC9VOr4JcrmjAviXbOdv78l0F+RnhJfl1U9RX7g4
	 bSUf/lANdPLYH7E4AUsJE5icRhOqaKurH3uNheI52A8Lpi+nB2GPAOP1AeRffLD/YLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZfVrbbFu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC801606A328;
	Tue,  3 Nov 2026 17:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZfVrbbFu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C151F00A1A;
	Tue,  3 Nov 2026 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793725459;
	bh=4sghRfvpX+eAonCWMENYaARxGNgqibOAgOQ2PAAwmw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZfVrbbFufgZA6P/d4rWcT527uw6YZfQsIVznyaLz4A1a/OAXgncABl+7dSLuy4iID
	 l9NIRi3hzDhTSqf/QfojeZs+qo/5xwGsxXoieFKBWf8s3rvR4H1zCG8urUW11azHI5
	 1uTSmXMVQOpV8pTXKBgsL/qD3BSD09Qp1YozTeSZf7H1BEtzikIYf6yNwPBiaCfoHp
	 UEp9frYgP9OvM7Sux9j6uM9L7ar9TcLKtvpl/mWOHYlNFnEr4FspOxRgfSknwki7eR
	 vHHV0kT4k+0PBo0HPL9A9H3O6ypPu3nTCTEKF78+cH4cSs+sgid0tY72l85X9dvMF5
	 mNdjbhTIAHj+Q==
Date: Tue, 3 Nov 2026 17:04:13 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 20/28] KVM: arm64: Allow guest SPE physical
 timestamps only if kernel allows it
Message-ID: <auoFWWJHUcmvif7s@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-21-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-21-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:15PM +0100, Alexandru Elisei wrote:
> The SPE driver allows userspace to use physical timestamps for records only
> if the kernel allows it, do the same for a virtual machine.

This is really bare bones again. You are making a broader change of restoring
PMSCR_EL2 and gating on perf_allow_kernel() etc. - you should explain what
you're doing here.

Also you definitely need a 'why' here :>)

>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/include/asm/kvm_spe.h | 1 +
>  arch/arm64/kvm/hyp/vhe/spe-sr.c  | 5 +++--
>  arch/arm64/kvm/spe.c             | 8 ++++++++
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index ad0ad6ace93c..8a55ea0de4e5 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -15,6 +15,7 @@ struct arm_spe_pmu;
>  struct kvm_spe {
>  	struct arm_spe_pmu *spe_pmu;
>  	u64 pmblimitr_el1_res0_mask;
> +	u64 guest_pmscr_el2;
>  };
>
>  struct kvm_vcpu_spe {
> diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> index 978620ad99fa..3c32a1338cc8 100644
> --- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
> +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> @@ -107,6 +107,7 @@ static bool __kvm_spe_profiling_buffer_enabled(u64 pmblimitr, u64 pmbsr)
>   */
>  void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
>  {
> +	struct kvm *kvm = vcpu->kvm;
>  	u64 pmblimitr, pmbsr;
>
>  	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
> @@ -120,10 +121,10 @@ void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_con
>  		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
>  	}
>
> -	__kvm_spe_restore_sampling_regs(vcpu->kvm, guest_ctxt);
> +	__kvm_spe_restore_sampling_regs(kvm, guest_ctxt);
>
>  	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
> -	write_sysreg_el2(0, SYS_PMSCR);
> +	write_sysreg_el2(kvm->arch.kvm_spe.guest_pmscr_el2, SYS_PMSCR);
>  }
>  NOKPROBE_SYMBOL(__kvm_spe_restore_guest_state_vhe);
>
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index af1e19cb8e9a..68b751bdb384 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -3,9 +3,11 @@
>   * Copyright (C) 2021 - ARM Ltd
>   */
>
> +#include <linux/capability.h>
>  #include <linux/cpumask.h>
>  #include <linux/kvm_host.h>
>  #include <linux/perf/arm_spe_pmu.h>
> +#include <linux/perf_event.h>
>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_spe.h>
> @@ -97,6 +99,12 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
>  	if (!kvm_spe->pmblimitr_el1_res0_mask)
>  		kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);
>
> +	if (kvm_vm_has_ran_once(kvm))
> +		return 0;
> +
> +	if (perf_allow_kernel())
> +		kvm_spe->guest_pmscr_el2 = PMSCR_EL2_PCT_PHYS;

Ouch, I see the bot raised that perf_allow_kernel() does the 'return 0 if
success' pattern which is just AWFUL naming.

Though I'm confused as to why you're gating on this at all? The driver needs to,
I get that, as you don't want host userspace to gain access.

But physical timestamps in the SPE buffer seems fine? What's the threat model
there? This should be explained with a comment/commit msg if there if it's
needed.

Does it expose this data to userspace in a way that is not correctly gated? Or
does the driver already handle this?

Looking at [0], I can see that there are multiple options here in PMSCR_EL2.PCT:

* PMSCR_EL2_PCT_VIRT = 0b00 - Virtual, offset by CNTVOFF_EL2 (unless EL2-owned
  then 0, but patch 19 already made it EL1-owned when guest sampling).

* PMSCR_EL2_PCT_PHYS = 0b01 - Defer to PMSCR_EL1.PCT if EL1-owned, otherwise
  phys. Define phys as the RAW physical counter (no offset).

* PMSCR_EL2_PCT_GUEST = 0b11 - Defer to PMSCR_EL1.PCT if EL1-owned.
  Virtual means raw phys minus CNTVOFF_EL2. Phys means raw phys minus
  CNTPOFF_EL2 when ECV is enabled, otherwise no offset.

And [1], [2] tells me that there are offsets to take into account (ugh)
which I see can be set via KVM_ARM_SET_COUNTER_OFFSET, and these counters will
be what is used to correlate the data with other perf counters.

As far as I can make out from the timer code, if there's no CNTPOFF_EL2
but userspace has set a physical offset, KVM traps the guest's CNTPCT
reads and applies the offset in software, i.e. in timer_set_traps():

    /*
     * We have two possibility to deal with a physical offset:
     *
     * - Either we have CNTPOFF (yay!) or the offset is 0:
     *	 we let the guest freely access the HW
     *
     * - or neither of these condition apply:
     *	 we trap accesses to the HW, but still use it
     *	 after correcting the physical offset
     */
    if (!has_cntpoff() && timer_get_offset(map->direct_ptimer))
	tpt = tpc = true;

So just accepting physical timestamps in SPE would mean they'd be offset
from the physical counter.

Where CNTPOFF_EL2 exists, PMSCR_EL2_PCT_GUEST does the right thing in
both directions - virtual minus CNTVOFF_EL2, physical minus
CNTPOFF_EL2).

But you're kinda screwed if it doesn't, so the only way for the timestamps
to be consistent with what's expected is to force a virtual offset.

So the code should look like:

    u64 pct;

    ...

    /* Without CNTPOFF_EL2 physical timestamps can't be offset, so deny them. */
    pct = has_cntpoff() ? PMSCR_EL2_PCT_GUEST : PMSCR_EL2_PCT_VIRT;
    kvm_spe->guest_pmscr_el2 = FIELD_PREP(PMSCR_EL2_PCT, pct);

I think.

> +
>  	return 0;
>  }
>
> --
> 2.43.0
>
>

--
Cheers, Lorenzo

[0]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/PMSCR-EL2--Statistical-Profiling-Control-Register--EL2-?lang=en
[1]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/CNTVOFF-EL2--Counter-timer-Virtual-Offset-Register?lang=en
[2]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/CNTPOFF-EL2--Counter-timer-Physical-Offset-Register?lang=en
