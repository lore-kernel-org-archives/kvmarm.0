Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401E0EEC8
	for <kvmarm@lists.linux.dev>; Sun,  2 Mar 2025 08:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740904884; cv=none; b=qRK8JiE4bwk55e3/YEsONxQ9pZWJoFgEn+WLcv+j6ASx1YKsfNxFFP/sdA5mG0F742uCafxEyGZlPu6wipNkdUzJexwI/oKItPQf3+sahRUnuD1ZE7UBLHK1Iokf8IjJzaqeGIzG5IQxcWmnVKODrSE+uUjyjIIwj4BZQthy/z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740904884; c=relaxed/simple;
	bh=shygSG4jJZ0nMCTqJCVmz4MRExogp395qEunp5/6nE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sDlm7uJ0mENmjdE/o7Je7aemZKsKvm2bI9wTLLIAt+SaP6AE+B0F5t8387WjtRPZxNuPqNMpalUm0QjV77eDDM+anu3Csg2c5vNHDzgKC9P2ytT3OU1OdT7E4sTMiiXhDmn5TtMxU0YNlcdO/N/FpGnTVSq2KOOlR0HpoJZq16M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KnW5XC9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KnW5XC9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96744C4CED6;
	Sun,  2 Mar 2025 08:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740904883;
	bh=shygSG4jJZ0nMCTqJCVmz4MRExogp395qEunp5/6nE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnW5XC9Y+ZZ1MmxNnOpHUx/b0xDo6PGQhbEi9SakX+h8awXXephFYF05USFFEn6pG
	 IcWr8rdMUVJ/CtwmrV5ZSROpNZtRHLKozb0QaruhASpttZOX4wYmkw9KVkkQqHzZSn
	 2AiMXgLcdCMrrNcNDJ+T587GOgjDi6p85+na+bkjhCb3cbMp1gd9lKMAKv3GSWbdXy
	 /1nx0LtTKDd9IaG9VoxSBNNA8zQjHt3/ocwAPofRGyy0tzdWqT4gotoAbRLxBf66ko
	 DlKp4HhupIp0ys4avldhcRVkePlCjCFXdMVyAovBKAIyxpNexVGMvh9t+TKabP+w+G
	 9/HqX+O+KRZkg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1toesz-009WBm-9s;
	Sun, 02 Mar 2025 08:41:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Cc: ahmed.genidi@arm.com,
	ben.horgan@arm.com,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	leo.yan@arm.com,
	oliver.upton@linux.dev,
	will@kernel.org
Subject: Re: [PATCH 0/2] KVM: arm64: PSCI relay fixes
Date: Sun,  2 Mar 2025 08:41:18 +0000
Message-Id: <174090487063.2316303.3603727860925384915.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250227180526.1204723-1-mark.rutland@arm.com>
References: <20250227180526.1204723-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, ahmed.genidi@arm.com, ben.horgan@arm.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev, leo.yan@arm.com, oliver.upton@linux.dev, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 27 Feb 2025 18:05:24 +0000, Mark Rutland wrote:
> These patches fix some missing initialization in the PSCI relay code
> which can result in host kernel crashes shortly after entering the cold
> entry points used by PSCI CPU_ON, CPU_SUSPEND, and SYSTEM_SUSPEND.
> 
> The SCTLR_EL1 issue was originally reported by Leo Yan and debugged by
> Ahmed Genidi. While looking at Ahmed's patch I spotted a more general
> issue with E2H, so I've fixed that up with patch 1, and I've tweaked his
> patch accordingly. Any errors there are my fault.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Initialize HCR_EL2.E2H early
      commit: 7a68b55ff39b0a1638acb1694c185d49f6077a0d
[2/2] KVM: arm64: Initialize SCTLR_EL1 in __kvm_hyp_init_cpu()
      commit: 3855a7b91d42ebf3513b7ccffc44807274978b3d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


