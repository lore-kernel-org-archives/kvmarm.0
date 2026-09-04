Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E545F3B47D2;
	Fri,  4 Sep 2026 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514378; cv=none; b=R8mnlmbvAb7c84CsO5snUA6/dusMU4eGveZOiBJHPsG3kj3d1OR2YWDw39LW/alIZcRHV+qlQxAZHnIY17L9RQrjoBBqIYgPtcynf7+5/eDXBIgl/F8dGklSFftj7LPK42wvU3nCJ23q1CHltZOf4AwWvV4n9IOLcKqiIwjPjjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514378; c=relaxed/simple;
	bh=8IqxKYFOiF9vA0czxvEUZT5ZfMbk4exAdOUP2ececsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n+1PWMw+GKJD4vknDYbrtLQkPreeL4cy69frScxTS8Ht7BabljyuNIqrizIkxwGZsCisB/4WXGkQ2VGpDdjbaJhDEOilYN7r1GlG2UoAqk3quL1G7KxrmTNFKTmb6/Cu01tBKOkObtE89/RTSnQASBhJStN9qmMM/WXbu59WCpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XQOcQTSp; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XQOcQTSp"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 62B12153B;
	Fri,  4 Sep 2026 02:32:51 -0700 (PDT)
Received: from e140010.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3108B3F7D8;
	Fri,  4 Sep 2026 02:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788514375; bh=8IqxKYFOiF9vA0czxvEUZT5ZfMbk4exAdOUP2ececsI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XQOcQTSpByGGFOw1cEh85r7Gdl9ONPqWTs9Ls1J0u95vtIFuXOAHtynso4fCM1DY/
	 a7xrqPjQlc/OOuycz4BEtLsZaNLirLo5r6ahNkRUNmZRnKa+ndnxnUbpXVNvpmP49e
	 xx08k8if7QCvDyUVnRQDlQFzWcuk8/RPN6Vn6ucM=
Date: Fri, 4 Sep 2026 10:32:51 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH v7 13/28] KVM: arm64: Add SPE VCPU device attribute
 to set the SPE device
Message-ID: <apqQQ2RGo53lb--k@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-14-alexandru.elisei@arm.com>
 <20260903163944.BCAEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903163944.BCAEF1F000E9@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:39:44PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] Incorrect declaration of `supported_cpus` causes stack corruption and NULL pointer dereferences when `CONFIG_CPUMASK_OFFSTACK=n`.
> - [Medium] Changing the PMU identifier after SPE is configured incorrectly accumulates CPU mask restrictions, potentially rejecting valid reassignments.
> --
> 
> commit b2f754414c4648e5b2996f0b8f1a6f27ec6f0cf7
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: Add SPE VCPU device attribute to set the SPE device
> 
> This commit introduces a new KVM device attribute to assign an SPE
> instance to a virtual machine. It adds support for tracking physical
> CPUs that share the assigned SPE and PMU instances, ensuring VCPUs
> only run on appropriate hardware.
> 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 763b102dc51fa..132df44c30887 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> 
> [ ... ]
> 
> > @@ -612,6 +614,47 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
> >  
> >  }
> >  
> > +int kvm_update_supported_cpus(struct kvm *kvm, cpumask_t *pmu_cpus,
> > +			      cpumask_t *spe_cpus)
> > +{
> > +	cpumask_t *supported_cpus;
> > +	cpumask_t *cpus;
> > +	int ret;
> > +
> > +	if (!zalloc_cpumask_var(&supported_cpus, GFP_KERNEL_ACCOUNT))
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> [Severity: Critical]
> Does this cause stack memory corruption and a NULL pointer dereference
> when CONFIG_CPUMASK_OFFSTACK=n?
> 
> In kvm_update_supported_cpus(), supported_cpus is declared as a simple pointer
> rather than cpumask_var_t. When CONFIG_CPUMASK_OFFSTACK is disabled,
> cpumask_var_t is defined as a 1-element array. Passing &supported_cpus to
> zalloc_cpumask_var() will zero out NR_CPUS bits starting at the stack address
> of the pointer itself, overwriting the pointer and potentially adjacent
> stack variables.
> 
> The subsequent cpumask_copy() then dereferences a NULL pointer. Could we
> use cpumask_var_t for the declaration here?

This indeed look like a bug, I'll fix it, thanks for spotting it.

> 
> > +		return -ENOMEM;
> > +
> > +	cpumask_copy(supported_cpus, kvm->arch.supported_cpus);
> > +
> > +	lockdep_assert_held(&kvm->arch.config_lock);
> > +
> > +	ret = -EINVAL;
> > +	/* Cannot update for SPE and PMU at the same time. */
> > +	if (WARN_ON_ONCE(pmu_cpus && spe_cpus))
> > +		goto out;
> > +
> > +	if (pmu_cpus)
> > +		cpus = pmu_cpus;
> > +	else
> > +		cpus = spe_cpus;
> > +
> > +	if ((spe_cpus && kvm->arch.arm_pmu) ||
> > +	    (pmu_cpus && kvm_spe_pmu_set(kvm)))
> > +		cpumask_and(supported_cpus, cpus, supported_cpus);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> [Severity: Medium]
> Could this incorrectly accumulate CPU mask restrictions and reject valid
> reassignments?
> 
> If userspace configures a VM by first setting a PMU, then setting the SPE ID,
> and later changes the PMU to a different instance (which is permitted before
> the VM runs), this logic intersects the new PMU mask with the
> already-intersected kvm->arch.supported_cpus mask.
> 
> Since the current mask already includes the first PMU's restrictions, the new
> mask accumulates both PMUs' restrictions instead of replacing the old PMU's
> mask. If the two PMUs have disjoint CPU masks, the intersection becomes empty
> and the operation fails with -EINVAL. 

My mistake here, I was under the impression that you can assign a PMU *exactly*
once to a VM, but looking at the code it turns out I was wrong and you can
assign different PMUs (where each assignment overwrites the previous one), as
long as you haven't set a filter. I'll fix it in the next iteration.

This begs the question: should the same behaviour be allowed with SPE? Because
right now trying to set a different SPE PMU is rejected by KVM.

Thanks,
Alex

> 
> > +	else
> > +		cpumask_copy(supported_cpus, cpus);
> > +
> > +	if (cpumask_empty(supported_cpus))
> > +		goto out;
> > +
> > +	cpumask_copy(kvm->arch.supported_cpus, supported_cpus);
> > +	ret = 0;
> > +out:
> > +	free_cpumask_var(supported_cpus);
> > +
> > +	return ret;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=13
