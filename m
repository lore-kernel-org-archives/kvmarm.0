Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31218134A8
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752504114; cv=none; b=WBUu0bYp/la6E94/kMCimAZBUnoIxALlIXEzMNnffRKgZsf5iH0CEwzmBHbA9hoGS/HPFrnqkLAQCqFMIf2I/bcCtHML8NBO8FQ/Urd0ejh1t8cp252VHD9f9n9aDVYB5Jn9mmVcTxcSRtjyP2ETiPnNAXYkN1t3ecut6YTlYXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752504114; c=relaxed/simple;
	bh=v8XHF7iLaKlEqkDTbzB2d02qxdNXiPKJ2V9YlCrPqjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=md4Z6XB2Ynp70ncatvwLZcjjf7OMgG8HYZVj8kuQuCvqCPnjC42r0iYg7kezucLLEpSh6nCHcgM+d67Ci2LZJxgHPaE1puR+684DOEuuwDAbvaDmlRChRR78jFRBpu/FZhXW25dxHYaFsworBuykK8hD9sLqYQYys/xdhAVpnGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LBiu/bj1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LBiu/bj1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752504112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtFbJIgJ5M1DAdgvetyqGm51/2QIe74QyLU/ajs1FG8=;
	b=LBiu/bj1BN72if9zOEhsV587+SVIg8wg7/2+N5p0/0Lle1B8hU/309qeH2E6NyUxcP9qAj
	DZ4tusIEcqolZeSqVWqxk2gEBQUpmA0rFzaTXLqVWmRx00Aoygl4gM4vZPbalNSx/RQaBL
	HBwAzIMp0MwQErUm9PxdEAQwLDqr2Og=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-C7-VbwAlOwW5T98FCwEnhQ-1; Mon, 14 Jul 2025 10:41:49 -0400
X-MC-Unique: C7-VbwAlOwW5T98FCwEnhQ-1
X-Mimecast-MFC-AGG-ID: C7-VbwAlOwW5T98FCwEnhQ_1752504108
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455e918d690so13845305e9.1
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 07:41:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752504108; x=1753108908;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xtFbJIgJ5M1DAdgvetyqGm51/2QIe74QyLU/ajs1FG8=;
        b=COwjQMRBE0ME1xJEG80FbWuZWsMOuTi7QrSa+GNf2k9YazURBvO5Z+QO8h8AiMMk0I
         48afzoBd0rOoO0FmXccrh7YWe5BT77Cquxgmr723IyvenrihrQeIu7DjHBnQzTyY/7sT
         L10aA8CVJZKBCWzOH3pex6W9dlID9uhSsisTzEngkYseHbdQcit5mQtkrW5HcJBc9+kd
         mkbkf83+NosxSm+hyeAjJqg3uK/ch+XP0HWpGt/h4qd6Z4zoPd/MzZT/2qSElNPZBbdO
         rdVtalssVMGAOmU03PnRKBY0Pp1ztYhvM7mg5MeJF7MRwg2xRb8XrRQVVmF/jLxBeGoo
         v8XQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxhJKDnRvHGRLS4xwmz/Q4Ds5GPjSBpADMrlWqv9q6Qf2i/zUP55EU+LziySQMyI2NIZWLUrA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzc830TwBMiaxpoZ6EtDCI6Tl/Ls+1TPFlZV7BPtG6DYB6J96fF
	UlqLgZ2ebzcTU2G1tQfaVxBuE4LjSyPQ9kO9LzV85bleBIdgVE7ev9ILMc7chy2Er78f6Xtp103
	ELZ7tH1XsuB6N+T/Tg8MbVaEkTmZFPbmqETEU8DlXPL/9SzXsD3Q2mjWtgQ==
X-Gm-Gg: ASbGncupO4thY3RdMnK8B+PjNXQc6Ki8wSZlSJl5S3FDLWQ1GUxw+RMfqQMh9BUVrga
	TMwPlBT6V9l/zaMnKNvSszFkxL8d9t8Tuk2e+2Cq5JLA5zrpMDoCC31FdvICRQcVfz9pv5I0X9l
	5/agq/C4IaqJLlght+QzZMTo+xQGmtvhQxjW0k9xqVS2R1lGdKu9uSsxwBmi4FFtIOmA6XWMZqX
	aY5o1bW5xgkCl8+haNK29g3PAH5xu2SG3OH0exY/VpOv7xRZ3NAt9lseOZujiBbp9Ci7BbTWn0k
	y8BQ8WaKZ4s08Jk0VykKBbUptw1mOPpFLgndPabvgPdNqRfArZiFVBu4yPsXfkHUHZYMPyoE30i
	1SFOUyQ==
