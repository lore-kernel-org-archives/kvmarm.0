Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B06A35B636;
	Mon, 23 Mar 2026 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774261861; cv=none; b=tJxEjfrTvHAnfuyzysBu/Bxp0ZBagHWuMAu+2MVcBidm6xWvDrDOQWD1/r7lYv1bpJVsbTtUI7Wqh+VPmzCP1V4P9X9HBtSRSAIjGnK9axqigdjjkXJ2vbWG5B6ZCigSoppTQyeeExzotmd1KtHww423AnWENNUAtsX0QZx981U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774261861; c=relaxed/simple;
	bh=KmGnBvKMzR3WBmIZw7lxqJvwoUfOF73BsW5xUbWkhjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INTR9SRKGLRuN6m/gdJhVYnrw9Qov7fozIxM5Wln6BFUDa79qF5t0BdbhZhqkGErd1GJn93APfq3RNAm3EY+uPUTxASPUae4mj/Yc71ctEzOpIVSF/K9m/BYDN/Z70+KjdX2rSY8zQKodGK/SoNd93yalWbuIyiNFYIhcCe9H/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jV5iEclb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jV5iEclb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40BAC2BCC4;
	Mon, 23 Mar 2026 10:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774261861;
	bh=KmGnBvKMzR3WBmIZw7lxqJvwoUfOF73BsW5xUbWkhjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jV5iEclbUcaLlVkz/oAjM0CHZbT9x7l1LoucV4A16HDLof2omrwFdjsJnOLu1db5h
	 Z1uIIrudQ8nElsVPPefCeHuR+OvDpv7e8SuYoi9iMxFyoBPfbeBwNlhqVP/HajZA4k
	 gqzLz5fhCzDObfrBrMwe7XiRU3vLmVytp2e3fpgzkctVaXcJBN6eMkxGt2vl7LxGAv
	 cEd/Gp5OnfWwDN4GWobZ/16iMA6jL3mNiJ8OtJQC2VU39CxpGuusPvg83uxz14mb3l
	 zzsBD5jwex+5R302u3R4vQeFITojQ/MPTqPUxAU7rd06Mw5bMNfQakPKng5COdc1wF
	 JOw3rfagwXfxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w4cYk-00000004g7W-2Cyg;
	Mon, 23 Mar 2026 10:30:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 0/2] KVM: arm64: nv: Expose shadow page tables in debugfs
Date: Mon, 23 Mar 2026 10:30:54 +0000
Message-ID: <177426184180.2895807.211946324243843322.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260317182638.1592507-1-weilin.chang@arm.com>
References: <20260317182638.1592507-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, weilin.chang@arm.com, oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 17 Mar 2026 18:26:36 +0000, Wei-Lin Chang wrote:
> This is v2 of exposing shadow page tables in debugfs, there are a few
> small improvements, please see below.
> 
> Changes in v2:
>  - move debugfs_nv_dentry also behind CONFIG_PTDUMP_STAGE2_DEBUGFS
>  - use a macro to define the file names of shadow ptdumps, also
>    explicitly spell out the string to get its maximum size
>  - add Reviewed-by tag from Sebastian (thanks!)
>  - Link to v1: https://lore.kernel.org/kvmarm/20260308231829.864983-1-weilin.chang@arm.com/
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: ptdump: Make KVM ptdump code s2 mmu aware
      commit: 204f7c018d76c2488a90fc6681519b8eb6eebb1d
[2/2] KVM: arm64: nv: Expose shadow page tables in debugfs
      commit: 19e15dc73f0fc74eaf63ad9b3a50648450269b4d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


