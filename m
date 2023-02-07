Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0DD28EA
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 12:22:27 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso13026414wmp.3
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 04:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U4270KcmhwHObRXxbA6duIgRVQX8U4dTBfwyE3BlZU4=;
        b=EfsjtE0KTvihG8YYYBF4VD2b0uiK8ecgj2vKvntsbMhJtsIWIWTNFruWmUDCBV0WEc
         VQDl6xb7KdZkw38DeQ8M+SSeZRo+0J9h2v4/upBxP7QwLEZUKbapi2zytKGiA2RGdOOb
         2Klp0gnA6W6S4g7RlzFUd3oppk3kB8e3j8kAeU6hH7nVKCbC5Qxb5BZ7HWp7xFfQtMPu
         dkZoL+hM6iKa/MQ7Wd2k01p6bwHhf52rITtpKo5YJaHhptjGckMCR13YDVtJb1Dy5Yhu
         QknexDea1iqpEt0GIbPb0WNuyzkHOaMsjgQy0yPQGKNeF5wANoFWK7IIeeJHnNfXt4GB
         blDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4270KcmhwHObRXxbA6duIgRVQX8U4dTBfwyE3BlZU4=;
        b=Mk3fULDDWmvxbV80ZZyOmCogRF094HKCuGUTttRLhh9/tpsk6K/GC7Gg/Yu92ZPucE
         7TQNDgBndF9zgE4XYrc0LKvBNbBPObyb+PKZNm1egY3nfH2FJXwp26qfPshjHcjJlPDS
         K6CiPFLJE+Bd4R+c55prCObEyOJIIK0btxkV5KYZnHi7/vOAs73P7R8bxOae4YhYZr8G
         M/7DYdr1l9zGdSRa5wpQax4xLArhzNHKtbCFBSpYXLQJ8ptcjrXp7sXwA93bOipbnLZx
         GPI2GlrrRD/EKo6Fx4QENXCcTg+2sY3RR+gLNy6UTzuGCq5bDUU2MVrvQL1z+Fuoptqj
         whuw==
X-Gm-Message-State: AO0yUKWOdjULpgQguZNyHqCtlAFsV9KhDY7gfyN0D0+9Yiy4BoeNrHEK
	7wBpA8IsJA2Af6pQkVyBLM7f/g==
X-Google-Smtp-Source: AK7set/3HW35lwoBV8fAb2W9wTUyuQE7iLTrg1JNxyIV1kCvHLvpXKVcMLTI0ZrBnoT7/ByKLVuOnQ==
X-Received: by 2002:a05:600c:3b88:b0:3df:f3ce:be48 with SMTP id n8-20020a05600c3b8800b003dff3cebe48mr113836wms.7.1675772545732;
        Tue, 07 Feb 2023 04:22:25 -0800 (PST)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id p12-20020a5d48cc000000b00241fab5a296sm11013595wrs.40.2023.02.07.04.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 04:22:25 -0800 (PST)
Date: Tue, 7 Feb 2023 12:22:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 09/45] KVM: arm64: pkvm: Add
 pkvm_create_hyp_device_mapping()
Message-ID: <Y+JCPLyan2y2TGph@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-10-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-10-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:52:53PM +0000, Jean-Philippe Brucker wrote:
> Add a function to map a MMIO region in the hypervisor and remove it from
> the host. Hypervisor device drivers use this to reserve their regions
> during setup.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/setup.c      | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> index d5ec972b5c1e..84db840f2057 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
> @@ -27,5 +27,6 @@ int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
>  				  enum kvm_pgtable_prot prot,
>  				  unsigned long *haddr);
>  int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
> +int pkvm_create_hyp_device_mapping(u64 base, u64 size, void __iomem *haddr);
>  
>  #endif /* __KVM_HYP_MM_H */
> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
> index 629e74c46b35..de7d60c3c20b 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -259,6 +259,23 @@ static int fix_host_ownership(void)
>  	return 0;
>  }
>  
> +/* Map the MMIO region into the hypervisor and remove it from host */
> +int pkvm_create_hyp_device_mapping(u64 base, u64 size, void __iomem *haddr)
> +{
> +	int ret;
> +
> +	ret = __pkvm_create_private_mapping(base, size, PAGE_HYP_DEVICE, haddr);
> +	if (ret)
> +		return ret;
> +
> +	/* lock not needed during setup */
> +	ret = host_stage2_set_owner_locked(base, size, PKVM_ID_HYP);
> +	if (ret)
> +		return ret;
> +

Do we need to unmap in case of errors from host_stage2_set_owner_locked?

> +	return ret;
> +}
> +
>  static int fix_hyp_pgtable_refcnt(void)
>  {
>  	struct kvm_pgtable_walker walker = {
> -- 
> 2.39.0
> 
