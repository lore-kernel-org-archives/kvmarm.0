Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88413659EE;
	Thu, 23 Jul 2026 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823082; cv=none; b=k9nefTZa9wlVlLYuHUIMkWZpL8axn3rPwuh3BiGjmAHTCyK7tdpHBh1xGJuVrGEwDtw8+VVFWoPYzOoT2s7auCGqY2as9swTHqaofYWqEbL/qbeFDtjKm4qULqak/RzPYLlznGW39GyopI3Fxr9lEcvI6CEXCZf01q2qdh4PtzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823082; c=relaxed/simple;
	bh=Ns/WeDQQoBGBoz6QF2YD2fU+mT+Gn9daJO852t4UjcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ECrFgopEeSGg56WiYMiVaKnYlLL39drySfFuDdtckgMrQjarGeFH2qhdip2GtwAyLWr9MsYeRnB2ZtOY8JF625mLFSlL/PM5JeZwMVPykOcp3fRYrXYelZie9D5OWPf9S60TjpO3QGhWfQZnYN43sGOCUFwHHw8/z74/MITgblo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E204B1F000E9;
	Thu, 23 Jul 2026 16:11:19 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmw0m-00000008721-0s2F;
	Thu, 23 Jul 2026 16:11:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/2] KVM: arm64: vgic: Fix racy LPI release and re-registration handling
Date: Thu, 23 Jul 2026 17:11:01 +0100
Message-ID: <178482303771.3351010.3978266372982748047.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715105137.3973823-3-clopez@suse.de>
References: <20260715105137.3973823-3-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, clopez@suse.de, oupton@kernel.org, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 15 Jul 2026 12:51:36 +0200, Carlos López wrote:
> Fix a couple of potential issues that could arise from racy LPI release
> and re-registration for the same INTID.
> 
> The issue fixed in patch 1 can manifest itself through either a
> leaked LPI structure, or a prematurely deleted LPI. The issue fixed
> in patch 2 could materialize as a spurious -ENOMEM failure when
> registering an LPI.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: vgic: Fix race between LPI release and re-registration
      commit: cbfe2b24a1ea9de35032dbdd100fdc700f5be92d
[2/2] KVM: arm64: vgic: Mitigate potential LPI registration failure
      commit: 21f12496fdd357ad4e1fcdd07dc80ab7378f7d24

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


