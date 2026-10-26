Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016078;
	b=Fv76vrGkTYy9EPzOZgZki1XnWNsc8oDfLhTPschVenkIlnDlPZpUSACpTJyJhY2gOMRF
	 AMXhfO6X8CHoXbZULgNxARFk0Nq5dSQR16zVXIECiY8k+bevREhRDCjdE0biitx6LSU8K
	 UK41+XRGllynnEuXmJB7QSqDxvYbkU4LSRKvUdpNVl5huAE/AFuZKjMKB70DgDvUGg+7Y
	 wolD1FkcE/E9bFi7jK9GLBAcdwVEmma8zPrzl78OF5DRELcw8v7iBz6j3D6gtFbRiLRdi
	 6drNajpFigbn6gvMzvotoNaKdy9EUkkyAyL9cg0rcxuOPH6fb22OMpB85ZCXCv77c+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016078;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=FHBChhLbuB6TzLDwIH+42vOrmoSeOsBok/XmKTA9HCc=;
	b=Ib9tXLstpXVNSS+5S05Ba1wg/R3VuO0EQk/6duiV5Zd3xTdYeQTQ09D8oa96ONM8KSWr
	 CQfOVW7GU4RUCaADgDfOLp7yHTAbAxU9jUE2pbXZoDp7eJ8lgcbtX5VvtU3wyeIFSryE2
	 bu24QOANVsQWB4YlWuy7S0pJKwwdfwxKkegLxkwrVRmhqYGFP5ylOkqrmiqvONvfFZ4NW
	 ZHqZMq3FZLbWiv84pZLcVQKDmjoJAn5HtghlRouDascP8DeStBdrIYM0OHxuPQnd1eL84
	 Qow+UAQQgWRtCyJjiLrL2lcQl0qNMl3cdJ21+Cd2pAu/jVAtlFj/wtvPxVbMOEQomYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Okps9Vgd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3C7606A326;
	Mon, 26 Oct 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Okps9Vgd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6491F01829;
	Mon, 26 Oct 2026 12:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016077;
	bh=FHBChhLbuB6TzLDwIH+42vOrmoSeOsBok/XmKTA9HCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Okps9VgdhbOD6me+jQl800n6iIjMigUTKIsrz8CWl87dmXIbPffJKtTnCSETproxl
	 +ZulYUKEDIFyP/4CrfH0I8nfxLrveoZ7pdrBrewqqJmqIBMMFVsB6lNObLwgJDSXpi
	 kthYsdjdCJRr+3k96yGNfqx5N7tp78gRbMEsx8XB1n3dapVKvYbfbxSwGILLpsMtXS
	 4aldojnTas5rbnIsGJL0+rIK92PjZe6O5oaV96RdTd1rfCTuKSZ/23oMHV2seFuqTU
	 LKTKyBczFiuuf4PyZYaUn2h+3ibYSYeMylr5CufZMmEVu4YosYKAQV9ArB10dtBjZz
	 0DaBjXnHX2/1Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLJO7-00000007Fr6-435Z;
	Mon, 26 Oct 2026 12:01:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Set HCR_EL2.BSU to Inner Shareable for guests
Date: Mon, 26 Oct 2026 12:00:58 +0000
Message-ID: <179301587176.2527370.16109421648237594785.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261016081558.805411-1-fuad.tabba@linux.dev>
References: <20261016081558.805411-1-fuad.tabba@linux.dev>
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
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 16 Oct 2026 09:15:58 +0100, Fuad Tabba wrote:
> KVM sets HCR_EL2.BSU to Inner Shareable for guests, so that a guest's
> barriers cover the TLB and I-cache invalidations that HCR_EL2.FB
> broadcasts. However, since HCR_BSU_IS became an alias of the generated
> HCR_EL2_BSU_IS, it is the unshifted field value 0b01, which sets bit
> 0 (VM, already set) and leaves BSU at 0b00. A guest's DSB NSH is then
> not required to wait for a broadcast TLBI to complete on other CPUs.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Set HCR_EL2.BSU to Inner Shareable for guests
      commit: 00e73757518020273ccf6308a51f214e58c21ad5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


