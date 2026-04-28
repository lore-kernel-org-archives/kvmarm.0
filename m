Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CA0436377;
	Tue, 28 Apr 2026 13:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777384588; cv=none; b=sQ//DIKsl5dtLGZZXUiG7HosiON4B0x8M+4cQHarRtpcFybKpiWPrM/1EAWVx2o7X7n8nzcs5uh+9M4A5u2+v/qXcKoydr2wt6UMQ9LZgwyG2ofzl8D4oQV5/0k7UYTGCPecKA4MwUfObhU7qzNCtGWdxEHsXgKq+VV+dcvczKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777384588; c=relaxed/simple;
	bh=tzR76jwjcwHZJGzKefeV38J4m6XWBejLedn5tsPTIMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HR+xj+OU1D38rvOcuYm98YlpBA3WsYCyEomF0S4bxdHKy/e1wC7OxmVvAeHTtHw6WDzvi7tZtiaNHNN3LpodRZRApC3HANvLIZDdMVTAsj+6PQln3VgP5IeT2YcVMAVDbUGIgXjwRtiAke67P0FCDvlALjr+jLhWY6O0/8rcn6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DS6k2Bn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DS6k2Bn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6A1C2BCAF;
	Tue, 28 Apr 2026 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777384587;
	bh=tzR76jwjcwHZJGzKefeV38J4m6XWBejLedn5tsPTIMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DS6k2Bn82HqQjbd4tlW9JWMHVz1+5KTI5b/BfvTBKiuA9WwzIscwxhmjHPgb/omGV
	 OEzL1EXlTR5pjJSG4pTVflm5N5KzaCaxnkOE/3kNnDqaLBxY5+7ircXZy75INGU9Ve
	 HY34+7q6JTokXxXbfrgJXOO0I7GlAlaj9nJWgT3FD069FRRAeh6HPKDNVfdre/gap9
	 IuEqo6dFQThj2aOR4eexv9DFHAcebMq4dGVho9d46SUpcWSTApxZF7B92dT1sn7BxD
	 OsMgdW3FOkTcd3ZtB5/PNG7B88aGK2w5TsmLKVdI1b3up4H9dq5O4qTJhZBzwk9Pbg
	 dCDhqziOEZTmQ==
Date: Tue, 28 Apr 2026 14:56:21 +0100
From: Will Deacon <will@kernel.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, sebastianene@google.com
Subject: Re: [PATCH v4 3/3] coco: guest: arm64: Query host IPA-change
 alignment via RHI
Message-ID: <afC8hZTJY6Cx8Liz@willie-the-truck>
References: <20260427063108.909019-1-aneesh.kumar@kernel.org>
 <20260427063108.909019-4-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427063108.909019-4-aneesh.kumar@kernel.org>

[+Seb for the ITS]

On Mon, Apr 27, 2026 at 12:01:08PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Add the Realm Host Interface support needed to query host configuration
> from a Realm guest. Define the RHI hostconf SMCs, add rsi_host_call(), and
> use them during Realm initialization to retrieve the host IPA-change
> alignment size.
> 
> Expose that alignment through realm_get_hyp_pagesize() and
> mem_decrypt_granule_size() so shared-buffer allocation and
> encryption/decryption paths can honor the ipa change page-size requirement.
> 
> If the host reports an invalid alignment (when alginment value is not
> multiple of 4K), do not enable Realm support.
> 
> This provides the host alignment information required by the shared buffer
> alignment changes.
> 
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  arch/arm64/include/asm/mem_encrypt.h |  3 ++
>  arch/arm64/include/asm/rhi.h         | 24 +++++++++++++
>  arch/arm64/include/asm/rsi.h         |  2 ++
>  arch/arm64/include/asm/rsi_cmds.h    | 10 ++++++
>  arch/arm64/include/asm/rsi_smc.h     |  7 ++++
>  arch/arm64/kernel/Makefile           |  2 +-
>  arch/arm64/kernel/rhi.c              | 54 ++++++++++++++++++++++++++++
>  arch/arm64/kernel/rsi.c              | 13 +++++++
>  arch/arm64/mm/mem_encrypt.c          |  8 +++++
>  9 files changed, 122 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/include/asm/rhi.h
>  create mode 100644 arch/arm64/kernel/rhi.c

[...]

> diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
> index 38c62c9e4e74..f5d64bc29c20 100644
> --- a/arch/arm64/mm/mem_encrypt.c
> +++ b/arch/arm64/mm/mem_encrypt.c
> @@ -59,3 +59,11 @@ int set_memory_decrypted(unsigned long addr, int numpages)
>  	return crypt_ops->decrypt(addr, numpages);
>  }
>  EXPORT_SYMBOL_GPL(set_memory_decrypted);
> +
> +size_t mem_decrypt_granule_size(void)
> +{
> +	if (is_realm_world())
> +		return max(PAGE_SIZE, realm_get_hyp_pagesize());
> +	return PAGE_SIZE;

No, this should be indirected via 'struct arm64_mem_crypt_ops' because
there's nothing particularly unique to realms here. For pKVM protected
guests using a smaller page-size than the host, we'd presumably need
something similar for the ITS (where restricted-dma isn't used).

Will
