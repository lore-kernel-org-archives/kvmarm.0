Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C310784
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 08:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0D5C433D9;
	Fri, 28 Jul 2023 08:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690534067;
	bh=e+3U+cBzZz/pg+nQwB+caVki3U/+XywuXbOHT1akfDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ot5gdhgzjqy3MeeWhdLFzCKzulFzs4IteHMoBOshJo/Qtp7EU1ErlOdE+3REBVb3+
	 3HKe1jpsDgnJw17fsM/CWHIIYnl/d6Tg0N9yEnKbusRd/tIcB/v/7qUfNAlPvO3wjy
	 a2EOOUhy6nJah6nV2fNnOwV6oE0HmK2EdUUXWrLnxHgQcd2Raa9JvrmGDeUCYz/BlC
	 rCmCl3VNApL+xa6kl10rst2Jd1cxpszrg1H7zrqkg4PDdZ687Lp8Nwwy5nt/14Qsok
	 OQ2odx5aPlm6CXseiS15v84tfLbLsU2vrJJedBPoSstE8vSaZAp4cKl+9/kJWfJehu
	 pqAyRfb2cBE1w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qPJ8T-0000kI-MN;
	Fri, 28 Jul 2023 09:47:45 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Use 'generic' vCPU target across all uarches
Date: Fri, 28 Jul 2023 09:47:42 +0100
Message-Id: <169053403727.959943.5992623820320299989.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230710193140.1706399-1-oliver.upton@linux.dev>
References: <20230710193140.1706399-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 10 Jul 2023 19:31:36 +0000, Oliver Upton wrote:
> kvm_vcpu_init::target is quite useless at this point. We don't do any
> uarch-specific emulation in the first place, and require userspace
> select the 'generic' vCPU target on all but a few implementations.
> 
> Small series to (1) clean up usage of the target value in the kernel and
> (2) switch to the 'generic' target on implementations that previously
> had their own target values. The implementation-specific values are
> still tolerated, though, to avoid UAPI breakage.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
      commit: ea55d5a2cf7c507a9ac03b41716bf1877edad153
[2/4] KVM: arm64: Remove pointless check for changed init target
      commit: c8a67729b8a36a5f4857de645ee9808fc99d8618
[3/4] KVM: arm64: Replace vCPU target with a configuration flag
      commit: ef98406036769107d5c49a519b31c940910b98d3
[4/4] KVM: arm64: Always return generic v8 as the preferred target
      commit: 5346f7e13e5eb134920a14504b6900c6168dd16e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


