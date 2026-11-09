Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.183
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213149;
	b=rxgiQLyW/qHzOIcQuTQAbmZ7jDWfvgPchxRoLdGZlZbA1MOv+LIeFQdVRKxgMTqjc1I6
	 aMNInnCIF5kvBvRjvi5L2DZIWjdsFte5fdAP30Gu2jzT/wbO9vnkWyTdygWQEikZwFfIw
	 50qjivJKKg6pUrCcdCHHz3Hrzf2Aaq9qYpRhE+NvyzdasuDhUJ31ny4aj7Zzz28TmF9M0
	 rgeSFfKt9FkKn1aYkXC7z21wvN1rTxouSkmpHpEPTe7RYXfvnpkQTbIXJB+TCMN92/qy4
	 FhjA1BNmg3s51p356L9qrPMFg3d/DWY7PJS/0bb9PpepeTcixIPh6QjqVqI+1RyeiOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213149;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KXB74kWypKloRCmPJ/b9p8r0COb/RsH73q72omYlB+k=;
	b=unE6J1E1PzQgJ/AMSVhd6Ne4BxPgT/LpO78HJ5bG45/ZA7ev4G6WX0VAA1OSwtCpOFNi
	 MROPfvKKH7KuAnoXuTiXY+0scVCzWQY0E++igRLgYsBB7EDkzRoRRWC7Bx6aH+Ut6dU9d
	 VgO3YMnPcYqP+duZqRELmnKZy+zXV9W/5+/9K9T9ld5j6uGq/Ev/Tsgsf2/cCbZBV4D/+
	 DR813GOstBNfE2ad6WWw55K9mE46YUvTTJ2flEU/H6cdXvgFsWDKgfs+tP2UIPux2QYxO
	 lQuBBDSYcim4U6mTXi7vCGaX/f7N22BZGLTCeXeGG/wnZAUGb+XZourVTswRkUmVKVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="u/Fw5LRw";
	arc=none smtp.remote-ip=95.215.58.183
Received: from mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B14606A332
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96B14606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=u/Fw5LRw
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=S+ysH1BuivVAwHxEv/xXCvirxD/LdCy9y543PHafoYk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213146; v=1; x=1794817946;
 b=u/Fw5LRwcgD34YO7ZcAg1rHO7sakGirZL2RNGi3oP7cO3Rp3EDK+Yp4SjTKm7G7W82Rh/L0W
 4gD/KlW/uvKRoEQyKdGZS4uxK+gdrB49Wvn31+4dyOn4/vQRjdB4N2Z+foGyxlND0pubD8G0rbK
 etM6ADRJ5T09y/4DsHwEFDXM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4d70107428964b21;
	Mon, 09 Nov 2026 08:32:26 +0000
X-Mizu-Trace-ID: 4d70107428964b21
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] KVM: arm64: Move the VM's FGU initialisation into config.c
Date: Mon,  9 Nov 2026 08:31:55 +0000
Message-ID: <20261109083205.806619-7-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109083205.806619-1-fuad.tabba@linux.dev>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first time one of a VM's vCPUs runs, kvm_calculate_traps() computes
the VM's fine-grained UNDEF masks from its ID registers, one
compute_fgu() call per FGT group, and sets KVM_ARCH_FLAG_FGU_INITIALIZED
so that it computes them once. The next patch computes the same masks
for protected VMs at EL2.

Move the calls and the flag into kvm_init_fgu() in config.c, so that a
group added later is computed at EL2 too. compute_fgu() then has no
caller outside config.c, so make it static.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/config.c           | 20 +++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c         | 17 +----------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb1300..82ba4bb9573f1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1748,7 +1748,7 @@ static inline bool kvm_arch_has_irq_bypass(void)
 }
 
 void kvm_idregs_enforce_dependencies(struct kvm *kvm);
-void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
+void kvm_init_fgu(struct kvm *kvm);
 struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg);
 void check_feature_map(void);
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index adaf26ab93b85..c65cf1dd27330 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1586,7 +1586,7 @@ static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
 	return resx.res0 | resx.res1;
 }
 
-void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
+static void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 {
 	u64 val = 0;
 
@@ -1630,6 +1630,24 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 	kvm->arch.fgu[fgt] = val;
 }
 
+void kvm_init_fgu(struct kvm *kvm)
+{
+	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
+		return;
+
+	compute_fgu(kvm, HFGRTR_GROUP);
+	compute_fgu(kvm, HFGITR_GROUP);
+	compute_fgu(kvm, HDFGRTR_GROUP);
+	compute_fgu(kvm, HAFGRTR_GROUP);
+	compute_fgu(kvm, HFGRTR2_GROUP);
+	compute_fgu(kvm, HFGITR2_GROUP);
+	compute_fgu(kvm, HDFGRTR2_GROUP);
+	compute_fgu(kvm, ICH_HFGRTR_GROUP);
+	compute_fgu(kvm, ICH_HFGITR_GROUP);
+
+	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
+}
+
 struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 {
 	struct resx resx;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 850eba167aad6..bcec0a7d2b2f5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5841,22 +5841,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	vcpu_set_hcr(vcpu);
 	vcpu_set_ich_hcr(vcpu);
 	vcpu_set_hcrx(vcpu);
-
-	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
-		goto out;
-
-	compute_fgu(kvm, HFGRTR_GROUP);
-	compute_fgu(kvm, HFGITR_GROUP);
-	compute_fgu(kvm, HDFGRTR_GROUP);
-	compute_fgu(kvm, HAFGRTR_GROUP);
-	compute_fgu(kvm, HFGRTR2_GROUP);
-	compute_fgu(kvm, HFGITR2_GROUP);
-	compute_fgu(kvm, HDFGRTR2_GROUP);
-	compute_fgu(kvm, ICH_HFGRTR_GROUP);
-	compute_fgu(kvm, ICH_HFGITR_GROUP);
-
-	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
-out:
+	kvm_init_fgu(kvm);
 	mutex_unlock(&kvm->arch.config_lock);
 }
 
-- 
2.47.3

