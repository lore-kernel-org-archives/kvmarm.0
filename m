Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586531DE4C9;
	Tue, 29 Jul 2025 15:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753804025; cv=none; b=fgIyPyT/AW4jGFjahWjk5gLuLHJRKrneiRe59z41TFZ4Xt8+leKcqSty43aRt/v66IbstKx0LAvzgvPRyt8SoGNKAnSqtrCRFAmB25XgMpHN5cjRNtwYCELAblZ8ci06TZh1pOr4r/ikaRgOcJ6aO+O1UqAljdZb7OC+4jPDLLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753804025; c=relaxed/simple;
	bh=asf759iARhCsqlW3LV9P1RiiwlEqeEAcEfX9/r8vZSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jpnO2j+UP0vwQePE3ponFiOYJSv2idj8zO/cdt9NXPJ9KrkSR1RlMg7LsY05gKBGtJF91Zyv6wTz35sQgY3vtI/UXxb99ncc6aRTqs0xsK1q/Hk/AAMNhZIlTzusbtoyFX+jQ2N+MtkxM91SMD5xDJKCxP4vF2X38fsdbuU2hW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i2DgZaQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2DgZaQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECC5C4CEEF;
	Tue, 29 Jul 2025 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753804024;
	bh=asf759iARhCsqlW3LV9P1RiiwlEqeEAcEfX9/r8vZSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i2DgZaQS6K3Vd6+mPAu9iGvuNRMCHZcr9QOs7zi3mtZ/f8s1gvwO0vy1CDZDba40p
	 FDUoNHvYXjZNzwchfQuacmVUX75jrVU6vkEndnGuv0bhr8/y55eJXEdvkQQdFqJYcJ
	 e7G98H90edHlHhCzx4/acrH+yRp2NHhVcvCPxvhiXrVpIUuW4KX4C28NUUs8lpcmtD
	 6WdKnq44DhRYOSKpjc0oQ7WPoc82VNIt/gP1mZNF3nVhDBnnLFxCegG/VbSeHuh9wd
	 OUFr+mMfae87IM6Tf4X2Tv55W2L+++e7QbSYDrS3BRP6iuYnHBhrJdMrB1avRrO9IZ
	 hiIGOLFkTQmHQ==
Date: Tue, 29 Jul 2025 16:46:58 +0100
From: Will Deacon <will@kernel.org>
To: perlarsen@google.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, ahomescu@google.com,
	armellel@google.com, arve@android.com, ayrton@google.com,
	qperret@google.com, sebastianene@google.com, qwandor@google.com
Subject: Re: [PATCH v8 5/7] KVM: arm64: Mask response to FFA_FEATURE call
Message-ID: <aIjs8p5Ti0pXbf2Y@willie-the-truck>
References: <20250719-virtio-msg-ffa-v8-0-03e8e8dbe856@google.com>
 <20250719-virtio-msg-ffa-v8-5-03e8e8dbe856@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250719-virtio-msg-ffa-v8-5-03e8e8dbe856@google.com>

On Sat, Jul 19, 2025 at 02:11:27AM +0000, Per Larsen via B4 Relay wrote:
> From: Per Larsen <perlarsen@google.com>
> 
> The minimum size and alignment boundary for FFA_RXTX_MAP is returned in
> bit[1:0]. Mask off any other bits in w2 when reading the minimum buffer
> size in hyp_ffa_post_init.
> 
> Signed-off-by: Per Larsen <perlarsen@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 2 +-
>  include/linux/arm_ffa.h       | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 5a173ea481940236356e2bc4248d094a858a0923..2cbecc9af5d27a9e7c8497001cf9b0987c72bdb4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -733,7 +733,7 @@ static int hyp_ffa_post_init(void)
>  	if (res.a0 != FFA_SUCCESS)
>  		return -EOPNOTSUPP;
>  
> -	switch (res.a2) {
> +	switch (res.a2 & FFA_FEAT_RXTX_MIN_SZ_MASK) {
>  	case FFA_FEAT_RXTX_MIN_SZ_4K:
>  		min_rxtx_sz = SZ_4K;
>  		break;
> diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
> index e1634897e159cdc208931938649eb0fb04d5a070..cd7ee4df9045dceca1c4e0dca2d533b770b1b056 100644
> --- a/include/linux/arm_ffa.h
> +++ b/include/linux/arm_ffa.h
> @@ -128,6 +128,7 @@
>  #define FFA_FEAT_RXTX_MIN_SZ_4K		0
>  #define FFA_FEAT_RXTX_MIN_SZ_64K	1
>  #define FFA_FEAT_RXTX_MIN_SZ_16K	2
> +#define FFA_FEAT_RXTX_MIN_SZ_MASK	GENMASK(1, 0)

Acked-by: Will Deacon <will@kernel.org>

Will
