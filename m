Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845AA388868
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780915493; cv=none; b=TXQ48VY6H4A5mj8yzEbNinQPwlVTNbvQBX4i7uN5Qz0AiBYcTuYc487E9qNjZdXocFEjgxJNrk930ufYCpibZAymiiLRSxC9a/UlIh/AlHPqmTjD0Eld6wH1aEaHZq7Up10o6g6JWYNWAGBmTbiB4/CTkbbzAZwaWbl07ffPAx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780915493; c=relaxed/simple;
	bh=cK2AElC/m1A4Wd8B2z5BpgPSrxgQ3DIYG331ZPkq9Ho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dDEinXV7WhE6LThcZz+vD86BU0qZ0dqmhNd3gdu8aLmAk7na4y5gwdMZoJuU/7jLtDpy1eSe1mFcdXwWDCLRB8HUWBCZLdL77A03kJs06WO5ZaDn9S4zoqDhh5kgTCiV8uZQDnaOOdZdIVJqzdaTDJezxM1gQxdRPZf9Pfodqys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gZWtRGpA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gZWtRGpA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF1073552;
	Mon,  8 Jun 2026 03:44:45 -0700 (PDT)
Received: from entos-yitian-01.Arm.com (unknown [10.168.196.244])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 458463F62B;
	Mon,  8 Jun 2026 03:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780915490; bh=cK2AElC/m1A4Wd8B2z5BpgPSrxgQ3DIYG331ZPkq9Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZWtRGpAylKlA4WY3MUfSBlG106Zcq/UOfLJu7bkXyTMQo+EwKv+V15Fpzt4jnpnS
	 5AUmbRDy5iMF1XTuRFYZEE4iZ0GHBqOvofdLMDncTO+E0swVHzV5JAzJy4UDBob869
	 nIqzGDQ41SfNYqHrcctM5fDvLXd9JT6nEDyRiuDg=
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH 1/1] KVM: arm64: Make kvm_s2_fault_pin_pfn() fault-in interruptible
Date: Mon,  8 Jun 2026 10:43:36 +0000
Message-Id: <20260608104336.2405384-2-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260608104336.2405384-1-justin.he@arm.com>
References: <20260608104336.2405384-1-justin.he@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

arm64 KVM faults guest memory into the host in kvm_s2_fault_pin_pfn() via
__kvm_faultin_pfn(). Today this request is made non-interruptible, so if
the host fault-in path blocks for a long time, a vCPU thread that already
has a pending signal cannot leave the fault-in path until GUP eventually
completes.

This is particularly painful during VM teardown, where userspace may
signal vCPU threads while they are blocked faulting in guest memory. In
that case there is no benefit in continuing to wait for the fault to
complete; the vCPU should return to userspace and let the pending signal
be handled.

Ask the generic KVM fault-in helper to use FOLL_INTERRUPTIBLE. When GUP
reports a pending signal it returns KVM_PFN_ERR_SIGPENDING; handle it by
calling kvm_handle_signal_exit() and returning -EINTR. This matches the
behaviour expected by the generic KVM fault-in path and mirrors the
signal-exit handling already done by the arm64 run loop, which sets
run->exit_reason = KVM_EXIT_INTR before returning to userspace. It is
also consistent with architectures such as x86 that already allow the
fault-in to be interrupted by pending signals.

The interrupted fault does not install a partial stage-2 mapping: the
-EINTR is returned before any mapping is created, so the fault is simply
retried on a subsequent vCPU entry once userspace re-enters KVM_RUN. The
only observable effect in the absence of a pending signal is none; this
does not make ordinary stage-2 faults abortable.

Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/mmu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4da9281312eb..dfb779e6d792 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1872,19 +1872,27 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 				struct kvm_s2_fault_vma_info *s2vi)
 {
 	int ret;
+	unsigned int flags = FOLL_INTERRUPTIBLE;
 
 	ret = kvm_s2_fault_get_vma_info(s2fd, s2vi);
 	if (ret)
 		return ret;
 
+	if (kvm_is_write_fault(s2fd->vcpu))
+		flags |= FOLL_WRITE;
+
 	s2vi->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
-				      kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
+				      flags,
 				      &s2vi->map_writable, &s2vi->page);
 	if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
 		if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
 			kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
 			return 0;
 		}
+		if (is_sigpending_pfn(s2vi->pfn)) {
+			kvm_handle_signal_exit(s2fd->vcpu);
+			return -EINTR;
+		}
 		return -EFAULT;
 	}
 
-- 
2.34.1

