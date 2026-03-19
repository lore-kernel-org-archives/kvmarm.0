Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E78D3446DA;
	Thu, 19 Mar 2026 18:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773946210; cv=none; b=dX15BrM7fokVEHzfN+Y9Sb4bmiqimzLJRCH9p3e2o5L8zprNC6bT952s2iKHEfvCdLoERGYKEYn118imm3Qgya9LVJwH0xH8LrByqR91gqjw+XC0wXCnFOltIYbBH6JZrYZ3iSZPA7KULV8o1+Y7H8wRe9pNdI0ZKWWeziA7TU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773946210; c=relaxed/simple;
	bh=K60s6YsRrO5TdEcwxz1N7lQiumDIwNH/vVrpAIgtC0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j9rP5UMCPDgTqggAX9LHlQbyc+xpEdamPgprzXhvvL/gxAbfl4qNeAIcFNsULpm81EjRHS1PD05VCmXQV45PXFNYXo9mAwDvtEXCcqyGk0VjWUdh9CPHnZ8v5QhLREUCBjIPMIxyHQF1/5mzto9MAo4m7mV/7qXvCapS/y+TkZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKM+idIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKM+idIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A0CC19424;
	Thu, 19 Mar 2026 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773946209;
	bh=K60s6YsRrO5TdEcwxz1N7lQiumDIwNH/vVrpAIgtC0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKM+idIOb3Gm5h5QZn0tIGkkfml4/gxJhkuV3CoggDssjZfA+jegvS71HwY7ZJW4K
	 KC4Y2HEBgYC6f7FV3fXbewWwqpNmypb6rFP+zlWpMJiacgphTqwzSS5Y/n+hsxG4ge
	 OgWbqmw88JxLOjBqHZV3cYmCG76XcW9l4tiuB8TnCgHZoBpekVLu6cjaYO0Fni7u9K
	 J1aRHeyn3mzXflmeQED2R9wY9mxtj/ijp5xjLdQRvZuI1QGBXAGsBQ3XW8Qc8vN7Zm
	 YuRuezC5BbL6axtDhLVfxrbz/FC18qPiLj5Sv9IQANAcS0MlbtflUCLRU1OMZF6BlA
	 jdqIRkjEs9TSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w3IRb-00000003m7Z-1A6D;
	Thu, 19 Mar 2026 18:50:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Cc: nd <nd@arm.com>,
	Joey Gouly <Joey.Gouly@arm.com>,
	Suzuki Poulose <Suzuki.Poulose@arm.com>,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	Timothy Hayes <Timothy.Hayes@arm.com>,
	jonathan.cameron@huawei.com,
	Oliver Upton <oupton@kernel.org>
Subject: Re: (subset) [PATCH v7 00/41] KVM: arm64: Introduce vGIC-v5 with PPI support
Date: Thu, 19 Mar 2026 18:50:04 +0000
Message-ID: <177394618565.2534565.1166639018053467365.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319154937.3619520-1-sascha.bischoff@arm.com>
References: <20260319154937.3619520-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, lpieralisi@kernel.org, Timothy.Hayes@arm.com, jonathan.cameron@huawei.com, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 19 Mar 2026 15:49:42 +0000, Sascha Bischoff wrote:
> This is v7 of the patch series to add the virtual GICv5 [1] device
> (vgic_v5). Only PPIs are supported by this initial series, and the
> vgic_v5 implementation is restricted to the CPU interface,
> only. Further patch series are to follow in due course, and will add
> support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.
> 
> v1, v2, v3, v4, v5, v6 of this series can be found at [2], [3], [4],
> [5], [6], [7], respectively.
> 
> [...]

Applied to next, thanks!

[01/41] KVM: arm64: vgic-v3: Drop userspace write sanitization for ID_AA64PFR0.GIC on GICv5
        commit: 90f0155f8754e75fa29fce02e40d690fb733852d
[02/41] KVM: arm64: vgic: Rework vgic_is_v3() and add vgic_host_has_gicvX()
        commit: 3a2857da94d4783c076b15035c578892f1817dce
[03/41] KVM: arm64: Return early from kvm_finalize_sys_regs() if guest has run
        commit: cbd8c958be54abdf2c0f9b9c3eac971428b9d4b1
[05/41] KVM: arm64: vgic: Split out mapping IRQs and setting irq_ops
        commit: 663594aafb438f8c4e51d4bf2dbf48b9f68aedb7
[06/41] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
        commit: 2808a8337078f2a65f1f1176880e1491a3e88fa8
