Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF802402454;
	Wed, 18 Mar 2026 15:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849373; cv=none; b=FylOH8x+nuiQoJOpUf61BGW35sktqcfY8tygATDPEhrZSVJ+9pzxeKZIfUXnFClS5VN2CNnJAlrItay6tXeSO2XmXA1HoQQjkbenT/bf0ZUSDXMfcmxcow+VB98arFWj/LBucsSLASKcIla4MRUZVtqf0pGFDbanbGsC1IgRWzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849373; c=relaxed/simple;
	bh=LvE59dYAB7ldJ9ghvlqdp63ExZZto5wY7ImuBSv+V4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxJwxW+g0Yl+5ogxb9qFvQZOO12mdidzTuRsTlSKQsMllEgLN/5A6EixZz2t06Y+iRqGUErY3Xsu9zgQ1XXp1wLTTGmdRgNGuzJq8irn3WPcVblviLXzsyoqtwKKibxt4Np14Uc88fhRlR5+oe8w/mDNoSWMKjsx7UcLOIK9Y8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 598062050;
	Wed, 18 Mar 2026 08:56:01 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CFFD3F73B;
	Wed, 18 Mar 2026 08:56:04 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v13 28/48] KVM: arm64: Handle realm VCPU load
Date: Wed, 18 Mar 2026 15:53:52 +0000
Message-ID: <20260318155413.793430-29-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
References: <20260318155413.793430-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When loading a realm VCPU much of the work is handled by the RMM so only
some of the actions are required. Rearrange kvm_arch_vcpu_load()
slightly so we can bail out early for a realm guest.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 43d05da7e694..304fb1f2b3ff 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -688,7 +688,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
-	if (is_protected_kvm_enabled())
+	if (is_protected_kvm_enabled() || kvm_is_realm(vcpu->kvm))
 		goto nommu;
 
 	if (vcpu_has_nv(vcpu))
@@ -732,12 +732,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_vgic_load(vcpu);
 	kvm_vcpu_load_debug(vcpu);
 	kvm_vcpu_load_fgt(vcpu);
-	if (has_vhe())
-		kvm_vcpu_load_vhe(vcpu);
-	kvm_arch_vcpu_load_fp(vcpu);
-	kvm_vcpu_pmu_restore_guest(vcpu);
-	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
-		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
 	if (kvm_vcpu_should_clear_twe(vcpu))
 		vcpu->arch.hcr_el2 &= ~HCR_TWE;
@@ -759,6 +753,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 			     &vcpu->arch.vgic_cpu.vgic_v3);
 	}
 
+	/* No additional state needs to be loaded on Realmed VMs */
+	if (vcpu_is_rec(vcpu))
+		return;
+
+	if (has_vhe())
+		kvm_vcpu_load_vhe(vcpu);
+	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_pmu_restore_guest(vcpu);
+	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
+		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
+
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
 		vcpu_set_on_unsupported_cpu(vcpu);
 }
-- 
2.43.0

