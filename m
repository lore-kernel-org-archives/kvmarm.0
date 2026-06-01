Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081551A6839;
	Mon,  1 Jun 2026 19:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780341378; cv=none; b=n9mScDmOJRz70ExkPYlTzcB6EQZ+x8s2lXSYZwOeZqOW+E0v+CbAaTG/Ay/dv+lQL7dMl2a6jN2uOnSpVZ3/PDIBf6HO4LJToiXMYT1wHlbUAvS2wsEP5b9lmjeV3j5fodm6zDtmrDcdlw0XYM2u0C03eMEwd5Q7Op4vLduprVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780341378; c=relaxed/simple;
	bh=FxeW2c/mt7wpZrOO29SwSdnzqoiGNt2hqOTlkGEbPE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fm8w2krEeTjl+f7Uch4bqO/Wy3YAWh3+RFxkL78MW0e9bXVQ9RtkAve+jdmGX1rVQP1L5pT3ph3vtktzWVFr8alwbL8u71fEH0iOBWQg0BOBMjSJFbyrKcxZjkyrjy+lr8McIqWN/TxRdMr3KLgdVzVIyFTFRLBVOCdrhhqMBhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erERrhzw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erERrhzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D951F00893;
	Mon,  1 Jun 2026 19:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780341377;
	bh=3Py+hXu1RT6jBoYKS4W+9qHiEMV6Utt4FtLuxKrveNs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=erERrhzwbrBFn4Q6+juSPsSdsefRY/T0KH39K7jN9NHt1RIMTWFGqzmulVPhAbAzm
	 hZ/yPZivbJgaJwBPKGoqxmAm2F6eFiW0XBaciJfyRMiVF5+SkgJZpY2+9YsJbbCqoo
	 TiuiKT5L/ImCZM/GNai0IjM25SGU/o/1IwMOCpxjqWQW6cDnjgb74FfidHZ95Zf6hb
	 skqPiA91AoESwFEWnujFugJECfLJqKM5U93A/v+M9h58S5w3mUWEFsj/TwrX19GxNo
	 XG0DLAJ7Yzd4KsiVeBgooMeodrhIA+e1gup3TTSdpM/BRokj3De0SN45Cb+WZomn93
	 4RJzKRCwrHKMg==
Date: Mon, 1 Jun 2026 12:16:16 -0700
From: Oliver Upton <oupton@kernel.org>
To: tabba@google.com
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Flush HCR_EL2.VSE to deliver SErrors to pKVM
 guests
Message-ID: <ah3agGh1s61HKiPG@kernel.org>
References: <20260531154548.1505799-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531154548.1505799-1-tabba@google.com>

On Sun, May 31, 2026 at 04:45:48PM +0100, tabba@google.com wrote:
> With pKVM enabled, the host injects a virtual SError by setting
> HCR_EL2.VSE on its vCPU copy, but flush_hyp_vcpu() only flows TWI/TWE
> into the hyp vCPU that runs, so VSE never reaches it and a deferred
> (masked) SError is never delivered. VSE is a host-owned injection
> control, not a trap-configuration bit, so restricting the host's
> trap-register values should not have dropped it. Flow it on entry;
> sync_hyp_vcpu() already copies hcr_el2 back, so delivery is reflected
> to the host.

Might be worth mentioning that flush_hyp_vcpu() also forwards VSESR_EL2
from the host since that bit is _just_ out of context of this diff :)

> Fixes: b56680de9c648 ("KVM: arm64: Initialize trap register values in hyp in pKVM")
> Reported-by: Sashiko (local):gemini-3.1-pro
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
> Not an urgent fix. I should stop running Sashiko...
> ---
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 06db299c37a8..9e4a20df6409 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -129,9 +129,14 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
>  	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
>  
>  	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
> -	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
> +	/*
> +	 * HCR_EL2.VSE is host-owned (a pending virtual SError to inject), not a
> +	 * trap-control bit, so it must flow to the hyp vCPU alongside TWI/TWE
> +	 * for the vSError to be delivered. sync_hyp_vcpu() reflects it back.
> +	 */
> +	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE | HCR_VSE);
>  	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &
> -						 (HCR_TWI | HCR_TWE);
> +						 (HCR_TWI | HCR_TWE | HCR_VSE);
>  
>  	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
>  
> -- 
> 2.54.0.929.g9b7fa37559-goog
> 
