Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793193121;
	b=4RfLvuHjyxjbYhuxpuEv9q9bkah6tMZCWx+FBISjxorlhKHSVu/DXr/whuhwH86Dv9T1
	 EiFQkKA3CybukGHf/3drJRbtWlXKvCWHUG0B0h2wqCy3LHPMTGHUTVJ+6lIKi3I1sp5wI
	 6/ZsTlzYxOvuFLcpQz5NVMIjtfpJoVD1GICsI6s1fk4x5QqoCBnm9gYDSlCcMv5gNZ4ZL
	 2ZsQg2rg8I9lQ7Cd2J1EKfxjutXgG5CtMoEM0g77ZuG2eJ3i0wbUlfdtox6NsA4w589vg
	 isajd2e6jYYN3/yvTKG/aE1+UxkyfynrnS4hBbOfS11ADu0Z5OX4si7I0dQQzJLYCNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793193121;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ecUemaTc55nocyfU0f1NFP9v9OzEV+UdH17xCsNf8M8=;
	b=5QL5B/9oaYF8Sfoq2k87B4dc9YxYVuJi2V2IXOm56ZCKX7e7HJSJ1YupfRGvz/HVEx52
	 cmKvvnmA/2Eif7wOGUTV0VfhQv4VDyYpmBOfM3jJGJ0/3gTmU3jOV9PalW9geIkwt7RYo
	 ZGVqpfecdRAcapthAq04H+GjhjmYpzSranN4wnoyTO4FNgG/gTCI+dGudPi45PFNBHOfb
	 pJYsx3KgGs5hsYqtkocl5Sdvf42vowlgzIov0FdfIZtO9li6XiYWPsCsSREN5pjZlHFhk
	 aGbuFon9ChbqUIUCADAUyvTWQ/JxZKLfBu2F42J5o2biuBuzHVEA6E/fKKnxFzdmdAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbKhIfTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1620A606A31A;
	Wed, 28 Oct 2026 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbKhIfTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C401F01825;
	Wed, 28 Oct 2026 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793193120;
	bh=ecUemaTc55nocyfU0f1NFP9v9OzEV+UdH17xCsNf8M8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kbKhIfTlSawp1EcnJJ/W+BSZbPK4ax/IsabagSjMUPDgVbhin3BImO+Mudbu94JZm
	 Y/lTynDeg92YcqeAXtuCKi2HCd4BvTbYIHn7dIAyl61SYe7jjfMh6jmTSyp2NjJ6do
	 v1rshekOh3qrqU/XYTMsY4FF3uF/1AiPpo+ZvUC3xD8gubj8HUZ9+wl5MilN7vKIft
	 MMYA+xMjRLWLCLL3z+Wm4+zUA3DuhLL2N3A8encCD7YAYpDHA5HT4INVtn4ihkTVZ0
	 34mA3yvC4LwN+NAyz2FZZOOBRhsoc2YnNCuoHxUsHgKfrgqDjRBu31O2XXMRN6STlp
	 wN+9YnZbThodA==
Date: Wed, 28 Oct 2026 13:11:54 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 13/28] KVM: arm64: Add SPE VCPU device attribute
 to set the SPE device
Message-ID: <auHUUHYtQXg0imDt@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-14-alexandru.elisei@arm.com>
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
In-Reply-To: <20260903160623.315525-14-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:08PM +0100, Alexandru Elisei wrote:
> To support systems where there is more than one SPE instance, or where not
> all the PEs have SPE, add KVM_ARM_VCPU_SPE_CTRL(KVM_ARM_VCPU_SPE_ID) for
> userspace to set the SPE instance it wants the virtual machine to use.
> Similar to the PMU, it is entirely up to userspace to make sure the VCPUs
> are run only on the physical CPUs which share this SPE instance.

OK but this is enforced by KVM right? So while it's up to userspace to
ensure affinity, this is checked for and if the user gets it wrong KVM will
bail AFAICT?

So I'd probably add something here about what happens if you don't do this
- i.e. 'this is checked on vCPU load via kvm_arch_vcpu_load(), and if the
CPU does not share the SPE instance specified, KVM will eventually error
out to userspace.'

