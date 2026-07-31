Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E4547D937;
	Fri, 31 Jul 2026 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523915; cv=none; b=oEbyvqS7kfAdp0ARtKSX4Rzs6Y7owuXYHQL2WlMxv72vTlijTlV5hAl2SZpJ+znOhzJJrsmT3pYh/UJ+7RDdSfX6aGbA54bSm1OCO/FjJnrzYQo8DTxU+YlHULdmghCGXhefCJpIYcUrNDZn890dNpXBaCkuKbBAdJl1/T3H5k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523915; c=relaxed/simple;
	bh=lIcsPhAQ5eP3Js8DadK/NTVQDLWt+i+mpz1K191HLeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pIFw9hxSMDS2DylrPssYSc97zz+PqOiRfFmQ12nHtet49Blva9s8+CfE/lMOQPOTqZteMGPTYUKvdEY6vUxbhhsRKwac9hRWbeBaaOJ7B9GSAhwjC2f16wU0B0Wx3ZH4W3r7ZXP/UU/ZJXBzFyOwLFrkvY8V2lmtfSNUKlV1tVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsxUJQ5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsxUJQ5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400211F01558;
	Fri, 31 Jul 2026 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523914;
	bh=zeOdbGxA0Hq8bC3KgDfNJ1qxDpOGR14VawtdX+k5mec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LsxUJQ5fDbsD7+F0eTToEZCsc3CPeeLCO8pBZhmPciYe4ali+ltlobWHz8GaknuAC
	 0yQPll18J0pUgylcD5XoX5P/QmBTP6gofXl31VAnNxMKef6Bl0MsDhmTmXCh2L/LYT
	 SIwiZdEKj+TJ5oxh3KGdtqlf7HFfio03Dkk/SBz5M4oDWO2qyDyAyfrYfFkrhfd0++
	 58Alky/QF1yv3AUb0ww+lvG7dMJgM71RW3cp7BiD5d/LISngPtrcBpLTQ1x8iYwkeY
	 pfiJPloLMLMTzyl3B4V0CES+XejnMYpYnL9OSyQt90H8B2ofooXbMhq2jK+fs1DPr5
	 ul1SB9vk3bvNA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v4 00/29] KVM: arm64: Add support for FEAT_NV2p1 and FEAT_NV3
Date: Fri, 31 Jul 2026 11:51:48 -0700
Message-ID: <178552142347.30097.13874588546478889683.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730071022.296811-1-maz@kernel.org>
References: <20260730071022.296811-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 30 Jul 2026 08:09:53 +0100, Marc Zyngier wrote:
> This is the fourth (and hopefully last) version of a series adding
> support for two extensions targeting Nested Virt on arm64:
> 
> - FEAT_NV2p1 is effectively a bug fix for two registers (CNTHCTL_EL2
>   and CPTR_EL2) that are missing stateful bits when accessed from EL1
>   in a NV configuration. When this is present, the hypervisor can
>   avoid a bunch of traps.
> 
> [...]

Applied to next, thanks!

[01/29] arm64: sysreg: Emit RESx/UNKN values for Mapping/Fields definitions
        https://git.kernel.org/kvmarm/kvmarm/c/6ae7fab7d9d3
[02/29] arm64: Update ID_AA64MMFR4_EL1 description to 2026-03 JSON release
        https://git.kernel.org/kvmarm/kvmarm/c/1441f717ab5c
[03/29] KVM: arm64: Merge guest's HCRX_EL2 using NV_HCRX_GUEST_EXCLUDE
        https://git.kernel.org/kvmarm/kvmarm/c/4422d8b7502d
[04/29] KVM: arm64: Drop __HCRX_EL2_* masks
        https://git.kernel.org/kvmarm/kvmarm/c/34a7514b87ac
[05/29] KVM: arm64: Plumb HCRX_EL2.SRMASKEn in HCRX_EL2 sanitisation
        https://git.kernel.org/kvmarm/kvmarm/c/fed0a1e87c28
