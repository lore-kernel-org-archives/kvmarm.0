Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBC738F63F;
	Fri, 27 Mar 2026 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611389; cv=none; b=eidDlCG90jq/sVu82SWuSghQ3fitAsUEREvGLurB/qCzQKzclAspe7ePkhUfZw9C8QVzohFPtB/J0SUgLCWDfklulbkvfCUWHKZspxPp7MGrMrTc21VVIxDcdMYkAHH2UKBJW9QjP4WxofNVgcvliVKzkNjFeXLwqaJhss8+BoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611389; c=relaxed/simple;
	bh=pcTTqXh84ObMi4KJgCftkIiV8Pxu0ISQSHYAz2k5qWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wfc/YAsHvlQ+MtAEfBDLKbknKYx+pem6syjuESDyfWLMoxHjjG+wYKdys5sPw//uZ01NSq7Yj7EIXBrhuK6ZWP6c0VeV52aWg0cjC0bQvt7X7dPwb6qdIMuBwi+ALOPYFuwo1l0rTR/mjuBPRV1+GZq138KlkED6NC2duI45QQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hyk0+NtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hyk0+NtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADA5C2BCB4;
	Fri, 27 Mar 2026 11:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611388;
	bh=pcTTqXh84ObMi4KJgCftkIiV8Pxu0ISQSHYAz2k5qWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hyk0+NtPqOLQBCBqCXv5demBO7JBU8d55d9l+lfzA8ZouS9t+aCbouKq2Lgv5i8u9
	 dnbwOYiA5GPbmVpU24qEox8JCZNLNqLVZpL8Ay7D4hrYl/qY4IxYtKa9D+dpBhosKv
	 +Bx6iK7WPlVym+wPDwGTzwfN5kNweeTWbp/8M4vhQQKjEn185mR7G/hX4LDEe83Eif
	 AX38z/ehbtTaOzR0BO5kzphRaM5KWIHMBcvGbYSv4tgWpmapUy356LhMaUY7KwxOBP
	 u7/lmJIkC/BM4os/IrB4C3mBH1pGCszUfwIAXuIlrWaLSz6+xG5i+R4xuB4xsifh2H
	 deYTCGfCsJCgw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UI-00000006K4a-3yOs;
	Fri, 27 Mar 2026 11:36:27 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 20/30] KVM: arm64: Kill exec_fault from kvm_s2_fault
Date: Fri, 27 Mar 2026 11:36:08 +0000
Message-ID: <20260327113618.4051534-21-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Similarly to write_fault, exec_fault can be advantageously replaced
by the kvm_vcpu_trap_is_exec_fault() predicate where needed.

Another one bites the dust...

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7dab0c3faa5bf..e8bda71e862b2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1711,7 +1711,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 }
 
 struct kvm_s2_fault {
-	bool exec_fault;
 	bool writable;
 	bool topup_memcache;
 	bool mte_allowed;
@@ -1857,7 +1856,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		fault->writable = false;
 	}
 
-	if (fault->exec_fault && fault->s2_force_noncacheable)
+	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && fault->s2_force_noncacheable)
 		return -ENOEXEC;
 
 	/*
@@ -1877,7 +1876,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	if (fault->writable)
 		fault->prot |= KVM_PGTABLE_PROT_W;
 
-	if (fault->exec_fault)
+	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
 	if (fault->s2_force_noncacheable)
@@ -1984,7 +1983,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-		.exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
 		.topup_memcache = !perm_fault || (logging_active && kvm_is_write_fault(s2fd->vcpu)),
 	};
 	void *memcache;
-- 
2.47.3

