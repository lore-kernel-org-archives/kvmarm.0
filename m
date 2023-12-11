Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2567B3D96A
	for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXVAutGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370DBC433C7;
	Mon, 11 Dec 2023 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702300297;
	bh=HyxA50VSNSu9/4ag8bMZv/nyTEhf2B6BLI15T86XngM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MXVAutGuwElXMr2qmpGQOF6UH+hffOho/+Q9UmBTDvNCKfJaDzTWP2b3YkZlkLani
	 82OHBuw1xmZvH0bR0iyjPDjFwD6GxXhFqgJGTJGgbuqcv/oT2JeNqH1JflyVYfGPul
	 C8Bfn30qcuzytss4US+m4PGqn88CpYfKHF6RxhNi0l+uNtEB5BRS2Vfrk1JtTrZXCN
	 37/WbdGAIwG5aJ+EZiCo035arULkR/4dWbp/X7AOzh3aQmyilYDcUH1MhIMiAO0u6z
	 5hBdFISMiKawxNyvbnNN5IetDxK1Jz56UXMf7dGrg1mqyBjzcIZm1+ZGctLheaFm5G
	 3PggBWBANQ3zQ==
Date: Mon, 11 Dec 2023 13:11:31 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] arm64: Make icache detection a cpu capability
Message-ID: <20231211131131.GA25681@willie-the-truck>
References: <20231205133148.2011836-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205133148.2011836-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Dec 05, 2023 at 01:31:48PM +0000, Marc Zyngier wrote:
> Now that we only have two icache policies, we are in a good position
> to make the whole detection business more robust.
> 
> Let's replace __icache_flags by a single capability (ICACHE_PIPT),
> and use this if all CPUs are indeed PIPT. It means we can rely on
> existing logic to mandate that a VIPT CPU coming up late will be
> denied booting, which is the safe thing to do.

Why do we want to prevent that? We currently allow it and I'm not seeing
what goes wrong.

Will
