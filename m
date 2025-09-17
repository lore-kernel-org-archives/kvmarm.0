Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F9234BA40
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758127400; cv=none; b=LiDrW12vIVruSus91+it/VSeojwa3uZDxbevh8/xCPxu6c2LkkzTOfnOY4E8D6PuU5mcza9b6ZBHVuIa0T1NclILi/tdiAXS9A19/MwKFtP4BzT/Wbmft2aPvDS5ZYjh6FrurS1YuOdfXpPrkrxHzX1oaTubFie+QcVJWaOOcIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758127400; c=relaxed/simple;
	bh=xEyniTA6kZCCEt9/e6UwyCJ68SzkpPAahdVtJFbmuZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f0QLiDFYzgnxq5/kZ4AKPvpFyZS6DoRy0gJj7tBfTbAhteY7ALWucu+ZW5FyGn+WKqa0K/k4n2KYHSWAL8L+QNmz0VfoNgiz0xIJYOV+t4cssBbydIpNPN68dMtXCm03bI6Ryz6FqTWPojN5q83HgfDInvi3lekV6Lufn27j4ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUH+jnNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUH+jnNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D063EC4CEE7;
	Wed, 17 Sep 2025 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758127399;
	bh=xEyniTA6kZCCEt9/e6UwyCJ68SzkpPAahdVtJFbmuZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUH+jnNSUD01BZPB0ohKYtxvP/09yEgMEh5lTA2iUt1NmmNNvt3shU+MTPXf3Z3Cw
	 Zu0iNoo4177A2PBUGvmMrunTOyhPMc3gI1veZQ7AkYuWqrU2FBtme71pVPOFjNvfcf
	 34SUWY6Jz3h7Rpn6NFkj7UI4l6/EIg1MwzrRmvSoLjVIekt/8HFUe58w2h2h8e+z1f
	 7bTrDuPzjmkZYjHIuykgvmnTL9ByhQhpGUteZoYs52Uz0trbAU1Tl+fHjYWH5fSwbr
	 m0vmPvIqDPZprXjO//NCogrmte54tTjpNyH2ojcl+XIFxI/AYo2sVY8GJ4zhddT/M1
	 TVmRJjGlprPtQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uyvFV-00000007AF5-2f6j;
	Wed, 17 Sep 2025 16:43:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: oliver.upton@linux.dev,
	ankita@nvidia.com,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Subject: Re: [PATCH v1] KVM: arm64: Fix page leak in user_mem_abort()
Date: Wed, 17 Sep 2025 17:43:14 +0100
Message-Id: <175812736819.1632848.17948994955088762874.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250917130737.2139403-1-tabba@google.com>
References: <20250917130737.2139403-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, oliver.upton@linux.dev, ankita@nvidia.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 17 Sep 2025 14:07:37 +0100, Fuad Tabba wrote:
> The user_mem_abort() function acquires a page reference via
> __kvm_faultin_pfn() early in its execution. However, the subsequent
> checks for mismatched attributes between stage 1 and stage 2 mappings
> would return an error code directly, bypassing the corresponding page
> release.
> 
> Fix this by storing the error and releasing the unused page before
> returning the error.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix page leak in user_mem_abort()
      commit: 5f9466b50c1b4253d91abf81780b90a722133162

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


