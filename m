Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C9E332EB6
	for <kvmarm@lists.linux.dev>; Mon, 15 Dec 2025 11:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765799071; cv=none; b=VsY08q09hDMBZCXWqSQv9MXZl1c6zlA2271b5QwFATMjwmUsnNePh23y+Eytgh2ATAM2GTTHNgr4i2+RQ/BG+v+R8ToOIoVzeLOoyYHcuqebbRyBb7tronL2c1qRHzPaszsa3JVNNZavH/fAOnMBx+V8ZBBVccgmeV5MmHKErGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765799071; c=relaxed/simple;
	bh=eUHGAT7cQUq1q1o0lLwaUhh5uy/KzUlSO7mhrEIkk5M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQacmrnJpIwwUShvjC2J2pMXqczVRrUVtkA3U9a4O5AsQizIyQyQ0BjrjVuOZKVvcsaTuFaG6VBAVjlPPWDxqHD/FMx6AecfR/RnyyArVUJmg+lVw58FrIbUVA9RhwXzxH60q9Jai1lfvJeO3QOoY5CGYQkZ2toA+CmYlZkR2a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9803B1655;
	Mon, 15 Dec 2025 03:44:21 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E60133F73B;
	Mon, 15 Dec 2025 03:44:26 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	will@kernel.org,
	tabba@google.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 2/4] KVM: arm64: Print register encoding if there's no accessor
Date: Mon, 15 Dec 2025 11:44:07 +0000
Message-ID: <20251215114409.212512-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215114409.212512-1-alexandru.elisei@arm.com>
References: <20251215114409.212512-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Configuring a register trap without specifying an accessor function is
abviously a bug. Instead of calling die() when that happens, let's be a bit
more helpful and print the register encoding and kill the virtual machine
instead.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a1..d669f6fef177 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4668,7 +4668,13 @@ static void perform_access(struct kvm_vcpu *vcpu,
 	 * that we don't know how to handle. This certainly qualifies
 	 * as a gross bug that should be fixed right away.
 	 */
-	BUG_ON(!r->access);
+	if (!r->access) {
+		KVM_BUG(1, vcpu->kvm,
+			"Unexpected access to register: { Op0(%2u), Op1(%2u), CRn(%2u), CRm(%2u), Op2(%2u) } (%s)",
+			params->Op0, params->Op1, params->CRn, params->CRm, params->Op2,
+			str_write_read(params->is_write));
+		return;
+	}
 
 	/* Skip instruction if instructed so */
 	if (likely(r->access(vcpu, params, r)))
-- 
2.52.0

