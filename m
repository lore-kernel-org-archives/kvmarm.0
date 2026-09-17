Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B433D4A483B;
	Thu, 17 Sep 2026 10:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789641420; cv=none; b=d8pvwUJIJfwRhrODSEDKtNw3+7gxKr7vAKS5Aqt1nYyAopZbfoaJIx2Zk4ZyPI+ALCs0NlV+l+PHKQj9It9ZkTVyeFADS9SLMkw+OcHNZNe4z43tVixbXslMUbWZ9RhA1Xms5/2wi2rKacP9N0TFIoSO8qGo16VnEVqD/lFPtEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789641420; c=relaxed/simple;
	bh=HFJCSpH6FLoOTK/OMrzkNYKid6wglsq3WkOL5d44zXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CzKiIKcyDv0UJlZ1hQE1fXBPFWMdOYCKl+egeeR6xDCIxB4ZEH4Mk6nhzGi9TmtUKp7oPK8wCxG/JcxtHE1LwmILIxcX0CZOQMHvGJIqrPnO6Ypxjy5hXqiDqhDEuKnyU97LTNb4rdKOt3ixVoTjPrstLxkiu1QtXLfSX09zldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=K6ceyb1d; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="K6ceyb1d"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1947C1476;
	Thu, 17 Sep 2026 03:36:50 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F8EB3FAA1;
	Thu, 17 Sep 2026 03:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789641413; bh=HFJCSpH6FLoOTK/OMrzkNYKid6wglsq3WkOL5d44zXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6ceyb1dKbKDTE5CusZ/Ez78cvFyWYSRzt51rGQj21EJGMTXwtEoWVwN+MKWmPxAa
	 +i6+l/BOQYpzJKhugeyBhipf5dPVdu+voBzZNIuWyAf6B9teCVjp56PmIpVl/d0D1x
	 WU7VtqOhSd0OYneIlsRPF1fDHFjVDDdly5Kq3OU4=
Date: Thu, 17 Sep 2026 11:36:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
	will@kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
	aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
Subject: Re: [PATCH v18] arm64: mm: Handle Granule Protection Faults (GPFs)
Message-ID: <aqvCwM_73qMpqzvV@arm.com>
References: <20260913070459.2547407-1-suzuki.poulose@arm.com>
 <aqrGPK0lFBFXL2qY@arm.com>
 <985520fa-99b0-4620-bfee-8e6321b36104@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <985520fa-99b0-4620-bfee-8e6321b36104@arm.com>

Hi Suzuki,

On Thu, Sep 17, 2026 at 10:03:14AM +0100, Suzuki K Poulose wrote:
> On 16/09/2026 17:39, Catalin Marinas wrote:
> > On Sun, Sep 13, 2026 at 08:04:58AM +0100, Suzuki K Poulose wrote:
> > > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > > index 75c3e463df2ef..dc3a87902a60c 100644
> > > --- a/arch/arm64/mm/fault.c
> > > +++ b/arch/arm64/mm/fault.c
> > > @@ -914,6 +914,24 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
> > >   	return 0;
> > >   }
> > > +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > > +{
> > > +	const struct fault_info *inf = esr_to_fault_info(esr);
> > > +	unsigned long addr = untagged_addr(far);
> > > +
> > > +	die_kernel_fault(inf->name, addr, esr, regs);
> > > +	return 0;
> > > +}
> > > +
> > > +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> > > +{
> > > +	if (!user_mode(regs) && !is_el1_instruction_abort(esr) &&
> > > +	    fixup_exception(regs, esr))
> > > +		return 0;
> > > +
> > > +	return 1;
> > > +}
> > 
> > We discussed briefly offline. With the latest patches around, would we
> > ever end up with private memory mapped in the VMM and hence the GPF? If
> > not, I would still keep this handling but add a
> > WARN_ON_ONCE(user_mode(regs)).
> > 
> > However, can we end up delegating a non-guest_memfd memslot page as
> > protected?
> > 
> > I played a bit with codex and it reckons it's possible if a guest_memfd
> > memslot is deleted after its IPA range has been initialised with
> > RIPAS=RAM. Removing the memslot unmaps and undelegates any data pages
> > but leaves the RMM state as RAM. The VMM can then install an ordinary
> > memslot over the same GPA range.
> 
> This should be prevented by the following predicates:
> 
> 1) Realms only support guest_memfd backed memslots for mappable memory.
> 2) Memslots cannot be created after the Realm is created, as is with the
> protected VMs. (This check seems to have been lost over the iterations,
>  but should be reinstated).

If that's the intended model, I think it should work. But v18 doesn't
enforce either of them. I noticed the second predicate for pKVM only -
your 'Widen the scope of "protected" VMs' patch makes this restriction
explicit to pKVM.

For the first one, if !kvm_slot_has_gmem(), it simply continues with the
registration.

> > A subsequent private-IPA S2 fault sees the non-guest_memfd slot, takes
> > user_mem_abort(), GUPs the user page and passes it to
> > realm_map_protected(). The userspace mapping remains present, so a later
> > EL0 access can generate a GPF.
> 
> The Realm mem abort code should prevent this by ensuring that the
> memslot is backed by gmem for private_faults. With the mandate of
> in-place conversion, even the shared pages must come from the
> gmem backed memslots.

IIUC this only works if the memslot is gmem but I can't see what
prevents ordinary slots from being assigned to realms. I think we can
enter the user_mem_abort() -> realm_map_ipa() for ordinary slots unless
we prevent the deletion of the original slots and enforce gmem only
slots early.

-- 
Catalin
