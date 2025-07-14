Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB8A23E355
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 10:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752488423; cv=none; b=SCz7TpaSZLq5ogJg5bDROa/XSOlXvemRpceqe3/LUahJlWeXFGCSXlHqMfp5AuI7cCSh2CwHNzeWMas24PdHuLvLdL7205pbp1GrJDkB7H/cNnaC5485EbZmEHQm6aJ5Pnws3Z0M/W7F3TS7owjv21Dfza8j3N0LUwgUZ6KrgWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752488423; c=relaxed/simple;
	bh=TZDmu4ZScTEiHOWHBSY/dIgca+XuvV50OX+n9WXFPfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PtlN8e7RnHLrhVd+oVrB8J84Ki5LCNP8AcOTH2PsxygKz4XdlMfBiud3K/w2vBs2qpPnw03T6omjHPu6VLcNZv1CcybKqaV9TiE1/QJL1sU3hrscXHNr0s1AYEqHsIfhUvh9puKFOfa+05DKTuba0OpUUDInWfZxXoPNmxTaSK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZOSSHKBf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZOSSHKBf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752488420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxAG86TX5S4yT6mCk2qLIM6IfKCKIm7x7EKGbv+VKqo=;
	b=ZOSSHKBfEcOtjYCiQQJrwLFN91E3jWNYhg3fm2UbvHiFx/Ue5DeeolPtoB7wPX942NErJD
	emZCufnOO3S3Bak6ZiPNh6hCwt4kFlMfEBeF7/2bAyVnzVLFeC/hjqyBakTUst3SCHHThH
	BfWJmBOXizvd+/GLjnLNGr0OudAi5qo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-39BDdlXENeClq7UTh-uJCw-1; Mon, 14 Jul 2025 06:20:19 -0400
X-MC-Unique: 39BDdlXENeClq7UTh-uJCw-1
X-Mimecast-MFC-AGG-ID: 39BDdlXENeClq7UTh-uJCw_1752488418
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a6d90929d6so1854723f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 03:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752488418; x=1753093218;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jxAG86TX5S4yT6mCk2qLIM6IfKCKIm7x7EKGbv+VKqo=;
        b=ftymlotaux0sJJM9QGkn/3Sad5w6A3czX0bvG2fYyquQPwON7TnpRVRYspbrJuTnH0
         MJpDMrElVKcVia0FGRcFGFuKtUSUuwJXYg52PQH/IJsV7IV1qx7A/7OugCxFFnFoUIzd
         NRIhosu05iY9yw+1aAjHEoHMOXq8KIGEQf9YwC/S1OuR/8ZM6pbPOUR9X+J8s7ixPJRt
         lJKGDevxtwkODjhGAr2nrJjLQbiQ1wWP1jUISWRq101m7SWCwdjS9mO46Q5xLgv03B2I
         qTL+QURDGJgsc3qim81o+hW7sGtqYxz/gsH78TZUxjTqkRQGaJuaFFspwLnBR7bYgEUU
         OJYg==
X-Forwarded-Encrypted: i=1; AJvYcCW+/NJgBlmOuTty1Iz972nFQfGNGgYz5mfN1DHxJXfiMYmb3/E5tDHdbMqZbQYwnyLY+uQimtE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yymj70hgAfvydLjyFr+BF1zrraUOVt5+nR9fNjwyztE6+n3Ne/Z
	DBp3QSi7jUlrVJkabchoYWzBHpSDw+nqKg9ysK9O0HI4xrxsEDTOpUS31o1eJ1LJBhMPwaqrolK
	0uh5+1F13teQXbjf9Dl3QvrA6bLgncB8+4f+APBxHnOMOUMH3XbU7go1E+g==
X-Gm-Gg: ASbGncvaish0fy1jHN0nkJXum0JEPex9uvYVlsTWr2UQETZ9N+Z6DXWT7NvlXY+Huk6
	oL3veqYHAIopK7L7qnSXT3MMQDgBlkkmunKa8/GRDqtTuJIJ328jOGwuiODCbnRNb7KTauVeJaX
	pyjArAqpAjzqaFe0gaThrrEFDKFz/xFdD2OGm22AFFrhAPIcc/fhVhWF5FCVGGjxDD7GYE/WD4v
	Yp4nega0MBK0fBZBt/yToYft+z3W+VWOri+s2pi7oaYYoqWTaP7defakLnGwBitzFuwClt/v0co
	5spizrI55csSDLIxqKPTfh1Fq7l7ghWcLQcke7h1n8LaMR7w7zOalIeey58DzYrKosL1k2oewg2
	uTD4hDw==
X-Received: by 2002:a05:6000:1447:b0:3a6:d6e4:dffd with SMTP id ffacd0b85a97d-3b5f2dc2234mr9755560f8f.14.1752488417696;
        Mon, 14 Jul 2025 03:20:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHEJ+nym8yoRIht6eQd7eu75ctSOhoEcUeyPS/Z+Uu+DpnHIicXgrwfFb3COxTbwlRYeSrGyA==
X-Received: by 2002:a05:6000:1447:b0:3a6:d6e4:dffd with SMTP id ffacd0b85a97d-3b5f2dc2234mr9755523f8f.14.1752488417101;
        Mon, 14 Jul 2025 03:20:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8dc9268sm11929459f8f.41.2025.07.14.03.20.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 03:20:16 -0700 (PDT)
Message-ID: <50eee3a2-55d5-4128-8b42-47a37306b8a1@redhat.com>
Date: Mon, 14 Jul 2025 12:20:14 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] KVM: arm64: Disambiguate support for vSGIs v.
 vLPIs
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-2-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250709211417.2074487-2-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ga011c7uOOf7rLOfepgIZAP9MIicJCoFCkiuLpQ3sV4_1752488418
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ho Oliver,

