Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11429302149;
	Mon, 22 Sep 2025 13:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758546900; cv=none; b=YqKtQr4k5Z1z/xwsSUFwjEvPB1B/hnps8gw299y0M8QDmjuqTdUQszteTyR8iV4O+DdxKXGlugFvlc4/nc12SfZ6kci42MSLumvdI7r7CsHkAVr2AE/DY7r/MlBZtDTuktH91/Ybrob6SbX6w7l8u/Q2ht98rtz/dXNZWNAvo98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758546900; c=relaxed/simple;
	bh=4mwrs79JuPeoSlr3rsZo4cRqZdSiJmSWsd/KzugKZww=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hp17+GZ0o/8pVygQ7MVY+iRqs9DmKF32Eorcr10RXgZp41UjdymsSgc9ohUDYMxD8ITlLUEYWoFnrSpfsX+ZKAVTM2AmbQKaGlHL/S36gKPjI9FXx3YtxIJpflTnjVsk1QmAMC3KwmtXLTdVKf5XG1EIhPXlspV9o8uqUiElFHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSzdRVWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSzdRVWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E95EC4CEF0;
	Mon, 22 Sep 2025 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758546899;
	bh=4mwrs79JuPeoSlr3rsZo4cRqZdSiJmSWsd/KzugKZww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSzdRVWTEXnok+wOor+BG+ngHJBbovfZ7w9cS1mQasnBEmOlLoMISVKtkGotLTX3+
	 Cex0Na6mlq18lF0qGcAUk/WdfroRhXA2GC6QqZD/6LRQ0G9SIYBsh8aCvjUMt1qNfo
	 GtukSZ3WM9X1qq6YJ5E0oe1DqRorHBLNljP5w1e4itzrXFsN7zFzsDjH4lzCzb1NtA
	 V1PYYrjHg+etxLlV6Eo4VIgm70BNq+zXwA1vSZx/lEQ1AfJOsfsujJPco1OCoJE50K
	 JaLX4/ZXdG4DA6Suha0YGwyzFWoqJ3KXQ3lZLUhyieOH3jtkzZoforjKBvF1yWzlEt
	 mY/G6aIVxezuw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/4] arm64/sysreg: Clean up TCR_EL1 field macros
Date: Mon, 22 Sep 2025 14:14:45 +0100
Message-Id: <175853863661.3125743.12776771359177737990.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250921005300.2535994-1-anshuman.khandual@arm.com>
References: <20250921005300.2535994-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sun, 21 Sep 2025 06:22:56 +0530, Anshuman Khandual wrote:
> Currently TCR_EL1 field macros are sprinkled across the arm64 platform code
> including KVM implementation. Clean these up via updating required register
> filed definitions in tools sysreg format and then subsequently doing all
> necessary replacements. All required TCR_XXX macros have been moved from
> (asm/pgtable-hwdef.h) into KVM header (asm/kvm_arm.h) for their continued
> usage in KVM.
> 
> [...]

Applied arch parts to arm64 (for-next/sysregs), thanks!

[2/4] arm64/sysreg: Update TCR_EL1 register
      https://git.kernel.org/arm64/c/14f158552eec
[3/4] arm64/sysreg: Replace TCR_EL1 field macros
      https://git.kernel.org/arm64/c/4f91624778b2

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
