Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.95
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621196;
	b=4yJ3bpezb6GbBU2QtUHr7t+80QJkP/O1/jns/mW39p6JVRV9VhjfQC6QN2DiTU/Z/9sN
	 mPuH07KPkE91rWj3SS6oQfp2wV6ehEXS25VCfhSlpNxQ32K0hNhCb1YFwrfb5VZldw/wY
	 D675K4DnTNco4LXHFXOPRmYavawqGT5WUDt4Dp9OTfvr3nOdCed9Y2U6lNPIgHC1lU2sq
	 UgkB1FY0kzMJLJdySu8Licrpb/7xRUFgD1biQTZcD4hbDVG+9vOzrMzY4sv2X78clxPLF
	 XPadRStqU6CnIxvxmr3bXgCJjdVc9U1Z1W9IpssgYZiWZeABOSL/WjS4w+Yu7oRfTmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621196;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=AHWtWicFYQTSZ+pv8ha5Ysqf1whC+s2crZfNfys75SU=;
	b=BNoEy5f3XycltK6AX6eSoOKM9ZrEU3yFrQ4IRIHI/hASCH1vPbRJMo2sU6kVcfZfLTcL
	 laTV6hvvsAeDslal4XYuVpWp+WKit+JCuwFxO0U7QHCa6Hzoq+RqCkBUg6VuckD/45hKX
	 ZS30VOnf4f/GiOpQzgrFP6l3JOFcwOLF2vSp5ObSazql0htswHiFC0qJ2hyc7oYHfKgM7
	 T+irOjN/TAyMP6JJLaUBl8VHLcOKq0U1fLrxuWJ5ihJgpPoo5OTnTh1EudtNgQRJ5a2lb
	 dd4Kf/Lz20Qsa/Ra/u5JOlaoX5wy1vfufOpGePgzZNnCzJK8mtdCoCDgTa4EobJqOLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dJqgTga1;
	arc=none smtp.remote-ip=95.215.58.95
Received: from mta1.migadu.com (out-95.mta1.migadu.com [95.215.58.95])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F082D606A321
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:39:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F082D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dJqgTga1
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VasWsmKzmIjzdgB+tnchbPGMfZU/P7HS7PhkSGjv9OQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621194; v=1; x=1796225994;
 b=dJqgTga1laKHG54NBY5wrr/2hR+KkHBoD/2xyXgNW7/q5J+4z+/8Awe+FDHaVOizfiAOKZIz
 2vjha9q2GgktwA8kYH7kwprbjmRHSmSoLT2EmbZdZ3s6l+CLVbT8wuG03a8AqpJiu4A1LDoGJjO
 57zADTO0lXdDRqmYyrLWSAHA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cc9b23bc0178ea10;
	Wed, 25 Nov 2026 15:39:53 +0000
X-Mizu-Trace-ID: cc9b23bc0178ea10
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
Subject: [PATCH v2 08/20] KVM: arm64: Move the VM's FGU initialisation into config.c
Date: Wed, 25 Nov 2026 15:38:59 +0000
Message-ID: <20261125153911.106793-9-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
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
index c7d91138a6d49..2cbbae81c07c4 100644
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

