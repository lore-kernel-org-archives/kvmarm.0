Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021141B5818
	for <kvmarm@lists.linux.dev>; Thu, 15 Aug 2024 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723743754; cv=none; b=YsKvh5nIMkOg2QovjQY/8l/gjlPMyF6MHO80FGrmyfy/Iw2ucV4/ooWaRA73iQm/J+6TSyUkZkHAbMQD1E3UF8ZRFpnhHjgGMdpyrJ+b9nOVshkyyj9yNI/8pm0vO22hwbIbhmn4O4FK4esgTpBwskB5DBwQJU87D2gXvUNN5/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723743754; c=relaxed/simple;
	bh=F7hjDcQU1uKyTnZ18iSdrBrO9H0arIdj4gIjb4wPULI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQ3xTiGsrP7bs8PgU4ex4a17VwHTC67yDAbVXGv7hROVmbFVdQu4utvMFrZ23caDaNBfXIFLWlvQpmeIqYgzsdapLlySj8rCSNutEJI1WkTOEMDk6iWFFIVzDUSR4Iso7iQIBP6EhNH2ChXNdy5yFefF7yS3Ce2LPASuRw0hYeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K1AUp3Xb; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K1AUp3Xb"
Date: Thu, 15 Aug 2024 10:42:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723743750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e/lR98zRBHFHUyMNnPW+pmonNMjc4h80yWAs/T+8nNU=;
	b=K1AUp3XbKzdV7Iv8sgn6QzafKMVgoLsmsvSagCSCkTJ/U17wVaDgWpa7TfRbquHdP7l+Sx
	oSaje5t9/DhD4T0xtLdTbkZNhpGcHwe09cRxiLu3NZUihmbiHTkspVIDRYiMvc9lRFv4EP
	UrIi3vX2CTUL+TkdIdLCg0GAr+yJb+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	wangzhou1@hisilicon.com, linuxarm@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Make the exposed feature bits in
 AA64DFR0_EL1 writable from userspace
Message-ID: <Zr49_ticsFzHOJq8@linux.dev>
References: <20240815155954.85480-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240815155954.85480-1-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 15, 2024 at 04:59:54PM +0100, Shameer Kolothum wrote:
> KVM exposes the OS double lock feature bit to Guests but returns
> RAZ/WI on Guest OSDLR_EL1 access. This breaks Guest migration between
> systems where this feature differ. Add support to make this feature
> writable from userspace by setting the mask bit. While at it, set the
> mask bits for the exposed WRPs(Number of Watchpoints) as well.
> Also update the selftest to cover these fields.
>=20
> However we still can't make BRPs and CTX_CMPs fields writable, because
> as per ARM ARM DDI 0487K.a, section G2.8.2 Breakpoint types and
> linking of breakpoints, highest numbered breakpoints must be context aware
> breakpoints. And it will be problematic if userspace decreases the number
> of non-context aware breakpoints as it will make the context aware
> breakpoints for the guest mapped to a wrong one.
>=20
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>    v1 --> v2:
>    Removed making BRPs and CTX_CMPs writable.
>    v1: https://lore.kernel.org/all/20240813142835.77180-1-shameerali.kolo=
thum.thodi@huawei.com/
> ---
>  arch/arm64/kvm/sys_regs.c                         | 13 ++++++++++++-
>  tools/testing/selftests/kvm/aarch64/set_id_regs.c |  2 ++
>  2 files changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c90324060436..e77cd6d1abb5 100644=02
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2376,7 +2376,18 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>  	  .get_user =3D get_id_reg,
>  	  .set_user =3D set_id_aa64dfr0_el1,
>  	  .reset =3D read_sanitised_id_aa64dfr0_el1,
> -	  .val =3D ID_AA64DFR0_EL1_PMUVer_MASK |
> +	/*
> +	 * We can't still make BRPs and CTX_CMPx writable as highest
> +	 * numbered breakpoints must be context aware breakpoints(ARM ARM
> +	 * DDI 0487K.a, section G2.8.2 Breakpoint types and linking of
> +	 * breakpoints). Hence, if the number of non-context aware breakpoints
> +	 * for the Guest is decreased by userspace, that will be problematic
> +	 * as KVM will map context aware breakpoints for the vCPU to different
> +	 * numbered breakpoints for the pCPU.

A few minor nitpicks:

 - BRPs counts the total number of breakpoints, not just the non-context
   aware BRPs

 - KVM doesn't do any register mapping at all, which is why we disallow
   changing the breakpoints altogether

 - The citation is for the AArch32 view of the debug architecture, not
   AArch64.

Perhaps use this wording:

	/*
	 * Prior to FEAT_Debugv8.9, the architecture defines context-aware
	 * breakpoints (CTX_CMPs) as the highest numbered breakpoints (BRPs).
	 * KVM does not trap + emulate the breakpoint registers, and as such
	 * cannot support a layout that misaligns with the underlying hardware.
	 * While it may be possible to describe a subset that aligns with
	 * hardware, just prevent changes to BRPs and CTX_CMPs altogether for
	 * simplicity.
	 *
	 * See DDI0487K.a, section D2.8.3 Breakpoint types and linking
	 * of breakpoints for more details.
	 */

Besides that, LGTM:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> +	 */
> +	  .val =3D ID_AA64DFR0_EL1_DoubleLock_MASK |
> +		 ID_AA64DFR0_EL1_WRPs_MASK |
> +		 ID_AA64DFR0_EL1_PMUVer_MASK |
>  		 ID_AA64DFR0_EL1_DebugVer_MASK, },
>  	ID_SANITISED(ID_AA64DFR1_EL1),
>  	ID_UNALLOCATED(5,2),
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/te=
sting/selftests/kvm/aarch64/set_id_regs.c
> index d20981663831..6edc5412abe8 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -68,6 +68,8 @@ struct test_feature_reg {
>  	}
> =20
>  static const struct reg_ftr_bits ftr_id_aa64dfr0_el1[] =3D {
> +	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DoubleLock, 0),
> +	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, WRPs, 0),
>  	S_REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, PMUVer, 0),
>  	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64DFR0_EL1, DebugVer, ID_AA64DFR0_EL1=
_DebugVer_IMP),
>  	REG_FTR_END,
> --=20
> 2.45.2
>

--=20
Thanks,
Oliver
