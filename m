Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2114611FC
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778084080; cv=none; b=Nd4rESUh/EK1fTqliE8ZxzRjPO3me4hf1s66dIznJgfWZP87RM3sq0dvZ3yXNRgmQw9+bcJrsZhSvNyD+OdLZpsgy9bu+IV6L2fgH2oGjxcsZISW3hx+0a19H6hyj6BDyh+LLeV6nBH3//1Agg2Z3UTrnfwEPz9OyGTGcMHtRXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778084080; c=relaxed/simple;
	bh=NWybhyhZOftJ9uYzJ6gBhCYWxRgsVrDsoYwiBx0JL+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fUhX0/7L2suygQOIkSTYJuwdU8NBAJI22LE+jbZSSgiYprOHGBUEW7YsQc0MAho+FxWWUzS+JEzzhqa2Kohsvdkxfgb4Q6L4Qoiw8DjEmRUl2KBThWUMdV0zhKeNi3RQpOIRpNpG+OlJIRTyytz9qU+QHNzhp4uI0KnoCtNy2ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5fY96X9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5fY96X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDFCC2BCB8;
	Wed,  6 May 2026 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778084078;
	bh=NWybhyhZOftJ9uYzJ6gBhCYWxRgsVrDsoYwiBx0JL+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5fY96X9nEDw11sMbwI3KaWS9j+3p2jEuuARhK9OvDaBwQN9wAzJfEOtWtSDYHx4d
	 5u1Bj/VqUmri3eMVa6zUn5h8lZZ7o1UAJQ7w1+F8SSiwkYhvC8orc6RISZX0hzCycL
	 PWwrNOPQ3CstXUbeKGvYkn9Eg9wuOoLniZrCGOXZBWXzmgg5VpUNz9Z1440KnXV/0X
	 6xNWZTWAu9BWtF8/2gWoP8Ko9LcD7mjGd79E4jzFe0sb20whz6+UO6tsPVK3qJ0Gzt
	 wxCgbnXkbrZ0t5cnxBOjIAhS7WlD3hoKdbKXcnv/TJ86GNE8SvGM5Yfnz0gH42nFmT
	 b9Ps6XZ4W1bWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wKetQ-00000000MI9-1pD4;
	Wed, 06 May 2026 16:14:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: Work around C1-Pro erratum 4193714 for protected guests
Date: Wed,  6 May 2026 17:14:33 +0100
Message-ID: <177808404886.2712489.16077885657000139159.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260505165205.2690919-1-catalin.marinas@arm.com>
References: <20260505165205.2690919-1-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, mark.rutland@arm.com, oupton@kernel.org, vdonnefort@google.com, lpieralisi@kernel.org, sudeep.holla@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 05 May 2026 17:52:03 +0100, Catalin Marinas wrote:
> C1-Pro cores with SME have an erratum where TLBI+DSB does not complete
> all outstanding SME accesses. Instead a DSB needs to be executed on the
> affected CPUs. The implication is that pages cannot be unmapped from the
> host Stage 2 and then provided to a protected guest or to the
> hypervisor. Host SME accesses may still complete after this point.
> 
> This erratum breaks pKVM's guarantees, and the workaround is hard to
> implement as EL2 and EL1 share a security state meaning EL1 can mask
> IPIs sent by EL2, leading to interrupt blackouts.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Work around C1-Pro erratum 4193714 for protected guests
      commit: 1f7305d87aa23db2579df222eba504a333c2c978

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


