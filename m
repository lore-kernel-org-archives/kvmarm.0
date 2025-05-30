Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B2F21FF44
	for <kvmarm@lists.linux.dev>; Fri, 30 May 2025 09:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748597273; cv=none; b=MEobQaZ8dfC1mcIIJ8zhrGANNWkShs12SOxcjSvVrINEdMrIH/pLJwIlyMS2B1ahBIw8ZeqzSiKQsGN01PHQ+tA1QWPU/hq9dcP7PHkT5J3eJpYsuqTKLwwVlbT2FTnHy2ElncIPWyPD4kjkqyCPq2vzCPG9KoNMgj2NWIjvXMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748597273; c=relaxed/simple;
	bh=yZbB/aYnq5RRXas7SL6sK522IMjXH177xHOkAAcNkXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgFL9mM/sRt3VnGdwPlApz55gYnLTyzSQNKTz8v1vgGELG48Kd8PyvUV+yun+Xv9D9X7y0kx0NIs6Vw8SIGNGIU6VLVGuKGfKjP+RG2eRyKq+lw1LgVmjNM7nFTFtOBYRp9Ww6s2Jm7YTSw0ez8xHcIBweMYIH2l/FFXudwwB/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJCYVd63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJCYVd63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4021FC4CEEB;
	Fri, 30 May 2025 09:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748597273;
	bh=yZbB/aYnq5RRXas7SL6sK522IMjXH177xHOkAAcNkXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KJCYVd63aquv3Xa7Mr+m7Pry8/2ajc+X70pSQ5KvFPzyceO004i9Wn0pJFGptuxbj
	 K+LUwc2jzpbRHn+nNQylyV5YgCNdlv29UO3N2p5hvRwCcKQ50+DVCsDPOnR00/aLz8
	 BRV7NEHG2Ag3kvoZ4yk9beBfMyeSe897/33XvX4dYac+t0jxXl9OaiBvebOXB76A+c
	 yCVoFsQqTyhWGkgxoF2cyFUn8DX6su3Dh14vCttRvwjz+VVSsaiO8LfdMitvtVKorz
	 tbqNeKU1nL9NQ6YhrpivIKbVkN2TJRCYz/It5CYDWXb9hsZyG8NN/J6vbAmnFEuhZJ
	 O2CPuN6JcMOAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uKw1m-001oJL-KT;
	Fri, 30 May 2025 10:27:51 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/5] KVM: arm64: Some VGIC-related fixes
Date: Fri, 30 May 2025 10:27:47 +0100
Message-Id: <174859721251.1152851.11865968004373991220.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250523194722.4066715-1-oliver.upton@linux.dev>
References: <20250523194722.4066715-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 23 May 2025 12:47:17 -0700, Oliver Upton wrote:
> v1 -> v2:
>  - Added details to changelog about why its_lock gets removed later from
>    vgic_v4_unset_forwarding() (Marc)
>  - Fix email address for Sweet Tea's Tested-by tags (sorry about that!)
> 
> v1: https://lore.kernel.org/kvmarm/20250523160810.4049313-1-oliver.upton@linux.dev/
> 
> [...]

Applied to next, thanks!

[1/5] KVM: arm64: Use lock guard in vgic_v4_set_forwarding()
      commit: 761aabe76e6b1eb8850e72141cb026c7057e46fd
[2/5] KVM: arm64: Protect vLPI translation with vgic_irq::irq_lock
      commit: fc4dafe87b93ec94204896c4bc8cad7e71bdd151
[3/5] KVM: arm64: Resolve vLPI by host IRQ in vgic_v4_unset_forwarding()
      commit: 05b9405f2fa1848e984f231708fa1e5d385e4d27
[4/5] KVM: arm64: Unmap vLPIs affected by changes to GSI routing information
      commit: 4bf3693d36af9768c9bcc1df3a12d00ad6ea8083
[5/5] KVM: arm64: vgic-init: Plug vCPU vs. VGIC creation race
      commit: 07212d16adc7a02810e1641c2721762751ce4f88

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


