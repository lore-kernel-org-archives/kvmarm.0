Received: from out-61.mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E821078A
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 19:43:10 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687549388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sxyEKR2rizTfQsOMqfcASdxej9Cjkb/UvBfg4WJFTSI=;
	b=MomuY64NHKdaP/cekM7HsMpJzfYvPcABmij5wrzgT0BD5V4C/gQtt7Iy+RJmmz8SvvFKwe
	7kjKBO5FlS+iow8kzrBjlumNZukSRXaLMM+z2uVAG082bvUk7jb31sbdWGsFUs+Gv0s1m0
	zh1JFTtYaYQbmhP5Qr2lzSFCDDtZAfw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/4] KVM: arm64: Consistently use 'generic' vCPU target across all uarches
Date: Fri, 23 Jun 2023 19:42:54 +0000
Message-ID: <20230623194258.2648987-1-oliver.upton@linux.dev>
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

Oliver Upton (4):
  KVM: arm64: Delete pointless switch statement in kvm_reset_vcpu()
  KVM: arm64: Remove pointless check for changed init target
  KVM: arm64: Replace vCPU target with a configuration flag
  KVM: arm64: Always return generic v8 as the preferred target

 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/arm.c              | 18 ++++++++----------
 arch/arm64/kvm/guest.c            |  4 +---
 arch/arm64/kvm/hyp/nvhe/switch.c  |  2 +-
 arch/arm64/kvm/reset.c            | 25 ++++++++++---------------
 5 files changed, 23 insertions(+), 31 deletions(-)


base-commit: 192df2aa0113ddddee2a93e453ff46610807b425
-- 
2.41.0.178.g377b9f9a00-goog

