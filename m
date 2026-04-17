Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954CE2D0614
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 15:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776439314; cv=none; b=c8gxtHjYEmXCNrFi2r2yiE+ElzCMwKYpUGw4iR/vdb6HZFHgGL4HQTpvr7WhjlKSkZ8e1N6TEk2700dZe9d9gcHWJaJ3hVGsNo5s6wB40CtCiDpCASV59aoomGjLexO9xIROfbF9kA9OsA+o7aWXLolH7zt4nD59N4+0itlYPto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776439314; c=relaxed/simple;
	bh=cd9Rsv0Yx3PKYaozVpdSsPm7OsaRdQE/jXvlFpuAv/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iwDX4oTC8h7EbZVM/6E/E0v6vO7LzR3aiNpJTnAvfUwswUwGTjDoJHklgmeMZuRyos4Fu/7hyfA7oj8qFWQdFHE3takeZ/niRduEAhQJpVlu+j1cjKzYKaiORQK2DM/7AqjPbwU6Q3Z3UFLQYlFAD6jI3+Ocyq6o4uiyRiqTmYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bA15Bho5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bA15Bho5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B137615A1;
	Fri, 17 Apr 2026 08:21:40 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 690393F7D8;
	Fri, 17 Apr 2026 08:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776439306; bh=cd9Rsv0Yx3PKYaozVpdSsPm7OsaRdQE/jXvlFpuAv/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bA15Bho54g4VCuj9pYPPA7+hFZfzZUbnrJH5C19n0FE8HqDs2yRBIwRfH6LtVhP3v
	 bKSfThXWvKJ571R4wxK5wR8wIN8bK34EibsyaOD1V4iPyVdsrdJPYTns2XpeWfFkJs
	 khZMOzvY7RJw3TOabdtP85AwRJlunvPH/a/T28Y4=
Date: Fri, 17 Apr 2026 16:21:40 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: Re: [PATCH 08/18] KVM: arm64: vgic: Rationalise per-CPU irq accessor
Message-ID: <20260417152140.GA3311048@e124191.cambridge.arm.com>
References: <20260415115559.2227718-1-maz@kernel.org>
 <20260415115559.2227718-9-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415115559.2227718-9-maz@kernel.org>

On Wed, Apr 15, 2026 at 12:55:49PM +0100, Marc Zyngier wrote:
> Despite adding the necessary infrastructure to identify irq types,
> vgic_get_vcpu_irq() treats GICv5 PPIs in a special way, which
> impairs the readability of the code.
> 
> Use the existing irq classifiers to handle per-CPU irqs for all
> vgic types, and let the normal control flow reach global interrupt
> handling without any v5-specific path.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 3ac6d49bc4876..b697678d68b01 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -106,24 +106,23 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
>  
>  struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid)
>  {
> +	enum kvm_device_type type;
> +
>  	if (WARN_ON(!vcpu))
>  		return NULL;
>  
> -	if (vgic_is_v5(vcpu->kvm)) {
> -		u32 int_num, hwirq_id;
> -
> -		if (!__irq_is_ppi(KVM_DEV_TYPE_ARM_VGIC_V5, intid))
> -			return NULL;
> -
> -		hwirq_id = FIELD_GET(GICV5_HWIRQ_ID, intid);
> -		int_num = array_index_nospec(hwirq_id, VGIC_V5_NR_PRIVATE_IRQS);
> +	type = vcpu->kvm->arch.vgic.vgic_model;
>  
> -		return &vcpu->arch.vgic_cpu.private_irqs[int_num];
> -	}
> +	if (__irq_is_sgi(type, intid) || __irq_is_ppi(type, intid)) {
> +		switch (type) {
> +		case KVM_DEV_TYPE_ARM_VGIC_V5:
> +			intid = vgic_v5_get_hwirq_id(intid);
> +			intid = array_index_nospec(intid, VGIC_V5_NR_PRIVATE_IRQS);
> +			break;
> +		default:
> +			intid = array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
> +		}
>  
> -	/* SGIs and PPIs */
> -	if (intid < VGIC_NR_PRIVATE_IRQS) {
> -		intid = array_index_nospec(intid, VGIC_NR_PRIVATE_IRQS);
>  		return &vcpu->arch.vgic_cpu.private_irqs[intid];
>  	}
>  

It preserves the behaviour of returning NULL for anything other than PPI on
gic-v5, because the fallthrough to vgic_get_irq() returns NULL for gic-v5 and
__irq_is_sgi() is always false for gic-v5.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
