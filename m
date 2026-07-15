Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3E0480DE6;
	Wed, 15 Jul 2026 15:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784129397; cv=none; b=JJez2hGOMi/Vt5+mKT2LhTJjeBV7hgb/Z07yPBndiXLrF0+YZjJnW2ZtKeE+lSwf+i6xc7o9MRdx8YTRduiImzv3KR1g6le7hfbSJrQjdQrwIZ4Y2+D129v3c4NWfWIq5rpSiiKCxv07sAHsaYchVyBRxQmLaxreWk0mAIwqc40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784129397; c=relaxed/simple;
	bh=hyBfho3fe9EoSQo9+7TxXsKWR0m1HcRr+LjZ1CToV9g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MvFIY8uGUGXm4juRDs7Tts9CiBhJGpLO2nStYUKIO6BHgJmezbJKsiUexGtedeaIvo4tUlWOG0qAYA7wdFxHb4rfWulcKdPHHx9F7TdRptVnx2SiCZTPY1aemjqeRkFpfykHe0QNjoDeyTm3OD5foaZPJnVfEs6A4M2h3EFjDqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nP9Vcfd0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nP9Vcfd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAEA1F000E9;
	Wed, 15 Jul 2026 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784129395;
	bh=68L1pqlN1cUg3j3+jVJQc9w3RUlgKSEU0hp6XIkSh+k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nP9Vcfd0f5Hvf8GrOOzdUsHuiKypNQaqX5VwATh0Pxo232IAWZHKCQ/NOhBjWzsM8
	 eSB8ycRB4DMSlRnGTJTWon6tH3lsyUux+8PJqWtsNVN4x/oC0uN3AAnPeBJQoac24Z
	 wJFqdIzTxfYXK1RIbCIbKuBpOc3Ys7uSTpvpRwN7SBR+CGxR6CCHPEvR/ZfzB7TXwS
	 kNUHDKlImtHyOHnftHgVGBum01xsLMJIYjz2Ymh8gTK1aH9gHgrajhnrSE9ISy/Xgl
	 0XOKTkDDwJqS8hm1w3cpXg5Y5Yf3YDiuzpM4Zbm51RA6gA5k2l/h65fjMesjzNO2OC
	 qw8bHMkWkCASQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/6] firmware: arm_rmm: Add support for SRO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Steven Price" <steven.price@arm.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260715142739.80398-6-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-6-steven.price@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 15:29:54 +0000
Message-Id: <20260715152954.ECAEA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [High] Kernel infinite loop when SRO memory allocation fails and the oper=
ation cannot be cancelled.
- [High] SRO wrappers wipe and free the `rmi_sro_state` struct unconditiona=
lly, leaking cached memory and breaking cross-call reuse.
- [High] `rmi_op_cancel` overwrites the `regs` structure with the cancellat=
ion request result, destroying the SRO loop state and leaving the RMM opera=
tion incomplete.
- [High] Out-of-bounds array read and arbitrary memory free when handling a=
n overflow condition in SRO reclaim.
- [High] Missing clamp on `donated_granules` in `rmi_sro_donate_contig` all=
ows a malicious or buggy RMM to trigger arbitrary out-of-bounds page frees.
- [Medium] Incorrect alignment check using `IS_ALIGNED` with potentially no=
n-power-of-two sizes.
- [Medium] SRO wrappers hardcode `GFP_KERNEL`, directly contradicting the s=
tated goal of supporting atomic execution contexts.
- [Low] Usage of non-standard macro `kmalloc_obj()` causes compilation fail=
ure.
--

--- Patch [5]: [PATCH 5/6] firmware: arm_rmm: Add support for SRO ---
commit 105823e0511b9065ecd4f5281f43bd808384b24c
Author: Steven Price <steven.price@arm.com>

firmware: arm_rmm: Add support for SRO

This commit introduces Stateful RMI Operations (SRO) for RMM v2.0, allowing
SMC operations to return while still in progress and be continued later. It
adds infrastructure to track and reuse allocated memory during these
operations to support execution in contexts where memory allocation is
difficult. The patch also provides wrappers for SRO commands and modifies
delegate/undelegate handlers to use the stateful infrastructure.

> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/r=
mi_cmds.h
> index 7eb2c8d7f7fa8..f13ecdb40ded4 100644
> --- a/arch/arm64/include/asm/rmi_cmds.h
> +++ b/arch/arm64/include/asm/rmi_cmds.h

[ ... ]

