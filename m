Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6744BA1CA;
	Thu, 24 Sep 2026 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265989; cv=none; b=qZaKZQpNGIlS7gvfmtRHC3MzQrv10UadPCNq9EYcFcvsTCFvu1VhOivgLLCei9o02CQdm5yZB9FNvADEmr/IEaz5Q5321auU/dQldS3dGWuqMnGtTuGjpsLvcCwZLRhKhRp1BgPLLif5KU9+l1mMZ6JYMzEI7SPsTBnffONfrMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265989; c=relaxed/simple;
	bh=p+zcxg7BECsR89IwYH5uWpbzH4ouiCsroF6MFra80bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbZ1TFvOr6OluqE1hmN+3Ssxt648sPO1FAo8XGA+JHVZ4iNfEWDhctLG9rPU0gqxoYb+QqNrd0QjtXcPX2CoBGxBCZff963LMbyY65Ch1qqKCLznrGNw87mxpm46hUvCCRh15zuhkQ1KMUBDFyHNREISLIdYkGqL3f0LxiRlwK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JlgDOHtG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JlgDOHtG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 868011E8D;
	Thu, 24 Sep 2026 09:06:23 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C8CDB3F86C;
	Thu, 24 Sep 2026 09:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790265987; bh=p+zcxg7BECsR89IwYH5uWpbzH4ouiCsroF6MFra80bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlgDOHtGK5OW9l4IiNRluCiZPy2X9nhDgQdxRJ8KAdYTzJLRgF5nKtkOZcg6uy1wM
	 +dqjqhMhNb2RFXTjwH+ZhqvEZQacUUpjLYkBDuzYNRhwXclEi0Df59hBlowtj//9I0
	 e8ekQNgKHRo+YTzD+I/9kRcNwjQkoHXjbPHQPrQ4=
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
Subject: [PATCH v20 15/22] KVM: arm64: CCA: Add VCPU load/put for Realms
Date: Thu, 24 Sep 2026 17:04:57 +0100
Message-ID: <20260924160504.853911-16-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924160504.853911-1-suzuki.poulose@arm.com>
References: <20260924160504.853911-1-suzuki.poulose@arm.com>
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

