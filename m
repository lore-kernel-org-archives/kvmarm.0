Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D233F36165E
	for <kvmarm@lists.linux.dev>; Sun, 26 Jul 2026 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785076615; cv=none; b=Pkv7KfG/RUmoMviURkPQjmbDOapbKxXvBWXU/vvUG1Q4S53SwoH4teiol5U5GJU4yr/uUU0UlHohgyqO/FSi1tXRLySmCd1/0/353JCJyHTqInby/W3qqYKjwdOh75dqDS6FSTPDxhRfvar6YPuBMxej8m5LDyelkhpXciEk+1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785076615; c=relaxed/simple;
	bh=+16vHCkspflW/8xOwHcmOcINEccvZZ5aAjfFMVK3suo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HOodKvb91pcHObZujiNhSKWOhjcBAeVssTwbJv/s5/GDLnibaUfXf3Fx7bAkLsWbGelbnIwq4ROT31Pl2LuwDwgIULC9gjrHDr9ariLIrrwCewC2NY8NR9WEgSth8vxEok5l3FcWJ8208mOXMPCaDt/1pRewKZjYfgaovXYbwHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mm+iU81y; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mm+iU81y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785076611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Txs9DV0oGu7TMtbUDZqDz+8dQ7HwLvd721pG0OMdow=;
	b=mm+iU81yoKpcrY+JyzumBbqktAVlUrC0xGPhsIujUHCotEjaLhECnX2q47HzOLpKAB7b6m
	3JDDDbj0T5vt+mCuC5PFv79SihSfVARRhmDQItVmBPkQK0TXC7rhkbgOUrk29eKCSbz2ra
	Cfj8amWxpTbSOTWUx+CwAylRNjupnck=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	tabba@google.com
Subject: [PATCH 1/2] KVM: arm64: Flush external_mdscr_el1 to the pKVM hyp vCPU
Date: Sun, 26 Jul 2026 15:36:42 +0100
Message-Id: <20260726143643.303456-2-fuad.tabba@linux.dev>
In-Reply-To: <20260726143643.303456-1-fuad.tabba@linux.dev>
References: <20260726143643.303456-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

flush_debug_state() propagates the guest's debug_owner and the
owner-selected debug register state to the hyp vCPU, but not
external_mdscr_el1. While the host owns the debug registers, the world
switch loads MDSCR_EL1 from external_mdscr_el1 (ctxt_mdscr_el1()),
where the host's KDE/MDE/SS bits live. A non-protected guest under
KVM_GUESTDBG_USE_HW or single-step therefore runs with MDSCR_EL1.MDE/SS
clear in hardware, and its watchpoints, breakpoints and single-step
never fire.

Propagate external_mdscr_el1 to the hyp vCPU alongside the host-owned
debug state.

Fixes: 4ad3a0b87f2ec ("KVM: arm64: Don't hijack guest context MDSCR_EL1")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3c69de698f48..104026ee70e80 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -108,10 +108,16 @@ static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.debug_owner = host_vcpu->arch.debug_owner;
 
-	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu))
+	if (kvm_guest_owns_debug_regs(&hyp_vcpu->vcpu)) {
 		hyp_vcpu->vcpu.arch.vcpu_debug_state = host_vcpu->arch.vcpu_debug_state;
-	else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu))
+	} else if (kvm_host_owns_debug_regs(&hyp_vcpu->vcpu)) {
 		hyp_vcpu->vcpu.arch.external_debug_state = host_vcpu->arch.external_debug_state;
+		/*
+		 * The world switch loads MDSCR_EL1 from external_mdscr_el1
+		 * (ctxt_mdscr_el1()).
+		 */
+		hyp_vcpu->vcpu.arch.external_mdscr_el1 = host_vcpu->arch.external_mdscr_el1;
+	}
 }
 
 static void sync_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
-- 
2.39.5

