Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5ACF3B6BE4;
	Mon, 29 Jun 2026 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747814; cv=none; b=Nayejsv2V/Xqym7KiwbDVqfQfGeIUv5+h+/RG2AioVDpM9cCMEX5WJjsCtMrrsaL8xSnvQbajujv3CrT4pwhnGambwqnfW0mASodz7NwFOWM1oXUJ3UKbpBu0MHEpOOrkdOdWKuiDP/lvpZl6VtOPkUfQZLIH3ne0B82Eb3c2R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747814; c=relaxed/simple;
	bh=6GolJiylRxOcj7cu03lGLgzPugnpFr9jX5w3dGIkXJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=ixiByHBu6H65+bh9V5HKrynoygOJmRuvQ6K6UHtB0stG2uICoHnas3ownnrUVPopFytaStKQ1WVZjNFnYpfwm/PSngqHsQd1KjjVSJGRP++BPCTkW8yyYHHzq+NAveOUbaK3Rarkbz7Fnsyo/59pmy8QiJgsLT3ITAjMAaKjnYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cQ5gC3VB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cQ5gC3VB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A959F26AC;
	Mon, 29 Jun 2026 08:43:27 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 304523F673;
	Mon, 29 Jun 2026 08:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782747812; bh=6GolJiylRxOcj7cu03lGLgzPugnpFr9jX5w3dGIkXJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQ5gC3VBrP6bMo5KEqoQSaxAE/JbbgBYAzpG5y0VLGvzbsaeqhKpaJ/RmD0xk4Ky4
	 1PaZGcGFP8MmWu1dlGNabmQABqS1vBqSuco//sJqZYWS0ShViKuxkEIj7B9dUTT+4g
	 BvUOnyfqkOFwkvxqHAIJwYtq91KaiIVTkc21eoMg=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/13] KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ
Date: Mon, 29 Jun 2026 16:43:29 +0100
Message-ID: <akKSoZkYWDTE07hi@LeoBrasDK>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629113242.9142A1F000E9@smtp.kernel.org>
References: <20260629111820.1873540-1-leo.bras@arm.com> <20260629111820.1873540-6-leo.bras@arm.com> <20260629113242.9142A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jun 29, 2026 at 11:32:42AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 12 potential issue(s) to consider:
> - [Critical] The `wfi()` loop in `dirty_bit_clear()` creates a check-then-sleep race condition that can stall the CPU indefinitely.
> - [Critical] The level-triggered `HACDBSIRQ` is not acknowledged or cleared in the interrupt handler, resulting in an infinite interrupt storm.
> - [High] Missing `isb()` context synchronization barrier after writing to control-plane system registers `HCR_EL2` and `SYS_HACDBSCONS_EL2`.
> - [High] Missing memory barrier (`dmb ish`) before starting the HACDBS hardware engine.
> - [High] The ACPI MADT parser registers `hacdbsirq_gsi` without verifying it is non-zero, risking a hijack of SGI 0.
> - [High] Missing `default:` case in the error handling switch statement leaves the tracking status unchanged on unexpected hardware errors, causing a vCPU hang.
> - [High] If HACDBS IRQ initialization fails, the feature remains enabled in KVM, causing a permanent host hang upon first use of dirty tracking.
> - [Medium] ACPI GSI mapping is leaked if `request_percpu_irq()` fails.
> - [Medium] Missing teardown of HACDBS resources if KVM subsystem initialization fails.
> - [Medium] The per-cpu HACDBS status is initialized after enabling the per-cpu interrupt, causing a TOCTOU race.
> - [Medium] Calling `smp_processor_id()` in a preemptible context triggers a kernel BUG/warning.
> - [Low] A variable declaration immediately follows a case label, violating C syntax rules and causing a build failure.
> --
> 
> commit a0d2df687f2678f7a10866e285efd8319bf84cea
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ
> 
> Find via ACPI the Id for HACDBSIRQ, initialize it as a per-cpu IRQ and make
> sure any cpu able to run virtualization has it active. Introduce a per-cpu
> structure used by the HACDBSIRQ handler to keep track of entries size and
> the status of HACDBS.
> 
> Link: https://github.com/tianocore/edk2/issues/12409
> 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 50adfff75be82..dc1a4629aaeb9 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> [ ... ]
> > @@ -2481,6 +2484,8 @@ static int __init init_subsystems(void)
> >  	if (err)
> >  		goto out;
> >  
> > +	kvm_hacdbs_init();
> > +
> >  	kvm_register_perf_callbacks();
> >  
> >  	err = kvm_hyp_trace_init();
> 
> [Severity: Medium]
> If a subsequent initialization step like kvm_hyp_trace_init() fails, the
> code branches to the out: error path and aborts KVM initialization. Does
> this path need to call a teardown function to free the per-CPU IRQ and
> release the GSI allocated by kvm_hacdbs_init()?
> 

Maybe. Another solution would be to put it after anything that may present 
any error. I wonder how ofter do we get kvm to fail startup, though.

> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > index 32fe938d6bf70..789da8712b1b4 100644
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> [ ... ]
> > @@ -14,3 +21,93 @@
> >  	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> >  #define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
> >  #define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
> > +
> > +static __ro_after_init int hacdbsirq = -1;
> > +
> > +static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
> > +{
> > +	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
> > +	unsigned long err = FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons);
> > +
> > +	switch (err) {
> > +	case HACDBSCONS_EL2_ERR_REASON_NOF:
> > +		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> > +		break;
> > +	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
> > +		/* When size not a power of two >= 4k, exit with reserved TTLW */
> > +		int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
> 
> [Severity: Low]
> Does this variable declaration cause a build failure?

No

> Under standard C rules,
> a label can only be attached to a statement, and a declaration is not a
> statement.

That's not a label.

> 
> > +
> > +		if (index >= this_cpu_read(hacdbs_pcp.size)) {
> > +			this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> > +			break;
> > +		}
> > +		fallthrough;
> > +	case HACDBSCONS_EL2_ERR_REASON_STRUCTF:
> > +	case HACDBSCONS_EL2_ERR_REASON_IPAF:
> > +		this_cpu_write(hacdbs_pcp.status, HACDBS_ERROR);
> > +		break;
> 
> [Severity: High]
> What happens if the hardware reports an undefined or reserved error reason
> in HACDBSCONS_EL2_ERR_REASON?
> 
> Without a default: case, the tracking status wouldn't be updated, remaining
> as HACDBS_RUNNING. Could this cause the synchronous wfi() wait loop in
> dirty_bit_clear() to spin forever and lock up the host CPU?

I get the error code by reading a 2-bit bitfield. There can only be 4 
different combinations here, and all are dealt with. 

> 
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> [Severity: Critical]
> Is it necessary to write back to a hardware register to acknowledge or clear
> the active source of this interrupt before returning?
> 
> The ACPI MADT registers the HACDBS interrupt as ACPI_LEVEL_SENSITIVE.
> Since a level-triggered interrupt remains asserted until explicitly cleared,
> would returning IRQ_HANDLED without clearing the hardware signal trap the CPU
> in an infinite loop of executing the ISR?
> 

I am pretty sure this is done by generic code.

> > +
> > +void kvm_hacdbs_cpu_up(void)
> > +{
> > +	if (hacdbsirq < 0)
> > +		return;
> > +
> > +	enable_percpu_irq(hacdbsirq, IRQ_TYPE_LEVEL_HIGH);
> > +	this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> > +}
> 
> [Severity: Medium]
> Could this sequence cause a race condition if a pending interrupt fires
> immediately upon being unmasked?
> 
> If hacdbsirq_handler() executes and updates the state, and then
> kvm_hacdbs_cpu_up() resumes and unconditionally overwrites the state
> with HACDBS_IDLE, the handler's update would be lost. Should the status
> be initialized before enabling the interrupt?

This is a per-cpu irq, and above happens when we are enabling 
virtualization on a CPU. Prior to the endo of kvm_hacdbs_cpu_up() there 
should be no guest running in this cpu, so faulting is not an issue. 

> 
> > +
> > +void kvm_hacdbs_cpu_down(void)
> > +{
> > +	if (hacdbsirq < 0)
> > +		return;
> > +
> > +	disable_percpu_irq(hacdbsirq);
> > +	this_cpu_write(hacdbs_pcp.status, HACDBS_OFF);
> > +}
> > +
> > +#ifdef CONFIG_ACPI
> > +static int __init hacdbs_acpi_get_irq(void)
> > +{
> > +	struct acpi_madt_generic_interrupt *gicc;
> > +	u32 gsi;
> > +	int irq;
> > +
> > +	gicc = acpi_cpu_get_madt_gicc(smp_processor_id());
> 
> [Severity: Medium]
> Is it safe to call smp_processor_id() here?
> 
> Since kvm_hacdbs_init() is called from init_subsystems() during a
> device_initcall, preemption is enabled. Would calling smp_processor_id()
> directly without disabling preemption trigger a kernel bug/warning if
> CONFIG_DEBUG_PREEMPT is enabled? Should raw_smp_processor_id() or
> get_cpu()/put_cpu() be used instead?

This is called in init time, by kvm_arm_init(). Also, it should not matter 
as we are not actually touching anything from that cpu, but instead just 
fetching this read-only information about the IRQ.


> 
> > +	if (gicc->header.length < ACPI_MADT_GICC_HACDBSIRQ)
> > +		return -ENXIO;
> > +
> > +	gsi =  gicc->hacdbsirq_gsi;
> > +
> > +	irq = acpi_register_gsi(NULL, gsi, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_HIGH);
> 
> [Severity: High]
> Does the GSI read from ACPI need to be validated before registration?
> 
> If the firmware does not support HACDBS, it might leave this field as 0.
> On ARM64, GSI 0 corresponds to Software Generated Interrupt (SGI) 0, which is
> used for Inter-Processor Interrupts (IPIs). Could registering a device
> interrupt handler on GSI 0 corrupt host IPI handling and crash the system?
> 

Adding a test here could be easy.
In any case I remember testing with the table entry being zero and this 
not being an issue.

> > +	if (irq < 0) {
> > +		pr_warn("ACPI: Unable to register HACDBS interrupt: %d\n", gsi);
> > +		return -ENXIO;
> > +	}
> > +
> > +	return irq;
> > +}
> 
> [Severity: Medium]
> If the subsequent call to request_percpu_irq() in kvm_hacdbs_init() fails,
> how is this ACPI GSI mapping cleaned up?
> 
> Since hacdbs_acpi_get_irq() only returns the mapped IRQ and discards the
> original GSI, it seems impossible for the caller to properly unregister it
> via acpi_unregister_gsi(), which would result in leaking the resource.
> 

This feature should only be enabled if the whole system supports HACDBS, so 
once one cpu succeeds in request_percpu_irq() every other one should 
succeed as well.

> > +#else
> > +#define hacdbs_acpi_get_irq() (-ENXIO)
> > +#endif
> > +
> > +void __init kvm_hacdbs_init(void)
> > +{
> > +	int irq;
> > +
> > +	/* FEAT_HACDBS is only supported if Linux runs in EL2 (VHE) */
> > +	if (!system_supports_hacdbs() || !is_kernel_in_hyp_mode())
> > +		return;
> > +
> > +	irq = hacdbs_acpi_get_irq();
> > +	if (irq < 0)
> > +		return;
> > +
> > +	if (request_percpu_irq(irq, hacdbsirq_handler, "HACDBSIRQ", &hacdbs_pcp) < 0)
> > +		return;
> 
> [Severity: High]
> If request_percpu_irq() or hacdbs_acpi_get_irq() fails, the function returns
> early. Is there a global flag that needs to be unset to tell KVM that HACDBS
> hardware cleaning is unavailable?

The availability is tracked by hacdbsirq variable. Once it's set, it means 
the whole system supports hacdbs, and the IRQ is available.


> 
> If KVM later assumes hardware support is available and calls
> dirty_bit_clear() unconditionally, it might set the software status to
> HACDBS_RUNNING and wait in a wfi() loop. Since the IRQ is disabled or
> unmapped, the handler would never fire, resulting in a host hang.
>
> 
> Additionally, I have a few questions regarding the implementation of
> dirty_bit_clear() and hacdbs_start(), which appear to interact with the
> features introduced in this patch:
> 
> [Severity: High]
> In dirty_bit_clear(), is an isb() required after the write to HCR_EL2?
>

No, and __load_stage2 will do that anyway if needed, as it also sets 
registers. Also, it's done at the end of hacdbs_start()
 
> dirty_bit_clear() {
>     ...
>     write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
>     __load_stage2(&kvm->arch.mmu);
>     ...
> }
> 
> Similarly, in hacdbs_start(), is an isb() required after writing to
> SYS_HACDBSCONS_EL2?
> 

it's done at the end of hacdbs_start.

> hacdbs_start() {
>     ...
>     sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
>                        HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
> 
>     br = (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
>     ...
> }
> 
> The ARM64 subsystem guidelines indicate that writes to control-plane system
> registers must be followed by an isb() as the very next instruction to
> ensure subsequent instructions do not execute with an architecturally
> undefined pipeline state.
> 

Those intructions are unrelated between themselves, the one at the end of 
hacdbs_start() should be enough.

> [Severity: Critical]
> Does the wfi() loop in dirty_bit_clear() contain a check-then-sleep race
> condition?
> 
> dirty_bit_clear() {
>     ...
>     do {
>         wfi();
>     } while (this_cpu_read(hacdbs_pcp.status) == HACDBS_RUNNING);
>     ...
> }
> 
> Although preemption is disabled, local interrupts are not disabled during this
> check. If the hardware interrupt fires after the condition is checked but
> before the wfi() executes, the CPU could service the interrupt, update the
> status to HACDBS_IDLE, return, and then execute wfi(). The CPU would then
> sleep indefinitely, causing a host hard lockup.

Until the next interrupt, though. Very unlikely, but possible.

Maybe a WFIT (timeout), then?

> 
> [Severity: High]
> In hacdbs_start(), is a memory barrier like `dmb ish` required before starting
> the hardware engine?
> 
> hacdbs_start() {
>     ...
>     if (size_b < size_p2)
>         hw_entries[size] = HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
>     ...
>     write_sysreg_s(br, SYS_HACDBSBR_EL2);
>     isb();
> }
> 
> A sentinel stop entry is written to the memory buffer before writing to
> SYS_HACDBSBR_EL2 to enable the engine. Since system register writes are not
> inherently ordered with respect to memory stores, the hardware engine might
> begin reading before the stop entry is visible in coherent memory.
> 

And that could mean possibly running though entries that are not supposed 
to be valid, but could be because we are talking about random data.
So we need to make sure the write buffer is clear before setting the 
register.

Thanks
Leo


