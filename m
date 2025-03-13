Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10614264FBD;
	Thu, 13 Mar 2025 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741865227; cv=none; b=eMVFtxOPy9ny6una0h5VMuhA2nybx9BEpn7bVZXQWSVcggTRgwBsT7Qbl5lJVfdTyzYkjvfu2Rf71g9jRHBdPHNQqxb/0e7zcFfHC/O+W2IJTgUmSNyuO616C7nfVEDqyLMUAqSDou6AIJtbJ3+np4xwiB2nUY4le+94mXzQKVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741865227; c=relaxed/simple;
	bh=H3Sm9drDYVSjHR0XGaZA7OInsYmljvw1bNb0smU/DtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3rr1Kx8fQkmtjio3PlSKyIdOMsMmctgMWnw8RNSiN0b81mKWQML6fuyPWCd3ycmd4NVAeBk2JhAs/UMCPzoSh2//RXYen0GHuTMeQkGbZfsVf8rO+GvQhwA7M159GmHg5VfLoHkjHU+gU5PwA9oLPKYtJEL0Ka5bNuVZ4HEcEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eLlLZEPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eLlLZEPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7018DC4CEE5;
	Thu, 13 Mar 2025 11:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741865225;
	bh=H3Sm9drDYVSjHR0XGaZA7OInsYmljvw1bNb0smU/DtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eLlLZEPGuZaF+vWTcpzYAFYzGPShEx7NHj0ul2aaX1eN0GGEx+pM8w7xCEVwvrcMh
	 4xP8Yo2MEciS0wVCgHYmkDOqptKjIJnc5OubeOlWxl+0KxkiGhhu9teq1h+nNY30qa
	 PGFR8KOXWKdaDFWv+PB/H5+V8oTywOB2O6t3+acetjNzx5zVJvwvVEkqdxGz95rLXV
	 v9vn7Pthz+whbfRTcL/t103RZxIzl0hNMiEBBCcxjA0XV7gC6AqOrxsrtdGzwHUQWj
	 6vt3EJ6TMV8oWviZ+XfRWCbskhtGTCOLlrOvJwkHPsj984E1qsxvM9wk60n4Wpa22D
	 nV2MlVBPgtQ4g==
Date: Thu, 13 Mar 2025 11:26:59 +0000
From: Will Deacon <will@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, qperret@google.com, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, shan.gavin@gmail.com
Subject: Re: [PATCH] KVM: arm64: Drop sort_memblock_regions()
Message-ID: <20250313112659.GA7223@willie-the-truck>
References: <20250311043718.91004-1-gshan@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311043718.91004-1-gshan@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 11, 2025 at 02:37:18PM +1000, Gavin Shan wrote:
> Drop sort_memblock_regions() and avoid sorting the copied memory
> regions to be ascending order on their base addresses, because the
> source memory regions should have been sorted correctly when they
> are added by memblock_add() or its variants.
> 
> This is generally reverting commit a14307f5310c ("KVM: arm64: Sort
> the hypervisor memblocks"). No functional changes intended.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/arm64/kvm/pkvm.c | 19 -------------------
>  1 file changed, 19 deletions(-)

It's not especially obvious from the memblock API that the memblocks
are sorted and so for_each_mem_region() will traverse the regions in
order. But it does appear to be true, so I suppose this is fine:

Acked-by: Will Deacon <will@kernel.org>

Will
