Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE962571C2
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752505096; cv=none; b=VsPvAV5f0Kg3GcWJV6yFlbQIDeGNMiB77GWiknA3UyYs/zo5pxrCrzo8YB2/oJoGVTJXF5q1IBENSKqOeepy4ozSsj/gKeZG1KlWmIeTeaJTkzi0AeNRFB4WnS3BuVEcEeetQ6+QtZUGOedkLPrXur09iwC8n1mDlt4oMOqNDvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752505096; c=relaxed/simple;
	bh=RTq2l9DOJocn6t/vLz2QlioXD03iMgpS0TCKWHOPKb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F5F0y4OZdj30QN8JWY4Zp4zTJsUXtD5/b2/yArhn5Eapd58s7xPc5o9FcWquOPtiYBFKqa3qRro5qrl12kmePGCaYLjnxCU+xV5GxewiH3Ro2tm0NbnAMMrbbn36hFRASoP1RBQS/MAfDl25f3y0Zf7BpUUe5c34r+Hlbp5wViY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DoaG0Qau; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DoaG0Qau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752505093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bQPE8d+FaA2yVmYGq+SKbVlX0UPjnfjK5gOcz7yLZqE=;
	b=DoaG0Qau5ShG+qJZzBnnpqMKuDeKxETS7bd/MjTkbZ2uNCIBepBiLN0cudbKlvg8jGT2Kf
	s+1v9Bw8kki/0YdqM255cY8kb9le6aXOzaMZPgGQcwAkLjRpCVhL53hTMEhibo6EtYXlxk
	DgiPTWgyCrgiadmYsQ5pslvjy1hUNlo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-H0xL8_xrN9OuZNeSybgfnQ-1; Mon, 14 Jul 2025 10:58:12 -0400
X-MC-Unique: H0xL8_xrN9OuZNeSybgfnQ-1
X-Mimecast-MFC-AGG-ID: H0xL8_xrN9OuZNeSybgfnQ_1752505092
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455f79a2a16so22063055e9.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 07:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752505091; x=1753109891;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bQPE8d+FaA2yVmYGq+SKbVlX0UPjnfjK5gOcz7yLZqE=;
        b=rLeF257h00ELsWUhR6cUIOAnuXFSJcjtUbdA0zHbj7P6kMDdL5ILiTD+EUjVJGSUJS
         d4madPNOCkkBDJwtgRQysW19B9wVw/69lZP6v5Im0jxqzM/iepRY09gGTMdB43ZZAx6m
         K84/aHCKtZmb8BQrUEPxsYJCoSdPBXP/6QEjxZLxZzXdNjywdmEKjJRflcfVcoQv8NCp
         VCjbv6ugCS8L3YKQ3V5JZtoiDlYFXyPqfiMOCr4OD+2USWOemi0eFpVTOSJslnMhltSv
         VHxVbXFAMN6PTeb+aqFuhKt+NkTY3PzgXzMdMTC8h09s/Vjj/wWk3L0vHl6I+qTj1nsN
         zyIA==
X-Forwarded-Encrypted: i=1; AJvYcCXxV2GXTMUP8+bN3nMuqJZwOTBzirHDudw/dHxh2JqEjh3MuKdTI2xcFJkDz0G9Q8Duo/LvKVM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcrCas2As2deuY1rLA/U/Zhzfnz1dN3YwP4Ac1I8KTbCFfUrnY
	FgFsIEFhTgzZivIMyXh/Oay7730aj9NjprR6voQzKSDlV2iwbNRb9lCRaUVhytQ81daeNYCBet7
	j+hP45FNOXtDylmf+/aqYRmOGckfq8Do31MLck8mcaPKW2HHoJKWePSIAnA==
X-Gm-Gg: ASbGncvM4EsMBsaeLxwhPnt22h0QHNqRp4nuoNyysV5fCBobQlRW4yN3Ri2dLI3vs3e
	dZtEkZEiNeK9u0Iv3ls1SrPxJhWGFLsc3pvmqcr+xidPmWaBBMD4VGBAuqUE54Q8Icuxxi76h+6
	1Xr1RyW3pKhsGAyfc+FGxU+kVavymX/BQzdLE/yNOO6/EI1oLkDZHz/PuVj3b8zpjs1wc5ei4b6
	wilQQrFFrWQBPvvJoCVHgJAGXWWiMHAQ8VxGa0LSY5EEfm1V65rsTibHBuErB/9jXZXAWgAmLsA
	49nXE2d06cdpn9dNgaMZeQ5J33Jrf1DY8srtULjMIsv5al+9W83fECPGySjN8Ethdlsm8VNah6z
	8LCOq+A==
