Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B0B190684;
	Tue, 10 Sep 2024 09:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961672; cv=none; b=gpl3MD3/M24izQfB5OA9sPUmniPnOQcdzvwkuy0MwBbyamkQXDtpfRc/bllhvuYrPx5yGXh6NIQ8T2InaioSGN4G0/MbD4sdvyP0GBR0OXFbAsT4mzYsf+tvYKNEA2Tq0np5aYmmlcry3BY53PQfBxH4K+tkdKzBel8/8uUiOl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961672; c=relaxed/simple;
	bh=32ZjKnbISZ5HfC13g6akEMY5BzbXnZdxgkLbbXDzTxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pklvLEZ63I5URlsnoiVHMej9hApGvBY2JxdZ9woH2YBuGTLmnQLbPoNJNMX/cq4nZawFDsDmutt44hs+CialqBZWb2PUAAdnaUbzutUNyCUjVyLK7ojhhzLlM5JqxXOP1ow0LUVElqRUoMaVesoeyCHDklgePz5cjB78senFUCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IETI+2t3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IETI+2t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA79C4CECC;
	Tue, 10 Sep 2024 09:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725961672;
	bh=32ZjKnbISZ5HfC13g6akEMY5BzbXnZdxgkLbbXDzTxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IETI+2t329OYBYsMx1EZRAhMLEl1dL0aBVCOsZTV0f09eGVZ/LJ5bAkZ5dRqAmroq
	 yOC6nmxEhzLeYSi/DtBVQe4rUKffMUVMRs54tXxw2b99SYx+aEFm9DuvapaNCEAW0L
	 TkiYIkSse2yxbSDzKajHW4sW3tDGGmqO7PG0Pi+azRA+SCA03dxFmWxnvtfBqGyE2F
	 uPN2EaXD62V0D1A50pHQaCQOdaf0UBfriIa/qUkUXmTfPkDjoMovh9z99MqkeMH952
	 CMe00OuUiS8AV3M+KG7VpRBsgly5oa9hqiyONnko9RK4tQ2MTc4cECnAcr10c0XUwh
	 lSSYvMAMSadGg==
Date: Tue, 10 Sep 2024 10:47:46 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Anastasia Belova <abelova@astralinux.ru>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] arm64: KVM: define ESR_ELx_EC_* constants as UL
Message-ID: <20240910094746.GA20813@willie-the-truck>
References: <865xr5856r.wl-maz@kernel.org>
 <20240910085016.32120-1-abelova@astralinux.ru>
 <86v7z37u5a.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v7z37u5a.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Sep 10, 2024 at 10:08:49AM +0100, Marc Zyngier wrote:
> On Tue, 10 Sep 2024 09:50:16 +0100,
> Anastasia Belova <abelova@astralinux.ru> wrote:
> > 
> > Add explicit casting to prevent expantion of 32th bit of
> > u32 into highest half of u64 in several places.
> > 
> > For example, in inject_abt64:
> > ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT = 0x24 << 26.
> > This operation's result is int with 1 in 32th bit.
> > While casting this value into u64 (esr is u64) 1
> > fills 32 highest bits.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: aa8eff9bfbd5 ("arm64: KVM: fault injection into a guest")
> > Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
> 
> nit: the subject line is misleading, as this doesn't only affect KVM,
> but the whole of the arm64 port (the exception classes form a generic
> architectural construct).

Weird, this v2 landed in my spam for some reason.

> This also probably deserve a Cc stable.
> 
> Will, Catalin: I'm happy to queue this in the KVM tree, but if you are
> taking it directly:
> 
> Acked-by: Marc Zyngier <maz@kernel.org>


I can take it via arm64. I assume it's ok to land in v6.12 (with the cc:
stable), or is there an urgency to landing this in v6.11? It looks it
was found using verification tools, rather than because of an actual
issue affecting users.

Will
