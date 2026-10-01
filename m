Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FA34B3364;
	Thu,  1 Oct 2026 09:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790845492; cv=none; b=pzC1k6sAwsZqUV+CW01+1rOtVh9LguIwBq2gk/GIfwCzyjwot+uNLOQTH721c7ZngSaRhHhzc5Qf7rQM62RpeBHR/dcjita9uxO/YnaeyLtbmEYO7mWvmm84I3PQkDUMGMZyPplKPJBtmfSvqXXTOumHA7ce47bvLvjovrEaJkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790845492; c=relaxed/simple;
	bh=8N9REXczr+kUuB+VUm1j5YjRbLQWrvY8/W0bgkYGgrA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HX8WG0UCPh/rmTQIPFxgLirc6uYHQUC2O4QFQFk2LGecsasPEetAaSzoERC9LgYDI1oczyw0K+JQiADupP69j5nEDnCX2XdmiKwSD0ariV2s/+ZdF6CwrvdWuE3yjkEBWQCJLr0r/qgWJGSpNKd6Ub5eq7pM29ownQZb+OuV0oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hx7W9A5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hx7W9A5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CBB1F0089A;
	Thu,  1 Oct 2026 09:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790845491;
	bh=vGhPooovytXiIGhb9Qi6gDS4ibveb1btc2keqfMf59g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hx7W9A5tLTpBZAgcmFr2oUnq6Rwo/cviylHmZ2OvQ+RLFtK5mUWvFdDM/UXlD7W+9
	 6d4wkRmVhDJGqwIHZIjbjMiLopmpCV/NdJjPQfauKGH3ZO0X1kVMmqOywOERt55tE7
	 wxHji1vja2YXK9aidxdDUssm3iqx3awOvtYwUiOAabXlVBsV1hC/Jpxx0Q495MP7s/
	 dOF8UsdgMYflmcnpYa52Himmj8nGlQkKbK0P3/u3Odcnk63eRUETqv43FPArq4SiKm
	 FPGAvdd7QBDvdxKGfWDLdhVuIfq9hbvfT41VIK0YWcWaiAM6u32Rdzl9W2nnyXIZ9h
	 g3PSOKg7CY1og==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v21 8/9] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20261001084555.1456543-9-suzuki.poulose@arm.com>
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-9-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 09:04:50 +0000
Message-Id: <20261001090450.C1CBB1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] arm_rmm: dropped out_top on RMI_ERROR_RTT for range commands
--

commit 68e63e1b38f1af07d69bbc2eee9306e4bedb8efa
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add wrappers for Realm related RMI commands

This commit introduces wrappers for the RMI calls used to create and
manage realm guests. These inline functions map the standard KVM realm
operations to their underlying SMCCC interfaces.

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index 5d005054f3c6c..e3503aba646e2 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
[ ... ]
> +static inline long rmi_rtt_data_map(unsigned long rd,
> +				    unsigned long base,
> +				    unsigned long top,
> +				    unsigned long flags,
> +				    unsigned long oaddr,
> +				    unsigned long *out_top)
> +{
> +	struct arm_smccc_1_2_regs regs =3D {
> +		SMC_RMI_RTT_DATA_MAP, rd, base, top, flags, oaddr
> +	};
> +	long ret;
> +
> +	ret =3D rmi_sro_execute(&regs);
> +
> +	if (ret =3D=3D RMI_SUCCESS && out_top)
> +		*out_top =3D regs.a1;

[Severity: High]
If this operation encounters an RTT state conflict midway through processing
the range, the RMM terminates early and returns RMI_ERROR_RTT.

When that happens, the RMM writes the failing IPA to out_top (register x1)
so the caller knows which pages were successfully processed before the erro=
r.

By restricting the out_top assignment strictly to ret =3D=3D RMI_SUCCESS, d=
oesn't
this silently discard the partial progress indicator on RMI_ERROR_RTT, caus=
ing
KVM to lose track of the modified pages?

> +
> +	return ret;
> +}
[ ... ]
> +static inline long rmi_rtt_data_unmap(unsigned long rd,
> +				      unsigned long base,
> +				      unsigned long top,
> +				      unsigned long flags,
> +				      unsigned long oaddr,
> +				      unsigned long *out_top,
> +				      unsigned long *out_range,
> +				      unsigned long *out_count)
> +{
> +	struct arm_smccc_1_2_regs regs =3D {
> +		SMC_RMI_RTT_DATA_UNMAP, rd, base, top, flags, oaddr
> +	};
> +	long ret;
> +
> +	ret =3D rmi_sro_execute(&regs);
> +
> +	if (ret !=3D RMI_SUCCESS)
> +		return ret;
> +
> +	if (out_top)
> +		*out_top =3D regs.a1;

[Severity: High]
Similarly, if rmi_rtt_data_unmap() encounters an RMI_ERROR_RTT, it returns
early here without populating out_top.

Since the RMM handles range commands sequentially, the IPAs prior to the
error were successfully unmapped. Discarding out_top hides this partial
progress from the caller. Can this lead to memory leaks or missing TLB
invalidations because KVM loses sync with the actual RTT state?

This same pattern appears to affect the other range command wrappers
introduced in this patch, such as rmi_rtt_init_ripas(), rmi_rtt_unprot_map(=
),
rmi_rtt_set_ripas(), and rmi_rtt_unprot_unmap().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001084555.1456=
543-1-suzuki.poulose@arm.com?part=3D8
