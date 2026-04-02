Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CE530F52B;
	Thu,  2 Apr 2026 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775136963; cv=none; b=Aq5qFN52EmLEzUBdGQmu9ASCJrlHeTvLhRpgtt8Fmtk43L1dm8gc1k9zioMGM73F0CHteHKp8JRzELKXNISOFdE6Joa5BK4crBcB0hCgEJ31HEqfH2O77V6Qth6kORiZgXPjXShWJ+F5bwX3gIr6bjL8li+YOXQctwx5sf8PBMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775136963; c=relaxed/simple;
	bh=iXINi8wbcgvvzxIu9ZHmz3Yjq2Fc7XgtVugmJpzXWCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d2481YmptPnwlnsos8E+tdnGayUBuX1HRODarCf7hmP6dFKkK56IXyht+CqeNdgMbCRSFPX6dYnFLoGgRc6/2Q2r6hmmQOyXspgV7dcgarUEWaMUsMUunvNyXyBjtlc41jSuEWqiuwuzIaoKWS8GPoedrQk7jkeJH51npXwgFuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e56R5cnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e56R5cnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB317C116C6;
	Thu,  2 Apr 2026 13:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775136962;
	bh=iXINi8wbcgvvzxIu9ZHmz3Yjq2Fc7XgtVugmJpzXWCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e56R5cnc20S9El3aMHHHBTQRvZSsqaxF2lg6ImbJ2wBCqYLJw+aMX4lIjCKzzMiAv
	 j6H2JrI3PiIzlJLMqqsS5I8M53oFf+JIgngZtHffdmM8LCfGw1/qZTWdB7y/z6jZC0
	 M2j+3KQ1wZozPL9TLEtZplX8MgJUjHyNkxx9GP3QlZ1JwNbCe0NZPhaWqV+XTEynCp
	 tFrqGMynIs/1EVg+9hroiyexarqqOc6ZHxVsx4X1iY5OkNlVRfdQ53HZBxsGys0gXr
	 UsIiGhloE8jbkm22HnlRwxUWWVNyzX0xlDUMPlFcyQCb8JU/10gII9Gnx8YcT3UlNb
	 zVQvJvlvRJYBA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w8IDI-00000008GzR-1g99;
	Thu, 02 Apr 2026 13:36:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	android-kvm@google.com,
	Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com,
	joey.gouly@arm.com,
	mark.rutland@arm.com,
	oupton@kernel.org,
	suzuki.poulose@arm.com,
	tabba@google.com,
	vdonnefort@google.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH v3] KVM: arm64: Prevent the host from using an smc with imm16 != 0
Date: Thu,  2 Apr 2026 14:35:57 +0100
Message-ID: <177513694954.452775.15481446147791932639.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330105441.3226904-1-sebastianene@google.com>
References: <20260330105441.3226904-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, android-kvm@google.com, sebastianene@google.com, catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, oupton@kernel.org, suzuki.poulose@arm.com, tabba@google.com, vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 30 Mar 2026 10:54:41 +0000, Sebastian Ene wrote:
> The ARM Service Calling Convention (SMCCC) specifies that the function
> identifier and parameters should be passed in registers, leaving the
> 16-bit immediate field un-handled in pKVM when an SMC instruction is
> trapped.
> Since the HVC is a private interface between EL2 and the host,
> enforce the host kernel running under pKVM to use an immediate value
> of 0 only when using SMCs to make it clear for non-compliant software
> talking to Trustzone that we only use SMCCC.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Prevent the host from using an smc with imm16 != 0
      commit: cf6348af645bd8e38758114e6afcc406c5bb515f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


