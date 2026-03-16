Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6CC33B6F8
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683703; cv=none; b=PaMQKi+7UX4ND7ut79d33fz+mAac5eoUaw8TykmXyULzej02/LBTJUvuZ3AzxRzSMQu9GPxKSF2r6QlOd2WHSotm2OFxr6kMVg4l2LKY4ApXuMCHiS6yMFiTGb6/hv1ZMqkvvPJq/UAKTAZhFKAzVuavyZyF5fjoPSMhOiJ3wKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683703; c=relaxed/simple;
	bh=mi4o7VJwjJ7mCXjGkRr0+qnth9Sye75ortbEYQO/k/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6bI5B/9gGlfrF5Cy3iniV+siiwaHI0jPDJx4AZr2LvaLHpcZMnkyqr9awb2ocxB4+FHgZgd6+48ohAxAgiOjSYi2hVXKCGHlGaJdBIC1Fwyo4amuw0RmejPRnLMbxC4cCNyD7qoEmBvrv8okbU4p2KmoxMwH7fPNwmpzHaJc34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=as0uQIop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="as0uQIop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17ADC4AF09;
	Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683702;
	bh=mi4o7VJwjJ7mCXjGkRr0+qnth9Sye75ortbEYQO/k/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=as0uQIopz2uqNw2ogQDOhJhgE9uDwUL17b8/+VRB6h3Kr7qDL5gjhtEFtRugyBx0l
	 w043z5d79Uri6ia+iOtZ3XwNYns43ClBGFU9JYxIImEFMKuIrSzcSi3hPq6IGo5kna
	 0zLXi4zVlitLQtjlXgTYKAKnmzKoYgjAr+BHzAlOvfEfB+ee6GuUE2zVrCD/78bkMX
	 n2Lx9HJW3XrfOR/ErUMu90FfgV+FPerOEyd0oqWRrO+xwqywKLPGXoqcSdb+4zdeRF
	 8Lts5w4S31ya1+4jUOrpmFfM4AxyiMLLllmvDslfy777rF/vKHojM7RHro420n8gZ2
	 kX2d4dPnTlyew==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9d-00000002XDx-0OnR;
	Mon, 16 Mar 2026 17:55:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 08/17] KVM: arm64: Kill topup_memcache from kvm_s2_fault
Date: Mon, 16 Mar 2026 17:54:41 +0000
Message-ID: <20260316175451.1866175-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316175451.1866175-1-maz@kernel.org>
References: <20260316175451.1866175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The topup_memcache field can be easily replaced by the equivalent
conditions, and the resulting code is not much worse.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 11820e39ad8e1..abe239752c696 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1712,7 +1712,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 
 struct kvm_s2_fault {
 	bool writable;
-	bool topup_memcache;
 	bool mte_allowed;
 	bool is_vma_cacheable;
 	bool s2_force_noncacheable;
@@ -1983,7 +1982,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-		.topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
 	};
 	void *memcache;
 	int ret;
@@ -1994,9 +1992,11 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	ret = prepare_mmu_memcache(s2fd->vcpu, fault.topup_memcache, &memcache);
-	if (ret)
-		return ret;
+	if (!perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu))) {
+		ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
-- 
2.47.3

