Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596D03B3BE2;
	Tue, 29 Sep 2026 22:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790720978; cv=none; b=a5IV5V1G1NlJpedUUEDP3Q8TmCoMJwsCm2QIMP+BJQ5+UYMoJLjTwaROkJ8bM8YLxu/BMcV7KjiS/vUK/mkT93yEEw1yo9xgrnZ/5yf1JIfOzdxLYQEA/3zXzbO1jTk96mRkL5OogN6bHKhbLAv12SLE/H6vwhwTstbJ8/9OepA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790720978; c=relaxed/simple;
	bh=36cQp3hUF4IJKmEUKbeKUDpV8hjtIqqM5nwkKa67F2c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NaN5jP2jlLL+dkvFrmdDnFNYoEI5DDbxYfwUsWImt4gqtaOpi/vu0r2aUMdcnnio9JAHJd/aFWwxUuFWbI0vucDqbMi9R53io1FoQxlMj/UpD1ie5N8XM2//rJn6zB0qsHtCn5xoQmOdY1GdGYlcxF5jJYAC+YeATo4sFUwy9cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SqZarxyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SqZarxyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8344F1F000FF;
	Tue, 29 Sep 2026 22:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790720976;
	bh=E7Nh+li5tH2W/zzNhsY99ToMXYNxgZz+A10CwADykR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SqZarxybAUQgs363XCPtDzmHjPRbBfG1JieSx7ZQVGIuAoRzBhZftOmBM4cOV6Aeu
	 aAwRB8e81734WwfgSBch+sRceExGKg1OQnHSHj+iHUcwaKHxdU1ferdBFBZpBudh96
	 Nsl6M6AZK3BuZ+Tcrko95HHK4VTlh9b+yK2OW4EgK4kkGtF3BlSzCTMsGcnSP5zMKH
	 Z7MgW/zlRIzH+rj++Mm/Ee7k1oZhWnfA7idiT5h49OnfX5G0zm6iVK2lRFz/YzGZcd
	 1rZhC5QPzvmz+4rMwQEM7MbsGqBQPPNftDRfyCzYvcD+kMyOpQz9YPzhVBkxjfETwS
	 luu16uae0BTsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v20 8/9] firmware: arm_rmm: Add wrappers for Realm
 related RMI commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260929221623.1342076-9-suzuki.poulose@arm.com>
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-9-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 22:29:36 +0000
Message-Id: <20260929222936.8344F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] arm_rmm: Range-based RMI wrappers drop progress indicator on e=
rror, risking GPF
- [High] arm_rmm: SRO cancellation flow aborts prematurely, leaving SRO dan=
gling
--

commit 206f9f5530d9fa5eb129cd6fc6e598e72857683a
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add wrappers for Realm related RMI commands

This commit introduces static inline wrappers for executing Realm
Management Interface (RMI) commands. These wrappers call into lower-level
SMC execution functions to manage Realm guests.

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index 5d005054f3c6c..4f0d6a8006a4a 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h
> @@ -104,4 +104,464 @@ static inline bool is_rmi_available(void)
>  }
>  #endif	/* CONFIG_ARM_RMM_RMI */
> =20
> +
> +/**
> + * rmi_rtt_data_map_init() - Create a mapping at protected IPA, copying =
contents
> + *			     from a given non-secure source granule.
> + * @rd: PA of the RD
> + * @data: PA of the target granule mapped in the guest
> + * @ipa: IPA at which the granule @data will be mapped in the guest
> + * @src: PA of the source granule with contents
> + * @flags: RMI_MEASURE_CONTENT if the contents should be measured
> + *
> + * Create a mapping from Protected IPA space to conventional memory, cop=
ying
> + * contents from a Non-secure Granule provided by the caller.
> + *
> + * Return: 0 on success, positive RMI result code or negative Linux erro=
r code
> + */
> +static inline long rmi_rtt_data_map_init(unsigned long rd, unsigned long=
 data,
> +					 unsigned long ipa, unsigned long src,
> +					 unsigned long flags)
> +{
> +	struct arm_smccc_1_2_regs regs =3D {
> +		SMC_RMI_RTT_DATA_MAP_INIT, rd, data, ipa, src, flags
> +	};
> +
> +	return rmi_sro_execute(&regs);

[Severity: High]
Does the SRO cancellation flow in the underlying rmi_sro_execute() and
rmi_sro_memxfer_execute() abort prematurely when returning to these wrapper=
s?

In rmi_sro_execute(), the cancellation path does this:

	rmi_op_cancel(sro_handle, regs);
	cancelled =3D true;

According to the RMM specification, SMC_RMI_OP_CANCEL returns RMI_SUCCESS w=
hen
accepted. Since RMI_SUCCESS is 0, the loop condition in rmi_sro_execute():

	while (RMI_RESULT_STATUS(regs->a0) =3D=3D RMI_INCOMPLETE)

evaluates to false. This breaks out of the loop and skips the mandatory
RMI_OP_CONTINUE calls needed to fully unwind the SRO.

Similarly, in rmi_sro_memxfer_execute(), there is an explicit assertion:

	if (WARN_ON_ONCE(RMI_RESULT_STATUS(regs->a0) !=3D RMI_INCOMPLETE))
		return ret;

which immediately aborts when rmi_op_cancel() correctly returns RMI_SUCCESS.

Can this leave SRO operations permanently in the CANCELLING state within the
RMM, leading to resource leaks and preventing realms from being properly
destroyed?

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

[Severity: Critical]
If a range-based RMI SRO executes partially and returns an error (such as
RMI_ERROR_INPUT), the architecture specifies that the address of the first
unprocessed granule is returned in regs.a1.

Does this wrapper drop the Top progress marker on failure?

By only populating out_top when ret =3D=3D RMI_SUCCESS (or by returning ear=
ly on
failure as seen here), callers might evaluate their progress as zero on
partial failure.

In paths like rmi_delegate_range(), this unpopulated out_top causes out_phys
to evaluate to the start address, which bypasses rmi_undelegate_range().
Could this lead to leaking partially processed granules to the allocator,
causing Granule Protection Faults (GPF) when the host accesses them later?

The same pattern appears in rmi_rtt_data_map(), rmi_rtt_unprot_map(),
rmi_rtt_unprot_unmap(), and rmi_granule_range_delegate().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929221623.1342=
076-1-suzuki.poulose@arm.com?part=3D8
