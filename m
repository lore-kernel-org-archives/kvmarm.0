Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EDD34751F
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 17:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122199; cv=none; b=hHpA6q1Rhj+hVasArQk3tghTrPX6B1QGiKJkCLw8jE8zziLCl7IG2w8jdHV2+5OI9eR8VYK6OdDAwRIcYLaWSggZE5pV5j6+/ASqZL4gPIAFLC5ehYjDjXOsjDDbrZgKmcWmNRJQ45eY5Gz3OMa5EoPN3kc93Zo3LxqV8VL5CY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122199; c=relaxed/simple;
	bh=a+Y6AsMD16vjhMlInsEfQ1rxW367wPCASpNkeyX7QB4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hC9k7Xb6PhDtP9KX25mUPjyvrXd8OBle/Y12WOBTKOOhvL1hw9/ch7Xt+e2fwEAEpJeXh9W+AZAP6J1/b6+e5Sq+XXAvuqsItTIofM81HT/XFhQV8oYw8IBFwxpm3I86VWl2ba3ZMnsyh+fmzgczQ0lNj1zRw6T002s9HO+634s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jy6QIGn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jy6QIGn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7474C1F000E9;
	Fri,  7 Aug 2026 17:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786122196;
	bh=D19zoMio3bgYBXvqkzm0hJEjdYps0QUAsU7zP7YwKfA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jy6QIGn0mRVREWZIby+yLOYgV+Nvs9u4FxpywVqCarJnf9BwPNsYhe0MS8ti3IU9K
	 QUERan2afsavncvr3Izk0X2mrvhDLNBgqcqcBphU0RNouYQWcrMOhymQ3rQRwqjul6
	 rPwln3Jx6Uw+jmYDi9kOhG9NkC1eDWO38vjlEz5skwIAr5Mh8B4CA7XMU4BprDylJt
	 P2ckdIYLARnQul1f3iCctu4HwouexvAIv9D/VldcIzn/r2AvTqxxHoOXfLNyZrW4Tn
	 uOWSxUNy+HRWfHTkPh+PZUoO1eY9+w7nv4puqKt6hZ1PCaU5/Uan8byUcpThvWQQuV
	 FZXggSmvIXNQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/13] KVM: arm64: Support host MMIO trap handlers
 for unmapped devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260807164322.2970811-5-sebastianene@google.com>
References: <20260807164322.2970811-2-sebastianene@google.com>
 <20260807164322.2970811-5-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 17:03:16 +0000
Message-Id: <20260807170316.7474C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Host MMIO trap handler fails to properly mask, sign-extend, and tr=
uncate register values during emulation.
- [Medium] Unconditional 4-byte instruction skip breaks AArch32 EL0 Thumb e=
xecution.
--

--- Patch [3]: [PATCH v2 03/13] KVM: arm64: Support host MMIO trap handlers=
 for unmapped devices ---
commit 4f82f551a35a497988ae3208761d26c15c28de61
Author: Sebastian Ene <sebastianene@google.com>

KVM: arm64: Support host MMIO trap handlers for unmapped devices

This commit introduces a stage-2 fault handler in the hypervisor to interce=
pt
and emulate host memory accesses to unmapped or protected MMIO regions. It
hooks into handle_host_mem_abort() to check if a registered callback can ha=
ndle
the access.

> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/n=
vhe/mem_protect.c
> index 500c18c2fd48b..7e978e0c44b9e 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
[ ... ]
> @@ -752,6 +753,50 @@ static void host_inject_mem_abort(struct kvm_cpu_con=
text *host_ctxt)
>  	inject_host_exception(esr);
>  }
> =20
> +static bool handle_host_mmio_trap(struct kvm_cpu_context *host_ctxt, u64=
 esr, u64 addr)
> +{
> +	u64 offset, reg_value =3D 0, start, end;
> +	u8 reg_size, reg_index;
> +	bool write;
> +	int i;
> +
> +	for (i =3D 0; i < num_protected_reg; i++) {
> +		if (!pkvm_protected_regs[i].pfn || !pkvm_protected_regs[i].nr_pages ||
> +		    !pkvm_protected_regs[i].cb)
> +			continue;
> +
> +		start =3D PFN_PHYS(pkvm_protected_regs[i].pfn);
> +		end =3D start + PFN_PHYS(pkvm_protected_regs[i].nr_pages);
> +		reg_size =3D BIT((esr & ESR_ELx_SAS) >> ESR_ELx_SAS_SHIFT);
> +
> +		if (start > addr || addr + reg_size > end)
> +			continue;
> +
> +		reg_index =3D (esr & ESR_ELx_SRT_MASK) >> ESR_ELx_SRT_SHIFT;
> +		write =3D (esr & ESR_ELx_WNR) =3D=3D ESR_ELx_WNR;
> +		offset =3D addr - start;
> +
> +		if (write && reg_index !=3D 31)
> +			reg_value =3D host_ctxt->regs.regs[reg_index];
> +
> +		pkvm_protected_regs[i].cb(&pkvm_protected_regs[i], offset, write,
> +					  &reg_value, reg_size);
> +
> +		if (!write && reg_index !=3D 31)
> +			host_ctxt->regs.regs[reg_index] =3D reg_value;

[Severity: High]
Does this emulation handle sign extension and register width properly?

When the host executes an instruction like LDRSB, shouldn't the handler ins=
pect
the ESR_ELx_SSE (Sign Extend) bit to properly sign-extend the value? Also, =
for
32-bit register destinations (ESR_ELx_SF =3D=3D 0), the architecture requir=
es the
upper 32 bits to be zeroed, but it looks like this assigns the value direct=
ly.

> +
> +		kvm_skip_host_instr();

[Severity: Medium]
Can this break AArch32 EL0 Thumb execution?

kvm_skip_host_instr() unconditionally adds 4 to the ELR. If the stage-2 data
abort originates from a host userspace process executing a 2-byte Thumb
instruction, shouldn't it inspect the ESR_ELx_IL bit to advance the PC by 2
bytes instead?

> +		return true;
> +	}
> +
> +	return false;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807164322.2970=
811-2-sebastianene@google.com?part=3D3
