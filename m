Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076083DE42D
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773845009; cv=none; b=L2o29pvPorcTCWQ9tTwVC+Ry+61fzpTLD1haAKQOAtOdSHgZfj7+0wKqE1yURMGhJwK+JH6bVhMVvORd7g8IglihW8Br8pxZGrSTdiQlkAiohlS64exNTGADI6LHF6PxNMiqffTREZ2aSjPX/Wsy3d45CZ2ixwfzjwfhBs2AWMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773845009; c=relaxed/simple;
	bh=DbR+zohV4iQi/RXbRDYT6/mRRdP2EnN/6PpEIDt2Vds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oNBinRD863Lfqd4sTChxRW77VaXLCuTb0ERf2aiDRhpRbR+z2uRYu3+oRNAFvOcrIpy46N8XneoFwExfLNg3OSOgD7OhHT+aB4vAb2BvbUjkIQbXQYFkKkvSSTFod7YKzHtvijXWpOlYgrSRyRgcsO+FmqelufOUY9Ny6O8wVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bZkg58T9; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bZkg58T9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773845002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+aEDVNqb9xxPM5wo/zpqSuDIPCsG6efM35ChSAziaog=;
	b=bZkg58T9gxZLUS9ENazMqngeY9Fv3/bvzoFx7bf51D2TXlL8USBJT94QDac+cv9WEKXe0j
	bOo+MoYM5hK823uh8VZcpz+IZaJgJPXE2ujUT9e0bS6fLqiGuiFDmM9lMLHzI8zmuOMHen
	2bx57rLRl8h1V28/ePuldSwDyNyXeT0=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] KVM: arm64: Remove @arch from __load_stage2()
Date: Wed, 18 Mar 2026 22:43:05 +0800
Message-ID: <20260318144305.56831-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Since commit fe49fd940e22 ("KVM: arm64: Move VTCR_EL2 into struct s2_mmu"),
@arch is no longer required to obtain the per-kvm_s2_mmu vtcr and can be
removed from __load_stage2().

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 arch/arm64/include/asm/kvm_mmu.h              | 3 +--
 arch/arm64/kvm/at.c                           | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c              | 2 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                 | 4 ++--
 arch/arm64/kvm/hyp/vhe/switch.c               | 2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                  | 4 ++--
 8 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index d968aca0461a..c1e535e3d931 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -318,8 +318,7 @@ static __always_inline u64 kvm_get_vttbr(struct kvm_s2_mmu *mmu)
  * Must be called from hyp code running at EL2 with an updated VTTBR
  * and interrupts disabled.
  */
-static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu,
-					  struct kvm_arch *arch)
+static __always_inline void __load_stage2(struct kvm_s2_mmu *mmu)
 {
 	write_sysreg(mmu->vtcr, vtcr_el2);
 	write_sysreg(kvm_get_vttbr(mmu), vttbr_el2);
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index a024d9a770dc..3b61da0a24d8 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -1379,7 +1379,7 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 		}
 	}
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
-	__load_stage2(mmu, mmu->arch);
+	__load_stage2(mmu);
 
 skip_mmu_switch:
 	/* Temporarily switch back to guest context */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 5f9d56754e39..803961cdd39e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -63,7 +63,7 @@ int refill_memcache(struct kvm_hyp_memcache *mc, unsigned long min_pages,
 static __always_inline void __load_host_stage2(void)
 {
 	if (static_branch_likely(&kvm_protected_mode_initialized))
-		__load_stage2(&host_mmu.arch.mmu, &host_mmu.arch);
+		__load_stage2(&host_mmu.arch.mmu);
 	else
 		write_sysreg(0, vttbr_el2);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d815265bd374..87a169838481 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -336,7 +336,7 @@ int __pkvm_prot_finalize(void)
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 
 	write_sysreg_hcr(params->hcr_el2);
-	__load_stage2(&host_mmu.arch.mmu, &host_mmu.arch);
+	__load_stage2(&host_mmu.arch.mmu);
 
 	/*
 	 * Make sure to have an ISB before the TLB maintenance below but only
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 779089e42681..3938997e7963 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -299,7 +299,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	mmu = kern_hyp_va(vcpu->arch.hw_mmu);
-	__load_stage2(mmu, kern_hyp_va(mmu->arch));
+	__load_stage2(mmu);
 	__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 3dc1ce0d27fe..01226a5168d2 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -110,7 +110,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 	if (vcpu)
 		__load_host_stage2();
 	else
-		__load_stage2(mmu, kern_hyp_va(mmu->arch));
+		__load_stage2(mmu);
 
 	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
@@ -128,7 +128,7 @@ static void exit_vmid_context(struct tlb_inv_context *cxt)
 		return;
 
 	if (vcpu)
-		__load_stage2(mmu, kern_hyp_va(mmu->arch));
+		__load_stage2(mmu);
 	else
 		__load_host_stage2();
 
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9db3f11a4754..bc8090d915bf 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -219,7 +219,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
-	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
+	__load_stage2(vcpu->arch.hw_mmu);
 }
 
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 35855dadfb1b..539e44d09f17 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -60,7 +60,7 @@ static void enter_vmid_context(struct kvm_s2_mmu *mmu,
 	 * place before clearing TGE. __load_stage2() already
 	 * has an ISB in order to deal with this.
 	 */
-	__load_stage2(mmu, mmu->arch);
+	__load_stage2(mmu);
 	val = read_sysreg(hcr_el2);
 	val &= ~HCR_TGE;
 	write_sysreg_hcr(val);
@@ -78,7 +78,7 @@ static void exit_vmid_context(struct tlb_inv_context *cxt)
 
 	/* ... and the stage-2 MMU context that we switched away from */
 	if (cxt->mmu)
-		__load_stage2(cxt->mmu, cxt->mmu->arch);
+		__load_stage2(cxt->mmu);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		/* Restore the registers to what they were */
-- 
2.53.0

