Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B30347F768;
	Fri,  4 Sep 2026 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788521758; cv=none; b=EEszDyjvXuJ/PXBF+VayBgrZrDWBMi3BmT/JPPLxIT6aPuSyFzN08qgOsRq9cx+OG164aVjO2r9R3iNawEQ4n5ubdOgYw2T6GeArIF7/0rw3x9Hn0WUPIbYx0UgAsEj7FRvB3cKvYmM7ng+qmGIP2bMXiTejJrVOUillebmj3n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788521758; c=relaxed/simple;
	bh=pVVX7wCHPnyKDDskx5BAkF5R6YRcS3QCTY4q1fSXlXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D41kP4oOuAfOrUd602F6DynU8A+7qmx+uv3FPXBn61UrJZcFcnh7g3mgsxTRsi1rxAGJQuHP3Y57gZaFeiAoskHEQyUVtKH8Nm7BC9vOkF9jvKzvNwPhy8HGkHMN/xqVgET/rGQY/9mE6Dldc4vTzKtFPa/Zu9HaQkvRORTyCRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=uYbJrDyu; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="uYbJrDyu"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCA76153B;
	Fri,  4 Sep 2026 04:35:51 -0700 (PDT)
Received: from e140010.arm.com (e140010.arm.com [10.2.213.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B09AF3F7D8;
	Fri,  4 Sep 2026 04:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788521755; bh=pVVX7wCHPnyKDDskx5BAkF5R6YRcS3QCTY4q1fSXlXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uYbJrDyuwqOsKENN9Bm4C94iVXgcC8ngtvbR64LRX+QpjdpjJhunnc4GdgdMBmnC8
	 XlkP5MXGomILIgChkihCUrYruYXcveBjAcAMb0t+1CCgjA1U+aFSX3/Q69Io9WtdE4
	 fZDy63pQadBhALJjsveBt+fVD2fDFXHhNdEJR4hI=
Date: Fri, 4 Sep 2026 12:35:52 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	linux-perf-users@vger.kernel.org, Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH v7 19/28] KVM: arm64: VHE: Context switch SPE state
Message-ID: <apqtGD4IArjJHFk8@e140010.arm.com>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-20-alexandru.elisei@arm.com>
 <20260903164313.9716A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260903164313.9716A1F000E9@smtp.kernel.org>

Hi Sashiko,

On Thu, Sep 03, 2026 at 04:43:13PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Writing to PMBSR_EL1 after enabling the SPE profiling buffer via PMBLIMITR_EL1 is CONSTRAINED UNPREDICTABLE and can corrupt hardware events.
> - [High] Host SPE sampling control registers (e.g., PMSNEVFR_EL1, PMSDSFR_EL1) can be permanently corrupted by a malicious guest.
> --
> 
> commit 32125a6226fde42baaf9001e75434e4177067f24
> Author: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> KVM: arm64: VHE: Context switch SPE state
> 
> Save and restore the SPE register state when a VCPU is run. The SPE
> resources are shared between the guest and the host (the resources are not
> partitioned) so KVM has to save the host state, change the owning
> translation regime, and then restore the guest state before entering a
> guest.
> 
> > diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> > new file mode 100644
> > index 0000000000000..978620ad99fa5
> > --- /dev/null
> > +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> > @@ -0,0 +1,209 @@
> [ ... ]
> > +static void __kvm_spe_save_sampling_regs(struct kvm *kvm, struct kvm_cpu_context *ctxt)
> > +{
> > +	/*
> > +	 * This is dependent on the VM features, and not the hardware features,
> > +	 * even for the host, because (a) guest accesses to PMSNEVFR_EL1 and
> > +	 * PMSDSFR_EL1 result in an undefined exception in the guest and (b)
> > +	 * they don't affect the guest unless the guest explicitly enables them,
> > +	 * and a well-behaved guest shouldn't enable them when the corresponding
> > +	 * feature is not advertised.
> > +	 */
> > +	if (kvm_spe_has_feat_spe_fne(kvm))
> > +		ctxt_sys_reg(ctxt, PMSNEVFR_EL1) = read_sysreg_s(SYS_PMSNEVFR_EL1);
> 
> [Severity: High]
> Does this check of the guest's advertised features (kvm_spe_has_feat_spe_fne)
> leave the host's sampling control registers vulnerable to corruption?
> 
> If the host physically supports FEAT_SPE_FNE but the KVM VM does not
> advertise it, KVM will skip saving and restoring the host's PMSNEVFR_EL1
> register. Because MDCR_EL2.TPMS = 0 is cleared on guest entry, these
> registers will not trap to EL2.
> 
> A malicious guest could execute an msr instruction to PMSNEVFR_EL1 directly,
> overwriting the hardware register. When the guest exits, KVM skips restoring
> the host's value in __kvm_spe_restore_sampling_regs(), allowing the guest's
> malicious configuration to persist in the host execution context.
> 
> Could this be checking the host's physical capabilities instead of the VM's
> advertised features when saving and restoring host state?

Yeah, that's a good point, this is a leftover from the previous iteration where
SPE support in KVM was dependant on FEAT_FGT, which would trap accesses to those
registers if FEAT_SPE_FnE and/or FEAT_SPE_FDS were not exposed to the VM.

If FEAT_FGT is implemented, nothing changes. But if that's not present, I see
two way to handle it:

1. Save/restore the registers on each VM entry/exit and let the guest access
them as it wishes. This would go against the architecture, which says that
accesses are undefined if the corresponding feature is not implemented. In
practice, this might not be a problem if all hardware that implements
FEAT_SPE_FnE and FEAT_SPE_FDS also implements FEAT_FGT.

2. Trap *all* buffer control registers with MDCR_EL2.TPMS and inject an undefined
instruction exception.

Thoughts?

> 
> [ ... ]
> > +void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
> > +{
> > +	u64 pmblimitr, pmbsr;
> > +
> > +	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
> > +	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
> > +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> > +		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
> > +		isb();
> > +		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
> > +		isb();
> > +		/* A buffer management event preserves fields in PMBSR_EL1 */
> > +		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
> 
> [Severity: High]
> Is it safe to write to PMBSR_EL1 after enabling the SPE profiling buffer via
> PMBLIMITR_EL1?

I haven't found any evidence to the contrary.

> 
> According to the ARM Architecture Reference Manual, when the profiling buffer
> is enabled, a direct write to PMBSR_EL1 is constrained unpredictable. This
> can corrupt hardware events or lead to unknown exceptions.

I haven't found anything in the Arm ARM saying that, and I don't see why writing
to PMBSR_EL1 would be a problem at all after the correct sequence for disabling
the buffer has been followed in __kvm_spe_save_host_state_vhe().

This is also how the SPE driver programs the buffer in the interrupt handler, if
there is indeed an issue the SPE driver would also have to be fixed.

Thanks,
Alex

> 
> In __kvm_spe_restore_host_state_vhe(), the PMBSR_EL1 register is correctly
> restored before PMBLIMITR_EL1. Should the guest restoration follow the same
> sequence to avoid unpredictable behavior?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=19
