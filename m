Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9E3441619;
	Tue, 15 Sep 2026 22:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789511147; cv=none; b=ZcvcW4BlaevV1D3ARwexVTEoUVIG/GABD42e6W0CXJshXSgFKQypQDKJKPviv4UNiGxWtNbrIlUP1a5Sc+OFUuxM9x4vUZTBPQMLH5/U00SOokZ3wMez2KO9oAeMi50ewlti6nQwxJSnaa9kF+I8girNzap0MxN5IUT/CBi4wMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789511147; c=relaxed/simple;
	bh=rv5a9A1n+V27tBVg2Yrxl/jSLwzXiJbXCGqPyTM5FNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GLcm4st1vwDvkqFwVpYex+rE8KL4HWsnb/G97rCZHc52pZj5znVaKf4N4KeUcwwNTB9z0lmub334YUMi+LlvIfFQdKzhJgqSBp1fPaOsh1lOKT0i5a1kkX2i7bsC5XDVf3KzkaO1p5rfb/eRU7sfBL4gzjW4mJuk5uZxK+CEP+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qlu+BstI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qlu+BstI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100211F0089A;
	Tue, 15 Sep 2026 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789511146;
	bh=QNxI24y/TunKWl5C4ctu+sU3K8XoQzuW+d1dKY+Zk0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qlu+BstI+KeC/+51Se/nSMCSIVHhkuoebDOQF430ks/qH2TgcDhtSLujgIJxxxzo6
	 vMSstDex8T23NYcsT9gfC13O4h3wLPfaY4evcTEJg53z/eHgRIcCz271+8x9rkLLv6
	 BAx3YTr+0tcv7QU3b/d6bkvHlb+lhWOBr1wdrkFVNi1MPIZIvSFT85yCo4Zhm164dl
	 FQa/cON2MpxXqNiLx9kvwPTwj3o6fOBUfQYMEQ9zi/QlqOHbdh64SN2olYjXj3Mqr3
	 pbgF+jLOwA0hKlb2efGbCaQBinsBfBoivb1jOBtbZ93M+Kqkn9vEl4rhZ3R/jZAdVh
	 VKfs8EPLlvm1Q==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Stefan Teodorescu <fane@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: arm64: pKVM SVE vCPU init fixes
Date: Tue, 15 Sep 2026 15:25:34 -0700
Message-ID: <178951103700.10790.15404656431875850871.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260825085948.1674721-1-fuad.tabba@linux.dev>
References: <20260825085948.1674721-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 09:59:44 +0100, Fuad Tabba wrote:
> If it's not the GIC, it's SVE. I found these while preparing the
> follow-up to the pKVM core series [1].
> 
> Patch 1 was posted on its own [2] and carries Marc's Reviewed-by. It is
> unchanged and included here because it has not been picked up yet and
> the rest of the series does not apply without it.
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
      https://git.kernel.org/kvmarm/kvmarm/c/2a2eb10795a1
[2/4] KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
      https://git.kernel.org/kvmarm/kvmarm/c/a1b3c788ad31
[3/4] KVM: arm64: Key unpin_host_sve_state() on the state it unpins
      https://git.kernel.org/kvmarm/kvmarm/c/0d62fbf34d8f
[4/4] KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2
      https://git.kernel.org/kvmarm/kvmarm/c/4f16c5fc8dc4

--
Best,
Oliver
