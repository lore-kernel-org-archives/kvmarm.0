Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452DD3E8660
	for <kvmarm@lists.linux.dev>; Tue, 25 Aug 2026 08:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787648396; cv=none; b=kfjmV0+Fqgnh972dRFPN39V15IZ+/9ykwlh1ebrNccyfn8++4ozHTp3qAjnwP0qhCvJU6jbqqELmIXB9latFxrfYlwDe1lRL7GTwTAiRfC5i5j3g7clqD2yGJaQhr96q90yzjVyS49gG07hubOgb+RJzt8bTTtqOaAR/MN+cnhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787648396; c=relaxed/simple;
	bh=2E7hO/OQUbvmwGv3PtNaGFCsE2W2xbF14FNeWSPRc1g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=N+Hv6JTEeJSdOX98Jlt3qHKq7RB0z2V4ALa2MlLw4xCwHmEKv/xk3gQBBupt5YgwgCbFvXNOoo7gu70/jVO4LD7Mp3xzriBQQhKSyuhdCP0TyBVld0nmIuRtslyMf4CnNGv9bpMxP15/VpAngoQNFuQuRA1vfNn2DPVmmoLtp8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IkSVNXko; arc=none smtp.client-ip=95.215.58.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IkSVNXko"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=2E7hO/OQUbvmwGv3PtNaGFCsE2W2xbF14FNeWSPRc1g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787648393; v=1; x=1788253193;
 b=IkSVNXkoCnzZIkAmrHcMgOsjNeSXwo0DverNIoajUdF6WxXP3997nHcXAgbNBSm5f1qBO707
 sVUlssNyMpvrKJLqmPW00NpWE3ikzNoeZpEL7jAw/btAoP9zcumA/IKzprGxG6aSWg5JvSE2l0M
 0NqH+W35XJvxOOcjph0eZArc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.local (2a01:4b00:ad36:1d00:3a05:25ff:fe33:35a9)
	by smtp.migadu.com with ESMTPS id 0b983d3b0ddc8a86;
	Tue, 25 Aug 2026 08:59:53 +0000
X-Mizu-Trace-ID: 0b983d3b0ddc8a86
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Stefan Teodorescu <fane@google.com>,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: arm64: pKVM SVE vCPU init fixes
Date: Tue, 25 Aug 2026 09:59:44 +0100
Message-Id: <20260825085948.1674721-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

If it's not the GIC, it's SVE. I found these while preparing the
follow-up to the pKVM core series [1].

Patch 1 was posted on its own [2] and carries Marc's Reviewed-by. It is
unchanged and included here because it has not been picked up yet and
the rest of the series does not apply without it.

Patches 2 and 4 are two ways to reach the same broken state, a vCPU
whose sve_state is NULL while vcpu_has_sve() is true, so the world
switch loads the guest's SVE state from it. EL2 keeps two answers to
"does this guest have SVE": KVM_ARCH_FLAG_GUEST_HAS_SVE, which the
world switch reads, and KVM_ARM_VCPU_SVE, which pkvm_vcpu_init_sve()
reads. Patch 2 stops EL2 desynchronising them itself on an init
failure. Patch 4 stops the host handing them over already
desynchronised. Patch 3 keys the unpin on the state it unpins rather
than on the feature bit, which agree for any vCPU that completed init.

All of it needs a host that misreports its own vCPU state, so none of
it is reachable from host userspace.

Based on Linux 7.2, and applies cleanly to kvmarm/next.

Cheers,
/fuad

[1] https://lore.kernel.org/all/178552142335.30097.18179093757678605679.b4-ty@kernel.org/
[2] https://lore.kernel.org/all/20260818093117.2379344-1-fuad.tabba@linux.dev/

Fuad Tabba (4):
  KVM: arm64: Validate the SVE vector length in pkvm_vcpu_init_sve()
  KVM: arm64: Do not clear VM-wide SVE feature on vCPU init failure
  KVM: arm64: Key unpin_host_sve_state() on the state it unpins
  KVM: arm64: Derive GUEST_HAS_SVE from the SVE feature bit at EL2

 arch/arm64/kvm/hyp/nvhe/pkvm.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

-- 
2.39.5

