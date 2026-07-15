Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D20653A6B6D;
	Wed, 15 Jul 2026 14:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125826; cv=none; b=t5Ax3mg6wqrELF/Z5EhCb7oP13pJUOcVu6s0Tb4DQC+3TpSzo3PTvEHRX0Qzx85LB63wd9cMN3ne4T2JIpBIYR6yNU6JWoE9b375V4kc614gDgItIGzYutqkQvvH5TOKmyctFLXbrKfMoZg3Cna57vitupSRV3MUMkm3D5/1iQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125826; c=relaxed/simple;
	bh=G9XH5zZJ1GvOceYjyx4dHra6hejDLcr12uK8ZZtBmz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXoPBGIAC3V1uzlVFU1W7lxXhsrKRUqgl5SypF7+9WHD3qJGhjhss4cui6fuxADDdgNfO0EtWWGtYn7e3Bc6+3R5jZd3Q84mHx9fsNaixflL05outRr+RA+9JOeVh6B8db5XYidrVO4b+yM2bNmf9g6zssS7IPf3BWZwaFfJLSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KBg9JTgU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KBg9JTgU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C61F153B;
	Wed, 15 Jul 2026 07:30:18 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 525E53F7B4;
	Wed, 15 Jul 2026 07:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125822; bh=G9XH5zZJ1GvOceYjyx4dHra6hejDLcr12uK8ZZtBmz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBg9JTgU9fq3MMswbBA9g1KIVx8UAsBZXG3Da+XM514kButrHc9Mx6E2a4c5z5z+A
	 rBNnaCvHaFaOr+uvlsbY6CjBuBWIN1GED/CC39xzJriQzrvyc/NkXSJObSyYxu/Pw5
	 ntFryhi6rw/H3wmmWIN9fgU20dqVxINIAfo9u6dc=
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
Subject: [PATCH v15 18/37] KVM: arm64: CCA: Create the realm descriptor
Date: Wed, 15 Jul 2026 15:28:20 +0100
Message-ID: <20260715142841.80544-19-steven.price@arm.com>
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

Creating a realm involves first creating a realm descriptor (RD). This
involves passing the configuration information to the RMM. Do this as
part of realm_ensure_created() so that the realm is created when it is
first needed. The call to realm_ensure_created() will be added in a
later patch.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v14:
 * Explicitly set hash_algo = RMI_HASH_SHA_256 (which is the default).
 * Support SRO flow during realm creation.
Changes since v13:
 * The RMM no longer uses AUX granules, so no need to ask it how many it
   needs.
 * Adapted to other changes.
Changes since v12:
 * Since RMM page size is now equal to the host's page size various
   calculations are simplified.
 * Switch to using range based APIs to delegate/undelegate.
 * VMID handling is now handled entirely by the RMM.
---
 arch/arm64/kvm/rmi.c | 91 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 1ef676eed172..94776a9262c9 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -449,6 +449,79 @@ static void realm_unmap_shared_range(struct kvm *kvm,
 			     start, end);
 }
 
+static int realm_create_rd(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_params *params = realm->params;
+	void *rd = NULL;
+	phys_addr_t rd_phys, params_phys, top_delegated;
+	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+	int r;
+
+	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+
+	if (WARN_ON(realm->rd || !realm->params))
+		return -EEXIST;
+
+	rd = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!rd)
+		return -ENOMEM;
+
+	rd_phys = virt_to_phys(rd);
+	if (rmi_delegate_page(rd_phys)) {
+		r = -ENXIO;
+		goto free_rd;
+	}
+
+	if (rmi_delegate_range(kvm->arch.mmu.pgd_phys, pgd_size,
+			       &top_delegated)) {
+		r = -ENXIO;
+		goto out_undelegate_tables;
+	}
+
+	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+	params->rtt_level_start = get_start_level(realm);
+	params->rtt_num_start = pgd_size / PAGE_SIZE;
+	params->rtt_base = kvm->arch.mmu.pgd_phys;
+	params->hash_algo = RMI_HASH_SHA_256;
+
+	if (kvm->arch.arm_pmu) {
+		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
+		params->flags0 |= RMI_REALM_PARAM_FLAG_PMU;
+	}
+
+	if (kvm_lpa2_is_enabled())
+		params->flags0 |= RMI_REALM_PARAM_FLAG_LPA2;
+
+	params_phys = virt_to_phys(params);
+
+	if (rmi_realm_create(rd_phys, params_phys, realm->sro)) {
+		r = -ENXIO;
+		goto out_undelegate_tables;
+	}
+
+	realm->rd = rd;
+	kvm_set_realm_state(kvm, REALM_STATE_NEW);
+	/* The realm is up, free the parameters.  */
+	free_page((unsigned long)realm->params);
+	realm->params = NULL;
+
+	return 0;
+
+out_undelegate_tables:
+	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys, top_delegated - kvm->arch.mmu.pgd_phys))) {
+		/* Leak the pages if they cannot be returned */
+		kvm->arch.mmu.pgt = NULL;
+	}
+	if (WARN_ON(rmi_undelegate_page(rd_phys))) {
+		/* Leak the page if it isn't returned */
+		return r;
+	}
+free_rd:
+	free_page((unsigned long)rd);
+	return r;
+}
+
 static void realm_unmap_private_range(struct kvm *kvm,
 				      unsigned long start,
 				      unsigned long end,
@@ -614,6 +687,24 @@ static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int __maybe_unused realm_ensure_created(struct kvm *kvm)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	switch (kvm_realm_state(kvm)) {
+	case REALM_STATE_NONE:
+		break;
+	case REALM_STATE_NEW:
+		return 0;
+	case REALM_STATE_DEAD:
+		return -ENXIO;
+	default:
+		return -EBUSY;
+	}
+
+	return realm_create_rd(kvm);
+}
+
 static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-- 
2.43.0

