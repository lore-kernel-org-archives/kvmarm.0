Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2981A4AD4A8
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475942; cv=none; b=c3IOLjwD/RUkyYL95HDIRNiql0vx9N5SZ2NQY6ZN0iC/6JchhP4wMluW8lkmqjaFEd1qXe4EzpZOzR1G+HLZkWig6nADdgXSh00ktLnclcmbAUfgLscA5ZB0t4/WcH11baCwlMVfFNaE3g4uXz9EHr175wqF9C6/47UDC2ALfeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475942; c=relaxed/simple;
	bh=tRWMpaS2zOGMIhR9Ho3dwkRGEMdtnMmq18pcvS3WgPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ivgnb9W+Me8LlAU7LJNjsoh55O7Xubc0BTyXD5WLplIpqlCNCIqhb3Q8DG+G2HvnWVLMHtD7JWXkx1RMaZdjPim6YKr3mJcfYCcQvMqmEdLbnBTEzcrhh1uuLzrCE3tEUKgOOSX5cIq+sGwPaue6sXHPZj7LFi7IaXbUf9KQB6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oGT2/rTV; arc=none smtp.client-ip=91.218.175.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oGT2/rTV"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=tRWMpaS2zOGMIhR9Ho3dwkRGEMdtnMmq18pcvS3WgPs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475937; v=1; x=1790080737;
 b=oGT2/rTV1ZXXdvjHISk6X8hvyDgUNuQZQlzxdavVhJF4reWxcubYcPw02fXog9f+A1tL7XbQ
 27wGSgYVsxFk+kCbqMVfMuSKMwGdMBhZnY0ovcp/DtOeBUJNEJwZPa5vTZioYpRoByIYVkUTPj9
 FqM0ueysfvCwDJed7vNWipM4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9b55889483332976;
	Tue, 15 Sep 2026 12:38:57 +0000
X-Mizu-Trace-ID: 9b55889483332976
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Sascha.Bischoff@arm.com,
	steven.price@arm.com,
	tabba@google.com
Subject: [PATCH 3/7] KVM: arm64: Validate the host-provided vgic model in pKVM
Date: Tue, 15 Sep 2026 13:38:42 +0100
Message-Id: <20260915123846.2317931-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260915123846.2317931-1-fuad.tabba@linux.dev>
References: <20260915123846.2317931-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 copies vgic_model from the host's struct kvm unchecked, and the nVHE
world switch dispatches on it with no cpucap guard. A host writing
KVM_DEV_TYPE_ARM_VGIC_V5 makes EL2 access GICv5 CPU interface registers
that are UNDEFINED without FEAT_GCIE, and panics the hypervisor on any
GICv3 machine.

Accept only GICv3, the one model pKVM supports, forcing anything else
to 0.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..4c33c863e90e1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -340,13 +340,19 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
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
+	 * GICv3 is the only model pKVM runs, and the GICv5 world switch
+	 * touches registers UNDEFINED at EL2 without FEAT_GCIE.
+	 */
+	if (vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		vgic_model = 0;
+	hyp_vm->kvm.arch.vgic.vgic_model = vgic_model;
 
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
-- 
2.39.5

