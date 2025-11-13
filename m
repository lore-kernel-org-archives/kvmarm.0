Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387263126C8;
	Thu, 13 Nov 2025 19:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060459; cv=none; b=ea3k0PlD5fsSSBiGLn7ntWNz9yn2eroc/8V7ETx1luMFjwLCi3ttYztYMK8oWfsqyMi4ksPA03Xm4muHMCaHGzsS8NvSzFqji0HlU+hpvq2xGPP+PgC0qiMU/hP37NdwjO1VC2CsYiciGnwkY2/PTxt2PCnHSSTFBnMgulBbM3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060459; c=relaxed/simple;
	bh=H3Clw8gjcbGw+xYduDA4z9LON6MUCgNU2LErbevLunA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jGNWYutnSdwEuRhMRluRVCSyk2BnoaE3uBvPv86hqZOn4licqKTIBtKQUsZmTHIM+WG6HXU4XWyjxUwEQ1ABSNVN3fDPY7yE2Ot0GPk+IfGKN75vup7w1yYckkTEwiT1uwBVI+88Pp/1MyAJAEg4+CHr4ONMcuBsBkxQVe2UTPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+Yez3vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+Yez3vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF70AC4CEF1;
	Thu, 13 Nov 2025 19:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763060458;
	bh=H3Clw8gjcbGw+xYduDA4z9LON6MUCgNU2LErbevLunA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+Yez3vmqjImQAJABdv5lgo/kTd3N3vuVjk+1UX/x5vgaM99H4vpn7D4JLiz931UD
	 Ijlk5tIw7KKbWa/qH4wH5umbshiKkLsR5qK5A2E6o5ZbnAsxBwYMmlZ5L3dRDYc24m
	 J+N4C6AR6JJP1rD+ikyfxnUcrULUugoG3rjTy1qfcK5onkcINdeFRMvI01xOkamx9m
	 RvZaFEx6/OC/Z62ozbtLlnIyxaDwzU0ySGIEdOIEOk5mvwU2ZW332zHDLCkuYUAYpJ
	 GqK5Dcu6hx9ph1jaFWZ82+6FjNd1HgABR4Lrb24Vb3C0giXGaXzFAkplRQS7iz4ihG
	 8q9+N7NUORl5A==
From: Catalin Marinas <cmarinas@kernel.org>
To: linux-kernel@vger.kernel.org,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: (subset) [PATCH V6 0/3] arm64/sysreg: Clean up TCR_EL1 field macros
Date: Thu, 13 Nov 2025 18:59:34 +0000
Message-ID: <176306037412.2469077.5781631213880341597.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013052945.2197190-1-anshuman.khandual@arm.com>
References: <20251013052945.2197190-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Catalin Marinas <catalin.marinas@arm.com>

On Mon, 13 Oct 2025 10:59:42 +0530, Anshuman Khandual wrote:
> Currently TCR_EL1 field macros are sprinkled across the arm64 platform code
> including KVM implementation. Clean these up via updating required register
> filed definitions in tools sysreg format and then subsequently doing all
> necessary replacements. All required TCR_XXX macros have been moved from
> (asm/pgtable-hwdef.h) into KVM header (asm/kvm_arm.h) for their continued
> usage in KVM.
> 
> [...]

Applied to arm64 (for-next/sysreg), thanks!

[2/3] arm64/sysreg: Replace TCR_EL1 field macros
      https://git.kernel.org/arm64/c/b0a3f0e894f3

The tools header updates can be triggered subsequently, I haven't queued
that. I left the KVM changes to Marc/Oliver.

-- 
Catalin

