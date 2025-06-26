Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F0F1F2BAD;
	Thu, 26 Jun 2025 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750937243; cv=none; b=BroFOAZoDPdllcpL/lpM/InOlQCYjbIjXc+oo6aPsx9VA4syoOraCaGzoODEtkBYmr/NXCX9XulxeJtN+0VPoWuHBncgCbugjFEK9t+LOn6auhPtGJ1hTkGqgcI8a0jX+K/vMcLm+5zgMbfJgiI2BIS/5XVZkharAd4y7VwlsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750937243; c=relaxed/simple;
	bh=JrCZb5QzxTxFZWoptOSoxzU+/er8vrbB5+3VYfpq9jE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m8I7gWT7EnNijzVDEIcnuhUPqVo5P5yWVjOwIkGi+nxB/KM3tD23tngDMh+QwMzj1Ek9ySwwTgDuBodYvS5bzNn08RdPJX5euaFcQ0PhGFPPk/ojeL+pF5ZB5VVWSo9WUFkbnYeMGOucJcS927vx833oDv9YZl7TvwZOKkDSPxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqqmHNTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqqmHNTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F16C4CEEB;
	Thu, 26 Jun 2025 11:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750937243;
	bh=JrCZb5QzxTxFZWoptOSoxzU+/er8vrbB5+3VYfpq9jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqqmHNTY6Kc6gv7fACQSPLTkpDgmsstq6TMOQ1t6N5Xp1upAeehfgvM1xXT0W5K/q
	 Uw3W+2FxOPUw5opFX0DwFvtFRXI0CdxjgVeEYayTlCQ6RNFjckTpt69FNHR59BIFst
	 bkoYRG6MbhqyQUYdgxks38saeDpcIYHx5k2n7SloKzYTvX8eJMjjoTqeua7ZdKc2JY
	 hkmTFqGDGXdlsHZYtd1Y8cjgLq2MPclYIbK/25gT74IDLKEo3jsI/BUyQKG9s3EBP4
	 PueHM1dXhMHP16yg/fwT2NX5WlWuddZi18SDEiR913mMeoeWlb3HkTFGdXGyW6gZNj
	 +SqjIEj1fX6zw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uUklF-00ACj9-9j;
	Thu, 26 Jun 2025 12:27:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Cc: Mostafa Saleh <smostafa@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Don't free hyp pages with pKVM on GICv2
Date: Thu, 26 Jun 2025 12:27:18 +0100
Message-Id: <175093722839.181610.1798670653973681500.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250626101014.1519345-1-qperret@google.com>
References: <20250626101014.1519345-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, smostafa@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 26 Jun 2025 10:10:14 +0000, Quentin Perret wrote:
> Marc reported that enabling protected mode on a device with GICv2
> doesn't fail gracefully as one would expect, and leads to a host
> kernel crash.
> 
> As it turns out, the first half of pKVM init happens before the vgic
> probe, and so by the time we find out we have a GICv2 we're already
> committed to keeping the pKVM vectors installed at EL2 -- pKVM rejects
> stub HVCs for obvious security reasons. However, the error path on KVM
> init leads to teardown_hyp_mode() which unconditionally frees hypervisor
> allocations (including the EL2 stacks and per-cpu pages) under the
> assumption that a previous cpu_hyp_uninit() execution has reset the
> vectors back to the stubs, which is false with pKVM.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't free hyp pages with pKVM on GICv2
      commit: 0e02219f9cf4f0c0aa3dbf3c820e6612bf3f0c8c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


