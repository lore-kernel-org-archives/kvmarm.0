Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2933E248F70
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 14:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753713202; cv=none; b=kqBf7bRU+XnnOvHouPDaOQS7gnxE1XTnH8+lOcSWTH4WyVFCkoJvLIbfWBdxSzXfnioYRgdat7VibJRbTvnw00DRWINlsENeCLwXy73reIhfPvmwNR4jvrQ6SRTwogIF3RwUpJlKZti7lQeRktZprn3teqdQL7E2+KPqF3ejWuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753713202; c=relaxed/simple;
	bh=W9cZd84LF6duF0602DMOOstiN56aNMhgPt1nX1d9jRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oqHGc+EwM13oTcAoxho1Bnix+ecZARaHJzK5flK1ZnHe2/sv9ZYPj2bLtrGdD8MFf2LGRYL7zpPvNDU1fcqAMVx/IZWKMvo4hb43izWkqdVVeWfbcCpNi8HhaV2nLQUFQCDnbYeZcq3FYsI8vdTvQ0I3A1etp1Fa1Rsnq41p1eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=E6/isURf; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="E6/isURf"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6faf66905adso25445796d6.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 07:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753713200; x=1754318000; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWXJt0ksyO0+qZpgSvPEVSB9f2WnFWOci7NBGJx/i70=;
        b=E6/isURfxGFOZnRiNOZXKOboyp3TzCGS+mHxnW9uMeuH5Sy5pfchap2aVfEyYUeQC4
         cKovsaSd/NP+zm4JYIkN4yPWKHBbzZiLA6LKI43OSruskSx5k42g8K2sTRK+bY2MTb4E
         xRDFrwdoQvjQQ7ear6jNueU596+E5qilnthEnGSkJRpp2r0aRzmaRSGcJWM3ceR0YAFg
         Ni4DlFcc0psZYrdKH4IGNdUeZs4m7zSLRLPXt5cVliT4H/mJneJnZQguGB8wn7uI5Kt0
         8fnJA1Nhkt8WLu4LToZRluelE6meRaOas9B0la/iotKA9y+LA70mYs5bpibmkTsYzPOM
         wmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753713200; x=1754318000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWXJt0ksyO0+qZpgSvPEVSB9f2WnFWOci7NBGJx/i70=;
        b=ADZNKXVQvZvnoNW2Q/dXGFCFLlGtZPWGRgPVeyf0GmQsWyhm3EydDoEGG96nLYQQs5
         umSxDzAv8r/NLSRUMVrECMYbj0DYLahHjeFqMEg8/B8VIUlWKHa6z2L2zDNqNWWLz0zC
         /nNYlvuBlnq51aqYa9rPub7PsxvT3fEfTLpfI3w40gXb+RMy7Y7vXqvFl05HTcOJCcFK
         0g5jNMRblyxMcAmP83X+f7UsWLA62OOrhkFC9GLhznxYj9ScNESL3YH9SBm8yo5iPEYC
         GjIEN6OTujqEWCjxxHPWwu1huTtdcXULI3obhu4l7+RoOaRuXxmqQvOUhGAlxFbyb/y0
         38qw==
X-Forwarded-Encrypted: i=1; AJvYcCUNWzHGjk+n734HfUHp26i3a5BeiLkThzKJNpDJdS1yh2mNHmcYLvvn7bpIHaWCUYcOQAtkRhs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhAQxmB/l0l/2VfC/D2+QJGmseFVMNqeF6JFwMUvwvyiqWy3Br
	gwaALeE0ZC/pnWWLRrbmgCgts0uOnZBnbg1hAepjMhNmqsTbqbCQ0uxue+bkKmn+Jdg=
X-Gm-Gg: ASbGncuV4LYf20gHavY3LJCzeTQCRJUjSL6vlnSPTT49RXTUALzWOh5ZVQ8UVLrA/yj
	KJ2Vtff1BadDlA4iZx0u4BpPJcrF44fcwSY8MxYTjPRbqetri3kuJb3F86+pq1cIDiVqiXqWcha
	4CznsUFBvY9sovqXo0LjuOwZTItmRFHUGeJAExNhK/iWvLBHQ4Rk556VM3FnOssx4ClO6ZDSqSY
	paFU/DEYWTOlS5opZN2iytitsx7f/ZbXOI5uq0dCDgd/Weac+n10lOiMV7+ANpFThAGomb+lnb1
	LFxgtYcfBYFO3Aa7pMlSUx99vCKmAQOIpXYWD37ZgPc+Ih7Z2XDOmfogsxfPyOoFHr9slAmc50E
	5RWiB+ad4KLGgwQ0rpE9mljL8SG8JdcOYzpNkzqvQwjG/WDS1JvJJp3hK4CkZaUS9sUez8iaL/q
	UkO3c=
X-Google-Smtp-Source: AGHT+IHMY4rGulXXEHfYzZtPMGVblgwyt5UUI5t558D0JMhsu4TWVCWFWjqwz9Xtl5YNFBAdYTlQIg==
X-Received: by 2002:a05:6214:224a:b0:707:9eb:d483 with SMTP id 6a1803df08f44-707205a1bcemr162291726d6.27.1753713199708;
        Mon, 28 Jul 2025 07:33:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7074c37e84asm9044456d6.19.2025.07.28.07.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 07:33:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ugOuk-00000000Ayl-2Dx4;
	Mon, 28 Jul 2025 11:33:18 -0300
Date: Mon, 28 Jul 2025 11:33:18 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 04/38] tsm: Support DMA Allocation from private
 memory
Message-ID: <20250728143318.GD26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-5-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728135216.48084-5-aneesh.kumar@kernel.org>

On Mon, Jul 28, 2025 at 07:21:41PM +0530, Aneesh Kumar K.V (Arm) wrote:
> @@ -48,3 +49,12 @@ int set_memory_decrypted(unsigned long addr, int numpages)
>  	return crypt_ops->decrypt(addr, numpages);
>  }
>  EXPORT_SYMBOL_GPL(set_memory_decrypted);
> +
> +bool force_dma_unencrypted(struct device *dev)
> +{
> +	if (dev->tdi_enabled)
> +		return false;

Is this OK? I see code like this:

static inline dma_addr_t phys_to_dma_direct(struct device *dev,
		phys_addr_t phys)
{
	if (force_dma_unencrypted(dev))
		return phys_to_dma_unencrypted(dev, phys);
	return phys_to_dma(dev, phys);

What are the ARM rules for generating dma addreses?

1) Device is T=0, memory is unencrypted, call dma_addr_unencrypted()
   and do "top bit IBA set"

2) Device is T=1, memory is encrypted, use the phys_to_dma() normally

3) Device it T=1, memory is uncrypted, use the phys_to_dma()
   normally??? Seems odd, I would have guessed the DMA address sould
   be the same as case #1?

Can you document this in a comment?

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

I would give the dev->tdi_enabled a clearer name, maybe
dev->encrypted_dma_supported ?

Also need to think carefully of a bitfield is OK here, we can't
locklessly change a bitfield so need to audit that all members are set
under, probably, the device lock or some other single threaded hand
waving. It seems believable it is like that but should be checked out,
and add a lockdep if it relies on the device lock.

Jason

