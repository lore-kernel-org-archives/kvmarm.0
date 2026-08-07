Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0C4397936
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121875; cv=none; b=aJCnLYTXkW33NgsWdb3hxmfXa4iOzioL0Xfod+d0AQvQK7AkLUyJ9uQTGaM/UkASYVTbSjPyRcmOcPfKVCXEsrHE7g1Hsbyt0SuBhuDFeXuf4iECXJEfTiummYFoUYwfRGRDU9erWz5EJU9QgCpodvZTSMZBTPgrXKD5HX4jC78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121875; c=relaxed/simple;
	bh=pwNst9smIY6l5a528TbEf6z6Zo/yJONGt5IUjkJFfto=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EHriAfPIGs/2aZycoSZXENh/esI3Wce7qdDSZebE6npHu2caLd0/gW45z36ldz/jUhjgUKM2bGwcm7gKCTae9gjSJG5ucJSDjMn0Y8EOhuI+Y4q9UL21LujXK1DOfsUCzNHsmO5uPJTvL0mkdUtkJN5UEeu2YYCOZO+gZg+O4nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKXD8+db; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKXD8+db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D351F000E9;
	Fri,  7 Aug 2026 16:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786121871;
	bh=ycINfeROeM5ojGT3Ub7Ys20C7v+gdth+FQUiOiVg9XU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GKXD8+dbc/7GWWj+fQND4PSVdUDOaZ6lJf2MRquSKZL8RpUXezvgMOcXlm1XROvMD
	 Gji9iswVcpO1jdYA4JwEJ4yKDRHc8KxtoLZQh/ByheZkulqIaqYuEDY7c/yZfG3nb4
	 /S2hCju/v48v1hltOVh5e2zRR9K9zSTdiijhGLxxgwRPbVJ5jBQRJab/kuwjToi9Fw
	 hPabjjoBflQUw66EBuImYwGJHFxuwjAiH87MsQ87ZjD5E+bAJt60RmGTKR0lkyd9s/
	 usZmCO5ebOFDgH5atOX3dbV7aq3EHdFNGjvjgAZmyMSmLPzl5CeXsiD0v8FootUQe1
	 FQiaCc6Eu0ZQw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/13] KVM: arm64: Shadow the ITS command queue and
 setup emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807164322.2970811-8-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-8-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 16:57:50 +0000
Message-Id: <20260807165750.D9D351F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:
- [Critical] The hypervisor ITS emulation fails to trap critical configurat=
ion registers (e.g., GITS_CBASER, GITS_CTLR), allowing the host to bypass e=
mulation and execute arbitrary ITS commands.
- [Critical] Rolling back the emulation state when hardware command process=
ing times out causes a critical state desynchronization, leading to memory =
corruption.
- [High] Unvalidated `cmd_offset` initialization from hardware allows the h=
ost to cause out-of-bounds memory accesses in the hypervisor.
- [High] An unsigned loop counter underflow in the error path of `pkvm_setu=
p_its_shadow_cmdq` causes an infinite loop and out-of-bounds memory unshari=
ng.
- [High] The ITS emulation uses `__hyp_va()` on physical MMIO device addres=
ses, causing a Translation Fault.
- [High] The error path in `pkvm_its_emulate_setup` leaks randomized hyperv=
isor virtual addresses (hyp tags) to the host kernel.
- [Medium] The ITS emulation mishandles 32-bit MMIO accesses to the 64-bit =
`GITS_CWRITER` and `GITS_CREADR` registers, applying bitmasks to the wrong =
payload bits.
- [Medium] The error path in `pkvm_its_emulate_setup` hardcodes a 1-page re=
turn for private memory, permanently leaking hypervisor pages if more were =
allocated.
- [Medium] Mismatched size calculations in `pkvm_setup_its_shadow_cmdq` cau=
se it to attempt pinning unshared pages when addresses or lengths are unali=
gned.
--

--- Patch [6]: [PATCH v2 06/13] KVM: arm64: Shadow the ITS command queue an=
d setup emulation ---
commit 44d4bb1ba5e1c6603582c76567c28f1efdb0f865
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Shadow the ITS command queue and setup emulation

