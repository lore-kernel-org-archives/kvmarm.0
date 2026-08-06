Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5F73D5229
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 10:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786010633; cv=none; b=MLZRMyGrdrhM+pa8LpOVJGIK8caL4nl33DIzMLBTvL3wK5+y3KZXgWTSnxGkwX/deplyoZaJuBFv4Re8V37RhQvTrT0lHH7YUtOGHCHtkzVKmWQdHvG6/p/m8Ge67dW1PW2G5P6MjCtiNUACylW7tMN/DGt9ysJ6oqLy1gaclAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786010633; c=relaxed/simple;
	bh=KYoGU+OGRT1b3u/3rPF3W7y1lsPkKfvdYF3xaIRH2LE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nbfy+i1Wa461evYDnAk8FCuhj3nCcvWcdIos0ckzNpf4aL+jQG7ZHUz2QepjjHxSr1QaAlFork6W59jTnK5+rE9aV1IjNphoCq0pG9sOCDoC8JsM0CMv59wUE6CFvUlcYBDFPRvo0eX0S8pq2mvnnNSetAbGR4xUBZ6dO8jsIpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ty5O7BPe; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ty5O7BPe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786010627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MWi0NI9m0cyCHv/YKcE74ooCGwGwg2XY1zvoMF0Rkgs=;
	b=Ty5O7BPeeLVaIMGJXZp3xJGEA2mnwh1wjVXmlLzlgjj2LEBj8CpEOEdsgWEGQA42Cgf4sj
	CT531aboWPk63SaGlPDGkRBcWRek2DwgQE1mx1KHu32gBQF1Ay1QCy7IQY8+IAS0jTIKPR
	yOGYyINxpEkeLq1fsQqSfGFc7snBLZ0=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v1 1/4] KVM: arm64: Validate the host-provided vgic model in pKVM
Date: Thu,  6 Aug 2026 11:02:53 +0100
Message-Id: <20260806100256.371164-2-fuad.tabba@linux.dev>
In-Reply-To: <20260806100256.371164-1-fuad.tabba@linux.dev>
References: <20260806100256.371164-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

EL2 copies vgic_model from the host's struct kvm unchecked, and the nVHE
world switch dispatches on it with no cpucap guard. A host writing
KVM_DEV_TYPE_ARM_VGIC_V5 makes EL2 access GICv5 CPU interface registers,
which are UNDEFINED without FEAT_GCIE and panic the hypervisor on any
GICv3 machine.

Accept only the models pKVM can run, forcing anything else to 0.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 24d6f164129ac..59bb15efdca42 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -340,13 +340,25 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 {
 	struct kvm *kvm = &hyp_vm->kvm;
 	unsigned long host_arch_flags = READ_ONCE(host_kvm->arch.flags);
+	u32 vgic_model = READ_ONCE(host_kvm->arch.vgic.vgic_model);
 	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
 
 	/* CTR_EL0 is always under host control, even for protected VMs. */
 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
 
-	/* Preserve the vgic model so that GICv3 emulation works */
-	hyp_vm->kvm.arch.vgic.vgic_model = host_kvm->arch.vgic.vgic_model;
+	/*
+	 * Preserve the vgic model for GICv3 emulation, but only what pKVM can
+	 * run: the GICv5 world switch touches registers UNDEFINED at EL2
+	 * without FEAT_GCIE. 0 is not a valid kvm_device_type: "no vgic".
+	 */
+	switch (vgic_model) {
+	case KVM_DEV_TYPE_ARM_VGIC_V2:
+	case KVM_DEV_TYPE_ARM_VGIC_V3:
+		break;
+	default:
+		vgic_model = 0;
+	}
+	hyp_vm->kvm.arch.vgic.vgic_model = vgic_model;
 
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
-- 
2.39.5

