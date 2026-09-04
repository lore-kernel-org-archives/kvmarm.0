Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5CD30EF86;
	Fri,  4 Sep 2026 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788529559; cv=none; b=B8xpDELvKYunSgyGNIXf9jjGNsSMbdgf4/07+g2kXhfMIs3NfiJZTxX4Ya0vUh9xv+H3VStZXkqkM9appI9424dofIInOlB05Ur8eyegwo8McC2KcgG2f34yytbGB1vY4kbaL3rSxl6xP3kzZKX5f5NBQQ1d6Ze7cDpOgt2oaHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788529559; c=relaxed/simple;
	bh=uBILfIAE4wAXjKxPSimgi2IVaLLcdAzi0ERSqo59Sy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/GyDHItvC2rj8xa3O4tctVXT2UuzhUqLl2JyYa/DcARkWgvHEy33i2/A1L6Z8bKbXcDcrczUAicZwtZGEXkvag5mO5woSuZLomZy2Km71NNkftIB/7CntzA8S8UUHta6RJ7W6jkIdFKUOR9kfjutM9cvt327VUmlxPwTUKP52Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mSHPHHSf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mSHPHHSf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79556152B;
	Fri,  4 Sep 2026 06:45:51 -0700 (PDT)
Received: from e140010.arm.com (unknown [10.57.70.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 78D3B3F7D8;
	Fri,  4 Sep 2026 06:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788529555; bh=uBILfIAE4wAXjKxPSimgi2IVaLLcdAzi0ERSqo59Sy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mSHPHHSfAXofkS3WNmrj1OpVV/ph9/XvcUR9HtIwLk6cThoT0KQLRDbLYIsLQVDEZ
	 fJPYKbd1sMNvwVJzLTu6lmvYT7jWwKma0XfkjK3V3/cjR1nMNPt3rLZFOCn9//k+VF
	 uRmSh02XndknZBpr6voZ4hz9N3qJIUVXQ8kz7wxc=
Date: Fri, 4 Sep 2026 14:45:49 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	linux-perf-users@vger.kernel.org, Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH v7 20/28] KVM: arm64: Allow guest SPE physical
 timestamps only if kernel allows it
Message-ID: <aprLjUt5i4FD4GHz@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-21-alexandru.elisei@arm.com>
 <20260903164858.E55DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903164858.E55DC1F000E9@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:48:58PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Inverted logic for `perf_allow_kernel()` grants physical timestamps to unprivileged users and denies them to privileged users.
> - [High] Capability check `perf_allow_kernel()` is evaluated at `KVM_RUN` time (TOCTOU) instead of VM/VCPU configuration time.
> - [Medium] Silently-on guest-visible feature (SPE physical timestamps) breaks live migration and violates subsystem guidelines.
> - [Medium] Concurrent first `KVM_RUN` invocations on multiple vCPUs cause a data race on the VM-wide `kvm_spe->guest_pmscr_el2`.
> --
> 
> commit 8640bfaf0b943972e8c97350b961b39b15830f1b
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: Allow guest SPE physical timestamps only if kernel allows it
> 
> The SPE driver allows userspace to use physical timestamps for records only
> if the kernel allows it, do the same for a virtual machine.
> 
> [ ... ]
> 
> > diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> > index 978620ad99fa5..3c32a1338cc8d 100644
> > --- a/arch/arm64/kvm/hyp/vhe/spe-sr.c
> > +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> 
> [ ... ]
> 
> > @@ -120,10 +121,10 @@ void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_con
> >  		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
> >  	}
> >  
> > -	__kvm_spe_restore_sampling_regs(vcpu->kvm, guest_ctxt);
> > +	__kvm_spe_restore_sampling_regs(kvm, guest_ctxt);
> >  
> >  	write_sysreg_el1(ctxt_sys_reg(guest_ctxt, PMSCR_EL1), SYS_PMSCR);
> > -	write_sysreg_el2(0, SYS_PMSCR);
> > +	write_sysreg_el2(kvm->arch.kvm_spe.guest_pmscr_el2, SYS_PMSCR);
> 
> [Severity: Medium]
> Can this read of kvm->arch.kvm_spe.guest_pmscr_el2 race with a concurrent
> write from another vCPU?

Yes, it can.

