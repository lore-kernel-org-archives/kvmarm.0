Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D342347DD54;
	Fri,  4 Sep 2026 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788529548; cv=none; b=iupU6oP//xkGDsCk84EmXkjnU438mjKJ8ZANHBfdJm0ULJMDBxd8X07STxbABAJc3oUUaajjb5nTUbkME4zp7q7nqkmY2VrZiqUyvrperR4NKC+MwwNF6beNTB5jd3jFOcAg5/I1SrXXJ1yL5P1Be4InZdzeUADPAPiAIIgDfgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788529548; c=relaxed/simple;
	bh=x0A1kB72ZpUPDKdBQWyRDq4/HRBE+lO3fb6GPu8hn1w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aV1lgsYo36FPWhJYRo4XzQYD/FtDvnlqPlh7q2vCrIpbV4H6AKyQcFeyZ+uX0hE0GuQCzpcGRGaOrVdS8Xiwhqm2uN7G7tDm9cKnpSde7Vvknid72v7v87e2Ur4rpqzzwMlsf7h9yyydITvV9dJJlJGA8yXgI9dyPfkZtBmwxtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=db9pWl9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="db9pWl9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2561F1F00A3D;
	Fri,  4 Sep 2026 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788529546;
	bh=CEN3eHGG8a4J8rPb3syRCgQ4tzK/RBznwyDvY1psSjI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=db9pWl9RpjbBtlHsQY7OF8v12D2k0weK5fTMTPFRdUTgU65DCU+SCUll21QB8kFA9
	 WrCKmMeRcgG4zVR5B7BiSlG4cgGuf1fZBjZRdjjvqz9H/TbFRtoTmE6iJXg7W9zJmZ
	 8LZ5zvW8eQ2DHKZqfbSE0IJFyrp3AWVQyAPmDCb+pEHdobcaNk+0gkpzBndQhhYaSY
	 1nYq32K173oJnF5iBAwHDCMhvK9zZ6WKGzyV8SY9B5vBW8cpJvhlpVCxezhsycPna/
	 zGX3PN935/VwhZ8rxYWK3vSmNUXyCgaOg8jPvSesep39q0QobUTB4UXiicKJJ7vvMa
	 ejDjFgxIT6H6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 35/49] KVM: arm64: gic-v5: Implement save/restore
 mechanisms for ISTs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260904113404.4051341-36-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
 <20260904113404.4051341-36-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:45:45 +0000
Message-Id: <20260904134546.2561F1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] KVM fails to validate that restored pending LPIs have a valid IntI=
D (>=3D 8192), allowing userspace to inject out-of-range LPIs into the hard=
ware.
--

commit f80500170eda967b08d4456f691f187bea6f8d97
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs

This commit introduces the ability to save and restore Interrupt State Tabl=
es
(ISTs) for SPIs and LPIs in a GICv5 VM. Userspace provides migration storage
via KVM_DEV_ARM_VGIC_GRP_IST, and KVM handles copying the state between the
GICv5 hardware and these buffers while ensuring the VM remains quiesced.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5-tables.c b/arch/arm64/kvm/vgic/v=
gic-v5-tables.c
> --- a/arch/arm64/kvm/vgic/vgic-v5-tables.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5-tables.c
[ ... ]
> +static int vgic_v5_process_iste(__le32 *iste, struct list_head *pending_=
irqs,
> +				u32 intid, u32 type)
> +{
> +	u32 iste_data =3D le32_to_cpu(READ_ONCE(*iste));
> +	int ret;
> +
> +	/* Pending state is replayed later with VDPEND. */
> +	if (iste_data & GICV5_ISTL2E_PENDING) {
> +		ret =3D vgic_v5_track_pending_irq(pending_irqs, intid, type);

[Severity: High]
Can userspace inject an out-of-range LPI by restoring a buffer with the
pending bit set for an invalid index?

When restoring the IST via KVM_DEV_ARM_VGIC_GRP_IST, KVM scans the
userspace-provided buffer and calls vgic_v5_process_iste(). If the
pending bit is set, it tracks the interrupt for later replay. However,
there does not appear to be a check to ensure that the intid is within
the valid range for LPIs (e.g., >=3D 8192).

Executing a vdpend instruction with an LPI identifier less than 8192 is
architecturally unpredictable. Could this allow a malicious userspace
process to trigger a synchronous exception or SError at EL2, taking
down the host hypervisor?

> +		if (ret)
> +			return ret;
> +	}
> +
> +	iste_data &=3D ~GICV5_ISTL2E_PENDING;
> +	iste_data &=3D ~GICV5_ISTL2E_HWU;
> +
> +	WRITE_ONCE(*iste, cpu_to_le32(iste_data));
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904113404.4051=
341-1-sascha.bischoff@arm.com?part=3D35
