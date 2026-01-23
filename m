Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2523009DE
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 11:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769168858; cv=none; b=BwQqqzfS4BiNKVhNDpmwcuDBGQRcL2GOMkq/sSqPD0qzUoQQcxE8sLOKR3Dfby2N7n1i6kcxcOytQLoWLeIj9Ssaf95UQ5TKgFIXgYdjWDAosqF+vYM9O7HEqJe3M9dbhXxQFlsDdGR+v2Tq7VPGdK5+CToVOZs15BnLOIJwjfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769168858; c=relaxed/simple;
	bh=eRuKxWOMlnjHgiZEV5213EEYlA17aFkixqemYW9Czf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jyOFv1KiSevSgVYC56r1nYToTJHUgwOsRmzINQuOgMWIsHJOa+sJe5Vld7RyA5C+FlJYKfvZc484piKapPc/0ESsVQvsN4itWEWlzIQKosjI6750NU8fJ5gFsaNsm0S9B+/EMz7ZSY/qKyW2uZN3FQVNhKgn0gdwbaYz5bEWx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=up2JIwyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="up2JIwyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D688C4CEF1;
	Fri, 23 Jan 2026 11:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769168857;
	bh=eRuKxWOMlnjHgiZEV5213EEYlA17aFkixqemYW9Czf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=up2JIwyVxC3fpUH9haWPzKn5c3nHzuEvg0aXouWmG5305K3PWCwUM1DbulLpicVy4
	 RC/OyEP0hvNthNs/jCasFbjn0QAORoSEagrQJe6Xj4y7PE8pkQlStcruO7DGuDKsU3
	 d8BhMFtX2CyFp0FkBPsduDVvgioCGgcmv/4rJxUAPKE81Hh8jD2VWcrNhjChP6Z+u+
	 tmq/qbSz3pFXKk0Np11A/MgqzlSNEXgqKoKwlEsSBj6o5U/m9CGwwYMUj9hWWoZzOI
	 TTEBfxM2T6aUkfeuummifXHb6a/hGNaSDLRdoEFwGd9xq4ongDsSOGDhXe/cNoBZAv
	 vAa/gmNJ9g5kQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vjFdX-000000052LF-0pOC;
	Fri, 23 Jan 2026 11:47:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <tabba@google.com>
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v3 0/4] KVM: arm64: Enforce MTE disablement at EL2
Date: Fri, 23 Jan 2026 11:47:31 +0000
Message-ID: <176916883962.704159.2345456855633126333.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260122112218.531948-1-tabba@google.com>
References: <20260122112218.531948-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 22 Jan 2026 11:22:14 +0000, Fuad Tabba wrote:
> Changes since v2 [1]:
> - Trap accesses to GMID_EL1 by setting `HCR_EL2.TID5` when MTE is
>   disabled (Marc)
> - Dropped patch refactoring `enter_exception64()` in favor of open-coded
>   logic in `inject_undef64()` in patch 3/4 (Marc)
> - Based on Linux 6.19-rc6
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Remove dead code resetting HCR_EL2 for pKVM
      commit: c103c2dfe4975da31b67a0fcb95761359f30992d
[2/4] KVM: arm64: Trap MTE access and discovery when MTE is disabled
      commit: f35abcbb8a084db4c24b66ccc8db0405c08e2f61
[3/4] KVM: arm64: Inject UNDEF when accessing MTE sysregs with MTE disabled
      commit: 5ee8ad69da07d0e2cffa0ce2f2339c9ad2d587f2
[4/4] KVM: arm64: Use kvm_has_mte() in pKVM trap initialization
      commit: 230b080623fec2e1302df2afe2cf2dcb34f9c89b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


