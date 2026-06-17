Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF2547798B
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 15:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781708875; cv=none; b=GU2JQ+V1q5OfCC8LioT0ITTd64fDcRi6NlzJMXFBMBi6tsIaPXjX8GiKgg8RHlOudaf7IpdIqyl0L2QCnb3Wq7fLl3UW2XjN4txfj49kE3vUv/Tx0RjiL7zJ3L+BhToLzk8OPkpzBqqYViUDATLBYnNT2VXY9vPEaQaZZK5Fr6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781708875; c=relaxed/simple;
	bh=270XOer/jzUl5yFvZ32BnApCIi8ITDPuZ+Y0VnUnLBo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XXBmDJcnxVv65R1uBpY/FLdVOLHbSh6XggDUY389hgqlDPLBGcSn3e5PkK3z0ifixdl2qkJwfuQr6o2xsYlbtNHjprdg8WV4hGa45oxtVFdJg7ftOtX3+nLxEyoWf/Q6qsJvc6aIcFsvTMogBmkM6jOIvjfBTnkYZxPfLcPo65c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DcZhEecA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DcZhEecA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBEC1F000E9;
	Wed, 17 Jun 2026 15:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781708873;
	bh=QTN+ZTpa8zEeSVweJrqwqNGpfKmfUM0iT/dhIBsWwLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DcZhEecAawPMLAIy8VjDtcSDIFZlv+1VcKTIMkCa20qejAwkzadNnS0it5ufSC0+S
	 hTDl8XsoEGpr0VIOdTjoePea1kISbT52dYyGgnkDGhM1arXFoyUOoRq5t6ClNNYAvR
	 Pthd6LfwXdWirdOC58drjTyj1TdKrI1j9t7qpLEa8ONKtKQbil28sw9ODrkc+Fl4aa
	 B+Ui9URI2HGsbEmwNx1Q0UjdK5D5lNAetgKWHSaz8vusvV6ugst5wb6D6t2My4mb8h
	 9fdORPlEiSAh9k2xUYN/BzW2eBpj8EymjeC2JMO3DpGPM54wKvp60POQeiqmgI+McS
	 bwjwVUglXyueQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/7] optee: ffa: Add NULL check in
 optee_ffa_lend_protmem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sebastian Ene" <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260617145130.3729015-2-sebastianene@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-2-sebastianene@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 17 Jun 2026 15:07:52 +0000
Message-Id: <20260617150752.BBBEC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Integer division truncation when validating the TEE's response=
 size in `get_protmem_config` allows out-of-bounds memory accesses and NULL=
 pointer dereferences.
- [High] A malicious or compromised TEE returning TEEC_SUCCESS with a non-z=
ero attribute size when no buffer was supplied causes a NULL pointer derefe=
rence in `optee_ffa_lend_protmem`.
- [High] The `optee_protmem_dyn_pool` structure leaks its `mem_attrs` array=
 when the pool is destroyed.
--

commit e70191e60cbc95a8fabdaddc766ad1d432febd3b
Author: Mostafa Saleh <smostafa@google.com>

optee: ffa: Add NULL check in optee_ffa_lend_protmem

Sashiko (locally) reports a possible null dereference under memory
pressure due to the lack of validation of the allocated pointer. Fix that
by adding the missing check.

> diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
> index b4372fa268d03..633715b98625c 100644
> --- a/drivers/tee/optee/ffa_abi.c
> +++ b/drivers/tee/optee/ffa_abi.c
> @@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee=
, struct tee_shm *protmem,
>  	int rc;
> =20
>  	mem_attr =3D kzalloc_objs(*mem_attr, ma_count);
> +	if (!mem_attr)
> +		return -ENOMEM;
> +
>  	for (n =3D 0; n < ma_count; n++) {
>  		mem_attr[n].receiver =3D mem_attrs[n] & U16_MAX;

[Severity: High]
This is a pre-existing issue, but can this lead to a NULL pointer
dereference of the mem_attrs array if the TEE returns malformed data?

If get_protmem_config() in drivers/tee/optee/protmem.c is called with
mem_attrs =3D=3D NULL to probe the array size, and the TEE returns
TEEC_SUCCESS (0) with params[1].u.memref.size > 0:

drivers/tee/optee/protmem.c:get_protmem_config() {
	...
	*ma_count =3D params[1].u.memref.size / sizeof(*mem_attrs);
	...
}

This skips the TEEC_ERROR_SHORT_BUFFER check. The caller
optee_protmem_alloc_dyn_pool() sees rc =3D=3D 0:

drivers/tee/optee/protmem.c:optee_protmem_alloc_dyn_pool() {
	...
	if (rc) {
		if (rc !=3D -ENOSPC)
			goto err;
	...
}

This bypasses the allocation of rp->mem_attrs, leaving it NULL while
rp->mem_attr_count is > 0. When init_dyn_protmem() later calls
optee_ffa_lend_protmem(), doesn't the loop here dereference the NULL
mem_attrs array?

[Severity: High]
This isn't a bug introduced by this patch, but does
optee_protmem_dyn_pool leak its mem_attrs array?

In optee_protmem_alloc_dyn_pool(), rp->mem_attrs is dynamically
allocated:

drivers/tee/optee/protmem.c:optee_protmem_alloc_dyn_pool() {
	...
	rp->mem_attrs =3D kcalloc(rp->mem_attr_count,
	                        sizeof(*rp->mem_attrs), GFP_KERNEL);
	...
}

However, in the destruction path pool_op_dyn_destroy_pool(), it appears
the array is not freed before destroying the pool:

drivers/tee/optee/protmem.c:pool_op_dyn_destroy_pool() {
	...
	mutex_destroy(&rp->mutex);
	kfree(rp);
}

If dynamic pools are repeatedly created and destroyed, could this leak
memory on every destruction cycle?

[Severity: Critical]
This is a pre-existing issue, but does the size validation in
get_protmem_config() suffer from integer division truncation?

If the TEE returns a size that is not a multiple of the struct size
(e.g., 7 when *ma_count is 1), does this check fail to catch the invalid
size?

drivers/tee/optee/protmem.c:get_protmem_config() {
	...
	if (!msg_arg->ret && mem_attrs &&
	    *ma_count < params[1].u.memref.size / sizeof(*mem_attrs)) {
	...
}

Since 7 / 4 evaluates to 1, the condition 1 < 1 is false. Would this
bypass the error path and lead to an out-of-bounds memcpy?

drivers/tee/optee/protmem.c:get_protmem_config() {
	...
	if (mem_attrs)
		memcpy(mem_attrs, tee_shm_get_va(shm_param, 0),
		       params[1].u.memref.size);
	...
}

Additionally, on the initial probe where mem_attrs =3D=3D NULL, if the TEE
returns a size of 3, rp->mem_attr_count becomes 0. On the second call,
kcalloc(0, 4) returns ZERO_SIZE_PTR. If the TEE again returns size 3,
the check evaluates to 0 < 0 (false). Would this result in passing NULL
to tee_shm_get_va() and causing a NULL pointer dereference inside that
function?

>  		mem_attr[n].attrs =3D mem_attrs[n] >> 16;
>  	}
>  	args.attrs =3D mem_attr;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260617145130.3729=
015-1-sebastianene@google.com?part=3D1
