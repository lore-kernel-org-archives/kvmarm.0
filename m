Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78242C375B;
	Tue, 29 Apr 2025 13:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745934077; cv=none; b=mfADktK4ZnG1r4HExGNskDNtH8PaxXWf9GZWOzCxmZYSTxRQtfV7ep7Hj1Ydv47wudE0tWVJWKnCSlMAzmfljhqhgAekNe0GnoJfvvUG9xs6Q22u3RLcW9O8Tuj6rv+v3+/szOu9+npSDPdKr7W0C4Vxp0T4K9R/Xtvxo5lzzCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745934077; c=relaxed/simple;
	bh=bJRpUbI549tFu5fdC+DCORV9nXGD3YYzkP2HcOX7uQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7kW1z3rfURlr1TAdLbPNF99nR2sPWmefWmumEgHUBn/ONSArwyfM4yDbOYwcJXyz0sjTxqNFq+URceCTFGgUPzazjlc4WxgvriJX/uhe+4nFNF0UH8x73KIgmbl3Z+urX35ASu1dCbFmu3ntWvbl8aHe58Qf047wAOgS3OtKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hOexpkUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOexpkUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F781C4CEE3;
	Tue, 29 Apr 2025 13:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745934074;
	bh=bJRpUbI549tFu5fdC+DCORV9nXGD3YYzkP2HcOX7uQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOexpkUFYTMHUAahkUcB99gyQNhZi94+y5iTQIKG3/0Pge+BHKZJsq4hUAfCbzZ4O
	 MlqiFUPPewBo8vPmY1sleA2XxiHyL4U0xJr7x9QvlrM5FCWcijVER/3tQbbCZkJtJb
	 SCOb0IE8r/tlW7EdexI9cWLwfuLJxKvoqfdaaHaoFWNo2o5OY6hFpBaR5cVzfwedAs
	 p/Wl9mf3z4SYUvIVGcD9QTS5ZKkG5hTzc58i1xNuG5dXvvr2hws8DdDHTrn8Ygf2PQ
	 eQiA7c3BHd/qxXR+bK2mF5hKURUrH/eKHI214QQSk8O+NllaOYEe4yzs/krjI+Gv49
	 OvEJ9S5cBtgKQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u9lCx-009vXz-TM;
	Tue, 29 Apr 2025 14:41:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Cc: Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Move pKVM ownership state to hyp_vmemmap
Date: Tue, 29 Apr 2025 14:41:08 +0100
Message-Id: <174593405817.3620453.10683944453931548390.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250416152648.2982950-1-qperret@google.com>
References: <20250416152648.2982950-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 16 Apr 2025 15:26:40 +0000, Quentin Perret wrote:
> This series moves the hypervisor's ownership state to the hyp_vmemmap,
> as discussed in [1]. The two main benefits are:
> 
>  1. much cheaper hyp state lookups, since we can avoid the hyp stage-1
>     page-table walk;
> 
>  2. de-correlates the hyp state from the presence of a mapping in the
>     linear map range of the hypervisor; which enables a bunch of
>     clean-ups in the existing code and will simplify the introduction of
>     other features in the future (hyp tracing, ...)
> 
> [...]

Applied to next, thanks!

[1/7] KVM: arm64: Track SVE state in the hypervisor vcpu structure
      commit: 5db1bef933427aa467ad89c7b695a84a6b4afe16
[2/7] KVM: arm64: Fix pKVM page-tracking comments
      commit: ba637018ca67224fa21dc2212cb4457b357a5455
[3/7] KVM: arm64: Use 0b11 for encoding PKVM_NOPAGE
      commit: cd4b039165a5e709d0d599e207709d73141a8bed
[4/7] KVM: arm64: Introduce {get,set}_host_state() helpers
      commit: ba5b2e5b9dff5ba14940e1525f6e3a595f012466
[5/7] KVM: arm64: Move hyp state to hyp_vmemmap
      commit: 3390b3cbb613bc0822854f5754437cd1d1b3d5d0
[6/7] KVM: arm64: Defer EL2 stage-1 mapping on share
      commit: 48d848882395a6a42ff1bb685082c79791d4e753
[7/7] KVM: arm64: Unconditionally cross check hyp state
      commit: 43c475504a39e98f10f5e6ec4d9d9ed60672a753

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


