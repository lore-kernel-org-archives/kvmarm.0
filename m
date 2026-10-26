Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041945;
	b=hHB2UlH9d4vxWd/6WROwTgTJROcWnEveRZi7/s/ukyM5th0XY0XXdZUqC57E2+Dt6NW8
	 xKFOOBqSJlZMPgFOKEB+XWUIGaxL+9LR7EoKarcwc69Jbr/fB860jgCPLvhiodL/hBvfY
	 AWb4LleLvTvTdf7bXo6J2i8CBsITurx+neQ9NGVoZQ+kfbDVcNG2t5yrWRagXP8Onyula
	 5UW2b7kh5m3YJjiTy1qzulQlAnwd35S15k3Mue3NV7zZJReSH4GZMyBD91HJs8Vm+FOI3
	 7QqCzdn07GOzzRkmx7Cd1ULUtNg/NFcgQWAZQDfNknIMme5tyihj+hl1et7/v4sUujA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041945;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=/xdSDdeNwO4oLUk3isMtVnIVH6TEXIfV4gp7YgJ8B1k=;
	b=iqrnissL9EU6rS3eDWY0njWKiiZ21gQixvMQWwwTB0q0G0YPJd3pfPw7awLE88dcgw5c
	 I5w8q7+AoKOYoNK7AAQK6Ciuw8M91w7SSPENDnqLfTov7n8uc32TYObi1nmxvejfw10Yc
	 +ttMDFIKZfC5mExtrdEWPsB7u8GDAkxdN6vz44/lEZbd3hb+xuJ+rzB9289eEpK15xsp9
	 gbWdkM3VOzcI/okSCngmDEOcZaSqKDESUaUjfuxioE6/yLjT1+dybCd9Zs7M90FYhDGy4
	 Zj+wqQOHHg0j9QMby9L+yQurMT+ajveKyq9eA7iJ5/JeE1eckMzm6RZunPrt2FM0cKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Gvl/U9ym";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C642606A31D;
	Mon, 26 Oct 2026 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gvl/U9ym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A191F01825;
	Mon, 26 Oct 2026 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793041945;
	bh=/xdSDdeNwO4oLUk3isMtVnIVH6TEXIfV4gp7YgJ8B1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gvl/U9ymGmD76EDO8gM1idS4m2xm2nI+zYFCJ02a5UHiKYkdMkYM89OkW7lpaQ7zI
	 kOjq7yrAq+hFHOVpyuqNGqTkvCTKIJGt55YdMDWL1LX3T6SUwB0clNHjiAXtbefSA6
	 wVZMhfp4HvGIbtEYIpajRqW5OGW4vf/JJyTNLQ6Nc3W7Jps1ujwvQIf/dULCm63oJK
	 om0DQbzTvw2LiMx2QuidllGglTAbWkrVI2d/pJkCrmBt+slX6elHe1Cr1NewXJ++5X
	 BjyTwYkAsKqdRi6sCPJ3kkzYhoNGnlYTIpwCe8dL4DKo+6Kn14Bqikqh9mL6vusfJf
	 HKH0VAw9U0y8w==
Date: Mon, 26 Oct 2026 12:12:23 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: vgic-v4: Don't allocate vPEs for a GICv2
 VM
Message-ID: <at-mF3Qvq67Nh_v5@kernel.org>
References: <20261026152639.3926498-1-fuad.tabba@linux.dev>
 <20261026152639.3926498-2-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026152639.3926498-2-fuad.tabba@linux.dev>

On Mon, Oct 26, 2026 at 03:26:38PM +0000, Fuad Tabba wrote:
> KVM can run a GICv2 VM on a GICv4.0 host whose CPU interface supports
> legacy operation.

I'm pretty sure there's no IP out there that has GICv4.0 and legacy
mode...

> Such a VM has no LPIs and never uses vPEs, so
> vgic_supports_direct_irqs() is false for it and kvm_vgic_dist_destroy()
> never tears them down. However, userspace can still create an ITS for
> it. Once the vgic is initialised, vgic_its_create() calls
> vgic_v4_init(), which allocates the vPEs and requests a doorbell IRQ for
> each vCPU. They're then never freed, and each doorbell handler stays
> registered with a vCPU that's freed with the VM.
> 
> Only allocate vPEs for a GICv3 VM.
> 
> Fixes: 74fe55dc9ab77 ("KVM: arm/arm64: GICv4: Add init/teardown of the per-VM vPE irq domain")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-v4.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index ed236f083f0d7..a01de4de608a6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -248,7 +248,7 @@ int vgic_v4_init(struct kvm *kvm)
>  
>  	lockdep_assert_held(&kvm->arch.config_lock);
>  
> -	if (!kvm_vgic_global_state.has_gicv4)
> +	if (!kvm_vgic_global_state.has_gicv4 || dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)

use vgic_is_v3() instead

Thanks,
Oliver

>  		return 0; /* Nothing to see here... move along. */
>  
>  	if (dist->its_vm.vpes)
> -- 
> 2.47.3
> 
> 
