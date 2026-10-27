Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793141593;
	b=KylHo8brY46TI6bNtYUwFn0HVQbtVV0kuLxb8x5V80K+XwvQYEWrVgABifV/6kpMfQQt
	 /G7pvq5ZqdvtZOQLSqAPjPJfulFd9c9ayfZaUtJ7wmeAoaiHt9ikRQpTqrWng3htps8XC
	 nXnP6Z0rcQPxUBkR72brTeRCOTnobRvU4u8xqtx2HmeNUmaD6+3WX7/a/l/UDTMkaJxVQ
	 pz1nLsb75sR8Tf2jAe6RqyuIEbmOLR7CrYzLhmYuSo6XAOFTXiNNntQZ53h7jyf3q6JyG
	 HJn3du2YZjfwaKKxkcmDC6VsggMX+Orxdpaa0aVMONarsDjhQ/5ZMMLnAVL+ymd0yZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793141593;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=04q4u1JObS7tfcOZudjA/sgn19SAKGmJTGwcBE/ecfU=;
	b=jVdo5ApbRpdWCwDPxOqZ3qt345GmjBOuy4iTef9uLrLcLDTvSJWMd0oYtoDf3H5Jh7eP
	 jgSceL7FVxKvrg7HmRMBtVYPFVrI71OvAFGFP+POb5fzCkQkWhR8msHBQuCDYJOhXrO5p
	 /qk8jQGeTpPZaBNpt9zwZAhdFADDn8e/VDG466ASlf5HGkJVn4tllBwCYmOYX7ZYR+vTy
	 yRenbM8Hz98b2sTTnuH1NADx0IaPG1KrLz50TgaGDJirG+ro5loNTO16zwGn0CWgN1LIZ
	 F6F50d3SLa+aoRP6W4zbW+G7vnQW4jXE40C8TIB7/WYTBvx7N6YfhLcDAUsSqM61wbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZyPwHfJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB7C606A31A;
	Tue, 27 Oct 2026 22:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZyPwHfJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0BE1F01825;
	Tue, 27 Oct 2026 22:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793141592;
	bh=04q4u1JObS7tfcOZudjA/sgn19SAKGmJTGwcBE/ecfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LZyPwHfJlZOQqN7z+uCWJxqmk/WseCQmRIEWIZieJinlbPG0BxcFttrx6TYYvowhQ
	 4NpdFkbWNvv206a/5UWnPBgvabhA16HufdbzlxGZJVzw1kQm1SnPl0jeRbh1eBKgHi
	 KC6K3mmbsR8uVx4AWC2hIkwKTYvddDDns2oMfHxQFbGIfdp+Nn0c5UhsronIwDbWjO
	 WuOKZ2VE8KhJo3JinG7Hv+74NABgd7NkYgXG9k6fWTdez5HSaC4bCe0kt53br1xErF
	 KpGBOYO1TXdEbxHCp8nAjYtUG5obptbAS/quITDHlJU1y2KIiSosxCIaplULhaidJ1
	 h1hiBEtteGksw==
Date: Tue, 27 Oct 2026 15:53:11 -0700
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
Subject: Re: [PATCH 2/2] KVM: arm64: vgic-v4: Don't allocate vPEs when
 userspace clears nASSGIcap
Message-ID: <auErVwVAwtT-y9Hf@kernel.org>
References: <at-saZT_ixQxsZIr@kernel.org>
 <20261027073634.440288-1-fuad.tabba@linux.dev>
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
In-Reply-To: <20261027073634.440288-1-fuad.tabba@linux.dev>

On Tue, Oct 27, 2026 at 07:36:34AM +0000, Fuad Tabba wrote:
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 5913a20d83019..a60697238a7a7 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -48,7 +48,7 @@ bool vgic_has_its(struct kvm *kvm)
>  	return dist->has_its;
>  }
>  
> -bool vgic_supports_direct_msis(struct kvm *kvm)
> +bool vgic_supports_vpes(struct kvm *kvm)
>  {
>  	/*
>  	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
> @@ -58,7 +58,12 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
>  	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
>  		return false;
>  
> -	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> +	return kvm_vgic_global_state.has_gicv4 && vgic_is_v3(kvm);
> +}
> +
> +bool vgic_supports_direct_msis(struct kvm *kvm)
> +{
> +	return vgic_supports_vpes(kvm) && vgic_has_its(kvm);
>  }
>  
>  bool system_supports_direct_sgis(void)
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index ed236f083f0d7..0a4b9a74425b4 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -248,7 +248,7 @@ int vgic_v4_init(struct kvm *kvm)
>  
>  	lockdep_assert_held(&kvm->arch.config_lock);
>  
> -	if (!kvm_vgic_global_state.has_gicv4)
> +	if (!vgic_supports_vpes(kvm))
>  		return 0; /* Nothing to see here... move along. */
>  
>  	if (dist->its_vm.vpes)
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index b71d486ae5145..7fc29a395a7db 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -500,6 +500,7 @@ static inline bool vgic_host_has_gicv5(void)
>  }
>  
>  bool system_supports_direct_sgis(void);
> +bool vgic_supports_vpes(struct kvm *kvm);
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  bool vgic_supports_direct_sgis(struct kvm *kvm);
>  
> 
> Tested on the FVP (GICv4.0 and GICv4.1): KVM doesn't leak doorbells in
> either patch's case, a GICv3 VM still gets its vPEs when the ITS is
> created, and the reproducer above doesn't hit the WARN. Does that work
> for you? If so, I'll send it as v2.

Bugh... Thanks for de-crapifying my request.

Yes, this works perfectly for me.

Thanks,
Oliver
