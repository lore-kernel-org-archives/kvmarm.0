Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156437E77B
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714579284; cv=none; b=rsspD5ov3jU5bIl0zYv/Ly7/9GO9tqxORPjMbRYEbfCu8Axdt6PEnVGSBokFNaoSlC4mDiv81wj3F0nYdIqpHnZb5+XPdPCINAIf7BI2rzXEKL47TyexYEtWMFSJtBpR2EY2rIA0Zolc/7dSwy4qlJf890LsA/y5tT0w7U0O4+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714579284; c=relaxed/simple;
	bh=bVP7kD9kkSHV8bs/Jy/h8+iCmGgD+27nJVGguP26wWg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KtUz8SCz+yuuzckU0ud1WkGv5GnX0Fc9ihKF7SD/UZ49D3KKmQlzPvlNvsSbEKvRZ5YaQPnBfXCl23rpZE2soa/bT6NdD1yi+FW8PJkZ970unbNMGtwPZZIV9u4WxyiCqx9GzSR2vekPEPTMFa7wU6aTEgWHV8GWa0icrSGnkcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEWMCD0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEWMCD0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F023C072AA;
	Wed,  1 May 2024 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714579283;
	bh=bVP7kD9kkSHV8bs/Jy/h8+iCmGgD+27nJVGguP26wWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEWMCD0URq9Ft6g+ndoaN56hnp9ggjfkmA2itDG/ykP/0813z47g6EF1uDl/BwaZp
	 vTBKXU9wBQ4HYjkXC0gIYf/TaigCoNLC35dp3u2vf1PCrFSQqmGi+3IOushANlfGnT
	 qK9xwSe+vrIrPMNqQu+BHy+T2gm5D3WdRs9o+JrFfv14sYMjLOPkoQPUjhybWEdsHu
	 2Ys1ON6nxO0EuopVdP0npnskg+26yojqbVGuF6wrW5diWlZ6UUsjjCRH3cfTal6ndO
	 DPXoB2JmDQIFzXgrZk4MY/3gLdweno8PpBLTuLOtLSFqkCAtxZWkVyiMWePmct59Z9
	 baJgZt672MJag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2COX-009lBV-7T;
	Wed, 01 May 2024 17:01:21 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>
Cc: will@kernel.org,
	qperret@google.com,
	seanjc@google.com,
	alexandru.elisei@arm.com,
	catalin.marinas@arm.com,
	philmd@linaro.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	mark.rutland@arm.com,
	broonie@kernel.org,
	joey.gouly@arm.com,
	rananta@google.com,
	smostafa@google.com
Subject: Re: (subset) [PATCH v4 00/30] KVM: arm64: Preamble for pKVM
Date: Wed,  1 May 2024 17:01:17 +0100
Message-Id: <171457924214.3002084.2616257315945363151.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
References: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, qperret@google.com, seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, rananta@google.com, smostafa@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 23 Apr 2024 16:05:08 +0100, Fuad Tabba wrote:
> Changes from V3 [0]:
> - Rebased on latest kvmarm/next (dcbf421a8c08)
> - Dropped atomic and locking patches for now, while we rework them
> - Misc fixes (Oliver)
> 
> We are getting closer to upstreaming the remaining part of pKVM
> [1]. To make the process easier for us and for our dear
> reviewers, we are sending out this patch series as a preamble to
> the upcoming patches.
> 
> [...]

Applied to next, thanks!

[01/30] KVM: arm64: Initialize the kvm host data's fpsimd_state pointer in pKVM
        commit: 4c22a40dd9c3dcc2156f312ffc71955e56192a76
[02/30] KVM: arm64: Move guest_owns_fp_regs() to increase its scope
        commit: b5b85bd713b1623c192754cd39a3351fa0c13717
[03/30] KVM: arm64: Refactor checks for FP state ownership
        commit: f11290e0aa6e40e6823f80c7dcdacf033a54aaeb
[04/30] KVM: arm64: Do not re-initialize the KVM lock
        commit: 40099dedb4a81fbf13ebac3a9dafcb72c7722d6a
[05/30] KVM: arm64: Issue CMOs when tearing down guest s2 pages
        commit: cb16301626c339b3ccde93e5deea0569e508cb98
[06/30] KVM: arm64: Avoid BUG-ing from the host abort path
        commit: 02949f36bc7b723944bf754b71cfdf75e5e36f44
[07/30] KVM: arm64: Check for PTE validity when checking for executable/cacheable
        commit: 96171cfa55d0a58048ef7dada507141daa400027
[08/30] KVM: arm64: Avoid BBM when changing only s/w bits in Stage-2 PTE
        commit: 7cc1d214a6cd39d7af13f931c8134c24e33dd7f6
[09/30] KVM: arm64: Support TLB invalidation in guest context
        commit: 58f3b0fc3b877447592301d14e7e1c05ebbad1a6
[10/30] KVM: arm64: Rename __tlb_switch_to_{guest,host}() in VHE
        commit: cfbdc546b667d16cdbec04c628dc1ce5a5d33bd2
[11/30] KVM: arm64: Do not map the host fpsimd state to hyp in pKVM
        commit: d48965bc47e40b06034315260b18368d6ad152b4
[12/30] KVM: arm64: Prevent kmemleak from accessing .hyp.data
        commit: 06cacc9d283c858661768fe0fc86e062ac23a5ad
[13/30] KVM: arm64: Fix comment for __pkvm_vcpu_init_traps()
        commit: 40458a66afdeef42966203939c5ac6c480c99a5a
[14/30] KVM: arm64: Change kvm_handle_mmio_return() return polarity
        commit: cc81b6dfc3bc82c3a2600eefbd3823bdb2190197
[15/30] KVM: arm64: Move setting the page as dirty out of the critical section
        commit: 9c30fc615daa3ef177a5fd4a9b2451697c515ce9
[16/30] KVM: arm64: Simplify vgic-v3 hypercalls
        commit: 948e1a53c2e95ad4c03cc6201edcb5d92e87d841
[17/30] KVM: arm64: Add is_pkvm_initialized() helper
        commit: d81a91af417c8f34dc3c3f8f90240e843d1c5c08
[18/30] KVM: arm64: Introduce and use predicates that check for protected VMs
        commit: b6ed4fa9411f7c17ebc69949c1df66dc12b2f827
[20/30] KVM: arm64: Clarify rationale for ZCR_EL1 value restored on guest exit
        commit: eef4ce6363626cbaabceef64d0bda84c3df922ac
[25/30] KVM: arm64: Reformat/beautify PTP hypercall documentation
        commit: 5a08146d9ba79838b8479739c9e494bd399074e8
[26/30] KVM: arm64: Rename firmware pseudo-register documentation file
        commit: af725804f905c8fbd0a6cebc61ec3f842cca5d34
[27/30] KVM: arm64: Document the KVM/arm64-specific calls in hypercalls.rst
        commit: 4dc8c9de384fb99692d35d2acdfedd5660930dfc
[28/30] KVM: arm64: Refactor setting the return value in kvm_vm_ioctl_enable_cap()
        commit: 97a3dee1725dc690f806f7b899b086b67f1ef905
[29/30] KVM: arm64: Restrict supported capabilities for protected VMs
        commit: 92536992cfd461207c78e46154d16050b236a6fc
[30/30] KVM: arm64: Force injection of a data abort on NISV MMIO exit
        commit: 3b467b16582c077f57fab244cf0801ecea7914b6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


