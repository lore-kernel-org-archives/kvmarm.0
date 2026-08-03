Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851EC41D624;
	Mon,  3 Aug 2026 13:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764843; cv=none; b=Zjph0jG4zPqE0/8Wnb7qyL2Zz9ftFwI9Fp6K7uJr7uoMxEmMx3taWxsWL85WkyFr9RL7feugTe4vVHc7aBQiatLP1YOtJQFU5llkYnjxMUWN5VcVj7WYhqXpqzmX49XybcD9wkGQbCMa++pp2xfdW67K3sQfzWynT1pfM0BMGE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764843; c=relaxed/simple;
	bh=9GDpZgOYe45/M0EdsvXuzkys8UNvJZkiOkdd7cYeySA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L98/oiIJoPBrEOyFqNKZRCMRU7uiOgBgO8q4KSbfBHDXcaMX/9ExcFWyBJiPxavejR5IQUsyn8pKU5kUiWWTjVSnJEAMli40Q/UkZcvEVEVKBjZWxdGMjo3GUGU6HKbFhXkrH5LQM5Qi/nRhtU+EgVKq/5+EV4k8owgS6/sdkj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XAXMpK/d; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XAXMpK/d"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 123A51476;
	Mon,  3 Aug 2026 06:47:17 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C7123F66F;
	Mon,  3 Aug 2026 06:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764841; bh=9GDpZgOYe45/M0EdsvXuzkys8UNvJZkiOkdd7cYeySA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAXMpK/d97ZEIgFIHrUDtd7m2Qct79oQT26ZenfnneS44RgoOeCBw3jxwASyQm5YG
	 J1EHb9sAy+mqqRv0JZLvJP+euQT4QorG8fejp/MZ0k89yBqEuIoOkHR31Y9XbpDLYz
	 +e7CQBAFa+Hxb6DTXhsi6GQSy+NK06mWy6D6g0Rw=
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
Subject: [PATCH v16 39/45] KVM: arm64: CCA: Set breakpoint parameters through SET_ONE_REG
Date: Mon,  3 Aug 2026 14:43:55 +0100
Message-ID: <20260803134403.80630-40-steven.price@arm.com>
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

Allow userspace to configure the number of breakpoints and watchpoints
of a Realm VM through KVM_SET_ONE_REG ID_AA64DFR0_EL1.

The KVM sys_reg handler checks the user value against the maximum value
given by RMM (arm64_check_features() gets it from the
read_sanitised_id_aa64dfr0_el1() reset handler).

Userspace discovers that it can write these fields by issuing a
KVM_ARM_GET_REG_WRITABLE_MASKS ioctl.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/guest.c    |  7 +++++++
 arch/arm64/kvm/rmi.c      |  3 +++
 arch/arm64/kvm/sys_regs.c | 17 +++++++++++------
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5469c9a97fad..3ed563e85572 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -735,6 +735,8 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
 }
 
+#define KVM_REG_ARM_ID_AA64DFR0_EL1	ARM64_SYS_REG(3, 0, 0, 5, 0)
+
 /*
  * The RMI ABI only enables setting some GPRs and PC. The selection of GPRs
  * that are available depends on the Realm state and the reason for the last
@@ -749,6 +751,11 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
 		u64 off = core_reg_offset_from_id(reg->id);
 
 		return kvm_realm_validate_core_reg(off);
+	} else {
+		switch (reg->id) {
+		case KVM_REG_ARM_ID_AA64DFR0_EL1:
+			return true;
+		}
 	}
 
 	return false;
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index de893308148e..44ddee730863 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -505,6 +505,7 @@ static int realm_create_rd(struct kvm *kvm)
 	void *rd = NULL;
 	phys_addr_t rd_phys, params_phys, top_delegated;
 	size_t pgd_size = kvm_pgtable_stage2_pgd_size(kvm->arch.mmu.vtcr);
+	u64 dfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
 	long rmi_ret;
 	int r;
 
@@ -537,6 +538,8 @@ static int realm_create_rd(struct kvm *kvm)
 	params->rtt_level_start = get_start_level(realm);
 	params->rtt_num_start = pgd_size / PAGE_SIZE;
 	params->rtt_base = kvm->arch.mmu.pgd_phys;
+	params->num_bps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
+	params->num_wps = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
 	params->hash_algo = RMI_HASH_SHA_256;
 
 	if (kvm->arch.arm_pmu) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e0fe9f2562bc..e47be8f8d259 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2174,6 +2174,9 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 {
 	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
+	u8 bps = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, val);
+	u8 wps = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, val);
+	u8 ctx_cmps = SYS_FIELD_GET(ID_AA64DFR0_EL1, CTX_CMPs, val);
 
 	/*
 	 * Prior to commit 3d0dba5764b9 ("KVM: arm64: PMU: Move the
@@ -2193,10 +2196,11 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 
 	/*
-	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
-	 * nonzero minimum safe value.
+	 * ID_AA64DFR0_EL1.DebugVer, BRPs and WRPs all have to be greater than
+	 * zero. CTX_CMPs is never greater than BRPs.
 	 */
-	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
+	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP || !bps || !wps ||
+	    ctx_cmps > bps)
 		return -EINVAL;
 
 	if (ignore_feat_doublelock(vcpu, val)) {
@@ -2429,10 +2433,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	mutex_lock(&vcpu->kvm->arch.config_lock);
 
 	/*
-	 * Once the VM has started the ID registers are immutable. Reject any
-	 * write that does not match the final register value.
+	 * Once the VM has started or the Realm descriptor is created, the ID
+	 * registers are immutable. Reject any write that does not match the
+	 * final register value.
 	 */
-	if (kvm_vm_has_ran_once(vcpu->kvm)) {
+	if (kvm_vm_has_ran_once(vcpu->kvm) || kvm_realm_is_created(vcpu->kvm)) {
 		if (val != read_id_reg(vcpu, rd))
 			ret = -EBUSY;
 		else
-- 
2.43.0

