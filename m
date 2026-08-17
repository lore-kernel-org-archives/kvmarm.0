Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D893AC0E4
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 10:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786962761; cv=none; b=tTD0/hwEN2Csb7cenFaWn5h5Jrs0y3Zzi7VO+W8pEkC8G1u74jXW/Syw6GSaFkzLvuBbyyG32V28cB9uEOoTbKiAfOYVbeC9b9apGZClTtAzsNKpH0FJquVWdw2FIZR8On1PkTfAIhguViYKyj2zt1ywkZLzwQFzd3opIvgKKVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786962761; c=relaxed/simple;
	bh=iOgWnCEhDGyg56J6gm4nwCS3dgCjFHT30oB0fu9Wrzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lvee8MmeSeChjnrGhPpOLUJGygItwwDjHqM1J5FGQ6N6cYMhWbbG7tUBjyIjRnXPl2kYpttn21lAlfvV0wN6LSR/etG2HL/M+icbrM5kSzHSCUek6K2iZoIHmndbyNqHEqMVEsal+Usp+aTcnECfOms5JXMZa7j6YyMdZP/YkvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P0hIBph8; arc=none smtp.client-ip=91.218.175.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P0hIBph8"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=iOgWnCEhDGyg56J6gm4nwCS3dgCjFHT30oB0fu9Wrzc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786962757; v=1; x=1787567557;
 b=P0hIBph8QvyowagfkE397x6s/R4i/4IuIugcN9foyvrA00O1OFkjuz4YdnxnxKIfCbprQoRt
 R/5jYwS5xKPhlUZqQLz/ARWELJPusR9nnaLI/3nZS7kyq7Onui07FfZUVOe+1K9RVj3KpWX4TmE
 AgZNq6Sx4+cqmLlka2c7Opv4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from claudy.lan (37.156.72.212)
	by smtp.migadu.com with ESMTPS id 0a54397236c5e6e6;
	Mon, 17 Aug 2026 10:32:37 +0000
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v2 1/4] KVM: arm64: Validate the host-provided vgic model in pKVM
Date: Mon, 17 Aug 2026 11:32:25 +0100
Message-Id: <20260817103228.1203140-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260817103228.1203140-1-fuad.tabba@linux.dev>
References: <20260817103228.1203140-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 copies vgic_model from the host's struct kvm unchecked, and the nVHE
world switch dispatches on it with no cpucap guard. A host writing
KVM_DEV_TYPE_ARM_VGIC_V5 makes EL2 access GICv5 CPU interface registers,
which are UNDEFINED without FEAT_GCIE and panic the hypervisor on any
GICv3 machine.

Accept only GICv3, the one model pKVM supports, forcing anything else
to 0.

Fixes: 9b8e3d4ca0e73 ("KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 24d6f164129ac..f41b92c50ad7d 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -340,13 +340,20 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
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
+	 * touches registers UNDEFINED at EL2 without FEAT_GCIE. 0 is not a
+	 * valid kvm_device_type: "no vgic".
+	 */
+	if (vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		vgic_model = 0;
+	hyp_vm->kvm.arch.vgic.vgic_model = vgic_model;
 
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
-- 
2.39.5

