Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C0D43B488;
	Mon,  3 Aug 2026 13:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764853; cv=none; b=iw7WvD3IphGysWdMvAOr6P5jOjnYhfv0r+VO3KhTXuspQwxnB7DDe0nptuwBzFx7Rt4Cu/BghT7J+YDFTXsGdRZmKcxzawbYkh14n0RU/PRAn+9fRDgBSYsNRP7CC+++WGt1r5MenjGWGo8cCixGSayKLZovVrDkNvkoFty+NaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764853; c=relaxed/simple;
	bh=QbXqYIX01Dxf57p9QrsPRpSm8WGko41S0UwAnL78VD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdghistj4PE47qfKdoATJzrB20oOjFYIs9Yt4I6l8HfniVUG8VKEg3q0N1bCCd21SRI5C3R2raAm3GeS+ytJ7oxrtSWVzwN143o0FtwdR+imt8bKI9uwNEZQvvVkWbwnxYcqwr5+7sTwfunmw/4/J2QgVkL6jfaufB5Q/HPbIAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qqOZ1lUn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qqOZ1lUn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0566165C;
	Mon,  3 Aug 2026 06:47:27 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CFF663F66F;
	Mon,  3 Aug 2026 06:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764851; bh=QbXqYIX01Dxf57p9QrsPRpSm8WGko41S0UwAnL78VD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqOZ1lUn+6MK9Ys8IBGQjQ++t3wZu7QB6Sf4KJ9fhMBHZThChHEOEqymmPSBX5py9
	 JVpMxkFSfLpVEdVhFJNqrYyMqiW6pjyKBlOtptob2bNVjmVPqAOteFIoMi6Ayxnu7d
	 201D44sgbfzPJxgfcomiabDQuPlPralDcF/xBkZg=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v16 41/45] KVM: arm64: CCA: Configure max SVE vector length for a Realm
Date: Mon,  3 Aug 2026 14:43:57 +0100
Message-ID: <20260803134403.80630-42-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Obtain the max vector length configured by userspace on the vCPUs, and
write it into the Realm parameters. By default the vCPU is configured
with the max vector length reported by RMM, and userspace can reduce it
with a write to KVM_REG_ARM64_SVE_VLS.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v6:
 * Rename max_vl/realm_max_vl to vl/last_vl - there is nothing "maximum"
   about them, we're just checking that all realms have the same vector
   length
---
 arch/arm64/kvm/guest.c |  3 ++-
 arch/arm64/kvm/rmi.c   | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index f48fc0d5a249..452cf5d3152e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -361,7 +361,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
 
-	if (kvm_arm_vcpu_sve_finalized(vcpu))
+	if (kvm_arm_vcpu_sve_finalized(vcpu) || kvm_realm_is_created(vcpu->kvm))
 		return -EPERM; /* too late! */
 
 	if (WARN_ON(vcpu->arch.sve_state))
@@ -754,6 +754,7 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
 	} else {
 		switch (reg->id) {
 		case KVM_REG_ARM_ID_AA64DFR0_EL1:
+		case KVM_REG_ARM64_SVE_VLS:
 			return true;
 		}
 	}
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index cf043db05720..0f66a0e970cd 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -504,6 +504,39 @@ static void realm_unmap_shared_range(struct kvm *kvm,
 			     start, end);
 }
 
+static int realm_init_sve_param(struct kvm *kvm, struct realm_params *params)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+	int vl, last_vl = -1;
+
+	if (!kvm_has_sve(kvm))
+		return 0;
+
+	/*
+	 * Get the preferred SVE configuration, set by userspace with the
+	 * KVM_ARM_VCPU_SVE feature and KVM_REG_ARM64_SVE_VLS pseudo-register.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_arm_vcpu_sve_finalized(vcpu))
+			return -EINVAL;
+
+		vl = vcpu->arch.sve_max_vl;
+
+		/* We need all vCPUs to have the same SVE config */
+		if (last_vl >= 0 && last_vl != vl)
+			return -EINVAL;
+
+		last_vl = vl;
+	}
+
+	if (last_vl > 0) {
+		params->sve_vl = sve_vq_from_vl(last_vl) - 1;
+		params->flags0 |= RMI_REALM_PARAM_FLAG_SVE;
+	}
+	return 0;
+}
+
 static int realm_create_rd(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
@@ -556,6 +589,10 @@ static int realm_create_rd(struct kvm *kvm)
 	if (kvm_lpa2_is_enabled())
 		params->flags0 |= RMI_REALM_PARAM_FLAG_LPA2;
 
+	r = realm_init_sve_param(kvm, params);
+	if (r)
+		goto out_undelegate_tables;
+
 	params_phys = virt_to_phys(params);
 
 	rmi_ret = rmi_realm_create(rd_phys, params_phys, realm->sro);
-- 
2.43.0

