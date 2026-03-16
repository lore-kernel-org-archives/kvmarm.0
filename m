Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1204833B95A
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683703; cv=none; b=DSs2dX6dV/ThoM/uwmyzDO4WF7O8y6Y8Fs2AGxfQmTjDyAFWzuFpWUBMAGe0Khf8TqaQjFkVmI7BxNa+oR5e3MaKYlY9sX/oM2Ax92VAYtMFf6aJnxIgKsGN2izGshXkR4abar/DRQE7OzlSPqeVuImRBISK+kIC4AmA/XHs908=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683703; c=relaxed/simple;
	bh=2IOuOy3X9GXadM8aqgZpJLYp6WF7VrBo9c6JyQAJJ7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2Or0/+TLEC/3GdLhuF8XMFOCRPlSL89/Jpz3OmYvv8VHxRgen0OG55uQncxopw1hprkESl87qR72AqWBKtDR6xvzDsRoEPYHmkQ70u9QINaOZAhyE9mJ8+z4Q6scRY45Z+QL36ikRh+6LLqLin2jW03Ij1wJI6HECHev0XeHUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vCc7U1TV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vCc7U1TV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD636C19421;
	Mon, 16 Mar 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683702;
	bh=2IOuOy3X9GXadM8aqgZpJLYp6WF7VrBo9c6JyQAJJ7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCc7U1TVT+IGgrZwqPr27acGGDFH1v52590vkNa1DJRksIFFdMHuBTRdxOA32EDZJ
	 1xPBZbfb4PJrzULMb9/x6Xjs4PzocZjMHyjZiKlAqKgWzhW0Dsm6qaI7+d8jAi9ccj
	 hsD7g6uRoYR9yxQD2Pl66/D3Dql45KJFllBUK4cKe6pryRGJsQo3I6cZn8kR3F2KGY
	 RmmskeEOAO7/yz0axn2jVXj9dHYBZpWrdUOWK8GVn60bRPEZT2gwjgqwWJkNQnTmsE
	 rJuyI1t+Z+lVvwq4P65d3xdRLxPnNSMfI8JbyDkVRDXP/IGZ3Kfdp7lh8W4cmBvV55
	 BDvfXL2rNknKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9c-00000002XDx-3ew5;
	Mon, 16 Mar 2026 17:55:00 +0000
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
Subject: [PATCH 07/17] KVM: arm64: Kill exec_fault from kvm_s2_fault
Date: Mon, 16 Mar 2026 17:54:40 +0000
Message-ID: <20260316175451.1866175-8-maz@kernel.org>
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

Similarly to write_fault, exec_fault can be advantageously replaced
by the kvm_vcpu_trap_is_exec_fault() predicate where needed.

Another one bites the dust...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 86950acbd7e6b..11820e39ad8e1 100644
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

