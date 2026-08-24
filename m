Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD013932FF;
	Mon, 24 Aug 2026 22:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787610510; cv=none; b=azfsOHiJ0+KUC61O61q6qtRjRSu2PerBKe5V7eyQmbNFlSxlEfBYbEX5Zu66yBOGpKnETUEipeNT2MzAOu/wx0l5KIqN/iq3GLkS+Qv2vHl5Jp9GfbhKuWdU5iwR7m1RJNOkEXo59XR8cKhVX3akAT5plunHDu6FOjHgfrpmXZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787610510; c=relaxed/simple;
	bh=8YkalDfOLH7ZhauPFHeeoXqmWKKKSNSdp2k35xerf6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oYleqg3Dvb4a7/ViTGOhDEJpcE87jDGTNncnjZCXmaKXe7D9mdk3zPBURepxUuBi5YSy42bAjt6dlqKp7NwZK8vD6SPzVREayEr/aOOAYu+Pe4+cR/dPoB3tp6hGSlgudOq9xwwkUUOymKoFwmIom+sfFCKLK9mlRl0b8lwrBEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=pUj6NLIf; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="pUj6NLIf"
Received: from [10.4.158.9] (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id 51F2E20B7166;
	Mon, 24 Aug 2026 15:27:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 51F2E20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787610476;
	bh=3upJMujWsliLVEDZkldGdb84hlp2TqlRJwjZBbNKU3o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pUj6NLIfVHKUDMIbKK8hykSMwbBvQRxMJ6p1Dzw9v9DBx2eiYgnuw2muTtOd6EGDj
	 VChyaBkAAiREznAxDKC52ri1zfEoV8q8BeocTJ917idvyBQ+iOzfCMfRBR/vthF0U1
	 sY5zh2GMezaL1zAxJkh4hHDoxI7YrmiAoTDGcQbs=
Message-ID: <f086f940-edaa-4bd5-ba11-e52e61fd6cee@linux.microsoft.com>
Date: Mon, 24 Aug 2026 15:28:19 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 09/11] coco: guest: arm64: Hook TSM accept to Realm
 TDISP RUN transition
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dan Williams <dan.j.williams@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Cameron <jic23@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Samuel Ortiz <sameo@rivosinc.com>, Steven Price <steven.price@arm.com>,
 Suzuki K Poulose <Suzuki.Poulose@arm.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
 <20260427082805.931832-10-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Kameron Carr <kameroncarr@linux.microsoft.com>
In-Reply-To: <20260427082805.931832-10-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/2026 1:28 AM, Aneesh Kumar K.V (Arm) wrote:
> Add an accept callback in pci_tsm_ops and implement cca_device_accept() to:
> - verify evidence generation (lock_nonce)
> - allocate and register protected MMIO ranges
> - transition TDI state to RUN
> 
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  drivers/virt/coco/arm-cca-guest/arm-cca.c | 20 +++++++++++
>  drivers/virt/coco/arm-cca-guest/rsi-da.c  | 43 +++++++++++++++++++++++
>  drivers/virt/coco/arm-cca-guest/rsi-da.h  |  1 +
>  3 files changed, 64 insertions(+)
> 
> diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
> index 320dd5aa7b9a..b29b3948a454 100644
> --- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
> +++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
> @@ -499,9 +499,29 @@ static void cca_tsm_unlock(struct pci_tsm *tsm)
>  	kfree(cca_dsc);
>  }
>  
> +static int __cca_tsm_accept(struct pci_dev *pdev, unsigned long lock_nonce)
> +{
> +	int ret;
> +
> +	ret = cca_device_accept(pdev, lock_nonce);
> +	if (ret) {
> +		pci_err(pdev, "failed to transition the device to run state (%d)\n", ret);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int cca_tsm_accept(struct pci_dev *pdev)
> +{
> +	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
> +
> +	return __cca_tsm_accept(pdev, dsc->dev_info.lock_nonce);
> +}
> +
>  static struct pci_tsm_ops cca_devsec_pci_ops = {
>  	.lock = cca_tsm_lock,
>  	.unlock = cca_tsm_unlock,
> +	.accept	 = cca_tsm_accept,
>  };
>  
>  static void cca_devsec_tsm_remove(void *tsm_dev)
> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
> index 039138768f8f..7c2b28fa43a1 100644
> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
> @@ -230,3 +230,46 @@ int cca_verify_digests(u64 hash_algo,
>  	}
>  	return 0;
>  }
> +
> +int cca_device_accept(struct pci_dev *pdev, unsigned long lock_nonce)
> +{
> +	int ret;
> +	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
> +
> +	if (lock_nonce != dsc->dev_info.lock_nonce) {
> +		pci_err(pdev, "Device evidence generation mismatch\n");
> +		return -EIO;
> +	}
> +
> +	/* Allocation private mmio range based on interface report. */
> +	struct pci_tsm_mmio *tsm_mmio __free(kfree) = pci_tsm_mmio_alloc(pdev);
> +	if (!tsm_mmio) {
> +		pci_err(pdev, "Protected mmio range allocation failure\n");
> +		return -ENOMEM;
> +	}
> +
> +	/*
> +	 * Present the private mmio range in the resource hierarchy.
> +	 * We don't use this for ioremap, ioremap check the RIPAS value.
> +	 */
> +	ret = pci_tsm_mmio_setup(pdev, tsm_mmio);
> +	if (ret) {
> +		pci_err(pdev, "Protected mmio setup failure\n");
> +		return ret;
> +	}
> +
> +	ret = cca_map_evidence_report_range(pdev, tsm_mmio);
> +	if (ret) {
> +		pci_err(pdev, "failed to validate the interface report\n");
> +		return ret;
> +	}
> +
> +	ret = rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_RUN);
> +	if (ret) {
> +		pci_err(pdev, "failed to switch the device (%u) to RUN state\n", ret);
> +		return ret;
> +	}

After calling pci_tsm_mmio_setup() we have mappings from insert_resource()
then failures from later return codes never call mmio_teardown() so
remove_resource() is never called, only kfree on the tsm_mmio.

Likewise after cca_map_evidence_report_range() the mmio entry memory ranges
have state RIPAS_DEV. Later failures never restore RIPAS_EMPTY.

Could clean up be handled better? Is there a reason these failures don't
have a rollback path?

Regards,
Kameron

> +
> +	dsc->pci.mmio = no_free_ptr(tsm_mmio);
> +	return 0;
> +}
> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> index 07a044d3e335..eeb049d374c5 100644
> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
> @@ -61,5 +61,6 @@ int cca_verify_digests(u64 hash_algo,
>  		uint8_t *interface_report, size_t interface_report_size,
>  		uint8_t *measurements, size_t measurements_size,
>  		struct rsi_vdevice_info *dev_info);
> +int cca_device_accept(struct pci_dev *pdev, unsigned long lock_nonce);
>  
>  #endif

