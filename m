Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE538D3ED
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122553; cv=none; b=gNPOqeB97NR5z2RtApFcZvLYeA1oMliQNHuBiyNt2BR1QMrXSm+JpIEJxxeHiJMU2icDR6WixBxvsbW6kz6bVPQjjME/9mvIHjxndi8zfjp9aDsUs+H+FWEXT0aa3STDlB2SOAkmwsbcGMw0kHac8w0VYRsdy5BkV4RlDeT7wnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122553; c=relaxed/simple;
	bh=f3wgD0s6WiCfO58wgvrs+eRA0YJsQI71MxxJn/mXyns=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QrWK49YpxNJ4Q1PADS3BMGcqMXXSZKZLxUz42p+qgL7r7/GNzeTGiB6OvkftC4kGjCaLISdexJIM13yuknXvfSFyiUjGokoCMGgDnAj0aGQUR19jP6F22Q7IGXdAhFJEjJf+8J1W6KldUaLx1zVGGdNEEow9RADWlCqb1/1eXI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fzf0W9nN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fzf0W9nN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EAF1F000E9;
	Fri,  7 Aug 2026 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122552;
	bh=9faBLOj3FRHWHCRyKgKrFDuTzBqIO2rvymgzf2UFwLc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fzf0W9nNunzNqy2HjX52+JvHs1gi7dPoYSTQPIgTDJy6U0YVwrIqDkUorXjDGhuUD
	 917JfA1p5LXVMLEqAnv12VZO4u6nW5QF18hKr5oYOBmpH46SoZzyqwsLnhrJ4qx6Sc
	 Wo7CJEQl+mdpm/G9ZOD7Avy9/Xo1wqVMTRKSYEp2aLnH2rua7GqpHr4Tg2dwQeggLk
	 w0p2jro8/1iwuAxjPUiLiJVGGK20LREca31pZSwIFB4vwrptz7H0XSE9kRQcgX6vN/
	 /tGHCHGv0sU4PvTAlqYshhJloG5NYb6or0vSsbLxC2nYgLvRQ+vHLRMJiP1zqffJsc
	 OY1Pmmq3TUfIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/13] KVM: Parse the device tree and register the
 ITS region with pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807164322.2970811-6-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-6-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:09:11 +0000
Message-Id: <20260807170911.B6EAF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] The function pointer for the MMIO emulator passed to EL2 point=
s to unmapped/NX memory, causing an Instruction Abort.
- [High] MMIO emulation in `its_emulate_forward_req` double-swaps on Big En=
dian kernels by using `readX_relaxed` and `writeX_relaxed`.
- [High] pKVM incorrectly maps and accesses MMIO devices using the hypervis=
or's linear map (`__hyp_va()`) rather than a private VA range.
- [High] handle_host_mmio_trap ignores the ESR_ELx_SSE (Sign Extend) bit fo=
r MMIO reads, returning zero-extended values for signed loads.
--

--- Patch [4]: [PATCH v2 04/13] KVM: Parse the device tree and register the=
 ITS region with pKVM ---
commit 6f98f20a817e227941fab67881459ac609810480
Author: Sebastian Ene <sebastianene@google.com>

KVM: Parse the device tree and register the ITS region with pKVM

Identify the ITS base address from the device tree and store it in the
pkvm_protected_regs array so that it will be unmapped from the host
address space. Register a callback to forward all the MMIO requests to
the device to prevent breaking ITS functionality.

> diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/n=
vhe/its_emulate.c
> new file mode 100644
> index 0000000000000..63a42f520ed25
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
> @@ -0,0 +1,37 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <asm/kvm_pkvm.h>
> +#include <nvhe/mem_protect.h>
> +
> +void its_emulate_forward_req(struct pkvm_protected_reg *region, u64 offs=
et, bool write, u64 *reg,
> +			     u8 reg_size)
> +{
> +	void __iomem *addr =3D __hyp_va(PFN_PHYS(region->pfn) + offset);

[Severity: High]
Does using __hyp_va() here work for MMIO addresses? The __hyp_va() macro
subtracts hyp_physvirt_offset, which is based on RAM physical addresses.
Since MMIO regions often reside at lower physical addresses than RAM,
wouldn't this underflow and produce a virtual address with the top bits set,
leading to a Translation Fault? This same issue seems to be present in
__pkvm_host_donate_hyp_mmio() where it populates the page tables.

> +
> +	switch (reg_size) {
> +	case 1:
> +		if (!write)
> +			*reg =3D readb_relaxed(addr);
> +		else
> +			writeb_relaxed(*reg, addr);

[Severity: High]
Will these relaxed accessors cause a double-swap on Big Endian kernels?
When the host traps to EL2 on an MMIO access, the CPU register already
contains the exact data the host intended to write (swapped to Little
Endian by the host driver's writel). Using writeb_relaxed and similar
helpers will apply cpu_to_le* again. Should this use the __raw_read*
and __raw_write* accessors to preserve the trapped register's exact bit
representation?

> +		break;

[ ... ]

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 053e4f733e4be..5e80da18f3120 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c

[ ... ]

> @@ -39,6 +44,47 @@ static int __init register_memblock_regions(void)
> =20
> +static int __init register_its_emulated_region(void)
> +{

[ ... ]

> +		kvm_nvhe_sym(pkvm_protected_regs)[i].pfn =3D PHYS_PFN(res.start);
> +		kvm_nvhe_sym(pkvm_protected_regs)[i].cb =3D
> +			lm_alias(&kvm_nvhe_sym(its_emulate_forward_req));

[Severity: Critical]
Can this function pointer be safely executed at EL2? The host initializes
the callback using lm_alias, producing a host linear-map address. When
the hypervisor later applies kern_hyp_va() to it in
donate_protected_mmio_regions(), it converts it to a hyp linear-map
address. However, .hyp.text physical pages are not part of the
dynamically allocated hyp memory pool, so they are unmapped in the hyp
linear map. Does jumping to this pointer in handle_host_mmio_trap()
trigger an Instruction Abort?

[Severity: High]
Regarding how this callback's result is handled in handle_host_mmio_trap(),
does the trap handler process sign extension for MMIO reads? When the host
traps to EL2 on a stage-2 data abort caused by a signed read access (like
LDRSB), the ESR_ELx_SSE bit indicates the destination register should be
sign-extended. If handle_host_mmio_trap() writes the zero-extended value
directly into the host context, could this alter functional behavior for
signed loads?

> +		kvm_nvhe_sym(pkvm_protected_regs)[i].nr_pages =3D
> +			PFN_DOWN(min_t(u64, resource_size(&res), PAGE_ALIGN_DOWN(GITS_TRANSLA=
TER)));

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D4
