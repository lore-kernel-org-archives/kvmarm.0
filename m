Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [95.215.58.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5FB2C9C
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 15:31:45 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686756702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=01sXW6nMco73wjdCgRrO6l/Ruca2vxtKLoH6pkBbbok=;
	b=xLuio2pVOymqCJ0Wtdcda0yNBqV2wLptNoIRi1WXDSdEZqlk3PuEZr8neT6b7Qzp/0/7Ei
	xgVlbnxto/Ac8YkThjeSkCoMD9cL8ZD3rrqUyg4GpNZ5Pi1jVyqhSVEJxJAci9SNdTVtLj
	yys7tBM63a7M2BuWq76w4l9r0ll45eA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: (subset) [PATCH v3 00/17] KVM: arm64: Allow using VHE in the nVHE hypervisor
Date: Wed, 14 Jun 2023 15:31:27 +0000
Message-ID: <168675651876.3255755.11650251411681563144.b4-ty@linux.dev>
In-Reply-To: <20230609162200.2024064-1-maz@kernel.org>
References: <20230609162200.2024064-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 9 Jun 2023 17:21:43 +0100, Marc Zyngier wrote:
> KVM (on ARMv8.0) and pKVM (on all revisions of the architecture) use
> the split hypervisor model that makes the EL2 code more or less
> standalone. In the later case, we totally ignore the VHE mode and
> stick with the good old v8.0 EL2 setup.
> 
> This is all good, but means that the EL2 code is limited in what it
> can do with its own address space. This series proposes to remove this
> limitation and to allow VHE to be used even with the split hypervisor
> model. This has some potential isolation benefits[1], and eventually
> allow systems that do not support HCR_EL2.E2H==0 to run pKVM.
> 
> [...]

I decided we should probably should have this in -next for a bit before
sending a pull request. We can shove any fixes on top as needed.

Applied to kvmarm/next, thanks!

[01/17] KVM: arm64: Drop is_kernel_in_hyp_mode() from __invalidate_icache_guest_page()
        https://git.kernel.org/kvmarm/kvmarm/c/c4b9fd2ac035
[02/17] arm64: Prevent the use of is_kernel_in_hyp_mode() in hypervisor code
        https://git.kernel.org/kvmarm/kvmarm/c/35230be87ec6
[03/17] arm64: Turn kaslr_feature_override into a generic SW feature override
        https://git.kernel.org/kvmarm/kvmarm/c/0ddc312b7c73
[04/17] arm64: Add KVM_HVHE capability and has_hvhe() predicate
        https://git.kernel.org/kvmarm/kvmarm/c/e2d6c906f0ac
[05/17] arm64: Don't enable VHE for the kernel if OVERRIDE_HVHE is set
        https://git.kernel.org/kvmarm/kvmarm/c/7a26e1f51e3c
[06/17] arm64: Allow EL1 physical timer access when running VHE
        https://git.kernel.org/kvmarm/kvmarm/c/9e7462bbe00d
[07/17] arm64: Use CPACR_EL1 format to set CPTR_EL2 when E2H is set
        https://git.kernel.org/kvmarm/kvmarm/c/659803aef48b
[08/17] KVM: arm64: Remove alternatives from sysreg accessors in VHE hypervisor context
        https://git.kernel.org/kvmarm/kvmarm/c/57e784b4079e
[09/17] KVM: arm64: Key use of VHE instructions in nVHE code off ARM64_KVM_HVHE
        https://git.kernel.org/kvmarm/kvmarm/c/6f617d3aa643
[10/17] KVM: arm64: Force HCR_EL2.E2H when ARM64_KVM_HVHE is set
        https://git.kernel.org/kvmarm/kvmarm/c/d0daf5a21e63
[11/17] KVM: arm64: Disable TTBR1_EL2 when using ARM64_KVM_HVHE
        https://git.kernel.org/kvmarm/kvmarm/c/cff3b5cf96ed
[12/17] KVM: arm64: Adjust EL2 stage-1 leaf AP bits when ARM64_KVM_HVHE is set
        https://git.kernel.org/kvmarm/kvmarm/c/6537565fd9b7
[13/17] KVM: arm64: Rework CPTR_EL2 programming for HVHE configuration
        https://git.kernel.org/kvmarm/kvmarm/c/75c76ab5a641
[14/17] KVM: arm64: Program the timer traps with VHE layout in hVHE mode
        https://git.kernel.org/kvmarm/kvmarm/c/aca18585db4f
[15/17] KVM: arm64: Force HCR_E2H in guest context when ARM64_KVM_HVHE is set
        https://git.kernel.org/kvmarm/kvmarm/c/38cba55008e5
[16/17] arm64: Allow arm64_sw.hvhe on command line
        https://git.kernel.org/kvmarm/kvmarm/c/ad744e8cb346

--
Best,
Oliver
