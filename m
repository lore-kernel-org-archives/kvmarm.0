Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE623E1203;
	Mon, 29 Jun 2026 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782748484; cv=none; b=BzeOoh+DP52RfkWXvSVXjGNPSk5CHp60yMftruSk1cj9hleSOmaF5bIRQUpI/yDf3ysUkRnDEBwN2icygsr8W4KtiVR4pG528e9JYfwvwfejzzw3OJDUz6LDrTMiV7JuFT6pEilvYKizYDQyqhxfg6h1wV7odHNxV/Qd9ol75Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782748484; c=relaxed/simple;
	bh=93ATUFGStUVoH8MghwH3wgB4RX0ZFq8ZxEEq8p1K4SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=pHPR7TTyNSkKS016zmdCtdP96C7sphZhJwkOSPLXuPWnknyDo05TnXXTfSSgWlEeKsMiQgPGpNqg/iAGzDbCv6+AXB2cA8Ldx8etMASLtb0x8EPqauKTV3M/LGuQnEwlIpXqv7PAZqEZ0TdUz3k93mwdas1xvmcds4AwEZfRHEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XawM1eel; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XawM1eel"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D68E339;
	Mon, 29 Jun 2026 08:54:37 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C9753F673;
	Mon, 29 Jun 2026 08:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782748482; bh=93ATUFGStUVoH8MghwH3wgB4RX0ZFq8ZxEEq8p1K4SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XawM1eelrbIxTK4y4PyFeJJICs4xBNgq5CArZNv2H+sd/1+eK0zIBfeRscVA0R6Ru
	 WWarGTEbfltuuuTQUxufctIZdP80CCpk6ZbMvN/JWnx79sRnw+iFRi4fziwhCRZYjg
	 i6DfvSd+mwZcl8Jd7RW+UFArrU349UsbKicYZV3c=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v2 06/13] KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
Date: Mon, 29 Jun 2026 16:54:39 +0100
Message-ID: <akKVP2_vE4Wskmfk@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629112948.9F4D01F00AC4@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-7-leo.bras@arm.com> <20260629112948.9F4D01F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:29:48AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Missing Context Synchronization Event (ISB) after writes to control-plane system registers.
> - [High] TOCTOU race in wfi() polling loop causes a lost wakeup and indefinite CPU stall.
> - [High] Missing memory barrier (dsb) before starting the HACDBS hardware engine.
> - [High] Missing speculative execution barrier (dsb) after disabling an asynchronous hardware engine.
> --
> 
> commit 47f5964570817fd652e798e082c349d012b3edda
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
> 
> Introduce the basic cleaning routine that is going to be used for both
> dirty-bitmap and dirty-ring routines. It sets the required registers with
> the input buffer, and wait for HACDBSIRQ to happen, which means either
> the task is done, or there was some error during processing.
> 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > index 789da8712b1b4..e4283828b7807 100644
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> 
> [ ... ]
> 
> > @@ -24,6 +25,86 @@ DEFINE_PER_CPU(struct hacdbs, hacdbs_pcp) = {
> >  
> >  static __ro_after_init int hacdbsirq = -1;
> >  
> > +static void hacdbs_start(u64 *hw_entries, int size)
> > +{
> > +	u64 br;
> > +	/* Each entry is 8 bytes */
> > +	int size_b = size * sizeof(hw_entries[0]);
> > +	int size_p2 = max(roundup_pow_of_two(size_b), PAGE_SIZE);
> > +
> > +	/* If not using the full size of the array, put a stop entry at the end */
> > +	if (size_b < size_p2)
> > +		hw_entries[size] = HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
> > +
> > +	sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
> > +			   HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
> > +
> 
> [Severity: High]
> Does this code need an immediate isb() after writing the control-plane system
> register SYS_HACDBSCONS_EL2? The ARM64 guidelines indicate that an isb() must
> be the very next instruction after writing a control-plane system register to
> ensure the pipeline doesn't operate with architecturally undefined state.

IIUC they will have no effect until the base register says enabled. So an 
isb() at the end should be enough.

> 
> [Severity: High]
> Additionally, should there be a dsb() between the memory store to
> hw_entries[size] and the write to SYS_HACDBSBR_EL2 below? Without an explicit
> memory barrier, the store buffer might not be globally visible before the
> engine begins reading memory, which could cause it to miss the stop marker
> and access out-of-bounds memory.
> 
> > +	br = (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
> > +	     FIELD_PREP(HACDBSBR_EL2_SZ, ilog2(size_p2) - 12) |
> > +	     FIELD_PREP(HACDBSBR_EL2_EN, 1);
> > +
> > +	this_cpu_write(hacdbs_pcp.status, HACDBS_RUNNING);
> > +	this_cpu_write(hacdbs_pcp.size, size);
> > +	write_sysreg_s(br, SYS_HACDBSBR_EL2);
> > +	isb();
> > +}
> 
> [ ... ]
> 
> > +/*
> > + * Clears dirty-bits for an array of pages (hw_entries) using HACDBS
> > + * Returns the number of items cleaned from the array. If returns value < size,
> > + *	there was an error in the processing.
> > + */
> > +static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> > +{
> > +	u64 hcr_el2;
> > +	int ret;
> > +
> > +	preempt_disable();
> > +
> > +	hcr_el2 = read_sysreg(HCR_EL2);
> > +	write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
> > +	__load_stage2(&kvm->arch.mmu);
> 
> [Severity: High]
> Is an isb() required immediately after writing HCR_EL2 before proceeding to
> __load_stage2()? HCR_EL2 is a control-plane register, and delaying the barrier
> can cause the pipeline to operate with architecturally undefined state.
> 

Again, it won't operate until the enable at the end of hacdbs_start()

> > +
> > +	hacdbs_start(hw_entries, size);
> > +
> > +	do {
> > +		wfi();
> > +	} while (this_cpu_read(hacdbs_pcp.status) == HACDBS_RUNNING);
> 
> [Severity: High]
> Could this polling loop cause a lost wakeup and indefinite CPU stall? The loop
> unconditionally sleeps on the first iteration and checks the condition
> non-atomically with respect to interrupts. 
> 
> If the HACDBSIRQ interrupt is delivered and serviced just before the wfi()
> instruction executes, the wfi() will wait for a new interrupt that will never
> arrive. Should the check be made atomic with the sleep, for example by masking
> IRQs before the check?
> 

Answered before. Yes, it's unlikely, but maybe we need a WFIT.

> > +
> > +	ret = hacdbs_stop();
> > +
> > +	write_sysreg(hcr_el2, HCR_EL2);
> > +	isb();
> 
> [Severity: High]
> Should there be a speculative execution barrier (dsb) after stopping the engine
> in hacdbs_stop() and before changing the translation context here? 
> 
> The ARM64 guidelines mandate a speculative execution barrier (dsb + isb) after
> disabling an asynchronous engine to definitively halt out-of-context execution
> before updating the translation regime.


There is LITERALY a comment below addressing this.

> 
> > +
> > +	/*
> > +	 * No DSB is needed here, as kvm_flush_remote_tlbs_memslot() that happens
> > +	 * later in generic dirty-cleaning code already performs a DSB before
> > +	 * doing the TLBI.
> > +	 */
> > +
> > +	preempt_enable();
> > +
> > +	return ret;
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260629111820.1873540-1-leo.bras@arm.com?part=6
