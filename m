Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC6246E007;
	Mon, 14 Sep 2026 12:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387455; cv=none; b=FR7OAYUFjy4gJAPyWEJyKog1/ufpEkuvpn5eYqbRqzbiRP0rmie+cdCAAMffcyxE5lRo02R/sy1uSVvGvz5aaSJ+5Uvtyld7d4AzYqXkNAdRuwnps826d98LxIooP6eOdS4L9xpxr5TYUXt8hEpFdQzftm1BZZIwu5CtPCxH+3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387455; c=relaxed/simple;
	bh=fJFTGxxXIx5Of7eyoGFG51/JSGRRu9L2gD0hu8ep9Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8qDwu+O+2cVztWMbEPrQ+egNCuhczAz1c/FfttdnL92AHzJUCKiPBlb20Zr8mqKWk7AN4e7lnTO2pnUu5IyFHAEWjmEouTTqF1146uL9HjiyI1hYybL9NqvUJr8qVFK9OdHNukNnWjJWNQ7Td9FHqAxs8SzYMhQbU4H4ffnOUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=em0ZqbiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="em0ZqbiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704561F00898;
	Mon, 14 Sep 2026 12:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387453;
	bh=bDNxQ/gJq49PiHiq3EofcZoPLCbHqonN9B4STtNx+1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=em0ZqbiZlLGz46KA2+kWeTVfOTZI6Aybdpl0NUWMCulljGgR8L9FFf+3cseuIEJkJ
	 4H5KTF9mfMSHQY/vpE6AL4X7aWXQe5tRPUmW5r/P7QfnC6/NsboT29fjAxNRa89rLs
	 WML2IL3iSePDt3zHYp+zt84gBa3XPpfwakW65JoGPfi5X4elAcBAuVQp0zenCaQVPn
	 PzxyIEBHITLXHpCEnPNpl/mVeazdCtFxjO5Evk1IrMe+fWYYo/nagExFdf5rJ1Kvaz
	 hVAyyMNgz05/IC1EHtjXA2pBC6pJSkhcfIFyVinSOaF1Hh0POXWIhB9Dv9WUThAWeh
	 f67Dt++w9nSsw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pv-00000008bEL-2x6H;
	Mon, 14 Sep 2026 12:04:11 +0000
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
	fuad.tabba@linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v6 00/49] KVM: arm64: Add GICv5 IRS support
Date: Mon, 14 Sep 2026 13:04:10 +0100
Message-ID: <178938739465.3215146.9372089700143899027.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260904113404.4051341-1-sascha.bischoff@arm.com>
References: <20260904113404.4051341-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, Sascha.Bischoff@arm.com, nd@arm.com, Joey.Gouly@arm.com, Suzuki.Poulose@arm.com, yuzenghui@huawei.com, peter.maydell@linaro.org, lpieralisi@kernel.org, Timothy.Hayes@arm.com, fuad.tabba@linux.dev, oupton@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 04 Sep 2026 11:34:16 +0000, Sascha Bischoff wrote:
> This series builds on the initial vGICv5 support [1] and adds support
> for the GICv5 IRS, as described by the GICv5 (EAC0) specification [2].
> With this, a GICv5 guest is no longer restricted to PPIs, and can make
> use of SPIs and LPIs as well.
> 
> With SPIs and LPIs available, this series makes it possible to boot a
> full Linux guest on the Arm FVP model [3], using the setup described in
> Lorenzo's GICv5 Linux software enablement guide [4]. In addition, GICv5
> IPIs are typically implemented as LPIs, so LPI support is what makes
> guests with more than one vCPU possible.
> 
> [...]

Applied to next, thanks!

[01/49] irqchip/gic-v5: Allow KVM setup without a maintenance IRQ
        commit: 59df0510c197bca35c4b11adaa7c8afa8f5898b9
