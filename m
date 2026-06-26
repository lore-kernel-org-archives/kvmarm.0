Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41218286415;
	Fri, 26 Jun 2026 09:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782465083; cv=none; b=FtVLhbOxSRrfgBFzIS2bZJYnoYyOupm2OtvX+ATwMREMMQ7vOS6URkq0xXyGWbHc8cWSAhrjgq72IgpwfhUCpa4RL01TQuLvob2m1F6/h6tnnn9oejoSLtHLbzL9shs8qpj+dGOnYPuqMD69l0AqhhfTGNd97RGGNwRA6639J88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782465083; c=relaxed/simple;
	bh=4PCMt3omVbcRN9o/qsE4F3WHuuoUWV6jOHWchoJBgoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7GUIdX3eBI6tn5HWIMUeoIHownFfoAgjb5Zniitrm7UBIDUft6sqZUqdqyhhHw7tjo6UaKNO40mR/DBjg/+XlDJLp7aBmyhAhRLWb7jj1p9XaArMjHY5l+t1bW2BpEXC5WqSBNDZPtPM6jpWRKiRIcOCz0YJIyC9zUo/HucZZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fo5SDURM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fo5SDURM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673391F000E9;
	Fri, 26 Jun 2026 09:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465081;
	bh=pA6ANVNRahG4M8H0EzLwtjvJO6D9L1tq/SMvgZGvxjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Fo5SDURMny5tovLJ1rjldIVlET7xcvGvD4yNr1ZArm65N5c4bcLN9MuYIYUzKKxDg
	 WkrPAptCQuxPji4utdJ4ANcP5SXh/pCB3DdgafbulfuT/eAddupZrIUE2flc2wrTlz
	 Pz9ru7Vn0qhdagu225b7bqXu9cJWz9Dfhtlu9MWuXlzUsageN396y4CMsOyGUgAgum
	 FD7hBS69whCDqntzsy4QcWAqwd1k75rDkra4g4dQ/P5NHegV/z58HU4O4TgVUwlGwz
	 WFojdZ4MoB7DlDmsAQ0pmwfaJS18yHFnUxAunR93dSAMgcbpUoQmvv4wOPBZmSsuR3
	 /1jbGUnYvVVNQ==
Date: Fri, 26 Jun 2026 10:11:14 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v6 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <aj5CMsyQ25xuxISV@willie-the-truck>
References: <20260626074545.433234-1-sebastianene@google.com>
 <20260626074545.433234-8-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626074545.433234-8-sebastianene@google.com>

On Fri, Jun 26, 2026 at 07:45:45AM +0000, Sebastian Ene wrote:
> Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> arguments checking when the hypervisor acts as a relayer between the
> host and Trustzone.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 96 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 95 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 712811e89435..bd50ddc5b61c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -74,6 +74,21 @@ static u32 hyp_ffa_version;
>  static bool has_version_negotiated;
>  static hyp_spinlock_t version_lock;
>  
> +static bool ffa_check_unused_args_sbz(struct kvm_cpu_context *ctxt, int first_reg)
> +{
> +	DECLARE_REG(u32, func_id, ctxt, 0);
> +	int reg, end_reg = 7;
> +
> +	if (FFA_MINOR_VERSION(hyp_ffa_version) >= 2)
> +		end_reg = ARM_SMCCC_IS_64(func_id) ? 17 : 7;

This looks like an accident waiting to happen if we don't check the major
number as well.

I think you should just check:

	if (hyp_ffa_version >= FFA_VERSION_1_2)

instead.

You should also add a comment.

Will
