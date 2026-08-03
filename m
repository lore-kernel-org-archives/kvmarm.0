Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C69E41D225;
	Mon,  3 Aug 2026 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764837; cv=none; b=EyMgLhA+dpEkWHoJ6Mkt+Vo8N2tysmcVVBcYqWA5sjrJZC/IF+Eps/nJFQpbYwje9DRQvHWOT4dYSdjmCGkmStpyBes6/65pF1Bm5ls662yNGxsnElaa8tNA4bkYhuVKCyHKr1dgtMHVLHMS7Dm2owKqC7GS5OfeQKxSYd3fkmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764837; c=relaxed/simple;
	bh=9dDPYOK56JspwvgV/TEJkMLfs8tJYVd/42IM7MAl10c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCP/9mMeIkPG+RvUIn6uhauGmiCm5VyvTHr2HduTxmeFo8ZiLsI5AA7YgdAxpv72K5OpwkSdq3nYJ8p54qjJpUEIHEOY9TT1BJVLTDhL1m5ZeRt9CMgOY7VQKpzWPpaVNnsu2ImiNK9yWlc37ju3W4dMFlM4wHC9+F5t/Bd30DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I0icL62Y; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I0icL62Y"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1093D1476;
	Mon,  3 Aug 2026 06:47:12 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D46D3F66F;
	Mon,  3 Aug 2026 06:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764836; bh=9dDPYOK56JspwvgV/TEJkMLfs8tJYVd/42IM7MAl10c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0icL62YVCEWoYnpV0o0Dj3sRfoLSWq7PhtCgYUM2wbZOCRcPMkTEr+EgW5oDRWdM
	 7VV6oN95D4tvpPttnHaQojMt53FikPOUSAJ9QGL1p/ilu8Kqn10Y24inqXzQHMyUHT
	 qll0PeG43i7MwR/sIKhlOAEulFt/kd31HI+dyrX4=
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
Subject: [PATCH v16 38/45] KVM: arm64: CCA: Propagate breakpoint and watchpoint counts to userspace
Date: Mon,  3 Aug 2026 14:43:54 +0100
Message-ID: <20260803134403.80630-39-steven.price@arm.com>
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

The RMM describes the maximum number of BPs/WPs available to the guest
in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
which is visible to userspace. A VMM needs this information in order to
set up realm parameters.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/include/asm/kvm_rmi.h |  2 ++
 arch/arm64/kvm/rmi.c             | 19 +++++++++++++++++++
 arch/arm64/kvm/sys_regs.c        |  3 +++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 13933f0e555d..7d27c17276bf 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -98,6 +98,8 @@ struct realm_rec {
 void kvm_init_rmi(void);
 u32 kvm_rmm_ipa_limit(void);
 
+u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
+
 bool kvm_rmi_supports_sve(void);
 
 int kvm_init_realm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 0d46768022df..de893308148e 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -36,6 +36,25 @@ u32 kvm_rmm_ipa_limit(void)
 	return u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_S2SZ);
 }
 
+u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	u32 bps = u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_NUM_BPS);
+	u32 wps = u64_get_bits(rmi_feat_reg(0), RMI_FEATURE_REGISTER_0_NUM_WPS);
+	u32 ctx_cmps;
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
 static int get_start_level(struct realm *realm)
 {
 	return 4 - stage2_pgtable_levels(realm->ia_bits);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5d5c579d4579..e0fe9f2562bc 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2142,6 +2142,9 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 	/* Hide BRBE from guests */
 	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
 
+	if (vcpu_is_rec(vcpu))
+		return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
+
 	return val;
 }
 
-- 
2.43.0

