Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715060;
	b=TtjsWyULgxcYAAF9zw75sOCuilJJLkyUM6RozjFjnMdcA/IKgUV9rSOrf87bi7sAVYcU
	 AT6w5bQF6G4cCtjN4VgRIJO1c2RkbTuoRR/Ra805sVPlHE8wGLw3bngE/zdczcD4jolcP
	 5A+EpIYqVxhHeu1p9CZHdJ+j6F0h8yMtAY3FvWJe7E5mUyZCbp//++7P4L2Dzhbmq3yT1
	 Qj2K6sR2e8saccpHE0u3JVtkuxcpMhwr+58b395pAp5WgrQOesG4i04QWtWczZ7GJHHdp
	 agjWjDRhzxAmmrUpdt7QbY3eXE+43cv8MPIoaUcrPkNznPqPnVUPkuRT2AT/bDiTstQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715060;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=GX0mwXmyU3vb8SV+yKZWdGSuUnqV8OVSrYUOviXvTa8=;
	b=J++zaU/MqL8vw/EybWz51YEStFLkfnIAKD22Eiu4LHM7pmauRU89ISkZNuIFWXG1WaeN
	 05toDm19IrEdhnpaEJoD6ApNllAmQtxNIyyIDZsP1SdAFATUvFw8CwMyLT9VC1lhMVEPp
	 UrQYEOC+Mmc/zdTmNGK8Z4zs8UeHFD4YSGqwgRMA7Pvh8qJ9CtCO5vikFDUXgor5QmHWy
	 3NqulpLUxZVaUCACyK3bYKpXEO6iRXkEExv0bm1+fCL+3X3OW/oleIx7TuOzTzcIlLVZ9
	 WThpth3AgCmwYSssK//2F4dIFBK49J6JuduZ0XhzNusRBMZ7M1kSI6TJmAnm3G1fFSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Piz1pmLI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77234606A32D;
	Tue,  3 Nov 2026 14:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Piz1pmLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531091F000C1;
	Tue,  3 Nov 2026 14:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793715060;
	bh=GX0mwXmyU3vb8SV+yKZWdGSuUnqV8OVSrYUOviXvTa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Piz1pmLIm0OBc6Fdnqrk7uPfDNoBx4DNdjBCARoYPGTt/TvuG3VaSFwoC+iipaaQN
	 mu6UWHauwh9pHYYQyO3UQuje2BrLpWj4EhXjFYeVzawt5vqXjhcL0M5ZD/wNwVfhfn
	 OvVhjU/nm9TxUiub/F4y2vhVw5hfFlL7z3sNcNwXs7Z9iEY61/UWYTq/RmsIfq45vS
	 tzqdor9Fn20LULck2YMn5UkKk5IwBlYtbAUL+Psto5MEmZYpDPU2NM/SPMKishhZAh
	 a6zJiCIPSJG9e3nTRcx6h8DuOYG2EiB+JEhc+xRAn5rDWJwL7tRMN7GMqvzMD5Qf+T
	 pBHRMSWzrP3FQ==
Date: Tue, 3 Nov 2026 14:10:55 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, linux-perf-users@vger.kernel.org, 
	Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH v7 19/28] KVM: arm64: VHE: Context switch SPE state
Message-ID: <aunkjDlv8i5OkW8h@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-20-alexandru.elisei@arm.com>
 <20260903164313.9716A1F000E9@smtp.kernel.org>
 <apqtGD4IArjJHFk8@e140010.arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apqtGD4IArjJHFk8@e140010.arm.com>

On Fri, Sep 04, 2026 at 12:35:52PM +0100, Alexandru Elisei wrote:
> Hi Sashiko,
>
> On Thu, Sep 03, 2026 at 04:43:13PM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > - [High] Writing to PMBSR_EL1 after enabling the SPE profiling buffer via PMBLIMITR_EL1 is CONSTRAINED UNPREDICTABLE and can corrupt hardware events.
> > - [High] Host SPE sampling control registers (e.g., PMSNEVFR_EL1, PMSDSFR_EL1) can be permanently corrupted by a malicious guest.
> > --
> >
> > commit 32125a6226fde42baaf9001e75434e4177067f24
> > Author: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > KVM: arm64: VHE: Context switch SPE state
> >
> > Save and restore the SPE register state when a VCPU is run. The SPE
> > resources are shared between the guest and the host (the resources are not
> > partitioned) so KVM has to save the host state, change the owning
> > translation regime, and then restore the guest state before entering a
> > guest.
> >
> > > diff --git a/arch/arm64/kvm/hyp/vhe/spe-sr.c b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> > > new file mode 100644
> > > index 0000000000000..978620ad99fa5
> > > --- /dev/null
> > > +++ b/arch/arm64/kvm/hyp/vhe/spe-sr.c
> > > @@ -0,0 +1,209 @@
> > [ ... ]
> > > +static void __kvm_spe_save_sampling_regs(struct kvm *kvm, struct kvm_cpu_context *ctxt)
> > > +{
> > > +	/*
> > > +	 * This is dependent on the VM features, and not the hardware features,
> > > +	 * even for the host, because (a) guest accesses to PMSNEVFR_EL1 and
> > > +	 * PMSDSFR_EL1 result in an undefined exception in the guest and (b)
> > > +	 * they don't affect the guest unless the guest explicitly enables them,
> > > +	 * and a well-behaved guest shouldn't enable them when the corresponding
> > > +	 * feature is not advertised.
> > > +	 */
> > > +	if (kvm_spe_has_feat_spe_fne(kvm))
> > > +		ctxt_sys_reg(ctxt, PMSNEVFR_EL1) = read_sysreg_s(SYS_PMSNEVFR_EL1);
> >
> > [Severity: High]
> > Does this check of the guest's advertised features (kvm_spe_has_feat_spe_fne)
> > leave the host's sampling control registers vulnerable to corruption?
> >
> > If the host physically supports FEAT_SPE_FNE but the KVM VM does not
> > advertise it, KVM will skip saving and restoring the host's PMSNEVFR_EL1
> > register. Because MDCR_EL2.TPMS = 0 is cleared on guest entry, these
> > registers will not trap to EL2.
> >
> > A malicious guest could execute an msr instruction to PMSNEVFR_EL1 directly,
> > overwriting the hardware register. When the guest exits, KVM skips restoring
> > the host's value in __kvm_spe_restore_sampling_regs(), allowing the guest's
> > malicious configuration to persist in the host execution context.
> >
> > Could this be checking the host's physical capabilities instead of the VM's
> > advertised features when saving and restoring host state?
>
> Yeah, that's a good point, this is a leftover from the previous iteration where
> SPE support in KVM was dependant on FEAT_FGT, which would trap accesses to those
> registers if FEAT_SPE_FnE and/or FEAT_SPE_FDS were not exposed to the VM.
>
> If FEAT_FGT is implemented, nothing changes. But if that's not present, I see
> two way to handle it:
>
> 1. Save/restore the registers on each VM entry/exit and let the guest access
> them as it wishes. This would go against the architecture, which says that
> accesses are undefined if the corresponding feature is not implemented. In
> practice, this might not be a problem if all hardware that implements
> FEAT_SPE_FnE and FEAT_SPE_FDS also implements FEAT_FGT.

I think this is the best solution, it also means you can drop the comment :)