>
> If the ioctl is called for multiple VCPUs, userspace must use the same
> SPE identifier for each of the VCPUs.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  Documentation/virt/kvm/devices/vcpu.rst | 32 +++++++++
>  arch/arm64/include/asm/kvm_host.h       |  4 ++
>  arch/arm64/include/asm/kvm_spe.h        | 19 ++++++
>  arch/arm64/include/uapi/asm/kvm.h       |  1 +
>  arch/arm64/kvm/arm.c                    | 43 ++++++++++++
>  arch/arm64/kvm/pmu-emul.c               | 11 ++-
>  arch/arm64/kvm/spe.c                    | 90 +++++++++++++++++++++++++
>  7 files changed, 198 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
> index d30b2f7fec9a..d60dd1daa67f 100644
> --- a/Documentation/virt/kvm/devices/vcpu.rst
> +++ b/Documentation/virt/kvm/devices/vcpu.rst
> @@ -329,3 +329,35 @@ Specifies the Profiling Buffer management interrupt number. The interrupt number
>  must be a PPI and the interrupt number must be the same for each VCPU. Arm
>  recommends 21 as the interrupt number. SPE virtualization requires an in-kernel
>  vGIC implementation.
> +
> +5.2 ATTRIBUTE: KVM_ARM_VCPU_SPE_ID
> +------------------------------------------
> +
> +:Parameters: in kvm_device_attr.addr the address to an int representing the SPE
> +             identifier.
> +
> +:Returns:

Hmm this is a nit obviously but this is inconsistent from the previous doc
edit which uses 'Returns:' so I think better to choose one and stick with
it :)

> +
> +	 =======  =========================================================
> +	 -EBUSY   Virtual machine has already run
> +	 -EFAULT  Error accessing the SPE identifier
> +	 -EINVAL  A different SPE instance already assigned, or no physical
> +                  CPUs found

With the introduction of kvm_update_supported_cpus() and PMU also using
that, I think you need to add an -EINVAL line to the PMU doc entry too.

> +	 -ENXIO   SPE not supported or not properly configured, or the SPE
> +                  module not loaded
> +	 -ENODEV  KVM_ARM_VCPU_HAS_SPE VCPU feature not set

Should be KVM_ARM_VCPU_SPE? Looking back I think you also typo'd this in
the previous commit? Very easily done obviously :P

> +	 =======  =========================================================
> +
> +Required.
> +
> +Request that the VCPU uses the specified SPE instance. The SPE identifier can be
> +read from the 'type' file for the desired SPE instance under /sys/devices (or,
> +equivalent, /sys/bus/event_source). Must be set for at least one VCPU, in which
> +case all the other VCPUs will use the same SPE instance. Once a SPE instance has
> +been set, attempting to set a different one will result in an error.
> +

I think you need a paragraph here to explain that you must ensure that
physical CPUs assigned to vCPUs must share the same SPE instance, and
failing to do so will result in KVM returning an error when the vCPU is
attempted to be run.

> +Similar to KVM_ARM_VCPU_PMU_V3_CTRL(KVM_ARM_VCPU_PMU_SET_PMU), userspace is
> +responsible for making sure that the VCPU is run only on physical CPUs which
> +share the specified SPE instance. If the VCPU has a PMU assigned, and there are

I think the 'userspace is responsible for making sure that the VCPU is run
only on physical CPUs which share the specified SPE instance' bit can be
hoisted into the suggested paragraph above, leaving this one to focus on
SPE/PMU interactions.

And I think the SPE-specific bit shouldn't mention a similarity to PMU, I
think that's confusing in itself.

> +no physical CPUs which share the same SPE and PMU instance, an error is
> +returned.

This is overall unclear I think. It starts with 'similar to PMU' then
mentions an actual interaction between PMU/SPE. So, as above, I suggest
separating these two out.

And here I think you should be a lot clearer about that PMU/SPE
interaction, something like:

"Both SPE and PMU restrict supported physical CPUs to the subset which
share the selected SPE or PMU instance.

If both are selected, the subsets must overlap, otherwise there would be no
physical CPU on which the vCPUs could run.

If this happens, whichever of KVM_ARM_VCPU_SPE_ID or
KVM_ARM_VCPU_PMU_V3_SET_PMU specified it returns -EINVAL.