This patch introduces pKVM ITS command queue emulation. It sets up private
and shared memory regions to track the ITS command queue and intercepts
writes to GITS_CWRITER to validate commands before pushing them to the
hardware queue.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> index 63a42f520ed25..e943ab972aa5e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
[ ... ]
> @@ -35,3 +38,285 @@ void its_emulate_forward_req(struct pkvm_protected_re=
g *region, u64 offset, bool
> +static int submit_single_cmd(struct its_priv_state *its, bool retry)
> +{
[ ... ]
> +		/*
> +		 * We can't spin here forever and we can't roll back
> +		 * the cmd queue pointer. Let's revert the cmd effects in the
> +		 * emulation layer and then go back to the driver to let it
> +		 * decide what to do next.
> +		 */
> +		if (!timeout--)
> +			return -EBUSY;

[Severity: Critical]
Can this state rollback cause memory corruption?

If the hardware takes too long to process the command and we time out here,
returning -EBUSY causes cwriter_write() to call process_cmd(..., true)
to revert the hypervisor's internal tracking state.=20

However, the hardware is still asynchronously processing the command and ca=
nnot
be aborted. Will the hardware operate on memory that the hypervisor believes
has already been unmapped and returned to the host?

> +	}
> +
> +	return 0;
> +}
[ ... ]
> +static void cwriter_write(struct pkvm_protected_reg *region, u64 offset,=
 u64 value)
> +{
> +	struct its_priv_state *its =3D region->priv;
> +	struct its_cmd_block cmd, raw;
> +	u64 new_offset;
> +	bool retry;
> +	int i;
> +
> +	new_offset =3D value & GITS_CWRITER_OFFSET;

[Severity: Medium]
Does this properly handle 32-bit partial MMIO accesses?

The pkvm_its_emulate_handler() passes the 32-bit payload directly to=20
the handler as the value parameter, but cwriter_write() ignores the=20
offset parameter and treats the incoming 32-bit payload as the absolute
64-bit value. This might extract the wrong bits.=20

cwriter_read() below also ignores the offset and always returns the full
64-bit register.

> +	if (new_offset >=3D its->host_state->cmdq_len)
> +		return;
> +
> +	retry =3D FIELD_GET(GITS_CWRITER_RETRY, value);
> +	while (its->cmd_offset !=3D new_offset) {
> +		memcpy(&raw, its->cmd_host_copy + its->cmd_offset, sizeof(raw));

[Severity: High]
Can the host exploit the initial cmd_offset to cause out-of-bounds memory
accesses here?

The cmd_offset is initialized directly from the hardware's GITS_CREADR in
pkvm_its_emulate_setup(), which the host could have manipulated prior to
setup. This cmd_offset is used as an index for memcpy() operations without
checking if it exceeds the provided cmdq_len.

> +
> +		for (i =3D 0; i < ARRAY_SIZE(cmd.raw_cmd); i++)
> +			cmd.raw_cmd[i] =3D le64_to_cpu(raw.raw_cmd_le[i]);
> +
> +		if (process_cmd(its, &cmd, /* rollback */ false))
> +			return;
> +
> +		memcpy(its->cmd_original + its->cmd_offset, &raw, sizeof(struct its_cm=
d_block));
> +
> +		if (its->needs_flush)
> +			gic_flush_dcache_to_poc(its->cmd_original + its->cmd_offset, sizeof(c=
md));
> +		else
> +			dsb(ishst);
> +
> +		if (submit_single_cmd(its, retry)) {
> +			WARN_ON(process_cmd(its, &cmd, /* rollback */ true));
> +			return;
> +		}
> +	}
> +}
> +
> +static void cwriter_read(struct pkvm_protected_reg *region, u64 offset, =
u64 *read)
> +{
> +	struct its_priv_state *its =3D region->priv;
> +	*read =3D readq_relaxed(its->base + GITS_CWRITER);
> +}
> +
> +static struct its_handler its_handlers[] =3D {
> +	ITS_HANDLER(GITS_CWRITER, sizeof(u64), cwriter_write, cwriter_read),
> +	{},
> +};

[Severity: Critical]
Is it safe to only intercept GITS_CWRITER in this handler array?=20

It appears all other configuration registers (like GITS_CBASER and
GITS_CTLR) fall through to its_emulate_forward_req() which passes
the unintercepted writes directly to the hardware.=20

Could a malicious host directly modify GITS_CBASER to point the hardware qu=
eue
to an unvalidated memory page, bypassing all emulation checks and compromis=
ing
hypervisor isolation?

