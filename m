Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C6512C544;
	Mon, 26 Aug 2024 10:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666504; cv=none; b=b41ryCgnKcuUNBXMW2OrwH6ExVg/AdejOWzw+qC7rOguX3cqhWc74jHrReyCFeR06rUpQ+VfBtCog/MyQb46jtD54/50G2mxmN69ZlAopG6czkun8JgS+RpCIhMiexNYpqqE4JBDMLYPS1TRCWaPYUBWcIYIaZkaBVtCamrTExE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666504; c=relaxed/simple;
	bh=Pagmjwjg2LVDtqeEGAz877N+Fu/3AAw+uqG1Ihowako=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtKahWHPZgLJ9oWao3foBramgVX+0b6+wpiOVKXYTuxrRKbdG1pRnFtpqwvcgFt6ZqEWLR/Vq2RU2xPbEnC28q23JaKWKB75JPaibBLtL/m5E77eCGO7Lp56of1FNit7KerRs1hI2W4GXQ+peA0D5F8ZOsJemduYXZG32CQGiM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4D2C51411;
	Mon, 26 Aug 2024 10:01:39 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:01:47 +0300
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 03/19] arm64: rsi: Add RSI definitions
Message-ID: <ZsxSix3Om-Khmfup@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-4-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-4-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:08PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by a realm guest through SMC (Realm Services Interface) calls.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0-rc1.
> 
> [1] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

(I did cross-check the definitions with the spec)

> +struct realm_config {
> +	union {
> +		struct {
> +			unsigned long ipa_bits; /* Width of IPA in bits */
> +			unsigned long hash_algo; /* Hash algorithm */
> +		};
> +		u8 pad[0x200];
> +	};
> +	union {
> +		u8 rpv[64]; /* Realm Personalization Value */
> +		u8 pad2[0xe00];
> +	};
> +	/*
> +	 * The RMM requires the configuration structure to be aligned to a 4k
> +	 * boundary, ensure this happens by aligning this structure.
> +	 */
> +} __aligned(0x1000);

It might have been easier to just write the pad sizes in decimal (trying
to figure out what 0xe00 is ;)). Anyway, it's fine like this as well.

-- 
Catalin
