Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285C043B6E0;
	Tue, 21 Jul 2026 22:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671428; cv=none; b=tWvsXfX6p5sKsMnsSuZa0SuGF9UWpkDQBSfcAjPXz3LnghUyBG1Bk9vrm+/x2O+VEJQ5FJov+SkYPh4CohXhquDU3Bi2/e/Y93YaieLCthHy+ZA+3Ye4PltP73kQM8/lZQgl0SlO17ISPNXAKb7sesEGsfKQ4fnG67+OJ9zz4jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671428; c=relaxed/simple;
	bh=bCxbVfN6V5pHCC3mEwGYgsl5FA2XAsw3WeKrawYV32k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TF+u6LJRes4lbrJFIfski0uwUUw8AEvFeskcEPN8XSN9vPcTBXfLr7Ew7aQfNAnO020mbOIABqflHku6U9+7TCiRiCcQL+1Y92KLck8BN3gdQbZmOYA6MJZOCeE3byx3PXkrW8zRVKsDeEmQK/Jj1WI2wFHVAKUJ3DJwh24VB8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=auTW/WBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="auTW/WBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CBE1F000E9;
	Tue, 21 Jul 2026 22:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784671427;
	bh=6P8NXzkwEgiAM58tQMpUy9Cb9CjVa4MDzbpmorHECA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=auTW/WBCYQ0i42fuTPQW5kc5UvlmEvZwzOscJ/H5askVmaHpCz5oe7Xc77FDAmBf7
	 HuSI/X2oAg49afP3BY15c4kYsbK71P2r1sTA+qN5oMF7zXJHZ/+EfpBA48swTG1PU1
	 GyqDjnCxi1H7ILYAhFUmPLPU8jaRX2p2ajBgZ0NGYTc+c4962eVQ5X1W5mxMGpnm3w
	 OmUi/MGOMxwuu/5HgzT7mctMXWDq32jVGyihEoZ+IXIWwG/OgeGAM6j78cxpCvwUgh
	 nMLR9HTw40xcK1muaX5lBIQxaV/V0VdR+JuZeolXGVTr3VsRx80yFn5RLXqMgqMr5x
	 Ii/qx9fk+Ymng==
Date: Tue, 21 Jul 2026 23:03:40 +0100
From: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH v5 08/10] arm64: realm: Move Realm memory encryption ops
 to RSI code
Message-ID: <al_svOwkb5SleTWg@willie-the-truck>
References: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
 <20260706060432.1375570-9-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706060432.1375570-9-aneesh.kumar@kernel.org>

On Mon, Jul 06, 2026 at 11:34:30AM +0530, Aneesh Kumar K.V (Arm) wrote:
> Realm memory encryption callbacks are CCA-specific. Keep the Realm callback
> registration with the RSI initialization code instead of pageattr.c, which
> only needs to provide the low-level page-attribute transition helper.
> 
> Export __set_memory_enc_dec() within arm64 so the RSI code can wrap it with
> the Realm-specific encrypt/decrypt callbacks and warning policy.
> 
> No functional changes in this patch.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/include/asm/mem_encrypt.h |  3 +--
>  arch/arm64/kernel/rsi.c              | 34 +++++++++++++++++++++++++
>  arch/arm64/mm/pageattr.c             | 38 +---------------------------
>  3 files changed, 36 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
> index 314b2b52025f..f6325f30e844 100644
> --- a/arch/arm64/include/asm/mem_encrypt.h
> +++ b/arch/arm64/include/asm/mem_encrypt.h
> @@ -15,8 +15,7 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
>  
>  int set_memory_encrypted(unsigned long addr, int numpages);
>  int set_memory_decrypted(unsigned long addr, int numpages);
> -
> -int realm_register_memory_enc_ops(void);
> +int __set_memory_enc_dec(unsigned long addr, int numpages, bool encrypt);
>  
>  static inline bool force_dma_unencrypted(struct device *dev)
>  {
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> index 1fb2abd79800..5c566700974c 100644
> --- a/arch/arm64/kernel/rsi.c
> +++ b/arch/arm64/kernel/rsi.c
> @@ -143,6 +143,40 @@ static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
>  	return 0;
>  }
>  
> +static int realm_set_memory_encrypted(unsigned long addr, int numpages)
> +{
> +	int ret = __set_memory_enc_dec(addr, numpages, true);
> +
> +	/*
> +	 * If the request to change state fails, then the only sensible cause
> +	 * of action for the caller is to leak the memory
> +	 */
> +	WARN(ret, "Failed to encrypt memory, %d pages will be leaked",
> +	     numpages);
> +
> +	return ret;
> +}
> +
> +static int realm_set_memory_decrypted(unsigned long addr, int numpages)
> +{
> +	int ret = __set_memory_enc_dec(addr, numpages, false);
> +
> +	WARN(ret, "Failed to decrypt memory, %d pages will be leaked",
> +	     numpages);
> +
> +	return ret;
> +}
> +
> +static const struct arm64_mem_crypt_ops realm_crypt_ops = {
> +	.encrypt = realm_set_memory_encrypted,
> +	.decrypt = realm_set_memory_decrypted,
> +};
> +
> +static int realm_register_memory_enc_ops(void)
> +{
> +	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
> +}

It's good to move these out of pageattr.c but I still don't think any
of this stuff should be in arch/arm64. This is a firmware interface,
just like PSCI, so it should live in drivers/firmware/ along with all
the other Arm firmware interfaces (SDEI, FFA, SCMI, PSCI, SMCCC, ...).

Will
