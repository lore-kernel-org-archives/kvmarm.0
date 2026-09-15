Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6654C4F4D;
	Tue, 15 Sep 2026 16:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789488169; cv=none; b=eAWidO5vNjgIeNm4hd4furiYvMz00XyZ3vkpqhGjEsv4+rURsKyLTXXsOmvAV3G+liCIrK1QXp9+ONeP2S76QKUPvgzde/dOnwW2p62o8EkM5oPYWHicTCdj3rIYHb9WWvUHNp+/wUrtHIFrJXH7AaQjlbzaTOFUNZ7OKsOpEWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789488169; c=relaxed/simple;
	bh=CdQ3LU2C/wF8cnO0VzqHkPRgJxiUsivPTREctdi4DzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GtW5TjXeOU+65vIIojmulF0mAp/7NzKdvl9CZHGMheX7KU9qR1k68sxY2hRioaZ2PYDXzjwIkMrRaf6z5B7esBxIBBgw38waLNVVCw0XCjXaeYGHlWU/oKYFaU1QlsJjTjIa77/m1HLwUM9S1Qfg2tud+HLa6oEaE2IuZt6o1Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eE9sFgm/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eE9sFgm/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E7171570;
	Tue, 15 Sep 2026 09:02:43 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5EC183F882;
	Tue, 15 Sep 2026 09:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789488167; bh=CdQ3LU2C/wF8cnO0VzqHkPRgJxiUsivPTREctdi4DzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE9sFgm/9L4mffffTTMC8gBmxw71DbR2kDVTJKfwh7EENeaXUz+dYvUUEb20Luu5X
	 yrpqVtxXU81Xw8+0FtB3uaoRB4YHKw4K1fQaCdwlWJqnhUDYsbOlNTTMVJ+B/4yVJo
	 joV8DrrTQScwI5OjXpRq6VTQD8oKirbUkFGYqIXE=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v18 18/23] KVM: arm64: CCA: Mandate VGIC_V3 for Realms
Date: Tue, 15 Sep 2026 17:01:36 +0100
Message-ID: <20260915160141.3543048-19-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915160141.3543048-1-suzuki.poulose@arm.com>
References: <20260915160141.3543048-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM mandates that we use a VGIC v3 for a Realm and nothing else is supported.
Mandate this in KVM.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 4012df6002ea6..452c085073f3e 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -84,6 +84,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		!kvm_vgic_global_state.can_emulate_gicv2)
 		return -ENODEV;
 
+	/* Realms only support VGIC_V3 */
+	if (kvm_vm_is_realm(kvm) && type != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return -ENODEV;
 	/*
 	 * Ensure mutual exclusion with vCPU creation and any vCPU ioctls by:
 	 *
-- 
2.43.0

