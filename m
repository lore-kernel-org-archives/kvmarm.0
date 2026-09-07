Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51948412C08
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764509; cv=none; b=Jxk5w6aSyCWP5W+1VkNsyBIsWMg3t/5iR3GQ8TEt1uAWc3ZcUwAlHqrP4WHXLf2OfZqTgWS6GSQ97XxuuodXF0xU292jUYxhfo8VfBD6X8qAhmEC9VvUwhVK0kLGX03nrq/Bse6WSzrtHeJDHDgRSWbcg364Xs60jPCBL1jPJAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764509; c=relaxed/simple;
	bh=K+Cw1Rhs/pIXecXIjGAEGbyJhwCxhPQM371NHFscWfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I1ccZJIN9+SxooBQ4Sf8SbvWWoRZgy1KlVPKfXSFVFT687UaEf8Un+FjiHfwoJ8TwZfAe6mVHdEGhHp5syKo5tgWVe8vUGqvskNGquxWkJgUYeVhIy99RL95i0cLOmoTbf1ysdqo4i0IsO91NhnMt3rWpNfFNqow4SNdPlIN3hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=p8fNQnYu; arc=none smtp.client-ip=91.218.175.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p8fNQnYu"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=K+Cw1Rhs/pIXecXIjGAEGbyJhwCxhPQM371NHFscWfw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764502; v=1; x=1789369302;
 b=p8fNQnYuVsFPhdAhPxr5iNDsAmcuAMoCKemaon+6vgdDeWzMd3SgfbLHHsReo1SazQqmPFUQ
 G6XsECqPrraRiSH+Ev8xUFHy6VOLDQKqyKiNvee3gKb8rAj9gBLGnabzf3t75eh0xftsbSURpzd
 a3tahqUpAkalCaOFzIan1hyA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d6bcb7f9e1bd0ff6;
	Mon, 07 Sep 2026 07:01:42 +0000
X-Mizu-Trace-ID: d6bcb7f9e1bd0ff6
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 14/17] KVM: arm64: Reject host access to protected VM private state
Date: Mon,  7 Sep 2026 07:59:59 +0100
Message-Id: <20260907070002.3333525-15-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A protected vCPU's register and debug state is no longer exposed to
the host. Host ioctls that would reach that state now fail rather
than operate on a copy that is not the guest's:

  - KVM_GET_ONE_REG and KVM_SET_ONE_REG return -EPERM once the vCPU has
    run: the copy then holds reset values plus what the exit handlers
    marshal out. Pre-run access still builds the guest's boot state.
  - KVM_ARM_VCPU_INIT returns -EPERM once the vCPU has run: it would
    reset the host copy alone and rewrite mp_state, which EL2 reads
    only at hyp vCPU creation, so a vCPU the guest powered off would
    come back RUNNABLE.
  - KVM_SET_VCPU_EVENTS rejects external-abort injection with -EPERM;
    SError injection is forwarded and stays permitted.
  - KVM_SET_GUEST_DEBUG returns -EPERM: a protected guest's debug state
    is hypervisor-owned.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/arm.c   |  7 +++++++
 arch/arm64/kvm/guest.c | 19 +++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5c2587da815ab..37a260b139795 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1750,6 +1750,13 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	bool power_off = false;
 	int ret;
 
+	/*
+	 * Re-init would reset the host copy alone and rewrite mp_state
+	 * after EL2 has read it. Pre-run init stays allowed.
+	 */
+	if (vcpu_is_protected(vcpu) && vcpu_has_run_once(vcpu))
+		return -EPERM;
+
 	/*
 	 * Treat the power-off vCPU feature as ephemeral. Clear the bit to avoid
 	 * reflecting it in the finalized feature set, thus limiting its scope
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index ab659795d4b2f..abab580a659d4 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -701,6 +701,10 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 
 int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	/* Once the vCPU has run, the host copy is not the guest's state. */
+	if (vcpu_is_protected(vcpu) && vcpu_has_run_once(vcpu))
+		return -EPERM;
+
 	/* We currently use nothing arch-specific in upper 32 bits */
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
 		return -EINVAL;
@@ -718,6 +722,10 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
+	/* Writes build the boot state; once run, EL2 owns the registers. */
+	if (vcpu_is_protected(vcpu) && vcpu_has_run_once(vcpu))
+		return -EPERM;
+
 	/* We currently use nothing arch-specific in upper 32 bits */
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
 		return -EINVAL;
@@ -786,6 +794,13 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	u64 esr = events->exception.serror_esr;
 	int ret = 0;
 
+	/*
+	 * EL2 injects an external abort only to complete a forwarded abort.
+	 * SError injection is forwarded.
+	 */
+	if (vcpu_is_protected(vcpu) && ext_dabt_pending)
+		return -EPERM;
+
 	/*
 	 * Immediately commit the pending SEA to the vCPU's architectural
 	 * state which is necessary since we do not return a pending SEA
@@ -883,6 +898,10 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 {
 	trace_kvm_set_guest_debug(vcpu, dbg->control);
 
+	/* A protected guest's debug state is not exposed to the host. */
+	if (vcpu_is_protected(vcpu))
+		return -EPERM;
+
 	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
 		return -EINVAL;
 
-- 
2.39.5

