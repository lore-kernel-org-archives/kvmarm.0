Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B1D6084D
	for <kvmarm@lists.linux.dev>; Wed, 24 May 2023 12:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688B5C433D2;
	Wed, 24 May 2023 12:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684932589;
	bh=cOFN2G/iT6VXMnNjHgQa0UC2BMzAHqV2vza1H2oeKTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCM5hu9L9UrEngsmsdqqtfeLWm15y5V2Zgb+FDbJ1EcWzf44qiVq3H2K/nXCbo+DC
	 7IRyOiWXvjkDH6GKETm85rCY+bs0FCQTKXq7gfHUeHIJsUHCjL3+vJYvntOD+Qz5S7
	 uMsreTPYF1RtGNTxZHrhLoy+upWdOXeKB5a7KQq6v/C6oUc10cCvVBNk25WkXdfgxa
	 UQsbXQpVk4jShNnK6Ec7WXyW2orag5jc7vpr7cpK8QVvz+PKSP8W0NgyZvxAP/GRRJ
	 vCFLBiEJSdz6eDabsdrXTYW/C1uDJadt67oXwjq0Is8Ho8QLpV2t/gim2cr/DVWKj6
	 xwTAHJtF1CUKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q1nw2-0002Ld-Vx;
	Wed, 24 May 2023 13:49:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: oliver.upton@linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: yuzenghui@huawei.com,
	kvmarm@lists.linux.dev,
	james.morse@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	suzuki.poulose@arm.com,
	catalin.marinas@arm.com
Subject: Re: [PATCH 0/4] KVM: arm64: vgic: Locking fixes
Date: Wed, 24 May 2023 13:49:39 +0100
Message-Id: <168493254802.3630329.8583196060399633594.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230518100914.2837292-1-jean-philippe@linaro.org>
References: <20230518100914.2837292-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, jean-philippe@linaro.org, yuzenghui@huawei.com, kvmarm@lists.linux.dev, james.morse@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 18 May 2023 11:09:14 +0100, Jean-Philippe Brucker wrote:
> Another fun locking puzzle, between the new config_lock and srcu.
> Patch 1 attempts to fix it, and the other patches fix simpler issues.
> 
> I got these lockdep reports while running KVM QEMU on a TCG QEMU, but it
> can also be triggered by running the vgic_irq kselftest on TCG QEMU.
> Now, with the fix and lockdep enabled, vgic_irq hangs but I believe it's
> an unrelated weirdness: if I introduce a separate lockdep warning for
> some made up locks, then the test passes again. So I'm sending this out
> now for discussion, and will investigate that one later.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: vgic: Fix a circular locking issue
      commit: 59112e9c390be595224e427827475a6cd3726021
[2/4] KVM: arm64: vgic: Wrap vgic_its_create() with config_lock
      commit: 9cf2f840c439b6b23bd99f584f2917ca425ae406
[3/4] KVM: arm64: vgic: Fix locking comment
      commit: c38b8400aef99d63be2b1ff131bb993465dcafe1
[4/4] KVM: arm64: vgic: Fix a comment
      commit: 62548732260976ca88fcb17ef98ab661e7ce7504

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


