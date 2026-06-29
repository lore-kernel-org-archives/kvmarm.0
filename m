Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314A92765D7;
	Mon, 29 Jun 2026 11:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782732764; cv=none; b=T1znglYXtjcR/1USN3Db21Vwywpbu+1JTlqMiyHsOWovPA6JBajNtuXFIurSAG6Sj4v/nF8OJUAw5mnicIIe0iXguNEeP+ZqP3S5denEHDuJhLb+7O+GbLyZ8zoONvDsmRq/yizSksErzkRSyUjCD3YYBS3L1dKidNNT6soZgF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782732764; c=relaxed/simple;
	bh=m4jNVzPUsPeWel3qIxjEeWhTZ/km6W2hxeP8BNxWhw8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gj68GK7/1RBj/QHdNG3ljHXZLVmPETg4Bd+yS+qow/mnELxWpBbmVPTcINQ3CtBJ7nswqTn7sh4BmxQ6Ls0nYy8Bh8FjRRZAYZ6visaiG/BnM6W9s+AhZ5E6cViizU16dSnGEIRGo87WZRN/cN0nokJa+9MhZxl2pVo7AO9U88k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnVFsrZb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnVFsrZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9142A1F000E9;
	Mon, 29 Jun 2026 11:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782732762;
	bh=ZVA/CtX9Qzzu7HPDp27iELnPMloglYjbfSLba+FTFnc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LnVFsrZbWkqxlH7+VkbrPuPRwR/3pLjQvdZXb0AWudpR7NKVoXDNC23VjTIdSNHfm
	 BQmjN/jcelq68KFfBrGAii8bKCnLJ+u9g4aowfcM0MfpVg8EEOlSjjxBHdckivt89i
	 NqGoVNl0lKQej3Eg1S0OhkR/YZalqBI8bVqVruOhXX5UfdbInmdnbP0JSGKk+JtRip
	 /40h28ON7jAw0y0gSQmOH71gfyL92RCkTMhE9qFT3rTVT2mbuc4IEhghMOToAs0J90
	 KB5Q4SYJhjOUW36RlvpAAsLmgY+eDyesQDdae+yc8lmoe+9S4R9zhbplBo9LkHn2lF
	 EW+BQQpQORTog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/13] KVM: arm64: Detect (via ACPI) and initialize
 HACDBSIRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260629111820.1873540-6-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-6-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:32:42 +0000
Message-Id: <20260629113242.9142A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 12 potential issue=
(s) to consider:
- [Critical] The `wfi()` loop in `dirty_bit_clear()` creates a check-then-s=
leep race condition that can stall the CPU indefinitely.
- [Critical] The level-triggered `HACDBSIRQ` is not acknowledged or cleared=
 in the interrupt handler, resulting in an infinite interrupt storm.
- [High] Missing `isb()` context synchronization barrier after writing to c=
ontrol-plane system registers `HCR_EL2` and `SYS_HACDBSCONS_EL2`.
- [High] Missing memory barrier (`dmb ish`) before starting the HACDBS hard=
ware engine.
- [High] The ACPI MADT parser registers `hacdbsirq_gsi` without verifying i=
t is non-zero, risking a hijack of SGI 0.
- [High] Missing `default:` case in the error handling switch statement lea=
ves the tracking status unchanged on unexpected hardware errors, causing a =
vCPU hang.
- [High] If HACDBS IRQ initialization fails, the feature remains enabled in=
 KVM, causing a permanent host hang upon first use of dirty tracking.
- [Medium] ACPI GSI mapping is leaked if `request_percpu_irq()` fails.
- [Medium] Missing teardown of HACDBS resources if KVM subsystem initializa=
tion fails.
- [Medium] The per-cpu HACDBS status is initialized after enabling the per-=
cpu interrupt, causing a TOCTOU race.
- [Medium] Calling `smp_processor_id()` in a preemptible context triggers a=
 kernel BUG/warning.
- [Low] A variable declaration immediately follows a case label, violating =
C syntax rules and causing a build failure.
--

commit a0d2df687f2678f7a10866e285efd8319bf84cea
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Detect (via ACPI) and initialize HACDBSIRQ

Find via ACPI the Id for HACDBSIRQ, initialize it as a per-cpu IRQ and make
sure any cpu able to run virtualization has it active. Introduce a per-cpu
structure used by the HACDBSIRQ handler to keep track of entries size and
the status of HACDBS.

