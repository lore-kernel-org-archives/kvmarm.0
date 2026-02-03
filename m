Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53A536A037
	for <kvmarm@lists.linux.dev>; Tue,  3 Feb 2026 21:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770155053; cv=none; b=akLALQwvhdunn2xhlc9rSM6bBb3bHpJz6t+DzeRClywchnpHbJ5OpzcxUM2lKEnxpaJRm5yajzM9QYmkE7x4e3OrBz2W7Y67CNF/A9BCH4MkRrKNc2w+sp+VtNh4nf21DfVEwWe3QMrJGZ0+5IjbCbD/+TgFmTOI3A7YM3lGvSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770155053; c=relaxed/simple;
	bh=9VbKN501nV2Cxua5/LFfT9sXwfqzSJS592dCfuMZjdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvRgX9r7pHT6AQ3JuZ7ppwsktJgW5ecttSAvcbohumBwBQLyxDQ6tqxsXFDRkZtk74kx4upHHHB5HcdOQ0Ghc3fhqGCKirBfQcdD2AINgvKo3v+r/xQ5Ba2tVq9hcSqJjK0yRauP0pj5ZPOyU49sP9u/PmZBJnN6uB5mOQX7xjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D94DE1063;
	Tue,  3 Feb 2026 13:44:04 -0800 (PST)
Received: from e134344.cambridge.arm.com (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AE6743F778;
	Tue,  3 Feb 2026 13:44:05 -0800 (PST)
From: Ben Horgan <ben.horgan@arm.com>
To: ben.horgan@arm.com
Cc: amitsinght@marvell.com,
	baisheng.gao@unisoc.com,
	baolin.wang@linux.alibaba.com,
	carl@os.amperecomputing.com,
	dave.martin@arm.com,
	david@kernel.org,
	dfustini@baylibre.com,
	fenghuay@nvidia.com,
	gshan@redhat.com,
	james.morse@arm.com,
	jonathan.cameron@huawei.com,
	kobak@nvidia.com,
	lcherian@marvell.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	peternewman@google.com,
	punit.agrawal@oss.qualcomm.com,
	quic_jiles@quicinc.com,
	reinette.chatre@intel.com,
	rohit.mathew@arm.com,
	scott@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	tan.shaopeng@fujitsu.com,
	xhao@linux.alibaba.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev,
	zengheng4@huawei.com,
	linux-doc@vger.kernel.org,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: [PATCH v4 02/41] KVM: arm64: Preserve host MPAM configuration when changing traps
Date: Tue,  3 Feb 2026 21:43:03 +0000
Message-ID: <20260203214342.584712-3-ben.horgan@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260203214342.584712-1-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When kvm enables or disables MPAM traps to EL2 it clears all other bits in
MPAM2_EL2.  Notably, it clears the partition ids (PARTIDs) and performance
monitoring groups (PMGs). Avoid changing these bits in anticipation of
adding support for MPAM in the kernel. Otherwise, on a VHE system with the
host running at EL2 where MPAM2_EL2 and MPAM1_EL1 access the same register,
any attempt to use MPAM to monitor or partition resources for kernel space
would be foiled by running a KVM guest. Additionally, MPAM2_EL2.EnMPAMSM is
always set to 0 which causes MPAMSM_EL1 to always trap. Keep EnMPAMSM set
to 1 when not in a guest so that the kernel can use MPAMSM_EL1.

Tested-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Tested-by: Peter Newman <peternewman@google.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c5d5e5b86eaf..63195275a8b8 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -269,7 +269,8 @@ static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 {
-	u64 r = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
+	u64 clr = MPAM2_EL2_EnMPAMSM;
+	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
 
 	if (!system_supports_mpam())
 		return;
@@ -279,18 +280,21 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
 	} else {
 		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
-		r |= MPAM2_EL2_TIDR;
+		set |= MPAM2_EL2_TIDR;
 	}
 
-	write_sysreg_s(r, SYS_MPAM2_EL2);
+	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
 }
 
 static inline void __deactivate_traps_mpam(void)
 {
+	u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
+	u64 set = MPAM2_EL2_EnMPAMSM;
+
 	if (!system_supports_mpam())
 		return;
 
-	write_sysreg_s(0, SYS_MPAM2_EL2);
+	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
 
 	if (system_supports_mpam_hcr())
 		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
-- 
2.43.0

