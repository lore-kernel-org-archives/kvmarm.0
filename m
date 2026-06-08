Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC16390209;
	Mon,  8 Jun 2026 20:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780952128; cv=none; b=bjhSxrBC40tAJ4Es/amlOAgcP/A/DjlliNmrKPWYITWACUkvCpHA1csnYwU4Atln74YT80Avt5myxEu08RuC/+RfHMIO7lrdOkhrgLoVwK8XT48QGgGqG8R4egnH0mcHOUNCuPih40aLKjP//fs3CghvCwLWKeyinzhYu8I7xQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780952128; c=relaxed/simple;
	bh=4QBxR2PjlCKAPSvgpGacW2SShPc026qHj1QCYdxzg90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQAYNqalSfvEJe3iQdsB0xvsZM7thSc+4vFVzbGkMBle77cw+50Lhua6X9jngKr0qfDc8k1UGfX2SNzeqyekEWqfApoXDN3+Xb5hEJDleWk4la+1q07G/Rm4HO21CE4oP1azJlubNFXWtJxV0TJd70Xc9RGmmzVk+TWHwzrwiBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFipMoev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFipMoev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40F31F00893;
	Mon,  8 Jun 2026 20:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780952127;
	bh=Ww3MgvoKXBDrHgnorb3FWeSCZJO6ATl+G8SETSPUBWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EFipMoevJToto3v2ysvCUrVS+ZNcPWf2WkIrdRmxt6ajG+mXOU7ZP7q3TcvhOXUNC
	 qDfIs4f6CVWVFDfukXhxcsi/z9+8I8fEfyFVJnAeINqz3tyQMRRFDbbbKp/nRssbgA
	 earCd0m4XpdT4x8esC01HGbXgpiz6mh4mF3UOURLcb8ccWt9Y5LeMFE82GAF4h587o
	 g8vcrJMcuWtAqheTqHipclyaiAj3LetvPhcdqHqhdA/aU+XDY07vfcLivY4PLDfrlX
	 CiMKzToPz8DcjfRwSAhGFz14sWZ+TkdYlvucSh/vYWnhrYREtBF9Fb2cHsVBOs8V1R
	 uoL19+LlBq3JQ==
Date: Mon, 8 Jun 2026 20:55:25 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Hold kvm->mmu_lock while initialising
 vcpu->arch.vncr_tlb
Message-ID: <aicqzM4W4NN-GndT@google.com>
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

(I am not familiar with this code at all, so apologies in advance if I
am making an idiot out of myself here)

IIUC, the point of holding the lock here is *not* to protect against
concurrent initialization, as in this case the NULL check needs to be
done under the lock.

Rather, the goal is to prevent re-ordering of zeroing from kzalloc and
the assignment to vcpu->arch.vncr_tlb, by depending on the barriers
provided by the lock. The lock is held by the readers so holding it here
conviently means we do not need to add any barriers to the readers.

Is my understanding correct?

If yes, I think the code looks confusing, at least to a layman like
myself. It initially seems like the lock protects against concurrent
initializations, but then the NULL check is not done again under the
lock. The goal of the lock is not clear without the original report.

Mayeb it's clearer to explicitly use barriers if the goal is preventing
reordering?
