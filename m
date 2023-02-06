Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ABE7B
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:20:41 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675703590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vII0gLu68kSuBCcExcNCtXjKdRpzzjDFHCPp8egne4=;
	b=UquOkQo+cdHwkgxsDiSw5Ekm1UrcIziy+pGPxa6B4zhpqZxLSovf0DU4J8ASia+yMbqK5E
	XucgPpDR8o0M4KOoG4TVUPR1M7sYxLmWU/WPpPuWH/RR87nDTwZP1Xr4T1gNSaaHkwYWUB
	1W5XFq7Vg1vypqQw0MmlB6xRWGDv9a4=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Quentin Perret <qperret@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kernel-team@android.com,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: arm64: Fix CPU resume/on with pKVM
Date: Mon,  6 Feb 2023 17:12:59 +0000
Message-Id: <167570355326.3822888.6416716908821358162.b4-ty@linux.dev>
In-Reply-To: <20230201103755.1398086-1-qperret@google.com>
References: <20230201103755.1398086-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 1 Feb 2023 10:37:50 +0000, Quentin Perret wrote:
> When using pKVM, we do not reset the EL2 exception vectors back to the
> stubs for e.g. Power Management or CPU hotplug as we normally do in KVM.
> As consequence, the initialisation perfomed by __finalise_el2 is missing
> on e.g. the CPU_RESUME path with pKVM, hence leaving certain registers
> in an incorrect state.
> 
> One such example is ZCR_EL2 which remains configured with SVE traps
> enabled. And so using SVE on a CPU that has gone through a hotplug
> off/on cycle leads to a hyp panic. Not good.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/4] KVM: arm64: Provide sanitized SYS_ID_AA64SMFR0_EL1 to nVHE
      https://git.kernel.org/kvmarm/kvmarm/c/8669651ce0d9
[2/4] KVM: arm64: Introduce finalise_el2_state macro
      https://git.kernel.org/kvmarm/kvmarm/c/e2d4f5ae1771
[3/4] KVM: arm64: Use sanitized values in __check_override in nVHE
      https://git.kernel.org/kvmarm/kvmarm/c/3c4cc31537ec
[4/4] KVM: arm64: Finalise EL2 state from pKVM PSCI relay
      https://git.kernel.org/kvmarm/kvmarm/c/6f10f2ec61c7

--
Best,
Oliver
