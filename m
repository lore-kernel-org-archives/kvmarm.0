Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A3D27FD76
	for <kvmarm@lists.linux.dev>; Mon, 24 Nov 2025 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010923; cv=none; b=p6I43D668tgF5DNAxwP3z3Mpy43SkZh3lgHrI3Z0OumrpnMAXI9c24C8ZAc5Yp/CzdN9nAlX3V2dZhZYvTNVp6R/+glC7Mpp7G7pnwJHDj4mZ/NSp3TiDbaWwrP2HEze4hgBGLkHEOpBdJ+SnXMPJ/O9zZV4kjTDCygv1AReKz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010923; c=relaxed/simple;
	bh=Ne1nWoAtvGja0yTRw6Jt+6foMsIzRmryzzpbl9RZQ50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5SpkPhW59dcU3lgelUITkupAduKfcqSPXXcC4TJk9pqcK2ghRobJ+1yLlb2d7fD2+bkiNHJXBACt+YEB3dki4SqW1lZJ5l0+yyTlI3mMhvLxf5E8v8fNEReUEXKlqYuaN4pOmcHARehL6yTKuZFJhEt/I05zr+uImuFfk9q1m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReJcIq4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReJcIq4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DCFC19421;
	Mon, 24 Nov 2025 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764010922;
	bh=Ne1nWoAtvGja0yTRw6Jt+6foMsIzRmryzzpbl9RZQ50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReJcIq4xhkcoBd7T5xr48VUYx2e6VSCfLXSkDlpLTHEB9jG/aPEm7Fxs3r2ezIGbQ
	 O4+IPHAEfrIFbZpJfiYKwI+/wK5N93lyTzsy4sdHGSEZO5C8t9bdeBhQd4WGNNNp+k
	 xb/rB4r76P+aGMxpUZWm9teHZtmknnvKQzPTSv4ZG9I0SeKLkwPNKyOqR5NUkgmjRe
	 iPllvZGAz62OkfJT33jqnbmTwGPpRvdHwhU/nyuh58jOP2fsbixhn2HlKy1gbtBb9X
	 iV75lkOHpwGQBP+pLK1Mn5HtdfZZyEWOuchJoEmDTgiR9IU5esbAMfPMm9PlVrHYX2
	 7pMiiZHdFMk7g==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v3 14/15] KVM: arm64: nv: Expose hardware access flag management to NV guests
Date: Mon, 24 Nov 2025 11:01:56 -0800
Message-ID: <20251124190158.177318-15-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124190158.177318-1-oupton@kernel.org>
References: <20251124190158.177318-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything is in place to update the access flag at S1 and S2. Expose
support for the access flag flavor of FEAT_HAFDBS to NV guests.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6495442f400a..88d7dfb44410 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1599,11 +1599,13 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 	case SYS_ID_AA64MMFR1_EL1:
 		val &= ~(ID_AA64MMFR1_EL1_CMOW		|
 			 ID_AA64MMFR1_EL1_nTLBPA	|
-			 ID_AA64MMFR1_EL1_ETS		|
-			 ID_AA64MMFR1_EL1_HAFDBS);
+			 ID_AA64MMFR1_EL1_ETS);
+
 		/* FEAT_E2H0 implies no VHE */
 		if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features))
 			val &= ~ID_AA64MMFR1_EL1_VH;
+
+		val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR1_EL1, HAFDBS, AF);
 		break;
 
 	case SYS_ID_AA64MMFR2_EL1:
-- 
2.47.3

