Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A3544C4E2;
	Mon,  7 Sep 2026 10:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788776047; cv=none; b=pJ/SO40DcE0QJy9NUFn2n2303qAVeCjSSn1ZBuifXcy/2P5VpCi28L9LUZsxUbn39w7kF/o17h4F+rsOtamQi1uVeeREGZtcVpfy/9jysskcnXus3GSfgslly3xDhnB5Ui+egf84cr9ayrYEw6X6mX7GsxhbbqAv4EvUuikMci0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788776047; c=relaxed/simple;
	bh=nJGrtqM89Umvqc+EXkj0IOaPX3tL+8TpqGzzdv9qJT4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uCEuETYUgTRiI7oI8QM8gdTmEFPAefYYfeEjR+cYPbpmCGvSNWFyZUHOuGuVoUlWdSr9e8/CXxhdBTAI0LWMnvEht7glonSqDYN1KmpcS70UqU7qV2D5XrzESDDtzkU+4NPi+xKI+yhixLLkKYGT9NorHjABu1ppYeRDLQLbiW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KG8E8Usk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KG8E8Usk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517191F00A3A;
	Mon,  7 Sep 2026 10:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776045;
	bh=rmhgXU78dS9HRu9PphzIhUWmtLVWsT+/FkL3Jc7mjso=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KG8E8UskskKfJzjUMziutfWq9Kg1rkWsxOcZJ5uLKOd53JizA0f/jbAk1xmgZh4gB
	 ir3pyVu1hPRPUDyp66g7mSbDLjLTlBM6X81nMIeGbebUu+OzgETvv9uay4FZd6kjjN
	 WJ3hh12QPdhqQ3hv5wPrtVh7zERR+VnYEubCP53tRnRvOg2EPDtxGc3dmJyzCxXsY7
	 31qyd2pQn730/MWEKO8FaofYXnPR//DK65p23O5haeE38YPJijj6mAokZfSyZAwimH
	 w9h87uGCs2W52NsHzXMnQS7Jd7A5uNcFr8hIqcYk2Hj9+hXtPnIMRc/5APzwubrL+S
	 7NmOLq+Whnudw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 4/7] firmware: arm_rmm: Add support for SRO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260907095942.1140734-5-suzuki.poulose@arm.com>
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-5-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 10:14:04 +0000
Message-Id: <20260907101405.517191F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Infinite loop during SRO cancellation if the RMM continues to retu=
rn an unexpected MEMREQ.
- [High] Missing bounds check on `out_regs->a1` in `rmi_sro_donate_contig` =
allows an integer overflow that can erroneously free actively consumed memo=
ry.
- [High] The error handler for `sro->addr_count` corruption in `rmi_sro_ens=
ure_capacity` triggers an out-of-bounds read and arbitrary free.
- [High] Potential infinite loop in `rmi_delegate_range` and `rmi_undelegat=
e_range` on buggy RMM.
--

commit c980046a949a7ff8e2698f0f01373297576d9896
Author: Steven Price <steven.price@arm.com>
Subject: firmware: arm_rmm: Add support for SRO

This commit introduces support for RMM v2.0 Stateful RMI Operations (SRO), =
allowing SMCs to return with operations still in progress. It adds struct r=
mi_sro_state to track memory allocated but not yet consumed or reclaimed, a=
nd provides wrappers for SRO RMI commands.

> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rm=
i.c
> index 76f91c145e1fd..42c973c3a98bb 100644
> --- a/drivers/firmware/arm_rmm/rmi.c
> +++ b/drivers/firmware/arm_rmm/rmi.c
> @@ -24,6 +25,513 @@ unsigned long rmi_feat_reg(unsigned long id)
>  }
>  EXPORT_SYMBOL_GPL(rmi_feat_reg);
> =20
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
> +		if (ret =3D=3D RMI_SUCCESS)
> +			phys =3D out_top;

[Severity: High]
Could this loop indefinitely if a buggy RMM firmware returns RMI_SUCCESS but
does not advance out_top beyond phys?

