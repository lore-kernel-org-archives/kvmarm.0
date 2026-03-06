Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FD3338F255
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 12:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772801565; cv=none; b=IAwZkjcwrFEI043vWkcX8wRVKGn3SdHNMkjSdQUtXjdEJaCwDhkFYBM2qgSYsRsDbXwe/vTgdoY5QoG6vnxTr98/QgBQDc6r3QUXF4Wvzup6NJCw446OA2DoFedKMA11t4ZA5bVFT8gM7i1VXdYbhDLidVndd6Whj8JLwRWqcpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772801565; c=relaxed/simple;
	bh=I5s6cYwpy8ERQx3eisWdKRv+K50LZpGHEK6uTNeq9rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZBizIOI3xvZ3m7XWODckN7WjuC/5H+zcSunv/d5wWT41PO5cUghb/kM+RZEjBsoMMjZbKNX1NfxDGPGkfyqF90pmB4e3XSkrpuQKkQzcc/it3DNVeRVx1V8/28/fMGrDmgcNqfzAmnYMZQ7XrJ6Yux4Ro4nohL4AgKpAn86TMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44E80497;
	Fri,  6 Mar 2026 04:52:37 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 367FF3F694;
	Fri,  6 Mar 2026 04:52:42 -0800 (PST)
Date: Fri, 6 Mar 2026 12:52:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 4/4] KVM: arm64: Add SMC hook for SME dvmsync erratum
Message-ID: <aarOF-2I9gr6az4W@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-5-catalin.marinas@arm.com>
 <aamUFoQV74t4okXx@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamUFoQV74t4okXx@willie-the-truck>

On Thu, Mar 05, 2026 at 02:32:54PM +0000, Will Deacon wrote:
> On Mon, Mar 02, 2026 at 04:57:57PM +0000, Catalin Marinas wrote:
> > @@ -28,6 +30,15 @@ static struct hyp_pool host_s2_pool;
> >  static DEFINE_PER_CPU(struct pkvm_hyp_vm *, __current_vm);
> >  #define current_vm (*this_cpu_ptr(&__current_vm))
> >  
> > +static void pkvm_sme_dvmsync_fw_call(void)
> > +{
> > +	if (cpus_have_final_cap(ARM64_WORKAROUND_SME_DVMSYNC)) {
> > +		struct arm_smccc_res res;
> > +
> > +		arm_smccc_1_1_smc(ARM_SMCCC_CPU_SME_DVMSYNC_WORKAROUND, &res);
> > +	}
> > +}
> > +
> >  static void guest_lock_component(struct pkvm_hyp_vm *vm)
> >  {
> >  	hyp_spin_lock(&vm->lock);
> > @@ -553,6 +564,12 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
> >  	if (ret)
> >  		return ret;
> >  
> > +	/*
> > +	 * After stage2 maintenance has happened, but before the page owner has
> > +	 * changed.
> > +	 */
> > +	pkvm_sme_dvmsync_fw_call();
> 
> Please note that this will conflict with my patch series adding support
> for protected memory with pkvm. I _think_ the right answer is to
> move this call into host_stage2_set_owner_metadata_locked().

Yes, it needs to be after host_stage2_try(), so it makes sense to move
it to host_stage2_set_owner_metadata_locked(). Let's see which order the
patches go in or we may have to fix the conflict during merge.

We can also leave the pKVM workaround for later once your rework goes
in.

-- 
Catalin
