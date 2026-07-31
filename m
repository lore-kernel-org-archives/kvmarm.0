Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3582347987E;
	Fri, 31 Jul 2026 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523914; cv=none; b=mN2WG/QCekCGE9wlsyupGHBUVzYByes2tCeIUA1Ag3QXhc9WHgzoq5ILeXMY8XwR5Ewl1+flHxD2zzmdD9RJ0G4aab5wGibLJywCyelQSD4vPkzB7DTTuFb6r72+z80XibhovY0wUk2cr9z+UQJt3AoN49Xig8ASbwmw2nbFJhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523914; c=relaxed/simple;
	bh=Xk98sFUvrCpMxkX85+qDFdjYRwm+QTgOL6cUrk3dQgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HWGpidng3LEkt2+pZkejMXA3EP3Js+X5Srkay/lZXzKF0GvAyFG3CdKzyZ4zbtNfroyFU90uMdtWdt6fVnAsN2dNISlLqaxbpm0OiZIY1NWWAEnicBQYNXH+q+UntvtEw8e6lnYHErJVqlJEmgBX8IVwnJ2gFOoEkrzobklNEMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cWj+jl6+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cWj+jl6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B221F00AC4;
	Fri, 31 Jul 2026 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523913;
	bh=WZot6GFuhy9a+s0IugMlJ70eCJTGgM/zB3nf4mCWRaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWj+jl6+CIO586r12U21up84e9GPZCTcTt1faCSxLcxizMMQQYcGKJGz/RvwNUsY/
	 aNz08ZnrEy2GS4PI9u7HWHsjdy2cEuPiuw4/2ICAhpkLXV+jfknNspSWeB8GuyJdiZ
	 v4l033aztqBDf7SJKezD1t/ki1Ul0fh+H749i48g6EUXUccI/Kk1nM9juxWpPQahEK
	 hS5gBep5O6YqbxDTAEq0IbrHvL+dXmHxuPf6At3kVig8G23cbWX8/SnAMmXWMwo/vw
	 xdCfQCzCunPoMu9xqGAK4A18oKbFIOUJQhxkIJYMXhgFS/Ms+YHadkGCkOuth+dJTa
	 j/oVHggj+p9Hg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Congkai Tan <congkai@amazon.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Haris Okanovic <harisokn@amazon.com>,
	Geoff Blake <blakgeof@amazon.com>,
	Stanislav Spassov <stanspas@amazon.de>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Date: Fri, 31 Jul 2026 11:51:44 -0700
Message-ID: <178552142318.30097.12495596662819704320.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722202702.4165917-1-congkai@amazon.com>
References: <20260722202702.4165917-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 22 Jul 2026 20:26:58 +0000, Congkai Tan wrote:
> Today when the perf tool runs in a guest on cores with PMUv3p4, it fails
> to parse the default metrics with "Failure to read '#slots'", since perf
> can only read 0 from sysfs caps/slots, which is backed by PMMIR_EL1.SLOTS
> that KVM traps as RAZ/WI.
> 
> Taking into account backward compatibility and heterogeneous systems, the
> exposure of PMMIR_EL1.SLOTS is gated behind a new vCPU feature flag:
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Expose PMMIR_EL1.SLOTS under strict PMUv3 UAPI
      https://git.kernel.org/kvmarm/kvmarm/c/453f6ff04b8d
[2/4] KVM: arm64: Advertise STALL_SLOT* in PMCEID1 under strict PMUv3 UAPI
      https://git.kernel.org/kvmarm/kvmarm/c/203b22f76dc3
[3/4] KVM: arm64: Ignore writes to PMCR_EL0.N when using strict UAPI
      https://git.kernel.org/kvmarm/kvmarm/c/bbef6317f97b
[4/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature
      https://git.kernel.org/kvmarm/kvmarm/c/ad220e275c39

--
Best,
Oliver
