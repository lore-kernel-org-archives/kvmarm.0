Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A206F289813;
	Wed,  9 Jul 2025 12:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752063759; cv=none; b=m4ycDvnHWlVR6TwObgmLn50843xHoA2Z6J0rFY16R/8wa7YrcMjh3G4XDA4yIbTdo6T+EDwrFbUgDrwt7Zo24QxeIcON65A/kTeJ30c2/L3pEhnspBCesxd2D8sf+imBIuTv2yEJfTUuB5tZjlZzT2eSqg0ribYVJ90oAtg8OG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752063759; c=relaxed/simple;
	bh=ExusPl54+Z+6wa6Xfyog2ejojzWjQojh+qnvn+buZQ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IxG8dvboc9X1dtcg4RkgrUFENRJFTc9VzW+63R+6LGYMrYvLvYcm4vI9iGmlrcPZUIPxQg9qhgT6XldKnnOHrjg4QoEcX/lI7cvP2/7tPb5GCC2/Sle1Yj53ttXY66xbG4zvKCeamDzBt8mvomXTimGGpmn2XbLALTcxGXS2eNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aOK/pXVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aOK/pXVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C15C4CEF4;
	Wed,  9 Jul 2025 12:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752063759;
	bh=ExusPl54+Z+6wa6Xfyog2ejojzWjQojh+qnvn+buZQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aOK/pXVq98TtbtsMyifPo27ZSiq4dlguYgxXqQfIH75/DZ+tloIWyr/e6Ee80jY8a
	 BLFyS4i/7yHe7v1kjo5SV97w13jRqyxNxxqiiNfIiRxuWF+G7McEq5C4jYKVk2wNvt
	 cvf5cvn+NzO7NHKmTm+58biAMXmJxCFcLiGANsBj/1tp5jMTOSH6q264W38oLqWP5C
	 +pylrmwv6HzcTeYfa1ZGESqAh1hjAo5CFaeUUxE9Uv2l4xeXW65ilJkp5HfPhzrsXL
	 y9pikMjVy0SGwOyy16hfn5x5p6L4nzQZqiV5wvQfzmJIxQvx9mS4JkkyO+4gCU6PVn
	 MUsPKVz+LMJCQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uZToq-00E8wS-Kz;
	Wed, 09 Jul 2025 13:22:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	linux-kernel@vger.kernel.org,
	Ben Horgan <ben.horgan@arm.com>
Cc: james.morse@arm.com,
	stable@vger.kernel.org
Subject: Re: (subset) [PATCH v2 1/2] KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN
Date: Wed,  9 Jul 2025 13:22:26 +0100
Message-Id: <175206358921.2018765.12923963855524409894.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250709093808.920284-2-ben.horgan@arm.com>
References: <20250709093808.920284-1-ben.horgan@arm.com> <20250709093808.920284-2-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, will@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, yury.norov@gmail.com, linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org, ben.horgan@arm.com, james.morse@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 09 Jul 2025 10:38:07 +0100, Ben Horgan wrote:
> Previously, u64_replace_bits() was used to no effect as the return value
> was ignored. Convert to u64p_replace_bits() so the value is updated in
> place.
> 
> 

Applied to fixes, thanks!

I have dropped the Cc: stable, as ths bug only exists in 6.16, and we
are not backporting anything related to NV to previous kernel versions.

[1/2] KVM: arm64: Fix enforcement of upper bound on MDCR_EL2.HPMN
      commit: 2265c08ec393ef1f5ef5019add0ab1e3a7ee0b79

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


