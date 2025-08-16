Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D042F83BF
	for <kvmarm@lists.linux.dev>; Sat, 16 Aug 2025 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755357581; cv=none; b=D9aO2P0fvu93fq+7IuhYspf8i8fB21n7lZcFb7a+5ji2YVOU1i2qNHtTqyfm9OYH0lAqqIitJwcMC/MVCkK4BAYzAj3F575/UO9/LgmBJzr1Eliq+lZtE0JcjDU5XZ5bYAai9oAZYUL7eEq4O0poA6f2+1j/+mMr2yZ7mg3z5Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755357581; c=relaxed/simple;
	bh=fK6BIl0bRf8TDA36YUrZnKnjDme5iDAORJ48zBkuJE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kU2ACKRz7SfluWbEirYkrPk1uU3WCshk6UUXEZ2CMqHXY35/X6CpbdZXiDGha5uE9JFiEUyqmVuYdQgOqGQLrA0FH1N42+2cy9RXDp01TRROrCVRCK3JoJ3VSuEmGy3o+n+P1ET9Gy73hFTbj3zGBnKB4Afm7N/iw/90qVFrM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 518931D13;
	Sat, 16 Aug 2025 08:19:31 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 426123F5A1;
	Sat, 16 Aug 2025 08:19:37 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	broonie@kernel.org,
	maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	james.morse@arm.com,
	ardb@kernel.org,
	scott@os.amperecomputing.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH RESEND v7 2/6] KVM: arm64: expose FEAT_LSUI to guest
Date: Sat, 16 Aug 2025 16:19:25 +0100
Message-Id: <20250816151929.197589-3-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250816151929.197589-1-yeoreum.yun@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

expose FEAT_LSUI to guest.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82ffb3b3b3cf..fb6c154aa37d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1642,7 +1642,8 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
 		break;
 	case SYS_ID_AA64ISAR3_EL1:
-		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_FAMINMAX;
+		val &= ID_AA64ISAR3_EL1_FPRCVT | ID_AA64ISAR3_EL1_FAMINMAX |
+		       ID_AA64ISAR3_EL1_LSUI;
 		break;
 	case SYS_ID_AA64MMFR2_EL1:
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
@@ -2991,7 +2992,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 					ID_AA64ISAR2_EL1_APA3 |
 					ID_AA64ISAR2_EL1_GPA3)),
 	ID_WRITABLE(ID_AA64ISAR3_EL1, (ID_AA64ISAR3_EL1_FPRCVT |
-				       ID_AA64ISAR3_EL1_FAMINMAX)),
+				       ID_AA64ISAR3_EL1_FAMINMAX | ID_AA64ISAR3_EL1_LSUI)),
 	ID_UNALLOCATED(6,4),
 	ID_UNALLOCATED(6,5),
 	ID_UNALLOCATED(6,6),
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

