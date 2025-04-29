Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292B2270EC8
	for <kvmarm@lists.linux.dev>; Tue, 29 Apr 2025 20:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958499; cv=none; b=DCZl9wBkBx5/jssdbxAieK8Cixypppi0R6KIfXJ48jqlz2sXGZra8RPnh8cu2Mz3wyfnTCNLprc8GoNkc4TLj/zyiWb/4jMcD5PvdAL/O1F+YNAlORwVseXfASxCCfxrtYi9bdJv0DJB83WB0dN253brCCCVraHo83ZVS8BPels=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958499; c=relaxed/simple;
	bh=UcHVSdsNl83YVYs97yxyIXsnWeVius4kIYuiTanaakY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eRx6/DNgQUdqgfUAwz1/OKbkR2mKwVdrAkwgcFWZQYnbmFIloV2nrqqHam1BJEGdZvf5xpN/XMWmRAxY+K41RUtTyhXqzUcvWF5wck/zUPmwxkVxhqgAwLG9T4Up56FfyBRBBdqcHDdPlPFIvkJw9K9mSO/UNNoiATMx3P+PrX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmHse4nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmHse4nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25B3C4CEEA;
	Tue, 29 Apr 2025 20:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745958499;
	bh=UcHVSdsNl83YVYs97yxyIXsnWeVius4kIYuiTanaakY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmHse4nzSC0xWNL4u/4jmwhwqNq4C+kaqNKOcH9vNXevTJgqxMCmNecz6kK0J3B4K
	 7CYa89bITs71Mr/XFTpgTv6hoaL9apAO/QImvekdvtC8otfrsaZIzMKBUDdHVpdv5f
	 Sr1UCApB4gUlIxA85rYbPbhsK48P3ergbjlupCyu0/gDt6iEgKljJXBpeu8NU7PRNc
	 HEcgL/oAVQ0V44ZoSjXAVno8S7IrX7LY+qYU6l7Q4Tu0faTpm73M/FilDOLqKIJiXy
	 hxY0GldFfrAELs4wk04hazBONREJGTC9jwfNSXwsDFuUNRJEjJvIcXN7q03oz+c/8G
	 w0uDwvsIGGjjw==
From: Will Deacon <will@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] arm64: Expose AIDR_EL1 via sysfs
Date: Tue, 29 Apr 2025 21:27:51 +0100
Message-Id: <174593179853.437254.7295109441381830803.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20250403231626.3181116-1-oliver.upton@linux.dev>
References: <20250403231626.3181116-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 03 Apr 2025 16:16:26 -0700, Oliver Upton wrote:
> The KVM PV ABI recently added a feature that allows the VM to discover
> the set of physical CPU implementations, identified by a tuple of
> {MIDR_EL1, REVIDR_EL1, AIDR_EL1}. Unlike other KVM PV features, the
> expectation is that the VMM implements the hypercall instead of KVM as
> it has the authoritative view of where the VM gets scheduled.
> 
> To do this the VMM needs to know the values of these registers on any
> CPU in the system. While MIDR_EL1 and REVIDR_EL1 are already exposed,
> AIDR_EL1 is not. Provide it in sysfs along with the other identification
> registers.
> 
> [...]

Applied to arm64 (for-next/cpufeature), thanks!

[1/1] arm64: Expose AIDR_EL1 via sysfs
      https://git.kernel.org/arm64/c/17efc1acee62

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
