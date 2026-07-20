Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7647144CF2F
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784569653; cv=none; b=djb1VF4xcIRWc23qiz/kTH66JDslxmYgFq1d0UL0FIgSu77mdQUX6Ns0JdkGpL1rmQe9y+qSLoJtZ4xm4E+2lLXDld7God8U1qjafSPbkFXmdSQPIqi95C5S8iG7IUv6B+3nseifzBpqCliTiUdQuXOanw98zX19LWhBkkoP6D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784569653; c=relaxed/simple;
	bh=AQpuIMPVN4ZDzJoXbcNkxWZGA3U2NTlrdbv6odP1seE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pexuJ+48QU+jx/KGeqkcocQx1N1piy4AglnRunn+Cq3Lcij28mMC2I0dKX8ZCymLwfcJUfb3cUBuhQpj8eB26IfF/Zyn7zwz6hEcyKMM2EW3QwrXfo2WAOZJZTHGKFEQO9hI7W8Z0fJPcsxlvCyDeS3jON1XJTEKBsRgVFa/z2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wz587SkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wz587SkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D151F000E9;
	Mon, 20 Jul 2026 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784569645;
	bh=R6XsJcBAvlzvfHReHzBeavObj+JsW4FAwI2ASUjHh+Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Wz587SkEZCK6UDnHNqbFOtziHylB4ilRL2k+ZkhvGbt9/picjHIEZHcfEyRrIvjgO
	 MBhKr2HqbnhO2S3B9GvBY5KmzO6TQjlnERLHoIMTsNQ5J02h7iJD9lPdJmqcgA08Gr
	 2Z4zSsbnaib0+guKtfLhNo48jh1HGlErtRX4m/wbwP7h++vYvHd1Symg89rU9SMekM
	 +55zPo20zhKLb0iZB1A0TaNZyHZh/rx6ZL4A5Dn/FjY+iXas9VOWteTwq4Fbh+JfmO
	 UmFvigAWvj29fLOWUQ1NJVUpX3yhKA5SB54K8mBYg9eUQ13jsZHjoYKLo/OBETxUJu
	 tZRuW/AK4f0yQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/17] KVM: arm64: Alloc simple_buffer_page using
 pKVM hyp allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260720171513.1415357-18-vdonnefort@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-18-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 17:47:24 +0000
Message-Id: <20260720174725.47D151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Indiscriminate conversion of `-ENOMEM` into SMCCC top-up requests =
creates an infinite host kernel retry loop.
--

--- Patch [17]: [PATCH v3 17/17] KVM: arm64: Alloc simple_buffer_page using=
 pKVM hyp allocator ---
commit 1035ec393d7338c6871aee7974ca4f89393be89b
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Alloc simple_buffer_page using pKVM hyp allocator

This commit transitions the allocation of the simple_ring_buffer structures
from host-donated memory to the new pKVM hypervisor heap allocator. It
routes hypercalls through pkvm_call_hyp_req() and errno_to_smccc() to
handle heap memory top-up requests automatically during allocation.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 01e7ffc489f5b..a5b740d152be9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -745,7 +745,7 @@ static void handle___tracing_load(struct kvm_cpu_cont=
ext *host_ctxt)
>  	DECLARE_REG(unsigned long, desc_hva, host_ctxt, 1);
>  	DECLARE_REG(size_t, desc_size, host_ctxt, 2);
> =20
> -	cpu_reg(host_ctxt, 1) =3D __tracing_load(desc_hva, desc_size);
> +	errno_to_smccc(__tracing_load(desc_hva, desc_size), host_ctxt);

[Severity: High]
Does this create an infinite retry loop in the host if the hypervisor fails
to allocate page tables for the tracing buffer?

If __tracing_load() returns -ENOMEM because hyp_alloc() fails internally
during pkvm_map_private_va_range() (where no top-up is needed and
hyp_alloc_topup_needed() is 0), errno_to_smccc() will unconditionally
intercept the -ENOMEM and create a PKVM_HYP_REQ_HYP_ALLOC request with 0
pages.

The host kernel will successfully process the 0-page top-up in
__pkvm_handle_smccc_req(), which returns 0. Since pkvm_call_hyp_req() loops
on !__ret, this will cause the host to retry the failing hypercall endlessl=
y:

arch/arm64/include/asm/kvm_pkvm.h:pkvm_call_hyp_req() {
    ...
    do {
        ...
        __ret =3D __pkvm_handle_smccc_req(&__res);
    } while (!__ret);
    ...
}

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720171513.1415=
357-1-vdonnefort@google.com?part=3D17
