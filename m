Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB82130A42;
	Fri, 12 Apr 2024 08:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911483; cv=none; b=uGTP80r5HW2UGyoKZIuzYkVWOUnly7AB22LTsHq+t+Rv2ZyB1kWi90ILY6A6beq41BNFVHE/zVmhEuFQJ/p9CI2lwUB4/WZCc2une8BYwbH+58J0DYct4+0d/4PVwejGxgD8j89cF3uVMHX7fVIDVmHxIMv0XYBDNlR6kEn8WlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911483; c=relaxed/simple;
	bh=6RO1mE0SljN5zB2ChRtne2Phm80D1UoEgDPQQrnkBvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IUTSHCxyBuX7B9h+wzwr8wiINrcnHy54MdeJejY9jOfnmJEMJkfXcHkqV0VD9aF8d8quktvGW3gKv6YZiw7P+o2uFmsJbkL6NEexJmWolA0kcgtKlIvoptNhK0Z8yFGKriGnb6T5LGs94Hp0GZi4/EozDWIRqpfSvyLReuyNYn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35CA214BF;
	Fri, 12 Apr 2024 01:45:10 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B34643F6C4;
	Fri, 12 Apr 2024 01:44:38 -0700 (PDT)
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
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 35/43] arm64: RME: Propagate number of breakpoints and watchpoints to userspace
Date: Fri, 12 Apr 2024 09:43:01 +0100
Message-Id: <20240412084309.1733783-36-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

The RMM describes the maximum number of BPs/WPs available to the guest
in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
which is visible to userspace. A VMM needs this information in order to
set up realm parameters.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_rme.h |  1 +
 arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        |  2 +-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 62d1fa82ac92..44aa95befc14 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -88,6 +88,7 @@ struct realm_rec {
 
 int kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
+u64 kvm_realm_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val);
 
 bool kvm_rme_supports_sve(void);
 
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index e60a1196a2fe..4edc8d98e1e6 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -271,6 +271,28 @@ u32 kvm_realm_ipa_limit(void)
 	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
 }
 
+u64 kvm_realm_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
+{
+	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
+	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
+	u32 ctx_cmps;
+
+	if (!kvm_is_realm(vcpu->kvm))
+		return val;
+
+	/* Ensure CTX_CMPs is still valid */
+	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val) + 1;
+	ctx_cmps = min(bps, ctx_cmps);
+
+	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
+		 ID_AA64DFR0_EL1_CTX_CMPs);
+	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps - 1) |
+	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps - 1) |
+	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps - 1);
+
+	return val;
+}
+
 static int get_start_level(struct realm *realm)
 {
 	return 4 - stage2_pgtable_levels(realm->ia_bits);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 60452c6519a4..cb3dc640a4a5 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1708,7 +1708,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	/* Hide SPE from guests */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
 
-	return val;
+	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
 }
 
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
-- 
2.34.1

