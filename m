Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA4147F2C6;
	Wed, 15 Jul 2026 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125848; cv=none; b=Az7ZWW/lzmIymBYzMESkQ+r01GSxSxTkVF0uLQnJ97bQAL9RGSp/7KmdnSWtAyAZXFzDRHTDY5wlPe0SG6M3LmrA2f5NXSi3M3kA8qqAyuByFgdMQ8Ge3Vh+LeHtzxCz+GCmfzblIrxA9Z/3lardihqMFJKrxaTSl65KXsMabXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125848; c=relaxed/simple;
	bh=JZym60zbrF+ZMsN57R7TWSgm37sQOomsgrW5gOlLZu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itPYFaTj7W5W8iS+kdsMYIRYjHVYNMGnE7EpOVJiuuDObWt9VsuZQm+dRiGTPZFfXRKjLxfGBSdtSsOSAeDe05I495fw1SD8AmTICslGSOlotz6UD5JkJuQqntKgAuM5rHbl+fLlZ0gADZcZs87USMHRLH8WvMrQnqB7gZQ4ugo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bbwb03nN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bbwb03nN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 454C41595;
	Wed, 15 Jul 2026 07:30:42 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 940823F93E;
	Wed, 15 Jul 2026 07:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125846; bh=JZym60zbrF+ZMsN57R7TWSgm37sQOomsgrW5gOlLZu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbwb03nNFjXUcW1IZnu9G+dlaX2iZxpyhQQRpzBDed6sVsVmuaR5pE/RC10v8ctD9
	 KOwdpvlhO/sQDdbjWIRdt4Q09o8SruJXDM5sJih9ItRBD+CS84/MDWL0AT0F1WEMlz
	 ZkZgHQkUXGDN5hhjiNL2llvOYV+5qeVg2T92bODU=
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
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v15 23/37] KVM: arm64: CCA: Handle realm vCPU load
Date: Wed, 15 Jul 2026 15:28:25 +0100
Message-ID: <20260715142841.80544-24-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142841.80544-1-steven.price@arm.com>
References: <20260715142841.80544-1-steven.price@arm.com>
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
index 1558bb12b1b1..4ad9462e9d47 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -707,7 +707,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
-	if (is_protected_kvm_enabled())
+	if (is_protected_kvm_enabled() || kvm_is_realm(vcpu->kvm))
 		goto nommu;
 
 	if (vcpu_has_nv(vcpu))
@@ -751,12 +751,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
@@ -778,6 +772,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
 
-- 
2.43.0

