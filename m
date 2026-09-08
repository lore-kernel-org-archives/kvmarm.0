Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8736A582BAD;
	Tue,  8 Sep 2026 16:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788884618; cv=none; b=ggRvmUTU01exhB4mZEHAGE0jKJ6fDaDzK3YUfJKLuJdLBhqpz4q2X7lIOJQo5d1h5twfr4Bj3c31y0xEzZZ8F0ytPFauCq6998eQnzoiyv7LpYKLgGBsfmDAt0HvM4yezcfrNaHyEpB0f0VIK6Qy8d44Vp+TxR45AyD+gtG+WdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788884618; c=relaxed/simple;
	bh=rcvFiEHuSI+iYZssP4YUoc0XZJr7UrWElOyPy2d1u6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOvLpHO1o+zcurSYQZhgm1FSTV8Ot5IuTavAWfDZ7ER88m3pRNpNWTpLwbhUbuiOns1stdu6m9qTKPB3DxAN1kP86nMMevNdXJ/iSpuyLdiaI2jkzhw8C8aL61TbJMJR6UfV5nLQp2CQmchKBsyFTw3b+vgKCE6+lUMa+ui/PMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WMDCslfU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WMDCslfU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1FA6A1C01;
	Tue,  8 Sep 2026 09:23:32 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C4D23F7B4;
	Tue,  8 Sep 2026 09:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788884615; bh=rcvFiEHuSI+iYZssP4YUoc0XZJr7UrWElOyPy2d1u6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMDCslfUN1dre+HAmE9X1Q55Ii1XoTfcKIVPrHjrgsDViNunXcJ4JIobAh6hKTNAJ
	 ZGIcMsTnSSv9IWkenAEfgbsztp3S0KUdK6wB59Vh4pTkb7qGjsYDIfK46kUEG+/jLb
	 GByUP/siteS2s9n4sz1vR7apwihT9vs85j+0VOpI=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v17 13/20] KVM: arm64: CCA: Add VCPU load/put for Realms
Date: Tue,  8 Sep 2026 17:22:16 +0100
Message-ID: <20260908162223.1683432-14-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908162223.1683432-1-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM controls the VCPU settings and most are hidden from the KVM, except for the
VGIC and timer bits.

A later patch would add syncing the VCPU state into the Realm REC related SMC
parameters.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/arm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b5e0893ea16f1..3dfe0e03fab7a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -807,6 +807,13 @@ static void pkvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		     &vcpu->arch.vgic_cpu.vgic_v3);
 }
 
+static void realm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
+	vcpu_set_wfx_traps(vcpu);
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->cpu = cpu;
@@ -853,6 +860,12 @@ static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
 	nvhe_vcpu_put(vcpu);
 }
 
+static void realm_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	kvm_timer_vcpu_put(vcpu);
+	kvm_vgic_put(vcpu);
+}
+
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.vcpu_ops->vcpu_put(vcpu);
@@ -2210,11 +2223,17 @@ static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
 	.vcpu_put = pkvm_vcpu_put,
 };
 
+static const struct kvm_vcpu_ops realm_vcpu_ops = {
+	.vcpu_load = realm_vcpu_load,
+	.vcpu_put = realm_vcpu_put,
+};
+
 static const struct kvm_vcpu_ops *arm64_vcpu_ops[] = {
 	[VM_VHE] = &vhe_vcpu_ops,
 	[VM_NVHE] = &nvhe_vcpu_ops,
 	[VM_PKVM] = &pkvm_vcpu_ops,
 	[VM_PROTECTED_PKVM] = &pkvm_vcpu_ops,
+	[VM_REALM] = &realm_vcpu_ops,
 };
 
 static unsigned long nvhe_percpu_size(void)
-- 
2.43.0

