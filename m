Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B036E37F010;
	Thu,  3 Sep 2026 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788452626; cv=none; b=h5IqoqPEPvajS0wSDE/v9ocYdSNgVJ1VcuBwiJZWYdzErmOrU03V2If/qVQVQQ+JmU/sgDuOoDnxnP8kOB0xYUO8GGt0oZD475+uXA3N8OYK7NZBR5edRDTF2w8V2emhGW/ddV+MyPtOhi9/Vkz8kZWogr7FNuLZ9gfuehobjeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788452626; c=relaxed/simple;
	bh=JBd7I4/fg7dczN/LdTDewIzecH/B/oek1+sXV+5jo+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgSrsJHyWKd7Dca++nfWkMcc/+jHn+tITYXbVLjcERZrwuv6pB8cHgR5V8Q7a4F9qDP0l2ctewSaata0ym3dk051JP08eG2pESnSfeWumRI1TYN1A0ggxDI6VX1vSV4QHugQRp5jhZDxbKbzCCAChIzo/g2cbg9gaYpoNsPamWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlg0F1E0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlg0F1E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0B61F000E9;
	Thu,  3 Sep 2026 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788452625;
	bh=PDu19BjiI9AhkjE5BIfUBslC9MAuLaoj6YB1o1XS/ZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hlg0F1E0VCrtl/SDZ8Eode7rB/skCUp1JgvIBAx6yBzM9pnGYY2hhZdxzGgmIkjKc
	 zDGwVMntVC6G7YM24UgUB+xTVeyL0swXoVBpk51V6uBWdjTQaTs10olHtbwMx6+Piv
	 AZ0o2F6wxCamWCeGKw5hOqWcg98oxW2PNBRbYDHUcRcXWtIFrZCu8uvGmMlhC0icaz
	 bfoywEMZTn2hAltlYZ50yZUo08BmBFb6zhMDPGDWLdUFHdr9f/wpGeMXTuO9r9N/My
	 PTKnaNxz7Wu+M+Jgv4icSs12riikr8UwqExehgxVgPf6coilEFtxAmioXmzpoMuh17
	 Zm2wACI1ZgEwg==
Date: Thu, 3 Sep 2026 17:23:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v20 02/14] KVM: arm64: Fix FGT mapping for
 HFGITR_EL2.nGCSEPP
Message-ID: <apmcDT8YTjS6eXE0@gremlin>
References: <20260901-arm64-gcs-v20-0-f31750bdfadb@kernel.org>
 <20260901-arm64-gcs-v20-2-f31750bdfadb@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-arm64-gcs-v20-2-f31750bdfadb@kernel.org>

On Tue, Sep 01, 2026 at 10:47:00PM +0100, Mark Brown wrote:
> The encoding to trap mapping currently maps a FGT on OP_GCSPOPX to
> HFGITR_EL2.nGCSEPP but as per DDI0601 2026-06 this FGT controls trapping
> of GCSPUSHX and GCSPOPCX, and not the separate GCSPOPX instruction.
> Update the mapping to reflect the architecture.
>
> Fixes: 863ac38984a82 ("KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt")
> Reviewed-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/kvm/emulate-nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index 625604019fb3..3806ff0920fe 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -1445,7 +1445,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
>  	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
>  	SR_FGT(OP_COSP_RCTX, 		HFGITR, COSPRCTX, 1),
>  	SR_FGT(OP_GCSPUSHX, 		HFGITR, nGCSEPP, 0),
> -	SR_FGT(OP_GCSPOPX, 		HFGITR, nGCSEPP, 0),
> +	SR_FGT(OP_GCSPOPCX, 		HFGITR, nGCSEPP, 0),

Yikes, yeah I see from the doc I referenced in 1/14 that that's the wrong
instruction ([0]).

I guess this wasn't visible before in any case because 9/14 is required to
actually enable this in practice?

>  	SR_FGT(OP_GCSPUSHM, 		HFGITR, nGCSPUSHM_EL1, 0),
>  	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
>  	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),
>
> --
> 2.47.3
>
>

[0]: https://support.arm.com/documentation/111107/2026-06/AArch64-Registers/HFGITR-EL2--Hypervisor-Fine-Grained-Instruction-Trap-Register

--
Cheers, Lorenzo