Note that the default PMU selected by KVM is not taken into account by this
check, it only applies when a specific PMU instance has been selected via
KVM_ARM_VCPU_PMU_V3_SET_PMU."

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e7332bd82bf3..10fa223bdbda 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -382,6 +382,7 @@ struct kvm_arch {
>  	 */
>  	unsigned long *pmu_filter;
>  	struct arm_pmu *arm_pmu;
> +	struct kvm_spe kvm_spe;

I think we can do away with the kvm_ prefix on the value name?

>
>  	cpumask_var_t supported_cpus;
>
> @@ -1499,6 +1500,9 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
>  int __init kvm_set_ipa_limit(void);
>  u32 kvm_get_pa_bits(struct kvm *kvm);
>
> +int kvm_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus,
> +			      cpumask_t *spe_cpus);
> +
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  struct kvm *kvm_arch_alloc_vm(void);
>
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 8ded2d821bff..b8afb419c851 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -11,6 +11,11 @@ struct kvm_vcpu;
>  struct kvm_device_attr;
>
>  #ifdef CONFIG_KVM_ARM_SPE
> +struct arm_spe_pmu;
> +struct kvm_spe {
> +	struct arm_spe_pmu *spe_pmu;

I feel like 'spe_pmu' as a name is pretty confusing as there is PMU as
regards the perf driver thing, which SPE is implemented as, and also the
general PMUv3 architecture :)

Maybe the _pmu suffix makes sense then on the type (which has to be a
performance monitoring unit driver), but could we replace '_pmu' with
'_instance' in the field, etc. names?

> +};

This looks a little silly as a one field struct, but presumably because you
add more later. I think worth saying so in the commit message?

> +
>  struct kvm_vcpu_spe {
>  	int irq_num;		/* Buffer management interrupt number */
>  };
> @@ -20,10 +25,17 @@ bool kvm_supports_spe(void);
>  #define vcpu_has_spe(vcpu)					\
>  	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_SPE))
>
> +void kvm_spe_destroy_vm(struct kvm *kvm);

This naming feels weird, reads to me like 'spe, destroy the vm' which is
probably not the intent :P

Maybe just kvm_spe_destroy()?

> +
>  int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
>  int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
> +
> +bool kvm_spe_pmu_set(struct kvm *kvm);
>  #else
> +struct kvm_spe {
> +};
> +
>  struct kvm_vcpu_spe {
>  };
>
> @@ -34,6 +46,9 @@ static __always_inline bool kvm_supports_spe(void)
>
>  #define vcpu_has_spe(vcpu)	false
>
> +static inline void kvm_spe_destroy_vm(struct kvm *kvm)
> +{
> +}
>  static inline int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	return -ENXIO;
> @@ -46,6 +61,10 @@ static inline int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr
>  {
>  	return -ENXIO;
>  }
> +static inline bool kvm_spe_pmu_set(struct kvm *kvm)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_KVM_ARM_SPE */
>
>  #endif /* __ARM64_KVM_SPE_H__ */
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index b9e5019181eb..8ffa3e89d38c 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -448,6 +448,7 @@ enum {
>  #define   KVM_ARM_VCPU_PVTIME_IPA	0
>  #define KVM_ARM_VCPU_SPE_CTRL		3
>  #define   KVM_ARM_VCPU_SPE_IRQ		0
> +#define   KVM_ARM_VCPU_SPE_ID		1
>
>  /* KVM_IRQ_LINE irq field index values */
>  #define KVM_ARM_IRQ_VCPU2_SHIFT		28
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 763b102dc51f..132df44c3088 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -336,6 +336,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  	kfree(kvm->arch.sysreg_masks);
>  	kvm_destroy_vcpus(kvm);
>
> +	kvm_spe_destroy_vm(kvm);
> +
>  	kvm_unshare_hyp(kvm, kvm + 1);
>
>  	kvm_arm_teardown_hypercalls(kvm);
> @@ -612,6 +614,47 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>
>  }
>
> +int kvm_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus,
> +			      cpumask_t *spe_cpus)