X-Received: by 2002:a05:6000:1acf:b0:3a5:1388:9a55 with SMTP id ffacd0b85a97d-3b5e7f0a33emr13450949f8f.5.1752504107661;
        Mon, 14 Jul 2025 07:41:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB0N1NuHNhiYnu10IQsSBOjHgEvkcHKnjKRWlXiM/kiN/VFjUVaRqzO3htnt31VoLCMhlv1g==
X-Received: by 2002:a05:6000:1acf:b0:3a5:1388:9a55 with SMTP id ffacd0b85a97d-3b5e7f0a33emr13450929f8f.5.1752504107224;
        Mon, 14 Jul 2025 07:41:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d50ded8csm172281265e9.20.2025.07.14.07.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 07:41:46 -0700 (PDT)
Message-ID: <aeb76627-41b2-4550-9010-de90b679bfd4@redhat.com>
Date: Mon, 14 Jul 2025 16:41:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] KVM: arm64: vgic-v3: Allow access to GICD_IIDR
 prior to initialization
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Raghavendra Rao Ananta <rananta@google.com>,
 Zhou Wang <wangzhou1@hisilicon.com>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
 <20250709211417.2074487-4-oliver.upton@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20250709211417.2074487-4-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W8wMdLOye_rIOJL0DmeiGOquSodCAYL3lNf-Cmc8qUA_1752504108
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 7/9/25 11:14 PM, Oliver Upton wrote:
> KVM allows userspace to write GICD_IIDR for backwards-compatibility with
> older kernels, where new implementation revisions have new features.
> Unfortunately this is allowed to happen at runtime, and ripping features
> out from underneath a running guest is a terrible idea.
> 
> While we can't do anything about the ABI, prepare for more ID-like
> registers by allowing access to GICD_IIDR prior to VGIC initialization.
> Subsequent changes will allow the VMM to further provision the GIC
> feature set, e.g. the presence of nASSGIcap.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/vgic/vgic-init.c       |  9 +--------
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 20 +++++++++++++++++++-
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 5e0e4559004b..487e902b040c 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -157,6 +157,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>  
>  	kvm->arch.vgic.in_kernel = true;
>  	kvm->arch.vgic.vgic_model = type;
> +	kvm->arch.vgic.implementation_rev = KVM_VGIC_IMP_REV_LATEST;
>  
>  	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
>  
> @@ -409,15 +410,7 @@ int vgic_init(struct kvm *kvm)
>  		goto out;
>  
>  	vgic_debug_init(kvm);
> -
> -	/*
> -	 * If userspace didn't set the GIC implementation revision,
> -	 * default to the latest and greatest. You know want it.
> -	 */
> -	if (!dist->implementation_rev)
> -		dist->implementation_rev = KVM_VGIC_IMP_REV_LATEST;
The change related to KVM_VGIC_IMP_REV_LATEST looks unrelated to the
commit title/msg, isn't it?
>  	dist->initialized = true;
> -
>  out:
>  	return ret;
>  }
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index e28cf68a49c3..15d9772a53c8 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -5,6 +5,7 @@
>   * Copyright (C) 2015 ARM Ltd.
>   * Author: Marc Zyngier <marc.zyngier@arm.com>
>   */
> +#include <linux/irqchip/arm-gic-v3.h>
>  #include <linux/kvm_host.h>
>  #include <kvm/arm_vgic.h>
>  #include <linux/uaccess.h>
> @@ -503,6 +504,23 @@ int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
>  	return 0;
>  }
>  
> +/*
> + * Allow access to certain ID-like registers prior to VGIC initialization,
> + * thereby allowing the VMM to provision the features / sizing of the VGIC.
> + */
> +static bool reg_allowed_pre_init(struct kvm_device_attr *attr)
> +{
> +	if (attr->group != KVM_DEV_ARM_VGIC_GRP_DIST_REGS)
> +		return false;
> +
> +	switch (attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK) {
> +	case GICD_IIDR:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /*
>   * vgic_v3_attr_regs_access - allows user space to access VGIC v3 state
>   *
> @@ -552,7 +570,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
>  
>  	mutex_lock(&dev->kvm->arch.config_lock);
>  
> -	if (!vgic_initialized(dev->kvm)) {
> +	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
nit: !vgic_initialized(dev->kvm) && !reg_allowed_pre_init() is easier to
compute for me


Besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

>  		ret = -EBUSY;
>  		goto out;
>  	}

