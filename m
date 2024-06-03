Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9681112F37C;
	Mon,  3 Jun 2024 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425323; cv=none; b=INQwAZojRbvPOD29x4Aeri1R8FWtNaLEeB3Njt3U9Sju7RTpBou9IRX5gX4jd11w3Ql9p7XMJy5yoenxACHa2jzLoczO8Bbd/od+L2tbw6hmu4nU+RV8biso0+shAAh9MiDGDxeo6XAenASi0hT8LcTEACmUKE8dKJec0EGPImU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425323; c=relaxed/simple;
	bh=euJpfVQU9zj8p/s1zGGGRWYJoRokLwuyPbH4xvTgIN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORN/X5ACg/OeIzBGeQIWNItqT6GGB7fBP+t+Al8sBX2k+v3mtlk32HMeNnYExvLfDIRBQCXv6smZQ5F3mJwy1o8k0UAvz32Slf1vCbD/I1w7FjxgowABg/CQhJqtMTOCcoIcgM4/c6Jtz+f4g+mBZiY1gsaE03yMwIC/x7GJiMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkTOAwTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkTOAwTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFC9C32781;
	Mon,  3 Jun 2024 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425323;
	bh=euJpfVQU9zj8p/s1zGGGRWYJoRokLwuyPbH4xvTgIN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pkTOAwTjyr7AGWLkmoe9fEg5fFgCMQoPu7WI1POnXsDehXfDlJ9SqTlFH/vFknGMQ
	 mMvjIQMX8dXehl/u/BRaeD4GI8R79rJUkwZYcBpB2WqaebyZrPH0AeT03wTyiXMBtY
	 keeMgQlb2CGOF0LQoK73qqDUgJciZVkgGBpZaRjoIapakhdPEl6ff4mg/mc2vVtnwp
	 b8+v/6AwtFG3IuONMawekSyan3/nBuvLoRHcK8HoLjtwvAHCeIrnsk0s4BRAEzMWBM
	 f5VEuUTV2zGegBHeug0zXiFMrhxLV1ERHbYZ1VE3mZ3ssYP45GqppPlbcaY8qaBKmT
	 IeKYTgtYxqVsw==
Date: Mon, 3 Jun 2024 15:35:18 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 06/13] KVM: arm64: nVHE: gen-hyprel: Skip
 R_AARCH64_ABS32
Message-ID: <20240603143518.GG19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-7-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-7-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:12PM +0100, Pierre-Clément Tosi wrote:
> Ignore R_AARCH64_ABS32 relocations, instead of panicking, when emitting
> the relocation table of the hypervisor. The toolchain might produce them
> when generating function calls with kCFI to represent the 32-bit type ID
> which can then be resolved across compilation units at link time.  These
> are NOT actual 32-bit addresses and are therefore not needed in the
> final (runtime) relocation table (which is unlikely to use 32-bit
> absolute addresses for arm64 anyway).
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/gen-hyprel.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Thanks for updating the commit message:

Acked-by: Will Deacon <will@kernel.org>

Will
