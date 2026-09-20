Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C9147D94B;
	Sun, 20 Sep 2026 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789939787; cv=none; b=Pdt57DESeWQvWetTnpblZ12kDd7pW2xy9+GB4FGcFrvw4PLXZTjJqbnwhycqdMMiz/QhQS1Dm2rTwi7Jefe/T+YV28tdg+3DdAjDcHTgBvoZUg5JY7c220opYenwO/t9BMkvsPa/9X7GGE2fk/PKLw7vGe5APX6dzNCe5jZdw8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789939787; c=relaxed/simple;
	bh=ymvQEWhOJNVQirHRvg6HllaAitO224xcJg1CwhaFBwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvhlwvvTg9KFT2bh5u+pTzKDVW/8jzxiQfi2/e8XbFTjGzfeJfDnZqzLf4N1yhYlHasmBxqsjYoIdt163Sgjna+l+DRnTwFw//o6ZD1WP8Vl0Qi/LXwiIPF7JduIw0CaHxyFf+GK5jiPPbE7PqA7GmCnlot7NQlukt+nsa6z3WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F84obCSG; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F84obCSG"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0512A15A1;
	Sun, 20 Sep 2026 14:29:39 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BE5EF3F632;
	Sun, 20 Sep 2026 14:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789939782; bh=ymvQEWhOJNVQirHRvg6HllaAitO224xcJg1CwhaFBwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F84obCSGVXzmoK4mwODa8e9A/ek4xg/nEZmtRZs/p2ZiGpCgFNFTCmoSrjpNf36y8
	 kQZht/8M5Qs4jDnEHi3nHeNAjH6JqA5rXYeNqHjvvFyl0seYZDwH1Q3pRZt9gIv+eG
	 XaAnTZuAz19EcD77C0Q++euAvT3d7L/rA0HPY2Q8=
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
Subject: [PATCH v19 13/20] KVM: arm64: CCA: Add VCPU load/put for Realms
Date: Sun, 20 Sep 2026 22:28:38 +0100
Message-ID: <20260920212845.707-14-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920212845.707-1-suzuki.poulose@arm.com>
References: <20260920212845.707-1-suzuki.poulose@arm.com>
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
index 0e2ab5311e4d8..bcc274df2a915 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -795,6 +795,13 @@ static void pkvm_vcpu_load(struct kvm_vcpu *vcpu)
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
@@ -845,6 +852,12 @@ static void pkvm_vcpu_put(struct kvm_vcpu *vcpu)
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
@@ -2202,6 +2215,11 @@ static const struct kvm_vcpu_ops pkvm_vcpu_ops = {
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

