Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2FD410D06;
	Wed, 27 May 2026 13:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779888952; cv=none; b=QKCOBQAzaYJ5r/A6RYrrUehJHX5FgMx8IrYm32tZ+1SbGbKeNiq4aR2gkDqahOXVKGCyAyn7POYige2jbEK8mdmFlIOjtnmbQZsLI+sN1YvQ5Y4En0wCqAaE53P0T1GzP7BdtuhXUd6oQTEGrWNUYtSMN+ibFPNEap+Co2g7UY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779888952; c=relaxed/simple;
	bh=bP6yf/dnWu8YIljMG2BMqWC5MYvupLtEE0zz5IiQIA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=akUr+n76gmWbXorC2KxJw+45box33OshwOccI/uLDcT0AJGOj74Xzcea83mocRqldNJJUnW2VGR9XyV/bNbOl1pOt1xEdTi1kzKLSorkcqMwOVxHatWe687r74ZR2n1DAziqSP5VChq5YGlUHKPRpHxCX3V7SLi59NZ4WNvsFmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLmVXooH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLmVXooH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D2F1F000E9;
	Wed, 27 May 2026 13:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779888950;
	bh=d34ciTxG/47qWh26HChtVlWlXdmTlrot9eCQiU6gEY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLmVXooHEe0KwtJBbrmSgaiklTlpB5fpBn5xJAqZmkNBQfJGUZfyyA3078vr6Udrz
	 hcv3rGOtVDbXxxM/iBYzEAzxlKIf8pM3tMjkOt7sjFhNtlo8Ae6lqE0rl7h7WWas1B
	 PU5xGEWA9mnHyJsTcVHregQJnDkkaKRaUcJpK7ItZQU6gBnrhpDbwKSsg2UDpJXCjP
	 nsVOCEqI4w7UbHuzkA95DSei28oTSXYUEb4RRD1zbzGOvdpnPTCz/6gaU1jO6JKjCn
	 4G01rp+3XmC/R9CCUskHmuO4rsmKFp0XtrNHMtA6Q/3kuT1Vaf2xIjmC3XL0Bx7Z3f
	 dCzyqE5ttu1Xw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wSEQG-00000006h95-3Snx;
	Wed, 27 May 2026 13:35:48 +0000
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
Subject: Re: (subset) [PATCH v2 0/6] KVM: arm64: EL2 synchronisation and pKVM stage-2 error propagation fixes
Date: Wed, 27 May 2026 14:35:46 +0100
Message-ID: <177988892825.1514521.8187685470301754146.b4-ty@kernel.org>
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

Applied to next, thanks!

[2/6] KVM: arm64: Guard against NULL vcpu on VHE hyp panic path
      commit: 214a821c1462924668644e167a9706564cba65ea
[3/6] KVM: arm64: Fix __deactivate_fgt macro parameter typo
      commit: 1bdcdc84f9f91e702bb4410cb46016cde1d57d9b
[4/6] KVM: arm64: Seed pkvm_ownership_selftest vcpu memcache
      commit: 3a4f5b96730cb40d5d9b31293fd34e11a10f2d6d
[5/6] KVM: arm64: Pre-check vcpu memcache for host->guest share
      commit: 8ed0fbe5404616041f6daf1d2fa1824d75602f63
[6/6] KVM: arm64: Pre-check vcpu memcache for host->guest donate
      commit: cada2549ca4c934e6fb3801f857c6b4b0c36490b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