> @@ -46,6 +142,98 @@ static inline int rmi_realm_activate(unsigned long rd)
>  	return res.a0;
>  }
> =20
> +/**
> + * rmi_realm_create() - Create a realm
> + * @rd: PA of the RD
> + * @params: PA of realm parameters
> + * @sro: Preallocated SRO context to be used
> + *
> + * Create a new realm using the given parameters.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_create(unsigned long rd, unsigned long param=
s,
> +				   struct rmi_sro_state *sro)
> +{
> +	return rmi_sro_memxfer_cmd(sro, GFP_KERNEL,
> +				   SMC_RMI_REALM_CREATE, rd, params);
> +}

[Severity: Medium]
The commit message states the SRO framework permits operations to be done i=
n a
context where memory allocation may be difficult, such as an atomic context.
However, does passing GFP_KERNEL here directly contradict that goal? If
rmi_sro_ensure_capacity() requires memory, it will call alloc_pages_exact()
with GFP_KERNEL, which will sleep.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index e7ab4a7df3ca8..6a9f61760fd77 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c

[ ... ]

> @@ -22,6 +23,487 @@ unsigned long rmi_feat_reg(unsigned long id)

[ ... ]

> +static void rmi_op_cancel(unsigned long sro_handle,
> +			  struct arm_smccc_1_2_regs *out_regs)
> +{
> +	struct arm_smccc_1_2_regs regs =3D {
> +		SMC_RMI_OP_CANCEL, sro_handle
> +	};
> +
> +	rmi_smccc_invoke(&regs, out_regs);
> +}

[Severity: High]
Does rmi_op_cancel() overwrite the caller's out_regs with the cancellation
result? When called from rmi_sro_memxfer_execute(), a successful cancel
returns RMI_SUCCESS in out_regs->a0. This would cause the loop condition
(RMI_RETURN_STATUS(regs->a0) =3D=3D RMI_INCOMPLETE) to fail early and aband=
on
the operation before it completes, potentially causing future RMM operations
to fail.

[ ... ]

> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{
> +	unsigned long unit_size =3D RMI_DONATE_SIZE(donatereq);
> +	unsigned long unit_size_bytes =3D donate_req_to_size(donatereq);
> +	unsigned long count =3D RMI_DONATE_COUNT(donatereq);
> +	unsigned long state =3D RMI_DONATE_STATE(donatereq);
> +	unsigned long size =3D unit_size_bytes * count;
> +	unsigned long addr_range;
> +	int ret;
> +	void *virt;
> +	phys_addr_t phys;
> +
> +	for (int i =3D 0; i < sro->addr_count; i++) {
> +		unsigned long entry =3D sro->addr_list[i];
> +
> +		if (RMI_ADDR_RANGE_SIZE(entry) =3D=3D unit_size &&
> +		    RMI_ADDR_RANGE_COUNT(entry) =3D=3D count &&
> +		    RMI_ADDR_RANGE_STATE(entry) =3D=3D state &&
> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {

[Severity: Medium]
Can size be a non-power-of-two here? The IS_ALIGNED() macro evaluates a
bitwise AND with (size - 1) and strictly requires the alignment to be a
power of two. If the RMM requests a contiguous donation where count is not a
power of two, this check uses an invalid bitmask.

> +			sro->addr_count--;
> +			swap(sro->addr_list[sro->addr_count],
> +			     sro->addr_list[i]);
> +
> +			goto out;
> +		}
> +	}

[ ... ]

> +out:
> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
> +			  0, out_regs);
> +
> +	unsigned long donated_granules =3D out_regs->a1;
> +	unsigned long donated_size =3D donated_granules << PAGE_SHIFT;
> +
> +	if (donated_granules =3D=3D 0) {
> +		/* No pages used by the RMM */
> +		sro->addr_count++;
> +	} else if (donated_size < size) {

[Severity: High]
Is it possible for the RMM to return a maliciously large value for
donated_granules here? Unlike rmi_sro_donate_noncontig() which clamps
this value, this function does not. If the value overflows the bitwise shif=
t,
donated_size could appear small, causing the kernel to erroneously enter the
free loop below and release pages that the RMM may actively be using.

> +		phys =3D sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
> +
> +		/* Not all granules used by the RMM, free the remaining pages */
> +		for (long i =3D donated_size; i < size; i +=3D PAGE_SIZE) {
> +			if (state =3D=3D RMI_OP_MEM_DELEGATED)
> +				free_delegated_page(phys + i);
> +			else
> +				__free_page(phys_to_page(phys + i));
> +		}
> +	}
> +
> +	return 0;
> +}

