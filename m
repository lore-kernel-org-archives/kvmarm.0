Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E6E4AEE0
	for <kvmarm@lists.linux.dev>; Thu, 20 Jun 2024 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718866744; cv=none; b=UyqVn4jQ15Jqj3ji/6yboHHEjyCEW7VVMq1Sok7MT6H80LvdNieWdMGj7nPrl9wk/SupF8i3Av5rSNNDU3CGgcOn0VJGIqelImkB5feZS3NVx7SVhAtvnv0SxAx2taZEill2qyTYOYrSeT7FMFsyuY9d94JzkgZCNWLnIZ1JwuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718866744; c=relaxed/simple;
	bh=8EpJb52t53rNdx7QuGDxDh+upklfkbthTHecW7nbrbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ptjhvzo+i+R9TckEbeeczpfi3H7VGewpxFVPlOnbIv9/JzZHmBjp73ww7X+1maT9b3uEgOSkszQEdOuL0oVxSP6rCW8Y3oGxh5e37jFROr/pgSzTzoaNW+RqNJCyBF56a8rirB/vOQxCl7y6dthkBGzQUCPOmZzXZGSKAssbCjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8A2ADA7;
	Wed, 19 Jun 2024 23:59:26 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.46.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 64DBD3F73B;
	Wed, 19 Jun 2024 23:58:58 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	maz@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 09/10] KVM: arm64: nv: Enable HDFGRTR2_EL2 & HDFGWTR2_EL2 access from virtual EL2
Date: Thu, 20 Jun 2024 12:28:06 +0530
Message-Id: <20240620065807.151540-10-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240620065807.151540-1-anshuman.khandual@arm.com>
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds VNCR-capable HDFGRTR2_EL2 and HDFGWTR2_EL2 registers into enum
vcpu_sysreg and also enables their access from virtual EL2 environment.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/kvm_host.h     | 3 +++
 arch/arm64/include/asm/vncr_mapping.h | 2 ++
 arch/arm64/kvm/sys_regs.c             | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 36b8e97bf49e..7b44e96e7270 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -488,6 +488,9 @@ enum vcpu_sysreg {
 	VNCR(HDFGWTR_EL2),
 	VNCR(HAFGRTR_EL2),
 
+	VNCR(HDFGRTR2_EL2),
+	VNCR(HDFGWTR2_EL2),
+
 	VNCR(CNTVOFF_EL2),
 	VNCR(CNTV_CVAL_EL0),
 	VNCR(CNTV_CTL_EL0),
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index df2c47c55972..de9288bc2b84 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -38,6 +38,8 @@
 #define VNCR_HFGRTR_EL2		0x1B8
 #define VNCR_HFGWTR_EL2		0x1C0
 #define VNCR_HFGITR_EL2		0x1C8
+#define VNCR_HDFGRTR2_EL2	0x1A0
+#define VNCR_HDFGWTR2_EL2	0x1B0
 #define VNCR_HDFGRTR_EL2	0x1D0
 #define VNCR_HDFGWTR_EL2	0x1D8
 #define VNCR_ZCR_EL1            0x1E0
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..f921af014d0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2697,6 +2697,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
 	{ SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
+	EL2_REG_VNCR(HDFGRTR2_EL2, reset_val, 0),
+	EL2_REG_VNCR(HDFGWTR2_EL2, reset_val, 0),
 	EL2_REG_VNCR(HDFGRTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HDFGWTR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HAFGRTR_EL2, reset_val, 0),
-- 
2.25.1

