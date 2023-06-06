Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189C6174D4
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 17:00:46 +0000 (UTC)
Date: Tue, 6 Jun 2023 17:00:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686070845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PzjLQrjDjBeulzQc97rzJ5uq4+/AmqzZhJCe+jDpdIw=;
	b=DPLylzWCRfC0dYXIBK1fY671JjxWOnTZDW+ZAvFedjJB9P/fHF+o9107jAs9KsyvkGtQXt
	/9itav9DsgvCeIRrGk7zaxCPokQ6iMHXX6yXaB4gXoLJJclrM5Fof6ExKDwGpTILhTfhH/
	Ba8iTY4WMZozchv4Ikc8dkuDpfmUdOA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Sebastian Ott <sebott@redhat.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible
 context
Message-ID: <ZH9mOXYDWnMqoL9c@linux.dev>
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
 <ZH8+ZG7DOX9TYcIY@linux.dev>
 <ZH9CvE54NSVXqjlO@google.com>
 <ZH9OQzKIfwxR3q54@linux.dev>
 <ZH9UwSueTP37NaY7@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH9UwSueTP37NaY7@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 06, 2023 at 03:46:09PM +0000, Sean Christopherson wrote:
> On Tue, Jun 06, 2023, Oliver Upton wrote:
> > On Tue, Jun 06, 2023 at 07:29:16AM -0700, Sean Christopherson wrote:
> > > On Tue, Jun 06, 2023, Oliver Upton wrote:
> > > > The call from a preemptible context is intentional, so this really
> > > > should just be raw_smp_processor_id(). Do you mind if we fix it with the
> > > > following?
> > > 
> > > ...
> > > 
> > > > Nonetheless, there's no functional requirement for disabling preemption,
> > > > as the cpu # is only used to walk the arm_pmus list. Fix it by using
> > > > raw_smp_processor_id() instead.
> > > 
> > > As a partial outsider, that needs an explanation, and the code could really use a
> > > comment.  I assume KVM's ABI is that it's userspace's responsibility to ensure that
> > > the CPU(s) used for KVM_RUN is compatible with the CPU used for KVM_ARM_VCPU_PMU_V3_CTRL,
> > > but neither the original changelog nor the above state that, nor does anything
> > > explain what happens if userspace doesn't uphold its side of things.
> > 
> > See commit 40e54cad4540 ("KVM: arm64: Document default vPMU behavior on
> > heterogeneous systems"), which documents the subtlety of vCPU scheduling
> > with the 'old' ABI at the callsite of this function. I don't want to
> > bleed any details of this crap into user documentation, since the entire
> > scheme is irretrievably broken.
> 
> I wasn't suggesting adding anything to user documentation, I was suggesting/asking
> that the changelog explain the assertion "there's no functional requirement for
> disabling preemption".

Let's continue this on Marc's reply (don't want to spread context over
multiple threads).

> Poking around more, it looks like the answer is that kvm_arch_vcpu_load() will
> mark the vCPU as being loaded on an unsupported pCPU, which will prevent running
> on the target pCPU, and thus presumably prevent creating new perf events on the
> incompatible pCPU.

That's only the case with the 'new' ABI, where userspace has explicitly
selected a PMU instance. The answer for the 'old' interface is here:

	/*
	 * No PMU set, get the default one.
	 *
	 * The observant among you will notice that the supported_cpus
	 * mask does not get updated for the default PMU even though it
	 * is quite possible the selected instance supports only a
	 * subset of cores in the system. This is intentional, and
	 * upholds the preexisting behavior on heterogeneous systems
	 * where vCPUs can be scheduled on any core but the guest
	 * counters could stop working.
	 */
	kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();


> Though following the breadcrumbs from the commit you referenced above, the set of
> "supported" CPUs at this point is all possible CPUs in the system.  So unless I'm
> missing something, testing that the current, unstable CPU is a "supported" CPU is
> unnecessary because running on an impossible CPU is, um, impossible.

Careful -- arm_pmu->supported_cpus is different from kvm->arch.supported_cpus.
The former describes a PMU instance in the system and the latter
enforces our scheduling requirements when userspace _explicitly_ sets a
PMU type, i.e. KVM_ARM_VCPU_PMU_V3_SET_PMU.

So it is probable that some of the PMUs in the arm_pmus list *do not*
support the calling CPU.

> I.e. can't you just do?

No, this would break the 'old' ABI, but if we decide to deliberately
break it I prefer your suggestion over using CPU0.

-- 
Thanks,
Oliver
