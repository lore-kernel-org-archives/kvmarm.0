Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2337F2F1FDE;
	Fri,  3 Jul 2026 16:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783096775; cv=none; b=GkpwNZICnHlgDHAmReDHsiJdPdRH/XfyemGlqBx9HwW94D9IT2BKzJ4TbvRIYib7eAkR/Y7IwSqk+JX75XqOZFhGHcdfnsjCv7rwbboa5Wsk+O2RANzCAQL1z7A+uS3ixGs1EL2lp/59Xau8Q2Svr6+GZftBl2SjhywVMmYgxcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783096775; c=relaxed/simple;
	bh=t+oelIfKzrCBZcRPXSNZKrANj/xwhbPFN61MX66JZy8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LhsSrm27MDFkX3DOKt8Dl1Jp0sabuIC5YyXm6ib5Cq9KO8SHgV8uxyxXAOgfRSUirBufAoy4BmQJ8p3h3hcw0f6iUXMHm8FFGofKMNI2DyaowNftBbVDvFMySUp/ye0N886rshqA5in3Yj4mKy5TGUY8eCCgbG59h0Esrb+qHq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7d4xo4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7d4xo4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7E11F000E9;
	Fri,  3 Jul 2026 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096773;
	bh=k8goOvip0lQJPl2iw+wF9YNh6xcrvmib1V+w+48dxBA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G7d4xo4mAwGGz/GmsgZFn3d0Yj4e+PmJiRX76riAABF3AaFXjKgGOlABtaaVnky+1
	 Na9VIgE6S0aWDHv7gbjY6505T2+MJVlIdEAwlyo/hX8tZ9oHS42i8eV698bxWNOxax
	 6gf4eKngUblZiNRiaEq+gwxC8IPTDg3dDI5Pe8VDlS0Go2qh8iKill2oCPaVxS4uoG
	 H2PDADbk+fcbEr35RF485Ols5ppMFTW09Q/8mOnzX3LTv7i0Bnsfb7+p/SyQACg39/
	 c2nPMbQkZGKQGUlN4xtCq7yK+5+U//Zng89szROUfDniNGJHOA1kkTc7ZUGhtHAXtt
	 9pXrLcS0OnV+Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/40] KVM: arm64: gic-v5: Implement VMT/vIST IRS
 MMIO Ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260703154811.3355680-12-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-12-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:39:32 +0000
Message-Id: <20260703163933.5F7E11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] The error path unconditionally frees VMT memory if VMT assignm=
ent times out, risking hardware DMA into freed memory.
- [High] The error path for KVM device registration unconditionally returns=
 `-ENODEV`, completely bypassing the intended fallback to GICv3-legacy mode.
- [Medium] `vgic_v5_irs_assign_vmt()` writes to IRS control registers witho=
ut first waiting for the hardware interface to be idle.
--

commit 7badcef9a2165d8ec4899755d30ae11f3202995d
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops

This commit adds support for making VM and IST tables valid via the host
IRS MMIO interface. It introduces functions to allocate, assign, and clear
the VMT, and wires up vcpu_affinity commands to manipulate VMTE and VIST
validity.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 02d5e383a87ed..14adc82b65828 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c
[ ... ]
> @@ -105,13 +131,54 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
[ ... ]
> +	/*
> +	 * We've now allocated the VM table, but the host's IRS doesn't know
> +	 * about it yet. Provide the base address of the VMT to the IRS, as well
> +	 * as the number of ID bits that it covers and the structure used
> +	 * (linear/two-level).
> +	 */
> +	ret =3D vgic_v5_irs_assign_vmt(irs_caps.two_level_vmt_support,
> +				     ilog2(irs_caps.max_vms),
> +				     vgic_v5_get_vmt_base());
> +	if (ret) {
> +		kvm_err("Failed to assign the GICv5 VM tables to the IRS; no GICv5 sup=
port\n");
> +		vgic_v5_vmt_free();

[Severity: Critical]
If vgic_v5_irs_assign_vmt() fails, such as due to a hardware timeout after
writing the physical address to GICV5_IRS_VMT_BASER, doesn't the hardware
still hold the active pointer to this memory?

Calling vgic_v5_vmt_free() here unconditionally frees the VMT memory. If
the hardware recovers or continues processing, could this lead to the
hardware performing DMA into freed memory?=20

Should this path attempt to clear the VMT pointer in the hardware and only
free the memory if the clear operation succeeds?

> +		return -ENODEV;
> +	}
> +
>  	kvm_vgic_global_state.max_gic_vcpus =3D min(irs_caps.max_vpes,
>  						  VGIC_V5_MAX_CPUS);
> =20
>  	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
>  	if (ret) {
>  		kvm_err("Cannot register GICv5 KVM device.\n");
> -		goto skip_v5;
> +		/*
> +		 * Don't free the VMT itself if the hardware still has a valid
> +		 * pointer to it.
> +		 */
> +		if (!vgic_v5_irs_clear_vmt())
> +			vgic_v5_vmt_free();
> +		return -ENODEV;

[Severity: High]
Does returning unconditionally here bypass the intended fallback to
GICv3-legacy mode?

The commit message mentions falling back to the legacy path once the IRS VMT
state is cleared, and the original code used a goto to jump to skip_v5. By
returning -ENODEV directly here, it seems KVM will fail to initialize any G=
IC
support when vGICv5 registration fails.

>  	}
> =20
>  	v5_registered =3D true;
[ ... ]
> @@ -153,18 +221,136 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
[ ... ]
> +static int vgic_v5_irs_assign_vmt(bool two_level, u8 vm_id_bits,
> +				  phys_addr_t vmt_base)
> +{
> +	u64 vmt_baser;
> +	u32 vmt_cfgr;
> +
> +	guard(raw_spinlock_irqsave)(&global_irs_lock);
> +
> +	vmt_baser =3D irs_readq_relaxed(GICV5_IRS_VMT_BASER);
> +	if (!!FIELD_GET(GICV5_IRS_VMT_BASER_VALID, vmt_baser))
> +		return -EBUSY;
> +
> +	vmt_cfgr =3D FIELD_PREP(GICV5_IRS_VMT_CFGR_VM_ID_BITS, vm_id_bits);
> +	if (two_level)
> +		vmt_cfgr |=3D FIELD_PREP(GICV5_IRS_VMT_CFGR_STRUCTURE,
> +				       GICV5_IRS_VMT_CFGR_STRUCTURE_TWO_LEVEL);
> +
> +	irs_writel_relaxed(vmt_cfgr, GICV5_IRS_VMT_CFGR);
> +
> +	/* The base address is intentionally only masked and not shifted */
> +	vmt_baser =3D FIELD_PREP(GICV5_IRS_VMT_BASER_VALID, true) |
> +		    (vmt_base & GICV5_IRS_VMT_BASER_ADDR);
> +	irs_writeq_relaxed(vmt_baser, GICV5_IRS_VMT_BASER);

[Severity: Medium]
Should there be a check to ensure the hardware interface is idle before
writing to these IRS control registers?

Unlike vgic_v5_irs_write_vm_mmio_reg(), which explicitly calls
vgic_v5_irs_wait_for_vm_op() before writing, this function directly writes
to GICV5_IRS_VMT_CFGR and GICV5_IRS_VMT_BASER immediately after acquiring
the lock. Could this corrupt the hardware configuration if the IRS is busy
processing a previous operation (e.g., during kexec)?

> +
> +	return vgic_v5_irs_wait_for_vm_op();
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D11
