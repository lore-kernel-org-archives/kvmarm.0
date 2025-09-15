Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ECB2EFDBE
	for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 08:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925394; cv=none; b=h0BvzEA5MTSPDgwqF7lpGTEFguY42qst6TfmhFSgJQSMRua8PsnPKfp5wZmSPYCOzqPpxK7g3t4QQJog+tz2yScV6JOIzyndI39pjxBPyMg5gF5OSmNTw/QvVb2I9qDkmP9n35NqudXeSHUnbrIRop/Z1El1GI7WqfXJB/mIRs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925394; c=relaxed/simple;
	bh=oTUc05uAoj8tDOxyEV34nE5zIEyVRYInAxKt2au/nUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c6E8TAtA65bqfaViGryqbc3nCw1/6V411wP7qpQEVznpX/KpGaX97GtUG0Lie0w/B1WG+NuO5qIbC1ipgPFvt9wH1VSqbNfpMSOAcn7rHcY6qNFqrfmzWpkz0QhAlV7SAFtz/MTy56sgGlCVo97rEQU1zyGjxJ+KS93FTaw3chc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s17LM0al; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s17LM0al"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45f2f894632so17735e9.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Sep 2025 01:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757925391; x=1758530191; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uuG6t3iAuSKi0EnadmhBvC3rHWT3Byv2xYmpCXcLPYA=;
        b=s17LM0alBJ7e9+Eodjpi8VJfsgc2oH+3DwdHDf34CNMSKKlmalpNYsUfQX3oDFZ7g2
         wVlODOSTt8aj3v+xPKNXBQj3k+uMv0mGXbeogUZ+fw1iWvACZAnksdQOCUtrShi8Smhm
         uRffPCq9LyrZA6sCc5QVf3OM5u+KCRw4kggTUeP1yZ0zQhYkrc0oriCs115e9UYRGvDq
         MTTXrZ14f2K42OuReqYfPiAh52Y2nEdpqSGHxs8r8f0+qM7lV8EDFkTFWH+0ljS6V3LH
         l0QXjK6Ny4u/pYSiNzci8TE4b+7btCnjl73XXBB4HBLMT+4K7t7H3C6n/HsGjk9SWx70
         ZP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757925391; x=1758530191;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uuG6t3iAuSKi0EnadmhBvC3rHWT3Byv2xYmpCXcLPYA=;
        b=XSYtEmq2Efd53AJXg7e0+z7rP5LXLuZDLdrO++n8HGHVpAVyVZzKRxxqAAzvA2/U8U
         S6KaC6BSQDqPnUYnr4tNmVvCWsZbfLZrc/GDtpnRYOYYL/cVo8YslZYr/4hn2L/RmJWG
         POi4Ojerxc4gpsdd6lZEaHLZ6jEGzYQrx3CGQx+Aw9lu5BpDQOrUCjvr8UUaFgk9pujp
         UBbBe1oi1upAP9Dmz55xT1hJbhCWNFZlHRxNSrRwEGIh+roWYyBoN2zoX0TIK/FOWDt6
         TXDLuaMfAe2NDpOuA82EfkDzgpQb+UGlDDrmAZNumzWDkFnTZcoVGQLA+JeZRfp2hySg
         oA1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUymF1Pu8P63TknNshB8tFi2pUBs3he5DPlDNFbspoQGfReZ091HNLZVW/Y/L1meg+fHEGgllw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwaKxOw+cM/rcPZUjvX/0id1ASDn6rxJyVn9/jmrlljN6rapBHS
	hGi+wVmOi7C+TITSUpiajTKEsSE0W3xEDR6iCPAT27O6yxIatwjf9nQLIDUKMzOfpg==
X-Gm-Gg: ASbGncs5+CkAEz3NodEHlFMB9RYhZ5Fo+cHo5CWLcyB0/QD+W83bvc3njlCN88+YLAz
	6JhnWtZe1KcZgKUMApVE7iY8BLPpkg1iRm634wtNZ/2AqNCAFXvam5c5I6T7K8d/kbKz11uITjC
	/9RmE62fCyzuZDlnvGUjbTMs/j17oWb13KprlsDPasx+Eos5FiwClMsyOklximNm9Tu1DlubwpI
	Ph4+LRQygykaAKyarzIri4quSzY36f306AUM8cZc0gz6UvpQGSHGP/2N0UCECMOAlvW6LbQvIq6
	oxo//qMTBSoS0gUA1vZ67/JS6hi+Xnxg5ncEG9vMJTo5VIvjPjSYuVWBecwTS4rR4kxxu/ghIuO
	jgh6jou89jXdQoCKitkn0fCdwIm7qwPQunW1OCeMJA6qY3bZOUjKScqz2ngaeynf+VxzBGg==
X-Google-Smtp-Source: AGHT+IGhw7FjFgBAENHxwqNBn+q5TwhC7OvA4GcuoSnWIVBJGcdJW/TW82vig7dbFCs8/b6w3sEoaQ==
X-Received: by 2002:a05:600c:a10c:b0:45f:2db6:5202 with SMTP id 5b1f17b1804b1-45f2db65722mr740645e9.3.1757925390598;
        Mon, 15 Sep 2025 01:36:30 -0700 (PDT)
