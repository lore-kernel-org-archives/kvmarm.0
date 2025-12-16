Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45E89326957
	for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765881084; cv=none; b=oIc5LvsF56zmqmhdu4kFyGlA4B6xExun5tq5rhY/hXDPYIAoRcU6oepteXx7Fm3ynUEkUAT6x/Jevb4mhbjkivRl17NEdaylOsh8pVa+97CRPzgWG1y071m5t/lpvrfz8y5IGFtgWGlRpntWS3B5xuYcub8n55V6zmpgkLhbcCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765881084; c=relaxed/simple;
	bh=sdSxczjOGhx4okjh05n9Q8K8W3gtQexG+cbaea16BAg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JONBVgeFZHHdQmGCQCEIAkSePQH9XNGWp6s7OvE4uVZ6Ei3uz+MmgC1PUiGsAm+V6ndl5Nu98u2yLOVMEjXA7Is8VPonSngDbn2bgbvgX1eE95suYrnP3j61hfUMc2HTjHEY3q0cCV4GU4a/ntRyuQ8de1rT54PK0/DGAqD1UIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16CAC153B;
	Tue, 16 Dec 2025 02:31:14 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B2B83F694;
	Tue, 16 Dec 2025 02:31:19 -0800 (PST)
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
Subject: [PATCH v3 2/4] KVM: arm64: Inject UNDEF for a register trap without accessor
Date: Tue, 16 Dec 2025 10:30:51 +0000
Message-ID: <20251216103053.47224-3-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216103053.47224-1-alexandru.elisei@arm.com>
References: <20251216103053.47224-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Configuring a register trap without specifying an accessor function is
abviously a bug. Instead of calling die() when that happens, let's be a
bit more helpful and print the register encoding. Also inject an
undefined instruction exception in the guest, similar to other unhandled
register accesses.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c8fd7c6a12a1..88a57ca36d96 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4668,7 +4668,10 @@ static void perform_access(struct kvm_vcpu *vcpu,
 	 * that we don't know how to handle. This certainly qualifies
 	 * as a gross bug that should be fixed right away.
 	 */
-	BUG_ON(!r->access);
+	if (!r->access) {
+		bad_trap(vcpu, params, r, "register access");
+		return;
+	}
 
 	/* Skip instruction if instructed so */
 	if (likely(r->access(vcpu, params, r)))
-- 
2.52.0

