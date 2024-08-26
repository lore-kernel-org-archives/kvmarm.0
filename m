Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6396612DD90;
	Mon, 26 Aug 2024 10:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724666694; cv=none; b=hzG4VTWKqiLU9SaL9cN98yHdc733X1qS2VdfVY3zPQSRp2dxzAXuONOTBETN1Demcc92KeBUSJqekuwKd82GrwosQ+m+7jlKFTD7Pt5rMToXitKN9nGb6rW3PljKfKQEV1ijKniSd4/8Kv/D3BOg1ayJbY5KdKKb/B5M7UpAXRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724666694; c=relaxed/simple;
	bh=YL7qBo57RDbLeGhkDLRBvc0AFMgOBy3JMbnsj1QnyAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOif1flBSwXKwVA8cmkYHZmvjnTkBt6gX5bUvgYNyP7MS1hbsJ76YLQOgzRo7tjeHlQQTMyKCRCV65VM2Y4A4hhSLALOJC96duQWEKIFnAM6J9USHoFvceGDcE1PuwTDF2RUVnTXr2P4hPeRQokClthgdjt4QS441K+bFix0jzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146A7C51407;
	Mon, 26 Aug 2024 10:04:49 +0000 (UTC)
Date: Mon, 26 Aug 2024 13:04:58 +0300
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
Subject: Re: [PATCH v5 07/19] arm64: rsi: Add support for checking whether an
 MMIO is protected
Message-ID: <ZsxTSm-7Z6BS6Mg2@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-8-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-8-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:12PM +0100, Steven Price wrote:
> +static inline bool arm64_is_iomem_private(phys_addr_t phys_addr, size_t size)
> +{
> +	if (unlikely(is_realm_world()))
> +		return arm64_rsi_is_protected_mmio(phys_addr, size);
> +	return false;
> +}

I was wondering whether to return true in non-realm world. It doesn't
matter since the pgprot_decrypted() wouldn't do anything. Anyway:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
