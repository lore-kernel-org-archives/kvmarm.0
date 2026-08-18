Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8030391846;
	Tue, 18 Aug 2026 17:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075030; cv=none; b=fX6VidFR0f4dznkY5lRGnr+WKw5WOUBVO7WuWvKqsh5+6I92W3WZLSxJ8jJWEwldQ1I0Yoi1k/esEe221qKssNzjF0yD55Xnc2woPeYBwNq/cGA4wiZqf4csGM9p1RZ/pfFGq0LFPUcxAiaz9qHuncgXxDaZWvVE9IOCHY3s2FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075030; c=relaxed/simple;
	bh=g9hhg5cPvC+RxRbcs0YvetehpXxMGu9/BaUVLKzNfGE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=RsJ+jGT+goCkHQHtsurHmj4jOkk44vNuMW4yQ3PkHMI7OAB80aLKVNzTEBpEGqZwHfu+fUASmk57LLj37PzwTmSt3X07FSR9n881Y3yfBcm75XFwGYXUKn3QPZ9WPIC7MDe+S8CYSLHP+2wkhYo6I+Sq2t52gQPh/vDRAVAsO54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rjX6qxXK; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rjX6qxXK"
Received: from [10.4.158.9] (unknown [52.172.102.222])
	by linux.microsoft.com (Postfix) with ESMTPSA id 05DB820B7168;
	Tue, 18 Aug 2026 10:43:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 05DB820B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787075000;
	bh=71NdvjfhSL6mWbXOITNIsCZ1w+IRh7JItVsgMhRpEkI=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=rjX6qxXKPLUrCnMN1McoZtM73mCOfJ4Fn0nGlOK5iJqiMr5ENiHFn2JhekPFkd3vn
	 4/PLC6kleFnWZZWHFWuW5VOIZYrCJFRDAlbxvTwO+wzbRjsqtIvKBjc2VBHPfqCwCx
	 Wil1ZKEaNk2swisxYtKsJIM7qyhq/CHngHb8mICU=
Message-ID: <36877aa6-3f70-4da1-aecb-7209a33f8595@linux.microsoft.com>
Date: Tue, 18 Aug 2026 10:43:20 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kameron Carr <kameroncarr@linux.microsoft.com>
Subject: Re: [RFC PATCH v4 07/11] coco: guest: arm64: Add guest APIs to read
 host-cached DA objects
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jic23@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Samuel Ortiz <sameo@rivosinc.com>, Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
 <20260427082805.931832-8-aneesh.kumar@kernel.org>
