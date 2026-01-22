Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335F9309EFA
	for <kvmarm@lists.linux.dev>; Thu, 22 Jan 2026 10:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769076962; cv=none; b=ut6tg9WwwtEgTvukyW4gVFJG3/9er4lgOvhChzvmhv4xxeYmkq6mAzzAt5LGNskXNL3hdR7lkeZMIlesy0jtSE1nzXTVqDKfqCjgOlTptaWpl2gWuRoT5g5XG8yBAIZSMmwyDpC3BrDDaT2wBiiCeNLWWQ/7vb55VNUasNiasyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769076962; c=relaxed/simple;
	bh=UnI8VlnfOqiebAjN7smnzWiOC/uYQMjCL6S2C/BEoa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V7mAuYGlvU5TJWAn/E7xagkBdh1P1rHwqjRiThgYenjZw+HpbUPfQvQ4BjoN7BZNmmT3CcEtIgwisgIymZXnzfT6eGiHZyNSE2ZGTETwsQhtNwBFN/rQmO2AKI31JHqiIETPs05cdo2Fjm7IrlJp5/iG54D0G8nr97EyAqi7ki4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDUrfZk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDUrfZk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E6DC116C6;
	Thu, 22 Jan 2026 10:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769076962;
	bh=UnI8VlnfOqiebAjN7smnzWiOC/uYQMjCL6S2C/BEoa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CDUrfZk0Xz0L6cy1p+/tMeRnBxCxxQZqLqls7r3CB9RMoU/2gqNttU93cDQkxwdQ1
	 8vuQfGDe1C8bTX1sDeQ1hEqGFkYPU1YJy1r2nB4CRUpm21q6XLniDoMY2YiiJB9JS3
	 7h7YHX1WHp1CBfBJfGLS4kWrY8gbieN05QyxPM5BMZgQwxEIWCItR6Et719vFiSz9+
	 /rhm3sig7evYY8e8pfrdo4iG9ydXyEDtMmZJM0+lmC+bda9zap/M6r6o4pTsVsFuCM
	 SoE2bcKbfdYE0l/2h/TJBf90eSTeUHRrVpLsbhPU6P/Pc1sZM3jAF/rvMdxn80zO1F
	 CfuO6rrEl0gfQ==
Date: Thu, 22 Jan 2026 10:15:56 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 3/3] arm64: Unconditionally enable EPAN support
Message-ID: <aXH43Dr-5OrXNOyy@willie-the-truck>
References: <20260107180701.2858276-1-maz@kernel.org>
 <20260107180701.2858276-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107180701.2858276-4-maz@kernel.org>

On Wed, Jan 07, 2026 at 06:07:01PM +0000, Marc Zyngier wrote:
> While FEAT_PAN3 is pretty recent, having it permanently enabled costs
> exactly nothing, and does help with exec-only mappings on these fancy
> ARMv9.2 machines that are rumoured to exist.

I'm not sure it's _entirely_ accurate to say this one costs us "exactly
nothing":

> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 177c691914f87..13c0fa54ea19f 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -19,8 +19,6 @@ cpucap_is_possible(const unsigned int cap)
>  			   "cap must be < ARM64_NCAPS");
>  
>  	switch (cap) {
> -	case ARM64_HAS_EPAN:
> -		return IS_ENABLED(CONFIG_ARM64_EPAN);
>  	case ARM64_SVE:
>  		return IS_ENABLED(CONFIG_ARM64_SVE);
>  	case ARM64_SME:

as this means cpus_have_cap(EPAN) always ends up doing a test_bit(). It's
not exactly expensive, but it feels a little premature when compared to
PAN and LSE so I'll probably just take those changes for now.

Will
