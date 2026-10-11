Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011124570D8
	for <kvmarm@lists.linux.dev>; Sun, 11 Oct 2026 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791729421; cv=none; b=Zj/Ofx84aT3N6wjsK5kBBSNNYT6dICGAXhWoquKvn9eygxjmYweZTqSJyp/dCVL/9D7pZzaBa7Jymrv2CwpkeCqyI7jzVJuJ79+/lIX0R8aqJmhsTTv7D/Njh4khUdZXye8ng6msBs9AQFgiw1npsT7XlGHOBsKnVB0FFRvIJfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791729421; c=relaxed/simple;
	bh=kI4k7LKRskEk7+Aou1508QIGGibzNJmNHk2adKMVvWo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tXv9DrMQJlbvctq5Tfd9simjIGoblLoDRqkWH4gaG3O0xRCrTDegnO+3fWLkX80m0XngxTIY5nRm3BX9p2NEljRNVDGjKCM6FqUrCC8tH4hx86tVtb4Jxr6THj+IBk0XWp0yNESfVd6+N/6jCvzNWcESXkCGKPI8gHJesvazdTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ov8XNhVR; arc=none smtp.client-ip=91.218.175.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ov8XNhVR"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=kI4k7LKRskEk7+Aou1508QIGGibzNJmNHk2adKMVvWo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791729414; v=1; x=1792334214;
 b=ov8XNhVRxvhpv5wQO/L/CJrPBS2+qvEuH99qe37jDJWRiQxOrtIiTvtwZWcl56ga0ztYJDuu
 QZiAzHfyzxGdCf/BKuVCTrT18caYD/GFX6dpNzKBTWtaWla8Nv6GGEeYIIgC5rECEbycpP1y7zT
 gPTTMMq6HUOitJhTW6NAQt5Y=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4bc7a2959fe86583;
	Sun, 11 Oct 2026 14:36:54 +0000
X-Mizu-Trace-ID: 4bc7a2959fe86583
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
Subject: [PATCH v2 3/5] KVM: arm64: Validate the host-provided vgic model in pKVM
Date: Sun, 11 Oct 2026 15:36:46 +0100
Message-Id: <20261011143648.211337-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261011143648.211337-1-fuad.tabba@linux.dev>
References: <20261011143648.211337-1-fuad.tabba@linux.dev>
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

Accept only GICv3, the one model pKVM supports, and force anything else
to 0, as for a VM with no in-kernel irqchip. EL2 reads the model only to
pick the GICv5 world switch and to emulate GICv3 CPU interface accesses,
and the host's own copy is left alone.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 459bd9eb7e4bc..a9d0e94709199 100644
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
+	 * pKVM runs only GICv3. Anything else becomes 0, the model of a VM
+	 * with no in-kernel irqchip, which keeps EL2 off the GICv5 registers.
+	 */
+	if (vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		vgic_model = 0;
+	hyp_vm->kvm.arch.vgic.vgic_model = vgic_model;
 
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
-- 
2.39.5

