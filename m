Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9B83BFE34;
	Mon,  8 Jun 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780936483; cv=none; b=aX7R7mKTnSMN69mMpcHefvYdeMwtAqGH7kKNB5JNUtHRdcG+kRcalkFe+pe6J9SPGChpjsdkqAFT6IW/QJU8wAfGRql7G7lqfVS4kdoa9HIZrPRFuR3xjjnjN8M+/GuuhGnffskCD39enfs2FmeZZLPuCFfHKuIGcdh3E87d1hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780936483; c=relaxed/simple;
	bh=AXU1tYv3i5R2n9viTtxuEdee5G6RbaLWkstzn8M3FoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNIzJ14eHlruQyLHwlhKilE1IqIocc16aRQBzQgWOCf9Zby1RFLnyemNbF5RFy6ooAIL3g8odr870kgqsIIMUWvNwpLnivcm5Gpc2nNgcz7wpD5Am4oxhR8cuuAVXo0BnAodUExewfSs9X//rULkPu0euR3G41oxv4pR70qXRiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBHtPgxU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBHtPgxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C459F1F00893;
	Mon,  8 Jun 2026 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780936481;
	bh=OQ/DKIjQTR/mHpvMcZ8ruGCqc0pKfen5cUvVayJUDP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KBHtPgxU6DA3m+t/qfjHS3nawDmc+4r6YTzCCMBYT5rtw3yoVBsda6CPjBJ++CpeO
	 aLUYPukZ19n04nmeT5MSKCn4y7LgnjqNZZRgw9f3UVl4InzLI96vqDBR+DD16ybG96
	 Lx6CEf9M5gQ7YtawbDbJEqJc40EyZpF4UmlJRNjF4Ugw4O7UEbZItrhLqOuQezE4kj
	 iVkcZeYkLTqRzu7i6dGEE3eOW7ljJITenX+2+T8PAbAivmOdXQ0VNGXCh61Z/Xit0N
	 ESQR/jztm0tNg9NqH0dM57M7C+mCSSk5tZdLJXLYsXC33s6lz6eejk5FgiCW7U6lLZ
	 q4WFXw0spz3/w==
Date: Mon, 8 Jun 2026 09:34:40 -0700
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Hold kvm->mmu_lock while initialising
 vcpu->arch.vncr_tlb
Message-ID: <aibvIDkOjCLkwkoW@kernel.org>
References: <20260608081108.2244133-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608081108.2244133-1-maz@kernel.org>

On Mon, Jun 08, 2026 at 09:11:08AM +0100, Marc Zyngier wrote:
> Sashiko reports that there is a race between initialising vncr_tlb
> and making use of it, as we don't hold the mmu_lock at this point.
> 
> Additionally, it identifies a memory leak, should userspace repeatedly
> invokes the KVM_RUN ioctl after a failure of kvm_arch_vcpu_run_pid_change(),
> as we assign vncr_tlb blindly on first run, irrespective of prior
> allocations.
> 
> Slap the two bugs in one go by taking the kvm->mmu_lock on assigning
> vncr_tlb, preventing the race for good, and by checking that vncr_tlb
> is indeed NULL prior to allocation.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20260607180815.85FBC1F00893@smtp.kernel.org

Reviewed-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver

> ---
>  arch/arm64/kvm/nested.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 690b8e8564166..d11e36b3cfcc2 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1253,8 +1253,14 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
>  	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY))
>  		return 0;
>  
> -	vcpu->arch.vncr_tlb = kzalloc_obj(*vcpu->arch.vncr_tlb,
> -					  GFP_KERNEL_ACCOUNT);
> +	if (!vcpu->arch.vncr_tlb) {
> +		struct vncr_tlb *vt = kzalloc_obj(*vcpu->arch.vncr_tlb,
> +						  GFP_KERNEL_ACCOUNT);
> +
> +		scoped_guard(write_lock, &vcpu->kvm->mmu_lock)
> +			vcpu->arch.vncr_tlb = vt;
> +	}
> +
>  	if (!vcpu->arch.vncr_tlb)
>  		return -ENOMEM;
>  
> -- 
> 2.47.3
> 
