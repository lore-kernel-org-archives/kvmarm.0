Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BA0221DAE
	for <kvmarm@lists.linux.dev>; Sat, 10 Jan 2026 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768040590; cv=none; b=b5Wg0cTnK4qTjoCVdKHHEuG1P0K6aWB+jyWUMeLFWSVACthWKSDD7soKOspL13pnPhxXkK1FX0Z3bl7br9wd53YxQaSBqRrGgiS4oVPRi5c+1XF+ux95ePCIGiNWzwcgX+Qe8HxfeBuHLqasFRm3LkMeuGD3AO927qeINne8J10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768040590; c=relaxed/simple;
	bh=C7NdkOT1sMR8XLqlXwIBf7iZlmsgloV8Oc2iGw0koCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxe9RUT2QWUlUdxqKbtoXcZitjioZMQ9pwu/+XetTKH5GdN8oR5XQtMwfAK8Y5reR/tnVs/Sl1sX3ey2z+3uKfsxrwIbpihIWOBO7Le1tS0+k/u/BfSqb3kKaf+gtFabJ+qV1IrXJHzxJKqLZu2f9Wet/NGYMrBd34uK7fCSWBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmwZ9hH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmwZ9hH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C91C4CEF1;
	Sat, 10 Jan 2026 10:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768040590;
	bh=C7NdkOT1sMR8XLqlXwIBf7iZlmsgloV8Oc2iGw0koCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmwZ9hH6FmsIbLR17pRxisu69tMxpCgO4J4tBNBsAHU7QKgZToVT3UzA/sTTZmVG0
	 ZDsYxVubWpV8DfOCqJeI0q+59hhVhzOTUj72AYzT2Xea/f+aX9mGdYOSp8mXN+4q5f
	 zWml/G1r7E3u9etQfqBvsdFl4PWrqF8Ff1mHDW8SQ6uAWaHpfHXHKFd2nMXBWc88tZ
	 R3hUgixYifXg0ExHZdyczWRhxTxTEDnfzff9Y+IchG0xChNBtdLs6jgwU8+A7t5yV4
	 6uQcvlxJwZ2ZM3KYl4zP/5uu4/cZPeE2jmH2ps4ljpKgJG7cHrRNDmXTiqpoAzNFRs
	 au/dfQ8FHABlg==
From: Oliver Upton <oupton@kernel.org>
To: maz@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v3 0/4] KVM: arm64: pKVM fixes
Date: Sat, 10 Jan 2026 02:22:42 -0800
Message-ID: <176804045755.916140.1262128534408515726.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216103053.47224-1-alexandru.elisei@arm.com>
References: <20251216103053.47224-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 16 Dec 2025 10:30:49 +0000, Alexandru Elisei wrote:
> v2 can be found at [1].
> 
> Similar to [2], when trying to run an unprotected VM on FVP with S1PIE enabled
> and kvm-arm.mode=protected, writes to PIRE0_EL1 made by the guest in
> __cpu_setup() are trapped by KVM and the BUG_ON(!r->access) is hit. That's
> because HFGWTR_EL2.nPIRE0_EL1 is an inverse polarity trap and the FGT values for
> the unprotected pKVM VCPU weren't being propagated from kvm_arch_vcpu_load().
> 
> [...]

Applied to fixes, thanks!

[1/4] KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
      https://git.kernel.org/kvmarm/kvmarm/c/145cc42fe121
[2/4] KVM: arm64: Inject UNDEF for a register trap without accessor
      https://git.kernel.org/kvmarm/kvmarm/c/aba963cb98c6
[3/4] KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_hyp()
      https://git.kernel.org/kvmarm/kvmarm/c/26cdea4893c2
[4/4] KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()
      https://git.kernel.org/kvmarm/kvmarm/c/d252c7898ebc

--
Best,
Oliver