[ ... ]
> +static int pkvm_setup_its_shadow_cmdq(struct its_host_state *host_state)
> +{
> +	u64 start_pfn, num_pages, i;
> +	int ret;
> +
> +	start_pfn =3D hyp_virt_to_pfn(host_state->cmd_host_copy);
> +	num_pages =3D host_state->cmdq_len >> PAGE_SHIFT;
> +
> +	for (i =3D 0; i < num_pages; i++) {
> +		ret =3D __pkvm_host_share_hyp(start_pfn + i);
> +		if (ret)
> +			goto unshare_cmd_host;
> +	}
> +
> +	ret =3D hyp_pin_shared_mem(host_state->cmd_host_copy,
> +				 host_state->cmd_host_copy + host_state->cmdq_len);

[Severity: Medium]
Could this cause a mismatch in the number of pages pinned vs shared?

The calculation "num_pages =3D host_state->cmdq_len >> PAGE_SHIFT" truncates
the size, sharing exactly num_pages. However, hyp_pin_shared_mem() page-ali=
gns
the boundaries up and down.=20

If cmd_host_copy or cmdq_len are unaligned, the pin operation could span
num_pages + 1 pages, attempting to pin an unshared page and failing the
ownership check.

> +	if (ret)
> +		goto unshare_cmd_host;
[ ... ]
> +unshare_cmd_host:
> +	if (i =3D=3D 0)
> +		return ret;
> +
> +	for (i =3D i - 1; i >=3D 0; i--)
> +		__pkvm_host_unshare_hyp(start_pfn + i);

[Severity: High]
Will this loop underflow and cause an infinite loop?=20

The variable 'i' is defined as an unsigned 64-bit integer (u64) at the top =
of=20
the function. The condition 'i >=3D 0' is always true for unsigned variable=
s,=20
meaning when 'i' reaches 0 it will wrap around to UINT64_MAX.=20

This could unshare wildly out-of-bounds PFNs and crash the hypervisor.

> +	return ret;
> +}
[ ... ]
> +int pkvm_its_emulate_setup(phys_addr_t dev_addr, struct its_host_state *=
host_state, void *priv,
> +			   size_t priv_num_pages)
> +{
[ ... ]
> +	host_state->cmd_original =3D kern_hyp_va(host_state->cmd_original);
> +	host_state->cmd_host_copy =3D kern_hyp_va(host_state->cmd_host_copy);
> +
> +	ret =3D pkvm_setup_its_shadow_cmdq(host_state);
> +	if (ret)
> +		goto err_with_host_state;

[Severity: High]
Does this leak the randomized hypervisor virtual address to the host?

We mutate the host-provided host_state page in-place using kern_hyp_va()
which applies the hypervisor's KASLR tag. If pkvm_setup_its_shadow_cmdq()
fails, this modified page is returned directly to the host unscrubbed in
the err_with_host_state cleanup path, exposing the hypervisor's linear map =
tag.

> +
> +	hyp_spin_lock_init(&priv_state->its_lock);
> +
> +	priv_state->host_state =3D host_state;
> +	priv_state->base =3D (void __iomem *)__hyp_va(dev_addr);

[Severity: High]
Is it correct to use __hyp_va() on a physical MMIO device address?

In ARM64 pKVM, __hyp_va() applies a fixed offset intended only for=20
mapping system RAM into the hypervisor's linear map. It does not work=20
for physical MMIO regions.=20

Attempting to access these virtual addresses will likely cause a Translation
Fault and crash the hypervisor during setup. its_emulate_forward_req() also
appears to use this macro.

> +	priv_state->cmd_original =3D host_state->cmd_original;
> +	priv_state->cmd_host_copy =3D host_state->cmd_host_copy;
> +
> +	priv_state->cmd_offset =3D readq_relaxed(priv_state->base + GITS_CREADR=
) &
> +		GITS_CREADR_OFFSET;
> +	priv_state->needs_flush =3D
> +		(readq_relaxed(priv_state->base + GITS_CBASER) & GITS_CBASER_SHAREABIL=
ITY_MASK) !=3D
> +		GITS_CBASER_InnerShareable;
> +
> +	its_reg->priv =3D priv_state;
> +
> +	hyp_spin_unlock(&its_setup_lock);
> +
> +	return 0;
> +err_with_host_state:
> +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(host_state), 1));
> +err_with_priv:
> +	WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(priv_state), 1));

[Severity: Medium]
Should this use priv_num_pages instead of a hardcoded 1?

The hypervisor allocates priv_num_pages for the private state tracking,
but if an error occurs here, it explicitly returns only 1 page to the
host. If priv_num_pages > 1, won't the remaining pages permanently leak?

> +err_unlock:
> +	hyp_spin_unlock(&its_setup_lock);
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D6
