Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327B5213237;
	Fri, 10 Jan 2025 16:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736526183; cv=none; b=OR/aYJJaotw6Uxd53GgWNfGOJGCbgbKr3moRwljUfu8jST3WGpnnC2f4+zity1xj4iPC+RB0w6nM4SmrQgZ+geCuiIlugknJEIEyIktPAuo3MVUkmT2hj2jUEPIaqUVZbco5qTaA8FV/7Gey7/x/C0vcgauN8D2NRTOJoXOJDjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736526183; c=relaxed/simple;
	bh=+BmdB9emBwpf+gGi963mGVknRd9+wDnLwjWCpQ0Mzm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cImnOTN/Gugn8IYVBX5KRJeSIqvJVZH6F+XxC5nHeL/45t8zQAO37NpfzQKI9n8f1ZydZIg1f0hXtu/M579vctYyINzCmmXGkzRvqWxFLr3/AxO5HekXClzhv14jvrsB/ENBm5du6wVK8esIcJNxtX/G8enppbE9/XV1K4cJ8oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dl2PAI9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dl2PAI9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A456C4CEE2;
	Fri, 10 Jan 2025 16:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736526182;
	bh=+BmdB9emBwpf+gGi963mGVknRd9+wDnLwjWCpQ0Mzm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dl2PAI9IiEHY2aYlDERQmOJYSbxg6pOQL4FEpljVGlaA+uU4GGPdpzdX5HQ8Rg0NA
	 UjiuUAlG3cIGUeDfsJN0DJuL/cAqgerE6Ra9pL9kv6pMSKlRdTb2BbChwSpJVVrsAM
	 Ta842BkpivSBAquFSLJMUNZafNrBjCMBrD8U8ytQl8vwv9DhLeeOPvNGUoFlBh3y1H
	 NLck9Ji1lu9WCZHkK1mplL6LBQTyWxQvKl/4OEomOEMfkyc8qzFJSc9oUrRo+v6U9d
	 8jqzjC42AIMMu2Y6KbycXvb0fkciWnW4ZhNwek+DHtNJqJL/ON7Vd/9f79GyzjE+Ql
	 yaoYSyquO+e5w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] KVM: arm64: Support FEAT_PMUv3 on Apple hardware
Date: Fri, 10 Jan 2025 16:22:49 +0000
Message-Id: <173651597781.2396497.580300234024062639.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241217212048.3709204-1-oliver.upton@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 17 Dec 2024 13:20:30 -0800, Oliver Upton wrote:
> One of the interesting features of some Apple M* parts is an IMPDEF trap
> that routes EL1/EL0 accesses of the PMUv3 registers to EL2. This allows
> a hypervisor to emulate an architectural PMUv3 on top of the IMPDEF PMU
> hardware present in the CPU.
> 
> And if you squint, this _might_ look like a CPU erratum :-)
> 
> [...]

Applied the branch events patch to will (for-next/perf), thanks!

[03/18] drivers/perf: apple_m1: Map generic branch events
        https://git.kernel.org/will/c/4575353d82e2

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
