Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E07206F0C;
	Thu, 13 Feb 2025 18:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469761; cv=none; b=OQ5qthzbp/qm9SG1IoELkpRQkqJwUDfLVteeArRjphsRO0wgfdRk8nFjvlFFFjUfdC1LHXVXLNdlqlChxwZwqAmW2dwnHmnnnUj3rQ1Wm/9T1aHN9crT/SUOCfFol5Rm5YN3wrF4yVxU3N1mKf89Ocq23lF6jTN3aqVkFxVVvEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469761; c=relaxed/simple;
	bh=KCXWCt1tfCPrXneMgT2CusbMh3K2XAvWCZTxxW+kCs4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o0m3ZTt/6UxCs4Hhxq/E2/vlEbKGazKfv84uurcAXWosRnMOdFPolYn80s8sYIGk3/Tx2XtLupw5o+sIZIe+xPps669GBZ7oJKNq4frYSU5+rhVngW5Tcr3IboWzuDf5PMHzkgrJpZJStZMB33sy925/yxgicTwGZYiMjTSLndU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4TlgEEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4TlgEEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACAFC4CED1;
	Thu, 13 Feb 2025 18:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739469760;
	bh=KCXWCt1tfCPrXneMgT2CusbMh3K2XAvWCZTxxW+kCs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C4TlgEEz2SIOtgFa6lO18TAdRvksbF9Wc6+oD9Vqpiq7bGnLbTTqagyvRr/dKeLo7
	 BapSmWlLvzEwd/0rNdVKBe2fGvEdR+XzfCEyQZkZKYDwMMil5tN8KsqHuruLCEZcJt
	 AQhlkfgRcAU6pB1r6hLJXO7YYbAXtsf20wMFMivmYg+WpqrihiEEOf2XbQoeh7FBjI
	 aPNKbj24qU4yUPWTXs31yTsPNDce6S+8ELHefezrbMwh4PrIOKfNnZBQTSLef00XKX
	 CJrdbasTp6zPEnxO/XqPeTmRnlt1WnIHsQ1IrM5nwcpFoI3CSpacR+OBlYMU2XViIZ
	 4jn3k0D2mhbbg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tidXq-003nWM-1J;
	Thu, 13 Feb 2025 18:02:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Cc: Keir Fraser <keirf@google.com>,
	Ben Simner <ben.simner@cl.cam.ac.uk>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix alignment of kvm_hyp_memcache allocations
Date: Thu, 13 Feb 2025 18:02:35 +0000
Message-Id: <173946974570.2974684.11799250388121421778.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250213153615.3642515-1-qperret@google.com>
References: <20250213153615.3642515-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, keirf@google.com, ben.simner@cl.cam.ac.uk, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 13 Feb 2025 15:36:14 +0000, Quentin Perret wrote:
> When allocating guest stage-2 page-table pages at EL2, pKVM can consume
> pages from the host-provided kvm_hyp_memcache. As pgtable.c expects
> zeroed pages, guest_s2_zalloc_page() actively implements this zeroing
> with a PAGE_SIZE memset. Unfortunately, we don't check the page
> alignment of the host-provided address before doing so, which could
> lead to the memset overrunning the page if the host was malicious.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix alignment of kvm_hyp_memcache allocations
      commit: b938731ed2d4eea8e268a27bfc600581fedae2a9

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