[02/49] irqchip/gic-v5: Provide OF IRS config frame attrs to KVM
        commit: e6418104fbc661d5c9b280e5b9f3ff83709cf0c9
[03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts
        commit: 6055910efe9d5666eb096f5262e3501dbbca9aa2
[04/49] KVM: arm64: gic-v5: Define remaining IRS MMIO registers
        commit: 5ae1ecf679afefadccea64ff393675aebedd3253
[05/49] arm64/sysreg: Add GICv5 GIC VDPEND encoding
        commit: be0b3fd6345369e1fca0b52df52815a589629cb2
[06/49] arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields
        (no commit info)
[07/49] KVM: arm64: gic-v5: Cache host IRS ID registers
        commit: 896b6a10253c104eeb6a2bd98be297a7b51f6600
[08/49] KVM: arm64: gic-v5: Add VPE doorbell domain
        commit: b3a40e812322daaca26d40fde681dc3079b4f3b4
[09/49] KVM: arm64: gic-v5: Create and manage VM and VPE tables
        commit: f45438c015291f26e99f7fe355c4c191b5750f8d
[10/49] KVM: arm64: gic-v5: Introduce guest IST alloc and management
        commit: 77f7a9282fee67180134e75b107ff09d7e1a5876
[11/49] KVM: arm64: gic-v5: Implement VMT/vIST IRS MMIO Ops
        commit: 884d518cef62c5f4beb940709bf1920021b773b8
[12/49] KVM: arm64: vgic: Enforce model-specific vCPU limits
        commit: 21fd40005fb36c24ce0c28758b48da1238ffc909
[13/49] KVM: arm64: gic-v5: Implement VPE IRS MMIO Ops
        commit: d749533c006d4e6bd4413a8c99768cdd4f4e706d
[14/49] KVM: arm64: gic-v5: Set up VMTEs and VPE doorbells
        commit: 5c3966b2ecebcaef1c40f54e2c0b87b1deafb051
[15/49] KVM: arm64: gic-v5: Add resident/non-resident hyp calls
        commit: dc5e201aba78c8977336f71b9eb4eae9f72654ba
[16/49] KVM: arm64: gic-v5: Request doorbells when VPEs enter WFI
        commit: 2111261ac1c8cdd6d271c8a10860943720504241
[17/49] KVM: arm64: gic-v5: Introduce struct vgic_v5_irs and IRS base address
        commit: 297e838887a56700098f69891970f2b0949cde11
[18/49] KVM: arm64: gic-v5: Add IRS IODEV support to MMIO handlers
        commit: 11070de575623735ca1040c9b3c42086fd5eaba9
[19/49] KVM: arm64: gic-v5: Add KVM_VGIC_V5_ADDR_TYPE_IRS to UAPI
        commit: f6732cd67a025d8d216ee591ba5705a99ab974a1
[20/49] KVM: arm64: gic-v5: Add GICv5 IRS IODEV and MMIO emulation
        commit: f116c96e451b66831e05807d8a75259db041d2a5
[21/49] KVM: arm64: gic-v5: Initialise per-VM IRS state
        commit: c7f62066f2cf452043b43fbb7af179411029eff6
[22/49] KVM: arm64: gic-v5: Register the IRS IODEV
        commit: e3db95b1bc289fe3a4433561ad15275b13eb6b8f
[23/49] KVM: arm64: gic-v5: Set IRICHPPIDIS based on IRS enable state
        commit: 0829416d816edb01bab8b68bf3c2c278b3665515
[24/49] KVM: arm64: selftests: Update vGICv5 selftest to set IRS address
        commit: 414e17f21cfba084c6beb805c2b1d4bce15ed390
[25/49] KVM: arm64: gic-v5: Add GIC VDPEND hyp call
        commit: 32b253d3049a9f7c8d08ae11420d9166a9b06bed
[26/49] KVM: arm64: gic: Introduce set_pending_state() to irq_ops
        commit: 7e9e2aaca2f84e7a549737edf4f9fa5262c10b84
[27/49] KVM: arm64: gic-v5: Support SPI injection
        commit: c9e4010b4b222df9f73142a60454ee1d0c0d29aa
[28/49] Documentation: KVM: Extend VGICv5 device attribute docs
        commit: f549eb53494f096b1b39b58954244b6c17ea58ef
[29/49] KVM: arm64: gic-v5: Add GICv5 SPI injection to irqfd
        commit: af4d5229bf674b2554b825c79a71d1caa0088219
[30/49] KVM: arm64: gic-v5: Mask per-vCPU PPI state in vgic_v5_finalize_ppi_state()
        commit: 589d6072f25d0690ab9bace88b0d77a06e6ff22d
[31/49] KVM: arm64: gic-v5: Add GICv5 EL1 sysreg userspace accessors
        commit: 6479d16be163b2e3ce9cfdc6791e16aa42480f8a
[32/49] KVM: arm64: gic-v5: Handle userspace accesses to IRS MMIO region
        commit: 71091136d1452b6125579b210d29efec3e79681a
[33/49] KVM: arm64: gic-v5: Add CoreSight MMIO regs to IRS
        commit: 9264a0c0bf0e1fa4e2be2c146aef6c3bedceb72d
[34/49] KVM: arm64: gic-v5: Add VGICv5 IST save/restore UAPI
        commit: 8bcdcbb57a46a5f72ae55e8d69517ac5df8c05bd
[35/49] KVM: arm64: gic-v5: Implement save/restore mechanisms for ISTs
        commit: f9846846c4df6818d323f4a86c168bd2d63c6cdb
[36/49] Documentation: KVM: Document KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS for VGICv5
        commit: fc3a33a6f388bf0a3645d019bc7a0cab3a6ead92
[37/49] Documentation: KVM: Add KVM_DEV_ARM_VGIC_GRP_IRS_REGS to VGICv5 docs
        commit: 99055cdfb2102c096a7b90c677d292a4528578e4
[38/49] Documentation: KVM: Add docs for KVM_DEV_ARM_VGIC_GRP_IST
        commit: a7f442da926bae29563f456e5df6e59d44ff77ee
[39/49] Documentation: KVM: Add the VGICv5 IRS save/restore sequences
        commit: 53e9639e758524ab1f92b836d0fc4f023e762903
[40/49] KVM: selftests: Add VGICv5 IRS address attribute tests
        commit: e9d07ebc7eb41ebbc83d5eb52f43a970917830e9
[41/49] KVM: selftests: Add VGICv5 NR_IRQS attribute tests
        commit: 45895c459225150082427576582f887c9f80d720
[42/49] KVM: selftests: Add VGICv5 IRS_REGS attribute tests
        commit: fe9c6aa09239ea7a99ca1657afb4522c36972dc1
[43/49] KVM: selftests: Add VGICv5 IST attribute tests
        commit: aca2eb44d850d0c6fa16ba87334414cc2fa271c5
[44/49] KVM: selftests: Add VGICv5 USERSPACE_PPIS tests
        commit: 2899ec9a2e6a2694423efb46a408a37e66283744
[45/49] KVM: selftests: Add VGICv5 CPU sysreg attribute tests
        commit: 44607858563390e7f124ee343abda200d823755b
[46/49] KVM: selftests: Add VGICv5 SPI injection tests
        commit: 96e48f2f5322cecebabcda953b96efc254919c49
[47/49] KVM: selftests: Add VGICv5 LPI delivery tests
        commit: fc8ab69c081b99feddf3c873846068013b3a8a78
[48/49] KVM: selftests: Add VGICv5 IST save/restore coverage
        commit: 7bebd949670bb5ab1bd14a67779fd308795e247b
[49/49] KVM: selftests: Add VGICv5 sparse vCPU IDs test
        commit: 3ca5a03d139b7d3de02e9de824ba1caebff97b8f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


