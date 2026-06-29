Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEED40DFA5;
	Mon, 29 Jun 2026 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782742640; cv=none; b=G3JZuUt5f72QRsqIiy1ERaE4szKH9DRm6l652WrFQRYIJX2pXEMlixGj0qkzTSxwzZ+B5xfiLuyyGRHFJY6H5o0eMmn8jkSyZ4yQ+vmReAmsj5p7joxxV6gw2/onpto9+Lr7BisbmvQeAAmfPjzeCgfRviZM3e3GZRAUP07kRYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782742640; c=relaxed/simple;
	bh=90gcL8hBTH3A7fEQyB2mW0muWF5XFEJDaOXxV04p5fU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iUrfkSLY/E4d+mwdGWJ7eqvuj9Wx9Dgnkk1UJ7V+pb96LH6HKA+nunDmu0jc3pRR7KrfDLNWtOpMIXKFw47xR8PQptCRcERn5PnhARlBxcAj/x9Ex2K5pW+0e7bSFuoRwFAWXWh8n49RCsVDq1dqkW+qrVb8oVndHSxzHJ+QfLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g17YYQ9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g17YYQ9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1961E1F000E9;
	Mon, 29 Jun 2026 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782742638;
	bh=S6bK/PN6A/7QZziIgNdwB0ThmToPDxMxFw3ywyUt3A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g17YYQ9pShtzfDZmFAtSORwWhh7WRru09j5kEv143sgw1CPB709Xa8Pg9UA/LG6sL
	 XMpq93KvOEctM9jhvR7f66zxvwTD398LBH8CcoL8ig5FR6igJbFYFNawq9Er1nGV6M
	 br0hRKbVV7WEWXphm1TsfXvDOz1kOSp7zNY8fF/UgP+jvlPD4SvWInKvwzB0F6kzlA
	 BPZ2hTfqE73zf/nEnMCZP7ltT/Ks+rDqEaRbupe5upQb1/5ZNWm8602zIpbJZc27yV
	 FoBoK0H2gHY9vgsfc6bWIVyx+Wc16Y3P926JTUs0L72tEAQLMiAibYjW6Plzcnqr3E
	 Iil0vBwYg8HUg==
Date: Mon, 29 Jun 2026 15:17:12 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v7 7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A
 proxy
Message-ID: <akJ-aNK7yWTI__RE@willie-the-truck>
References: <20260629093558.2425257-1-sebastianene@google.com>
 <20260629093558.2425257-8-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629093558.2425257-8-sebastianene@google.com>

On Mon, Jun 29, 2026 at 09:35:58AM +0000, Sebastian Ene wrote:
> Introduce a helper method ffa_check_unused_args_sbz to enforce strict
> arguments checking when the hypervisor acts as a relayer between the
> host and Trustzone.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> Acked-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 96 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 95 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 712811e89435..334f8a28d942 100644
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
> +	if (hyp_ffa_version >= FFA_VERSION_1_2 && ARM_SMCCC_IS_64(func_id))
> +		end_reg = 17;

Sashiko gets angry about this check, but I don't think we need to change
anything. Yes, there is a data race on hyp_ffa_version if you issue
FFA_VERSION concurrently with itself, but FFA_VERSION is a 32-bit call
so it's all moot.

In fact, a 64-bit FFA_VERSION would be problematic for other reasons,
because a single (non-racy) CPU trying to attempt a version downgrade
could end up passing non-zero values in registers that SBZ in the running
version (of which it knows nothing about).

So my Ack stands.

Will
