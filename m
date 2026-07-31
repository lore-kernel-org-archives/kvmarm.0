Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DA5239E6C
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509159; cv=none; b=eEj1agMtCRna01Y3u9wBF10Y77Kv/nmxaRpghUMsANslMhYK971twuSkzvsC0iWzrJFmTIurvhWBMQCparr67Hf41Y0D0JQYm9vF7pT0ACBgOChItcETAn4ga/kdF1seM80RHj65HGuT9Iwmn/HNd5AKbiha4RameCvl2n0TWkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509159; c=relaxed/simple;
	bh=6J5ZjELG6ROP7xLYhSzAl2hrjF/P52RLbDEAoqL88eY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W6YKJz6nUPy2ZVPMj+nC+yX5wHIWfcptMJuOIAO1ZXz/vtfExI3CiGZMiLBsWui+QjykpKvRaTFcsSbP2qLBQqab+oZsyWndjzlRSIZfd2aaTxxfJNV6gR3FJ2bfDCOgW4LT19/ulM1I+1Fqfb8eQpcdVJgE1Xa/9K5ogHe+I0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mu9uDcXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mu9uDcXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9001F000E9;
	Fri, 31 Jul 2026 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785509158;
	bh=7nAt1rpq+J4hflrO3nvs4ep27K1ltKp5IpVZ4LpMU10=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mu9uDcXy8hfxnrK6h4vkdiOkjo/QA06j5enkmuKSKPKuCvoJHqwNguMEGTDPOX/Gt
	 Nzi4DRphjoQO0Wyvi98Owg8e3JmEb5LAQI++gIk24o5L8JtAUtGbybFwp49eZpgVM7
	 nZvPbLQQf7DpJ4QPKPvHZyCdqyylws5UpNWLkpryx5PxsUfucQoAxovgsrNSVtnZCz
	 MZYaPUWGUVbu1QMJxvN0l///x9Jb6DbRe9jk+CzE5hD+QnQAuexR5TbJBBknfAnr+0
	 wkBDgX5Y2z92xJvP7+eqwQrfgK8a3aQ+doFJue9W7cbfuXOKPNQt9iNN9usHexaFTK
	 sRaU81lF0IAgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260731143541.956291-7-vdonnefort@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-7-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 14:45:57 +0000
Message-Id: <20260731144557.AE9001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Phantom hypervisor requests leading to infinite loop and memory le=
ak on hypercall errors.
--

--- Patch [6]: [PATCH v4 06/17] KVM: arm64: Add pkvm_hyp_req infrastructure=
 ---
commit ec846697735578e1b5a4e25b88e07602c29ae6a2
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add pkvm_hyp_req infrastructure

Introduce a struct pkvm_hyp_req to enable the pKVM hypervisor to request
resources from the host. Provide serialisation helpers to transport these
requests via SMCCC registers and a macro to automate HVC retries.

> diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/k=
vm_pkvm.h
> index 74fedd9c5ff02..6c2497047f8d8 100644
> --- a/arch/arm64/include/asm/kvm_pkvm.h
> +++ b/arch/arm64/include/asm/kvm_pkvm.h

[ ... ]

> +/* Return true if a pkvm_hyp_req has been decoded from the SMCCC args */
> +static inline bool smccc_to_pkvm_hyp_req(struct pkvm_hyp_req *req, struc=
t arm_smccc_res *res)
> +{
> +	u8 *src =3D (u8 *)res + offsetof(struct arm_smccc_res, a2);
> +	u8 type =3D *src;
> +
> +	if (type =3D=3D PKVM_HYP_NO_REQ || type >=3D __PKVM_HYP_REQ_TYPE_MAX)
> +		return false;
> +
> +	req->type =3D type;
> +	memcpy(&req->args, src + 1, pkvm_hyp_req_arg_size(type));
> +
> +	return true;
> +}
> +
> +int __pkvm_handle_smccc_req(struct arm_smccc_res *res);
> +
> +#define pkvm_call_hyp_req(f, ...)								\
> +({												\
> +	struct arm_smccc_res __res;								\
> +	int __ret;										\
> +	do {											\
> +		__ret =3D -1;									\
> +		arm_smccc_1_1_hvc(KVM_HOST_SMCCC_FUNC(f), ##__VA_ARGS__, &__res);		\
> +		if (WARN_ON(__res.a0 !=3D SMCCC_RET_SUCCESS))					\
> +			break;									\
> +		__ret =3D __res.a1;								\
> +		if (!__ret)									\
> +			break;									\
> +		__ret =3D __pkvm_handle_smccc_req(&__res);					\
> +	} while (!__ret);									\
> +	__ret;											\
> +})

[Severity: High]
Can this sequence lead to an infinite loop and memory leak on hypercall err=
ors?

When the hypercall fails and returns a non-zero error in __res.a1, the macro
passes the result to __pkvm_handle_smccc_req() to check for a piggybacked
request in __res.a2.

Standard EL2 handlers typically do not clear the x2 register (which maps to=
 a2)
on error; they set x1 to the error code and return. This means a2 retains t=
he
original second hypercall argument passed by the host.

If the least significant byte of that original host argument happens to mat=
ch
a valid request type, smccc_to_pkvm_hyp_req() would mistakenly decode a pha=
ntom
request. The host would handle this phantom request, return success, and the
macro would then infinitely retry the failing hypercall.

Is there a way to explicitly distinguish a hypercall error from a legitimate
hypervisor request, perhaps using a specific return code in a1 to indicate =
when
a2 actually contains a request?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.9562=
91-1-vdonnefort@google.com?part=3D6