On 7/9/25 11:14 PM, Oliver Upton wrote:
> vgic_supports_direct_msis() is a bit of a misnomer, as it returns true
> if either vSGIs or vLPIs are supported. Pick it apart into a few
> predicates and replace some open-coded checks for vSGIs.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
>  arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
>  arch/arm64/kvm/vgic/vgic.c         |  4 ++--
>  arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
>  5 files changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index eb1205654ac8..5e0e4559004b 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -395,7 +395,7 @@ int vgic_init(struct kvm *kvm)
>  	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
>  	 * enable it if we present a virtual ITS to the guest.
the above comment refers to vSGISs. While the below change looks OK, I
feel difficult to associate it to the code below.
>  	 */
> -	if (vgic_supports_direct_msis(kvm)) {
> +	if (vgic_supports_direct_irqs(kvm)) {
>  		ret = vgic_v4_init(kvm);
>  		if (ret)
>  			goto out;
> @@ -443,7 +443,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
>  	}
>  
> -	if (vgic_supports_direct_msis(kvm))
> +	if (vgic_supports_direct_irqs(kvm))
>  		vgic_v4_teardown(kvm);
>  
>  	xa_destroy(&dist->lpi_xa);
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index ae4c0593d114..1a9c5b4418b2 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -50,8 +50,12 @@ bool vgic_has_its(struct kvm *kvm)
>  
>  bool vgic_supports_direct_msis(struct kvm *kvm)
>  {
> -	return (kvm_vgic_global_state.has_gicv4_1 ||
> -		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
> +	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
> +}
> +
> +bool vgic_supports_direct_sgis(struct kvm *kvm)
> +{
> +	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
In some checks we now have "&& gic_cpuif_has_vsgi()" added whereas we
previously only checked kvm_vgic_global_state.has_gicv4_1. This may be
described in the commit message too and explain whether this is a fix
for some configs.

Thanks

Eric
>  }
>  
>  /*
> @@ -86,7 +90,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
>  		}
>  		break;
>  	case GICD_TYPER2:
> -		if (kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi())
> +		if (vgic_supports_direct_sgis(vcpu->kvm))
>  			value = GICD_TYPER2_nASSGIcap;
>  		break;
>  	case GICD_IIDR:
> @@ -119,7 +123,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
>  		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
>  
>  		/* Not a GICv4.1? No HW SGIs */
> -		if (!kvm_vgic_global_state.has_gicv4_1 || !gic_cpuif_has_vsgi())
> +		if (!vgic_supports_direct_sgis(vcpu->kvm))
>  			val &= ~GICD_CTLR_nASSGIreq;
>  
>  		/* Dist stays enabled? nASSGIreq is RO */
> @@ -133,7 +137,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
>  		if (is_hwsgi != dist->nassgireq)
>  			vgic_v4_configure_vsgis(vcpu->kvm);
>  
> -		if (kvm_vgic_global_state.has_gicv4_1 &&
> +		if (vgic_supports_direct_sgis(vcpu->kvm) &&
>  		    was_enabled != dist->enabled)
>  			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
>  		else if (!was_enabled && dist->enabled)
> @@ -178,7 +182,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
>  		}
>  	case GICD_CTLR:
>  		/* Not a GICv4.1? No HW SGIs */
> -		if (!kvm_vgic_global_state.has_gicv4_1)
> +		if (vgic_supports_direct_sgis(vcpu->kvm))
>  			val &= ~GICD_CTLR_nASSGIreq;
>  
>  		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index 193946108192..e7e284d47a77 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -356,7 +356,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
>  {
>  	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>  
> -	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
> +	if (!vgic_supports_direct_irqs(vcpu->kvm) || !vpe->resident)
>  		return 0;
>  
>  	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
> @@ -367,7 +367,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
>  	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
>  	int err;
>  
> -	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
> +	if (!vgic_supports_direct_irqs(vcpu->kvm) || vpe->resident)
>  		return 0;
>  
>  	if (vcpu_get_flag(vcpu, IN_WFI))
> diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> index 8f8096d48925..f5148b38120a 100644
> --- a/arch/arm64/kvm/vgic/vgic.c
> +++ b/arch/arm64/kvm/vgic/vgic.c
> @@ -951,7 +951,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  	 * can be directly injected (GICv4).
>  	 */
>  	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head) &&
> -	    !vgic_supports_direct_msis(vcpu->kvm))
> +	    !vgic_supports_direct_irqs(vcpu->kvm))
>  		return;
>  
>  	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
> @@ -965,7 +965,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  	if (can_access_vgic_from_kernel())
>  		vgic_restore_state(vcpu);
>  
> -	if (vgic_supports_direct_msis(vcpu->kvm))
> +	if (vgic_supports_direct_irqs(vcpu->kvm))
>  		vgic_v4_commit(vcpu);
>  }
>  
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 4349084cb9a6..ebf9ed6adeac 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -370,6 +370,13 @@ int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
>  int vgic_its_invall(struct kvm_vcpu *vcpu);
>  
>  bool vgic_supports_direct_msis(struct kvm *kvm);
> +bool vgic_supports_direct_sgis(struct kvm *kvm);
> +
> +static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
> +{
> +	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
> +}
> +
>  int vgic_v4_init(struct kvm *kvm);
>  void vgic_v4_teardown(struct kvm *kvm);
>  void vgic_v4_configure_vsgis(struct kvm *kvm);