This interface is really awkward - it's unclear whether you need to pass
one + other NULL, or both, and what happens in each situation.

And it turns out that actually you should only specify one of them with the
other NULL as it stands.

It seems to me SPE vs. PMU is just immaterial here, and you should simply
have:

int kvm_restrict_supported_cpus(struct kvm *kvm, const cpumask_t *mask)
{
	lockdep_assert_held(&kvm->arch.config_lock);

	if (!cpumask_intersects(kvm->arch.supported_cpus, mask))
		return -EINVAL;

	cpumask_and(kvm->arch.supported_cpus, kvm->arch.supported_cpus, mask);
	return 0;
}

Then all the complexity goes away.

I think it's then simplest to simply disallow re-selection for both SPE and
PMU, returning -EBUSY if they're already selected.

That way it's very clear-cut - you set these once and only once.

You have kvm_spe_pmu_set() already. However that name is also a bit
confusing, since maybe it means 'set it' or refers to its CPU subset or
something. Also I dislike 'pmu' in there as mentioned before.

So that should probably be renamed to kvm_spe_has_instance()?

And to handle the PMU side, introduce KVM_ARCH_FLAG_PMU_SELECTED in
kvm->arch.flags and set this when PMU is selected.

Then add kvm_pmu_has_instance() which tests for this flag.

That way everything is consistent and simple.

> +int kvm_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus,
> +			      cpumask_t *spe_cpus)

> +{
> +	cpumask_t *supported_cpus;

I see the bot has already reported about this, but supported_cpus should be
a cpumask_var_t (which is cpumask_t * if CONFIG_CPUMASK_OFFSTACK, but a
1-element array if not), as zalloc_cpumask_var() accepts a pointer of this
type (cpumask_t ** or cpumask_t (*)[1]).

I think if !CONFIG_CPUMASK_OFFSTACK that's actually a compile error.

So fix is:

	cpumask_var_t supported_cpus;

But as per above, I think better to just radically simplify this function.

> +	cpumask_t *cpus;
> +	int ret;
> +
> +	if (!zalloc_cpumask_var(&supported_cpus, GFP_KERNEL_ACCOUNT))
> +		return -ENOMEM;
> +
> +	cpumask_copy(supported_cpus, kvm->arch.supported_cpus);
> +
> +	lockdep_assert_held(&kvm->arch.config_lock);
> +
> +	ret = -EINVAL;
> +	/* Cannot update for SPE and PMU at the same time. */
> +	if (WARN_ON_ONCE(pmu_cpus && spe_cpus))
> +		goto out;
> +
> +	if (pmu_cpus)
> +		cpus = pmu_cpus;
> +	else
> +		cpus = spe_cpus;
> +
> +	if ((spe_cpus && kvm->arch.arm_pmu) ||
> +	    (pmu_cpus && kvm_spe_pmu_set(kvm)))
> +		cpumask_and(supported_cpus, cpus, supported_cpus);
> +	else
> +		cpumask_copy(supported_cpus, cpus);
> +
> +	if (cpumask_empty(supported_cpus))
> +		goto out;
> +
> +	cpumask_copy(kvm->arch.supported_cpus, supported_cpus);
> +	ret = 0;
> +out:
> +	free_cpumask_var(supported_cpus);
> +
> +	return ret;
> +}

See above re: significant simplification of this.

> +
>  static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
>  {
>  	if (vcpu_has_ptrauth(vcpu) && !is_protected_kvm_enabled()) {
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 5b1af7e2176f..59930e1bf357 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -1085,6 +1085,11 @@ int kvm_arm_set_default_pmu(struct kvm *kvm)
>  	return 0;
>  }
>
> +static int kvm_pmu_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus)
> +{
> +	return kvm_update_supported_cpus(kvm, pmu_cpus, NULL);
> +}

Again the naming bites again here :) kvm_spe_pmu and kvm_pmu are confusing.

