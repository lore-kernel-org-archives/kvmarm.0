Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795804793;
	b=mAVsvtb9021ZhQGedoaFY3dGMm0Y4fxD65DJ/Ap3mJQFddg4w3Lt6monqAYsLV93Mye6
	 iCW4X1p7bA5CH62hLkTi9rQX98GMstpJJFf5NhL253/5I7IYNKxhMAMMOi9zEZzW84CfZ
	 A+ZP8yZPHTNr5a3oRugVqAWyJIYi0i1zvZM5FeKfyl4mjLPLHjdkTqm/+rZGALLFtBNiU
	 +gE9bCeA9abgc2fk9eRZSAKMliPi4C13+0oczUZQ9FT2O73mrtOZtjyNZUVhX0XBHukGh
	 B+Dx1X3WGwDmt3MK9jNDCAuRwHW72tYnHJdul3vwyX378QTQs1bf/kqCHPugfdZ6Qdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795804793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=GMnIj8q9kqDMWvDp1Ahec1IURkuOha5hwJFXn0dtihM=;
	b=t97v8mokM9ekro7TXXkd2UtwGwdR1cR5tmecVmWSM8Z0Sjov62eT5f7YwhCcaVYM4Ynt
	 scyxCeXgwNlY/B+vS38hU/rUWal+Dh0zGeA2LNUTAaYycVHbLHMNC6e2s79B9iPRKEobu
	 DDBNOLODQwPmTr93RtVcjL4DrmWAworatjxfZkFhUSH66XQnMUyVhyTBvxqTcEjBixSsN
	 gCZhO0aIdMv77TuhVxW7aA4S7PkpJn2s/WKjiaaTc9hU+h7+42lcAipRLkAfNpu8aKRIy
	 F3C1N5Cfohefr6En2DT8Wl+txTmnSPLJUVZIA6sO5WxGqNrnfhUrC0sB5RcLwVguWAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PLx+PMfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975560A2620;
	Fri, 27 Nov 2026 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PLx+PMfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09711F031D6;
	Fri, 27 Nov 2026 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795804793;
	bh=GMnIj8q9kqDMWvDp1Ahec1IURkuOha5hwJFXn0dtihM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLx+PMfc7vjDf9xZiK+vAvRvCC6w5PV5VkvQOJk/S3QOM8SeGwDq2hJGCqee0t00y
	 0KIKpwWtdjgPLm1VpHc3p359yK//u7di3/X4i+U40305ax1M1uaUfWWP1qr1tIBX1e
	 AgfKwi0EI9Fo7aHbVHDDEdOQN0ZDUHgpRKVMZNE++Q09GKMDBllcXrE6vjS9PiiTxy
	 B1bo5dszztX0AakE9L9M0iXqt2SFrq4CMOsURWRywWem5olBh8XOM4hl5dP8AFh4k3
	 eUOZO6MGv2GMSgtjTDcDWSaMdidd9FsI0bI54pSPrYkzoQ1YYzRjs/gEFZ8JJ0Y3G5
	 A5Cpg3IWhWf8w==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com,
	Sascha Bischoff <sascha.bischoff@arm.com>
Cc: catalin.marinas@arm.com,
	mark.rutland@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH kvmtool v7 00/23] arm64: Support GICv5-based guests
Date: Fri, 27 Nov 2026 18:39:17 +0000
Message-ID: <179580197868.1668728.14216688807361955321.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127170145.4138182-1-sascha.bischoff@arm.com>
References: <20261127170145.4138182-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 27 Nov 2026 17:01:22 +0000, Sascha Bischoff wrote:
> This series adds support for GICv5-based VMs to kvmtool. These are
> exposed as --irqchip=gicv5 and --irqchip=gicv5-its, where the former
> creates a vGICv5 device and the latter adds a GICv5 ITS. The GICv5
> specification can be found at [1].
> 
> The GICv5 support in KVM needed by --irqchip=gicv5 is available as of
> Linux v7.4-rc1. The GICv5 ITS support is described in [2]; using
> --irqchip=gicv5-its requires a KVM build with those changes.
> 
> [...]

Applied first 18 (i.e. sans ITS) to kvmtool (master), thanks!

[01/23] arm64: Propagate IRQ routing initialisation errors
        https://git.kernel.org/will/kvmtool/c/643c84fcabdf
[02/23] arm64: Close the ITS descriptor when setup fails
        https://git.kernel.org/will/kvmtool/c/fd4073f5e2e7
[03/23] arm64: Split GIC device setup
        https://git.kernel.org/will/kvmtool/c/c97b9ac472c4
[04/23] Sync kernel UAPI headers with v7.4-rc1
        https://git.kernel.org/will/kvmtool/c/31cacdfe9610
[05/23] arm64: Add GICv5 irqchip device support
        https://git.kernel.org/will/kvmtool/c/ebcac904ebc9
[06/23] arm64: Configure GIC interrupt bases
        https://git.kernel.org/will/kvmtool/c/3eda0ae06c3f
[07/23] irq: Allow the initial interrupt line number to be set
        https://git.kernel.org/will/kvmtool/c/2ec8a3ef3529
[08/23] arm64: Start GICv5 SPI line allocation at zero
        https://git.kernel.org/will/kvmtool/c/217760904a04
[09/23] arm64: Configure the GICv5 IRS
        https://git.kernel.org/will/kvmtool/c/94a57e57620e
[10/23] arm64: Define GICv5 interrupt types
        https://git.kernel.org/will/kvmtool/c/bb395ae93047
[11/23] arm64: Describe the PMU interrupt for GICv5
        https://git.kernel.org/will/kvmtool/c/886ac67b5f4b
[12/23] arm64: Describe timer PPIs for GICv5
        https://git.kernel.org/will/kvmtool/c/c6f9c988b76b
[13/23] arm64: Assign CPU DT phandles
        https://git.kernel.org/will/kvmtool/c/6794fb727311
[14/23] arm64: Describe the GICv5 CPU interface in the DT
        https://git.kernel.org/will/kvmtool/c/265b478fc159
[15/23] arm64: Describe the GICv5 IRS in the DT
        https://git.kernel.org/will/kvmtool/c/93d7111bc83e
[16/23] arm64: Generate GICv5 SPI specifiers for platform devices
        https://git.kernel.org/will/kvmtool/c/5ac92cbe187a
[17/23] arm64: Generate GICv5 PCI INTx specifiers
        https://git.kernel.org/will/kvmtool/c/a21cd5dababc
[18/23] arm64: Expose the GICv5 irqchip option
        https://git.kernel.org/will/kvmtool/c/c5b95e85d3c4

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