[ ... ]

> +static int rmi_sro_reclaim(struct rmi_sro_state *sro,
> +			   unsigned long sro_handle,
> +			   struct arm_smccc_1_2_regs *out_regs)
> +{
> +	unsigned long capacity;
> +	int ret;
> +
> +	ret =3D rmi_sro_ensure_capacity(sro, 1);
> +	if (ret)
> +		rmi_sro_free(sro);

[Severity: High]
If rmi_sro_ensure_capacity() fails because sro->addr_count is greater than
RMI_MAX_ADDR_LIST, it returns -EOVERFLOW. Passing sro to rmi_sro_free() in
this state will cause the loop in rmi_sro_free() to iterate out-of-bounds
past the end of the addr_list array, reading garbage data and attempting to
free it.

> +
> +	capacity =3D RMI_MAX_ADDR_LIST - sro->addr_count;

[ ... ]

> +unsigned long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t g=
fp)
> +{
> +	unsigned long sro_handle;
> +	struct arm_smccc_1_2_regs *regs =3D &sro->regs;
> +
> +	rmi_smccc_invoke(regs, regs);
> +
> +	sro_handle =3D regs->a1;
> +
> +	while (RMI_RETURN_STATUS(regs->a0) =3D=3D RMI_INCOMPLETE) {
> +		bool can_cancel =3D RMI_RETURN_CAN_CANCEL(regs->a0);
> +		int ret =3D 0;
> +
> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		case RMI_OP_MEM_REQ_DONATE:
> +			ret =3D rmi_sro_donate(sro, sro_handle, regs->a2, regs,
> +					     gfp);
> +			break;
> +		case RMI_OP_MEM_REQ_RECLAIM:
> +			ret =3D rmi_sro_reclaim(sro, sro_handle, regs);
> +			break;
> +		default:
> +			ret =3D WARN_ON_ONCE(1);
> +			break;
> +		}
> +
> +		if (ret) {
> +			if (can_cancel)
> +				rmi_op_cancel(sro_handle, regs);
> +
> +			if (WARN_ON_ONCE(RMI_RETURN_STATUS(regs->a0) !=3D RMI_INCOMPLETE))
> +				return ret;
> +		}
> +	}

[Severity: High]
Does this code loop infinitely if a memory allocation fails and can_cancel =
is
false? If ret is set to an error code and can_cancel is false, rmi_op_cance=
l()
is skipped. The regs state is not modified, so RMI_RETURN_STATUS(regs->a0)
remains RMI_INCOMPLETE, the WARN_ON_ONCE check fails, and the loop repeats
indefinitely without returning the error.

[ ... ]

> @@ -80,8 +562,9 @@ static int rmi_configure(void)
>  {
>  	unsigned long ret;
>  	struct rmm_config *config __free(free_page) =3D (struct rmm_config *)ge=
t_zeroed_page(GFP_KERNEL);
> +	struct rmi_sro_state *sro __free(kfree) =3D (struct rmi_sro_state *)kma=
lloc_obj(*sro);

[Severity: Low]
Is kmalloc_obj() a standard kernel macro? It does not appear to exist in the
standard kernel headers, which will result in an implicit function declarat=
ion
error and build failure.

> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
> index c038c1d685fad..138983ab4e3c2 100644
> --- a/include/linux/arm-rmi-cmds.h
> +++ b/include/linux/arm-rmi-cmds.h

[ ... ]

> @@ -19,10 +19,45 @@ struct rtt_entry {

[ ... ]

> +#define rmi_sro_memxfer_cmd(sro, gfp, ...) ({				\
> +	struct rmi_sro_state *__sro =3D (sro);				\
> +	*__sro =3D (struct rmi_sro_state){ .regs =3D {__VA_ARGS__} };	\
> +	int __ret =3D rmi_sro_memxfer_execute(__sro, gfp);		\
> +	rmi_sro_free(__sro);						\
> +	__ret;								\
> +})

[Severity: High]
Does this macro unconditionally wipe and free the rmi_sro_state struct? The
compound literal assignment *__sro =3D (struct rmi_sro_state){ ... } will
zero-initialize addr_count and addr_list, wiping any cached addresses from a
previous attempt. Furthermore, calling rmi_sro_free() unconditionally before
returning frees any allocated memory, defeating the stated design goal of
reusing memory across calls.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715142739.8039=
8-1-steven.price@arm.com?part=3D5
