Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481E2A29
	for <kvmarm@lists.linux.dev>; Sun, 25 May 2025 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748195908; cv=none; b=WzrHmFQHwfhSeieaQaunvKdTiD6LjveMNkL3axaFeK8DLl5WUFT7qLqhVmKNxq1eAbQHZwVVI4wHpSxMB+nYLpFqyUac7mBSUIseNquQohPGWo/Og79nreG8/kRnuD15zOOZPvARiFMrM9i2WYZk3Hq+vjhBqf0i7bwmBHv5mpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748195908; c=relaxed/simple;
	bh=c0DVjSp9QtchPMDhJIS/125dCk8iVBUSWQRTJ1mZiZE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TkwMNrWCCdDMmvF0aleC5NkSKOdGFv/inksKFBkgiJNAJbSiWzB2MZ4te45Vp9nXn9e9O2wQlwIJ0aM0IVjZWwlRe7Jtxy9M29x/OK5LVSNx1xLx2FaIUeC5hxW1z7AkKkhU9FkfYZJLsStvFxN+9CCjtEqgPWEM3CBWNbomNAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UY/+q0Ve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UY/+q0Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD01AC4CEEA;
	Sun, 25 May 2025 17:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748195907;
	bh=c0DVjSp9QtchPMDhJIS/125dCk8iVBUSWQRTJ1mZiZE=;
	h=From:To:Cc:Subject:Date:From;
	b=UY/+q0VeM/1QeG7MMfxF1aO/l0cMoxy7lUMeQCB1joiVOIOC2DfTQyCXQeE5PjCv6
	 CGoRghZmDgPyZPLNXyfXnWFRQM0J52gX2Sr+A2dbMpQ/pROxOkrSoj8tlJZcWUeL8t
	 s9mpoG9Epu5C5spe2Y0qtAR6yKIZczmbFzJua0Yzta4KmBGhEd/cYn2Coe07HVDBXt
	 a87lvRPAgkdC2zqKk1zQBxxZtI/CzLRQLnCAvLDoqq+JK3G8XFXlWVcW4n3yCMwpTx
	 /btEXqsAx8DPniPh/RlOI3VLaEJasBkdWcENi+2wiOhhYRgvalmLuf86gn87aPX47p
	 F+WNFXu+hbjuw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uJFc9-000QgR-AZ;
	Sun, 25 May 2025 18:58:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Mask out non-VA bits from TLBI VA* on VNCR invalidation
Date: Sun, 25 May 2025 18:57:59 +0100
Message-Id: <20250525175759.780891-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When handling a TLBI VA* instruction that potentially targets a
VNCR page mapping, we fail to mask out the top bits that contain
the ASID and TTL fields, hence potentially failing the VA check
in the TLB code.

An additional wrinkle is that we fail to sign extend the VA,
again leading to failed VA checks.

Fix both in one go by sign-extending the VA from bit 48, making
it comparable to the way we interpret VNCR_EL2.BADDR.

Fixes: 4ffa72ad8f37e ("KVM: arm64: nv: Add S1 TLB invalidation primitive for VNCR_EL2")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 291dbe38eb5cf..4a53e4147fb01 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -918,6 +918,8 @@ static void invalidate_vncr_va(struct kvm *kvm,
 	}
 }
 
+#define tlbi_va_s1_to_va(v)	(u64)sign_extend64((v) << 12, 48)
+
 static void compute_s1_tlbi_range(struct kvm_vcpu *vcpu, u32 inst, u64 val,
 				  struct s1e2_tlbi_scope *scope)
 {
@@ -964,7 +966,7 @@ static void compute_s1_tlbi_range(struct kvm_vcpu *vcpu, u32 inst, u64 val,
 		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
 		if (!scope->size)
 			scope->size = SZ_1G;
-		scope->va = (val << 12) & ~(scope->size - 1);
+		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
 		scope->asid = FIELD_GET(TLBIR_ASID_MASK, val);
 		break;
 	case OP_TLBI_ASIDE1:
@@ -992,7 +994,7 @@ static void compute_s1_tlbi_range(struct kvm_vcpu *vcpu, u32 inst, u64 val,
 		scope->size = ttl_to_size(FIELD_GET(TLBI_TTL_MASK, val));
 		if (!scope->size)
 			scope->size = SZ_1G;
-		scope->va = (val << 12) & ~(scope->size - 1);
+		scope->va = tlbi_va_s1_to_va(val) & ~(scope->size - 1);
 		break;
 	case OP_TLBI_RVAE2:
 	case OP_TLBI_RVAE2IS:
-- 
2.39.2

