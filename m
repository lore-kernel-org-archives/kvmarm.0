Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF93263A
	for <kvmarm@lists.linux.dev>; Sun, 20 Aug 2023 08:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EF6C433C8;
	Sun, 20 Aug 2023 08:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692521097;
	bh=Z33WikzOHKhSEole+Mw0Nb1MuF5jxguIoWu8Vv7lKQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix6PFHLMrmA8kAGa0XrvFjh2nky/uNK+X/KwmnNEepVbrH+/l+HZJGoVWNq+KbIys
	 jr7gELg2p14neVF37G31/bNhOaN04d+vNrpugytjjmyDHDH10fQxnM5NCmlvhA9Kq+
	 F5b0TO+dA5kQxfs8UVeF4x5SF1bGEADFSL4p+/iWBm4HO9CA9ounb3xgEwPukqYifn
	 da7GfmfYmR+JVmrLKp5AaBNCf3ZJAU5hRiz4WggVqyTqbQLPZjpN1hGMUr4X94gbdW
	 p2ohWpxdbXwoo4vLZqCWYKO1zHUcH+3Hjduh1yU5CououoW0XD2roBmcd4lZM0gqFN
	 lAgB3KDC1klIg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qXe3K-006Ojj-Ql;
	Sun, 20 Aug 2023 09:44:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 0/4] KVM: arm64: PMU: Fix PMUver related handling of vPMU support
Date: Sun, 20 Aug 2023 09:44:52 +0100
Message-Id: <169252108449.2789996.2547305803537475938.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230819043947.4100985-1-reijiw@google.com>
References: <20230819043947.4100985-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, reijiw@google.com, oliver.upton@linux.dev, james.morse@arm.com, jingzhangos@google.com, rananta@google.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 18 Aug 2023 21:39:43 -0700, Reiji Watanabe wrote:
> This series fixes a couple of PMUver related handling of
> vPMU support.
> 
> On systems where the PMUVer is not uniform across all PEs,
> KVM currently does not advertise PMUv3 to the guest,
> even if userspace successfully runs KVM_ARM_VCPU_INIT with
> KVM_ARM_VCPU_PMU_V3.
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: PMU: Disallow vPMU on non-uniform PMUVer
      commit: ec3eb9ed6081bea8ebf603ff545dba127071b928
[2/4] KVM: arm64: PMU: Avoid inappropriate use of host's PMUVer
      commit: 335ca49ff31f145c0f08540614062197a334e064
[3/4] KVM: arm64: PMU: Don't advertise the STALL_SLOT event
      commit: 8c694f557fd80ca9815ddb1cf5de10d8bf168110
[4/4] KVM: arm64: PMU: Don't advertise STALL_SLOT_{FRONTEND,BACKEND}
      commit: 64b81000b60b70f10a5834023fe100902d9f7a57

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


