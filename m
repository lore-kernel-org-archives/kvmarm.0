Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC31138AC78
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122152; cv=none; b=luGxD1d+V4O/Lo9we2mA2ad/Sgvx+SW07XORDI4UmgN4qwWfN/03/By6Ha+YTJovoL1uMiUkLBhkapPwq16C81NRqz67iD56/uP9+YyM2UvWaujfC6EfZBCo4LHoOzB7raZ4VAmZJqpol8v+QjiANrcGamJRwJNXDqY1oXV6cuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122152; c=relaxed/simple;
	bh=kin48Y6Qqn6rNMOsXf3YDwnwBNqpEZA8dQVGJj4oLyA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o/x/jpoPzcOpUxzy3QkIuEQ9UmlIZaVq0Vi4kNIGjGZ0ScCurBbYcsG9ovMxpTrmIknH6xLaJBxJ4HsP+YfV2zvMMZWxK3J5TkK5tuQ/te0MK1DRRsVpSEIRBuMj+AG79Rz90p2TpwjK2ZR8C/Sj3KIKheoSuiJhB+lP19F2PvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UkIHDxF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UkIHDxF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D301F000E9;
	Fri,  7 Aug 2026 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122150;
	bh=+T4wNgU1/OtEF3aFdo9z5GtoaIdGyIX+3NgZlMD4HZo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UkIHDxF+13wowE/vpFDxLFkRtfYuqwpjRi6+FKAVao+TtZh8pL7gm/bfxcDRig3/+
	 ypbVECFBhmOizP1i9dXP5yyI3rLrHZCk56nQFssUwusEMshHleDBdaez+6X1NWvtVf
	 9xWzo9pj30RGzbjuNPGhdgFy1JT8KeEzcCKZliWWZmotguEbgpE+UgHCa3TNMpsdyV
	 tpKVtnqWuBD5NlUYIlK5gIyr5KqwSzLYsp0yY6EOskZJZ0s9ww7epaR8GSUAh5H7yq
	 rBbTO6gqUBw5546shpFJmG1UBnjDyLtPMdcwI83zgzHIt3ftVCFPzijBvYQbMXgTtD
	 F4DzHLZlRPxNw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/13] KVM: arm64: Restrict host updates to GITS_CTLR
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807164322.2970811-12-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-12-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:02:29 +0000
Message-Id: <20260807170230.23D301F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [Critical] Missing interception of GITS_CBASER and GITS_BASER<n> allows t=
he host to bypass ITS emulation and execute unvalidated commands.
- [High] Concurrent modification of the host's `snapshot_table` during ITS =
command rollback leads to arbitrary memory donation attempts.
- [High] Widespread use of `WARN_ON` for host-reachable error conditions in=
 ITS emulation panics the hypervisor.
- [High] Incorrect sub-word MMIO handling in `ctlr_write` and `ctlr_read` l=
eads to register corruption.
- [Medium] 64-bit accesses to GITS_CTLR are incorrectly dropped, causing re=
ads to return uninitialized memory and writes to be silently ignored.
- [Medium] The handler fails to mask reserved (RES0) bits from the host-pro=
vided `value` before writing to the physical `GITS_CTLR` register.
--

--- Patch [10]: [PATCH v2 10/13] KVM: arm64: Restrict host updates to GITS_=
CTLR ---
commit 8547f0737e8d44ccf52c0d09c7367b0079543481
Author: Sebastian Ene <sebastianene@google.com>

    KVM: arm64: Restrict host updates to GITS_CTLR
   =20
    Prevent unpredictable hardware behavior when the host tries to enable
    the ITS while it is not in quiescent state.

This commit adds emulation for the GITS_CTLR register to restrict the host
from enabling the ITS while it is not in a quiescent state. It adds
ctlr_read and ctlr_write handlers and registers them in the its_handlers
array.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> index 5629e2a070df5..b9b71aa18d48b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -403,8 +403,35 @@ static void cwriter_read(struct pkvm_protected_reg *=
region, u64 offset, u64 *rea
>  	*read =3D readq_relaxed(its->base + GITS_CWRITER);
>  }
> =20
> +static void ctlr_read(struct pkvm_protected_reg *region, u64 offset, u64=
 *read)