[07/41] arm64/sysreg: Add GICR CDNMIA encoding
        commit: 59991153f026766447bea14d85439555b6bf9164
[08/41] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
        commit: c547c51ff4d44c787330506737c5ce7808e536cc
[09/41] KVM: arm64: gic: Introduce interrupt type helpers
        commit: eb8bce08ecb12fa0e76af23432f1adb162248ca6
[10/41] KVM: arm64: gic-v5: Add Arm copyright header
        commit: da92ff15ca4c5b0f75ec1cb3d2e275db2ff2c810
[11/41] KVM: arm64: gic-v5: Detect implemented PPIs on boot
        commit: f656807150e3e1c6f76cab918e5adfad6d881d58
[12/41] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
        commit: a258a383b91774ac646517ec1003a442964d8946
[13/41] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
        commit: 9d6d9514c08f462d162040b48526bda60def9de1
[14/41] KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
        commit: 607871ce633d3e0ca0eb375a04371f1130fc2c5a
[15/41] KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1 accesses
        commit: 070543a85adce329672012a1fe35fa48c76e02d5
[16/41] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
        commit: af325e87af5da2f686d1ad547edc96f731418f2a
[17/41] KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
        commit: 9b8e3d4ca0e734dd13dc261c5f888b359f8f5983
[18/41] KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
        commit: 8f1fbe2fd279240d6999e3a975d0a51d816e080a
[19/41] KVM: arm64: gic: Introduce queue_irq_unlock to irq_ops
        commit: 4a9a32d3538a9d800067be113b0196271a478c6a
[20/41] KVM: arm64: gic-v5: Implement PPI interrupt injection
        commit: 4d591252bacb2d004b7c7f5db439bfa23b552ee7
[21/41] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
        commit: da8d9636be7e0761f69c3dadf747c725732312ff
[22/41] KVM: arm64: gic-v5: Clear TWI if single task running
        commit: f20554ad3ccd42397f863f6c41b43b831cf9b328
[23/41] KVM: arm64: gic-v5: Check for pending PPIs
        commit: 933e5288fa9714085e384a3d6ad6dcce8089a6b9
[24/41] KVM: arm64: gic-v5: Trap and mask guest ICC_PPI_ENABLERx_EL1 writes
        commit: d1328c61511f6a2aeda48b8b9096e67d2443ec71
[25/41] KVM: arm64: Introduce set_direct_injection irq_op
        commit: 4a5444d23979b69e466f8080477112c264f194f2
[26/41] KVM: arm64: gic-v5: Implement direct injection of PPIs
        commit: 5a98d0e17e59210b400734f2359c4453aab3af21
[27/41] KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
        commit: b88d05a893cb7c8a48d03ff93d4aca95a6165377
[28/41] KVM: arm64: gic-v5: Create and initialise vgic_v5
        commit: f4d37c7c35769579c51aa5fe00161c690b89811d
[29/41] KVM: arm64: gic-v5: Initialise ID and priority bits when resetting vcpu
        commit: a3ca7cf9b31715a63c4dd32f3b6209c3bd744988
[30/41] irqchip/gic-v5: Introduce minimal irq_set_type() for PPIs
        commit: 91d940cd678d3c394c845cd64081113167d700d2
[31/41] KVM: arm64: gic-v5: Enlighten arch timer for GICv5
        commit: 9491c63b6cd7bdae97cd29c7c6bf400adbd3578f
[32/41] KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
        commit: 7c31c06e2d2d75859d773ba940e56d1db2bd1fcd
[33/41] KVM: arm64: gic: Hide GICv5 for protected guests
        commit: 5aefaf11f9af5d58257ad3d0c71c447a41963069
[34/41] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
        commit: 61d4ad518312ecddef2331ea3d22902b4eac0e0a
[35/41] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
        commit: 37a25294682d28ef3bd131566602450a72c4d839
[36/41] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
        commit: a8946fde86f860c3a94dca4ee71fe04a7a519da1
[37/41] KVM: arm64: gic-v5: Probe for GICv5 device
        commit: 9b7aa05533f1bd170211fb6ee5812d9e736492ef
[38/41] Documentation: KVM: Introduce documentation for VGICv5
        commit: eb3c4d2c9a4d76b775a9dbd5ac056d1abf0083a1
[39/41] KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI
        commit: d51c978b7d3e143381f871d28d8a0437d446b51b
[40/41] KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
        commit: 0a9f38bf612b195e04236d366ed9f769ce14cc27
[41/41] KVM: arm64: selftests: Add no-vgic-v5 selftest
        commit: ce29261ec6482de54320c03398eb30e9615aee40

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


