Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609FC2EFDA6
	for <kvmarm@lists.linux.dev>; Fri, 30 Jan 2026 10:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769767204; cv=none; b=mgoaw+pYXrsVvPmiy29y2496MZ4EIfHqVhwkzkEyfqlKsZ0/9Tf7UWHDjmv6cFLC64dUdOaipqHnByEa7V+w7OLbgLHC2eW204OsowWcxLighbemrKkSGJ9xduA1B1JzCOT888yeQZFOT1YJrnPUv4xdPxqwsq0gXbuZHqDXeEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769767204; c=relaxed/simple;
	bh=XmpHmdq1HfTT5TO3UqPlxsFYq0BALvEmTrAOu4O+SBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OyJvSE9rwSWBJVNhZC7B7pen2xxwyvg4dgUCr4gOU4xz8aWwifhrBsSV8tJmrW96ZK9gzMeaiS31uf81g2pO0G1d2uyPaOuwjQMS1UUAJwRux1LR20Qm5zBThJpeUqi9nFQ4tw1P5BloanNjUAHOTuijHppIHR2ecyFa/ZxOrxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOEZRsRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOEZRsRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37D6C4CEF7;
	Fri, 30 Jan 2026 10:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769767204;
	bh=XmpHmdq1HfTT5TO3UqPlxsFYq0BALvEmTrAOu4O+SBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOEZRsRze/2xRJN64xGZWXdND9Pa0WkXXHbl+cPH5YWcdEr3ulVdhPEOvqs1o0grD
	 C1+dM1gmGUqinF6z7FmH6NBP689VRQIs8ehWE4qXpKQNS/NYE57ygaKJgRBZjRfzHF
	 sabk3GlBPtb95eSCmQwUtzGWlqnIqjRKCJg9dmI2H87ePmfafMEaQFPnnaSy8BHPkJ
	 Xq0T3qgvQamTLap5n7+D5d8COsL1qtfGbJDfW6nAdmBBX/ZMDo5V5wbW4wNYS2DbkA
	 jyWZy9vuMvOPuJQDK8Jf7ren/WEDCHSxO8VXpXeQqC9JuC8Y+xb23Lt1vUuqfXZPPD
	 5uqckPmyj0f+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vllIH-000000071QQ-2L1y;
	Fri, 30 Jan 2026 10:00:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	wanghaibin.wang@huawei.com
Subject: Re: [PATCH] KVM: arm64: Fix various comments
Date: Fri, 30 Jan 2026 09:59:56 +0000
Message-ID: <176976718624.2311376.11327321071827821123.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128075208.23024-1-zenghui.yu@linux.dev>
References: <20260128075208.23024-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, zenghui.yu@linux.dev, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 28 Jan 2026 15:52:08 +0800, Zenghui Yu wrote:
> Use tab instead of whitespaces, as well as 2 minor typo fixes.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Fix various comments
      commit: 82a32eacbacc6f7e372f98999e5ee1ee0dd7462d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


