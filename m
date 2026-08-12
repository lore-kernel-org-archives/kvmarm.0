Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCB433A6E9
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 12:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539233; cv=none; b=fBALUJJqee/SLdBdlQaIrwcLjgkaRrlyNTqaAfhd2NisEJl++pQHD5MpFB2p3uYddevb0ATsdnIqMlS7ooaBdpBTrfBoVGrGMWXSY0dRJgXke2D4LrLJMd5GfXMbKspEiWc/V/kpUvDyP34V2VXSYPaPSgsRgABStBF3LcTpxLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539233; c=relaxed/simple;
	bh=Nsey5we6rIhYyiJ87M7AhJFBPy6Qd1JEoFQxTIJhaY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJkGmvb4rqfcjVZ/lt8eFD9TbtnP9ng0e12sPiyvhynLa4Suca1drHvpLVOwvzYcPcDNxMhE2kQq8hWluKev2OO4XNPn21oAxJbwSOCWsHojfluF+ndmOz+1KtrEtDy+lwGhLc+GU2m9LBOaMpExAzM23FiXEshfUgaowLpfYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QS9svdAB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QS9svdAB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EE401596;
	Wed, 12 Aug 2026 05:53:46 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC3303F632;
	Wed, 12 Aug 2026 05:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786539230; bh=Nsey5we6rIhYyiJ87M7AhJFBPy6Qd1JEoFQxTIJhaY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QS9svdABJ7Q7clDrd//faRMSGmsQiRrjhxaocMz0cbDDTn+rOE7PwoHvcJWprFwrs
	 AG+ifvva752QB+fPVJ8NZacgBX+ptPGpcXZr9lBUZC3fklqmfezltGCVDkxxI+pzTq
	 TEC8QvpfAOaf1zEqKg+SQf6ra0gPAitmbunC927Y=
Date: Wed, 12 Aug 2026 13:53:43 +0100
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
Subject: Re: [PATCH v2 4/4] KVM: arm64: Validate GICv5 timer PPIs before
 claiming ownership
Message-ID: <anxs1yj3Qbv2JkTf@e143914.arm.com>
References: <20260811150941.941295-1-sascha.bischoff@arm.com>
 <20260811150941.941295-5-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811150941.941295-5-sascha.bischoff@arm.com>

On Tue, Aug 11, 2026 at 03:11:48PM +0000, Sascha Bischoff wrote:
> With GICv5, timer PPIs use architecturally defined IDs, and therefore
> we require userspace to use the architected IDs too. We perform this
> validation in timer_irqs_are_valid(), which validates the configured
> PPI after claiming it with kvm_vgic_set_owner(). This is obviously the
> wrong order, and could both result in a NULL pointer dereference for
> an ID >= 64 and in an incorrect ownership claim.
> 
> Switch the order to first validate the PPI before setting the
> owner. This both prevents an invalid GICv5 timer PPI from reaching the
> IRQ lookup, and avoids claiming an IRQ for a timer configuration that
> will be rejected.
> 
> Fixes: 06c85b58e0b1 ("KVM: arm64: Move GICv5 timer PPI validation into timer_irqs_are_valid()")
> Link: https://sashiko.dev/#/message/20260810111614.DDC731F000E9%40smtp.kernel.org
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/arch_timer.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 4155fe89b58a1..af7e2894cd690 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1529,13 +1529,14 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *vcpu)
>  
>  		ctx = vcpu_get_timer(vcpu, i);
>  		irq = timer_irq(ctx);
> -		if (kvm_vgic_set_owner(vcpu, irq, ctx))
> -			break;
>  
>  		/* With GICv5, the default PPI is what you get -- nothing else */
>  		if (vgic_is_v5(vcpu->kvm) && irq != get_vgic_ppi(vcpu->kvm, default_ppi[i]))
>  			break;
>  
> +		if (kvm_vgic_set_owner(vcpu, irq, ctx))
> +			break;
> +
>  		/*
>  		 * We know by construction that we only have PPIs, so all values
>  		 * are less than 32 for non-GICv5 VGICs. On GICv5, they are

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
