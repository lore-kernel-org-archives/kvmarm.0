Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777163AE185
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780444497; cv=none; b=pWIfOC+fO89nnIhzHTlU+VMokBrdr/2hcWq2Z6tnCN4KMaHMvtDfmi/5Wyqc3iQ9U0QhzTQ5Oo9kRdOmEidYiYU7AtSF+zcGnHaAlRfXdYYpixA2blPyxudlmVc/E+onOehLLI+qaoV58UVS21sZo17XXkIYirsdySa1GW3MBI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780444497; c=relaxed/simple;
	bh=Ev2wgkOp+d65vtJEauuHxr7519CqUnUHYmZ6V7ZDKCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7w30UuXRH5z5pIBBVP+pveoSP/yeWf82STztWq4LEr9c8fYZMJegykiPhJ5kL+amqv1qYsbsjzG+4Qnc6+wC3MnFvuQVdMrtsrKWYSwuDdb0Tbs3wqeW8RG0FokYlU90RyPZEY+xI1VlpbpHYU1PjWSgzgCyGIni4myx4JbQug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuPQnEmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuPQnEmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D261F0089B;
	Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780444496;
	bh=mzkHNK8VPO3bswiJ91DRj7f/rcKMecQQ+8RH8xnlRo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuPQnEmqbEwWqMPBBeAlAZ98pAgbcI3LqH/o0eW2+dEt39j7S5IKpIzaxO9+/6AiQ
	 3/+ah7aF4oO29SmFZeEwmdKi50NKgmStTn61Q+V59pFTQnOlB2DC12MqmYp411TkJj
	 UBB/tkX0A19jWQG3UKRI0pnxNi2cMoI46m94gkE7/0VGDGvuoCeTBnBDAxXO4B52S9
	 JMEGfK1OLMlolihO9zJ8Bo82VzIh4euZSlswwIyL3TYLYaE1o5y3JwWrxMsoDB3ZRN
	 4sBeAFVR/HtJZR6U8q6PLkg8f8GSt9Wz2stWFzser63v3Cn21W04B1OvgFu+FYFnWU
	 8VZT8dU0OHxEQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 2/5] KVM: arm64: nv: Fully update VNCR fixmap state in kvm_translate_vncr()
Date: Tue,  2 Jun 2026 16:54:47 -0700
Message-ID: <20260602235450.103057-3-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260602235450.103057-1-oupton@kernel.org>
References: <20260602235450.103057-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_translate_vncr() first invalidates the pseudo-TLB entry and
corresponding fixmap in anticipation of installing a new translation.

While the fixmap invalidation does clear the mapping from host stage-1,
it does not clear the L1_VNCR_MAPPED flag. Depending on the state of the
VNCR TLB at vcpu_put(), this could potentially precipitate a BUG_ON() if
vt->cpu is reset.

Share a helper with kvm_vcpu_put_hw_mmu(), ensuring that KVM's view of
the VNCR fixmap is in sync with the state of the VNCR TLB. Give it a
slightly verbose name to make it obvious that it is meant to be used
local to a CPU, unlike other VNCR TLB maintenance.

Fixes: 069a05e535496 ("KVM: arm64: nv: Handle VNCR_EL2-triggered faults")
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 4fa82e96454d..d0545144eaac 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -797,18 +797,24 @@ void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void this_cpu_reset_vncr_fixmap(struct kvm_vcpu *vcpu)
+{
+	if (!host_data_test_flag(L1_VNCR_MAPPED))
+		return;
+
+	BUG_ON(vcpu->arch.vncr_tlb->cpu != smp_processor_id());
+	BUG_ON(is_hyp_ctxt(vcpu));
+
+	clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
+	vcpu->arch.vncr_tlb->cpu = -1;
+	host_data_clear_flag(L1_VNCR_MAPPED);
+	atomic_dec(&vcpu->kvm->arch.vncr_map_count);
+}
+
 void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu)
 {
 	/* Unconditionally drop the VNCR mapping if we have one */
-	if (host_data_test_flag(L1_VNCR_MAPPED)) {
-		BUG_ON(vcpu->arch.vncr_tlb->cpu != smp_processor_id());
-		BUG_ON(is_hyp_ctxt(vcpu));
-
-		clear_fixmap(vncr_fixmap(vcpu->arch.vncr_tlb->cpu));
-		vcpu->arch.vncr_tlb->cpu = -1;
-		host_data_clear_flag(L1_VNCR_MAPPED);
-		atomic_dec(&vcpu->kvm->arch.vncr_map_count);
-	}
+	this_cpu_reset_vncr_fixmap(vcpu);
 
 	/*
 	 * Keep a reference on the associated stage-2 MMU if the vCPU is
@@ -1282,7 +1288,8 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 	 * We also prepare the next walk wilst we're at it.
 	 */
 	scoped_guard(write_lock, &vcpu->kvm->mmu_lock) {
-		invalidate_vncr(vt);
+		this_cpu_reset_vncr_fixmap(vcpu);
+		vt->valid = false;
 
 		vt->wi = (struct s1_walk_info) {
 			.regime	= TR_EL20,
-- 
2.47.3

