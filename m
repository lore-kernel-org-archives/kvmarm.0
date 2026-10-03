Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C8242901D;
	Sat,  3 Oct 2026 12:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791029656; cv=none; b=WtO4+DW+tFJsnCXmWgIVMXIuInKlWpDQwPo+t9yFpubbw3zm3OpDuShFzu01GdN7ePx9YNMmda7D6rt22UvZVp6tuawhIcQjiti0u6fxkpNdrJ3/p6iGQakd+fcnrqPl68z/kZQ32pSZPvlCxlMPadS/RfKDpXtfthTbipHRbcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791029656; c=relaxed/simple;
	bh=PG8MFk8vZeYRRW5LAiGEFz8vGHLGlDWs4NQzpkjkbYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VHv1K/ClssK1+mrjh/6se56JkkPNC25SGH7gz0n4tneZOGBbMpUqMd6ubHVetFljpkBP6XsiB8RGKOFaeShP38JSOsbT5y2fJoX6Jog0CMfQLPmCJXVFYltKs/sK4lWB2eeKK2JsSvyf1nK+6xkrmjPOEuboarQApFpw+qGZgFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VUw/il2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VUw/il2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9101F0089B;
	Sat,  3 Oct 2026 12:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791029645;
	bh=rnNuPBOFoJ+E4mnM/5WK9CbF4T41g018LxYJP+6Inbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUw/il2bzsw+6JTG9oiEg2OoLA10RP+J828Xw8zZRzdGe2qVKHTPJqpuyZh7EQrx5
	 xj4sn+Rav34r2lrW4e3QGdPQiyJNFrS9tR+akU1HYoRP/mtPtEed10LKlherZSXF8N
	 M73lIBqYJCdY1D8NkuIIdTaaqFvt8djh/tjMzR2JSu35xIt0fEFGris5GwDq89/ya6
	 Cf02ufpPTM3PiSzGDWT/29u92hfflYrarWRHAy0Ia6FPmsJe0gf5ExWoQoELOSgq5S
	 Z0Y6aFTZE/PvR20YdyWu8LrZ5kfCDJBx+a+tiW/qXPpdiMjGVC2PX9dFtAZceQG0Pn
	 zReuy3uGP839A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xCyct-0000000GWmb-2c21;
	Sat, 03 Oct 2026 12:14:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Colton Lewis <coltonlewis@google.com>
Cc: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	pbonzini@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Handle hidden FEAT_PMUv3 in ID_AA64DFR0_EL1
Date: Sat,  3 Oct 2026 13:14:00 +0100
Message-ID: <179102963296.607377.2477246563507237480.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930211834.2773546-1-coltonlewis@google.com>
References: <20260930211834.2773546-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, coltonlewis@google.com, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 30 Sep 2026 21:18:32 +0000, Colton Lewis wrote:
> When userspace initializes a vCPU with KVM_ARM_VCPU_PMU_V3 and hides
> FEAT_PMUv3 via ID_AA64DFR0_EL1.PMUVer, KVM hits a WARN_ONCE("Unknown PMU
> version 0") during reset_pmevtyper() and continues to expose PMU system
> registers instead of emulating guest accesses as UNDEF.
> 
> Patch 1 handles ID_AA64DFR0_EL1_PMUVer_NI in __kvm_pmu_event_mask() and
> removes the redundant kvm_vcpu_has_pmu() check in reset_pmevtyper().
> Patch 2 updates pmu_visibility() to check ID_AA64DFR0_EL1.PMUVer via
> kvm_has_feat() so PMU registers are marked REG_HIDDEN when FEAT_PMUv3 is
> not advertised.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Handle ID_AA64DFR0_EL1.PMUVer == NI in __kvm_pmu_event_mask()
      commit: aa41a7c3beb59f9dac4e60c9cf1d146f6c9025c4
[2/2] KVM: arm64: Check ID_AA64DFR0_EL1.PMUVer in pmu_visibility()
      commit: 517cdec3d4b28ccf5dae2dd03dee2a0a1eef1981

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