[06/29] KVM: arm64: Classify CPTR_EL2 as a SR_LOC_SPECIAL register
        https://git.kernel.org/kvmarm/kvmarm/c/0b72c4060057
[07/29] KVM: arm64: Don't evaluate HCR_EL2.NV nor HFGITR_EL2.ERET on ERET fast path
        https://git.kernel.org/kvmarm/kvmarm/c/c938c826c1ef
[08/29] arm64: Add ARM64_HAS_NV2P1 capability
        https://git.kernel.org/kvmarm/kvmarm/c/0dbb49dcdbbe
[09/29] KVM: arm64: Relax CPTR_EL2 handling when FEAT_NV2p1 is present
        https://git.kernel.org/kvmarm/kvmarm/c/649ba043262c
[10/29] KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present
        https://git.kernel.org/kvmarm/kvmarm/c/7c614e169826
[11/29] KVM: arm64: Expose FEAT_NV2p1 to NV guests
        https://git.kernel.org/kvmarm/kvmarm/c/4eb776d0b984
[12/29] arm64: Add FEAT_NV2p1 detection
        https://git.kernel.org/kvmarm/kvmarm/c/1f4177ea49b5
[13/29] arm64: sysreg: Add NVHCR_EL2 description as a mirror of HCR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/7c81d7c4ef6e
[14/29] arm64: sysreg: Add HCRX_EL2 bits related to FEAT_NV3
        https://git.kernel.org/kvmarm/kvmarm/c/9809bdf151e2
[15/29] arm64: Add ARM64_HAS_NV3 capability
        https://git.kernel.org/kvmarm/kvmarm/c/5be1b8de27dc
[16/29] KVM: arm64: Split NV-specific exit fixups from the non-NV handling
        https://git.kernel.org/kvmarm/kvmarm/c/dbb45adfcdef
[17/29] KVM: arm64: Add NV3 control bits to HCRX_EL2 sanitisation
        https://git.kernel.org/kvmarm/kvmarm/c/6ec15c963e53
[18/29] KVM: arm64: Add kvm_has_nv{2,3}() predicates
        https://git.kernel.org/kvmarm/kvmarm/c/3908e3027235
[19/29] KVM: arm64: Make HCR_EL2 a non-VNCR register
        https://git.kernel.org/kvmarm/kvmarm/c/3fc7867a95c0
[20/29] KVM: arm64: Add sanitisation for NVHCR_EL2
        https://git.kernel.org/kvmarm/kvmarm/c/3b3ae6bfaca0
[21/29] KVM: arm64: Add NVHCR_EL2 handling to the sysreg array
        https://git.kernel.org/kvmarm/kvmarm/c/0c0b2ad26b36
[22/29] KVM: arm64: Add routing for NVHCR_EL2 trap
        https://git.kernel.org/kvmarm/kvmarm/c/d6debf95f1aa
[23/29] KVM: arm64: Add NVHCR_EL2 context switching
        https://git.kernel.org/kvmarm/kvmarm/c/62ed180231f4
[24/29] KVM: arm64: Engage NV3 ERET trap elision
        https://git.kernel.org/kvmarm/kvmarm/c/c962853bf5e1
[25/29] KVM: arm64: Engage NV3 TLBI trap elision
        https://git.kernel.org/kvmarm/kvmarm/c/328ab9719ee0
[26/29] KVM: arm64: Add FEAT_NV3 detection
        https://git.kernel.org/kvmarm/kvmarm/c/a64183418a80
[27/29] KVM: arm64: Expose FEAT_NV3 to guests
        https://git.kernel.org/kvmarm/kvmarm/c/89cdbeb18382
[28/29] KVM: arm64: selftest: Add NVHCR_EL2 to get-reg-list
        https://git.kernel.org/kvmarm/kvmarm/c/1f4a10ff9090
[29/29] arm64: Add override for ID_AA64MMFR4_EL1.NV_frac
        https://git.kernel.org/kvmarm/kvmarm/c/13c164acef36

--
Best,
Oliver
