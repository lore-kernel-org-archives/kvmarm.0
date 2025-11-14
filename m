Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D3E315D2F
	for <kvmarm@lists.linux.dev>; Fri, 14 Nov 2025 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136509; cv=none; b=D9/0+kTfT7MWIwHSZHJtRptG8RrmrtCX0BodI5vvlg7A+Aca9NqDw0VNXP2y0qFzpupj/lNNz6IKD+o+pj78a9au6BX3L/XeytX0KdnNz3IsNtUk+LsvRJaQihOv1hNeoN6oaCQkHnVVd8aq+6mP2zFN6o+GAy0rCv+C+QZevic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136509; c=relaxed/simple;
	bh=oTc3vxGx28FYUpuuCm9rDBTnLM60mFWKRXZoZ9k8XZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoPF5WjMZWAkMbLTK5albO1a3BWJ8gCtWnr1tmDH9tRuRnVPkzSUz1ifH0CoMXDBBky32anL6HmvjOv/64XD/+DYosGJHiEGB1EQsiOXQdTX6hj9AUARcNHHDQiIRykMm4vDlLbcSVe8U/mcjxi79LUx7ULQJFp1TJ2/bhUnyCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0CA119F6;
	Fri, 14 Nov 2025 08:08:19 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 546493F5A1;
	Fri, 14 Nov 2025 08:08:25 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: james.clark@linaro.org,
	mark.rutland@arm.com,
	james.morse@arm.com
Subject: [RFC PATCH v6 21/35] KVM: arm64: Check for unsupported CPU early in kvm_arch_vcpu_load()
Date: Fri, 14 Nov 2025 16:07:02 +0000
Message-ID: <20251114160717.163230-22-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251114160717.163230-1-alexandru.elisei@arm.com>
References: <20251114160717.163230-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When support for SPE is added, KVM will have to touch SPE hardware
registers on VCPU load and put. Move the check for unsupported CPU at the
start of kvm_arch_vcpu_load(), so KVM doesn't try to access SPE registers
on a CPU which doesn't have FEAT_SPE.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/kvm/arm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 783e331fb57a..f5c846c16cb8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -586,6 +586,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
+	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
+		vcpu_set_on_unsupported_cpu(vcpu);
+
 	if (is_protected_kvm_enabled())
 		goto nommu;
 
@@ -656,9 +659,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
 			     &vcpu->arch.vgic_cpu.vgic_v3);
 	}
-
-	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
-		vcpu_set_on_unsupported_cpu(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-- 
2.51.2

