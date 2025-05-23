Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9893183CC3
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 11:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747998090; cv=none; b=b3bvkrGq2WzicydG27kJ4T2/qu1jT7Kir/5iQsz8ZOaN8B1MLHqEkiWFbfMQL+wqACiO9LyaBRXZVKDljEO73YiZaGc0Xf10RkTYYXv6YFHtK+VdEBRsofvhITmprgsbo6spDAfTae06hjBBC2wU+VmW2dUhTgQnz54SB8/Jbjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747998090; c=relaxed/simple;
	bh=i+bBzliGOaU9GAlvZj2GNd3o4IjHCNM5Ha0nUaD4hG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aA1Z9Ae/huViKokgZ/eUyFKsGg2vPSjAtSvnG44vgBHpWJrE4Ze8Xdqlck0ds4703FG8Lf3iY9+kh/bYTxy5yED7CnHN3N9xbp5oMZ3YtEx08R9xtBo8LlBOIVYmIGZFutdnhl5GiSD3IcktQVNGkh2vMypJb3A6vYgx42vdkmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJBvNWPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJBvNWPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E563C4CEE9;
	Fri, 23 May 2025 11:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747998090;
	bh=i+bBzliGOaU9GAlvZj2GNd3o4IjHCNM5Ha0nUaD4hG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJBvNWPgO6j+c/lC7FRIhK7Tdr9pI8++y95+5/ML4j8gWvjVtm3EpovFYPSWqVP/1
	 /al/6zs1VBY8rrFoyKGDzuX6kpqB6cNGfDpf3QT0xRHRSxU2/zYdGQy9L/JBlRIccF
	 2NfEzi9spOyhM8u3A2GeFSW2RVIdM2ReoMdTj5mkU6wTiPW4GrZg2zikOZIisRvJZy
	 GdHgJ5EiaKplUY1dWqocQmafPdGCcMjvBY3zhjdzaHdLexnapuCfUI9En3dD/UTKxV
	 W6W0LHBJTe6QV2KczOeCQfRFK7RmfJD/Djliw4mzX6eFwHiYNQQqf5NFTTuuIH9Gfj
	 TKwfwRpcgOzyw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uIQ9Y-00HYcR-De;
	Fri, 23 May 2025 12:01:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: nv: Handle TLBI S1E2 for VNCR invalidation with mmu_lock held
Date: Fri, 23 May 2025 12:01:12 +0100
Message-Id: <174799806252.145825.12198525188454044758.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250521110514.66305-1-maz@kernel.org>
References: <20250521110514.66305-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 21 May 2025 12:05:14 +0100, Marc Zyngier wrote:
> Calling invalidate_vncr_va() without the mmu_lock held for write
> is a bad idea, and lockdep tells you about that.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: nv: Handle TLBI S1E2 for VNCR invalidation with mmu_lock held
      commit: beab7d058309bfe0460a441b1c73639941e33d38

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


