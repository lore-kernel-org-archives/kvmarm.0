Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4681451B161;
	Thu,  1 Oct 2026 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864740; cv=none; b=JIq1HbTk8hil0b0ysK9WdbiiXfoA3OyAsVL1cuhFoGIvoMzFht0CPkmwukO8G5X/miCzctEMa19PMFnksEWROmH87GYtmll4C4Lz58lppT2RD2btJUq9hmDw5V5FFjfWEOUnvydEav/mXtuSb9S6D9j7+y9a6YC60N7306CN+lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864740; c=relaxed/simple;
	bh=tasnBJ8YHzAnG8bpbSBn1fYDAHBXFheRjY3+fuPdFIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crPJxWpjeYgBNvnP/DHnnLUtzgO9v4KjgrKwA+8qUEcoY/vHSGv1EDSpLX23saN9nT7YD14ofwvqROkEEAjnr+z1srE+bICZtKyXnfkwx/yeXPiUEJdoipZaOfPOP3uVE7kAO5TlEDFvvaQLzByO2f4jygl/UCEk2Sqd2rq+HJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iehR+JhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iehR+JhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B1F1F000FF;
	Thu,  1 Oct 2026 14:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790864738;
	bh=8AC7GbvuCCMMbO7MKRkTJUZ5RNbtzx9lp9nn1lg0M9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iehR+JhNmWti4pt7pfdUdJ6fePSYT//2YUHfiZ2GH0gFzcTvh2uujKnreTPbdh9f3
	 InAhVQJauuzfMtHOROac9Sn4iUr2Jjiuf/5dsLjq+np/OXGSrrfwX4FbkLGWaOEwfC
	 SOpmvaH9GBGPE7YYvV9OX4mhXFOzAmcIiyqd3r6AOysyHvWbfeLFc2ZN2fxsGDwJvI
	 CfLvGrDiLGkpHpn67BrpwfZtN31KPXLEsyAzyDfQ616aG4PbKBiqPXJWGqwoKE4NuS
	 0/uH67EaBvXRO9WWtTh8DTHR41EpXacsiDhks8IoOxdDPuBTu6237B3FfonEih7AmT
	 kVO94jhXn8CRw==
Date: Thu, 1 Oct 2026 15:25:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v21 07/15] KVM: arm64: Forward GCS exceptions to nested
 guests
Message-ID: <ar5cHWMczKd6yw7n@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-7-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-7-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:17PM +0100, Mark Brown wrote:
> For nested guests where HFGITR_EL2.nGCSSTR_EL1 is clear or when there are

I see at [0] that, if HFGITR_EL2.nGCSSTR_EL1 is clear:

"If EL2 is implemented and enabled in the current Security state, and
either EL3 is not implemented or SCR_EL3.FGTEn == 1, then execution at EL1
using AArch64 of any of the specified instructions generates a GCS
exception with EC syndrome value 0x2D, unless the instruction generates a
higher priority exception."

For:

GCSSTR.
GCSSTTR when PSTATE.UAO is 1.
GCSSTTR when the Effective value of HCR_EL2.{NV, NV1} is {1, 1}.

So privileged GCS stores.

[0]: https://support.arm.com/documentation/111107/2026-09/AArch64-Registers/HFGITR-EL2--Hypervisor-Fine-Grained-Instruction-Trap-Register?lang=en

> L2 GCS data check exceptions we need to forward the exception to the guest.
> Add handling to do so.
>
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

(A bunch of commentary here, just reasoning out loud for my own
understanding.)

All LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index db37678dcb05..a8198e96fcb4 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c

> +/*
> + * We might get GCS exceptions that need to be forwarded to the
> + * hypervisor when a nested guest has HFGITR_EL2.nGCSSTR_EL1 clear, or
> + * for a GCS data check exception for a L2 guest.
> + */

OK so I see this is used as a handler in:

static exit_handle_fn arm_exit_handlers[] = {
	...
	[ESR_ELx_EC_GCS]	= kvm_handle_gcs,
};

And as per the arm ref page, 0x2D == ESR_ELx_EC_GCS.

And it's always something being injected, so returning 1 (handled) is fine.

>  static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
>  {
> -	/* We don't expect GCS, so treat it with contempt */
> -	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -		WARN_ON_ONCE(1);
> +	if (!kvm_has_gcs(vcpu->kvm)) {
> +		kvm_inject_undefined(vcpu);
> +		return 1;
> +	}

OK so make it not-a-kernel-warning if unsupported...

>
> +	if (vcpu_has_nv(vcpu)) {
> +		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));

...And this is the L0 at physical EL2 -> vEL2 (in physical EL1) injecting a
synchronous exception.

So it seems to me the key point of the patch is to forward to nested
guests, hence the subject line :>)

> +		return 1;
> +	}
> +
> +	WARN_ON_ONCE(1);

And this is an 'impossible' case because it should have been handled
natively otherwise. So it's a bug in KVM if it ever happened.

--
Cheers, Lorenzo
