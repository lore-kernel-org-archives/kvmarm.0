Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5EA214A62
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 15:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738681444; cv=none; b=Tr0fFsPmACzHdGBHgzYJmNri5oDf/Z/8Pd6ADT3dRC6f86+Ks/QIoD1ly7eaNM02G1VL3RCpuHe7E5fmH33MJGzXrlh7cNDUHUld7WGe+tcf/RoIMDDfECgAfOMo2VueHbbVerdSrnvgZlsLEN/IF+dPkTv7txzO7vueChSorw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738681444; c=relaxed/simple;
	bh=2PpkFVtl+mFoGN6qKuG8Uod8whMTj06b5rjX6hr9B24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adKKflEbeOnvBXH5efRIZ+L2Jy2YkHx6bWdvTw9K5hs5X7BjAkLDtdEWn0IYvL6DaEwbr9DQUr66X7eh2jXq0nIG9Oi9NhA78X7IX1H6T76MZ/gg10z8HWp5FBaXzwoLSFqPkyEKryMYqzXLxxUPn3NHGX+aiHhPcnI2wM0H0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJavxyha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJavxyha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D3CC4CEE7;
	Tue,  4 Feb 2025 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738681444;
	bh=2PpkFVtl+mFoGN6qKuG8Uod8whMTj06b5rjX6hr9B24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJavxyhaFth/825M/ghxKMvp3MaZn6RwEATtSq7hbs/wcwkE/A/LDSs3IlAHdcf0/
	 i2zDjR4YlA8ctmJUWD7P2c+AX8kh6LpiCkYsdX/ZSE6svfK9jlCHPiFeEJeqIvLHqU
	 UHGwn/QMAACKbDS0U05gYUaZcGYzYFKxBxmdeMexOxHHqe7xbw9YsG8ioFQqDIvkvg
	 TR3UYryAsomgdvrZY8RiJGsotqr1GORP7QCsb+OXTgq9riHR1wHkIcyXdBJZ9eG4SG
	 8Ljx1SZaZW7hn/ppIBc1sCHdaVjWWEGo9kjsdPQe1zr71ViVLi/WC18OFDL3lTGwO4
	 Z6O8H20jaMQKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tfKT3-000Skd-Mt;
	Tue, 04 Feb 2025 15:04:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH] KVM: arm64: Fix nested S2 MMU structures reallocation
Date: Tue,  4 Feb 2025 15:03:57 +0000
Message-Id: <173868142680.774793.5944251840310076656.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250204145554.774427-1-maz@kernel.org>
References: <20250204145554.774427-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 04 Feb 2025 14:55:54 +0000, Marc Zyngier wrote:
> For each vcpu that userspace creates, we allocate a number of
> s2_mmu structures that will eventually contain our shadow S2
> page tables.
> 
> Since this is a dynamically allocated array, we reallocate
> the array and initialise the newly allocated elements. Once
> everything is correctly initialised, we adjust pointer and size
> in the kvm structure, and move on.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix nested S2 MMU structures reallocation
      commit: 5417a2e9b130a78bf48cb4cf92630efcee5ccf38

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