Received: from google.com (157.24.148.146.bc.googleusercontent.com. [146.148.24.157])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ebc49f7ebbsm397501f8f.51.2025.09.15.01.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 01:36:30 -0700 (PDT)
Date: Mon, 15 Sep 2025 08:36:26 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 04/38] tsm: Support DMA Allocation from private
 memory
Message-ID: <aMfQCoLuVeR0nf02@google.com>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-5-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250728135216.48084-5-aneesh.kumar@kernel.org>

Hi Aneesh,

On Mon, Jul 28, 2025 at 07:21:41PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Currently, we enforce the use of bounce buffers to ensure that memory
> accessed by non-secure devices is explicitly shared with the host [1].
> However, for secure devices, this approach must be avoided.


Sorry this might be a basic question, I just started looking into this.
I see that “force_dma_unencrypted” and “is_swiotlb_force_bounce” are only
used from DMA-direct, but it seems in your case it involves an IOMMU.
How does it influence bouncing in that case?

Thanks,
Mostafa

> 
> To achieve this, we introduce a device flag that controls whether a
> bounce buffer allocation is required for the device. Additionally, this flag is
> used to manage the top IPA bit assignment for setting up
> protected/unprotected IPA aliases.
> 
> [1] commit fbf979a01375 ("arm64: Enforce bounce buffers for realm DMA")
> 
> based on changes from Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/include/asm/mem_encrypt.h |  6 +-----
>  arch/arm64/mm/mem_encrypt.c          | 10 ++++++++++
>  drivers/pci/tsm.c                    |  6 ++++++
>  include/linux/device.h               |  1 +
>  include/linux/swiotlb.h              |  4 ++++
>  5 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
> index 314b2b52025f..d77c10cd5b79 100644
> --- a/arch/arm64/include/asm/mem_encrypt.h
> +++ b/arch/arm64/include/asm/mem_encrypt.h
> @@ -15,14 +15,10 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
>  
>  int set_memory_encrypted(unsigned long addr, int numpages);
>  int set_memory_decrypted(unsigned long addr, int numpages);
> +bool force_dma_unencrypted(struct device *dev);
>  
>  int realm_register_memory_enc_ops(void);
>  
> -static inline bool force_dma_unencrypted(struct device *dev)
> -{
> -	return is_realm_world();
> -}
> -
>  /*
>   * For Arm CCA guests, canonical addresses are "encrypted", so no changes
>   * required for dma_addr_encrypted().
> diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
> index ee3c0ab04384..279696a8af3f 100644
> --- a/arch/arm64/mm/mem_encrypt.c
> +++ b/arch/arm64/mm/mem_encrypt.c
> @@ -17,6 +17,7 @@
>  #include <linux/compiler.h>
>  #include <linux/err.h>
>  #include <linux/mm.h>
> +#include <linux/device.h>
>  
>  #include <asm/mem_encrypt.h>
>  
> @@ -48,3 +49,12 @@ int set_memory_decrypted(unsigned long addr, int numpages)
>  	return crypt_ops->decrypt(addr, numpages);
>  }
>  EXPORT_SYMBOL_GPL(set_memory_decrypted);
> +
> +bool force_dma_unencrypted(struct device *dev)
> +{
> +	if (dev->tdi_enabled)
> +		return false;
> +
> +	return is_realm_world();
> +}
> +EXPORT_SYMBOL_GPL(force_dma_unencrypted);
> diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
> index e4a3b5b37939..60f50d57a725 100644
> --- a/drivers/pci/tsm.c
> +++ b/drivers/pci/tsm.c
> @@ -120,6 +120,7 @@ static int pci_tsm_disconnect(struct pci_dev *pdev)
>  
>  	tsm_ops->disconnect(pdev);
>  	tsm->state = PCI_TSM_INIT;
> +	pdev->dev.tdi_enabled = false;
>  
>  	return 0;
>  }
> @@ -199,6 +200,8 @@ static int pci_tsm_accept(struct pci_dev *pdev)
>  	if (rc)
>  		return rc;
>  	tsm->state = PCI_TSM_ACCEPT;
> +	pdev->dev.tdi_enabled = true;
> +
>  	return 0;
>  }
>  
> @@ -557,6 +560,9 @@ static void __pci_tsm_init(struct pci_dev *pdev)
>  	default:
>  		break;
>  	}
> +
> +	/* FIXME!! should this be default true and switch to false for TEE capable device */
> +	pdev->dev.tdi_enabled = false;
>  }
>  
>  void pci_tsm_init(struct pci_dev *pdev)
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 4940db137fff..d62e0dd9d8ee 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -688,6 +688,7 @@ struct device {
>  #ifdef CONFIG_IOMMU_DMA
>  	bool			dma_iommu:1;
>  #endif
> +	bool			tdi_enabled:1;
>  };
>  
>  /**
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 3dae0f592063..61e7cff7768b 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -173,6 +173,10 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
>  {
>  	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
>  
> +	if (dev->tdi_enabled) {
> +		dev_warn_once(dev, "(TIO) Disable SWIOTLB");
> +		return false;
> +	}
>  	return mem && mem->force_bounce;
>  }
>  
> -- 
> 2.43.0
> 