X-Received: by 2002:a05:600c:4684:b0:442:f97f:8174 with SMTP id 5b1f17b1804b1-454ec276b88mr135887295e9.18.1752505091150;
        Mon, 14 Jul 2025 07:58:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl4XhGNHt7LeUM0FJNptr8IYSNXZQoc8r7ckiRfPAM6u3ZPrzr5E5XrYi52kF9246wswih/A==
X-Received: by 2002:a05:600c:4684:b0:442:f97f:8174 with SMTP id 5b1f17b1804b1-454ec276b88mr135886825e9.18.1752505090364;
        Mon, 14 Jul 2025 07:58:10 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd1890sm12570601f8f.3.2025.07.14.07.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 07:58:09 -0700 (PDT)
Message-ID: <8a755010-17cb-42f3-845e-3ac14863849a@redhat.com>
Date: Mon, 14 Jul 2025 16:58:08 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] KVM: arm64: vgic-v3: Allow userspace to write
 GICD_TYPER2.nASSGIcap
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-5-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250709211417.2074487-5-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: I7vNyiGguQkyisnjEaHsxbFSuW9fU1_adsYMX7bP0Go_1752505092
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 7/9/25 11:14 PM, Oliver Upton wrote:
> From: Raghavendra Rao Ananta <rananta@google.com>
> 
> KVM unconditionally advertises GICD_TYPER2.nASSGIcap (which internally
> implies vSGIs) on GICv4.1 systems. Allow userspace to change whether a
> VM supports the feature. Only allow changes prior to VGIC initialization
> as at that point vPEs need to be allocated for the VM.
> 
> For convenience, bundle support for vLPIs and vSGIs behind this feature,
> allowing userspace to control vPE allocation for VMs in environments
> that may be constrained on vPE IDs.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c       |  3 +++
>  arch/arm64/kvm/vgic/vgic-kvm-device.c |  1 +
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 19 +++++++++++++++++--
>  arch/arm64/kvm/vgic/vgic.h            |  1 +
>  include/kvm/arm_vgic.h                |  3 +++
>  5 files changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 487e902b040c..80c07d5a7d7a 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -166,6 +166,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  	else
>  		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
>  
> +	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
> +		kvm->arch.vgic.nassgicap = system_supports_direct_sgis();
> +
>  out_unlock:
>  	mutex_unlock(&kvm->arch.config_lock);
>  	kvm_unlock_all_vcpus(kvm);
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index 15d9772a53c8..37beb6f32b3d 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -515,6 +515,7 @@ static bool reg_allowed_pre_init(struct kvm_device_attr *attr)
>  
>  	switch (attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK) {
>  	case GICD_IIDR:
> +	case GICD_TYPER2:
>  		return true;
>  	default:
>  		return false;
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 1a9c5b4418b2..1a24dde8ffdc 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -53,11 +53,16 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
>  	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
>  }
>  
> -bool vgic_supports_direct_sgis(struct kvm *kvm)
> +bool system_supports_direct_sgis(void)
>  {
>  	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
>  }
>  
> +bool vgic_supports_direct_sgis(struct kvm *kvm)
> +{
> +	return kvm->arch.vgic.nassgicap;
> +}
> +
>  /*
>   * The Revision field in the IIDR have the following meanings:
>   *
> @@ -163,8 +168,18 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
>  
>  	switch (addr & 0x0c) {
>  	case GICD_TYPER2:
> -		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
> +		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
> +
> +		if (reg == val)
> +			return 0;
> +		if (vgic_initialized(vcpu->kvm))
> +			return -EBUSY;
> +		if ((reg ^ val) & ~GICD_TYPER2_nASSGIcap)
>  			return -EINVAL;
> +		if (!system_supports_direct_sgis() && val)
> +			return -EINVAL;
> +
> +		dist->nassgicap = val & GICD_TYPER2_nASSGIcap;
>  		return 0;
>  	case GICD_IIDR:
>  		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index ebf9ed6adeac..96048ec59d0d 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -369,6 +369,7 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
>  int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
>  int vgic_its_invall(struct kvm_vcpu *vcpu);Reviewed-by: Eric Auger <eric.auger@redhat.com>
>  
> +bool system_supports_direct_sgis(void);
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  bool vgic_supports_direct_sgis(struct kvm *kvm);
>  
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 4a34f7f0a864..1b4886f3fb20 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -264,6 +264,9 @@ struct vgic_dist {
>  	/* distributor enabled */
>  	bool			enabled;
>  
> +	/* Supports SGIs without active state */
> +	bool			nassgicap;
> +
>  	/* Wants SGIs without active state */
>  	bool			nassgireq;
>  
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

