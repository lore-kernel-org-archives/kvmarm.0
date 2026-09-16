Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE49D4B0CBA
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 11:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789556472; cv=none; b=CKt6uFVeBsxd2bTE4poFuXx030rpMQJmZQ1D9dXXfrH19+JqUnKVb4dLb159eklVRdTz/FQ92efgVjicphDqfx1QWalc2oEbffJI4AelNl10R5XcUUFNBmFGB0Wkyr8TuXag7Y4DqiaVTKTqL9DUj6s51QNUKnswJEmwxhMsFU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789556472; c=relaxed/simple;
	bh=le64yFWu89IwQTgKsaA74r4GubOSVodhBlaIxBJsy1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dPqY3ZY+PgqWZ+Do1IvYleleYpZP41hSF1vY+cqSm765STKczTT+bP+huh8xRxQKjsz9rl/nfFrd8qNobqe3/5JAihw4rsqquESm1/dz2V7/3ppf5uUykIHf9fG/PPJ2nmtzVQ0Gbk050WFKiLCRrAE9AdqOhNFLf4exuBiKBAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VeHro92U; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VeHro92U"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45062152B;
	Wed, 16 Sep 2026 04:00:56 -0700 (PDT)
Received: from e143914.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C886E3F882;
	Wed, 16 Sep 2026 04:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789556459; bh=le64yFWu89IwQTgKsaA74r4GubOSVodhBlaIxBJsy1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VeHro92U0oRR3vwxd1JwJpCnnmvxSmWT5qbm9wVCD7uvApw8F7Ka2crYiiXwI/uTp
	 vYgQG5zxs0l8zCLSiKde0WIau2Hjc31y+np0XjwrxTCwkutglwEtnOahfk5+ISkDxT
	 ywM/0JFHlDAknHew+79UxH+X+H1IL6vXMKYOgB44=
Date: Wed, 16 Sep 2026 12:00:52 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	vdonnefort@google.com, qperret@google.com, Sascha.Bischoff@arm.com,
	steven.price@arm.com, tabba@google.com
Subject: Re: [PATCH 3/7] KVM: arm64: Validate the host-provided vgic model in
 pKVM
Message-ID: <aqp25JLeqyCKtCQH@e143914.arm.com>
References: <20260915123846.2317931-1-fuad.tabba@linux.dev>
 <20260915123846.2317931-4-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915123846.2317931-4-fuad.tabba@linux.dev>

Question(s)
   |
   |
   v

On Tue, Sep 15, 2026 at 01:38:42PM +0100, Fuad Tabba wrote:
> EL2 copies vgic_model from the host's struct kvm unchecked, and the nVHE
> world switch dispatches on it with no cpucap guard. A host writing
> KVM_DEV_TYPE_ARM_VGIC_V5 makes EL2 access GICv5 CPU interface registers
> that are UNDEFINED without FEAT_GCIE, and panics the hypervisor on any
> GICv3 machine.
> 
> Accept only GICv3, the one model pKVM supports, forcing anything else
> to 0.
> 
> Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 459bd9eb7e4bc..4c33c863e90e1 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -340,13 +340,19 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
>  {
>  	struct kvm *kvm = &hyp_vm->kvm;
>  	unsigned long host_arch_flags = READ_ONCE(host_kvm->arch.flags);
> +	u32 vgic_model = READ_ONCE(host_kvm->arch.vgic.vgic_model);
>  	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
>  
>  	/* CTR_EL0 is always under host control, even for protected VMs. */
>  	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
>  
> -	/* Preserve the vgic model so that GICv3 emulation works */
> -	hyp_vm->kvm.arch.vgic.vgic_model = host_kvm->arch.vgic.vgic_model;
> +	/*
> +	 * GICv3 is the only model pKVM runs, and the GICv5 world switch
> +	 * touches registers UNDEFINED at EL2 without FEAT_GCIE.
> +	 */
> +	if (vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
> +		vgic_model = 0;
> +	hyp_vm->kvm.arch.vgic.vgic_model = vgic_model;

A bit confused by what is expected by writing 0 here? I would have maybe
expected to refuse running this VM? What happens if the host writes some
garbage here, so vgic_model=0, but then tries to access gic-v3
registers?

Thanks,
Joey

>  
>  	/* No restrictions for non-protected VMs. */
>  	if (!kvm_vm_is_protected(kvm)) {
> -- 
> 2.39.5
> 
