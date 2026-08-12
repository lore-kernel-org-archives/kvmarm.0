Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DDE28D8D0
	for <kvmarm@lists.linux.dev>; Wed, 12 Aug 2026 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786542207; cv=none; b=Uo5a1JELmQV23pcf6O1/0rD/zHsM0VvVXMCGRBzYFMjkDt22bbhKwBrN8O/xeoqwEr/8AxBzcQq7lQF1bf+ebSxlhvzqoMbSvKkFCU01oD+kNsBTwTJQpAUkmjWD4bASWluUVUIUoGTUsl4kr6ceSKbAOIo5lGZdOjNYrWS3rJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786542207; c=relaxed/simple;
	bh=m/vxrrX8z+05JeaPz5hzIwTbbMakrEQQh0BPBp9z378=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRrlhVQMVk2N8DuwIDGQvsgKpx8r1OLlDm7YUHbNLtqCaFTjpGIX3YMWvnNTax02C62/pZIJdHDkqPPG+iQv1yJ6US8L1K6NHbkQl965JbrUpdCzF4rxtj/8KwJJgnIUmIlpmVm7XBzErizny0HM+bL6rY8623FiVqUEcK41r9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AQdi2E2r; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AQdi2E2r"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0BE16153B;
	Wed, 12 Aug 2026 06:43:21 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E4563F66F;
	Wed, 12 Aug 2026 06:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786542205; bh=m/vxrrX8z+05JeaPz5hzIwTbbMakrEQQh0BPBp9z378=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AQdi2E2ruUznlpNz9wyBxM5/1YHCirBSne1uR66NxfMMcJNEF4Qf4Nd/Pw8Mn8PKL
	 +KWqd8OsDnqzeXipkEOa+DCrZzgHsSe5AdxFZfVV3Fmt6XZoVlkFrFnmsL9H9WG7ej
	 fjjCOrunT0aa5yxbgZuMPrhzbHY0KYmB2cW0zKJI=
Date: Wed, 12 Aug 2026 14:43:21 +0100
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
Subject: Re: [PATCH v2 2/4] KVM: arm64: vgic: Prevent speculative SPI array
 underflow
Message-ID: <anx4eaMeaAumku9G@e143914.arm.com>
References: <20260811150941.941295-1-sascha.bischoff@arm.com>
 <20260811150941.941295-3-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811150941.941295-3-sascha.bischoff@arm.com>

On Tue, Aug 11, 2026 at 03:10:47PM +0000, Sascha Bischoff wrote:
> For a non-GICv5 VM, SPI interrupt IDs include the private-interrupt
> offset, while KVM's SPI array is indexed from zero. The lookup applies
> array_index_nospec() to the absolute interrupt ID and subtracts the
> private-interrupt offset afterwards.
> 
> On a speculative bypass of the range check for an interrupt ID below
> the private range, the clamp preserves the small absolute value and
> the subtraction underflows to an out-of-bounds SPI array index.
> 
> Convert the interrupt ID to a zero-based index into the SPI array
> before applying array_index_nospec(). This way, we ensure that we
> clamp to a reachable SPI ID, rather than an out-of-range SPI index.
> 
> Fixes: 41b87599c743 ("KVM: arm/arm64: vgic: fix possible spectre-v1 in vgic_get_irq()")
> Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff@arm.com?part=27
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 74bace10a22ed..352d52bd6315c 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -93,8 +93,9 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
>  	/* SPIs */
>  	if (intid >= VGIC_NR_PRIVATE_IRQS &&
>  	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
> -		intid = array_index_nospec(intid, kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS);
> -		return &kvm->arch.vgic.spis[intid - VGIC_NR_PRIVATE_IRQS];
> +		intid -= VGIC_NR_PRIVATE_IRQS;
> +		intid = array_index_nospec(intid, kvm->arch.vgic.nr_spis);
> +		return &kvm->arch.vgic.spis[intid];
>  	}
>  
>  	/* LPIs */

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