I don't think it would go against the architecture though, because:

1. I see in [0] that FEAT_SPE_FnE (as exposed in PMSIDR_EL1.FnE) is mandatory for
   ARMv8.7+ if FEAT_SPE is implemented:

"From Armv8.7, if FEAT_SPE is implemented, the value 0 is not permitted."

2. And in [1] that FEAT_FGT is mandatory for ARMv8.6+ if EL2 is implemented:

"In an Armv8.6 implementation, if FEAT_AA64EL2 or FEAT_AA64EL3 is implemented,
FEAT_FGT is implemented."

3. And finally I see in [0] that PMSIDR_EL1.FDS relies on FEAT_SPEv1p4
   (ARMv8.9):

"FDS, bit [7]
When FEAT_SPEv1p4 is implemented:"

Or in shorthand:

1. FnE: >=v8.7
2. FGT: >=v8.6
3. FDS: >=v8.9

So either FnE or FDS already guarantees you FGT (the VHE implementation requires
EL2 anyway).

To be clear - I'd simplify everything by replacing the VM-level check here with
an explicit check on PMSIDR_EL1. I will share suggested code in the review of
the actual patch to make that more concrete!


[0]:https://support.arm.com/documentation/ddi0601/2026-09/AArch64-Registers/PMSIDR-EL1--Sampling-Profiling-ID-Register?lang=en
[1]:https://support.arm.com/documentation/ddi0487/md/-Part-A-Arm-Architecture-Introduction-and-Overview/-Chapter-A2-A-profile-Architecture-Extensions/-A2-2-Armv8-A-architecture-extensions/-A2-2-7-The-Armv8-6-architecture-extension?lang=en

>
> 2. Trap *all* buffer control registers with MDCR_EL2.TPMS and inject an undefined
> instruction exception.
>
> Thoughts?
>
> >
> > [ ... ]
> > > +void __kvm_spe_restore_guest_state_vhe(struct kvm_vcpu *vcpu, struct kvm_cpu_context *guest_ctxt)
> > > +{
> > > +	u64 pmblimitr, pmbsr;
> > > +
> > > +	pmbsr = ctxt_sys_reg(guest_ctxt, PMBSR_EL1);
> > > +	pmblimitr = ctxt_sys_reg(guest_ctxt, PMBLIMITR_EL1);
> > > +	if (__kvm_spe_profiling_buffer_enabled(pmblimitr, pmbsr)) {
> > > +		write_sysreg_s(ctxt_sys_reg(guest_ctxt, PMBPTR_EL1), SYS_PMBPTR_EL1);
> > > +		isb();
> > > +		write_sysreg_s(pmblimitr, SYS_PMBLIMITR_EL1);
> > > +		isb();
> > > +		/* A buffer management event preserves fields in PMBSR_EL1 */
> > > +		write_sysreg_s(pmbsr, SYS_PMBSR_EL1);
> >
> > [Severity: High]
> > Is it safe to write to PMBSR_EL1 after enabling the SPE profiling buffer via
> > PMBLIMITR_EL1?
>
> I haven't found any evidence to the contrary.
>
> >
> > According to the ARM Architecture Reference Manual, when the profiling buffer
> > is enabled, a direct write to PMBSR_EL1 is constrained unpredictable. This
> > can corrupt hardware events or lead to unknown exceptions.
>
> I haven't found anything in the Arm ARM saying that, and I don't see why writing
> to PMBSR_EL1 would be a problem at all after the correct sequence for disabling
> the buffer has been followed in __kvm_spe_save_host_state_vhe().
>
> This is also how the SPE driver programs the buffer in the interrupt handler, if
> there is indeed an issue the SPE driver would also have to be fixed.

Agreed, I think this one is a non-issue.

>
> Thanks,
> Alex
>
> >
> > In __kvm_spe_restore_host_state_vhe(), the PMBSR_EL1 register is correctly
> > restored before PMBLIMITR_EL1. Should the guest restoration follow the same
> > sequence to avoid unpredictable behavior?
> >
> > --
> > Sashiko AI review · https://sashiko.dev/#/patchset/20260903160623.315525-1-alexandru.elisei@arm.com?part=19
>

--
Cheers, Lorenzo
