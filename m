Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7073F3F074F;
	Thu,  7 May 2026 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778160019; cv=none; b=hko5Cgxk9hN9SDaSNeezku+iQ8QES1jUne0Ro08YfWepSLN6WZLFcXUCtxlceA5006VE3TUMaqZuBcSmtpRhGWfyJKWiYJ7SiacOlpkATgCoQAkT7zYaSLuHljeuAhvazoYFyC7a0s7vP4LE6pE00hJgCOApX/1uptmLjaBqQKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778160019; c=relaxed/simple;
	bh=36ZswlSdEoa6CeQfZEQN8KqozyQBxq2eB7Tc0h/yYIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NU1BNsKODfrxUWcVDW8jJ3cwmAOY2oT5rNyXgimQFFHq0tLJuqHFvESycezu8oACRdML/oYex8wcjtzb6N1TDz+fhiGmK2H1VsJhP780EqOjLtvjk8/wkodoOycw6q4qmEF/GwQpEKdpw9A14BL1D2NY9f2imIeLjpIcguxnwsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8HSypZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8HSypZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11717C2BCB2;
	Thu,  7 May 2026 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778160019;
	bh=36ZswlSdEoa6CeQfZEQN8KqozyQBxq2eB7Tc0h/yYIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8HSypZiCPj9qsm8/i8LQ4YAD7nehVRteknpw9ph2arJnL2pPxB3EBmL3dAGahj9j
	 sZCTrYzPYsJOJY9lBy5ozrsDHwGQb3KkOUMzb/VDkwDPdRZfPH370snZJWPdDAfp/3
	 OvCtvvkrU/DtmwViqSqTnUCIq4uIJUdI+zMb6A8/wAinaOWvKJuFkRwGQdiVi/X1ps
	 oeUL7Sku6N7VAbfQcyI55LL+7j6vCP8GaVvHC8bcNAlI8i9oeEatjdfbFr9XZqEyHb
	 95CaKZp8yIJwE0UfTY4ab21x2T9drfmD//DwvU1HLGDnHWS6gNknjuVh45WFWLV7UY
	 Nj8i5My6W4B3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wKyeG-00000000dmL-3G5r;
	Thu, 07 May 2026 13:20:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>
Cc: james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	vdonnefort@google.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	yaoyuan@linux.alibaba.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 0/6] KVM: arm64: EL2 synchronisation and pKVM stage-2 error propagation fixes
Date: Thu,  7 May 2026 14:20:13 +0100
Message-ID: <177816000554.2904218.14736928674688744601.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501112149.2824881-1-tabba@google.com>
References: <20260501112149.2824881-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, tabba@google.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, qperret@google.com, vdonnefort@google.com, catalin.marinas@arm.com, will@kernel.org, yaoyuan@linux.alibaba.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 01 May 2026 12:21:43 +0100, Fuad Tabba wrote:
> V2 of the kvm/arm64 audit fixes [1].
> 
> Changes since v1:
> 
>     Patch 1 (SCTLR_EL2.EIS|EOS): Fixes: tag corrected to 0a35bd285f43
>     ("arm64: Convert SCTLR_EL2 to sysreg infrastructure"); the commit
>     message now explains that the conversion auto-generated
>     SCTLR_EL2_RES1 to UL(0).  Code unchanged.
> 
> [...]

Applied to fixes, thanks!

[1/6] KVM: arm64: Make EL2 exception entry and exit context-synchronization events
      commit: d7396a72eae795d7f968fb451237b6ac1616d712
[2/6] KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
      commit: 300fac4cc266b7782d88602b6b6a7faf31ce6405
[3/6] KVM: arm64: Fix __deactivate_fgt macro parameter typo
      commit: d4d215e5b81ba5acb17752cab12c514a8062bada
[4/6] KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
      commit: 5130d450d1488e62e1b5310f41910a3c7320e827
[5/6] KVM: arm64: Pre-check vcpu memcache for host->guest share
      commit: 8234409ffb656970e2f5b29e416f041419980bef
[6/6] KVM: arm64: Pre-check vcpu memcache for host->guest donate
      commit: effc0a39b8e0f30670fe24f51e44329d4324e566

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


