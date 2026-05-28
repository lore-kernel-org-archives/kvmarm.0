Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D892E738D
	for <kvmarm@lists.linux.dev>; Thu, 28 May 2026 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779987303; cv=none; b=E32YPmsKlUl69l24WHiMgNVdhM20mgEhz7b89XqnaW72C9ZmYNh6FcLPFL0o6uAiBePF6MR8/WyX3DZohN+5QwxJRMUqP9sDKD9M514qkUtx6ZhsTb0fqdiXo01gQj2DVayUrtFS7vFRjPIgD2/5zpLpE+M0smVmGa7dQIqGimM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779987303; c=relaxed/simple;
	bh=gQVxDLObpHw6ZNtfscQf7cTegZZAwSB0BoSq1y5HiHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NZtw+O+4wZkrnbeLtq0CoRz69QPaxGMKSvs9MWqeMPMAQuiKx03N9fItzHaOG1FHwk71mPYBhF9irmdaSuwDx57m37j6mBpAHdvHiL6exp/pXthgivxzJy8NA3HTRf2+FC1PtAhMGSLOkS8ysZ/pflIGhuVy72D3oawqwZD5QgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=M3R8YGxY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="M3R8YGxY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AA1B22EE;
	Thu, 28 May 2026 09:54:56 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BBA343F905;
	Thu, 28 May 2026 09:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779987301; bh=gQVxDLObpHw6ZNtfscQf7cTegZZAwSB0BoSq1y5HiHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3R8YGxYvuGGoCRxXevIjF2GM53s9+rEgLSnHYZtwwG+lrZwXFAg75dZcyIS1BhAT
	 43M0rpD94OfSur05UvG7dRRFwu2xWt1LS9ttawTKZ9cax2Os8vNfr31Vmj80Zz0ltM
	 aKTUX1cLfE87qsnm+DhfcQPIIw+nF6+G1O55HY7Y=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	vladimir.murzin@arm.com,
	will@kernel.org
Subject: [PATCH v2 03/18] KVM: arm64: pkvm: Save host FPMR in host cpu context
Date: Thu, 28 May 2026 17:54:31 +0100
Message-Id: <20260528165446.701944-4-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260528165446.701944-1-mark.rutland@arm.com>
References: <20260528165446.701944-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Protected KVM stores most of the host's system register state in
kvm_host_data::host_ctxt, which is an instance of struct
kvm_cpu_context. As kvm_cpu_context::sys_regs[] has a slot for FPMR, we
can store the host's FPMR there.

Do so, and remove kvm_host_data::fpmr.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 3 ---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ++++--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 5 +++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 65eead8362e0b..42b1c4764a4bf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -775,9 +775,6 @@ struct kvm_host_data {
 	 */
 	struct cpu_sve_state *sve_state;
 
-	/* Used by pKVM only. */
-	u64	fpmr;
-
 	/* Ownership of the FP regs */
 	enum {
 		FP_STATE_FREE,
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 98b2976837b11..cc4d011a2b380 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -554,6 +554,8 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
+
 	/*
 	 * Non-protected kvm relies on the host restoring its sve state.
 	 * Protected kvm restores the host's sve state as not to reveal that
@@ -562,11 +564,11 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 	if (system_supports_sve()) {
 		__hyp_sve_save_host();
 	} else {
-		__fpsimd_save_state(host_data_ptr(host_ctxt.fp_regs));
+		__fpsimd_save_state(&hctxt->fp_regs);
 	}
 
 	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm)))
-		*host_data_ptr(fpmr) = read_sysreg_s(SYS_FPMR);
+		ctxt_sys_reg(hctxt, FPMR) = read_sysreg_s(SYS_FPMR);
 }
 
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 06db299c37a89..db60f770060e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -66,6 +66,7 @@ static void fpsimd_sve_flush(void)
 
 static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
 	bool has_fpmr;
 
 	if (!guest_owns_fp_regs())
@@ -89,10 +90,10 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
 	else
-		__fpsimd_restore_state(host_data_ptr(host_ctxt.fp_regs));
+		__fpsimd_restore_state(&hctxt->fp_regs);
 
 	if (has_fpmr)
-		write_sysreg_s(*host_data_ptr(fpmr), SYS_FPMR);
+		write_sysreg_s(ctxt_sys_reg(hctxt, FPMR), SYS_FPMR);
 
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 }
-- 
2.30.2