> +		else if (ret =3D=3D RMI_BUSY || ret =3D=3D RMI_BLOCKED)
> +			cpu_relax();
> +		else
> +			break;
> +	}
> +
> +	if (out_phys)
> +		*out_phys =3D phys;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_delegate_range);
> +
> +int rmi_undelegate_range(phys_addr_t phys,
> +			 unsigned long size)
> +{
> +	long ret =3D 0;
> +	unsigned long top =3D phys + size;
> +	unsigned long out_top;
> +
> +	while (phys < top) {
> +		ret =3D rmi_granule_range_undelegate(phys, top, &out_top);
> +		if (ret =3D=3D RMI_SUCCESS)
> +			phys =3D out_top;

[Severity: High]
Does this undelegate loop carry the same infinite loop risk as the delegate=
 path
if the hypervisor fails to advance out_top?

> +		else if (ret =3D=3D RMI_BUSY || ret =3D=3D RMI_BLOCKED)
> +			cpu_relax();
> +		else
> +			break;
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(rmi_undelegate_range);

[ ... ]

> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
> +				 unsigned long sro_handle,
> +				 unsigned long donatereq,
> +				 struct arm_smccc_1_2_regs *out_regs,
> +				 gfp_t gfp)
> +{

[ ... ]

> +	rmi_op_mem_donate(sro_handle,
> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
> +			  0, out_regs);
> +
> +	unsigned long donated_granules =3D out_regs->a1;
> +	unsigned long donated_size =3D donated_granules << PAGE_SHIFT;

[Severity: High]
Can donated_granules (out_regs->a1) be an untrusted large value from a
compromised or buggy RMM?

If out_regs->a1 is excessively large, donated_granules << PAGE_SHIFT could
overflow into a small integer value.

> +
> +	if (donated_granules =3D=3D 0) {
> +		/* No pages used by the RMM */
> +		sro->addr_count++;
> +	} else if (donated_size < size) {
> +		phys =3D sro->addr_list[sro->addr_count] & RMI_ADDR_RANGE_ADDR_MASK;
> +
> +		/* Not all granules used by the RMM, free the remaining pages */
> +		for (long i =3D donated_size; i < size; i +=3D PAGE_SIZE) {

[Severity: High]
If the integer overflow described above occurs, this check
(donated_size < size) will incorrectly pass. Would this lead to the host
allocator erroneously freeing memory that the RMM might still be actively
using?

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
Is it safe to pass sro to rmi_sro_free() here when rmi_sro_ensure_capacity()
failed?

If rmi_sro_ensure_capacity() detects corruption and returns -EOVERFLOW beca=
use
sro->addr_count > RMI_MAX_ADDR_LIST, calling rmi_sro_free() passes that same
corrupted addr_count to the cleanup loop.

> +
> +	capacity =3D RMI_MAX_ADDR_LIST - sro->addr_count;
> +
> +	rmi_op_mem_reclaim(sro_handle,
> +			   virt_to_phys(&sro->addr_list[sro->addr_count]),
> +			   capacity, out_regs);
> +
> +	if (WARN_ON_ONCE(out_regs->a1 > capacity))
> +		out_regs->a1 =3D capacity;
> +
> +	sro->addr_count +=3D out_regs->a1;
> +
> +	return 0;
> +}
> +
> +void rmi_sro_free(struct rmi_sro_state *sro)
> +{
> +	for (int i =3D 0; i < sro->addr_count; i++) {

[Severity: High]
If sro->addr_count is corrupted and greater than RMI_MAX_ADDR_LIST, as caug=
ht
in the error path above, won't this loop use it as an upper bound, leading =
to
out-of-bounds array reads and arbitrary memory frees?

> +		unsigned long entry =3D sro->addr_list[i];
> +		unsigned long addr =3D RMI_ADDR_RANGE_ADDR(entry);
> +		unsigned long unit_size =3D RMI_ADDR_RANGE_SIZE(entry);
> +		unsigned long count =3D RMI_ADDR_RANGE_COUNT(entry);
> +		unsigned long state =3D RMI_ADDR_RANGE_STATE(entry);
> +		unsigned long size =3D donate_req_to_size(unit_size) * count;
> +
> +		if (state =3D=3D RMI_OP_MEM_DELEGATED) {
> +			if (WARN_ON_ONCE(rmi_undelegate_range(addr, size))) {
> +				/* Leak the pages */
> +				continue;
> +			}
> +		}
> +		free_pages_exact(phys_to_virt(addr), size);
> +	}
> +
> +	sro->addr_count =3D 0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_free);

[ ... ]

> +long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp)
> +{
> +	unsigned long sro_handle;
> +	struct arm_smccc_1_2_regs *regs =3D &sro->regs;
> +	bool cancelled =3D false;
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

[ ... ]

> +		}
> +
> +		if (ret) {
> +			/*
> +			 * All memory donating SROs must be cancellable. So a
> +			 * failure in memory allocation shouldn't be an issue.
> +			 * However, if we encounter a random failure (e.g.,
> +			 * buggy RMM), don't loop forever, just give up.
> +			 */
> +			if (WARN_ON_ONCE(!can_cancel))
> +				return ret;
> +
> +			rmi_op_cancel(sro_handle, regs);
> +			cancelled =3D true;
> +
> +			if (WARN_ON_ONCE(RMI_RETURN_STATUS(regs->a0) !=3D RMI_INCOMPLETE))
> +				return ret;

[Severity: High]
Does this sequence create an infinite loop on a buggy RMM?

If the RMM returns an unexpected MEMREQ and does not clear the can_cancel b=
it in
its return status after a cancellation is requested, the loop unconditional=
ly
re-issues the cancel command because it does not check the local cancelled =
state.

> +		}
> +	}
> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_memxfer_execute);
> +
> +/* For RMI commands that are stateful but not memory-transferring */
> +long rmi_sro_execute(struct arm_smccc_1_2_regs *regs)
> +{
> +	unsigned long sro_handle;
> +	bool cancelled =3D false;
> +
> +	rmi_smccc_invoke(regs, regs);
> +
> +	sro_handle =3D regs->a1;
> +
> +	while (RMI_RETURN_STATUS(regs->a0) =3D=3D RMI_INCOMPLETE) {
> +		bool can_cancel =3D RMI_RETURN_CAN_CANCEL(regs->a0);
> +
> +		switch (RMI_RETURN_MEMREQ(regs->a0)) {
> +		case RMI_OP_MEM_REQ_NONE:
> +			rmi_op_continue(sro_handle, RMI_CONTINUE_KEEP_GOING,
> +					regs);
> +			break;
> +		default:
> +			WARN_ON_ONCE(1);
> +			if (!can_cancel)
> +				return regs->a0;
> +
> +			cancelled =3D true;
> +			rmi_op_cancel(sro_handle, regs);

[Severity: High]
Could the same infinite loop vulnerability occur here for non-memory-transf=
erring
operations if the RMM continuously returns RMI_INCOMPLETE and an unexpected=
 MEMREQ
without clearing can_cancel?

> +		}
> +	}
> +
> +	if (cancelled)
> +		return -ECANCELED;
> +
> +	return regs->a0;
> +}
> +EXPORT_SYMBOL_GPL(rmi_sro_execute);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907095942.1140=
734-1-suzuki.poulose@arm.com?part=3D4
