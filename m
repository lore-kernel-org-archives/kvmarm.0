Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7987C231858
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 21:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764106082; cv=none; b=GJAPYFu9unbtOg2oeHmjh9EBidjZST/FeJ3zEivCau+3Hsj88/WEQaf5LNYdih+GzJ+vNe6TBJhLX7B24QBYst58ZMwf+UslvxSCy9tT/JsPhGlx09hmHjceDDhxlN5pFyjld8vgghG6hM2cc7iUHjc2A72rZWxYYqljqHUQH4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764106082; c=relaxed/simple;
	bh=Lthp2oIt0CjSTyCBl6DdHeK3C8f8yjc6ypdos1FTR5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fx46SdjSloAciw+NADdQaFGXu+n1Xrw5yQ/D+KNc6216jf2whE4WJ6ujbUoXwI0RDAn/VqvhK9rA9jturD6V9RknzhHNXyHDxzwljC7s0xkz0oyc6ng8u2LPAA+gNsCcTdJ+kdlyO4iij6Q8NJwXeLqmi1/6B8RD0ckcDtTYspo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CgIVQwWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CgIVQwWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7399C4CEF1;
	Tue, 25 Nov 2025 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764106082;
	bh=Lthp2oIt0CjSTyCBl6DdHeK3C8f8yjc6ypdos1FTR5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgIVQwWURIbdEZ3ocsensRhZKL7wV1xvWkKKDVbNit1OCAkrfIeYyvEjdmnrc/WnJ
	 0ZQtSoKlCgewMZ4UKWi61o3MsHQ+eY96LzKigyGHVcQSj9BDvAhwMgJqJuZfYDPkMx
	 fhK0jT5wwgXCvV+tYevIKTXpj0YudgyN21qUXMtAbPlNDE+jdNt2CHLfbaC+8OBotj
	 Q9l0MqTSDTXyg9bMiJP9qmT6BTqs2wKAz03bgDfb2PPIr+JBauloeEB36jvAG1Wqhh
	 TVzKkVFvkKsK0taA215mB//BuTcCRSzNP0I7Li/RBDqMJXsWLFU92GMvMt0FJ4febN
	 LaBG86xAkv65g==
Date: Tue, 25 Nov 2025 13:28:00 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>, will@kernel.org,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	shuah@kernel.org
Subject: Re: [PATCH v2 0/2] set_id_regs cleanup
Message-ID: <aSYfYC4UE3H9SDs7@kernel.org>
References: <20251125101207.1492580-1-ben.horgan@arm.com>
 <86cy56qgi3.wl-maz@kernel.org>
 <aSX2CSJEwUYkn5GQ@arm.com>
 <87cy55galp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87cy55galp.wl-maz@kernel.org>

On Tue, Nov 25, 2025 at 07:45:22PM +0000, Marc Zyngier wrote:
> On Tue, 25 Nov 2025 18:31:37 +0000,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > On Tue, Nov 25, 2025 at 03:27:48PM +0000, Marc Zyngier wrote:
> > > On Tue, 25 Nov 2025 10:12:05 +0000,
> > > Ben Horgan <ben.horgan@arm.com> wrote:
> > > > 
> > > > For this v2 I've dropped the ksft_test accounting fix. Mark Brown has
> > > > more extensive changes [1] and looks to be a user of the set_id_regs
> > > > test rather than someone just doing some cleanup. The other change in
> > > > this series is to remove ARM64_FEATURE_FIELD_BITS from the tools
> > > > sysreg.h header rather than the kernel version. I'll send a separate
> > > > patch to remove the kernel version.
> > > > 
> > > > Tidies up a few small things in set_id_regs. The removal of
> > > > ARM64_FEATURE_FIELD_BITS touches other code only so much as it removes
> > > > the define but set_id_regs.c is the only place its used.
> > > 
> > > Acked-by: Marc Zyngier <maz@kernel.org>
> > 
> > Thanks Marc. Shall I take these through the arm64 tree, together with
> > the removal of the macro? They should have probably been a single
> > series.
> 
> Oliver is in charge of the merge window this time around, so I'll
> defer to him, but that's absolutely fine from my PoV.

Catalin, please go ahead and apply. I don't believe I have anything that
will conflict.

Acked-by: Oliver Upton <oupton@kernel.org>

Thanks,
Oliver