Link: https://github.com/tianocore/edk2/issues/12409

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 50adfff75be82..dc1a4629aaeb9 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
[ ... ]
> @@ -2481,6 +2484,8 @@ static int __init init_subsystems(void)
>  	if (err)
>  		goto out;
> =20
> +	kvm_hacdbs_init();
> +
>  	kvm_register_perf_callbacks();
> =20
>  	err =3D kvm_hyp_trace_init();

[Severity: Medium]
If a subsequent initialization step like kvm_hyp_trace_init() fails, the
code branches to the out: error path and aborts KVM initialization. Does
this path need to call a teardown function to free the per-CPU IRQ and
release the GSI allocated by kvm_hacdbs_init()?

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 32fe938d6bf70..789da8712b1b4 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
[ ... ]
> @@ -14,3 +21,93 @@
>  	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
>  #define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
>  #define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
> +
> +static __ro_after_init int hacdbsirq =3D -1;
> +
> +static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
> +{
> +	u64 cons =3D read_sysreg_s(SYS_HACDBSCONS_EL2);
> +	unsigned long err =3D FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons);
> +
> +	switch (err) {
> +	case HACDBSCONS_EL2_ERR_REASON_NOF:
> +		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> +		break;
> +	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
> +		/* When size not a power of two >=3D 4k, exit with reserved TTLW */
> +		int index =3D FIELD_GET(HACDBSCONS_EL2_INDEX, cons);

[Severity: Low]
Does this variable declaration cause a build failure? Under standard C rule=
s,
a label can only be attached to a statement, and a declaration is not a
statement.

> +
> +		if (index >=3D this_cpu_read(hacdbs_pcp.size)) {
> +			this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> +			break;
> +		}
> +		fallthrough;
> +	case HACDBSCONS_EL2_ERR_REASON_STRUCTF:
> +	case HACDBSCONS_EL2_ERR_REASON_IPAF:
> +		this_cpu_write(hacdbs_pcp.status, HACDBS_ERROR);
> +		break;

[Severity: High]
What happens if the hardware reports an undefined or reserved error reason
in HACDBSCONS_EL2_ERR_REASON?

Without a default: case, the tracking status wouldn't be updated, remaining
as HACDBS_RUNNING. Could this cause the synchronous wfi() wait loop in
dirty_bit_clear() to spin forever and lock up the host CPU?

> +	}
> +
> +	return IRQ_HANDLED;
> +}

[Severity: Critical]
Is it necessary to write back to a hardware register to acknowledge or clear
the active source of this interrupt before returning?

The ACPI MADT registers the HACDBS interrupt as ACPI_LEVEL_SENSITIVE.
Since a level-triggered interrupt remains asserted until explicitly cleared,
would returning IRQ_HANDLED without clearing the hardware signal trap the C=
PU
in an infinite loop of executing the ISR?

> +
> +void kvm_hacdbs_cpu_up(void)
> +{
> +	if (hacdbsirq < 0)
> +		return;
> +
> +	enable_percpu_irq(hacdbsirq, IRQ_TYPE_LEVEL_HIGH);
> +	this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
> +}

[Severity: Medium]
Could this sequence cause a race condition if a pending interrupt fires
immediately upon being unmasked?

If hacdbsirq_handler() executes and updates the state, and then
kvm_hacdbs_cpu_up() resumes and unconditionally overwrites the state
with HACDBS_IDLE, the handler's update would be lost. Should the status
be initialized before enabling the interrupt?

> +
> +void kvm_hacdbs_cpu_down(void)
> +{
> +	if (hacdbsirq < 0)
> +		return;
> +
> +	disable_percpu_irq(hacdbsirq);
> +	this_cpu_write(hacdbs_pcp.status, HACDBS_OFF);
> +}
> +
> +#ifdef CONFIG_ACPI
> +static int __init hacdbs_acpi_get_irq(void)
> +{
> +	struct acpi_madt_generic_interrupt *gicc;
> +	u32 gsi;
> +	int irq;
> +
> +	gicc =3D acpi_cpu_get_madt_gicc(smp_processor_id());

[Severity: Medium]
Is it safe to call smp_processor_id() here?

Since kvm_hacdbs_init() is called from init_subsystems() during a
device_initcall, preemption is enabled. Would calling smp_processor_id()
directly without disabling preemption trigger a kernel bug/warning if
CONFIG_DEBUG_PREEMPT is enabled? Should raw_smp_processor_id() or
get_cpu()/put_cpu() be used instead?

> +	if (gicc->header.length < ACPI_MADT_GICC_HACDBSIRQ)
> +		return -ENXIO;
> +
> +	gsi =3D  gicc->hacdbsirq_gsi;
> +
> +	irq =3D acpi_register_gsi(NULL, gsi, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_=
HIGH);

[Severity: High]
Does the GSI read from ACPI need to be validated before registration?

If the firmware does not support HACDBS, it might leave this field as 0.
On ARM64, GSI 0 corresponds to Software Generated Interrupt (SGI) 0, which =
is
used for Inter-Processor Interrupts (IPIs). Could registering a device
interrupt handler on GSI 0 corrupt host IPI handling and crash the system?

> +	if (irq < 0) {
> +		pr_warn("ACPI: Unable to register HACDBS interrupt: %d\n", gsi);
> +		return -ENXIO;
> +	}
> +
> +	return irq;
> +}

