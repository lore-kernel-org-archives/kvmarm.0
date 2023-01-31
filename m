Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D259F81A
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 09:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA5FC4339C;
	Tue, 31 Jan 2023 09:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675158186;
	bh=ia+7lU7uvByBUeiEEpZKtYPX0L15wbvLID+PpsSZeJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGw8YvKfADeIFZt5hZ5RUYvftQu2xkhQiJgxCguzfo3/631Md02ftCvLxfKmXZdyf
	 8V6CXNiZzN7LVDgOjmb09RGFb9awX9dkIH6gbTDark+HeVM1vHAva7Cz8FEPp/tQW7
	 T12HBD2fcbvNfTMYabZQyoy5D/Eqcb52x8T9TOJRDHqpB+TjKwX1N1/AWn4vNvmE8P
	 HekJkeTUnmdAWVJUxBge/bSnkEHJEtljbd9LPBuiMpAiC4pPsOncrbOymafRhQlCU3
	 dOiDXwuZS3Ujs8ovQ1N2x3/yPTlG7l10qAChSGevrnp5jTp1t9a8OsYlfxtiQFz4Jb
	 FlxvqQcYDT6zA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pMmtv-0067U2-LQ;
	Tue, 31 Jan 2023 09:26:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 61/69] KVM: arm64: Add FEAT_NV2 cpu feature
Date: Tue, 31 Jan 2023 09:24:56 +0000
Message-Id: <20230131092504.2880505-62-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the detection code for the FEAT_NV2 feature.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  6 ++++++
 arch/arm64/kernel/cpufeature.c      | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5dd6b12b6ec0..86e89ace1746 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -14,6 +14,12 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
+static inline bool vcpu_has_nv2(const struct kvm_vcpu *vcpu)
+{
+	return cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
+		vcpu_has_nv(vcpu);
+}
+
 /* Translation helpers from non-VHE EL2 to EL1 */
 static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3fc14ee86239..49e632aa1756 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2240,6 +2240,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_width = 4,
 		.min_field_value = ID_AA64MMFR2_EL1_NV_IMP,
 	},
+	{
+		.desc = "Enhanced Nested Virtualization Support",
+		.capability = ARM64_HAS_ENHANCED_NESTED_VIRT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_nested_virt_support,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_EL1_NV_SHIFT,
+		.field_width = 4,
+		.min_field_value = ID_AA64MMFR2_EL1_NV_NV2,
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
-- 
2.34.1

