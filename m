Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8828B320A
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 08:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9F4C4339B;
	Thu, 20 Apr 2023 08:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681978126;
	bh=sNcC/4YLuv3NV1p2vjUhFdV9MKTBqvreodvPR0jwTFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNuxodsMu1W9T5KWvV+jGZLBFBPdMjp5HMnn2QlWIZmthC73SclTsmIPjVbXmP3Ro
	 cOEooQv3vMEepGHqVZmYX2ALVJJaJY7IXUPCOSF0TpeSTaMEnFPRRWjjGs15KsBlST
	 IrGaG2Ybj9T3duGlrZpKUJwJeMVAyaVGDxiaOJDSE16tAbxW6E0VmS4r2+uZTwNwWo
	 tEIUR7WM/CBd+Ue9dQeSrXKSnfirFGwvV71+EKIHRkxFLSWUiw6UtD/EStZacH69F/
	 9zELN8dM3T2dh8nMDPqnjb1gncoZmVlvU5B123dmpkeKhjmos+Iuvwch5IyGdBNG9i
	 xIMuNgrO17Yug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ppPLQ-009n1B-0Q;
	Thu, 20 Apr 2023 09:08:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	James Morse <james.morse@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Ricardo Koller <ricarkol@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] KVM: arm64: Fix bugs related to mp_state updates
Date: Thu, 20 Apr 2023 09:08:40 +0100
Message-Id: <168197811285.2978116.18354347158121769762.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230419021852.2981107-1-reijiw@google.com>
References: <20230419021852.2981107-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, reijiw@google.com, oliver.upton@linux.dev, suzuki.poulose@arm.com, rananta@google.com, james.morse@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com, alexandru.elisei@arm.com, jingzhangos@google.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 18 Apr 2023 19:18:50 -0700, Reiji Watanabe wrote:
> This series adds fixes that were missing in the patch [1].
> 
> The patch [1] added the mp_state_lock to serialize writes to
> kvm_vcpu_arch::{mp_state, reset_state}, and promoted all
> accessors of mp_state to {READ,WRITE}_ONCE() as readers do not
> acquire the mp_state_lock.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
      commit: 4ff910be01c0ca28c2ea8b354dd47a3a17524489
[2/2] KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update mp_state
      commit: a189884bdc9238aeba941c50f02e25eb584fafed

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


