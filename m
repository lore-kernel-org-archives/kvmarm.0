Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2436453D9E6;
	Thu,  1 Oct 2026 21:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790888898; cv=none; b=eYVXCpRlRS35wq6+Y6FrZDHelmnI0ddkyDjcpxMoDFtv0pgOIDfDmPoliYhEmU12zBOefZu0U6ny3OnPO5GpTetFJzNsQFdnhc0kRi4sigw6qs5TEe0PMwgVbjKbkpJXQh8OeUivjabhonM8VbOvHu5jWpitzsbpa7FPWVRfMMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790888898; c=relaxed/simple;
	bh=p+zcxg7BECsR89IwYH5uWpbzH4ouiCsroF6MFra80bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0ykbY8RxTp6WmhPsfsdeVQroLR3XPX/fM3vXzvnUpeSfMjUZ6FWMEs38B83bl+sGOQK6GVmSlZKkcP8ksVfERYYz4+yNv5kBeFVrs6qJtI7dUxpp2WxVwM7KjfJO1pJvavqwfLb6HjQtvFKpJSwzCczjF+n4Ja24LYO9xq+dkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ljudYv2O; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ljudYv2O"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 139821476;
	Thu,  1 Oct 2026 14:08:13 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1CE943F86F;
	Thu,  1 Oct 2026 14:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790888896; bh=p+zcxg7BECsR89IwYH5uWpbzH4ouiCsroF6MFra80bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljudYv2O+d9WFowhQOpSnrEkj9JxfgGTUeAPHmD6frk3qiRft2zy0dsr6z/d6SIfW
	 2ShRlTfZKa1IN3/1rxRd7BVQIS53yQzz/FbXdFLb2cRigCZAgXeroi1aQZX/+behuH
	 vuabQTWZpPoFNatOKgSPs1taNoM0lr4nZLVWLDc8=
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
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v21 15/23] KVM: arm64: CCA: Add VCPU load/put for Realms
Date: Thu,  1 Oct 2026 22:06:55 +0100
Message-ID: <20261001210703.1597150-16-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001210703.1597150-1-suzuki.poulose@arm.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RMM controls the VCPU settings and most are hidden from the KVM, except
for the VGIC and timer bits.

A later patch would add syncing the VCPU state into the Realm REC related
SMC parameters.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/arm.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3ab722f2af7c8..8b1beddd80ea5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -802,6 +802,13 @@ static void pkvm_vcpu_load(struct kvm_vcpu *vcpu)
 			  &vcpu->arch.vgic_cpu.vgic_v3);
 }
 
+static void realm_vcpu_load(struct kvm_vcpu *vcpu)
+{
+	kvm_timer_vcpu_load(vcpu);
+	kvm_vgic_load(vcpu);
+	vcpu_set_wfx_traps(vcpu);
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->cpu = cpu;
@@ -854,6 +861,12 @@ static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_restore_host(vcpu);
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
@@ -2211,6 +2224,11 @@ static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
 	.vcpu_put = pkvm_vcpu_put,
 };
 
+static const struct kvm_vcpu_ops realm_vcpu_ops = {
+	.vcpu_load = realm_vcpu_load,
+	.vcpu_put = realm_vcpu_put,
+};
+
 #define KVM_VCPU_OPS(flavor, ops)		\
 	[(flavor)] = (ops)
 
-- 
2.43.0

