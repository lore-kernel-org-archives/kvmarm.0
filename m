Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C784236453;
	Thu, 26 Jun 2025 07:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750924400; cv=none; b=hyF80aQny5LZuv0kdqfgT1zyXugC4NLvkKiVe7Rs0iQ2F+aWknl71EV1HmCsrMa35ohxt7OH81IOYRuhsohe8RgL0acUmYOhMqXo3msdA1rQ3LfDzbCTT/q2elEUhpZ3AGOWuOUc7P9JhIqHpQo/VotTyXKur7HuBpLxDS5Ykgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750924400; c=relaxed/simple;
	bh=pjppoiz7ViHXJGvWqCdSU9HQ/aOIYap1jzl8DIHCo8E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZ6us2MyyVdYX04BP1MP89niY11zN60PMkcM5ljhcYu//ekIZV4v6GUUepT66akBKlvaBbIcmZAL88aK8MGM81eIIy4BxHXrY69AsCvA7RJXTqIJv8nzTnQXwOs+C/SebhhiJY2gwh2NOqcgTG5y7tVtkI9qRSMWxIq5ijeHcCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MnQ6LWlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnQ6LWlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DFCC4CEEB;
	Thu, 26 Jun 2025 07:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750924400;
	bh=pjppoiz7ViHXJGvWqCdSU9HQ/aOIYap1jzl8DIHCo8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnQ6LWlMe+2wYiBCFcn5tjJreD/T2jgmXmwxz6lFsBp+jZfpsJbIL9OSOl3wJf0k3
	 SonfgF0kuenpryOVQIOB+G7DJuR+SO4yGzMfoQ9NJM2tRlmhOwGguqU1h+X7IVilHZ
	 KK5I1rR9GARclkdcEytAw9oArcVKtvmV9w5yWnuRD4Ga4ahThvoD10GlKojMhfmgJh
	 Kuh8D1hy2OX/6Pnd0g0G1P2x6ckQR9SAQ6WUtEe0jKOQbDA7H9M8eBsqXuSrwpg221
	 Kugd+O+0esiXPGIs63/14oJVc+QuR6c+GfmgrfcsC5M0dAVnSxU+3x9DGMxW4H7qjq
	 IOz5VWGUSncaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uUhQ6-00A8hJ-0Y;
	Thu, 26 Jun 2025 08:53:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Adjust range correctly during host stage-2 faults
Date: Thu, 26 Jun 2025 08:53:15 +0100
Message-Id: <175092438911.7995.9528618735352034955.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250625105548.984572-1-qperret@google.com>
References: <20250625105548.984572-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, qperret@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 25 Jun 2025 10:55:48 +0000, Quentin Perret wrote:
> host_stage2_adjust_range() tries to find the largest block mapping that
> fits within a memory or mmio region (represented by a kvm_mem_range in
> this function) during host stage-2 faults under pKVM. To do so, it walks
> the host stage-2 page-table, finds the faulting PTE and its level, and
> then progressively increments the level until it finds a granule of the
> appropriate size. However, the condition in the loop implementing the
> above is broken as it checks kvm_level_supports_block_mapping() for the
> next level instead of the current, so pKVM may attempt to map a region
> larger than can be covered with a single block.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Adjust range correctly during host stage-2 faults
      commit: e728e705802fec20f65d974a5d5eb91217ac618d

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