Anyway, I think with the suggested changes above we can do away with this
wrapper, like (untested):

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ kvm_arm_pmu_v3_set_pmu()
                if (arm_pmu->pmu.type == pmu_id) {
-                       if (kvm_vm_has_ran_once(kvm) ||
-                           (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
-                               ret = -EBUSY;
-                               break;
-                       }
-
-                       ret = kvm_pmu_update_supported_cpus(kvm, &arm_pmu->supported_cpus);
+                       if (kvm_pmu_has_instance(kvm) && kvm->arch.arm_pmu == arm_pmu)
+                               ret = 0;
+                       else if (kvm_vm_has_ran_once(kvm) || kvm_pmu_has_instance(kvm) ||
+                                (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu))
+                               ret = -EBUSY;
+                       else
+                               ret = kvm_restrict_supported_cpus(kvm, &arm_pmu->supported_cpus);
                        if (ret)
                                break;
                        kvm_arm_set_pmu(kvm, arm_pmu);
+                       set_bit(KVM_ARCH_FLAG_PMU_SELECTED, &kvm->arch.flags);

Now this does change the semantics - before a VMM could set PMU A, then
change its mind and set PMU B, and on and on as many times as it likes as long
as no event filter was set, with the last one winning.

After this, you set it once.

I don't imagine any VMM is doing or needs to do the former, and if they are
it's a bug really. So I think it's a valid thing to do, and makes
everything consistent.

The SPE side would be easier:

--- a/arch/arm64/kvm/spe.c
+++ b/arch/arm64/kvm/spe.c
@@ kvm_spe_set_spe_id()
        struct arm_spe_pmu *existing_spe_pmu, *spe_pmu = NULL;
        struct spe_pmu_entry *entry;
+       int err;

        if (kvm_vm_has_ran_once(kvm))
                return -EBUSY;
@@
        existing_spe_pmu = kvm_spe->spe_pmu;
        if (existing_spe_pmu) {
                if (existing_spe_pmu != spe_pmu)
-                       return -EINVAL;
+                       return -EBUSY;
                return 0;
        }

        if (!try_module_get(spe_pmu->pmu.module))
                return -ENXIO;

-       if (kvm_spe_update_supported_cpus(kvm, &spe_pmu->supported_cpus)) {
+       err = kvm_restrict_supported_cpus(kvm, &spe_pmu->supported_cpus);
+       if (err) {
                module_put(spe_pmu->pmu.module);
-               return -EINVAL;
+               return err;
        }

> +
>  static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -1104,8 +1109,11 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  				break;
>  			}
>
> +			ret = kvm_pmu_update_supported_cpus(kvm, &arm_pmu->supported_cpus);
> +			if (ret)
> +				break;
>  			kvm_arm_set_pmu(kvm, arm_pmu);
> -			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
> +

Looks like a stray extra line here?

>
>  			/*
>  			 * Since a specific PMU is explicitly selected,
> @@ -1117,7 +1125,6 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
>  				kvm->arch.pmmir_slots =
>  					FIELD_GET(ARMV8_PMU_SLOTS,
>  						  arm_pmu->reg_pmmir);
> -			ret = 0;

I guess because you assign ret above (and if non-zero bail) you don't need
to reset here, but probably worth keeping just to be really clear as to
intent?

>  			break;
>  		}
>  	}
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index dd5f80318ba4..87fcdbbcbd67 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -59,6 +59,71 @@ bool kvm_supports_spe(void)
>  	return !list_empty(&spe_pmus);
>  }
>
> +void kvm_spe_destroy_vm(struct kvm *kvm)

See above re: naming.

> +{
> +	struct arm_spe_pmu *spe_pmu;
> +
> +	guard(mutex)(&spe_pmus_lock);
> +
> +	spe_pmu = kvm->arch.kvm_spe.spe_pmu;
> +	if (!spe_pmu)
> +		return;
> +
> +	module_put(spe_pmu->pmu.module);

Does spe_pmus_lock (hopefully spe_instances_lock in future :P) need to be
held over module_put()? Seems unnecessary.

> +}
> +
> +bool kvm_spe_pmu_set(struct kvm *kvm)

See comments above re: naming.

> +{
> +	return !!kvm->arch.kvm_spe.spe_pmu;

This !! is unnecessary. The conversion to bool handles it for you.

> +}
> +
> +static int kvm_spe_update_supported_cpus(struct kvm *kvm, cpumask_t *spe_cpus)
> +{
> +	return kvm_update_supported_cpus(kvm, NULL, spe_cpus);
> +}

See above re: the helpers.

> +
> +static int kvm_spe_set_spe_id(struct kvm_vcpu *vcpu, int spe_id)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
> +	struct arm_spe_pmu *existing_spe_pmu, *spe_pmu = NULL;

Obviously similar comments to above about 'spe_pmu' -> 'spe_instance' :)

> +	struct spe_pmu_entry *entry;
> +
> +	if (kvm_vm_has_ran_once(kvm))
> +		return -EBUSY;
> +
> +	guard(mutex)(&spe_pmus_lock);
> +
> +	list_for_each_entry(entry, &spe_pmus, link) {
> +		if (entry->spe_pmu->pmu.type == spe_id) {
> +			spe_pmu = entry->spe_pmu;
> +			break;
> +		}
> +	}
> +
> +	if (!spe_pmu)
> +		return -ENXIO;
> +
> +	existing_spe_pmu = kvm_spe->spe_pmu;
> +	if (existing_spe_pmu) {
> +		if (existing_spe_pmu != spe_pmu)
> +			return -EINVAL;

This really should be -EBUSY for consistency I think.

See above for suggested change to the code for setting up the CPU mask.

> +		return 0;
> +	}
> +
> +	if (!try_module_get(spe_pmu->pmu.module))
> +		return -ENXIO;
> +
> +	if (kvm_spe_update_supported_cpus(kvm, &spe_pmu->supported_cpus)) {

You're ignoring the error here, better to do:

	int err;
	...
	err = kvm_spe_update_supported_cpus(kvm, &spe_pmu->supported_cpus);
	if (err) {
		...
		return err;
	}

> +		module_put(spe_pmu->pmu.module);
> +		return -EINVAL;
> +	}
> +
> +	kvm_spe->spe_pmu = spe_pmu;
> +
> +	return 0;
> +}
> +
>  static bool kvm_spe_irq_is_valid(struct kvm *kvm, int irq)
>  {
>  	struct kvm_vcpu *vcpu;
> @@ -108,6 +173,15 @@ int kvm_spe_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		vcpu_spe->irq_num = irq;
>  		return 0;
>  	}
> +	case KVM_ARM_VCPU_SPE_ID: {
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		int spe_id;
> +
> +		if (get_user(spe_id, uaddr))
> +			return -EFAULT;
> +
> +		return kvm_spe_set_spe_id(vcpu, spe_id);
> +	}
>  	}
>
>  	return -ENXIO;
> @@ -117,6 +191,7 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  {
>  	struct kvm_vcpu_spe *vcpu_spe = &vcpu->arch.vcpu_spe;
>  	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_spe *kvm_spe = &kvm->arch.kvm_spe;
>
>  	if (!vcpu_has_spe(vcpu))
>  		return -ENODEV;
> @@ -138,6 +213,20 @@ int kvm_spe_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>  		return 0;
>  	}
> +	case KVM_ARM_VCPU_SPE_ID: {
> +		struct arm_spe_pmu *spe_pmu = kvm_spe->spe_pmu;
> +		int __user *uaddr = (int __user *)(long)attr->addr;
> +		int spe_id;
> +
> +		if (!spe_pmu)
> +			return -ENXIO;
> +
> +		spe_id = spe_pmu->pmu.type;
> +		if (put_user(spe_id, uaddr))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
>  	}
>
>  	return -ENXIO;
> @@ -150,6 +239,7 @@ int kvm_spe_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>
>  	switch(attr->attr) {
>  	case KVM_ARM_VCPU_SPE_IRQ:
> +	case KVM_ARM_VCPU_SPE_ID:
>  		return 0;
>  	}
>
> --
> 2.43.0
>
>

Assuming you are on board with the suggested rework, I feel like this patch
needs splitting up into:

1. "KVM: arm64: Add helper to restrict a VM's supported CPUs"

Adds the helper, converts SET_PMU, discuss the change in
behaviour. PMU-only, establishes the foundations.

Update PMU doc to reflect new -EINVAL return.

2. "KVM: arm64: Add SPE VCPU device attribute to set the SPE device"

All the SPE bits.

Does that make sense?

--
Cheers, Lorenzo
