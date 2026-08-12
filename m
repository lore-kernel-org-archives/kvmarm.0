Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530AA43F0A6
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 13:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786540462; cv=none; b=r6D4mXiy6HXtb5k+LHFDlSHC313dUxB4TvX6Mx+48bS5t8/GRrWtoZ0G6yEltVcuisP7aFBLr+V8O1SsUpI0s0gfkZWvKUr9PoH/N2iASNtdyQ+sIptF7WUolRMm1Pa02o98QxalGLMMlZGh+lrFH3U+869pKcyOgWF8AeznqjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786540462; c=relaxed/simple;
	bh=/Mr3bC5Q8kCOVh3qoyQ0+5KAEKLL04lUmM0yK72ZsaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZYcmvUDe8t11t/P282YWG3g2NcknTURgMtxVyUfC3sUd/un8axjwuFuP51rX1mSGA8qn5MqK7DIiuLUSqzKKUr8urXz2wDedSMHktYMEzV/SRRnw6Y/ghDEFZ1HCTvKiAm/reo/9wyD/qRRJY7Rrjdb08LaJ6kXbH1+DcbEqTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nl/S3OSB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nl/S3OSB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB356153B;
	Wed, 12 Aug 2026 06:14:15 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30E993F882;
	Wed, 12 Aug 2026 06:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786540459; bh=/Mr3bC5Q8kCOVh3qoyQ0+5KAEKLL04lUmM0yK72ZsaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nl/S3OSBZQYuw8kfWWZek0nQBIb6s5Yv1EF1NRuOmse06XTEn/PLthNmNCn3ohugU
	 ohBQvbkJuyUPQHXtOku21faVOi7O4lq5pVAeC3HuhwFbqQviO9DU3sYMWYYrtk/TKJ
	 DBT+XcUuD3e/1W2wJY0IIgW9gmID8rUR/wMHhODQ=
Date: Wed, 12 Aug 2026 14:14:15 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd <nd@arm.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>
Subject: Re: [PATCH v2 1/4] KVM: arm64: vgic: Free gic_kvm_info on
 initialization failure
Message-ID: <anxxpxy6JXeyI2X9@e143914.arm.com>
References: <20260811150941.941295-1-sascha.bischoff@arm.com>
 <20260811150941.941295-2-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811150941.941295-2-sascha.bischoff@arm.com>

On Tue, Aug 11, 2026 at 03:10:17PM +0000, Sascha Bischoff wrote:
> vgic_set_kvm_info() allocates gic_kvm_info for use by
> kvm_vgic_hyp_init(). When a maintenance interrupt is mandatory but not
> provided, kvm_vgic_hyp_init() returns -ENXIO before reaching the
> common cleanup path, leaking said allocation.
> 
> Route this error through that cleanup path so that gic_kvm_info is
> freed and the global pointer is cleared.
> 
> Fixes: 0e5cb7770684 ("irqchip/gic: Split vGIC probing information from the GIC code")
> Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff@arm.com?part=1
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 907057881b26a..65e203d6a2cf4 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -787,7 +787,8 @@ int kvm_vgic_hyp_init(void)
>  
>  	if (has_mask && !gic_kvm_info->maint_irq) {
>  		kvm_err("No vgic maintenance irq\n");
> -		return -ENXIO;
> +		ret = -ENXIO;
> +		goto out_free;
>  	}
>  
>  	/*
> @@ -820,6 +821,7 @@ int kvm_vgic_hyp_init(void)
>  
>  	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
>  
> +out_free:
>  	kfree(gic_kvm_info);
>  	gic_kvm_info = NULL;
>  

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
