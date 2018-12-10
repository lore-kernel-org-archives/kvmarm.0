From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 06/12] KVM: arm64: Support Live Physical Time reporting
Date: Mon, 10 Dec 2018 10:56:32 +0000
Message-ID: <20181210105632.hjdnszkcqwiqbyub@lakrids.cambridge.arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
 <20181128144527.44710-7-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC694A2F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:56:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HbWdH-ariaTb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Dec 2018 05:56:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BE7C4A2BA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Dec 2018 05:56:37 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181128144527.44710-7-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Price <steven.price@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Nov 28, 2018 at 02:45:21PM +0000, Steven Price wrote:
> Provide a method for a guest to derive a paravirtualized counter/timer
> which isn't dependent on the host's counter frequency. This allows a
> guest to be migrated onto a new host which doesn't have the same
> frequency without the virtual counter being disturbed.

I have a number of concerns about paravirtualizing the timer frequency,
but I'll bring that up in reply to the cover letter.

I have some orthogonal comments below.

> The host provides a shared page which contains coefficients that can be
> used to map the real counter from the host (the Arm "virtual counter")
> to a paravirtualized view of time. On migration the new host updates the
> coefficients to ensure that the guests view of time (after using the
> coefficients) doesn't change and that the derived counter progresses at
> the same real frequency.

Can we please avoid using the term 'page' here?

There is a data structure in shared memory, but it is not page-sized,
and referring to it as a page here and elsewhere is confusing. The spec
never uses the term 'page'

Could we please say something like:

  The host provides a datastrucutre in shared memory which ...

... to avoid the implication this is page sized/aligned etc.

[...]

> +	struct kvm_arch_pvtime {
> +		void *pv_page;
> +
> +		gpa_t lpt_page;
> +		u32 lpt_fpv;
> +	} pvtime;

To remove the page terminology, perhaps something like:

	struct kvm_arch_pvtime {
 		struct lpt	*lpt;
 		gpa_t		lpt_gpa;
 		u32		lpt_fpv;
 	};

[...]

> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 8bf259dae9f6..fd3a2caabeb2 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -49,6 +49,8 @@ typedef unsigned long  gva_t;
>  typedef u64            gpa_t;
>  typedef u64            gfn_t;
>  
> +#define GPA_INVALID    -1

To avoid any fun with signed/unsigned comparison, can we please make
this:

#define GPA_INVALID	((gpa_t)-1)

... or:

#define GPA_INVALID     (~(gpa_t)0)

[...]

> +static void update_vtimer_cval(struct kvm *kvm, u32 previous_rate)
> +{
> +	u32 current_rate = arch_timer_get_rate();
> +	u64 current_time = kvm_phys_timer_read();
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +	u64 rel_cval;
> +
> +	/* Early out if there's nothing to do */
> +	if (likely(previous_rate == current_rate))
> +		return;

Given this only happens on migration, I don't think we need to care
about likely/unlikely here, and can drop that from the condition.

[...]

> +int kvm_arm_update_lpt_sequence(struct kvm *kvm)
> +{
> +	struct pvclock_vm_time_info *pvclock;
> +	u64 lpt_ipa = kvm->arch.pvtime.lpt_page;
> +	u64 native_freq, pv_freq, scale_mult, div_by_pv_freq_mult;
> +	u64 shift = 0;
> +	u64 sequence_number = 0;
> +
> +	if (lpt_ipa == GPA_INVALID)
> +		return -EINVAL;
> +
> +	/* Page address must be 64 byte aligned */
> +	if (lpt_ipa & 63)
> +		return -EINVAL;

Please use IS_ALIGNED(), e.g.

	if (!IS_ALIGNED(lpt_ipa, 64))
		return -EINVAL;

Thanks,
Mark.
