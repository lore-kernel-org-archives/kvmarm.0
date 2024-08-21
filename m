Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6917C1B2EE4;
	Wed, 21 Aug 2024 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254876; cv=none; b=cYoZYFXzmts/Q0Q96uNoOXGP7e2sbvHdL9wjH+Y3kDSkHz6sEqQTZdDuM+xsiJBzvWeTQeQTUA1uV+TgRdv685JB4nsf+g2ZeF9u5ZqQAWuO58+JReobQwXUOo+KE/QQsi53IsQogAM1MrAx5GvF4lmkALEr3B8K8OcKXKUADxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254876; c=relaxed/simple;
	bh=Vy/CuVsxUzywdbtvCDGGyFEyH7W0+FrD9wMB914LNx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aP5H5aFtA/jQafpyUfAy1A5OngNy3SZblTnFh1nUvfXdDg0AiMT68Gke/K9AS4ZXtIB3wdyXZYCPMRecLS1o2IFx0sFCuFIhzDIMFZ83m/+i2KvTs/qf0cMqFJ3WrOQ4cArnF1sFcGC2be1ex/sJIiqJdpun6qsQhL12DRWlv5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EC5DDA7;
	Wed, 21 Aug 2024 08:41:41 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.37.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABE003F73B;
	Wed, 21 Aug 2024 08:41:11 -0700 (PDT)
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
	Steven Price <steven.price@arm.com>
Subject: [PATCH v4 35/43] arm64: RME: Propagate number of breakpoints and watchpoints to userspace
Date: Wed, 21 Aug 2024 16:38:36 +0100
Message-Id: <20240821153844.60084-36-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821153844.60084-1-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
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
index 80c7db964079..8aa02134c461 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -88,6 +88,7 @@ struct realm_rec {
 
 void kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
+u64 kvm_realm_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val);
 
 bool kvm_rme_supports_sve(void);
 
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 93757c550394..5d9f732f4df2 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -286,6 +286,28 @@ u32 kvm_realm_ipa_limit(void)
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
+	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
+	ctx_cmps = min(bps, ctx_cmps);
+
+	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
+		 ID_AA64DFR0_EL1_CTX_CMPs);
+	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
+	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
+	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
+
+	return val;
+}
+
 static int realm_create_rd(struct kvm *kvm)
 {
 	struct realm *realm = &kvm->arch.realm;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 39a1ea231a09..c7a5b1a8a224 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1732,7 +1732,7 @@ static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	/* Hide SPE from guests */
 	val &= ~ID_AA64DFR0_EL1_PMSVer_MASK;
 
-	return val;
+	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
 }
 
 static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
-- 
2.34.1

