Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9872D29C8;
	Thu, 25 Jun 2026 13:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393407; cv=none; b=UQbyxIQYHkQ16+yTr5OO6kvoLWGzV+nbJKX7RpYvAQRhT/e1g9y5raEkmrUjq97L7Ia928OcPsWCnvadjqITyjW6YLZdHK797wdquk1UIZcSaQQtCmofELab8/blykS4rSrD9YsBO25vdog5CqnNaE56N4XlxNcQWcgL4VwH2vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393407; c=relaxed/simple;
	bh=r1Ujuj9y+OW8+P3gB0lSbn9j4JqYBEGFNwx5Q0U6skE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pRq59vJy9UbGSIyGAshibX79A6sYlxww8jb5Ebzi8VJvKyfSE1HyzT/0FNSZ+85dIaswxLLXN4L3/v4xTtHwltCsgkbJVlLg77FxYrgV4EHLVDI8w9WLoL3lbe1PI4lITqOhZOMUXjw3GwSsxOypxlUQpbJNWvzl26tYKbQzkZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7RNqNMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7RNqNMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BFD1F000E9;
	Thu, 25 Jun 2026 13:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782393406;
	bh=zyakJI5GD+PPIi44Smd0pGSoFVHMmc9YUMca9wIzM/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V7RNqNMtT8EQbl8j+mRtB5l3CkkFA8q8eOgYGPMBzwPHRtjhPy+Qwsk2m+rqWkrPq
	 iWQPr1L5YtnwkHmC7gUyUUIcQ3j9m+4DrqD62tOxbXA5j8kc75G56f1q84kfIsoB4E
	 LF+M2nGWlSOge7hXVNobOpw9S7KSCZ67i6c38EjryAbDGHgBVtHTM16eT27NAypvm7
	 HqcWL+hf6ZwajOgUBiy0KDluFFEQYUeSAGvekRvwDbjMrG0b6RKr8VlH+o5Btoyh85
	 pv0jGp9g6o9nNvSDUYQmf03mMdKYnugjiZvA8VnHwh+mwks4Z25LYWQC/PZ1teCmBk
	 NXx5wLl6LtSKg==
Date: Thu, 25 Jun 2026 14:16:40 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v5 1/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <aj0qOFO3pRA-U_mL@willie-the-truck>
References: <20260623115354.632361-1-sebastianene@google.com>
 <20260623115354.632361-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623115354.632361-2-sebastianene@google.com>

Hi all,

On Tue, Jun 23, 2026 at 11:53:48AM +0000, Sebastian Ene wrote:
> Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> arguments checking when the hypervisor acts as a relayer between the
> host and Trustzone.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 54 +++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..78bb043b33ee 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -71,6 +71,20 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
>  
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	int reg, end_reg;
> +
> +	end_reg = ARM_SMCCC_IS_64(func_id) ? 17 : 7;
> +	for (reg = first_reg; reg <= end_reg; reg++) {
> +		if (cpu_reg(ctxt, reg))
> +			return true;
> +	}
> +
> +	return false;
> +}

Seb and I tried taking this for a spin on some Android devices and, sadly,
it leads to fireworks. The reason is that the FF-A spec quietly changed
the list of unused parameter registers for 64-bit SMCs from v1.1 to v1.2
of the spec so that pre-existing calls were affected.

For example, in v1.1 a 64-bit RXTX_MAP only has x4-x7 as MBZ, whereas in
v1.2 the same call has x4-x17 as SBZ.

We can follow the spec by predicating the additional check on the FF-A
version being >= 1.2, but I'm not hopeful that existing drivers are
compliant. I also suggest moving this patch to the end of the series in
case we need to revert it.

Cheers,

Will
