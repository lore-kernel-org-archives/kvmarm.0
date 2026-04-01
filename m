Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE042741A0;
	Wed,  1 Apr 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775057455; cv=none; b=QM99ht67nIFtF3a/iH/iBekZIqEmKOOJiZPMHQCeLQZlFKI+iY6S1CRk/z3h0HTGsUgxPnYJAbH7Qkv8v5O21a+FAxOini3nSv2hzZL5dIRT3thbrX8r0MBftjL2dfDqAB3C4+Z83dt14FtROO2eFilZV0wa6bA8YYEgchaACvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775057455; c=relaxed/simple;
	bh=Z/U5IMggMMF1kNt5wu+LGU6fAG8b9GsPrj4esTexxoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/UAF9YDG/hM9SE/cgnYglQAC00M5sjHlsTTlsCPYPbClKVTX5PVWMunT8ttnnKM6zWyudbHpxmF2nuVmmOP5S9dT6NhDqWzE5TTglq6qg/rnIk9HiD6jm20Agj/oNZIAU9A7KHLt9po6hzaH2z/1ifF4NmFgbm96Oimbexg7T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5kRX85J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5kRX85J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EEAC4CEF7;
	Wed,  1 Apr 2026 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775057455;
	bh=Z/U5IMggMMF1kNt5wu+LGU6fAG8b9GsPrj4esTexxoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5kRX85J4aElnrgD6ekZwZhoWxAl6dJ1sF71aUEAF2xDPX7NXixl9x4AgTsNIGDFP
	 XreVhKUoY0qvCm2AqMK7XsmlAvIgGcVCDGuDIlmvleqdBW6yoUZ1NVRIZz3bGs7KYC
	 rXRUq2FmbpFpXaPIfUpLWuNJN0xIInOwBuvQMbLQYPRIYO7dj+ZlY1BgccxgjwM1RA
	 Eo3P8BlZjhyaX5GhJSf25Y60Xf1Zm9a74J9DoI9dljLRPGLWVrH2aK4L5sAN6ETqqQ
	 yYMrim3wQwCnQdqrzdDidoo0/i8BkA4cIL8mqv2kKTamXCgafYhB4nmELydlMRYsgI
	 P2kv2RzD9nknw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7xWu-00000007vFz-3dzp;
	Wed, 01 Apr 2026 15:30:52 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 00/16] KVM: arm64: First batch of vgic-v5 related fixes
Date: Wed,  1 Apr 2026 16:30:50 +0100
Message-ID: <177505744308.364053.4311405555004534903.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 01 Apr 2026 11:35:55 +0100, Marc Zyngier wrote:
> This is the second revision of this series attempting to fix a number
> of issues reported on the vgic-v5 PPI series.
> 
> * From v1 [1]:
> 
>   - Partially reverted the effective priority mask fix, as Sascha
>     pointed out the crucial difference in the way GICv5 manages the
>     PCR compared to GICv[234]'s PMR.
> 
> [...]

Applied to next, thanks!

[01/16] KVM: arm64: vgic: Don't reset cpuif/redist addresses at finalize time
        commit: ecc7f02499544ae879716be837af78260a6a10f7
[02/16] KVM: arm64: Don't skip per-vcpu NV initialisation
        commit: d82d09d5ba4be0b5eb053b2ba2bc0e82c49cf2c8
[03/16] arm64: Fix field references for ICH_PPI_DVIR[01]_EL2
        commit: 77acae60be60adddf33e4c7e9cf73291f64fb9e8
[04/16] KVM: arm64: Fix writeable mask for ID_AA64PFR2_EL1
        commit: 76efe94b1c5cc9b5fac7c5c1096d03f1596c7267
[05/16] KVM: arm64: Account for RESx bits in __compute_fgt()
        commit: d70d4323dd9636e35696639f6b4c2b2735291516
[06/16] KVM: arm64: vgic-v5: Hold config_lock while finalizing GICv5 PPIs
        commit: e63d0a32e7368f3eb935755db87add1bf000ea90
[07/16] KVM: arm64: vgic-v5: Transfer edge pending state to ICH_PPI_PENDRx_EL2
        commit: 170a77b4185a87cc7e02e404d22b9bf3f9923884
[08/16] KVM: arm64: vgic-v5: Cast vgic_apr to u32 to avoid undefined behaviours
        commit: 42d7eac8291d2724b3897141ab2f226c69b7923e
[09/16] KVM: arm64: vgic-v5: Make the effective priority mask a strict limit
        commit: a4a645584793dbbb4e5a1a876800654a8883326e
[10/16] KVM: arm64: vgic-v5: Correctly set dist->ready once initialised
        commit: 848fa8373a53b0e5d871560743e13278da56fabc
[11/16] KVM: arm64: Kill arch_timer_context::direct field
        commit: 8fe30434a81d36715ab83fdb4a5e6c967d2e3ecf
[12/16] KVM: arm64: Remove evaluation of timer state in kvm_cpu_has_pending_timer()
        commit: fbcbf259d97d340376a176de20bdc04687356949
[13/16] KVM: arm64: Move GICv5 timer PPI validation into timer_irqs_are_valid()
        commit: 06c85b58e0b13e67f4e56cbba346201bfe95ad00
[14/16] KVM: arm64: Correctly plumb ID_AA64PFR2_EL1 into pkvm idreg handling
        commit: be46a408f376df31762e8a9914dc6d082755e686
[15/16] KVM: arm64: Don't advertises GICv3 in ID_PFR1_EL1 if AArch32 isn't supported
        commit: f4626281c6bb563ef5ad9d3a59a1449b45a3dc30
[16/16] KVM: arm64: set_id_regs: Allow GICv3 support to be set at runtime
        commit: b3265a1b2bd00335308f27477cecb7702f4bb615

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


