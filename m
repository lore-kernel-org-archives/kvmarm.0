Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7280C427FBC;
	Thu,  6 Aug 2026 09:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007438; cv=none; b=Hk6EaS8aSH1PEOHsm+oKALx10znYKAVPjcr800eB/WhzH97kLzOQCc2IkTWPjNerO3d9qzLB7kJ/HbYZ+gsTS++Ftm2s03YbbCQtqbqArtxxfsDxXvfrQKDrhgyjyQjQoXRDCwWZLYjj8yzJqJI7LRbwCxwCk+tDtKmfoHTRzP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007438; c=relaxed/simple;
	bh=VkBi/bBoDfLidiTa3A7lvSj7uqYh/LhRE2Y0776sTKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOX6EgA8EC3RusZtzEp66R6yclTWzh8nSd0SEek3XYQnV9wcSDFBuKy0DHHMrrv+5AmgHN2zdVOzdEwThxaFdA6KGdlWoRJ42mnICmDMbgIL26mskeT5j87LT5Emd4sNxfXYEhMhPx6KENCyS77qGR4i1ZCekYsBqEvRFX05jC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dH5bD15u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dH5bD15u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8587D1F00ACA;
	Thu,  6 Aug 2026 09:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786007435;
	bh=oluhvk34mwN8JfL3PicOQVmTFBPtGE5Qtz9UH1YHF5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dH5bD15uDevv5Q0uti9vOGh90m/WVROPuLcIo0xlyEChgSiyKG5Fm5djy+FzNwAvm
	 TkWYWILmkT2+mXq1r0jDUFVbIHhK4D72xcT5cLNgKt3k7hmcdv6ad/3loZhm9UZih5
	 XtE/Y/qVKqpHUz+ymR2ndCaDAkiOoBES0bq/bCyakBvZz5zdnAiXfyB2uf3H6Eh3bB
	 N1m4UCbdtvvakYECyUlHE4An+D0z2Q075RWX6wo3JyPZN5E4VQZ5U4VByNZwqELXGS
	 K7mIBkr+u6qotrLolNMKo6at+Ox2gyH4ymypLxI7nJxT3aJKwYBgdqeuwdfQSNoD5q
	 sJrqoBeNjG9/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wru7V-0000000CtHi-3GLl;
	Thu, 06 Aug 2026 09:10:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	ljs@kernel.org
Subject: [PATCH v2 8/8] KVM: arm64: Add VNCR TLB tracking again
Date: Thu,  6 Aug 2026 10:10:26 +0100
Message-ID: <20260806091026.620700-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260806091026.620700-1-maz@kernel.org>
References: <20260806091026.620700-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, imv4bel@gmail.com, yaoyuan@linux.alibaba.com, ljs@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Having established that our VNCR TLB tracking was flawed and having
dropped it from KVM, it is time to replace it with something that
actually works in order to get some performance back, as the TLBI
overhead is otherwise pretty high.

The goal of such tracking is to hit the TLBI slow path if there are
any VNCR TLBs in the guest, irrespective of their mapping state.

For this purpose, we introduce an VM wide counter (vncr_tlb_count)
that tracks how many valid VNCR TLB are present. This means that
creating such TLB must increment the counter, and invalidation
decrement it, and both these operations must be done with the MMU lock
held for write.

On TLBI handling affecting EL2 S1, a non-zero counter forces the
handling to take the slow path to consider the VNCR TLBs. Note that
the bumping up is done "speculatively" in order to make sure that a
concurrent invalidation will be taken on the slow path.