[Severity: Medium]
If the subsequent call to request_percpu_irq() in kvm_hacdbs_init() fails,
how is this ACPI GSI mapping cleaned up?

Since hacdbs_acpi_get_irq() only returns the mapped IRQ and discards the
original GSI, it seems impossible for the caller to properly unregister it
via acpi_unregister_gsi(), which would result in leaking the resource.

> +#else
> +#define hacdbs_acpi_get_irq() (-ENXIO)
> +#endif
> +
> +void __init kvm_hacdbs_init(void)
> +{
> +	int irq;
> +
> +	/* FEAT_HACDBS is only supported if Linux runs in EL2 (VHE) */
> +	if (!system_supports_hacdbs() || !is_kernel_in_hyp_mode())
> +		return;
> +
> +	irq =3D hacdbs_acpi_get_irq();
> +	if (irq < 0)
> +		return;
> +
> +	if (request_percpu_irq(irq, hacdbsirq_handler, "HACDBSIRQ", &hacdbs_pcp=
) < 0)
> +		return;

[Severity: High]
If request_percpu_irq() or hacdbs_acpi_get_irq() fails, the function returns
early. Is there a global flag that needs to be unset to tell KVM that HACDBS
hardware cleaning is unavailable?

If KVM later assumes hardware support is available and calls
dirty_bit_clear() unconditionally, it might set the software status to
HACDBS_RUNNING and wait in a wfi() loop. Since the IRQ is disabled or
unmapped, the handler would never fire, resulting in a host hang.


Additionally, I have a few questions regarding the implementation of
dirty_bit_clear() and hacdbs_start(), which appear to interact with the
features introduced in this patch:

[Severity: High]
In dirty_bit_clear(), is an isb() required after the write to HCR_EL2?

dirty_bit_clear() {
    ...
    write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
    __load_stage2(&kvm->arch.mmu);
    ...
}

Similarly, in hacdbs_start(), is an isb() required after writing to
SYS_HACDBSCONS_EL2?

hacdbs_start() {
    ...
    sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
                       HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);

    br =3D (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
    ...
}

The ARM64 subsystem guidelines indicate that writes to control-plane system
registers must be followed by an isb() as the very next instruction to
ensure subsequent instructions do not execute with an architecturally
undefined pipeline state.

[Severity: Critical]
Does the wfi() loop in dirty_bit_clear() contain a check-then-sleep race
condition?

dirty_bit_clear() {
    ...
    do {
        wfi();
    } while (this_cpu_read(hacdbs_pcp.status) =3D=3D HACDBS_RUNNING);
    ...
}

Although preemption is disabled, local interrupts are not disabled during t=
his
check. If the hardware interrupt fires after the condition is checked but
before the wfi() executes, the CPU could service the interrupt, update the
status to HACDBS_IDLE, return, and then execute wfi(). The CPU would then
sleep indefinitely, causing a host hard lockup.

[Severity: High]
In hacdbs_start(), is a memory barrier like `dmb ish` required before start=
ing
the hardware engine?

hacdbs_start() {
    ...
    if (size_b < size_p2)
        hw_entries[size] =3D HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
    ...
    write_sysreg_s(br, SYS_HACDBSBR_EL2);
    isb();
}

A sentinel stop entry is written to the memory buffer before writing to
SYS_HACDBSBR_EL2 to enable the engine. Since system register writes are not
inherently ordered with respect to memory stores, the hardware engine might
begin reading before the stop entry is visible in coherent memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D5
