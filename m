Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1943358C4;
	Wed, 13 May 2026 13:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678454; cv=none; b=ElwDBy1SW93rabREGJX2ZLhkL208yADBr7s9C35X7GlNPKHCb0aSQ3MBwBU7GefEEATDTU/ZoeHSszyqVZGfCUAGz21gi/XQxMN6XB72j/1feqZLrSPtQZI2qSY25+qQLSmnnUc5XKS9CC1dqzpSj1oXCtjYk3jMK18WeFZqlPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678454; c=relaxed/simple;
	bh=FH/lIvcnlPAmxth30YsCSY7W015MGY2e5M4QLYMBxXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euhGvXK0EHrQxF21Q7fBDirJp8tY26CEE+qCGF3Hwh+UtnL7SD1IUyugl7aNULD3BsweqmB0+HB/aiJaKdrSHG3EvjWbTYaZcV+mI6AnOWZ/TJr/ahldM9zLHuemNXvtrhCDa/0+Gy6lF4iFfh/U3Xfn6NgLy5KwhFWawMsPdjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CNWZAhbJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CNWZAhbJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA7F6302F;
	Wed, 13 May 2026 06:20:46 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3EC743F836;
	Wed, 13 May 2026 06:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678451; bh=FH/lIvcnlPAmxth30YsCSY7W015MGY2e5M4QLYMBxXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNWZAhbJSxNoTQtayTQYYKeHMh4SKOtlErlmsrALC0GiBzCET4UnVEDUSS9f/7pan
	 +WD7zyvIoukmikrXvlXUZM20/GmGH92gehueJ37tz0RKNG3hjVlACQRl/cfLXBQjgi
	 p098GIAwE/o2xHjNEpmKWof8xQZak6TMJWQfo584=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 28/44] arm64: RMI: Create the realm descriptor
Date: Wed, 13 May 2026 14:17:36 +0100
Message-ID: <20260513131757.116630-29-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
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
first needed.

Signed-off-by: Steven Price <steven.price@arm.com>
---
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
 arch/arm64/kvm/rmi.c | 88 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index fb96bcaa73ed..cae29fd3353c 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -418,6 +418,77 @@ static void realm_unmap_shared_range(struct kvm *kvm,
 			     start, end);
 }
 
+static int realm_create_rd(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+	struct realm_params *params = realm->params;
+	void *rd = NULL;
+	phys_addr_t rd_phys, params_phys;
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
+	if (rmi_delegate_range(kvm->arch.mmu.pgd_phys, pgd_size)) {
+		r = -ENXIO;
+		goto out_undelegate_tables;
+	}
+
+	params->s2sz = VTCR_EL2_IPA(kvm->arch.mmu.vtcr);
+	params->rtt_level_start = get_start_level(realm);
+	params->rtt_num_start = pgd_size / PAGE_SIZE;
+	params->rtt_base = kvm->arch.mmu.pgd_phys;
+
+	if (kvm->arch.arm_pmu) {
+		params->pmu_num_ctrs = kvm->arch.nr_pmu_counters;
+		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
+	}
+
+	if (kvm_lpa2_is_enabled())
+		params->flags |= RMI_REALM_PARAM_FLAG_LPA2;
+
+	params_phys = virt_to_phys(params);
+
+	if (rmi_realm_create(rd_phys, params_phys)) {
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
+	if (WARN_ON(rmi_undelegate_range(kvm->arch.mmu.pgd_phys, pgd_size))) {
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
@@ -647,8 +718,21 @@ static int realm_init_ipa_state(struct kvm *kvm,
 
 static int realm_ensure_created(struct kvm *kvm)
 {
-	/* Provided in later patch */
-	return -ENXIO;
+	int ret;
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
+	ret = realm_create_rd(kvm);
+	return ret;
 }
 
 static int set_ripas_of_protected_regions(struct kvm *kvm)
-- 
2.43.0

