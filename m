Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A65F23B612
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 13:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774445297; cv=none; b=G5WX+pFyLnJ378TUGkexVuYV0ZtLN1bozDJ4Ydda+0oOaTjC1niq7oKv84ppPuJfvhioMMPfdg0qYxYjuE9gizMWIfWU9WIltNi7J7GOPZAihSnU45K/KJSDAE+Mld/5SW3DyM6c7JwAX67h5IY5ki05JR/RgMa1G9KzmZ1AAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774445297; c=relaxed/simple;
	bh=30zKMFL8Hb0ceqS8MaQ+b2fIKFZMYlPT6yAmBpIOQwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LU3QbsDSigKtl9JgSo+1NMys3ItK+XpOd9Nhi5Vip1Yj4tfBt1GhsIv1A9ibsgYp9k6PpD1+Iwa4JXwwVf3q3br1cn6ZaKg+4YqYnjuAd6KrGU0y3oDVpJ7tGPjbZWTceDYAMvNFUMGmi1a+LHFmrCJ8jMK7m4tKlXVz+foJXTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N6UmJBNt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N6UmJBNt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 686AD1CDD;
	Wed, 25 Mar 2026 06:28:07 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70B933F836;
	Wed, 25 Mar 2026 06:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774445293; bh=30zKMFL8Hb0ceqS8MaQ+b2fIKFZMYlPT6yAmBpIOQwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N6UmJBNt60706+y9MrrRwyLpyd1XQt65m4hcN5XnYV3ccYUakDUhR8c1KjFnRTSfN
	 rVDPql8iQic0bVnutRf2caoji8aL7CD6uPW3v/N8RXq4nKEzXU0dDMCVXOw+MnQshD
	 /lP7wJGEWvo4+vdk5cpZSDjPf1DoIs6lbMnRqmbc=
Date: Wed, 25 Mar 2026 13:28:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, maz@kernel.org,
	oupton@kernel.org, suzuki.poulose@arm.com, tabba@google.com,
	vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH v2] KVM: arm64: Prevent the host from using an smc with
 imm16 != 0
Message-ID: <acPi5V0DgGcgHNGO@J2N7QTR9R3>
References: <20260325113138.4171430-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325113138.4171430-1-sebastianene@google.com>

On Wed, Mar 25, 2026 at 11:31:38AM +0000, Sebastian Ene wrote:
> The ARM Service Calling Convention (SMCCC) specifies that the function
> identifier and parameters should be passed in registers, leaving the
> 16-bit immediate field of the SMC instruction un-handled.

That's not quite right; the SMCCC spec says callers must use immediate
0.

See https://developer.arm.com/documentation/den0028/h/ section 2.10
("SME and HVC immediate value"), which says:

| • For all compliant calls, an SMC or HVC immediate value of zero must be
|   used.
| • Nonzero immediate values in SMC instructions are reserved.
| • Nonzero immediate values in HVC instructions are designated for use by
|   hypervisor vendors.

> Currently, our pKVM handler ignores the immediate value, which could lead
> to non-compliant software relying on implementation-defined behavior.
> Enforce the host kernel running under pKVM to use an immediate value
> of 0 by decoding the ISS from the ESR_EL2 and return a not supported
> error code back to the caller.

From my PoV, it'd be fine to turn a non-zero immediate into an UNDEF:

* For HVC, we can say any non-zero immediate represents a request to KVM to
  inject an UNDEF.

* For SMC, the dbehaviour is not defined.

I am also ok with returning a value in x0, BUT that's stronger than SMCCC
actually requires.

Mark.

> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
> v1 -> v2:
> 
>  - Dropped injecting an UNDEF and return an error instead
>    (SMCCC_RET_NOT_SUPPORTED)
>  - Used the mask ESR_ELx_xVC_IMM_MASK instead of masking with U16_MAX
>  - Updated the title of the commit message from:
>    "[PATCH] KVM: arm64: Inject UNDEF when host is executing an
>     smc with imm16 != 0"
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index e7790097db93..4ffe30fd8707 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -762,6 +762,12 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
>  		handle_host_hcall(host_ctxt);
>  		break;
>  	case ESR_ELx_EC_SMC64:
> +		if (ESR_ELx_xVC_IMM_MASK & esr) {
> +			cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
> +			kvm_skip_host_instr();
> +			break;
> +		}
> +
>  		handle_host_smc(host_ctxt);
>  		break;
>  	case ESR_ELx_EC_IABT_LOW:
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 