> 
> If multiple vCPUs are starting their first KVM_RUN, one vCPU might complete
> kvm_arch_vcpu_run_pid_change(), proceed to enter the guest, and execute
> __kvm_spe_restore_guest_state_vhe(), reading guest_pmscr_el2.
> 
> Because kvm_spe_vcpu_first_run_init() performs unlocked writes to this
> shared VM-wide variable, another vCPU could be modifying it at the same
> time. Should this use READ_ONCE() and WRITE_ONCE() to prevent LKMM
> violations and KCSAN data race splats?

See below.

> 
> >  }
> >  NOKPROBE_SYMBOL(__kvm_spe_restore_guest_state_vhe);
> >  
> > diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> > index af1e19cb8e9ae..68b751bdb384b 100644
> > --- a/arch/arm64/kvm/spe.c
> > +++ b/arch/arm64/kvm/spe.c
> 
> [ ... ]
> 
> > @@ -97,6 +99,12 @@ int kvm_spe_vcpu_first_run_init(struct kvm_vcpu *vcpu)
> >  	if (!kvm_spe->pmblimitr_el1_res0_mask)
> >  		kvm_spe_compute_pmblimitr_el1_res0_mask(kvm);
> >  
> > +	if (kvm_vm_has_ran_once(kvm))
> > +		return 0;
> > +
> > +	if (perf_allow_kernel())
> > +		kvm_spe->guest_pmscr_el2 = PMSCR_EL2_PCT_PHYS;
> 
> [Severity: High]
> Does this logic invert the intended permission check?
> 
> The perf_allow_kernel() function returns 0 on success (access granted) and
> a negative error code (like -EACCES) on failure. By evaluating to true when
> access is denied, it seems we might be granting physical timestamps to
> unprivileged users and incorrectly denying them to privileged users.

That's correct, I assumed from the name that perf_allow_kernel() simply performs
a permission check and returns true if perf is allowed to profile the kernel.

I'll be changing it to:

	if (!perf_allow_kernel())
		kvm_spe->guest_pmscr_el2 = PMSCR_EL2_PCT_PHYS;

(I remember fixing it locally, I guess I got confused about the name a second
time).

> 
> [Severity: High]
> Is kvm_spe_vcpu_first_run_init() the right place to check these
> capabilities?
> 
> Checking perf_allow_kernel() here means it is evaluated during the KVM_RUN
> ioctl, rather than during VM configuration. VMMs typically configure VMs
> with full privileges but drop privileges before executing KVM_RUN for
> sandboxing. Checking at KVM_RUN time will incorrectly deny physical
> timestamps to properly sandboxed VMMs.
> 
> Furthermore, an unprivileged process could configure a VM and pass the vCPU
> file descriptor to a privileged process, improperly gaining access to
> physical timestamps using the privileged thread's capabilities.

Sure, I can set the VM-wide PMSCR_EL2 value the first time the SPE PMU instance
is assigned. Or maybe when KVM_ARM_VCPU_INIT is first called. I'll think about
what is the best approach.

> 
> [Severity: Medium]
> Could silently enabling SPE physical timestamps based on the host kernel
> break live migration?
> 
> If a VM is migrated from a host where perf_allow_kernel() grants access to
> one where it denies it, the guest would silently downgrade to virtual
> timestamps, causing data corruption in the profiling trace.
> 
> The KVM guidelines require that new behavior the guest can observe must be
> off by default and explicitly enabled through standard capability
> negotiation (like a KVM_CAP_* or ID register flag). Should this require an
> explicit opt-in from userspace instead?

I think a better approach would be to update the documentation to let the
system administrator know that the VM configuration depends on perf being
allowed to profile the kernel, and it should be the same on the source and
destination in the case of migration.

> 
> [Severity: Medium]
> Can this write to kvm_spe->guest_pmscr_el2 happen concurrently across
> multiple vCPUs?

It can, should be fixed with the above approach.

Thanks,
Alex

> 
> The kvm_vm_has_ran_once(kvm) flag is not set until the end of
> kvm_arch_vcpu_run_pid_change(), which happens after
> kvm_spe_vcpu_first_run_init() completes. If multiple vCPUs start their
> first KVM_RUN concurrently, they will all see kvm_vm_has_ran_once(kvm) as
> false and write to this shared variable without synchronization.
> 
> > +
> >  	return 0;
> >  }
> >
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=20
