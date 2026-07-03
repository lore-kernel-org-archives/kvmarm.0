Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29916279917;
	Fri,  3 Jul 2026 16:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095992; cv=none; b=pIQINtMNjTtkBK/QOMR2r7R18lClqZcqU6AvjYFqR4MvRCbS3Kyac5PQmkKWFBweCn6C/4YJhwJEDEM+Bp5/8IEZGUWp9YVhBXG+8udCfT1RWIzJQ8zLYkmnqciXAj4aLgZCmPKkz1ab+YBb0pc/B6qFj6LBoTEbOtwmgqbDuN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095992; c=relaxed/simple;
	bh=E8wBU4eZ3wQuwAcheuks1iYPT2XDH5PxkjBKARyM4ko=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WFP6+XITk7fBxk+dIua1vupTq7QvXi+OHzIJ1zh19HDQZKwNz0SS6ZqlYwSCSck5kcSPcPuJQorfQ0gCcx/ftGuyRxvN8REBuWMUyDhkhbKlbGRT68N5EADWcr0zvL85pAT6fLiz7Tbm0c/jfhttmgbc/5YxirrwzV2LZCInt/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NbH0JZPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NbH0JZPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D381F000E9;
	Fri,  3 Jul 2026 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783095990;
	bh=iMKo3ffDdzCsIWyfXsx8t2/Re4sWCgrZvqvUof8lHSI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NbH0JZPQTLqQKGtNL627w7LLgaGE+mf1NYDdD7hWucZf3/YsuqRoBFm3Kls8Qjm0N
	 uE991/QfEI0CiuFdrSgnYkM4xJzbWls8XvHLlwmhWDE9Wes+1z+ExLEbfQ9eHCVlA3
	 vMvUAG3NI6pOoreeQgC44OwOmSXcJKzA10qmNTj829of4gKXJzGH32AypYe76z3nmL
	 0VTVw9r3skudbUm+up7dm5nqh9n2kxfnEz4V/1wKSv4IVQJ0m2iUY+xDrWB42V4ju4
	 WYwPY1N5jS/JKlDVObiOx/idGzImlx+Mv/KuB2BqBt+BZwtJCoJavdlGqu2FpF8xWm
	 R3fmpRsdhC3MA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 13/40] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260703154811.3355680-14-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-14-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:26:29 +0000
Message-Id: <20260703162630.67D381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing hardware idle check before issuing VPE commands in `vgic_v=
5_irs_set_up_vpe()` causes state corruption on timeout recovery.
--

commit 0e86d7c766cc2f59e9782a84658b0e7ed678597a
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops

This commit introduces interfaces to validate and configure VPEs via the=20
host's IRS MMIO interface. It also extends the VPE doorbell commands with=20
VPE_MAKE_VALID.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index fd64ea0173b2f..6d7d9e6ed9dbf 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -332,10 +344,73 @@ static int vgic_v5_irs_set_vist_invalid(u16 vm_id, =
bool spi_ist)
>  	return __vgic_v5_irs_update_vist_validity(vm_id, spi_ist, true);
>  }
> =20
> +static int vgic_v5_irs_set_up_vpe(u16 vm_id, u16 vpe_id,
> +				  irq_hw_number_t db_hwirq)
> +{
> +	u64 vmap_vper, dbr, selr;
> +	u32 statusr, cr0;
> +	int ret;
> +
> +	guard(raw_spinlock_irqsave)(&global_irs_lock);
> +
> +	/* Make sure that we are idle to begin with */
> +	ret =3D vgic_v5_irs_wait_for_vm_op();
> +	if (ret)
> +		return ret;
> +
> +	/* Mark the VPE as valid */
> +	vmap_vper =3D FIELD_PREP(GICV5_IRS_VMAP_VPER_VPE_ID, vpe_id) |
> +		    FIELD_PREP(GICV5_IRS_VMAP_VPER_VM_ID, vm_id) |
> +		    GICV5_IRS_VMAP_VPER_M;
> +	irs_writeq_relaxed(vmap_vper, GICV5_IRS_VMAP_VPER);
> +
> +	/* Wait for the VPE to be marked valid in the VPET */
> +	ret =3D vgic_v5_irs_wait_for_vm_op();
> +	if (ret)
> +		return ret;
> +
> +	selr =3D FIELD_PREP(GICV5_IRS_VPE_SELR_VPE_ID, vpe_id) |
> +	       FIELD_PREP(GICV5_IRS_VPE_SELR_VM_ID, vm_id) |
> +	       GICV5_IRS_VPE_SELR_S;
> +	irs_writeq_relaxed(selr, GICV5_IRS_VPE_SELR);

[Severity: High]
Is it possible to clobber a still-busy VPE engine here if a previous
operation timed out?

While vgic_v5_irs_set_up_vpe() checks vgic_v5_irs_wait_for_vm_op() at the
start of the function, there does not appear to be a hardware idle check for
the VPE operation unit (like vgic_v5_irs_wait_for_vpe_op()) before writing
to GICV5_IRS_VPE_SELR.

If an earlier call to vgic_v5_irs_set_up_vpe() timed out waiting for a VPE
operation and released global_irs_lock on the error path, a subsequent call
could find the VM operation unit idle but the VPE operation unit still busy.
Writing to GICV5_IRS_VPE_SELR in this state could corrupt the hardware stat=
e.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D13