> +{
> +	struct its_priv_state *its =3D region->priv;
> +	*read =3D readl_relaxed(its->base + GITS_CTLR);
> +}

[Severity: High]
Does this read handler account for the access offset? When the host performs
a partial sub-word read at a non-zero offset, it appears we return the full
32-bit register value instead of the requested bytes.

> +
> +static void ctlr_write(struct pkvm_protected_reg *region, u64 offset, u6=
4 value)
> +{
> +	struct its_priv_state *its =3D region->priv;
> +	bool is_quiescent, is_enabled;
> +	u32 ctlr;
> +
> +	ctlr =3D readl_relaxed(its->base + GITS_CTLR);
> +	is_quiescent =3D !!(ctlr & GITS_CTLR_QUIESCENT);
> +	is_enabled =3D !!(ctlr & GITS_CTLR_ENABLE);
> +
> +	/*
> +	 * If it's disabled and not in quiescent state and it tries to enable
> +	 * it, bail out.
> +	 */
> +	if (!is_enabled && (value & GITS_CTLR_ENABLE) && !is_quiescent)
> +		return;
> +
> +	writel_relaxed(value, its->base + GITS_CTLR);

[Severity: High]
Can a sub-word write corrupt the register state here? If the host performs a
partial 8-bit or 16-bit write at a non-zero offset, this writes the provided
value directly to offset 0 as a 32-bit word, which would zero-extend the va=
lue
and wipe out other bits in GITS_CTLR.

[Severity: Medium]
Should we mask out reserved (RES0) bits from the host-provided value before
writing it? The host could write non-zero values to RES0 bits, which the
architecture states can lead to unpredictable hardware behavior.

> +}
> +
>  static struct its_handler its_handlers[] =3D {
>  	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
> +	ITS_HANDLER(GITS_CTLR, sizeof(u32), ctlr_write, ctlr_read),
>  	{},
>  };

[Severity: Critical]
Does this registry need to intercept GITS_CBASER and GITS_BASER<n>? Because
they are omitted, writes to these registers fall through and are forwarded
directly to hardware. This could allow the host to bypass the ITS emulation
completely by configuring the hardware to read from host-controlled memory,
leading to a potential DMA attack against EL2 memory.


I also noticed a few other issues in the ITS emulation code that might need
attention.

[Severity: High]
In check_table_update(), could there be a TOCTOU race with the host?

	snapshot_table =3D kern_hyp_va(table->base_snapshot);
...
	new_entry =3D snapshot_table[new_entry_index];
...
	if (rollback)
		new_entry =3D new_entry ^ GITS_BASER_VALID;

	if (new_entry & GITS_BASER_VALID)
		ret =3D __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MASK),

The snapshot_table is in host-shared memory. If the host concurrently
modifies the entry between the initial check and the rollback, couldn't it
force the rollback path to donate an arbitrary PFN to the hypervisor?

[Severity: High]
Can an untrusted host trigger the WARN_ON() in cwriter_write()?

		if (submit_single_cmd(its, retry)) {
			WARN_ON(process_cmd(its, &cmd, /* rollback */ true));
			return;
		}

If the host intentionally stalls the ITS to force a command timeout, this
rollback path is executed. If the rollback fails, the WARN_ON() will panic
the hypervisor in EL2 nVHE, bringing down the host and all protected VMs.

[Severity: Medium]
Are 64-bit accesses to GITS_CTLR incorrectly dropped by pkvm_its_emulate_ha=
ndler()?

		if (reg_handler->access_size < reg_size)
			return;

Since GITS_CTLR is configured with an access_size of 4, a valid 64-bit acce=
ss
from the host (which is permitted by the GICv3 architecture) would be silen=
tly
ignored, potentially returning uninitialized memory on reads.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D10
