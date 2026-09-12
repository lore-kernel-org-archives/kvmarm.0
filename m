Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8581C38D6A2;
	Sat, 12 Sep 2026 08:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202931; cv=none; b=TDC/l0NGkaATi564csPmFziwTI0YAIzTYxbAzHb62JFIhxB+PIy9usG2Vfezf+FIiNKwXSM3BB2y6UoAmnwgH8zwkXQGiACnZLQ5IYEQzQKe7MGkL3W/xzmCb1bW8HbKpV39PxDRgC+0rMEcSH+9/71cBDvH6ez0+yMVpwo9WA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202931; c=relaxed/simple;
	bh=8uaBdVa3vktGkQW7UlQVNX7uUlD4996fwxnJ3HH7AOg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rAlBup2ZvoMnwhBpMBdiu74axn2MDhzmgttGhtQ2Z/AjqamoD0S3W8y96sCKr2l3QSWuou8Ls/XQet+NU/lhPpAGMI+6hpX60dUJXSN1t4Ltuiwi9DXyepee5wq31cCITpcJ2KsTSeC6qxO1aTQoqADR2zjs7ZWbUjYfZe1H39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cULyLSWX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cULyLSWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285771F00898;
	Sat, 12 Sep 2026 08:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789202927;
	bh=oeruj1hDXHAgZSUz3uVc5kDVw6oz2R1yHWrt95UJLlI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cULyLSWXurSR5f72NOgfodZ4w82kcXeIhpGL/luMaghOUJOzuAaTynNrJqNS0anAg
	 bKCsHR2EyKVIodeZwYfV//m7dlFd8whiwxIkrXJa8pb7cmN37QnNbWn1U1HZh+298u
	 9TnQSzGbBopb7JsMFrVU76Oqag2pb/4bUcQAOpuDGuJU/nvkKAHQDaVF0CPRG+CH2l
	 bddmrBnFtBEmGkIIdgaAdhRvlv0U3M4pw8p9h9uLAeiP+bY2EIGiVpakxo0GlRDlbh
	 oXhGlFZ0ak4KTPs7Y/3HDqAQdfLt9LAimZN8vUf8qnQNo06JucdRURF0cXjFKPeFXF
	 90iFzO3xrYrAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 4/7] firmware: arm_rmm: Add support for SRO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260912083611.2513845-5-suzuki.poulose@arm.com>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 12 Sep 2026 08:48:46 +0000
Message-Id: <20260912084847.285771F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] `delegated_phys` is used uninitialized on the buggy RMM error path=
 of `rmi_delegate_range()`, causing unpredictable undelegation sizes and le=
aking/corrupting memory.
--

commit 860fe4975d9c1564e207c537f0159673fd509495
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

firmware: arm_rmm: Add support for SRO

RMM v2.0 introduces Stateful RMI Operations (SRO) where an SMC can return w=
ith
an operation still in progress. The SRO is tracked using a struct rmi_sro_s=
tate
object to manage memory donation and reclamation. This commit provides the =
core
infrastructure for SRO and adds delegate/undelegate range wrappers that use=
 it.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index 5b0e342ce3d58..4f9898ece7547 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
[ ... ]
> +int rmi_delegate_range(phys_addr_t phys,
> +		       unsigned long size,
> +		       phys_addr_t *out_phys)
> +{
> +	long ret =3D 0;
> +	unsigned long top =3D phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret =3D rmi_granule_range_delegate(phys, top, &out_top);
> +
> +		if (ret =3D=3D RMI_SUCCESS) {
> +			/* Buggy RMM ? */
> +			if (WARN_ON(out_top <=3D phys)) {
> +				rmi_undelegate_range(top - size, size);
> +				return -ENXIO;
> +			}

[Severity: High]
If we take this buggy RMM error path, this function returns -ENXIO immediat=
ely
without setting *out_phys. Does this leave the caller's delegated_phys vari=
able
uninitialized?

Also, doesn't rmi_undelegate_range(top - size, size) here undo the entire
delegation, making the caller's own cleanup logic redundant and potentially
conflicting?

> +			phys =3D out_top;
> +		} else {
> +			break;
> +		}
> +	}
> +
> +	if (out_phys)
> +		*out_phys =3D phys;
> +
> +	return ret;
> +}
[ ... ]
> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
[ ... ]
> +	if (state =3D=3D RMI_OP_MEM_DELEGATED) {
> +		phys_addr_t delegated_phys;
> +
> +		if (rmi_delegate_range(phys, size, &delegated_phys)) {
> +			if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +				free_pages_exact(virt, size);
> +			return -ENXIO;
> +		}

[Severity: High]
If rmi_delegate_range() returns an error from the buggy RMM path,
delegated_phys is completely uninitialized.

Can this result in passing a garbage size (delegated_phys - phys) to
rmi_undelegate_range(), attempting to undelegate an unpredictable physical
memory region and preventing free_pages_exact() from executing?

> +	}
[ ... ]
> +static int rmi_sro_donate_noncontig(struct rmi_sro_state *sro,
> +				    unsigned long sro_handle,
> +				    unsigned long donatereq,
> +				    struct arm_smccc_1_2_regs *out_regs,
> +				    gfp_t gfp)
> +{
[ ... ]
> +		if (state =3D=3D RMI_OP_MEM_DELEGATED) {
> +			phys_addr_t delegated_phys;
> +
> +			if (rmi_delegate_range(phys, block_size,
> +					       &delegated_phys)) {
> +				if (!rmi_undelegate_range(phys, delegated_phys - phys))
> +					free_pages_exact(virt, block_size);
> +				return -ENXIO;
> +			}

[Severity: High]
Similar to rmi_sro_donate_contig(), this code uses delegated_phys uninitial=
ized
if rmi_delegate_range() takes the buggy RMM error path. Could this lead to
a similar memory leak and corruption risk?

> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912083611.2513=
845-1-suzuki.poulose@arm.com?part=3D4