Not exactly rocket science. Hopefully I got it right this time.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/hyp/vhe/switch.c   | 11 +++++++---
 arch/arm64/kvm/nested.c           | 36 +++++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac16f96c878d6..108966a9db12b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -411,6 +411,9 @@ struct kvm_arch {
 	/* Masks for VNCR-backed and general EL2 sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
+	/* Count the number of VNCR_EL2 TLBs */
+	atomic_t vncr_tlb_count;
+
 	/*
 	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
 	 * the associated pKVM instance in the hypervisor.
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c09b1d411c584..fa776b18a32ca 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -424,10 +424,15 @@ static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 
 	/*
-	 * If we have to check for any VNCR mapping being invalidated,
-	 * go back to the slow path for further processing.
+	 * If we have to check for any VNCR TLB being invalidated, go back
+	 * to the slow path for further processing.
+	 *
+	 * The synchronisation betweem TLBI and walk is provided by the
+	 * speculative increment of the TLB counter on walk, and the
+	 * invalidation counter. Yes, this is fiddly.
 	 */
-	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu))
+	if (vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu) &&
+	    atomic_read(&vcpu->kvm->arch.vncr_tlb_count))
 		return false;
 
 	__kvm_skip_instr(vcpu);
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 550c9bd3dbe7d..20af94197a8a7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -48,6 +48,7 @@ void kvm_init_nested(struct kvm *kvm)
 {
 	kvm->arch.nested_mmus = NULL;
 	kvm->arch.nested_mmus_size = 0;
+	atomic_set(&kvm->arch.vncr_tlb_count, 0);
 }
 
 static int init_nested_s2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
@@ -1016,10 +1017,12 @@ u16 get_asid_by_regime(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	return asid;
 }
 
-static void invalidate_vncr(struct vncr_tlb *vt)
+static void invalidate_vncr(struct kvm *kvm, struct vncr_tlb *vt)
 {
+	BUG_ON(!vt->valid);
 	vt->valid = false;
 	unmap_l1_vncr(vt);
+	atomic_dec(&kvm->arch.vncr_tlb_count);
 }
 
 static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,
@@ -1066,7 +1069,7 @@ static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
 	 */
 	kvm_for_each_vncr_tlb(i, vcpu, vt, kvm)
 		if (vncr_tlb_intersects(vt, vt->wr.pa, start, end - start))
-			invalidate_vncr(vt);
+			invalidate_vncr(kvm, vt);
 }
 
 struct s1e2_tlbi_scope {
@@ -1123,7 +1126,7 @@ static void invalidate_vncr_va(struct kvm *kvm,
 			break;
 		}
 
-		invalidate_vncr(vt);
+		invalidate_vncr(kvm, vt);
 	}
 }
 
@@ -1359,13 +1362,20 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
  *   intersects with the TLBI request, invalidate it, and unmap the page
  *   from the fixmap. Because we need to look at all the vcpu-private TLBs,
  *   this requires some wide-ranging locking to ensure that nothing races
- *   against it. This may require some refcounting to avoid the search when
- *   no such TLB is present.
+ *   against it. This requires some refcounting to avoid the search when
+ *   no such TLB is present (see below).
  *
  * - On MMU notifiers, we must invalidate our TLB in a similar way, but
  *   looking at the IPA instead. The funny part is that there may not be a
  *   stage-2 mapping for this page if L1 hasn't accessed it using LD/ST
  *   instructions.
+ *
+ * - vncr_tlb_count tracks the number of valid VNCR TLBs VM-wide. This isn't
+ *   the number of *mapped* L1 VNCR pages, which is likely be a subset (and
+ *   by definition, a TLBI handled from L1 runs with the canonical VNCR
+ *   page, not the L1's). The innermost trap handling code checks this to
+ *   find out whether to return to the guest ASAP (no L1 TLBs) or to visit
+ *   this part of the world for some extra invalidation work.
  */
 
 int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
@@ -1420,7 +1430,8 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 	 */
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
 		this_cpu_reset_vncr_fixmap(vcpu);
-		vt->valid = false;
+		if (vt->valid)
+			invalidate_vncr(vcpu->kvm, vt);
 
 		vt->wi = (struct s1_walk_info) {
 			.regime	= TR_EL20,
@@ -1545,7 +1556,20 @@ int kvm_handle_vncr_abort(struct kvm_vcpu *vcpu)
 		return -EIO;
 	}
 
+	/*
+	 * Speculatively increment the TLB count to make sure concurrent
+	 * TLBIs will take the slow path, and will interact with the retry
+	 * mechanism. Drop it again on error.
+	 */
+	atomic_inc(&vcpu->kvm->arch.vncr_tlb_count);
+	smp_mb__after_atomic();
+
 	ret = kvm_translate_vncr(vcpu, &is_gmem);
+	if (ret) {
+		smp_mb__before_atomic();
+		atomic_dec(&vcpu->kvm->arch.vncr_tlb_count);
+	}
+
 	switch (ret) {
 	case -EAGAIN:
 		/* Let's try again... */
-- 
2.47.3