Content-Language: en-US
In-Reply-To: <20260427082805.931832-8-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/2026 1:28 AM, Aneesh Kumar K.V (Arm) wrote:
> Introduce guest-side helpers to read host-cached DA objects
> (certificate, VCA, interface report, and measurements).
> 
> Add RHI_DA_OBJECT_SIZE and RHI_DA_OBJECT_READ definitions, then implement
> rhi_read_cached_object() that:
> - queries object size from host
> - validates size against MAX_CACHE_OBJ_SIZE
> - allocates a shared buffer
> - issues OBJECT_READ into shared memory
> - copies data into private memory and frees shared pages
> 
> Export the helper for later evidence-collection and verification code.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/include/asm/rhi.h             |  8 +++
>  drivers/virt/coco/arm-cca-guest/rhi-da.c | 71 ++++++++++++++++++++++++
>  drivers/virt/coco/arm-cca-guest/rhi-da.h |  1 +
>  drivers/virt/coco/arm-cca-guest/rsi-da.h |  2 +
>  4 files changed, 82 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
> index 2b56a7760904..dc7a57370945 100644
> --- a/arch/arm64/include/asm/rhi.h
> +++ b/arch/arm64/include/asm/rhi.h
> @@ -48,6 +48,14 @@ unsigned long rhi_get_ipa_change_alignment(void);
>  				 RHI_DA_FEATURE_VDEV_SET_TDI_STATE)
>  #define RHI_DA_FEATURES			SMC_RHI_CALL(0x004B)
>  
> +#define RHI_DA_OBJECT_VCA			0x0
> +#define RHI_DA_OBJECT_CERTIFICATE		0x1
> +#define RHI_DA_OBJECT_MEASUREMENT		0x2
> +#define RHI_DA_OBJECT_INTERFACE_REPORT		0x3
> +#define RHI_DA_OBJECT_EXTENSION_EVIDENCE	0x4
> +#define RHI_DA_OBJECT_SIZE		SMC_RHI_CALL(0x004C)
> +#define RHI_DA_OBJECT_READ		SMC_RHI_CALL(0x004D)
> +
>  #define RHI_DA_VDEV_CONTINUE		SMC_RHI_CALL(0x0051)
>  
>  #define RHI_VDEV_MEASURE_HASH	0x0
> diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.c b/drivers/virt/coco/arm-cca-guest/rhi-da.c
> index d0f5ae320f83..73c599802a93 100644
> --- a/drivers/virt/coco/arm-cca-guest/rhi-da.c
> +++ b/drivers/virt/coco/arm-cca-guest/rhi-da.c
> @@ -3,6 +3,8 @@
>   * Copyright (C) 2026 ARM Ltd.
>   */
>  
> +#include <linux/string.h>
> +
>  #include "rsi-da.h"
>  #include "rhi-da.h"
>  
> @@ -283,3 +285,72 @@ int rhi_update_vdev_measurements_cache(struct pci_dev *pdev, const u8 *nonce)
>  		pci_err(pdev, "failed to get device measurement (%d)\n", ret);
>  	return ret;
>  }
> +
> +int rhi_read_cached_object(int vdev_id, int da_object_type, void **object, int *object_size)
> +{
> +	int ret;
> +	int data_size;
> +	void *data_buf_shared;
> +	struct page *shared_pages;
> +
> +	*object_size = 0;
> +	*object = NULL;
> +
> +	struct rsi_host_call *rhicall __free(kfree) =
> +		kmalloc(sizeof(struct rsi_host_call), GFP_KERNEL);

"Unused bits of the RsiHostCall structure SBZ"

It's best practice to use kzalloc for struct rsi_host_call.

> +	if (!rhicall)
> +		return -ENOMEM;
> +
> +	rhicall->imm = 0;
> +	rhicall->gprs[0] = RHI_DA_OBJECT_SIZE;
> +	rhicall->gprs[1] = vdev_id;
> +	rhicall->gprs[2] = da_object_type;
> +
> +	ret = rsi_host_call(rhicall);
> +	if (ret != RSI_SUCCESS)
> +		return -EIO;
> +
> +	if (rhicall->gprs[0] != RHI_DA_SUCCESS)
> +		return -EIO;
> +
> +	/* validate against the max cache object size used on host. */
> +	data_size = rhicall->gprs[1];
> +	if (data_size > MAX_CACHE_OBJ_SIZE || data_size == 0)
> +		return -EIO;

Consider making data_size and object_size size_t (unsigned long) to avoid
truncation and signed comparison.

For consistency with cca_verify_digests() and pci_tsm_evidence_object.len,
I would also change all the sizes in cca_collect_dev_evidence() to be
size_t.

> +	shared_pages = alloc_shared_pages(NUMA_NO_NODE, GFP_KERNEL, data_size);
> +	if (!shared_pages)
> +		return -ENOMEM;
> +
> +	data_buf_shared = page_address(shared_pages);
> +
> +	rhicall->imm = 0;
> +	rhicall->gprs[0] = RHI_DA_OBJECT_READ;
> +	rhicall->gprs[1] = vdev_id;
> +	rhicall->gprs[2] = da_object_type;
> +	rhicall->gprs[3] = virt_to_phys(data_buf_shared);
> +	rhicall->gprs[4] = data_size;
> +	rhicall->gprs[5] = 0; /* offset to read from */
> +	ret = rsi_host_call(rhicall);
> +	if (ret != RSI_SUCCESS || rhicall->gprs[0] != RHI_DA_SUCCESS) {
> +		free_shared_pages(shared_pages, data_size);
> +		return -EIO;
> +	}
> +
> +	if (data_size != rhicall->gprs[1]) {
> +		/* Short read */
> +		free_shared_pages(shared_pages, data_size);
> +		return -EIO;
> +	}
> +
> +	void *data_buf_private = kvmemdup(data_buf_shared,
> +					  data_size, GFP_KERNEL);
> +	/* free the shared pages irrespective of error condition */
> +	free_shared_pages(shared_pages, data_size);
> +	if (!data_buf_private)
> +		return -ENOMEM;
> +
> +	*object = data_buf_private;
> +	*object_size = data_size;
> +	return 0;
> +}
> diff --git a/drivers/virt/coco/arm-cca-guest/rhi-da.h b/drivers/virt/coco/arm-cca-guest/rhi-da.h
> index d32ccc48c0d0..f7655d7ecf18 100644
> --- a/drivers/virt/coco/arm-cca-guest/rhi-da.h
> +++ b/drivers/virt/coco/arm-cca-guest/rhi-da.h
> @@ -13,4 +13,5 @@ bool rhi_has_da_support(void);
>  int rhi_vdev_set_tdi_state(struct pci_dev *pdev, enum rhi_tdi_state target_state);
>  int rhi_update_vdev_interface_report_cache(struct pci_dev *pdev);
>  int rhi_update_vdev_measurements_cache(struct pci_dev *pdev, const u8 *nonce);
> +int rhi_read_cached_object(int vdev_id, int da_object_type, void **object, int *object_size);
>  #endif
> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> index 297cb800edc0..88067d2230ab 100644
> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> @@ -10,6 +10,8 @@
>  #include <linux/pci-tsm.h>
>  #include <asm/rsi_smc.h>
>  
> +#define MAX_CACHE_OBJ_SIZE	SZ_16M

Why is the limit 16 MiB? I don't see that limitation in the RHI spec.
Does the limit come from PCI TSM?

Regards,
Kameron

> +
>  struct cca_guest_dsc {
>  	struct pci_tsm_devsec pci;
>  };

