Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA43226AFC
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 20:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706819469; cv=none; b=SoIZ4OYxHdTVrI04gi6UuYXGbPbKYV3yadY9dW5MdkzPI94YUZx66tnxioZoXgY2wBOGzoXqBBt/cR6th6gRsNDOwylxfKq+53twubXdV3uoOcABsvhn2ynQSYX8O+sbAcFQwdN/nMup8f7mGdbvOj9HG9v4R67UqYenquxmtpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706819469; c=relaxed/simple;
	bh=pl01XxJvCSr905362CLcoeAKt0+bHnRT0ALDhya3/yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h3XRvdckuoX3V/TKoeGdQUOQQRAHt/+OB+fDRKPvcwjRwxTkLQxIRR5/gqwIiDAhA/9V8UBwfe6Izpu3N9bwpAgg3eBWAFYmhh3MUVq2SFx5uXsz2Lyr06Do/swWE2x0P2u7TEhzdsmC6LwrDQYmJztu9SHQ9dEb+I0tYKRkvu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dq/YUIlZ; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dq/YUIlZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706819466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cwP6DcVMHmam3R5gLofRFfJeh4GcrsoYje2BNlcsz5k=;
	b=dq/YUIlZ0XRTWoXuyrgAiNJkKdu4Bet/xKIqTO3mSElVcEBmCHVNqwQEQ7d1WdMnQY7wvD
	uMMWlyrB5CemYCsknlVxTDBvU2fstX/weM/r3bTinQjj+npQibyJ1VyTD8YCh9o86Iz3Wf
	Za9FRTRTdMVuKfBOoR5PkZ9QelMapIE=
From: Oliver Upton <oliver.upton@linux.dev>
To: Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 00/10] KVM: arm64: fix many kernel-doc warnings
Date: Thu,  1 Feb 2024 20:30:19 +0000
Message-ID: <170681941355.2769902.10865128203340654876.b4-ty@linux.dev>
In-Reply-To: <20240117230714.31025-1-rdunlap@infradead.org>
References: <20240117230714.31025-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 17 Jan 2024 15:07:04 -0800, Randy Dunlap wrote:
> Fix a bunch of kernel-doc warnings in arch/arm64/kvm/.
> 
>  [PATCH 01/10] KVM: arm64: debug: fix kernel-doc warnings
>  [PATCH 02/10] KVM: arm64: guest: fix kernel-doc warnings
>  [PATCH 03/10] KVM: arm64: hyp/aarch32: fix kernel-doc warnings
>  [PATCH 04/10] KVM: arm64: vhe: fix a kernel-doc warning
>  [PATCH 05/10] KVM: arm64: mmu: fix a kernel-doc warning
>  [PATCH 06/10] KVM: arm64: PMU: fix kernel-doc warnings
>  [PATCH 07/10] KVM: arm64: sys_regs: fix kernel-doc warnings
>  [PATCH 08/10] KVM: arm64: vgic-init: fix a kernel-doc warning
>  [PATCH 09/10] KVM: arm64: vgic-its: fix kernel-doc warnings
>  [PATCH 10/10] KVM: arm64: vgic: fix a kernel-doc warning
> 
> [...]

Applied to kvmarm/next, thanks!

[01/10] KVM: arm64: debug: fix kernel-doc warnings
        https://git.kernel.org/kvmarm/kvmarm/c/c4d15f841570
[02/10] KVM: arm64: guest: fix kernel-doc warnings
        https://git.kernel.org/kvmarm/kvmarm/c/39db66e6b404
[03/10] KVM: arm64: hyp/aarch32: fix kernel-doc warnings
        https://git.kernel.org/kvmarm/kvmarm/c/bc13610b4240
[04/10] KVM: arm64: vhe: fix a kernel-doc warning
        https://git.kernel.org/kvmarm/kvmarm/c/aa96af24f320
[05/10] KVM: arm64: mmu: fix a kernel-doc warning
        https://git.kernel.org/kvmarm/kvmarm/c/ffd9eaffa34d
[06/10] KVM: arm64: PMU: fix kernel-doc warnings
        https://git.kernel.org/kvmarm/kvmarm/c/2a00f0855530
[07/10] KVM: arm64: sys_regs: fix kernel-doc warnings
        https://git.kernel.org/kvmarm/kvmarm/c/8ce783927268
[08/10] KVM: arm64: vgic-init: fix a kernel-doc warning
        https://git.kernel.org/kvmarm/kvmarm/c/dd609a574a02
[09/10] KVM: arm64: vgic-its: fix kernel-doc warnings
        https://git.kernel.org/kvmarm/kvmarm/c/f779d2c0176c
[10/10] KVM: arm64: vgic: fix a kernel-doc warning
        https://git.kernel.org/kvmarm/kvmarm/c/e634ff9598a4

--
Best,
Oliver
