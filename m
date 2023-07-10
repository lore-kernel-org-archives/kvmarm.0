Received: from out-33.mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAC214AAC
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:31:49 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689017507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UNLOmnW1r8G2/2p9clpHlK32Y5vvS5mr4qe8a9lLTk8=;
	b=tA+32iydUawTtv9UMOLvm5njmMW6FwDH1R+dqwK/f2Wi/Tyu9ikK2sBgVjeTmSSGpwYVtD
	TsKpjOwkkLmR9F6cN9txG5DC4+uUnuBwD1LoZab63OJ74KXlJ7R2nXRHOFDd7WrPisW7HE
	Sy/UpI+7F13QPRJ8P+gMh7K1uQsSZEA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 0/4] KVM: arm64: Use 'generic' vCPU target across all uarches
Date: Mon, 10 Jul 2023 19:31:36 +0000
Message-ID: <20230710193140.1706399-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

kvm_vcpu_init::target is quite useless at this point. We don't do any
uarch-specific emulation in the first place, and require userspace
select the 'generic' vCPU target on all but a few implementations.

Small series to (1) clean up usage of the target value in the kernel and
(2) switch to the 'generic' target on implementations that previously
had their own target values. The implementation-specific values are
still tolerated, though, to avoid UAPI breakage.

v1: https://lore.kernel.org/kvmarm/20230623194258.2648987-1-oliver.upton@linux.dev/

v1 -> v2:
 - Set the generic v8 target in the kvm_vcpu_init struct initializer
   (Marc)
 - Use the kvm_vcpu_initialized() helper (Zenghui)
 - Collect Zenghui's ack/reviews (Thanks!)

Oliver Upton (4):
  KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
  KVM: arm64: Remove pointless check for changed init target
  KVM: arm64: Replace vCPU target with a configuration flag
  KVM: arm64: Always return generic v8 as the preferred target

 arch/arm64/include/asm/kvm_host.h |  6 +++---
 arch/arm64/kvm/arm.c              | 24 +++++++++++-------------
 arch/arm64/kvm/guest.c            | 15 ---------------
 arch/arm64/kvm/hyp/nvhe/switch.c  |  2 +-
 arch/arm64/kvm/reset.c            | 25 ++++++++++---------------
 5 files changed, 25 insertions(+), 47 deletions(-)


base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0.255.g8b1d071c50-goog

